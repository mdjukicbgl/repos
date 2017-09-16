# Returning values
# like python's built-in str() function, which returns a string
# representation of the value specified as its argument by the caller
# custom functions
from __future__ import print_function

import os
import sys
from datetime import datetime

def main(args):
	num = str(raw_input('Enter an Intger:') )
	result = squared(num)
	print('result-->', result)


def squared(num):

	if not num.isdigit():
		return('Invalid entry')

	num = int(num)
	return(num*num)



if __name__ == '__main__':
	print ('Start of return.py at.....', format(str(datetime.now())))
	main(sys.argv[1:])	
	print ('End of return.py at.....', format(str(datetime.now())))

##############
# typically a 'return' statement will appear at the end of a
# function block to return the final result of executing all statement s
# contained in that function


####
#Enter an Intger:g
#Traceback (most recent call last):
#  File "return2.py", line 29, in <module>
#    main(sys.argv[1:])	
#  File "return2.py", line 12, in main
#    num = str(input('Enter an Intger:') )
#  File "<string>", line 1, in <module>
#NameError: name 'g' is not defined
#
#***Repl Closed***
