#!/usr/bin/env python

from __future__ import print_function
import random
import sys
import os

class Animal:
    __name = None  #__ implies private variable, and needs a function within class to change it
    __height = 0
    __weight = 0
    __sound = 0

#
# Constructor is used to initialize an object
#
    def __init__(self, name, height, weight, sound):
        self.__name = name
        self.__height = height
        self.__weight = weight
        self.__sound = sound
#
# set and get are known as Encapsulation - setters and getters
#
    def set_name(self, name):
        self.__name = name

    def get_name(self):
        return(self.__name)        

    def set_height(self, height):
        self.__height = height

    def get_height(self):
        return(self.__height)        

    def set_weight(self, weight):
        self.__weight = weight

    def get_weight(self):
        return(self.__weight)        

    def set_sound(self, sound):
        self.__sound = sound

    def get_sound(self):
        return(self.__sound)        

#
# Polyporphism - print out the object name
#
    def get_type(self):
        print("Animal")

    def tostring(self):
        return("{} is {} cm tall and {} kg and say {}".format(self.__name
                                , self.__height
                                , self.__weight
                                , self.__sound))
#
# create an object
#
cat = Animal("Whiskers", 33, 10, "Meow")

print(cat.tostring())

#
# Inheritance - when you inherit from another class, you inherit all variables
# methods etc from the class you are inheriting from
# 
# Create class Dog, and inherit from Animal class
#
class Dog(Animal, object):
    __owner = None

    def __init__(self, name, height, weight, sound, owner):
        self.__owner = owner
        self.__animal_type = None
        super(Dog, self).__init__(name, height, weight, sound)

    def set_owner(self, owner):
        self.__owner = owner

    def get_owner(self):
        return(self.__owner)
    
    def get_type(self):
        print("Dog")
    #
    # overwrite defined variable values, as defined within Animal class
    #
    def tostring(self):
        return("{} is {} cm tall and {} kg and say {}. His owner is {}".format(
                          self.get_name()
                        , self.get_height()
                        , self.get_weight()
                        , self.get_sound()
                        , self.get_owner() ))

    #
    # Method overloading
    # Able to perform different tasks, based upon the attribues sent in
    #
    def multiple_sounds(self, how_many=None):  # None means that how_many is optional
        if how_many is None:
            print(self.get_sound())
        else:
            print(self.get_sound() * how_many)

spot = Dog("Spot", 53, 27, "Rufffff", "mdjukic")

print(spot.tostring() )

#
# Polymorphism - allows you to refer to objects as their superclass,
# and then have the correct functions called automatically
#  
class animaltesting:
    def get_type(self, animal):
        animal.get_type()

testanimals = animaltesting()

testanimals.get_type(cat)
testanimals.get_type(spot)

spot.multiple_sounds(5)
spot.multiple_sounds()

