#!/usr/bin/env python

# 7. First-Class Functions
# A programming languare is said to have first-class functions
# if it treats functions as first-class citizens
#
# methods are functions which are associated with a class
# data are attributes associated with a class
# 
def square(x): 
    return(x * x)
#
# defining the cube function
#
def cube(x):
    #return("Cube-->", x*x*x)
    return(x*x*x)
#
# defining my_map function
#
def my_map(func, arg_list):
    result = []
    for i in arg_list:
        result.append(func(i))

    return(result)



###############################################################
# end of functions.....
##############################################################
#   
#f = square(5)
#f = square

#print(square)
#print(f)
#print(f(5))

squares = my_map(square, [1,2,3,4,5])
cubes = my_map(cube, [1,2,3,4,5])

print("squares-->", squares)
print("cube-->", cubes)

