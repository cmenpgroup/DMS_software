# Cluster data

# The data Mt must be loaded before running this function
# The analysis variable cluster.gap in ns must be set before running this function.

sort.Mt <- sort( Mt )
stdcut <- c( TRUE, diff( sort.Mt ) > cluster.gap )
cluster.start.times <- sort.Mt[stdcut] # start of cluster in ns
cluster.start.times <- c( cluster.start.times, max( Mt ) + 1 )
number.of.clusters <- length( cluster.start.times ) # number of clusters
number.of.clusters
