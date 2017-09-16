
from __future__ import print_function  
from datetime import datetime
import os
import sys


def main(args):	

	print ('Start of dict.py at {}.....', format(str(datetime.now())))


	# initialize associative array with key:value pairs.....
	array = {'name': 'Marko', 'ref': 'Python', 'sys':'win'}

	# print out whole array.....
	print('Dictioary, key:value pairs-->', array) 

	# print a single value referenced by its key
	print('\nReference-->', array['ref'])

	# display all keys within the associative array.....dictionary
	print('\nAll Keys-->', array.keys())
	print('\nAll Values-->', array.values())

	# delete one pair from teh array and add a replacement pair then display th enew key:value contents
	del array['name']
	array['user'] = 'MARKO'
	print('Dictioary, key:value pairs-->', array) 

	# Next, see if there's a particular key in the associative array.....
	print('\nIs the name key present?-->', 'name' in array )

	# Next, see if there's a user key present....
	for a in ['name', 'user'] :

		print('\nIs the a key present?-->', 'a' in array )
		if a in array :
			print ('\nThis line will print if', a, 'key is present in array-->', array[a])
		else :	
			print('\nIs the name key present?-->', a in array )	

	print('\n')
	print ('End of dict.py at {}.....', format(str(datetime.now())))


if __name__ == '__main__':
		main(sys.argv[1:])


