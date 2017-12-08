#!/bin/env python

from __future__ import print_function
import sys

'''
sys.argv is a list of arguments. 
So when you execute your script without any arguments this list which you're accessing index 1 of is empty 
and accessing an index of an empty list will raise an IndexError.

With your second block of code you're doing a list slice and you're checking if the list slice 
from index 1 and forward is not empty then print your that slice of the list. 
Why this works is because if you have an empty list and doing a slice on it like this, the slice returns an empty list.
'''

def main(args):

	last_list = [1,2,3]
	if last_list[1:]:
		print('Frist block [1:]', last_list[1:] )
	#>> [2,3]

	empty_list = []
	print('First block [:1]', empty_list[:1] )
	#>> []

if __name__ == '__main__':
	main(sys.argv[1:])


