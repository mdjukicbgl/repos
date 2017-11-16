#!/usr/bin/env python
from __future__ import print_function

#
## 7. First-Class Functions
## A programming languare is said to have first-class functions
## if it treats functions as first-class citizens
##
## methods are functions which are associated with a class
## data are attributes associated with a class
## 
#def square(x): 
#    return(x * x)
##
## defining the cube function
##
#def cube(x):
#    #return("Cube-->", x*x*x)
#    return(x*x*x)
##
## defining my_map function
##
#def my_map(func, arg_list):
#    result = []
#    for i in arg_list:
#        result.append(func(i))
#
#    return(result)
#
################################################################
## end of functions.....
################################################################
#
##   
##f = square(5)
##f = square
#
##print(square)
##print(f)
##print(f(5))
#
#squares = my_map(square, [1,2,3,4,5])
#cubes = my_map(cube, [1,2,3,4,5])
#
#print("squares-->", squares)
#print("cube-->", cubes)
#

################################################################
# end of functions.....
################################################################

################################################################
# start of 2nd part of functions.....
################################################################

#def logger(msg):
#
#    def log_message():
#        print('Log:', msg)
#
#    return(log_message) # note, no parenthesis, hence, it is just returned, and
#                        # NOT executed at this point
#
#log_hi = logger('Hi!')
#log_hi()
#

################################################################
# start of 3rd part of functions.....
################################################################
#
def html_tag(tag):

    # wrap_text(msg) is merely created at this point, NOT EXECUTED
    def wrap_text(msg):
        print('<{0}>{1}</{0}>'.format(tag, msg))

    # wrap_text function is EXECUTED at this point
    return(wrap_text)

print_h1 = html_tag('H1')
print_h1('Test Headline!')
print_h1('Another Headline!')

print_p = html_tag('p')
print_p('Test Paragraph!')

