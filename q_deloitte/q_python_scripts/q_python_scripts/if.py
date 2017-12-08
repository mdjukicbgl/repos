
from __future__ import print_function  
from datetime import datetime
import os
import sys


def main(args):	


	# indentation of code within Python is very important, as it identifies code blocks to the interpreter
	# - other programming languages use braces

	# initialize a variable within user input of an integer value:
	num = int(input('Please Enter a number: '))
	# note that the input is read in as a string value by default, so must be cast as an int data type with int() for arithmetic comparisons


	# test the variable and display an apporpriate response:
	if num > 5 :
		print('Number exceeds 5-->', num)
	elif num < 5 :
		print('Number is less than 5-->', num)
	else :
		print('Number is 5')	


	# The and keyword ensures evaluation is True only when both tests succeed, whereas the or keyword ensures the evaluation is True when either test succeeds
	if num > 7 and num < 9 :
		print('Number returned should be 8-->', num)
	if num == 1 or num == 3 :
		print('Number returned shoudl either be 1 or 3-->', num)


if __name__ == '__main__':

	print ('Start of dict.py at {}.....', format(str(datetime.now())))
	main(sys.argv[1:])	
	print ('End of dict.py at {}.....', format(str(datetime.now())))
