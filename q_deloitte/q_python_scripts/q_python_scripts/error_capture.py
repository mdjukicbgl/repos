
from __future__ import print_function
import json
import sys
from pprint import pprint

a = 2
b = 1

def main(args):
	divide(a,b)
	readjson()

def divide(x, y):
    try:
        result = x / y
    except ZeroDivisionError:
        print("except-->division by zero!")
    else:
        print("else-->result is", result)
    finally:
        print("finally-->executing finally clause_0")

#
# A finally clause is always executed before leaving the try statement, whether an exception has occurred or not.
# When an exception has occurred in the try clause and has not been handled by an except clause (or it has occurred in the 
# try except or else clause), it is re-raised after the finally clause has been executed.
# The finally clause is also executed 'on th eway out' when any other clause of the try statement is 
# left via a break, continue or return statement.
#
#from __future__ import print_function
#import json
def readjson():
	recs = []
	
	with open('C:\Users\mdjuk\q_json\data.json') as f:
		for line in f.readlines():
			recs.append(json.loads(line))
			
	
	for rec in recs:
		pprint(rec)
		print("print keys-->", rec.keys())
		print("print values-->", rec.values())		  


if __name__ == '__main__':
	main(sys.argv[1:])


	