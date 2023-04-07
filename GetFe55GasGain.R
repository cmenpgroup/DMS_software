# Fe-55 analysis

filename
stdcut <- number.hits > 2 & adc < 800

hist( adc[stdcut], nclass = 50, col = 'brown',  main = paste0( filename, "\n", run.title ) )
h <- hist( adc[stdcut], nclass = 50,  plot = "FALSE" )
x <- h$mids
y <- h$counts
print( "Pick out main peak with two clicks." )
xy <- locator(2)
this.stdcut <- x > xy$x[1] & x < xy$x[2]
x <- x[this.stdcut]
y <- y[this.stdcut]
fit <- nls( y ~ A * exp( -( x - center )^2 / ( 2 * sigma^2 ) ), start = list( A = max( y ), center = mean( xy$x ), sigma = ( xy$x[2] - xy$x[1] ) / 2 ) )
summary( fit )
A <- coef(summary(fit))[1, "Estimate"]
center <- coef(summary(fit))[2, "Estimate"]
sigma <- coef(summary(fit))[3, "Estimate"]
A.err <- coef(summary(fit))[1, "Std. Error"]
center.err <- coef(summary(fit))[2, "Std. Error"]
sigma.err <- coef(summary(fit))[3, "Std. Error"]
x.fit <- seq( from = center - 3 * sigma, to = center + 3 * sigma, by = 1 )
y.fit <- A * exp( -( x.fit - center )^2 / ( 2 * sigma^2 ) )
gas.gain <- 1e-15 * measurement( center, center.err ) / chip.gain / 1.602e-19 / 209
this.run.gas.gain <- gas.gain # Save for later and clear variable

par( mfrow = c( 2, 2 ) )
plot( x.mid[stdcut], adc[stdcut], ylim = c( 0, center + 3 * sigma ), pch = 20, cex = 0.5, main = "X" )
plot( y.mid[stdcut], adc[stdcut], ylim = c( 0, center + 3 * sigma ), pch = 20, cex = 0.5, main = "Y" )
plot( y.mid[stdcut], adc[stdcut], ylim = c( 0, center + 3 * sigma ), pch = 20, cex = 0.5, main = "Y" )
plot( x.mid[stdcut], adc[stdcut], ylim = c( 0, center + 3 * sigma ), pch = 20, cex = 0.5, main = "X" )
par( mfrow = c( 1, 1 ) )

main.label <- paste0( filename, "\n", run.title, "\nGas Gain = ", signif( gas.gain$val, 4 ), " +/- ", signif( gas.gain$err, 2 ), ", FWHM/mean = ",  signif( 100 * 2.35 * sigma/center, 3 ), "% +/- ", signif( 100 * 2.35 * sigma.err/center, 1 ), "%" )
hist( adc[stdcut], nclass = 50, col = 'brown',  main = main.label )
lines( x.fit, y.fit, col = "blue" )

jpeg( paste0( plot.root, "/", filename, " Histogram.jpg" ) )

hist( adc[stdcut], nclass = 50, col = 'brown',  main = main.label )
lines( x.fit, y.fit, col = "blue" )

dev.off()

pdf( paste0( plot.root, "/", filename, " Fe55.pdf" ) )

hist( adc[stdcut], nclass = 50, col = 'brown',  main = main.label )
lines( x.fit, y.fit, col = "blue" )

par( mfrow = c( 2, 2 ) )
plot( x.mid[stdcut], adc[stdcut], ylim = c( 0, center + 3 * sigma ), pch = 20, cex = 0.25, main = "X" )
plot( y.mid[stdcut], adc[stdcut], ylim = c( 0, center + 3 * sigma ), pch = 20, cex = 0.25, main = "Y" )
plot( y.mid[stdcut], adc[stdcut], ylim = c( 0, center + 3 * sigma ), pch = 20, cex = 0.25, main = "Y" )
plot( x.mid[stdcut], adc[stdcut], ylim = c( 0, center + 3 * sigma ), pch = 20, cex = 0.25, main = "X" )
par( mfrow = c( 1, 1 ) )

dev.off()

print( paste0( length( seq( number.hits )[stdcut] ), " Fe-55 events" ) )
print( paste0( "FWHM / Center = ", signif( 100 * 2.35 * sigma/center, 3 ), "%" ) )

# Fe-55 Heat Map

# Load the lattice package
library("lattice")

data <- expand.grid( X = 1:64, Y = 1:64 )

gas.gain <- adc * 1e-15 / chip.gain / 1.602e-19 / 209

delta.L <- 1
mean.gas.gain <- data$X * 0
for ( i in seq( data$X ) ) {
  stdcut <- x.mid >= data$X[i] - delta.L/2 & x.mid < data$X[i] + delta.L/2
  stdcut <- stdcut & ( y.mid - 64 ) >= data$Y[i] - delta.L/2 & ( y.mid - 64 ) < data$Y[i] + delta.L/2
  stdcut <- stdcut & gas.gain > ( center - 2 * sigma ) * 1e-15 / chip.gain / 1.602e-19 / 209 & gas.gain < ( center + 2 * sigma )  * 1e-15 / chip.gain / 1.602e-19 / 209
  if ( length( gas.gain[stdcut] ) > 2 ) {
    mean.gas.gain[i] <- mean( gas.gain[stdcut] )
  } else {
    mean.gas.gain[i] <- 0
  }
}
data$Z <- mean.gas.gain

# Make the heatmap
main.label <- paste0( filename, "\n", run.title, "\nGas Gain = ", signif( this.run.gas.gain$val, 4 ), " +/- ", signif( this.run.gas.gain$err, 2 ) )

levelplot(Z ~ X*Y, data=data, xlab="X (channel number)", ylab="Y (channel number)", main = main.label, col.regions=heat.colors( 100 ) )

jpeg( paste0( plot.root, "/", filename, " Fe55 Heat Map.jpg" ) )

levelplot(Z ~ X*Y, data=data, xlab="X (channel number)", ylab="Y (channel number)", main = paste0( filename, "\nFe55 Heat Map" ), col.regions=heat.colors( 100 ) )

dev.off()

#hist( vmm0.adc[stdcut & max.channel < 64], col = 'blue',  main = paste0( filename, ", VMM0\n", run.title, "\n", paste0( round( mean( vmm0.adc[stdcut & min.channel < 64] ) ), " +/- ", round( sqrt( var( vmm0.adc[stdcut & min.channel < 64] ) / length( vmm0.adc[stdcut & min.channel < 64] ) ) ) ) ) )
#gas.gain <- 2.0 * 1e-15 * measurement( round( mean( vmm0.adc[stdcut & max.channel < 64] ) ), round( sqrt( var( vmm0.adc[stdcut & max.channel < 64] ) / length( vmm0.adc[stdcut & max.channel < 64] ) ) ) ) / chip.gain / 1.602e-19 / 209
#gas.gain
#hist( vmm1.adc[stdcut & min.channel > 63], col = 'green',  main = paste0( filename, ", VMM1\n", run.title, "\n", paste0( round( mean( vmm1.adc[stdcut & min.channel > 63] ) ), " +/- ", round( sqrt( var( vmm1.adc[stdcut & min.channel > 63] ) / length( vmm1.adc[stdcut & min.channel > 63] ) ) ) ) ) )
#gas.gain <- 2.0 * 1e-15 * measurement( round( mean( vmm1.adc[stdcut & min.channel > 63] ) ), round( sqrt( var( vmm1.adc[stdcut & min.channel > 63] ) / length( vmm1.adc[stdcut & min.channel > 63] ) ) ) ) / chip.gain / 1.602e-19 / 209
#gas.gain

#stdcut <- adc > ( center - 2 * sigma ) & adc < ( center + 2 * sigma )
# charge.ratio <- x.adc[stdcut] / y.adc[stdcut]
# hist( charge.ratio[charge.ratio < 2], nclass = 200 )
# h <- hist( charge.ratio[charge.ratio < 2], nclass = 200,  plot = "FALSE" )
# x <- h$mids
# y <- h$counts
# print( "Pick out main peak with two clicks." )
# xy <- locator(2)
# this.stdcut <- x > xy$x[1] & x < xy$x[2]
# x <- x[this.stdcut]
# y <- y[this.stdcut]
# fit <- nls( y ~ A * exp( -( x - center )^2 / ( 2 * sigma^2 ) ), start = list( A = max( y ), center = mean( xy$x ), sigma = ( xy$x[2] - xy$x[1] ) / 2 ) )
# summary( fit )
# A <- coef(summary(fit))[1, "Estimate"]
# center <- coef(summary(fit))[2, "Estimate"]
# sigma <- coef(summary(fit))[3, "Estimate"]
# A.err <- coef(summary(fit))[1, "Std. Error"]
# center.err <- coef(summary(fit))[2, "Std. Error"]
# sigma.err <- coef(summary(fit))[3, "Std. Error"]
# x.fit <- seq( from = center - 3 * sigma, to = center + 3 * sigma, length = 1000 )
# y.fit <- A * exp( -( x.fit - center )^2 / ( 2 * sigma^2 ) )

#main.label <- paste0( filename, "\n", run.title, "\nCharge Ratio = ", signif( center, 4 ), " +/- ", signif( center.err, 1 ), ", Gas Gain = ", signif( this.run.gas.gain$val, 4 ), " +/- ", signif( this.run.gas.gain$err, 2 ) )
#hist( charge.ratio[charge.ratio < 2], nclass = 200, xlab = "Q_x/Q_y", main = main.label )
#lines( x.fit, y.fit, col = "blue")

#jpeg( paste0( plot.root, "/", filename, " Charge Ratio.jpg" ), height = 1024, width = 1024 )

#hist( charge.ratio[charge.ratio < 2], nclass = 200, xlab = "Q_x/Q_y", main = paste0( filename, "\nCharge Ratio = ", signif( center, 4 ), " +/- ", signif( center.err, 1 ) ) )
#lines( x.fit, y.fit, col = "blue")

#dev.off()

