#
# how to use sys.argv in python
# what is sys.argv?
#
# sys.argv is a list in python, which contains the command-line arguments passed to the script
#
# with the len(sys.argv) function, you can count the number of arguments
#
# If you are going to work with command line arguments, you probably want to use sys.argv
#
# to use sys.argv, you will first have to import the sys module
# 
# remember that sys.argv[0] is the name of the script
#
from __future__ import print_function
import sys
import os

print("This is the name of the script:",  sys.argv[0])
print("Number of arguments:", len(sys.argv))
print("Argumets are:", os.path.basename(str(sys.argv)) ) 


