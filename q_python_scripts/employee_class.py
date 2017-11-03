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
    # defining a Class Method
    # note: instead of 'self', in a @classmethod, we use 'cls'(short for class)
    # since Class is a reserved word
    #   
    @classmethod
    def set_raise_amt(cls, amount):  
        cls.raise_amt = amount

    @classmethod
    def from_string(cls, emp_str):
        first, last, pay = emp_str.split('-')
        return(cls(first, last, pay))

    #
    # defining a staticmethod
    # this does NOT automatically pass either 'self' or 'cls'
    # staticmethods do not reference 'self' or 'cls'
    # hence, they are static
    #
    @staticmethod    
    def is_workday(day):
        if day.weekday() == 5 or day.weekday() == 6 :
            return(False)
        else:
            return(True)


def init_vals():
    #
    # note: emp_1 and emp_2 below, are automatically passed in as self
    # emp_1 & emp_2 are known as instances
    #
    print("Employee.num_of_emps-->", Employee.num_of_emps)
    emp_1 = Employee('marko', 'djukic', 50000)
    emp_2 = Employee('debbie', 'djukic', 60000)
    print("Employee.num_of_emps-->", Employee.num_of_emps)


    #print(emp_1)    
    #print(emp_2)

    # instance variables - data unique to each instance

    #emp_1.first = 'marko'
    #emp_1.last = 'djukic'
    #emp_1.email = 'mdjukic@company.com'
    #emp_1.pay = 50000
    #
    #
    #emp_2.first = 'debbie'
    #emp_2.last = 'djukic'
    #emp_2.email = 'debbiedjukic@company.com'
    #emp_2.pay = 47500

    print(emp_1.email)
    print(emp_2.email)

    #
    # Can use the Class name as follows, as an alternative:
    # These 2 statements are different, but functionally the same:
    #
    emp_1.fullname()
    print("emp_1.fullname()-->", emp_1.fullname())

    Employee.fullname(emp_1)
    print("list Employee.fullname(emp_1)-->", Employee.fullname(emp_1))
    #print("Employee.__name__-->", Employee.__name__)
    #print("Employee.__dict__-->", Employee.__dict__)
    #print("Employee.__init__-->", Employee.__init__)
    
    #
    # Check apply_raise
    #
    #Employee.raise_amount = 1.05
    
    #print("Employee.raise_amount-->", Employee.raise_amount)
    #print("emp_1.raise_amount-->", emp_1.raise_amount)
    #print("emp_2.raise_amount-->", emp_2.raise_amount)
    
    #
    # use instance variable instead of Class variable to change raise_amount
    #
    emp_1.raise_amount = 1.05
    
    print("emp_1.__dict__sorted-->", sorted(emp_1.__dict__))
    print("emp_1.__dict__reverse-->", sorted(emp_1.__dict__, reverse=True))
    print("emp_2.__dict__-->", emp_2.__dict__)
    
    print("Employee.raise_amount-->", Employee.raise_amount)
    print("emp_1.raise_amount-->", emp_1.raise_amount)
    print("emp_2.raise_amount-->", emp_2.raise_amount)
    
    #
    # parsing strings via class methods
    #
    emp_str_1 = 'Marko-Djukic-50000'
    emp_str_2 = 'Deborah-Djukic-4750'
    emp_str_3 = 'Alica-Djukic-28000'

    new_emp_1 = Employee.from_string(emp_str_1)
    print("new_emp_1.email-->", new_emp_1.email)
    print("new_emp_1.pay-->", new_emp_1.pay)

    """
    for i in ['emp_str_1', 'emp_str_2', 'emp_str_3']:
        new_emp = Employee.from_string(i)
        print("i-->", new_emp)
    """

    import datetime
    my_date = datetime.date(2016, 7, 11)
    print("Employee.is_workday(my_date)-->", Employee.is_workday(my_date))


def main(args):
    help(init_vals)
    init_vals()


if __name__ == '__main__':
    main(sys.argv[1:])


