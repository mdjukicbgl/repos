#!/usr/bin/env python

from __future__ import print_function

def square_numbers(nums):
    result = []
    for i in nums:
        result.append(i*i)
    return result

my_nums = square_numbers([1,2,3,4,5])

print("my_nums list-->", my_nums)

print("using generators\n")

def square_numbers2(nums):
    for i in nums:
        yield(i*i)

my_nums2 = square_numbers2([1,2,3,4,5,6])

for i in my_nums2:
    print("yield-->", i) 
    
           