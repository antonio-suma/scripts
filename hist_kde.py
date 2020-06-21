import numpy as np
from scipy.stats import gaussian_kde
import sys

data=np.loadtxt(sys.argv[1])
#delta=float(sys.argv[3])

print(data)

# KDE instance
g_kde = gaussian_kde(dataset=data) #,bw_method=0.5)
#,bw_method=0.55

# compute KDE
gridsize = 20
g_x = np.linspace(0, np.max(data), gridsize)
g_kde_values = g_kde(g_x)
#g_kde_values=g_kde_values/np.max(g_kde_values)

np.savetxt(sys.argv[2],np.stack((g_x,g_kde_values), axis=-1))

