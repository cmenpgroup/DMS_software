# R script to create the file list

if(!exists("PathIsSet")) source("/Users/wood5/LDM/RMD/DMS_software/SetUpPathDMS.R")

source( paste0(program.root,"/measurement.r" ))
# Set parameters
wire.spacing <- 0.16 # cm
drift.length <- 1.55 # cm

filenames <- list.files(paste0(data.root, "/"),pattern= paste0(dataType,".dat"))

badFiles <- NULL
badFiles <- c(badFiles,"DMS-20230318-17-0002-back")
badFiles <- c(badFiles,"DMS-20230318-13-0001-neut")
badFiles <- c(badFiles,"DMS-20230318-14-0001-neut")
#badFiles <- c(badFiles,"DMS-20230319-22-0002-neut")

filenames <- gsub(".dat","",filenames)
numFiles <- length( filenames )
print(filenames)
print(paste0("Full list of files ",numFiles," files"))

filenames <- filenames[filenames %in% badFiles == FALSE]
numFiles <- length( filenames )
print(filenames)
print(paste0("Analyze good files",numFiles," files"))