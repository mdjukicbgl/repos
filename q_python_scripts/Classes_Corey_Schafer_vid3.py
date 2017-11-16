#!/usr/bin/env python

# methods are functions which are associated with a class
# data are attributes associated with a class
#
# lesson 3 - Difference between regular, class, and static methods
# 
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
    
    #
    # static methods - where class methods pass 'cls' as first arg
    # and normal methods pass 'self' as the first arg
    # static methods do not pass anything automatically
    # But, they have some logical connection to the class
    #


    
##############################################################
# end of employee class
##############################################################

#   
# define instances of the employee class, & print them
#
emp_1 = employee('Corey', 'Schafer', 50000)
emp_2 = employee('Test', 'User', 60000)

#
# set the class raise_amount variable from 4% to 5%
#
employee.set_raise_amout(1.05)
print("showing raise amount")
print("Employee.raise_amount-->", employee.raise_amount)
print("emp_1.raise_amount-->", emp_1.raise_amount)
print("emp_2.raise_amount-->", emp_2.raise_amount)
#showing raise amount before we called the set_raise_amout classmethod
#('Employee.raise_amount-->', 1.04)
#('emp_1.raise_amount-->', 1.04)
#('emp_2.raise_amount-->', 1.04)

#showing raise amount after we called the set_raise_amout classmethod
#('Employee.raise_amount-->', 1.05)
#('emp_1.raise_amount-->', 1.05)
#('emp_2.raise_amount-->', 1.05)

#
# Using class methods as alternative constructors
#
emp_str_1 = 'John-Doe-70000'
emp_str_2 = 'Steve-Smith-30000'
emp_str_3 = 'Jane-Doe-90000'

#
# using the new constructor to parse the string
#
new_emp_1 = employee.from_string(emp_str_1)

#
# list contents of fields
#
print("")
print("listing contents of split string")
print(new_emp_1.email)
print(new_emp_1.pay)

#
# testing static method
#
import datetime
my_date = datetime.date(2016,7,10)
print("Checking Static method - passing 2016-7-10-->")
print("Employee.is_workday(my_date)-->", employee.is_workday(my_date))

my_date = datetime.date(2016,7,11)
print("Checking Static method - passing 2016-7-11-->")
print("Employee.is_workday(my_date)-->", employee.is_workday(my_date))
