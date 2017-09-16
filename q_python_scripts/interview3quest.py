
from __future__ import print_function  # need this to allow print function to work with ()
from datetime import datetime
import os
import sys
import types

def main(args):
	A0 = dict(zip(('a','b','c','d','e'),(1,2,3,4,5)))
	A1 = range(10)
	A2 = sorted([i for i in A1 if i in A0])
	A3 = sorted([A0[s] for s in A0])
	A4 = [i for i in A1 if i in A3]
	A5 = {i:i*i for i in A1}
	A6 = [[i,i*i] for i in A1]
	print ("A0-->", A0)
	print ("A1-->", A1)
	print ("A2-->", A2)
	print ("A3-->", A3)
	print ("A4-->", A4)
	print ("A5-->", A5)
	print ("A6-->", A6)

	A1 = range(10)

	help(zip)
	
	f(2,[])		# [0, 1]
	f(3,[3,2,1])  	# [3, 2, 1, 0, 1, 4]
	f(3)			# [0, 1, 4]
	f(10)		# [0, 1, 4, 0, 1, 4, 9, 16, 25, 36, 49, 64, 81]

	# Monkey patching - changing the behaviour of a function from what it was initially designed to do
	
def f(*args,**kwargs)
	print(args, kwargs)

	l = [1,2,3]
	t = (4,5,6)
	d = {'a':7,'b':8,'c':9}

def f(x,l=[]):
    for i in range(x):
        l.append(i*i)
    print(l)

if __name__ == '__main__':

	print ('Start of dict.py at.....', format(str(datetime.now())))
	main(sys.argv[1:])	
	print ('End of dict.py at.....', format(str(datetime.now())))

# Start of dict.py at {}..... 2017-04-24 13:06:03.310000
# A0--> {'a': 1, 'c': 3, 'b': 2, 'e': 5, 'd': 4}
# A1--> [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
# A2--> []
# A3--> [1, 2, 3, 4, 5]
# A4--> [1, 2, 3, 4, 5]
# A5--> {0: 0, 1: 1, 2: 4, 3: 9, 4: 16, 5: 25, 6: 36, 7: 49, 8: 64, 9: 81}
# A6--> [[0, 0], [1, 1], [2, 4], [3, 9], [4, 16], [5, 25], [6, 36], [7, 49], [8, 64], [9, 81]]
