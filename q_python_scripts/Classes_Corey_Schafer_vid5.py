#!/usr/bin/env python

# 5. Special(Magic/Dunder) Methods
#
# methods are functions which are associated with a class
# data are attributes associated with a class
#
# lesson 4 - Inheritance - Creating sub-classes
#
class employee:

    #
    # Add class variable raise_amount
    #
    raise_amount = 1.04
    #
    # defining class variable for number of employees, as this 
    # should be the same irrespective if we use instance emp_1
    # or emp_2
    #
    num_of_emps = 0

    def __init__(self, first, last, pay):
        # these are known as instance variables
        self.first = first
        self.last = last
        self.pay = pay
        self.email = first + '.' + last + '@company.com'
        #
        # incr num_of_emps each time this class is called
        #
        employee.num_of_emps += 1

    # method to print full name
    def fullname(self):
        return('{} {}'.format(self.first, self.last))

    # apply_raise method
    def apply_raise(self):
        self.pay = int(self.pay * self.raise_amount) # 4%

    # defining a class method
    @classmethod   # this is known as a decorator
    def set_raise_amout(cls, amount):
        cls.raise_amount = amount

    # defining a class method to be used as an alternative constructor
    @classmethod   # this is known as a decorator
    def from_string(cls, emp_str): # 'from' is a convention which is used
        first, last, pay = emp_str.split('-')
        return(cls(first, last, pay)) # & return new employee object

    # defining a static method
    # static methods - where class methods pass 'cls' as first arg
    # and regular methods pass 'self' as the first arg
    # static methods do NOT pass anything automatically
    # But, they have some logical connection to the class
    #
    @staticmethod  # this is known as a decorator
    def is_workday(day):
        if day.weekday() == 5 or day.weekday() == 6 :
            return(False)
        return(True)

    def __repr__(self):
        return("Employee('{}', '{}', '{})".format(self.first,
                    self.last, self.pay))

    def __str__(self):
        return("'{}' - '{}'".format(self.fullname(), self.email))

    #
    # combine 2 employees and add their salaries together
    #
    def __add__(self, other):
        return(self.pay + other.pay)

    #
    # one further example - len
    #
    def __len__(self):
        return(len(self.fullname()))

##############################################################
# end of employee class
##############################################################
#   
# define instances of the employee class, & print them
#
emp_1 = employee('Corey', 'Schafer', 50000)
emp_2 = employee('Test', 'User', 60000)

print(emp_1)

#
# these 2 lines.....
#
print(repr(emp_1))
print(str(emp_1))
#
# ...are the same as calling these 2 lines...
#
print(emp_1.__repr__())
print(emp_1.__str__())

#
# Also, special methods for arithmetic exist...
#
print(1+2) # this is using the Dunder-Add method, as follows...
print(int.__add__(1,2))
print(str.__add__('marko ', 'djukic'))

print("")
print(emp_1 + emp_2)

print("\n__len__")
print(len(emp_1))
print(len(emp_2))
