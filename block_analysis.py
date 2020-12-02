#pip install pyblock
#pip install pandas

import numpy as np
import pyblock
import sys

#def corr_data(N, L):
#    '''Generate random correlated data containing 2^N data points.
#    Randon data is convolved over a 2^L/10 length to give the correlated signal.'''
#    return np.convolve(np.random.randn(2**N), np.ones(2**L)/10, 'same')
#rand_data = corr_data(16, 6)
#
#mu=0
#sigma=1.
#rand_data=np.random.normal(mu, sigma, 10000000)

rand_data=np.loadtxt(sys.argv[1])
printarg=int(sys.argv[2])

ndata=len(rand_data)

reblock_data = pyblock.blocking.reblock(rand_data)

#0 block number
#1 num data (dopo aver fatto block transf) quindi ndatainiziali/#1=#nblock
#2 mean array
#3 cov
#4 std_err
#5 std_err_err

if printarg==1:
    for reblock_iter in reblock_data:
        #print(reblock_iter)
        print(ndata/reblock_iter[1],reblock_iter[1],ndata,reblock_iter[4],reblock_iter[5],reblock_iter[4]**2*ndata)
if printarg==0:
    opt = pyblock.blocking.find_optimal_block(len(rand_data), reblock_data)
    ##print(opt)
    print(reblock_data[opt[0]][4]**2*ndata)
