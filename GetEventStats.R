# Find event statistics

# The data Mt, Mch and Madc must be loaded before running this function
# The analysis variable cluster.gap in ns must be set before running this function.

  # XY statistics

x.number.hits <- NULL
x.min.channel <- NULL
x.max.channel <- NULL
x.min.time <- NULL # ns
x.max.time <- NULL # ns
x.adc <- NULL
x.slope <- NULL
x.intercept <- NULL
x.R2 <- NULL
y.number.hits <- NULL
y.min.channel <- NULL
y.max.channel <- NULL
y.min.time <- NULL # ns
y.max.time <- NULL # ns
y.adc <- NULL
y.slope <- NULL
y.intercept <- NULL
y.R2 <- NULL
for ( i in 1:( number.of.clusters - 1 ) ) {
  # X stats
  this.stdcut <- Mt >= cluster.start.times[i] & Mt < cluster.start.times[i+1] & Mch < 64
  x.number.hits <- c( x.number.hits, length( Mch[this.stdcut] ) )
  if ( length( Mch[this.stdcut] ) > 0 ) {
    x.min.channel <- c( x.min.channel, min( Mch[this.stdcut] ) )
    x.max.channel <- c( x.max.channel, max( Mch[this.stdcut] ) )
    x.min.time <- c( x.min.time, min( Mt[this.stdcut] ) )
    x.max.time <- c( x.max.time, max( Mt[this.stdcut] ) )
    x.adc <- c( x.adc, sum( Madc[this.stdcut] ) )
    
    x <- Mch[this.stdcut] * wire.spacing
    z <- ( Mt[this.stdcut] - min( Mt[this.stdcut] ) ) * 1e-9 * drift.speed
    if ( length( x ) == 1 ) {
      x.intercept <- c( x.intercept, 1000000 )
      x.slope <- c( x.slope, 1 / 0.0 )
      x.R2 <- c( x.R2, 1.1 )
    } else {
      # Fit to first and last points
      this.delta.z <- ( max( z ) - min( z ) )
      this.max.x <- x[z == max( z )]
      if ( length( this.max.x ) > 1 ) this.max.x <- mean( this.max.x ) # in case two x have the same z at max
      this.min.x <- x[z == min( z )]
      if ( length( this.min.x ) > 1 ) this.min.x <- mean( this.min.x ) # in case two x have the same z at max
      this.delta.x <- this.max.x - this.min.x
      if ( this.delta.z > 0.0 ) {
        this.slope <- this.delta.z / this.delta.x
      } else {
        this.slope = 0.0
      }
      this.intercept <- -this.slope * this.min.x
      this.R2 <- 1.2
      
      # lsfit barfs when slope = 0, FIX
      if ( length( x ) > 3 & abs( this.slope ) > 0.0 & abs( this.slope ) <= 1.0 ) { # Use a least squares fitter for small slopes
        ls.fit <- lsfit( x, z, wt = Madc[this.stdcut] )
        this.slope <- as.double( ls.fit$coefficients[2] ) # change to better fit
        this.intercept <- as.double( ls.fit$coefficients[1] ) # change to better fit
        ls.summary <- ls.print( ls.fit, print.it = FALSE )
        this.R2 <- as.double( ls.summary$summary[2] ) # change to better fit
      }
      if ( length( x ) > 3 & abs( this.slope ) > 0.0 & abs( this.slope ) > 1.0 ) { # lsfit has trouble with high slope fits
        ls.fit <- lsfit( z, x, wt = Madc[this.stdcut] )
        this.slope <- as.double( 1 / ls.fit$coefficients[2] ) # change to better fit
        this.intercept <- as.double( -this.slope * ls.fit$coefficients[1] ) # change to better fit
        ls.summary <- ls.print( ls.fit, print.it = FALSE )
        this.R2 <- as.double( ls.summary$summary[2] ) # change to better fit
      }

      # lm barfs when slope = 0
     # if ( length( x ) > 3 & abs( this.slope ) <= 1.0 & abs( this.slope ) > 0.0 ) { # Use a least squares fitter for small slopes
     #   lm.fit <- lm( x ~ z )
     #   this.slope <- coef( lm.fit )[2] # change to better fit
     #   this.intercept <- coef( lm.fit )[1] # change to better fit
     #   lm.summary <- summary.lm( lm.fit )
     #   this.R2 <- as.double( lm.summary$adj.r.squared ) # change to better fit
     # }
     # if ( length( x ) > 3 & abs( this.slope ) > 1.0 & abs( this.slope ) > 0.0 ) { # lsfit has trouble with high slope fits
     #   lm.fit <- lsfit( z ~ x )
     #   this.slope <- 1 / coef( lm.fit )[2] # change to better fit
     #   this.intercept <- -this.slope * coef( lm.fit )[1] # change to better fit
     #   lm.summary <- summary.lm( lm.fit )
     #   this.R2 <- as.double( lm.summary$adj.r.squared ) # change to better fit
     # }
      
      x.intercept <- c( x.intercept, this.intercept ) # working
      x.slope <- c( x.slope, this.slope )
      x.R2 <- c( x.R2, this.R2 )
    }
  } else {
    x.min.channel <- c( x.min.channel, -1 )
    x.max.channel <- c( x.max.channel, 129 )
    x.min.time <- c( x.min.time, -1 )
    x.max.time <- c( x.max.time, -1 )
    x.adc <- c( x.adc, 0 )
    
    x.intercept <- c( x.intercept, -1000000.0 )
    x.slope <- c( x.slope, 0.0 )
    x.R2 <- c( x.R2, 0.0 )
  }
  
  # Y stats
  this.stdcut <- Mt >= cluster.start.times[i] & Mt < cluster.start.times[i+1] & Mch > 63
  y.number.hits <- c( y.number.hits, length( Mch[this.stdcut] ) )
  if ( length( Mch[this.stdcut] ) > 0 ) {
    y.min.channel <- c( y.min.channel, min( Mch[this.stdcut] ) )
    y.max.channel <- c( y.max.channel, max( Mch[this.stdcut] ) )
    y.min.time <- c( y.min.time, min( Mt[this.stdcut] ) )
    y.max.time <- c( y.max.time, max( Mt[this.stdcut] ) )
    y.adc <- c( y.adc, sum( Madc[this.stdcut] ) )
    
    y <- ( Mch[this.stdcut] - 64 ) * wire.spacing
    z <- ( Mt[this.stdcut] - min( Mt[this.stdcut] ) ) * 1e-9 * drift.speed
    if ( length( y ) == 1 ) {
      y.intercept <- c( y.intercept, 1000000 )
      y.slope <- c( y.slope, 1 / 0.0 )
      y.R2 <- c( y.R2, 1.1 )
    } else {
      # Fit to first and last points
      this.delta.z <- ( max( z ) - min( z ) )
      this.max.y <- y[z == max( z )]
      if ( length( this.max.y ) > 1 ) this.max.y <- mean( this.max.y ) # in case two x have the same z at max
      this.min.y <- y[z == min( z )]
      if ( length( this.min.y ) > 1 ) this.min.y <- mean( this.min.y ) # in case two x have the same z at max
      this.delta.y <- this.max.y - this.min.y
      if ( this.delta.z > 0.0 ) {
        this.slope <- this.delta.z / this.delta.y
      } else {
        this.slope = 0.0
      }
      this.intercept <- -this.slope * this.min.y
      this.R2 <- 1.2
      
      if ( length( y ) > 3 & abs( this.slope ) <= 1.0 ) { # Use a least squares fitter for small slopes
        ls.fit <- lsfit( y, z, wt = Madc[this.stdcut] )
        this.slope <- as.double( ls.fit$coefficients[2] ) # change to better fit
        this.intercept <- as.double( ls.fit$coefficients[1] ) # change to better fit
        ls.summary <- ls.print( ls.fit, print.it = FALSE )
        this.R2 <- as.double( ls.summary$summary[2] ) # change to better fit
      }
      if ( length( y ) > 3 & abs( this.slope ) > 1.0 ) { # lsfit has trouble with high slope fits
        ls.fit <- lsfit( z, y, wt = Madc[this.stdcut] )
        this.slope <- as.double( 1 / ls.fit$coefficients[2] ) # change to better fit
        this.intercept <- as.double( -this.slope * ls.fit$coefficients[1] ) # change to better fit
        ls.summary <- ls.print( ls.fit, print.it = FALSE )
        this.R2 <- as.double( ls.summary$summary[2] ) # change to better fit
      }
      
      y.intercept <- c( y.intercept, this.intercept ) # working
      y.slope <- c( y.slope, this.slope )
      y.R2 <- c( y.R2, this.R2 )
    }
  } else {
    y.min.channel <- c( y.min.channel, -1 )
    y.max.channel <- c( y.max.channel, 129 )
    y.min.time <- c( y.min.time, -1 )
    y.max.time <- c( y.max.time, -1 )
    y.adc <- c( y.adc, 0 )
    
    y.intercept <- c( y.intercept, -1000000.0 )
    y.slope <- c( y.slope, 0.0 )
    y.R2 <- c( y.R2, 0.0 )
  }
}

x.R2[is.na(x.R2)] <- 0 # happens for delta.t = 0 tracks
y.R2[is.na(y.R2)] <- 0
hist( x.R2, nclass = 200 )
hist( y.R2, nclass = 200 )
plot( x.R2, y.R2 )

x.contiguous.hits <- x.number.hits < -1 # all FALSE
this.stdcut <- x.number.hits == 1
x.contiguous.hits[this.stdcut] <- TRUE
this.stdcut <- x.number.hits > 1
x.contiguous.hits[this.stdcut] <- ( x.max.channel[this.stdcut] - x.min.channel[this.stdcut] ) / ( x.number.hits[this.stdcut] - 1 ) == 1.0

y.contiguous.hits <- y.number.hits < -1 # all FALSE
this.stdcut <- y.number.hits == 1
y.contiguous.hits[this.stdcut] <- TRUE
this.stdcut <- y.number.hits > 1
y.contiguous.hits[this.stdcut] <- ( y.max.channel[this.stdcut] - y.min.channel[this.stdcut] ) / ( y.number.hits[this.stdcut] - 1 ) == 1.0

  # Event statistics

number.hits <- x.number.hits + y.number.hits

x.mid <- ( x.max.channel + x.min.channel ) / 2.0
y.mid <- ( y.max.channel + y.min.channel ) / 2.0

adc <- x.adc + y.adc

min.time <- apply( cbind( x.min.time, y.min.time ), 1, min )
max.time <- apply( cbind( x.max.time, y.max.time ), 1, max )
delta.z <- ( max.time - min.time ) * 1e-9 * drift.speed # vertical extent of track according to hits

zenith <- atan( sqrt( 1 / x.slope^2 + 1 / y.slope^2 ) )
azimuth <- atan2( x.slope, y.slope )

