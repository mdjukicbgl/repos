#!/usr/bin/env python

from __future__ import print_function
import csv
import sys

def readcsv():
    """
    Function readcsv(): reading csv files
    """
    filename = open(c:/Users/mdjukic/q_python_files/examples.csv)
    filereader = csv.reader(filename)
    data = list(filereader)
    print("listing datafile contents-->%s", data)


def main(args):
    help(readcsv)
    readcsv()

if __name__ == '__main__':
    main(sys.argv[1:])
