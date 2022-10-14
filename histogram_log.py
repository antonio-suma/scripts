import numpy as np
import sys

### LOAD DATA ###
data=np.loadtxt(sys.argv[1])

min=np.min(data)
max=np.max(data)
ntot=len(data)
#print(min,max,ntot)

### MAKE HISTOGRAMS ###
bins = np.logspace(np.log(min), np.log(max), num=int((ntot-1)**(1/3)),base=np.exp(1))
#print(bins)
widths = (bins[1:] - bins[:-1])

exp_hist = list(np.histogram(data, bins=bins, density=True)[0])

exp_bins = list(bins)

#print(int((ntot-1)**(1/3)),len(exp_bins))


# Normalize by bin width, I am a bit unclear about this point since we are using logarithmic scaling bins
# exp_hist = np.array(exp_hist)/widths
# ising_hist = np.array(ising_hist)/widths

		
for i in range(len(exp_bins)-1):
	print(exp_bins[i],exp_hist[i])



#HOW TO COMPARE WITH POWER LAW GENERATED RANDOMLY TO CHECK
#https://stats.stackexchange.com/questions/173242/random-sample-from-power-law-distribution
#generate sample in bash
#awk 'BEGIN{x_min=1;alpha=2;for(i=0;i<100000;i++)print x_min * (1 - rand) ** (-1 / (alpha - 1))}'
#gnuplot
#x_min=1
#alpha=2
#p(x) = ((alpha - 1) / x_min) * (x / x_min) ** -alpha
#p p(x)


