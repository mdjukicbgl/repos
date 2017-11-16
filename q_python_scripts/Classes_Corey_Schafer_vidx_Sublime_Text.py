#!/usr/bin/env python


from __future__ import print_function
import sys

print(sys.executable)
print(sys.version)

class Employee(object):

    """
    A sample Employee Class
    """

    def __init__(self, first, last):
        self.first = first
        self.last = last

    @property
    def email(self):
        return("{}.{}@email.com".format(self.first, self.last))

    @property
    def fullname(self):
        return("{} {}".format(self.first, self.last))

emp_1 = Employee("Marko", "Djukic")

print(emp_1.first)
print(emp_1.last)
print(emp_1.fullname)

