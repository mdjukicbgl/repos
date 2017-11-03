#!/usr/bin/env python

from __future__ import print_function
import os, sys

def dataline ():
    """
    this will load data as expected
    """
    emp_str_1 = '"1","0","3","male","22.0","1","0","A/5 21171","7.25","","S"'

    (PassengerId,Survived,Pclass,Sex,Age,SibSp,Parch,Ticket,Fare,Cabin,Embarked) = emp_str_1.split(',') 

    print("PassengerId-->", PassengerId)
    print("Age-->", Age)



def main(args):
    if __name__ == '__main__':
        help(dataline)
        dataline()


#
# PassengerId,Survived,Pclass,Sex,Age,SibSp,Parch,Ticket,Fare,Cabin,Embarked

if __name__ == '__main__':
    main(sys.argv[1:])

