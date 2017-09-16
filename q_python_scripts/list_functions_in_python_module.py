
from __future__ import print_function  # need this to allow print function to work with ()
from datetime import datetime
import os
import sys
import types

print ('Start of dict.py at {}.....', format(str(datetime.now())))

#eg 1

n=0

for i in dir(os): 
	n +=1
	if isinstance(os.__dict__.get(i), types.FunctionType) :
		print ( n, '-->', i , '-->', types.FunctionType )  


#eg 2


# import types
# import os

# yourmodule = os

# print ( [(yourmodule.__dict__.get(a) for a in dir(yourmodule)
#   if isinstance(yourmodule.__dict__.get(a), types.FunctionType) ) ] )

print ('End of dict.py at {}.....', format(str(datetime.now())))
