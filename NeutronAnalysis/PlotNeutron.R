# R script to plot a histogram from the summing data from many files

source(paste0( neutron.root, "/FileList.R"))

# variable dataType is set in the AnalyzeNeutron.R script
data.filenames <- filenames[grep( dataType, filenames )]
length( data.filenames )

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
adc.all <- NULL

for ( filename in data.filenames ) {
  print(paste0("Analyzing ",filename))
  source( paste0( program.root, "/LoadStats.R") )
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
  adc.all <- c(adc.all,adc)
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
adc <- adc.all

look.stdcut <- x.number.hits == 3 & y.number.hits == 3 & x.adc / y.adc > 0.75 & x.adc / y.adc < 1.5 
adc.clean <- adc[look.stdcut]
adc.clean <- adc.clean[!is.na(adc.clean)]
adc.clean <- adc.clean[adc.clean < 2500]
adc_hist <- hist( adc.clean,breaks = seq( from = 0, to = 2500, by = 50 ), xlab = "ADC Channel", ylab = "Counts", main = paste("GEM Study: Cf-252"))
print(adc_hist$counts)
