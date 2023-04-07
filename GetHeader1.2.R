#file=file.choose()
con=file(file,"rb")
#seek(con, where = 0, origin = "end")
#n=seek(con, where = 0, origin = "start")/8

res=readBin(con, raw(),  n = 2, size=1)  #read the first 2 bytes: version and buffer size
resI=as.integer(res)
VERSION=resI[1]/10   #version 1.0
sizeBuffer=resI[2]   #should be 14 in version 1.0   and 22 in version 1.1

if (VERSION == 1.0) {
  #vlgttccccxxxxxxx
  #  123456789ABCDE 
  res=readBin(con, raw(),  n = sizeBuffer, size=1)
  resI=as.integer(res)
  gainIndex=resI[1]
  threshold=resI[2]*256+resI[3]	#default is 240
  for (i in 0:3) {
    cnt= cnt*256+resI[i+4]
  }
  
} else if (VERSION == 1.1) {
  res=readBin(con, raw(),  n = sizeBuffer, size=1)
  resI=as.integer(res)
  if (resI[1] > 15) {
    print("First byte of header should be 15 or less")
#    break
  }
  
  #gttccccrsssslliiiffddn     The complete header contains 2+22=24 bytes
  #1234567890123456789012
  gainIndex=resI[1]%%8    #0000nggg  1 bit for neighbor and 3 bits for gain
  neighbor.ON = (as.integer(resI[1]/8))== 1    # TRUE or FALSE
  threshold=resI[2]*256+resI[3]	#default is 240
  ram =resI[8]
  epochTime=0        # time since 1/1/1970 in seconds according to pyboard clock
  for (i in 0:3){
    epochTime = epochTime*256+resI[i+9]
  }
  runLength=resI[13]*256+resI[14]	#in seconds
  current=0
  for (i in 0:2){
    current = current*256+resI[i+15]
  }
  flow=resI[18]*256+resI[19]	#in ccm
  dac=resI[20]*256+resI[21]	#for test pulses
  channelIncrement=resI[22]	#for test pulses, a number between 1 and 64
  for (i in 0:3) {
    cnt= cnt*256+resI[i+4]
  }
  
} else if (VERSION == 1.2) {
  res=readBin(con, raw(),  n = sizeBuffer, size=1)
  resI=as.integer(res)
  if (resI[1] > 15) {
    print("First byte of header should be 15 or less")
#    break
  }
  
  #gttcccllssssiiiffrddnz     The complete header contains 2+22=24 bytes
  #1234567890123456789012
  gainIndex=resI[1]%%8    #0000nggg  1 bit for neighbor and 3 bits for gain
  neighbor.ON = (as.integer(resI[1]/8))== 1    # TRUE or FALSE
  threshold=resI[2]*256+resI[3]	#default is 240
  ram =resI[18]
  epochTime=0        # time since 1/1/1970 in seconds according to pyboard clock
  for (i in 0:3) {
    epochTime = epochTime*256+resI[i+9]
  }
  runLength=resI[7]*256+resI[8]	#in seconds
  current=0
  for (i in 0:2){
    current = current*256+resI[i+13]
  }
  flow=resI[16]*256+resI[17]	#in ccm
  dac=resI[19]*256+resI[20]	#for test pulses
  channelIncrement=resI[21]	#for test pulses, a number between 1 and 64
  #cnt should be at position 3 in the header
  cnt=0
  for (i in 0:2) {
    cnt= cnt*256+resI[i+4]
  }
} else {
  print("VERSION is incorrect")
#  break
}

close(con)

gains=c(0.5,1,3,4.5,6,9,12,16)
gain = gains[gainIndex+1]

cat('File name: ',file,'\n')
cat('Version: ',VERSION*1.0,'\n')
cat('Gain(mV/fC): ',gain,'\n')
cat('Threshold: ',threshold,'\n')
cat('Total count: ',cnt,'\n')
cat('Run Length(sec): ',runLength/1000.0,'\n')
cat('Neighbors logic: ',neighbor.ON,'\n')
cat('RAM (kB): ',ram,'\n')
cat('Current(uA): ',current/1000.0,'\n')
cat('Flow(ccm): ',flow,'\n')

