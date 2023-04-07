# Analyze the neutron from Cf-252 and GEM
rm( list = ls() )

if(!exists("PathIsSet")) source("/Users/wood5/LDM/RMD/DMS_software/SetUpPathDMS.R")

dataType <-"neut"
source(paste0(neutron.root,"/PlotNeutron.R"))
hist_neut <- adc_hist

dataType <-"back"
source(paste0(neutron.root,"/PlotNeutron.R"))
hist_back <- adc_hist

# plot the histograms in the Plots viewer 
#plot(hist_neut, col = rgb(1,0,0,0.4), xlab = "ADC Channel", ylab = "Counts", main = paste("GEM Study: Cf-252"))
plot(hist_neut$mids,hist_neut$counts, log = "y", type = "h", lwd = 5, lend = 2, col = rgb(1,0,0,0.4), xlab = "ADC Channel", ylab = "Counts", main = paste("GEM Study: Cf-252"))
points(hist_back$mids, hist_back$counts, log = "y", type = "h", lwd = 5, lend = 2, col = rgb(0,0,1,0.4))

xVal <- hist_neut$mids
yVal <- hist_neut$counts - hist_back$counts
points(xVal, yVal, type = "h", log = "y", lwd = 5, lend = 2, col = rgb(0,1,0,0.4))
legend('topright', c('neutron', 'background', 'bgd subtracted'), fill=c(rgb(1,0,0,0.4), rgb(0,0,1,0.4),rgb(0,1,0,0.4)))

# plot the histograms to be saved in a file
jpeg( paste0( plot.root, "/", "DMS-AnalyzeNeutron.jpg" ) ) # open the graphics file

#plot(hist_neut, col = rgb(1,0,0,0.4), xlab = "ADC Channel", ylab = "Counts", main = paste("GEM Study: Cf-252"))
plot(hist_neut$mids,hist_neut$counts, log = "y", type = "h", lwd = 5, lend = 2, col = rgb(1,0,0,0.4), xlab = "ADC Channel", ylab = "Counts", main = paste("GEM Study: Cf-252"))
points(hist_back$mids, hist_back$counts, log = "y", type = "h", lwd = 5, lend = 2, col = rgb(0,0,1,0.4))

xVal <- hist_neut$mids
yVal <- hist_neut$counts - hist_back$counts
points(xVal, yVal, type = "h", log = "y", lwd = 5, lend = 2, col = rgb(0,1,0,0.4))
legend('topright', c('neutron', 'background', 'bgd subtracted'), fill=c(rgb(1,0,0,0.4), rgb(0,0,1,0.4),rgb(0,1,0,0.4)))

dev.off() # close the graphics file