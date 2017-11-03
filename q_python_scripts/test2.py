#!/usr/bin/env python

import numpy as np
import sys

def read_unstructured_data():
    """
    Read unstructured data, ie. mixed data types
    """
    #
    # Assign the filename: file
    #
    filename = "C:\\Users\mdjuk\\repos\\q_python_scripts\\titanic.csv"

    data = np.genfromtxt(filename, delimiter=',', names=True, dtype=None)    

    for i in data['Survived'] :
        if i == 1 :
            print("data from titanic.csv-->%s" %(i))


def recfromcsv_func():
    """
    reading recs from file, via readfromcsv
    """
    print("Start of recfromcsv")
    filename = "C:\\Users\mdjuk\\repos\\q_python_scripts\\titanic.csv"

    #d = np.recfromcsv(filename, delimiter=',', names=True, dtype=None)
    d = np.genfromtxt(filename, delimiter=',', names=True, dtype=None)

    #
    # print first 3 records
    #
    #print("recs from recfromcsv_func-->%s" %(d[:3]))
    for i in d['Survived'] :
        if i == 1 :
            print("data from titanic.csv-->%s" %(i))

 
def main(args):

    help(read_unstructured_data)
    read_unstructured_data()

    help(recfromcsv_func)
    recfromcsv_func()


if __name__ == '__main__':
    main(sys.argv[1:])        

###

