#!/bin/env python
'''
from __future__ import print_function
from datetime import datetime

import os
import sys
import types

def main(args):
 	pass


if __name__ == '__main__':

	print ('Start of XXXX.py at.....', format(str(datetime.now())))
	main(sys.argv[1:])	
	print ('End of XXXX.py at.....', format(str(datetime.now())))	


'''
###

from __future__ import print_function
import os
import sys
from datetime import datetime

def main(args):
	# reverse a string
	a = "markodjukic"
	print('1. Reversing a sting-->', a, "-->", a[::-1])
	
	# transposing a matrix
	mat = [[1,2,3], [4,5,6]]
 	print('2. Transposing a matrix-->', mat, "-->", zip(*mat) )

 	# store all 3 values of the list in 3 new variables
 	a = [1,2,3]
 	x, y, z = a
 	print("x-->", x, "y-->", y, "z-->", z)

 	# create a single string from all the elements in the list above
 	a = ["Code", "mentor", "Python", "Developer"]
 	print (" ".join(a) )

 	# write python code to print
 	list1=['a', 'b', 'c', 'd']
 	list2=['p', 'q', 'r', 's']
 	for x, y in zip(list1, list2):
 		print (x,y)

 	# swap two numbers with one line of code
 	a = 7
 	b = 5
 	print('Before swap-->', 'a-->', a, 'b-->', b)
 	b, a = a, b
 	print('After swap-->', 'a-->', a, 'b-->', b)

 	# print "codecodecodecode mentormentormentormentormentor" without using loops
 	print("code"*4 +' '+ "mentor"*5)

 	# Convert the following list to a single list without using any loops 
 	a = [[1,2], [3,4], [5,6]]
 	# result: [1, 2, 3, 4, 5, 6]
 	import itertools
 	print(list(itertools.chain.from_iterable(a)))

 	# taking a string input - need to run this via REPL, and enter input
 	result = map(lambda x:int(x) ,raw_input().split())
 	print(result)

 	

if __name__ == '__main__':
	print('Start of script 10PythonTricks-->', format(str(datetime.now())))
	main(sys.argv[1:])
	print('End of script 10PythonTricks-->', format(str(datetime.now())))

