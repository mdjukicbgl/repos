#!/usr/bin/env python

from __future__ import print_function
import sys

def lesson1():
    """ 
    taken from the first chapter within the book:
    https://automatetheboringstuff.com/chapter1/
    """

    print("I am " + str("29 ") + "years old")   

    # Range tests:
    # range(10), range(0, 10), and range(0, 10, 1)
    for i in range(10):
        print("range(10)-->", range(10))
        
    for i in range(0, 10):
        print("range(0, 10)-->", range(0, 10))

    for i in range(0, 10, 1):
        print("range(0, 10, 1)-->", range(0, 10, 1)) 

def main(args):
    """
    within mainline of script
    """
    help(lesson1())
    lesson1()

if __name__ == '__main__':
    main(sys.argv[1:])


"""
In Python, 2 + 2 is called an expression, which is the most basic kind of 
programming instruction in the language. 
Expressions consist of values (such as 2) and operators (such as +), 
and they can always evaluate (that is, reduce) down to a single value. 
That means you can use expressions anywhere in Python code that you could also use a value.

In the previous example, 2 + 2 is evaluated down to a single value, 4. 
A single value with no operators is also considered an expression, though 
it evaluates only to itself, as shown here:

"""