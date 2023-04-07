
plot( Mch, Madc, main = paste0( "Channel vs ADC, ", filename, "\n", run.title ), xlim = c( 0, 128 ), ylim = c( 0, 1025 ), pch = 20, cex = 0.1 )

plot( Madc, main = paste0( "Index vs ADC, ", filename, "\n", run.title ), pch = 20, cex = 0.1 )
hist( Madc, main = paste0( "Histogram of Madc, ", filename, "\n", run.title ), seq( from = 0, to = 1025, by = 1 ) )
hist( Madc[Madc < 1023], main = paste0( "Histogram of Madc[Madc < 1023], ", filename, "\n", run.title ), seq( from = 0, to = 1025, by = 1 ) )

plot( Mch, Mt, main = paste0( "Channel vs Time, ", filename, "\n", run.title ), xlim = c( 0, 128 ), pch = 20, cex = 0.1 )
plot( Mch, main = paste0( "Index vs Channel, ", filename, "\n", run.title ), pch = 20, cex = 0.1 )
hist( Mch, main = paste0( "Histogram of Mch, ", filename, "\n", run.title ), nclass = 200 )

plot( Mt, main = paste0( "Index vs Time, ", filename, "\n", run.title ), pch = 20, cex = 0.1 )
#hist( Mt, main = paste0( "Histogram of Mt, ", filename, "\n", run.title ), nclass = 200 )
