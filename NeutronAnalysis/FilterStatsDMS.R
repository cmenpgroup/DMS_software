# Initialize R
rm( list = ls() )

# Create stats files
print(paste0("Starting FilterStatsDMS.R"))
print( system( "date"))

if(!exists("PathIsSet")) source("/Users/wood5/LDM/RMD/DMS_software/SetUpPathDMS.R")

source(paste0(neutron.root,"/FileList.R"))

for( filename in filenames ) {
  print( filename )
  file <- paste0( data.root, "/", filename, ".dat" )
  adjacent.channels <- "ON" # This can be extracted from the header file
  
  source( paste0(program.root,"/GetData1.2.R") )
  threshold <- threshold # from GetData2.R
  chip.gain <- c( 0.5, 1, 3, 4.5, 6, 9, 12, 16 )[gainIndex+1] # from GetData2.R
  run.time <- max( Mt ) / 1e9 # in s
  run.current <- current / 1000.0
  
  run.title <- paste0( "I=", run.current, " uA, G=", chip.gain, " mV/fC, Thres=", threshold, ", t=", round( run.time ), " s, Adj", adjacent.channels )
  
  source( paste0(program.root,"/GetVandSigma.R") )
  
  source( paste0(program.root,"/MakeStandardPlots.R") )
  pdf( paste0( plot.root, "/", filename, " Output Summary.pdf" ) )
  source( paste0(program.root,"/MakeStandardPlots.R") )
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
  source( paste0(program.root,"/ClusterData.R") )
  
  source( paste0(program.root,"/GetEventStats.R") )
  
  stats.filename <- paste0( filename, "-stats.dat" )
  file <- paste0( stats.root, "/", stats.filename )
  write( c( "x.number.hits", "x.min.channel", "x.max.channel", "x.min.time", "x.max.time", "x.adc", "x.slope", "x.intercept", "x.R2", "y.number.hits", "y.min.channel", "y.max.channel", "y.min.time", "y.max.time", "y.adc", "y.slope", "y.intercept", "y.R2" ), file = file, ncolumns = 18, sep = "\t" )
  write( t( cbind( x.number.hits, x.min.channel, x.max.channel, x.min.time, x.max.time, x.adc, x.slope, x.intercept, x.R2, y.number.hits, y.min.channel, y.max.channel, y.min.time, y.max.time, y.adc, y.slope, y.intercept, y.R2 ) ), file = file, ncolumns = 18, sep = "\t", append = TRUE )
  
  print( system( "date"))
}
