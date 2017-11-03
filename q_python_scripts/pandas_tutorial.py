#!/usr/bin/env python

from __future__ import print_function
import pandas as pd
import sys


def read_ign_csv():
    """
    *** Read ign.csv file
    """
    # define source file
    filename = "C:\\Users\mdjuk\\repos\\q_python_scripts\\ign.csv"

    # define dataframe and populate from filename
    df = pd.read_csv(filename)

    # print first 3 rows
    print("df.head-->%s" %(df.head(n=3)))
    
    # print rows and colums present in dataframe 
    print("\ndf.shape-->%s" %(str(df.shape)))

    # index the entire dataframe
    df.iloc[:,:]

    # print first 5 rows
    print("df.head-->%s" %(df.head(n=5)))
    
    # print first 5 rows, and the respective score
    print("df.loc-->\n%s" %df.loc[:5,["score", "release_year"]])

    # an alternative option
    print("df[score, release_year]-->%s" %(df[["score", "release_year"]]) )

    # Verify a single column: will return: <class 'pandas.core.series.Series'>
    print("type(df[score]-->%s" %(type(df["score"])))

    # We can create a Series manually to better understand how it works. 
    # To create a Series, we pass a list or NumPy array into the Series object 
    # when we instantiate it:
    s1 = pd.Series([1,2])

    print("s1-->%s" %(s1))

    # ..can also be mixed datatypes
    s2 = pd.Series(['Marko Djukic', 'Debbie Djukic', 'Alicia Djukic', 'Alex Djukic'])
    print("s2-->%s" %(s2))

    # Creating A DataFrame in Pandas
    # We can create a DataFrame by passing multiple Series into the DataFrame class. 
    # Here, we pass in the two Series objects we just created, 
    # s1 as the first row, and s2 as the second row:

    ##print("new dataframe-->\n%s" %(pd.DataFrame([s1,s2])))
    i = pd.DataFrame([s1,s2])
    print("new dataframe-->\n%s" %(i))



def main(args):    
    """
    Call to mainline script
    """

    help(read_ign_csv)
    read_ign_csv()


if __name__ == '__main__' :

    main(sys.argv[1:])
    
