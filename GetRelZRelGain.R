# Get relative gain data for selected events

look.stdcut <- muon.stdcut & !x.left.corner.stdcut & !x.right.corner.stdcut & !y.left.corner.stdcut & !y.right.corner.stdcut # Run from top of this section to reset!  This is for non-left-right corner clippers
length( seq( number.hits )[look.stdcut] )

relative.z <- NULL
relative.ionization <- NULL

for ( i in seq( x.number.hits )[look.stdcut] ) {
  # only in X now
  this.stdcut <- Mt >= x.min.time[i] & Mt <= x.max.time[i] & Mch > 20 & Mch < 40 # Focus on middle X wires to avoid edge gain effects

  relative.z <- c( relative.z, ( Mt[this.stdcut] - min( Mt[this.stdcut] ) ) * 1e-9 * drift.speed )
  relative.ionization <- c( relative.ionization, Madc[this.stdcut] / mean( Madc[this.stdcut & ( Mt[this.stdcut] - min( Mt[this.stdcut] ) ) * 1e-9 * drift.speed > 0.05] ) )
  
  # if( length( Mch[this.stdcut] ) != length( unique( Mch[this.stdcut] ) ) ) {
  #   print( "Found a muon event with multiple hits on a single line" )
  # }
}

this.stdcut <- relative.z > 0.05 & relative.z < 1.50 & relative.ionization < 2.00
ls.fit <- lsfit( relative.z[this.stdcut], relative.ionization[this.stdcut] )
ls.print( ls.fit )
( 1 + 1.5 * ls.fit$coefficients[2] ) / 1
main.label <- paste0( "Ionization vs Distance\nslope = ", signif( ls.fit$coefficients[2], 3 ), " per cm")
plot( relative.z, relative.ionization, ylim = c( 0, 4 ), main = main.label, xlab = "z (cm)", ylab = "Ionization/mean(ionization) per track" )
abline( v = 0.05, col = "red" )
abline( v = 1.50, col = "red" )
abline( h = 2.00, col = "red" )
abline( ls.fit )
jpeg( paste0( "RelativeGain-", filename, ".jpeg"))
plot( relative.z, relative.ionization, ylim = c( 0, 4 ), main = main.label, xlab = "z (cm)", ylab = "Ionization/mean(ionization) per track" )
abline( v = 0.05, col = "red" )
abline( v = 1.50, col = "red" )
abline( h = 2.00, col = "red" )
abline( ls.fit )
dev.off()
