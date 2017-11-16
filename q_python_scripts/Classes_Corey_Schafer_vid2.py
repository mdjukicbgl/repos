#!/usr/bin/env python

# methods are functions which are associated with a class
# data are attributes associated with a class
#
# lesson 2 - Difference between class variables an dinstance variables
# Class variables - variables which are shared between 
# all instances of a class
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


#
# define instances of the employee class, & print them
#
print("employee.num_of_emps-->", employee.num_of_emps)  
emp_1 = employee('Corey', 'Schafer', 50000)
emp_2 = employee('Test', 'User', 60000)
print("employee.num_of_emps-->", employee.num_of_emps)

print("emp_1.pay-->", emp_1.pay)
emp_1.apply_raise()  # need () as we are calling a method
print("emp_1.pay-->", emp_1.pay)

print("showing raise amount")
#print("Employee.raise_amount-->", employee.raise_amount)
#print("emp_1.raise_amount-->", emp_1.raise_amount)
#print("emp_2.raise_amount-->", emp_2.raise_amount)

#
# print out namespaces to see what keys we are using
#
#employee.raise_amount = 1.05
# if we use the instance variable instead of the class variable
emp_1.raise_amount = 1.05
print(emp_1.__dict__)
#print(employee.__dict__)

print("Employee.raise_amount-->", employee.raise_amount)
print("emp_1.raise_amount-->", emp_1.raise_amount)
print("emp_2.raise_amount-->", emp_2.raise_amount)


