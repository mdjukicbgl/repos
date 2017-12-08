# Returning values
# like python's built-in str() function, which returns a string
# representation of the value specified as its argument by the caller
# custom functions
from __future__ import print_function

import os
import sys
from datetime import datetime

def main(args):
	total = sum1(18, 5)
	print ('Eight plus five =', total)		

def sum(a, b):
	return(a + b)

def sum1(a, b):
	if a < 10:
		return

	return(a+b)

if __name__ == '__main__':
	print ('Start of return.py at.....', format(str(datetime.now())))
	main(sys.argv[1:])	
	print ('End of return.py at.....', format(str(datetime.now())))

##############
# typically a 'return' statement will appear at the end of a
# function block to return the final result of executing all statement s
# contained in that function
