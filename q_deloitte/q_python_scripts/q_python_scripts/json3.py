#!/bin/env python

from __future__ import print_function  # need this to allow definition of SITE & EXPECTED


import os
import sys
from datetime import datetime
import json
import ijson

#SITE = os.environ['site'] # URL of the site to check, stored in the site environment variable
#EXPECTED = os.environ['expected'] # String expected to be on the page, stored in the expected variable

def main(args):
		
	filename = "mdj_dict.json"

	# the col in columns will return: objects, values, parameters
	
	column_names = ['objects', 'parameters', 'values']
	#with open(filename, 'r') as f:
		#columns = list(f)
	#	for col in f:   #columns:
			#print("\ncol-->", column_names) 
	#		list(column_names).append(col)


	print("\ncolumn_names-->", column_names) 

	with open(filename, 'r') as f:
    	#objects = ijson.items(f, 'meta.view.columns.item')
		objects = ijson.items(f, 'objects.item')
		columns = list(objects)
		print("columns-->", columns)

		



if __name__ == '__main__':
		print ('Start of dict.py at-->' + format(str(datetime.now())))
		main(sys.argv[1:])
		print ('\nEnd of dict.py at-->' + format(str(datetime.now())))

	
	