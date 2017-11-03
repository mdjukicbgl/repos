#!/usr/bin/env python

from __future__ import print_function
import pandas as pd
import numpy as np
import sys

def read_dataframe():
    """
    Inititalizing dataframe from csv file
    """
    filename = "C:\\Users\mdjuk\\repos\\q_python_scripts\\titanic.csv"

    #df = pd.read_csv(filename, header=True, sep=',' )
    df = pd.read_csv(filename, sep=',')

    print("dataframe index-->\n%s" %(df.index))
    print("dataframe columns-->\n%s" %(df.columns))

    print("dataframe head-->\n%s" %(df.head()))

    print("type of dataframe-->%s" %(type(df)))

    # conbert pandas dataframe to numpy array
    data = df.values

    print("print Ticket-->%s" %(df['Ticket'][883]))
    print("type of data type-->%s" %(type(data)))

    print("Numpy array-->\n%s" %(data))

    #training_data = pd.read_excel("/home/workstation/ANN/new_input.xlsx", header=None)
    #X_train = training_data_x.as_matrix()

def main(args):
    """
    start of mainline
    """
    help(read_dataframe)
    read_dataframe()


if __name__ == '__main__' :

    main(sys.argv[1:])

