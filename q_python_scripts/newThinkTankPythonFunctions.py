#!/usr/bin/env python

from __future__ import print_function
import random
import sys
import os

def addnos(fnum, lnum):
    """
    function to add 2 numbers together
    """
    sumnos = fnum + lnum
    return(sumnos)

def main(args):
    help(addnos)
    #print("add 2 nos together-->", addnos(5,7))
    stringnos = addnos(5,7)
    print(stringnos)
    
if __name__ == '__main__':
    main(sys.argv[1:])
    