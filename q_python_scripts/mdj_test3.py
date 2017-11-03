#!/usr/bin/env python

from __future__ import print_function
import pandas as pd
import numpy as np
import sys

def read_pandas():
    """
    read in titanic.txt file to pandas dataframe
    """
    # define the source file
    filename = "C:\\Users\mdjuk\\repos\\q_python_scripts\\titanic.csv"

    # define dataframe
    df = pd.read_csv(filename, sep=',')

    # define numpy array
    data = df.values

    print("df-->%s" %(df))

    print("type(df)-->%s" %(type(df)))
    print("type(data)-->%s" %(type(data)))
    print("df.columns-->%s" %(df.columns))
    
    print("data nparray-->%s" %(data))
    
    # PassengerId,Survived,Pclass,Sex,Age,SibSp,Parch,Ticket,Fare,Cabin,Embarked
    for i in df['Ticket']:
        #print("Ticket-->%s" %(i['Ticket'], i['PassengerId']))
        print("Ticket-->%s" %(i))
        

def main(args):
    """
    Mainline script
    """
    help(read_pandas)
    read_pandas()


if __name__ == '__main__' :

    help(main)
    main(sys.argv[1:])
