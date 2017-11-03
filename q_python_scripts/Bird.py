#!/usr/bin/env python

from __future__ import print_function
import random
import sys
import os

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
    
            
"""
    def __init__(self, name, height, weight, sound):
        self.__name = name
        self.__height = height
        self.__weight = weight
        self.__sound = sound
        
    def set_name(self, name):
        self.__name = name

    def get_name(self):
        return(self.__name)   

"""