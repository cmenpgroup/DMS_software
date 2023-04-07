# R script to set up the directories 

setwd( "/Users/wood5/LDM/RMD/DMS_software/" )

program.root <- getwd()
data.root <- paste0(program.root,"/DMS Data")
plot.root <- paste0(program.root,"/DMS Plots")
stats.root <- paste0(program.root,"/DMS Stats")
neutron.root <- paste0(program.root,"/NeutronAnalysis")

PathIsSet <- TRUE

print(paste0("The working directory is ", program.root))