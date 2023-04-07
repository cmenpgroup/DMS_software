file <- paste0( data.root, "/", filename, ".dat" )

adjacent.channels <- "ON" # This can be extracted from the header file

source( "GetHeader1.2.R" )
threshold <- threshold # from GetData2.R
chip.gain <- c( 0.5, 1, 3, 4.5, 6, 9, 12, 16 )[gainIndex+1] # from GetData2.R
#run.time <- max( Mt ) / 1e9 # in s
run.time <- runLength / 1000.0 # in s doesn't work
run.current <- current / 1000.0
run.title <- paste0( "I=", run.current, " uA, G=", chip.gain, " mV/fC, Thres=", threshold, ", t=", round( run.time ), " s, Adj", adjacent.channels )

source( "GetVandSigma.R" )

stats.filename <- paste0( filename, "-stats.dat" )
file <- paste0( stats.root, "/", stats.filename )

mat <- matrix( scan( file = file, skip = 1, sep = "\t" ), ncol = 18, byrow = TRUE )
x.number.hits <- mat[,1]
x.min.channel <- mat[,2]
x.max.channel <- mat[,3]
x.min.time <- mat[,4] # ns
x.max.time <- mat[,5] # ns
x.adc <- mat[,6]
x.slope <- mat[,7]
x.intercept <- mat[,8]
x.R2 <- mat[,9]
y.number.hits <- mat[,10]
y.min.channel <- mat[,11]
y.max.channel <- mat[,12]
y.min.time <- mat[,13] # ns
y.max.time <- mat[,14] # ns
y.adc <- mat[,15]
y.slope <- mat[,16]
y.intercept <- mat[,17]
y.R2 <- mat[,18]

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

