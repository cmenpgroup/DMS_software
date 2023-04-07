# Look at muon event statistics

plot( zenith[muon.stdcut] * 180 / pi, azimuth[muon.stdcut] * 180 / pi, xlim = c( 0, 90 ), ylim = c( -180, 180 ), main = "Zenith and Azimuth\nNo corner cuts" )
abline( h = seq( from = -180, to = 180, by = 45 ) )

x.number.hits.expected <- abs( drift.length / x.slope ) / wire.spacing
hist( x.number.hits[muon.stdcut] / x.number.hits.expected[muon.stdcut], nclass = 100 )

hist( zenith[muon.stdcut] * 180 / pi, nclass = 50, xlim = c( 0, 100 ), xlab = "Zenith Angle (degrees)", main = paste0( filename, "\n", length( delta.z[muon.stdcut] ), " muons" ) )
abline( v = 90, col = "red" )
#jpeg( paste0( plot.root, "/", "Zenith-", filename, ".jpeg"))
#hist( zenith[muon.stdcut] * 180 / pi, nclass = 50, xlim = c( 0, 100 ), xlab = "Zenith Angle (degrees)", main = paste0( filename, "\n", length( delta.z[muon.stdcut] ), " muons" ) )
#abline( v = 90, col = "red" )
#dev.off()

hist( delta.z[muon.stdcut], nclass = 50, xlab = "Delta z (cm)", main = paste0( filename, "\n", length( delta.z[muon.stdcut] ), " muons" ) )
#jpeg( paste0( plot.root, "/", "DeltaZ-", filename, ".jpeg"))
#hist( delta.z[muon.stdcut], nclass = 50, xlab = "Delta z (cm)", main = paste0( filename, "\n", length( delta.z[muon.stdcut] ), " muons" ) )
#dev.off()

# Set up corner clipper cuts
missing.delta.z <- drift.length - delta.z
missing.delta.z[missing.delta.z < 0] <- 0.0
x.left.corner.stdcut <- x.intercept > 0 & x.intercept < drift.length # left corner clippers in x dimension
x.left.corner.stdcut <- x.left.corner.stdcut | ( ( x.intercept + missing.delta.z ) > 0 & ( x.intercept + missing.delta.z ) < drift.length ) # left corner clippers in x dimension

x.right.intercept <- x.intercept + x.slope * 64 * wire.spacing # ~10 cm
x.right.corner.stdcut <- x.right.intercept > 0 & x.right.intercept < drift.length # right corner clippers in main dimension
x.right.corner.stdcut <- x.right.corner.stdcut | ( ( x.right.intercept + missing.delta.z ) > 0 & ( x.right.intercept + missing.delta.z ) < drift.length ) # right corner clippers in main dimension
x.right.corner.stdcut[is.na(x.right.corner.stdcut)] <- FALSE # These are due to Inf - Inf

length( number.hits[muon.stdcut] )
length( number.hits[muon.stdcut & x.left.corner.stdcut] )
length( number.hits[muon.stdcut & x.right.corner.stdcut] )
y.left.corner.stdcut <- y.intercept > 0 & y.intercept < drift.length # left corner clippers in x dimension
y.left.corner.stdcut <- y.left.corner.stdcut | ( ( y.intercept + missing.delta.z ) > 0 & ( y.intercept + missing.delta.z ) < drift.length ) # left corner clippers in x dimension

y.right.intercept <- y.intercept + y.slope * 64 * wire.spacing # ~10 cm
y.right.corner.stdcut <- y.right.intercept > 0 & y.right.intercept < drift.length # right corner clippers in main dimension
y.right.corner.stdcut <- y.right.corner.stdcut | ( ( y.right.intercept + missing.delta.z ) > 0 & ( y.right.intercept + missing.delta.z ) < drift.length ) # right corner clippers in main dimension
y.right.corner.stdcut[is.na(y.right.corner.stdcut)] <- FALSE # These are due to Inf - Inf

length( number.hits[muon.stdcut] )
length( number.hits[muon.stdcut & y.left.corner.stdcut] )
length( number.hits[muon.stdcut & y.right.corner.stdcut] )

non.corner.stdcut <- muon.stdcut & !x.left.corner.stdcut & !x.right.corner.stdcut & !y.left.corner.stdcut & !y.right.corner.stdcut # Run from top of this section to reset!  This is for non-left-right corner clippers

main.label <- paste0( filename, "\n", length( delta.z[non.corner.stdcut] ), " non-corner-clipping muons, ", round( 100 * length( delta.z[non.corner.stdcut & delta.z < 1.25] ) / length( delta.z[non.corner.stdcut] ) ), "% below 1.25 cm" )
hist( delta.z[non.corner.stdcut & delta.z < 2.5], xlab = "Delta z (cm)", main = main.label, breaks = seq( from = 0, to = 2.5, by = 0.1 ) )
jpeg( paste0( "DeltaZ-", filename, ".jpeg"))
hist( delta.z[non.corner.stdcut & delta.z < 2.5], xlab = "Delta z (cm)", main = main.label, breaks = seq( from = 0, to = 2.5, by = 0.1 ) )
dev.off()

hist( zenith[non.corner.stdcut] * 180 / pi, xlim = c( 0, 100 ), nclass = 25, xlab = "Zenith Angle (degrees)", main = paste0( filename, "\n", length( delta.z[muon.stdcut] ), " non-corner-cutting muons" ) )
abline( v = 90, col = "red" )
jpeg( paste0( plot.root, "/", "Zenith-", filename, ".jpeg"))
hist( zenith[non.corner.stdcut] * 180 / pi, xlim = c( 0, 100 ), nclass = 25, xlab = "Zenith Angle (degrees)", main = paste0( filename, "\n", length( delta.z[muon.stdcut] ), " non-corner-cutting muons" ) )
abline( v = 90, col = "red" )
dev.off()

hist( azimuth[non.corner.stdcut] * 180 / pi, xlim = c( -180, 180 ), nclass = 25, xlab = "Azimuth Angle (degrees)", main = paste0( filename, "\n", length( delta.z[muon.stdcut] ), " non-corner-cutting muons" ) )
jpeg( paste0( plot.root, "/", "Azimuth-", filename, ".jpeg"))
hist( azimuth[non.corner.stdcut] * 180 / pi, xlim = c( -180, 180 ), nclass = 25, xlab = "Azimuth Angle (degrees)", main = paste0( filename, "\n", length( delta.z[muon.stdcut] ), " non-corner-cutting muons" ) )
dev.off()

mean.number.per.muon <- sum( number.hits[non.corner.stdcut] ) / length( number.hits[non.corner.stdcut] )
mean.number.per.muon.error <- mean.number.per.muon * sqrt( length( number.hits[non.corner.stdcut] ) ) / length( number.hits[non.corner.stdcut] )
hist( number.hits[non.corner.stdcut & number.hits < 70], xlab = "Number of Hits per Muon", main = paste0( filename, "\nMean hits = ", signif( mean.number.per.muon, 3 ), " +/- ", signif( mean.number.per.muon.error, 2 ), " per non-left-right corner clipping muon" ), breaks = seq( from = 0, to = 70, by = 5 ) )
jpeg( paste0( plot.root, "/", "Hits-", filename, ".jpeg"))
hist( number.hits[non.corner.stdcut & number.hits < 70], xlab = "Number of Hits per Muon", main = paste0( filename, "\nMean hits = ", signif( mean.number.per.muon, 3 ), " +/- ", signif( mean.number.per.muon.error, 2 ), " per non-left-right corner clipping muon" ), breaks = seq( from = 0, to = 70, by = 5 ) )
dev.off()

plot( zenith[non.corner.stdcut] * 180 / pi, azimuth[non.corner.stdcut] * 180 / pi, xlim = c( 0, 90 ), ylim = c( -180, 180 ), main = paste0( filename, ", Zenith and Azimuth\nNon-corner cutting muons" ) )
jpeg( paste0( plot.root, "/", "Azimuth and Zenith -", filename, ".jpeg"))
plot( zenith[non.corner.stdcut] * 180 / pi, azimuth[non.corner.stdcut] * 180 / pi, xlim = c( 0, 90 ), ylim = c( -180, 180 ), main = paste0( filename, ", Zenith and Azimuth\nNon-corner cutting muons" ) )
dev.off()
