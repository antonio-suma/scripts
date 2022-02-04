awk 'BEGIN{ i=0;}{
	hist[$1]++
 	i++;
 }
END{
        ndata=i;
        for(j in hist){
                print j,hist[j]/ndata
        }

}' | sort -g

