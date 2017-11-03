#!/usr/bin/env python

from __future__ import print_function
import pandas as pd
import numpy as np
import sys


def read_pandas2():
    """
    read pandas dataframe
    """

    # define the source file
    filename = "C:\\Users\mdjuk\\repos\\q_python_scripts\\digits.csv"

    # define dataframe
    df = pd.read_csv(filename, sep=',', header=None)

    # Read the first 5 rows of the file into a DataFrame: data 
    data = df.head()

    print("df.index-->%s" %(df.index))
    print("df.columns-->%s" %(df.columns))

    for i in df.index:
        print("value of dataframe-->%s" %(df[i][10]))

    # build a numpy data_array
    data_array = df.values

    # print data_array
    print("data array-->\n%s" %(data_array))


def main(args):

    help(read_pandas2)
    read_pandas2()


if __name__ == '__main__':

    main(sys.argv[1:])


###
