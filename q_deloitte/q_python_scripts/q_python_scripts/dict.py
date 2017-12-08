
from __future__ import print_function  # need this to allow definition of SITE & EXPECTED


import os
import sys
from datetime import datetime
from urllib2 import urlopen


#SITE = os.environ['site'] # URL of the site to check, stored in the site environment variable
#EXPECTED = os.environ['expected'] # String expected to be on the page, stored in the expected variable

def main(args):
	
	# '''
	# try:

	# except Exception as e:
	# 	raise
	# else:
	# 	pass
	# finally:
	# 	pass

	# Associating list elements
	# also know as an associative array, ie. key/value pairs

	# Dictionaries are the final type of data container available in Python.
	# In summary, the various types are:
	# Variable - stores a single value
	# List - stores multiple values in an ordered index
	# Tuple - stores multiple fixed values in a sequence
	# Set - stores multiple unique values in an unordered collection
	# Dictionary - stores multiple unordered key:value pairs	

	# '''
	# initialize a dictionary they display its key:value contents
	dict = {'name':'Bob', 'ref':'Python', 'sys':'Win'}
	print ('Dictionary:', dict )

	# next, display a single value referenced by its key
	print ('\nReference:-->', dict['ref'] )
	print ('\n')

	# delete one pair from the dictionary and add a replacement pair then display the new key:value contents
	del dict['name']
	dict['user'] = 'Tom'
	print ('Dictionary:', dict )
	
if __name__ == '__main__':
		print ('Start of dict.py at {}.....', format(str(datetime.now())))
		main(sys.argv[1:])	
		print ('End of dict.py at {}.....', format(str(datetime.now())))