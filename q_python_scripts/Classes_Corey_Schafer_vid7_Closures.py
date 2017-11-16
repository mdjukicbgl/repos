#!/usr/bin/emv python
from __future__ import print_function

# Closures
# A closure is a record storing a function together with an environment: a 
# mapping associating each free variable of the function with the value
# or storage location to which the name was bound when the closure was 
# created.  
# A closure, unlike a plain function, allows the function to access those
# captured variables through the closure's reference to them, even when the
# function is invoked outside their scope
#

#########################################################################
# 1st example, executing inner_func() via return statement
#########################################################################
#def outer_func():
#    message = 'Hi'
#
#    # this inner function, merely is 'created' when outer_func is called
#    # and NOT executed at this point.
#    def inner_func():
#        print(message)  # message is known as a free variable, it's not defined
#                        # within the function, but is external to it.
#
#    # the inner_func created above is exected at this point, via the 
#    # return function
#    return(inner_func())
#
#outer_func()

#########################################################################
# 2nd example, just return the function 
#########################################################################

#def outer_func():
#    message = 'Hi'
#
#    # this inner function, merely is 'created' when outer_func is called
#    # and NOT executed at this point.
#    def inner_func():
#        print(message)  # message is known as a free variable, it's not defi
#                        # within the function, but is external to it.
#
#    # the inner_func created above is exected at this point, via the 
#    # return function
#    return(inner_func)
#
#my_func = outer_func()
#print("Show what type of object 'my_func' is-->", my_func)
##"Show what type of object 'my_func' is-->", <function inner_func at 0x0000000002ABCEB8>
## NOTE: <function inner_func at 0x0000000002ABCEB8> ie. object type is function
##
## print out function name
##
#print(my_func.__name__)
## it shows as: inner_func
#
#my_func()
#my_func()
#my_func()
#
## NOTE: inner_func() has access to variables which were created in the local 
## scope, in which it was created, even after the outer_func() has finished
## executing
## This gets more interesting when we pass parameters to the functions

#########################################################################
# 3rd example, passing parms to outer functions 
#########################################################################

#def outer_func(msg):
#    message = msg
#
#    # this inner function, merely is 'created' when outer_func is called
#    # and NOT executed at this point.
#    # NOTE: in this example, inner_func() doesn't take in any params
#    def inner_func():
#        print(message)  # message is known as a free variable, it's not defi
#                        # within the function, but is external to it.
#
#    # the inner_func created above is exected at this point, via the 
#    # return function
#    return(inner_func)
#
#hi_func = outer_func('Hi')
#hello_func = outer_func('Hello')
#
## to execute the above variables, call as before
#hi_func()
#hello_func()
#
#########################################################################
# 4th example, passing parms to Both outer & inner functions 
#########################################################################
#
import logging
logging.basicConfig(filename='example.log', level=logging.INFO)

def logger(func):
    def log_func(*args):
        logging.info('Running "{}" with arguments {}'.format(func.__name__, args))
        print(func(*args))
    return(log_func)

def add(x,y):
    return(x+y)

def sub(x,y):
    return(x-y)

add_logger = logger(add)
sub_logger = logger(sub)

add_logger(3,3)
add_logger(4, 5)

sub_logger(10,5)
sub_logger(20, 10)
