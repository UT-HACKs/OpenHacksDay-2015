import numpy as np
import pylab as pl
import sys
argvs = sys.argv
argc = len(argvs)
if (argc != 2):
    print "not collect"
    quit()

data = np.loadtxt(argvs[1])
pl.plot(data[:,0],data[:,1],'ro')
pl.xlabel("x")
pl.ylabel("y")
pl.show()
