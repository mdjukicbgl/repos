from __future__ import print_function

import os
from  fnmatch import *

print("-"*100)	
print("-- start of os output.....")
print("-"*100)	
for i in dir(os):
	print("os available functions-->" + i)

for i in dir(fnmatch):
	print("fnmatch available functions-->" + i)

for i in dir(__builtins__) :
	print("builtins available functions-->" + i)

print("-"*100)	

Matching Patterns
Teh pytjon 're' module cab be imported into a program to make use of Regular Expressions that describe