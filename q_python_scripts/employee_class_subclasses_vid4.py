#!/usr/bin/env python

from __future__ import print_function
import sys

class Employee:

    #
    # these are known as Class variables
    #
    num_of_emps = 0
    raise_amount = 1.04

    def __init__(self, first, last, pay):  # initialized or constructor
        #
        #  these are known as instance variables
        # 
        self.first = first        
        self.last = last
        self.pay = pay
        self.email = first + '.' + last + '@company.com'
        
        Employee.num_of_emps += 1

    #
    # adding Methods to our Class
    # functions within a Class, are known as a Method
    #
    def fullname(self):

        return('{} {}'.format(self.first, self.last))    

    
    def apply_raise(self):
        self.pay = int(self.pay * self.raise_amount)

    
#
# Sub Classes - inheriting attributes from an already
# defined class
# Python will walk up this chain of inheritance, until it finds what it's 
# looking for - METHOD RESOLUTION ORDER
#
class Developer(Employee, object):
    pass



def init_vals():
    #
    # note: emp_1 and emp_2 below, are automatically passed in as self
    # emp_1 & emp_2 are known as instances
    #
    print("Employee.num_of_emps-->", Developer.num_of_emps)
    dev_1 = Developer('marko', 'djukic', 50000)
    dev_2 = Developer('debbie', 'djukic', 60000)
    print("Employee.num_of_emps-->", Developer.num_of_emps)

    print("print help(Developer)-->", help(Developer))
    print(dev_1.email)
    print(dev_2.email)


def main(args):
    help(init_vals)
    init_vals()


if __name__ == '__main__':
    main(sys.argv[1:])


