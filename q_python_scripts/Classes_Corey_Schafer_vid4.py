#!/usr/bin/env python

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
   

#
# sub-class Developer - Inheriting the employee class
#
class Developer(employee, object):
    raise_amount = 1.10

    def __init__(self, first, last, pay, prog_lang):
        #
        # super directs employee class to handle these 3 variables
        # 
        super(Developer, self).__init__(first, last, pay) 
        #
        # instead of super() we could use the employee class method:
        #    employee.__init__(self, first, last, pay)
        self.prog_lang = prog_lang

#
# sub-class Manager inheriting from employee
#
class Manager(employee, object):

    def __init__(self, first, last, pay, employees=None): # None - defaultl
        super(Manager, self).__init__(first, last, pay) 
        if employees is None:
            self.employees = []
        else:
            self.employees = employees
    #
    # add method to add employees 
    #         
    def add_emp(self, emp):
        if emp not in self.employees:
            self.employees.append(emp)
    #
    # method to remove employees
    #         
    def remove_emp(self, emp):
        if emp in self.employees:
            self.employees.remove(emp)
    #
    # method to print employees
    #
    def print_emps(self):
        for emp in self.employees:
            print("Employee name-->", emp.fullname())




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
print("showing email addresses")
print("emp_1.raise_amount-->", emp_1.email)
print("emp_2.raise_amount-->", emp_2.email)
#
# instantiating 2 new instances
#
dev_1 = Developer('Corey', 'Schafer', 50000, 'Python')
dev_2 = Developer('Test', 'User', 60000, 'Java')

#
# set the class raise_amount variable from 4% to 5%
# method resolution order - working up the chain of inheritance to 
# resolve dev_1.email, which is not explicitly defined within Developer
#
print("showing dev email addresses")
print("dev_1.email-->", dev_1.email)
print("dev_2.email-->", dev_2.email)

#print(dev_1.__dict__)
#print(employee.__dict__)
#print("listing Developer class")
#print(help(Developer))

# print("showing dev_1.pay")
# print("dev_1.pay-->", dev_1.pay)
# dev_1.apply_raise()
# print("dev_1.pay-->", dev_1.pay)

print("showing dev_1 email and prog_lang")
print("dev_1.email-->", dev_1.email)
print("dev_1.prog_lang-->", dev_1.prog_lang)


mgr_1 = Manager('Sue', 'Smith', 90000, [dev_1])

print("")
print("listing Manager instance details")
print(mgr_1.email)
#
# add second employee
#
mgr_1.add_emp(dev_2)

#
# remove employee from list
# 
mgr_1.remove_emp(dev_1)

#
# print out all of the employees who report to this manager
#
mgr_1.print_emps()

# 
# Python built-ins
# isinstance() - check to see if object is an instance of a class
# issubclass() - check to see if a class is a subclass of another class
#
print("")
print("Checking if isinstance(mgr_1, Manager)-->", isinstance(mgr_1, Manager))

print("Checking if isinstance(mgr_1, employee)-->", isinstance(mgr_1, employee))

print("Checking if isinstance(mgr_1, Developer)-->", isinstance(mgr_1, Developer))

print("Checking if issubclass(Developer, Developer)-->", issubclass(Developer, Developer))

print("Checking if issubclass(Developer, employee)-->", issubclass(Developer, employee))

print("Checking if issubclass(Manager, Developer)-->", issubclass(Manager, Developer))

