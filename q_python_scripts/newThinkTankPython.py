#!/usr/bin/env python

from __future__ import print_function
import random
import sys
import os
import numpy as np

# Data types - numbers strings list dict tuple

print("hello world")
name = "markodjukic"
print(name)

# variable has to start with a letter, and can have numbers or underscores within its label

name = 15 

# +-*/%**//
print("5 + 2 =", 5+2)
print("5 - 2 =", 5-2)
print("5 * 2 =", 5*2)
print("5 / 2 = %0.5f" %(5/2))
print("5 % 2 =", 5%2)
print("5 // 2 =", 5//2)
print("5 ** 2 =", 5**2)

quote = "\"Always remember that you are unique"
print(quote)

multi_line_quote = """just
like everyone else """
print(multi_line_quote)

# combine strings
new = quote + multi_line_quote
print(new)

print("%s %s %s" %("I line the quote", quote, multi_line_quote), end="")
print("newlines")

print("\n" * 5)
print("5 newlines printed above")

### Lists
grocery_list = ['Juice', 'Tomatoes', 'Potaties', 'Bananas']
print("grocery_list, first item-->%s" %(grocery_list[0]))

# change values in a list
grocery_list [0] = "Green Juice"
print("grocery_list, first item-->%s" %(grocery_list[0]))

# print values of a list
print(grocery_list[1:3]) # will print item 1, and upto but not including item 3

# list of lists
other_events = ['Wash Car', 'Pick up kids', 'Cash cheque']
to_do_list = [other_events, grocery_list]
print(to_do_list)
print(to_do_list[1][1])

# append items to lists
grocery_list.append("Onion")
print(to_do_list)

grocery_list.insert(1, "Pickle")
print(to_do_list)

grocery_list.remove("Pickle")
print(to_do_list)

grocery_list.sort()
print(to_do_list)

grocery_list.reverse()
print(to_do_list)

del grocery_list[4]
print(to_do_list)

to_do_list2 = other_events + grocery_list
print("len, no of elements in list-->", len(to_do_list2))
print("min to_do_list2-->", min(to_do_list2))
print("max to_do_list2-->", max(to_do_list2))

### tuples - unlike lists, cannot be changed after defining

pi_tuple = (3,1,4,1,5,9)
#
# convert tuple into a list
#
new_tuple = list(pi_tuple)
print("new_tuple into a list-->", new_tuple)
#
# convert list into a tuple
#
new_tuple = tuple(new_tuple)
print("convert list into a tuple-->", new_tuple)
#
# no of elements in tuple
#
print("elements in tuple-->", len(pi_tuple))
#
# min of tuple
#
print("min element of tuple-->", min(pi_tuple))
#
# max of tuple
#
print("max element of tuple-->", max(pi_tuple))

#
# Dictionaries - cannot join with + as in lists
#
super_villians = {'father':'mdjukic', 'mother':'ddjukic', 'daughter':'Alicia', 'Son':'Alex'}
print(super_villians['mother'])
del super_villians['father']
print(super_villians)
super_villians['father'] ='mdjukic'
print(super_villians)
print("super_villian.keys-->", super_villians.keys())
print("super_villian.values-->", super_villians.values())
#
# number of super_villians defined
#
print("number of super_villians-->", len(super_villians))
print("min super_villians-->", min(super_villians))
print("max super_villians-->", max(super_villians))
print("get mdjukic-->", super_villians.get('father'))

#
# Conditionals
#
age = 21
if age > 16:
    print("You are old enought to drive", age)
else:
    print("You are NOT old enough to drive", age)

#
# Looping
#
for i in range(0,10):
    print(i, end="")

for i in range(0,10):
    print(i, ' ', end='')

print("\n", end="")
for i in [0,2,4,6,8]:
    print(i)  

print(end="\n")
new_list = [[1,2,3], [10,20,30], [100,200,300]]
for i in range(0,3):
    for j in range(0,3):
        print(new_list[i][j])

#
# while loop with random
#
random_num = random.randrange(0,100)
i = 0
print("Process random range")
while(random_num != 15):
    i += 1
    print(i, random_num)
    random_num = random.randrange(0,100)

i = 0

while (i <= 20 ):
    if (i%2 == 0):
        print(i)
    elif (i == 9):
        break   #breaks out of the while loop, and ends
    else:
        i += 1
        continue #skips all code beyond this point, and returns to the while loop
    i += 1

#
# read input
# 
#print("what is your name?")
#name = sys.stdin.readline()
#print("Hello ", name) 

#
# stings
#
long_string = "i'll catch you if you fall - The Floor"
#
# print first 4 characters
#
print(long_string[0:4])
#
# print last 5 characters
#
print(long_string[-5:])
#
# print upto the last 5 characters
#
print(long_string[:-5])
#
# concatenate 2 strings together
#
print(long_string[0:4] + ' be there')
#
# print formatting
#
print("%c is my %s letter and my number %d number is %.f5" %('M', 'favourtite', 1, .14))

long_string = "i'll catch you if you fall - The Floor"
#
# Capitalize first letting in string
#
print("Capitalize first letter in string-->", long_string.capitalize())
#
# find index of start of string
#
print("show index of string", long_string.find("catch"))
#
# check to see if all characters are alpha
#
long_string2 = "123"
print(long_string.isalpha())
print(long_string2.isalnum())
print(len(long_string))
#
# replace string
#
print("replace Floor with Ground-->", long_string.replace("Floor", "Ground"))
#
# strip whitespace
#
print("strip whitespace-->", long_string.strip())
#
# split string into list
#
quote_list = long_string.split(" ")
print("new list, which has been split-->", quote_list)

#
# Reading and writing to files
#
filename = open("banastest.txt", "w")
#
# list filename mode
#
print("print filename.mode-->", filename.mode)
#
# list filename name
#
print("print filename.name", filename.name)
#
# write to file
#
filename.write("Write me to the file\n")
#
# close file
#
filename.close()
#
# Read from file
#
filename = open("banastest.txt", "r+")

textinfile = filename.read()
print("print text within file-->", textinfile)
filename.close()
#
# delete file
#
os.remove("banastest.txt")

#
# using len and size of list
#
print(len(to_do_list))
print(len(super_villians))


