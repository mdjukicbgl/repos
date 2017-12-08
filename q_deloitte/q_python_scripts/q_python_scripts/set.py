
from __future__ import print_function  # need this to allow definition of SITE & EXPECTED
from datetime import datetime
import os
import sys

def main(args):
	
	print ('Start of set.py at {}.....', format(str(datetime.now())))

	# Set methods					Description
	# -------------------------------------------------------------------------------------
	# set.add(x)					Adds item x to the set
	# set.update(x,y,z)			Adds multiple items to the set
	# set.copy()					Returns a copy of the set
	# set.pop()					Removes one random item from the set
	# set.discard(l)				Removes item at position l from the set
	# set1.intersection(set2)		Returns itens that appear in both sets
	# set1.difference(set2)		Returns items in set1, but NOT in set2

	# The type() function can be used to ascertain these lists data structure classes 
	# and Python built-in membership operator 'in' can be used to find values in a set
	

	# initialize a tuple then display its contents, length, and type
	zoo = ('Kangaroo', 'Leopard', 'Moose')
	print ('Tuple', zoo, '\tLength:', len(zoo) )
	print ('Type:',  type(zoo) )


	# Now, initialize a set and add anoter element, then display its contents, length, and type
	bag = {'Red', 'Green', 'Blue'}
	bag.add('Yellow')
	print ('\nSet:', bag, '\tLength', len(bag) )
	print ('Type:',  type(bag) )
	#bag.pop()
	#print '\nSet:', bag, '\tLength', len(bag)

	# Now add two statements to seek two values in the set
	print ('\nIs Green in bag Set?:', 'Green' in bag )   # this will return True or False
	print ('\nIs Orange in bag Set?:', 'Orange' in bag  ) # this will return True or False

	# Finally, initialize a second set and display its contents, length, and all common values found in both sets
	box = {'Red', 'Pruple', 'Yellow'} 
	print ('\nSet:', box , '\t\tLength', len(box) )
	print ('Common in both Sets:', bag.intersection(box) )
	print ('Difference in both Sets:', bag.difference(box) )


	s3_pemfile = 'markodmarkod'
	s3_pemfile = s3_pemfile.replace('markod', 'kkkkk',0)
 	print ('s3_pemfile-->', s3_pemfile)


	mdj1 = '/%s/dir/name/goes/here/%s' % (s3_pemfile, box)
    

	print ('mdj1--> ', mdj1 )


	# '''
	# scope = ['https://spreadsheets.google.com/feeds']
	# s3_encrypted_bucket = 'economist-analytics-euw1-encrypted'
	# s3_pemfile = '%s/google/ga_serviceaccount_tegdatawarehouse.json' % (bigdataconfig.roleenv.replace('tst','dev'))
	
	print ('Start of set.py at {}.....', format(str(datetime.now())))

if __name__ == '__main__':
		main(sys.argv[1:])


