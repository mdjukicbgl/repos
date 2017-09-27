#! /usr/bin/env python

from __future__ import print_function
import sys

def qsum (a, b):
    """
    This will return the sum of two numbers
    """
    return (a + b)

def main(args):
    """
    Mainline section of script
    """
    help(qsum)
    help(main)
    print("sum of 2 integers %d" %(qsum(int(2), int(5))))


if __name__ == '__main__':
    main(sys.argv[1:])


