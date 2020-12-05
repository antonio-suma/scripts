import numpy as np
import sys, os
import scipy.stats as st



points=np.loadtxt(sys.argv[1])
outfile=sys.argv[2]
x=points[:,0]
y=points[:,1]

xmin=np.min(x)
ymin=np.min(y)
xmax=np.max(x)
ymax=np.max(y)


values = np.vstack([x, y])
kernel = st.gaussian_kde(values)

gridsize = 30
g_x = np.linspace(xmin, xmax, gridsize)
g_y = np.linspace(ymin, ymax, gridsize)


with open(outfile,'w') as out:
    for i in range(len(g_x)):
        for j in range(len(g_y)):
                out.write("%f %f %f\n" % (g_x[i],g_y[j],kernel(np.array([g_x[i],g_y[j]]))))
