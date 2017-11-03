#!/usr/bin/env  python

from __future__ import print_function
from Bird2 import *

print("\nClass instance Of:\n", Bird2.__doc__)

# add a statement to create an instance of the class and pass a
# string argument value to its instance variable

polly = Bird2("Squark, Squark!")

# now, display this instance variable value and call the class 
# method to display the common class variable value
print("\nNumber of Birds:", polly.count)
print("Polly says:", polly.get_chat())

# create a second instance of the class, passing different string args
harry = Bird2("Tweet, Tweet")
print("\nNumber of Birds:", harry.count)
print("Harry says:", harry.get_chat())

# create a third instance of the class, passing different string args
mdjukic = Bird2("How much?")
print("\nNumber of Birds", mdjukic.count)
print("mdjukic says:", mdjukic.get_chat())

# create a third instance of the class, passing different string args
mdjukic = Bird2("How much?")
print("\nNumber of Birds", mdjukic.count)
print("mdjukic says:", mdjukic.get_chat())
