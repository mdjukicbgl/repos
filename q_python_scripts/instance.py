#!/usr/bin/env  python

from __future__ import print_function
from Bird import *

print("\nClass instance Of:\n", Bird.__doc__)

# add a statement to create an instance of the class and pass a
# string argument value to its instance variable

polly = Bird("Squark, Squark!")

# now, display this instance variable value and call the class 
# method to display the common class variable value
print("\nNumber of Birds:", polly.count)
print("Polly says:", polly.talk())

# create a second instance of the class, passing different string args
harry = Bird("Tweet, Tweet")
print("\nNumber of Birds:", harry.count)
print("Harry says:", harry.talk())

# create a third instance of the class, passing different string args
mdjukic = Bird("How much?")
print("\nNumber of Birds", mdjukic.count)
print("mdjukic says:", mdjukic.talk())

