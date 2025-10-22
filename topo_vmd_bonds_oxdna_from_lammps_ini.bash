awk 'BEGIN{print "topo clearbonds"}/Bonds/{flag=1;next}flag && NF==4{print "topo addbond",$3-1,$4-1}' $1
