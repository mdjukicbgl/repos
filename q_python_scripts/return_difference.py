#!/usr/bin/env python

from __future__ import print_function
import os
import sys
from datetime import datetime

def return_difference(n1, n2):
    """
    Returns the difference between two numbers.
    - subtracts n2 from n1
    """
    return(n2-n1)

def cube(n1):
    """
    Returns the cube of a number
    - cube of n1
    """
    return(n1**3)

def multiply(n1, n2):
    """
    Multiplies two numbers together
    - multiplies n1 * n2
    """
    return(n1*n2)

def main(args):

    n1=3
    n2='axxxx'
    
    try:
        value1 = int(n1)
        value2 = int(n2)
    
    except ValueError:
        #if not isinstance(n1, int) and not isinstance(n2, int) :
        if not isinstance(n1, int):
            print("variable n1 --> %s is not an int" %(n1))
            
        if not isinstance(n2, int):
            print("variable n2 --> \"%s\" is not an int" %(n2))
            
    else:
        help(return_difference)
        print("difference between two numbers--> %s %s --> %s" %(n1, n2, return_difference(n1,n2)))

        help(cube)
        print("Cube of number %s is --> %s" %(n1, cube(n1)))

        help(multiply)
        print("Multiply two numbers--> %s %s --> %s" %(n1, n2, multiply(n1,n2)))

if __name__ == '__main__':
    main(sys.argv[1:])
