# Initialize R

setwd( "/Users/wood5/LDM/RMD/DMS_software" )

rm( list = ls() )
program.root <- getwd()
data.root <- "DMS Data"
plot.root <- "DMS Plots"
stats.root <- "DMS Stats"

source( "/Users/wood5/LDM/RMD/DMS_software/measurement.r" )

# Set parameters

wire.spacing <- 0.16 # cm
drift.length <- 1.55 # cm

# Create stats files

filenames <- c( "DMS-20230315-01-0001-Fe55", "DMS-20230315-03-0001-muon", "DMS-20230315-01-0001-muon", "DMS-20230315-03-0002-muon", "DMS-20230315-01-0002-muon", "DMS-20230315-04-0001-Fe55", "DMS-20230315-02-0001-Fe55", "DMS-20230315-04-0001-muon", "DMS-20230315-02-0001-muon", "DMS-20230315-04-0002-muon", "DMS-20230315-02-0002-muon", "DMS-20230315-05-0001-Fe55", "DMS-20230315-03-0001-Fe55", "DMS-20230315-06-0001-Fe55" )
length( filenames )
filenames <- filenames[2]
filenames <- "DMS-20230317-11-0001-neut"

for( filename in filenames ) {
  print( filename )
  file <- paste0( data.root, "/", filename, ".dat" )
  adjacent.channels <- "ON" # This can be extracted from the header file
  
  source( "GetData1.2.R" )
  threshold <- threshold # from GetData2.R
  chip.gain <- c( 0.5, 1, 3, 4.5, 6, 9, 12, 16 )[gainIndex+1] # from GetData2.R
  run.time <- max( Mt ) / 1e9 # in s
  run.current <- current / 1000.0

  run.title <- paste0( "I=", run.current, " uA, G=", chip.gain, " mV/fC, Thres=", threshold, ", t=", round( run.time ), " s, Adj", adjacent.channels )
  
  source( "GetVandSigma.R" )
  
  source( "MakeStandardPlots.R" )
  pdf( paste0( plot.root, "/", filename, " Output Summary.pdf" ) )
  source( "MakeStandardPlots.R" )
  dev.off()
  
  # Set cluster gap
  if( unlist( strsplit(filename, split = "-") )[5] == "Fe55" ) {
    cluster.gap <- 100 # Fe-55, minimum gap between clusters in ns
  } else if (unlist( strsplit(filename, split = "-") )[5] == "muon" ) {
    cluster.gap <- 500 # Muons, minimum gap between clusters in ns
  } else if (unlist( strsplit(filename, split = "-") )[5] == "back" ) {
    cluster.gap <- 500 # Muons, minimum gap between clusters in ns
  } else if (unlist( strsplit(filename, split = "-") )[5] == "neut" ) {
    cluster.gap <- 500 # Muons, minimum gap between clusters in ns
  } else {
    print( "Unknown run type!" )
    break
  }
  source( "ClusterData.R" )
  
  source( "GetEventStats.R" )
  
  stats.filename <- paste0( filename, "-stats.dat" )
  file <- paste0( program.root, "/", "DMS Stats/", stats.filename )
  write( c( "x.number.hits", "x.min.channel", "x.max.channel", "x.min.time", "x.max.time", "x.adc", "x.slope", "x.intercept", "x.R2", "y.number.hits", "y.min.channel", "y.max.channel", "y.min.time", "y.max.time", "y.adc", "y.slope", "y.intercept", "y.R2" ), file = file, ncolumns = 18, sep = "\t" )
  write( t( cbind( x.number.hits, x.min.channel, x.max.channel, x.min.time, x.max.time, x.adc, x.slope, x.intercept, x.R2, y.number.hits, y.min.channel, y.max.channel, y.min.time, y.max.time, y.adc, y.slope, y.intercept, y.R2 ) ), file = file, ncolumns = 18, sep = "\t", append = TRUE )

  print( system( "date"))
}


# Fe55 Analysis

fe55.filenames <- filenames[grep( "Fe55", filenames )]
length( fe55.filenames )

gas.gains <- NULL
gas.gains.error <- NULL
for ( filename in fe55.filenames ) {
  
  source( "LoadStats.R" )
  
  source( "GetFe55GasGain.R" )
  gas.gains <- c( gas.gains, this.run.gas.gain$val )
  gas.gains.error <- c( gas.gains.error, this.run.gas.gain$err )
}



# Look at neutron events

filename
look.stdcut <- x.number.hits == 3 & y.number.hits == 3 & x.adc / y.adc > 0.75 & x.adc / y.adc < 1.5
hist( adc[look.stdcut], breaks = seq( from = 0, to = 2500, by = 50 ) )
length( adc[look.stdcut] )

for ( draw.event.index in seq( x.number.hits )[look.stdcut] ) {
  
  source( "DrawEvent.R" )
  print( adc[draw.event.index])
  
  xy <- locator(1)
  if ( xy$y < 0.0 ) {
    break
  }
}



# Load muon stats

muon.filenames <- filenames[grep( "muon", filenames )]
length( muon.filenames )
muon.filenames <- muon.filenames[1:4]

x.number.hits.all <- NULL
x.min.channel.all <- NULL
x.max.channel.all <- NULL
x.min.time.all <- NULL # ns
x.max.time.all <- NULL # ns
x.adc.all <- NULL
x.slope.all <- NULL
x.intercept.all <- NULL
x.R2.all <- NULL
y.number.hits.all <- NULL
y.min.channel.all <- NULL
y.max.channel.all <- NULL
y.min.time.all <- NULL # ns
y.max.time.all <- NULL # ns
y.adc.all <- NULL
y.slope.all <- NULL
y.intercept.all <- NULL
y.R2.all <- NULL

for ( filename in muon.filenames ) {
  source( "LoadStats.R" )
  x.number.hits.all <- c( x.number.hits.all, x.number.hits )
  x.min.channel.all <- c( x.min.channel.all, x.min.channel )
  x.max.channel.all <- c( x.max.channel.all, x.max.channel )
  x.min.time.all <- c( x.min.time.all, x.min.time ) # ns
  x.max.time.all <- c( x.max.time.all, x.max.time ) # ns
  x.adc.all <- c( x.adc.all, x.adc )
  x.slope.all <- c( x.slope.all, x.slope )
  x.intercept.all <- c( x.intercept.all, x.intercept )
  x.R2.all <- c( x.R2.all, x.R2 )
  y.number.hits.all <- c( y.number.hits.all, y.number.hits )
  y.min.channel.all <- c( y.min.channel.all, y.min.channel )
  y.max.channel.all <- c( y.max.channel.all, y.max.channel )
  y.min.time.all <- c( y.min.time.all, y.min.time ) # ns
  y.max.time.all <- c( y.max.time.all, y.max.time ) # ns
  y.adc.all <- c( y.adc.all, y.adc )
  y.slope.all <- c( y.slope.all, y.slope )
  y.intercept.all <- c( y.intercept.all, y.intercept )
  y.R2.all <- c( y.R2.all, y.R2 )
}
x.number.hits <- x.number.hits.all
x.min.channel <- x.min.channel.all
x.max.channel <- x.max.channel.all
x.min.time <- x.min.time.all # ns
x.max.time <- x.max.time.all # ns
x.adc <- x.adc.all
x.slope <- x.slope.all
x.intercept <- x.intercept.all
x.R2 <- x.R2.all
y.number.hits <- y.number.hits.all
y.min.channel <- y.min.channel.all
y.max.channel <- y.max.channel.all
y.min.time <- y.min.time.all # ns
y.max.time <- y.max.time.all # ns
y.adc <- y.adc.all
y.slope <- y.slope.all
y.intercept <- y.intercept.all
y.R2 <- y.R2.all

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


# Define muons
muon.stdcut <- x.number.hits > 0 & y.number.hits > 0 
muon.stdcut <- muon.stdcut & ( x.max.time - x.min.time ) > 1000 & ( y.max.time - y.min.time ) > 1000 # in ns
muon.stdcut <- muon.stdcut & x.R2 >= 0.7 & y.R2 >= 0.7 # for muons R2 greater than 0 forces 4 hits on both X and Y
length( adc[muon.stdcut])
source( "GetMuonStats.R" )


# Make heat map

# Load the lattice package
library("lattice")

depth <- 15 * 12 * 2.54 / 100 # in m

R <- depth / cos( zenith[muon.stdcut] )

x <- as.double( R * sin( zenith[muon.stdcut] ) * cos( azimuth[muon.stdcut] ) )
y <- as.double( R * sin( zenith[muon.stdcut] ) * sin( azimuth[muon.stdcut] ) )

L <- 20 # side length of the map in m
number.pixels.per.side <- 40
delta.L <- L / number.pixels.per.side

x.pixel <- seq( from = -L/2 + delta.L/2, to = L/2 - delta.L/2, length.out = number.pixels.per.side )
y.pixel <- x.pixel


data <- expand.grid(X=x.pixel, Y=y.pixel)

numbers <- data$X * 0
for ( i in seq( data$X ) ) {
    stdcut <- x >= data$X[i] - delta.L/2 & x < data$X[i] + delta.L/2
    stdcut <- stdcut & y >= data$Y[i] - delta.L/2 & y < data$Y[i] + delta.L/2
    numbers[i] <- length( x[stdcut] )
}
data$Z <- numbers

# Make the heatmap
levelplot(Z ~ X*Y, data=data, xlab="X (m) at surface", ylab="Y (m) at surface", main = "1 hour Lab Muon Map", col.regions=heat.colors( 100 ) )




# Requires Mt, Madc etc

source( "GetRelZRelGain.R" )

# Look at events

filename
#look.stdcut <- muon.stdcut & !x.left.corner.stdcut & !x.right.corner.stdcut & !y.left.corner.stdcut & !y.right.corner.stdcut # Run from top of this section to reset!  This is for non-left-right corner clippers
look.stdcut <- non.corner.stdcut
look.stdcut <- muon.stdcut
length( seq( number.hits )[look.stdcut] )

for ( draw.event.index in seq( x.number.hits )[look.stdcut] ) {
  
  source( "DrawEvent.R" )
  
  xy <- locator(1)
  if ( xy$y < 0.0 ) {
    break
  }
}




# Muon hit analysis

currents <- c( 740, 750, 760, 770, 780 )
x.muon.mean.hits <- measurement( c( 18.1, 19.1, 22.4, 24.2, 27.6 ), c( 3.0, 2.3, 2.1, 2.5, 2.6 ) ) # X-muons
y.muon.mean.hits <- measurement( c( 14.0, 17.3, 18.7, 20.8, 24.5 ), c( 2.4, 2.2, 1.8, 1.9, 2.1 ) ) # Y-muons
plot( measurement( currents, 1 ), x.muon.mean.hits, ylim = c( 0, 35 ), main = "Y Hits per Muon vs Current", xlab = "Current (uA)", ylab = "Hits per muon", type = "n" )
points( measurement( currents, 1 ), x.muon.mean.hits, col = "blue" )
points( measurement( currents, 1 ), y.muon.mean.hits, col = "green" )
legend( "topright", legend = c( "X", "Y" ), text.col = c( "blue", "green") )

gains <- measurement( c( 5364, 8630, 13700, 18400, 31900 ), c( 50, 70, 100, 150, 200 ) )
plot( gains, x.muon.mean.hits, ylim = c( 0, 35 ), main = "Hits per Muon vs Gas Gain", xlab = "Gas Gain", ylab = "Hits per muon", type = "n" )
points( gains, x.muon.mean.hits, col = "blue" )
points( gains, y.muon.mean.hits, col = "green" )
legend( "topright", legend = c( "X", "Y" ), text.col = c( "blue", "green") )

gains <- measurement( c( 5364, 8630, 13700, 18400, 31900 ), c( 50, 70, 100, 150, 200 ) )
run.time <- 600
x.numbers <- c( 37, 70, 109, 93, 113 )
y.numbers <- c( 34, 63, 109, 118, 142 )
x.rates <- measurement( x.numbers, sqrt( x.numbers ) ) / run.time # in Hz
y.rates <- measurement( y.numbers, sqrt( y.numbers ) ) / run.time # in Hz
plot( gains, y.rates, ylim = c( 0, 0.35 ), main = "Rates vs Gas Gain", xlab = "Gas Gain", ylab = "Rate (Hz)", type = "n" )
points( gains, x.rates, col = "blue" )
points( gains, y.rates, col = "green" )
legend( "topright", legend = c( "X", "Y" ), text.col = c( "blue", "green") )




# Muon rate analysis

main.label <- "Rates vs Threshold and Current\nY wires"
mat <- matrix( scan( "RatesY.txt"), ncol = 5, byrow = TRUE )
current <- mat[,1]
threshold <- mat[,2]
number <- mat[,4]
times <- mat[,5]

rates <- measurement( number / times, sqrt( number ) / times )

colors <- c( "brown", "blue", "red", "green", "orange")
plot.colors <- NULL
for ( i in seq( colors ) ) {
  plot.colors <- c( plot.colors, array( colors[i], dim = 4 ) )
}
plot( measurement( seq( current ), 0 ), rates, xlim = c( 0, 20 ), ylim = c( 0, 3 ), main = main.label, xlab = "Decreasing threshold ->", ylab = "Muon Rate (Hz)", col = plot.colors )
abline( v = c( 0, 4.5, 8.5, 12.5, 16.5 ))
currents <- unique( current )
legend( "topright", legend = paste0( currents, " uA" ), text.col = colors )


colors <- c( "brown", "blue", "red", "green", "orange")

for ( i in seq( currents ) ) {
  this.current <- currents[i]
  this.threshold <- threshold[this.current == current]
#  this.currents <- current[this.current == current]
  this.rate <- measurement( rates$val[this.current == current], rates$err[this.current == current] )
  points( measurement( this.threshold, 0 ), this.rate, col = colors[i] )
}




# Save Fe-55 data to file

# Careful with this line!
#write( c( run.current, gas.gain$val, gas.gain$err ), "Fe55Data.txt", ncolumns = 3, append = TRUE )

mat <- matrix( scan( file = "Fe55Data.txt", comment = "#" ), byrow = TRUE, ncol = 3 )

this.colors <- c( "blue", "blue", "blue", "blue", "blue" ) # X wires 1/16
#this.colors <- c( this.colors, "red", "red", "red", "red", "red" ) # X wires 1/18
this.colors <- c( this.colors, "purple", "purple", "purple", "purple", "purple" ) # Y wires 1/21
this.colors <- c( this.colors, "brown", "brown", "brown", "brown", "brown" ) # X wires 2/2/2023
this.colors <- c( this.colors, "green", "green", "green", "green", "green" ) # Y wires 2/2/2023
plot( measurement( mat[,1], mat[,1] * 0 ), measurement( mat[,2], mat[,3] ), main = "Fe-55 Calibration Curve", xlab = "Current (uA)", ylab = "Gas Gain", col = this.colors )

plot( measurement( mat[,1], 0 ), measurement( mat[,2], mat[,3] ), xlim = c( 720, 820 ), log = "y", main = "Fe-55 Calibration Curve", xlab = "Current (uA)", ylab = "Gas Gain", col = this.colors )
for ( this.color in unique( this.colors ) ) {
  this.rows <- seq( mat[,1] )[this.colors == this.color]
  ls.fit <- lsfit( mat[this.rows,1], log( mat[this.rows,2] ) )
  x.fit <- seq( from = 730, to = 790, by = 10 )
  y.fit <- exp( ls.fit$coefficients[1] ) * exp( ls.fit$coefficients[2] * x.fit )
  lines( x.fit, y.fit, col = this.color )
}
abline( h = 15000, col = "red" )
legend( "topright", legend = c( "1/16 X", "1/20 Y", "2/2 X", "2/2 Y" ), text.col = unique( this.colors ) )


# Averaging and dividing X and Y

this.current <- 750
stdcut <- mat[,1] == this.current
x.gain.val <- mean( measurement( mat[seq(mat[,1])[stdcut], 2], mat[seq(mat[,1])[stdcut], 3])$val[c(1,3)] )
x.gain.val
x.gain.err <- sqrt( sum( measurement( mat[seq(mat[,1])[stdcut], 2], mat[seq(mat[,1])[stdcut], 3])$err[c(1,3)]^2 ) ) / 2
x.gain.err
y.gain.val <- mean( measurement( mat[seq(mat[,1])[stdcut], 2], mat[seq(mat[,1])[stdcut], 3])$val[c(2,4)] )
y.gain.val
y.gain.err <- sqrt( sum( measurement( mat[seq(mat[,1])[stdcut], 2], mat[seq(mat[,1])[stdcut], 3])$err[c(2,4)]^2 ) ) / 2
y.gain.err

this.current
measurement( x.gain.val, x.gain.err )
measurement( y.gain.val, y.gain.err )
measurement( x.gain.val, x.gain.err ) / measurement( y.gain.val, y.gain.err )
( measurement( x.gain.val, x.gain.err ) + measurement( y.gain.val, y.gain.err ) ) / 2


# Event selection

hit.numbers <- 89:148
Mch[hit.numbers]
cbind( hit.numbers, Mch[hit.numbers], Mt[hit.numbers] )
hist( Mt[hit.numbers], nclass = 200 )
plot( Mt[hit.numbers], Mch[hit.numbers] )
max( Mt[hit.numbers] ) - min( Mt[hit.numbers] )

stdcut <- seq( Mch ) < 0 # All False
stdcut[hit.numbers] <- TRUE
stdcut <- stdcut & Mt > 3379780000
plot( Mt[stdcut], Mch[stdcut] )


stdcut <- seq( Madc ) > 182 & seq( Madc ) < 197 & Mch > 100
Mch[stdcut]
hist( Mt[stdcut] )
plot( Mt[stdcut], Mch[stdcut] )

stdcut <- Mt > 507368369 - 1000000 & Mt < 507368369 + 1000000 & seq( Madc ) < 500
Mch[stdcut]
hist( Mt[stdcut] )
plot( Mt[stdcut], Mch[stdcut] )

stdcut <- seq( Madc ) > 0 & seq( Madc ) < 500
x <- diff( sort( Mt[stdcut] ) )
hist( x[x < 100], nclass = 1000 )

delta.t <- 1000
hist( Mt[stdcut], breaks = seq( from = min( Mt[stdcut] ), to = max( Mt[stdcut] ), by = delta.t ) )


#select a channel and plot.  
#In the absence of noise each point should be of the same amplitude.
#index=(Mch==20) 
#plot(Mt[index], Madc[index],main=title,ylim=c(200,800))

