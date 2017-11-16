#!/usr/bin/env python

# 6. Property decorator - allows us to define Getters, Setters
#    and Deleter functionality
# 
# methods are functions which are associated with a class
# data are attributes associated with a class
#
# lesson 4 - Inheritance - Creating sub-classes
#
class employee(object): # have to include 'object' as parm

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
        #self.email = first + '.' + last + '@company.com'
        #
        # incr num_of_emps each time this class is called
        #
        employee.num_of_emps += 1

    # method to print full name
    # add the @property directive, prior to method, and remove ()
    # when fullname is printf.  Method acts as an attribute               
    @property 
    def fullname(self):
        return('{} {}'.format(self.first, self.last))

    # defining a setter for fullname
    @fullname.setter
    def fullname(self, name):
        first, last = name.split(' ')
        self.first = first
        self.last = last

    # defining a deleter for fullname
    @fullname.deleter
    def fullname(self):  # only pass self
        print('Delete Name!!!')
        self.first = None
        self.last = None

    # method to print full name
    @property
    def email(self):
        return('{}.{}@company.com'.format(self.first, self.last))

    
##############################################################
# end of employee class
##############################################################
#   
# define instances of the employee class, & print them
#
emp_1 = employee('Corey', 'Schafer', 50000)
emp_2 = employee('Test', 'User', 60000)

emp_1.first = 'Jim'

print(emp_1.first)
print(emp_1.email)
print(emp_1.fullname)

#
# if we define fullname as follows:
#
emp_1.fullname = 'Marko Djukic'

print
print(emp_1.first)
print(emp_1.email)
print(emp_1.fullname)

del emp_1.fullname