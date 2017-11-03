#!/usr/bin/env python

from __future__ import print_function
import random
import sys
import os

"""
A class is a specified prototype describing a set of properties that
characterize an object.  Each class has a data structure that can
contain both functions and variables to characterize the object.

parameters passed to the Class are known as 'attributes'
functions within a class are know at its 'methods'

Class format structure:

Class ClassName:
    class-documentation-string
    class-variable-declaration ie. __init__(self), __doc__(self) etc.
    class-method-definitions ie. functions

All properties of a class are referened internally by th edot
notation prefix self - so aan attribute named 'sound' is self.sound
Additionally, all method definitions in a class must have self as their first argument
so their first argument - so a method named 'talk' is talk(self)

When a class instance is created, a special '__init__(self)' method
is automatically called.  Subsequent arguments can be added in its
parenthesis if values are to be passed to initialize its attributes. 

"""

class Critter:
    """ 
    A base class for all critter properties
    """
    count = 0 # variable count is a class variable, referenced as Critter.count from inside or outside the class

    def __init__(self, chat): # automatically called when class is created, this is an attribute
        self.sound = chat
        Critter.count += 1

    def talk(self): # this is a method
        return(self.sound)

class Bird:
    """
    A base class to define bird properties
    """
    count = 0

    def __init__(self, chat):
        self.sound = chat
        Bird.count += 1

    def talk(self):
        return(self.sound)
    
            
