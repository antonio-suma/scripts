#first argument $1 lammpstrj
#second argument $2 input file (for bonds)
#output file .xyz plus topo bond for vmd

#!/bin/bash
awk '{

if($2=="TIMESTEP")i=1
if(i==2){t=$1}
if(i==4){
	N=$1;
	print N*2
	print "TIMESTEP",t 
}
if(i>=10){
	#compute backbone and base
	myquat[0]=$6
	myquat[1]=$7
	myquat[2]=$8
	myquat[3]=$9
	mya1[0]=0
	mya1[1]=0
	mya1[2]=0
        quat_to_exyz(myquat,mya1)	
	printf("C %f %f %f\n",$3-0.4*mya1[0],$4-0.4*mya1[1],$5-0.4*mya1[2])
	printf("O %f %f %f\n",$3+0.4*mya1[0],$4+0.4*mya1[1],$5+0.4*mya1[2])
} 


i++
}

function quat_to_exyz(myquat,mya1)
{
    sqw = myquat[0]*myquat[0];
    sqx = myquat[1]*myquat[1];
    sqy = myquat[2]*myquat[2];
    sqz = myquat[3]*myquat[3];

    invs = 1 / (sqx + sqy + sqz + sqw)
    m00 = ( sqx - sqy - sqz + sqw)*invs ;
    m11 = (-sqx + sqy - sqz + sqw)*invs ;
    m22 = (-sqx - sqy + sqz + sqw)*invs ;

    tmp1 = myquat[1]*myquat[2];
    tmp2 = myquat[3]*myquat[0];
    m10 = 2.0 * (tmp1 + tmp2)*invs ;
    m01 = 2.0 * (tmp1 - tmp2)*invs ;

    tmp1 = myquat[1]*myquat[3];
    tmp2 = myquat[2]*myquat[0];
    m20 = 2.0 * (tmp1 - tmp2)*invs ;
    m02 = 2.0 * (tmp1 + tmp2)*invs ;
    tmp1 = myquat[2]*myquat[3];
    tmp2 = myquat[1]*myquat[0];
    m21 = 2.0 * (tmp1 + tmp2)*invs ;
    m12 = 2.0 * (tmp1 - tmp2)*invs ;

    mya1[0] = m00
    mya1[1] = m10
    mya1[2] = m20
    #mya3 = np.array([m02, m12, m22])

}' $1  > $1.xyz



awk 'BEGIN{print "topo clearbonds"}$2=="atoms"{natoms=$1}/Bonds/{flag=1;next}flag && NF==4{print "topo addbond",($3-1)*2,($4-1)*2;}END{for(i=0;i<natoms;i++)print "topo addbond",i*2,i*2+1; }' $2 > $1_bonds.vmd
