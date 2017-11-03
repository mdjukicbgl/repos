#!/usr/bin/env python

from __future__ import print_function
import os 
import sys
import numpy as np
from matplotlib import pyplot as plt
import functools
import re

def  read_txt_file():
    """
    function to read txt file
    """
    filename = "C:\\Users\mdjuk\\repos\\q_python_scripts\\moby_dick.txt"

    file = open(filename, mode='r')

    text = file.read()

    file.close()

    return(text)


def  read_txt_file_context_manager():
    """
    function to read txt file with 'with' context manager
    - using the with context manager, you NEVER have to concern to close the file
      as it will be done automatically 
    """
    filename = "C:\\Users\mdjuk\\repos\\q_python_scripts\\moby_dick.txt"
    fileout = "C:\\Users\mdjuk\\repos\\q_python_scripts\\moby_dick_out.txt"

    with open(filename, mode='r') as file:
        list_arr = file.read()
         
    #file = open(fileout, mode='w')
    #for line in list_arr:
    #    file.write(line)

    truncate(fileout)
    with open(fileout, mode='a') as file:
        for line in list_arr:
            file.write(line)

def read_csv_with_numpy():
    """
    Reading csv file with numpy
    """
    filename = "C:\\Users\mdjuk\\repos\\q_python_scripts\\digits.csv"

    data = np.loadtxt(filename, delimiter=',')

    return(data)


def numpy_selective_cols():
    # Import numpy
    #import numpy as np

    # Assign the filename: file
    filename = "C:\\Users\mdjuk\\repos\\q_python_scripts\\digits_header.txt"

    # Load the data: data
    data = np.loadtxt(filename, delimiter=',', skiprows=1, usecols=[0,2])

    # Print data
    print(data)
    print("type of data --> %s" %(type(data)))

"""
def assigning_functions():
    #Assigning functions

    # assigning functions
    #import functools
    memoize = functools.lru_cache
    print(memoize)
    # function lru_cache at 0x7fb2a6b42f28>

    # class assignment
    class MyClass:
        pass
    give_me_more = MyClass()
    print(give_me_more)
    # __main__.MyClass object at 0x7f512e65bfd0>
"""

def isinstance_func():
    """
    isinstance_func - determining the variable type
    """
    print("is value 2 an int?-->%s" %(isinstance(2, int)))
    print("is value 2 a float?-->%s" %(isinstance(2, float)))
    print("is value 5.6 a float?-->%s" %(isinstance(5.6, float)))
    print("is value 5.6+3j a complex?-->%s" %(isinstance(5.6+3j, complex)))
    print("is value 5.6+3j a complex?-->%s" %(isinstance(complex(5.6+3j), complex)))
    print("is string mdjukic a string?-->%s" %(isinstance('mdjukic', str)))
    print("is \'m\' in \'mdjukic\'?-->%s" %('m' in 'mdjukic'))
    print("is \'x\' in \'mdjukic\'?-->%s" %('x' in 'mdjukic'))
    combined_string = "-->".join(["marko", "djukic", "ok"])
    print("combined string: %s" %(combined_string))
    #
    # splitting a string into a list
    #
    split_string = "marko djukic".split() # splitting
    print("split_string-->%s" %(split_string))

    #
    # Or you can split a string based on a delimiter like :.
    #
    split_string = "1:2:3".split(":")
    print("split_string-->%s" %(split_string))

    #
    # formatting a string
    #
    print("I love {firstname} in {lastname}".format(firstname="marko", lastname="djukic"))

def read_unstructured_data():
    """
    Read unstructured data, ie. mixed data types
    """
    #
    # Assign the filename: file
    #
    filename = "C:\\Users\mdjuk\\repos\\q_python_scripts\\titanic.csv"

    #regexp = re.compile("*10*")

    data = np.genfromtxt(filename, delimiter=',', names=True, dtype=None)    

    for x in data['Survived'] :
        if x == 1 :
            print("data from titanic.csv-->%s" %(x))
            
    print("shape of data-->%s" %(np.shape(data)))


def main(args):
    """
    mainline of script
    """
    help(main)

    help(read_txt_file)
    print("output from test_file-->%s" %(read_txt_file()))

    help(read_txt_file_context_manager)
    read_txt_file_context_manager()    

    help(read_csv_with_numpy)
    new_digits = read_csv_with_numpy()
    print("output from csv_file-->%s" %(read_csv_with_numpy()))

    #
    # Select and reshape a row
    #
    #im = new_digits[21, 1:]
    #im_sq = np.reshape(im, (28, 28))

    #
    # Plot reshaped data (matplotlib.pyplot already loaded as plt)
    #
    #plt.imshow(im_sq, cmap='Greys', interpolation='nearest')
    #plt.show()

    #
    # 
    #
    help(numpy_selective_cols)
    numpy_selective_cols()

    #
    # range assignment
    #
    a1, a2, a3 = range(3)
    print("a1, a2, a3-->%s %s %s" %(a1, a2, a3))

    #help(assigning_functions)
    #assigning_functions()

    help(isinstance_func)
    isinstance_func()

    help(read_unstructured_data)
    read_unstructured_data()



if __name__ == "__main__":
    main(sys.argv[1:])

    
