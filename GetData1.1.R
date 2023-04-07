#file=file.choose()
con=file(file,"rb")
#seek(con, where = 0, origin = "end")
#n=seek(con, where = 0, origin = "start")/8

Madc=NULL  	# adc array
Mt = NULL	# time array
Mch= NULL	# channel array

#vlgttccccxxxxxxx
#  0123456789ABCD 
res=readBin(con, raw(),  n = 2, size=1)  #read the first 2 bytes: version and buffer size
resI=as.integer(res)
VERSION=resI[1]/10   #version 1.0
sizeBuffer=resI[2]   #should be 14 in version 1.0   and 22 in version 1.1

if (VERSION == 1.0){
    res=readBin(con, raw(),  n = sizeBuffer, size=1)
    resI=as.integer(res)
    gainIndex=resI[1]
    threshold=resI[2]*256+resI[3]	#default is 240
} else 

if (VERSION == 1.1){
    res=readBin(con, raw(),  n = sizeBuffer, size=1)
    resI=as.integer(res)
#    if (resI[1] > 15){
#      print("First byte of header should be 15 or less")
#      break()
#    }

    #gttccccrsssslliiiffddn     The complete header contains 2+22=24 bytes
    #1234567890123456789012
    gainIndex=resI[1]%%8    #0000nggg  1 bit for neighbor and 3 bits for gain
    neighbor.ON = (as.integer(resI[1]/8))== 1    # TRUE or FALSE
    threshold=resI[2]*256+resI[3]	#default is 240
    ram <- resI[8]
    epochTime=0        # time since 1/1/2000 in seconds according to pyboard clock
    for (i in 0:3){
      epochTime = epochTime*256+resI[i+9]
    }
    runLength=resI[13]*256+resI[14]	#in seconds
    current=0
    for (i in 0:2){
      current = current*256+resI[i+15]
    } # current in nA
    flow=resI[18]*256+resI[19]	#in ccm
    dac=resI[20]*256+resI[21]	#for test pulses
    channelIncrement=resI[22]	#for test pulses, a number between 1 and 64
} else {
    print("VERSION is incorrect")
    break()
}


#cnt should be at position 3 in the header
cnt=0
for (i in 0:3){
  cnt= cnt*256+resI[i+4]
}

gains=c(0.5,1,3,4.5,6,9,12,16)
gain = gains[gainIndex+1]

cat('file: ',file,'\n')
cat('VERSION: ',VERSION*1.0,'\n')
cat('gain: ',gain,'\n')
cat('threshold: ',threshold,'\n')
cat('count: ',cnt,'\n')

vmm.array <- NULL
ch.array <- NULL
for (i in 1:cnt) {
  res=readBin(con, raw(),  n = 8, size=1)   #read a hit
  val=as.integer(res)
  vh=val[1]*256*256*256+val[2]*256*256+val[3]*256+val[4]
  cc=bitwAnd(as.integer(vh/2^4), 0x7ffffff)    #clockcounter: 27 bits
  vmm=as.integer(val[1]/2^7)     #vmm =0 or 1: 1 bit
  bcid_high=bitwAnd(val[4], 0x0F)		
  vl=val[7]*256+val[8]
  adc=bitwAnd(as.integer(vl/2^6),0x03ff)	#adc: peak amplitude  10 bits
  ch = bitwAnd(val[8], 0x03f)			#ch: 6 bit channel -- 0-63
  tdc=bitwAnd(as.integer(val[6]),0x0FF) 	#tdc: fine timestamp 8 bits
  bcid_low=bitwAnd(as.integer(val[5]), 0x0FF) 
  bcid=bcid_high*256+bcid_low			#bcid: coarse timestamp 12 bits
  
  #    if ((bcid > 0) & (tdc > 0)){
  #tchip = (ClockCounter*4096 + BCID) ? 25 ns + (1.5 ? 25 ns - TDC ? 60 ns /255 ) .
  tchip=(cc*4096+bcid)*25+(1.5*25 -tdc*60.0/255.0)	#time of peak of hit
  channel=(vmm)*64+ch					# 7 bit channel: 0-127
  Madc=c(Madc,adc)
  Mt=c(Mt,tchip)
  #      Mch =c(Mch, channel)
  
  vmm.array <- c( vmm.array, vmm )
  ch.array <- c( ch.array, ch )
  #    }
#  cat(i,' vmm:',vmm,' ch:',ch,' channel:',channel,' adc:',adc,' cc:',cc,' bcid:',bcid,' tdc:',tdc,' tchip:',tchip,'\n')
}

Mch <- vmm.array * 0
for( i in 1:(length( vmm.array )-1) ) { # Last hit is going to be messed up
  Mch[i] <- vmm.array[i+1] * 64 + ch.array[i]
}

close(con)

