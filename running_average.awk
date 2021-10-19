#to use: awk -vn=nblocks -f running_average.awk
#if you use integers, you can print round(a[j]) instead of a[j]

BEGIN {
    m=int((n+1)/2)
}
{L[NR]=$2; sum+=$2}
NR>=m {d[++i]=$1}
NR>n {sum-=L[NR-n]}
NR>=n{
    a[++k]=sum/n
}
END {
    for (j=1; j<=k; j++)
        print d[j],a[j]
        #print d[j],round(a[j])
}
function round(x, ival, aval, fraction)
{
   ival = int(x)    # integer part, int() truncates

   # see if fractional part
   if (ival == x)   # no fraction
      return ival   # ensure no decimals

   if (x < 0) {
      aval = -x     # absolute value
      ival = int(aval)
      fraction = aval - ival
      if (fraction >= .5)
         return int(x) - 1   # -2.5 --> -3
      else
         return int(x)       # -2.3 --> -2
   } else {
      fraction = x - ival
      if (fraction >= .5)
         return ival + 1
      else
         return ival
   }
}
