awk 'BEGIN{ i=0;}{
	if(NR==1){min=$1;max=$1}
	if($1<=min)min=$1;
 	if($1>=max)max=$1;
 	data[i]=$1; #memorizza dati
 	i++;
 }
END{
        ndata=i;
        nbins=int(ndata**(1/3.));
        #facciamo un istogramma simmetrico
        largh_bin=(max-min)/nbins;   #print min,max,largh_bin,nbins,(max-min);
        for(j=0;j<=nbins;j++){
                hist[j]=0;
        }
        for(j=0;j<ndata;j++){
                hist[int((data[j]-min)/largh_bin)]++;
                #print data[j],data[j]-min,int((data[j]-min)/largh_bin),hist[int((data[j]-min)/largh_bin)];
        }
        for(j=0;j<=nbins;j++){
                print j*largh_bin+min+largh_bin/2.0,hist[j]/(ndata*largh_bin);
        }

}' 

