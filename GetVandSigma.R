# Need to input run.current in microA and drift.length

E.drift <- run.current * 1e-6 * 0.9090909091e6 / drift.length # in V/cm

VandSigmaDirectory <- paste0(program.root,"/Drift and Diffusion")

mat <- matrix( scan( paste0( VandSigmaDirectory, "/E vs v.txt"), skip = 1, sep = "," ), ncol = 2, byrow = TRUE )

E.field.v.array <- mat[,1] * 1000 # in V/cm
v.array <- mat[,2] * 1e6 # in cm/s

drift.speed <- approx( E.field.v.array, v.array, E.drift )$y
drift.speed / 1e6 # cm / s


mat <- matrix( scan( paste0( VandSigmaDirectory, "/E vs Sigma.txt"), skip = 1, sep = "," ), ncol = 2, byrow = TRUE )

E.field.sigma.array <- mat[,1] * 1000 # in V/cm
sigma.array <- mat[,2] * 1e-6 # in cm/sqrt( cm )

sigma <- approx( E.field.sigma.array, sigma.array, E.drift )$y
sigma * 1e6 # microns / sqrt( cm )

