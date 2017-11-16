#!/usr/bin/env python

# methods are functions which are associated with a class
# data are attributes associated with a class

# employee within a class

class employee:
    def __init__(self, first, last, pay):
        self.first = first
        self.last = last
        self.pay = pay
        self.email = first + '.' + last + '@company.com'

    # method to print full name
    def fullname(self):
        return('{} {}'.format(self.first, self.last))

    # at this point we have an employee class with no attributes and methods

#
# define instances of the employee class, & print them
# 
emp_1 = employee('Corey', 'Schafer', 50000)
emp_2 = employee('Test', 'User', 60000)

#print("emp_1 instance of employee class", emp_1)
#print("emp_2 instance of employee class", emp_2)

# 
# instance variables contain data which is unique to each instance
# Class variables are covered in vid2
#
#emp_1.first = 'Corey'
#emp_1.last = 'Schafer'
#emp_1.email = 'Corey.Schafer@company.com'
#emp_1.pay = 50000
#
#emp_2.first = 'Test'
#emp_2.last = 'User'
#emp_2.email = 'Test.User@company.com'
#emp_2.pay = 60000
#
print(emp_1.email)
print(emp_2.email)
#
print(emp_1.fullname()) # fullname() needed as this is a method not attribute

#
# these two lines are the same, ie. can call method via class name also
#
print(emp_2.fullname()) # fullname() needed as this is a method not attribute
print(employee.fullname(emp_2)) # fullname() needed as this is a method not attribute

    
