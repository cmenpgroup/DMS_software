#file=file.choose()
con=file(file,"rb")
#seek(con, where = 0, origin = "end")
#n=seek(con, where = 0, origin = "start")/8

Madc=NULL  	# adc array
Mt = NULL	# time array
Mch= NULL	# channel array

res=readBin(con, raw(),  n = 8, size=1)
resI=as.integer(res)
nch = resI[1]   #channel increment for pulse mode.  Default is 1.
pulse=resI[2]	#1: pulse	0: no pulse	Default is 1
threshold=resI[3]*256+resI[4]	#default is 300
dac=resI[5]*256+resI[6]		#pulse amplitude.  Default is 300
cnt=resI[7]*256+resI[8]		#Number of hits.  Range is 1-1023

while( !is.na( nch ) ) {
  
  cat('file: ',file,'\n')
  cat('threshold: ',threshold,'\n')
  cat('count: ',cnt,'\n')
  
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
    
    #tchip = (ClockCounter*4096 + BCID) ? 25 ns + (1.5 ? 25 ns - TDC ? 60 ns /255 ) .
    tchip=(cc*4096+bcid)*25+(1.5*25 -tdc*60.0/255.0)	#time of peak of hit
    channel=vmm*64+ch					# 7 bit channel: 0-127
    Madc=c(Madc,adc)
    Mt=c(Mt,tchip)
    Mch =c(Mch, channel)
  }
  print(readBin(con, raw(),  n = 8, size=1)) 
  
  res=readBin(con, raw(),  n = 8, size=1)
  resI=as.integer(res)
  nch = resI[1]   #channel increment for pulse mode.  Default is 1.
  pulse=resI[2]	#1: pulse	0: no pulse	Default is 1
  threshold=resI[3]*256+resI[4]	#default is 300
  dac=resI[5]*256+resI[6]		#pulse amplitude.  Default is 300
  cnt=resI[7]*256+resI[8]		#Number of hits.  Range is 1-1023
  
}
# End of event.  The next 8 bytes should all be 0xFF
close(con)

#if (pulse){
#  title=paste(nch, threshold, dac, cnt, sep=' ')
#}else{ 
#  title=paste('thresh =',threshold,'count =', cnt, "\n", file, sep='   ')
#}

