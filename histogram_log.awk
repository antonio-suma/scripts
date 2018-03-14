# richiamare con awk  -f !!!!!
#!/usr/bin/awk

BEGIN{i=0;}{
	if(NR==1){min=$1;max=$1}
 	if($1<=min)min=$1;
 	if($1>=max)max=$1;

 data[i]=$1; #memorizza dati
 	 i++;
 
 #print data[i-1],min,max;
 }
END{
	max=max+(max-min)/1000000; 
	ndata=i;
	nbins=int((i-1)^(1/3));
	#termine che determina gli intervalli
	t=(max/min)^(1/nbins)
	#gestiamo i bins, la loro larghezza e inizio/fine con vettori
	for(i=0;i<=nbins;i++){
		pos_bin[i]=min*(t^i);
		largh_bin[i]=min*t^(i+1)-min*t^i;
		hist[i]=0;
	}

#	for(i=0;i<=nbins;i++){
#		k+=largh_bin[i]
#		print pos_bin[i],pos_bin[i+1],largh_bin[i],k,log(largh_bin[i]),log(pos_bin[i+1])-log(pos_bin[i]);
#	}

	for(j=0;j<=ndata;j++){
		for(i=0;i<=nbins;i++){
			if(data[j]>=pos_bin[i] && data[j]<pos_bin[i+1])hist[i]+=data[j];

#print data[j],int(data[j]/largh_bin),hist[int(data[j]/largh_bin)];
		}
	}
	#stampiamo il middle point in scala log invece del primo point
for(i=0;i<nbins;i++){
	#k+=hist[i]/(ndata);
print pos_bin[i]*(pos_bin[i+1]/pos_bin[i])^(1./2.),hist[i]/(ndata*largh_bin[i]);
}

}