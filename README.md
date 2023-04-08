# DMS_software
R scripts for analyzing the Oxy GEM measurements.  The GEM is a gas electron multiplier from CERN.  

The original software from Dr. Daniel Snowden-Ifft is in the main directory of DMS_software.  Here are descriptions of some original scripts:
- VMM_ACQ_v5.R : main analysis code.  It can analyze many files of the types Fe-55, neutron, and muon.  The neutron section is incomplete.
- measurement.r : contains many useful mathematical functions especially error analysis.
- LoadStats.R : reads in -stats.dat files and fills lists with data information.  The -stats.dat files are text files with filtered data from the raw binary data files.
- GetData*.R : scripts to read in a raw binary data file.  There are a few versions.
- GetFe55GasGain.R : determines the GEM gas gain from fitting the ADC spectrum from Fe55 calibration runs.
- GetHeader1.2.R : extracts file information.  

Files added to the DMS_software directory by Dr. Michael Wood
- SetUpPathDMS.R : script to be executed at the start of an analysis.  It sets up paths for the DMS_software directory as the working directory (as variable program.root), the raw binary data directory DMS_software/DMS Data (as variable data.root), the plots directory DMS_software/DMS Plots (as the variable plot.root), the filtered data diredctory DMS_software/DMS Stats (as varible stats.root), and the neutron analysis directory DMS_software/NeutronAnalysis (as variable neutron.root).

The analysis software for the neutron analysis is in the DMS_software/NeutronAnalysis directory.  It contains the following scripts.
- FilterStatsDMS.R : reads in a list of raw binary data files, filters out different information, and writes the information to text files in DMS_software/DMS Stats.  The filtered files rows for each event and columns of the information like ADC values, x and y information, etc.
- AnalyzeFe55.R : reads in filtered data for Fe55 calibration runs (*Fe55-stats.dat), plots the ADC spectrum, asks the user to select limits for a gaussian fit, and prints out the fit information.  The scripts loops over a list of filtered files, analyzes them on at a time, and makes a plot of the calibration results vs run number.
- AnalyzeNeutron.R : analysis code for the neutron data.  It will
    1) Analyze the neutron data files.  Sets the variable dataType = “neut”.
    2) Runs the script PlotNeutron.R.
      a) Run the script FileList.R to create a list of the file names.
      b) Loop over each file in the list.
      c) Run the script LoadStats.R to read in the data from the -stats.dat file.
      d) Fill lists for each variable (column in the file).
      e) Apply cuts to the adc data.
      f) Create a histogram for the adc data.
    3) Analyze the background data files. Sets the variable dataType = “back”.
    4) Runs the script PlotNeutron.R.  Same procedure as in Step 2.
    5) Create a background subtracted histogram by subtracting the background ADC spectrum from the neutron ADC spectrum.
    6) Plot the neutron ADC spectrum with overlaying the background ADC spectrum and the neutron minus background ADC spectrum.  
    7) Save the plot to a file.
- PlotNeutron.R : create a plot of ADC channel for neutron and background data
- FileList.R : create a list of file names.  It fills the list by using a pattern search on the dataType (Fe55, neut, or back).  It will remove bad files from the list.  

Currently, the SetUpPathDMS.R file is run by a few of the scripts in the DMS_software/NeutronAnalysis directory.  The location of that script is hard-coded as 

if(!exists("PathIsSet")) source("/Users/wood5/LDM/RMD/DMS_software/SetUpPathDMS.R")

The "PathIsSet" variable is set as TRUE in SetUpPathDMS.R.  The if statement with the exists() function is used to check if it has been set.  If it has not, then SetUpPathDMS.R is executed.  Since this script may be called by many different scripts in the chain, the conditional ensures that it is only called once. 

