#!/bin/env python

from __future__ import print_function  # need this to allow definition of SITE & EXPECTED


import os
import sys
from datetime import datetime
import json
from pprint import pprint
from collections import OrderedDict

def main(args):
	

	# Reading data back
	###filename = 'C:\Users\mdjuk\q_python_scripts\data.json' 
	filename = 'C:\Users\mdjuk\q_python_scripts\data_ec2_instances.json'
	with open(filename, 'r') as f:
	     data = json.load(f)

	#content = json.loads(data, object_pairs_hook=OrderedDict)

	# # resp = json.loads(data.read().decode('utf-8'))	
	# pprint(resp)

	pprint(data)
	print("")

	content = json.dumps(data, indent=4)
	print("content-->", content)

	# Writing JSON data
	###filename_out = 'C:\Users\mdjuk\q_python_scripts\data_out.json'
	###with open(filename_out, 'w') as f:
	###   json.dump(data, f)

	print("data.keys-->", data.keys())

	###col = ['objects', 'parameters', 'values']
	col = list(data)
	print("col-->", col)
	for row in col:
	 	print("row-->", row)
	 	for item in data[row]:
	 		print("row-->item-->%s --> %s" %(row, str(item)))
	 		

	###print("objects-->scheduleType-->", data['objects'][col.index('objects')]['scheduleType'])
	###print("parameters-->id-->",        data['parameters'][col.index('parameters')]['id'])
	print("Reservations-->ReservationId-->",        data['Reservations'][col.index('Reservations')]['ReservationId'])

	# Reading data back
	###filename_out = 'C:\Users\mdjuk\q_python_scripts\data_out.json'
	###with open(filename_out, 'r') as f:
	###	data = f.read() 
	###     data = json.load(f)

	# # resp = json.loads(data.read().decode('utf-8'))	
	# pprint(resp)


	#data = [x.strip() for x in data]
	###pprint(data)
	


if __name__ == '__main__':
		print ('Start of dict.py at-->' + format(str(datetime.now())))
		main(sys.argv[1:])
		print ('\nEnd of dict.py at-->' + format(str(datetime.now())))

# 1
# dict.clear()
# Removes all elements of dictionary dict
# 2
# dict.copy()
# Returns a shallow copy of dictionary dict
# 3
# dict.fromkeys()
# Create a new dictionary with keys from seq and values set to value.
# 4
# dict.get(key, default=None)
# For key key, returns value or default if key not in dictionary
# 5
# dict.has_key(key)
# Returns true if key in dictionary dict, false otherwise
# 6
# dict.items()
# Returns a list of dict's (key, value) tuple pairs
# 7
# dict.keys()
# Returns list of dictionary dict's keys
# 8
# dict.setdefault(key, default=None)
# Similar to get(), but will set dict[key]=default if key is not already in dict
# 9
# dict.update(dict2)
# Adds dictionary dict2's key-values pairs to dict
# 10
# dict.values()
# Returns list of dictionary dict's values