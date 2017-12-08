
from __future__ import print_function  # need this to allow print function to work with ()
from datetime import datetime
import os
import sys

def main(args):
	print_directory_contents2("C:\\Users\\mdjuk")

def print_directory_contents(sPath):
    for sChild in os.listdir(sPath):                
        sChildPath = os.path.join(sPath,sChild)
        if os.path.isdir(sChildPath):
            print_directory_contents(sChildPath)
        else:
            print(sChildPath)

def print_directory_contents2(sPath):
	for sChild in os.listdir(sPath):
		sChildPath = os.path.join(sPath, sChild)
		print ("sChild-->", sChild)
		print ("sChildPath-->", sChildPath)
		if os.path.isdir(sChildPath):
			print (sChildPath)
		else:
			print (sChildPath)

if __name__ == '__main__':

	print ('Start of dict.py at {}.....', format(str(datetime.now())))
	main(sys.argv[1:])	
	print ('End of dict.py at {}.....', format(str(datetime.now())))
