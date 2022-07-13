#!/bin/bash
#act on xy coordinates
#args lammpsfile Nrowx Nrowy


SCRIPT=$(realpath "$0")
SCRIPTPATH=$(dirname "$SCRIPT")


if [[ $# -ne 3 ]]; then
    echo "Illegal number of parameters" >&2
    exit 2
fi


#check if voro++ is compiled and inside the library
if ! command -v voro++ &> /dev/null
then
    echo "voro++ could not be found"
    exit
fi

lammpsfile=$1
Nrowx=$2
Nrowy=$3


n_beads=$(awk 'NR==4{print}' $lammpsfile)
sizex=$(awk 'NR==6{print $2-$1}' $lammpsfile)
sizey=$(awk 'NR==7{print $2-$1}' $lammpsfile)

echo $n_beads $sizex $sizey

rm -f tmp

#prepare conf for voro++
awk -v Nrowx=$Nrowx -v Nrowy=$Nrowy 'BEGIN{i=1}NR>=10{print i,$Nrowx,$Nrowy,0;i++}' $lammpsfile > tmp

#elaborate with voro++
voro++ -c "%i %x %y %v %n" -o -px -py -g  0 $sizex 0 $sizey 0.00 0.01 tmp

#reconstruct hexatic
awk < tmp.vol -v Lx=$sizex -v Ly=$sizey 'BEGIN{PI = atan2(0, -1)}

{

        x[$1]=$2;
        y[$1]=$3;
	V[$1]=$4;  #volume of cell
        #ro[$1]=PI/4./$4;
        nfield[$1]=NF;
        for(i=5;i<=NF;i++)neigh[$1,i]=$i;
        npart++;

}

END{

        for(i=1;i<=npart;i++){

                k=0;
                psi_re=0;
                psi_im=0;
                for(j=5;j<=nfield[i];j++){

                        if(neigh[i,j]>=0){

                                dx=x[neigh[i,j]]-x[i]
                                dy=y[neigh[i,j]]-y[i]
#                               bc
                                if(dx>Lx/2.) dx=dx-Lx
                                if(dx<-Lx/2.) dx=dx+Lx
                                if(dy>Ly/2.) dy=dy-Ly
                                if(dy<-Ly/2.) dy=dy+Ly
                                ### calcoliamo angolo tra -180 e 180 usando atan2 (vanno prese direzioni normalizzate!!) ###            
                                dist=sqrt(dx**2+dy**2)
                                alpha=atan2(dy/dist,dx/dist)
                                if(alpha<0) alpha+=2*PI
                                psi_re+=cos(alpha*6.)
                                psi_im+=sin(alpha*6.)
                                k++
#                               print i,x[i],y[i],neigh[i],dist,cosalpha,alpha,k,psi_re,psi_im

                        }

                }

                psi_re=psi_re/k
                psi_im=psi_im/k
                print i,x[i],y[i],V[i],psi_re,psi_im,sqrt(psi_re*psi_re+psi_im*psi_im)

        }

}'  > tmp.hexatic


