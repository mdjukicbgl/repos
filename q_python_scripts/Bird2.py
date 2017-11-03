#!/usr/bin/env python

from __future__ import print_function
import random
import sys
import os

class Bird2:
  
    """
    A base class to define bird properties
    """
    __chat = None

    count = 0

    def __init__(self, chat):
        self.__chat = chat
        Bird2.count += 1

    def set_chat(self, chat):
        self.__chat = chat

    def get_chat(self):
        return(self.__chat)   
    
#   def talk(self):
#       return(self.chat)
#
# Polyporphism - print out the object name
#
    def get_type(self):
        print("Bird2")

    def tostring(self):
        return("Bird2 sound is {} ".format(self.__chat))
    
#mdjukic = Bird("How much, did you say?")

#print(mdjukic.tostring())
