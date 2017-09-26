#! /usr/bin/env python
from __future__ import print_function

import os
import sys
from datetime import datetime

def main(args):
	pass
	arr = ['marko', 'djukic']
	firstname, surname = arr
	print ("firstname, surname --> %s %s" % (firstname, surname) )

if __name__ == '__main__':
	print ('Start of XXXX.py at.....', format(str(datetime.now())))
	main(sys.argv[1:])	
	print ('End of XXXX.py at.....', format(str(datetime.now())))


#! /usr/bin/env python

#from __future__ import print_function
#import os
#import sys
#from datetime import datetime

def main(args):
	pass
	arr = ['marko2', 'djukic2']
	firstname, lastname = arr
	print("firstname, lastname --> %s %s" %(firstname, lastname))

if __name__ == '__main__':
	print('Start2 of XXXX.py at.....', format(str(datetime.now())))
	main(sys.argv[1:])
	print('end2 of XXXXX.py at.....' , format(str(datetime.now())))

	