# Fe55 Analysis
rm( list = ls() )

if(!exists("PathIsSet")) source("/Users/wood5/LDM/RMD/DMS_software/SetUpPathDMS.R")

source(paste0(neutron.root,"/FileList.R"))

fe55.filenames <- filenames[grep( "Fe55", filenames )]
length( fe55.filenames )

gas.file <- NULL
gas.run <- NULL
gas.gains <- NULL
gas.gains.error <- NULL
gas.center <- NULL
gas.center.error <- NULL
gas.sigma <- NULL
gas.sigma.error <- NULL
for ( filename in fe55.filenames ) {
  
  source( paste0(program.root,"/LoadStats.R") )
  
  source( paste0(program.root,"/GetFe55GasGain.R") )
  gas.gains <- c( gas.gains, this.run.gas.gain$val )
  gas.gains.error <- c( gas.gains.error, this.run.gas.gain$err )
  gas.center <- c( gas.center, center )
  gas.center.error <- c( gas.center.error, center.err )
  gas.sigma <- c( gas.sigma, sigma )
  gas.sigma.error <- c( gas.sigma.error, sigma.err )
  gas.run <- c(gas.run,unlist( strsplit(filename, split = "-") )[3] )
}
gas.file <- c(1:length(fe55.filenames))
plot(gas.file,gas.sigma)
plot(gas.file,gas.center)
plot(gas.file,gas.gains)