adc.colors <- rainbow( n = 128 )
par( mfrow = c( 2, 1 ) )

this.stdcut <- ( Mt >= x.min.time[draw.event.index] & Mt <= x.max.time[draw.event.index] ) | ( Mt >= y.min.time[draw.event.index] & Mt <= y.max.time[draw.event.index] )
this.event.min.time <- min( Mt[this.stdcut] )

# X
this.stdcut <- Mt >= x.min.time[draw.event.index] & Mt <= x.max.time[draw.event.index] & Mch < 64
main.label <- paste0( filename, "\nzenith = ", round( zenith[draw.event.index] * 180 / pi ), " degrees\nEvent number = ", i, ", x.R2 = ", x.R2[draw.event.index] )
plot( Mch[this.stdcut] * wire.spacing, ( Mt[this.stdcut] - this.event.min.time ) * 1e-9 * drift.speed, type = "n", main = main.label, xlim = c( 0, 64 * wire.spacing ), ylim = c( 0, 3.0 ), xlab = "x (cm)", ylab = "z (cm)" )
abline( v = c( (0:4) * 16) * wire.spacing, col = "dark gray")
abline( v = c( 0:64 ) * wire.spacing, col = "gray")
abline( h = seq( from = 0, to = 1.5, by = 0.5 ), col = "gray")
abline( h = drift.length )
if ( abs( x.slope[draw.event.index] ) < Inf ) {
  abline( x.intercept[draw.event.index], x.slope[draw.event.index] )
} else {
  x <- (Mch[this.stdcut] - 64) * wire.spacing
  z <- (Mt[this.stdcut] - this.event.min.time ) * 1e-9 * drift.speed
  abline( v = x[z==min(z)] ) # Occasionally this will produce double lines
}
points( Mch[this.stdcut] * wire.spacing, ( Mt[this.stdcut] - this.event.min.time ) * 1e-9 * drift.speed, cex = 1.5, col = adc.colors[round(128 * Madc[this.stdcut]/1023)], pch = 20 )
#print( paste0( "X z range = ", max( ( Mt[this.stdcut] - this.event.min.time ) * 1e-9 * drift.speed ) ) )

# Y
this.stdcut <- Mt >= y.min.time[draw.event.index] & Mt <= y.max.time[draw.event.index] & Mch > 63
main.label <- paste0( filename, "\nazimuth = ", round( azimuth[draw.event.index] * 180 / pi ), " degrees\nEvent number = ", i, ", y.R2 = ", y.R2[draw.event.index] )
plot( (Mch[this.stdcut] - 64) * wire.spacing, (Mt[this.stdcut] - this.event.min.time ) * 1e-9 * drift.speed, type = "n", main = main.label, xlim = c( 0, 64 * wire.spacing ), ylim = c( 0, 3.0 ), xlab = "y (cm)", ylab = "z (cm)" )
abline( v = c( (0:4) * 16) * wire.spacing, col = "dark gray")
abline( v = c( 0:64 ) * wire.spacing, col = "gray")
abline( h = seq( from = 0, to = 1.5, by = 0.5 ), col = "gray")
abline( h = drift.length )
if ( abs( y.slope[draw.event.index] ) < Inf ) {
  abline( y.intercept[draw.event.index], y.slope[draw.event.index] )
} else {
  y <- ( Mch[this.stdcut] - 64 ) * wire.spacing
  z <- ( Mt[this.stdcut] - this.event.min.time ) * 1e-9 * drift.speed
  abline( v = y[z==min(z)] ) # Occasionally this will produce double lines
}
points( ( Mch[this.stdcut] - 64 ) * wire.spacing, ( Mt[this.stdcut] - this.event.min.time ) * 1e-9 * drift.speed, cex = 1.5, col = adc.colors[round(128 * Madc[this.stdcut]/1023)], pch = 20 )
#print( paste0( "Y z range = ", max( ( Mt[this.stdcut] - this.event.min.time ) * 1e-9 * drift.speed ) ) )

#  extra.stdcut <- Mt >= min.time[draw.event.index] + 102.4 * 1000 & Mt <= max.time[draw.event.index] + 102.4 * 1000
#  points( Mch[extra.stdcut] * wire.spacing, ( Mt[extra.stdcut] - 102.4 * 1000 - this.event.min.time ) * 1e-9 * drift.speed, col = "red" )

#  extra.stdcut <- Mt >= min.time[draw.event.index] - 102.4 * 1000 & Mt <= max.time[draw.event.index] - 102.4 * 1000
#  points( Mch[extra.stdcut] * wire.spacing, ( Mt[extra.stdcut] + 102.4 * 1000 - this.event.min.time ) * 1e-9 * drift.speed, col = "purple" )

par( mfrow = c( 1, 1 ) )
