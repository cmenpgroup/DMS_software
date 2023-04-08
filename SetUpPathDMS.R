# R script to set up the directories 

setwd( "/Users/wood5/LDM/RMD/DMS_software/" )

program.root <- getwd()
data.root <- paste0(program.root,"/DMS_Data")
plot.root <- paste0(program.root,"/DMS_Plots")
stats.root <- paste0(program.root,"/DMS_Stats")
neutron.root <- paste0(program.root,"/NeutronAnalysis")

PathIsSet <- TRUE

print(paste0("The working directory is ", program.root))
