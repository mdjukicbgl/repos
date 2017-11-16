#!/usr/bin/env python

# memoization - is an optimization technique used primarily to speed up 
# computer programs by storing the results of expensive function calls
# and returning the cached result when the same inputs occur again.
#
# - utable and immutable

from __future__ import print_function
import time
from datetime import datetime

#def expensive_func(num):
#    print("Computing {}...".format(num))
#    time.sleep(1) # sleep for 1 sec
#    return(num*num)
#
#
#print("start of script-->{}".format(datetime.now()))
#print(expensive_func(4))
#
#print(expensive_func(10))
#
#print(expensive_func(4))
#
#print(expensive_func(10))
#
#print("end of script  -->{}".format(datetime.now()))
#
#########################################################################
# 2nd example with a dictionary, which acts as a pseudo cache, as it 
# stores all the results in it for us
#########################################################################
#
# define empty cache, in this case a dictionary 
ef_cache = {} 

def expensive_func(num):
    if num in ef_cache:
        return(ef_cache[num])

    print("Computing {}...".format(num))
    time.sleep(1) # sleep for 1 sec
    result = num*num
    ef_cache[num] = result
    return(result)

print("start of script-->{}".format(datetime.now()))
print(expensive_func(4))

print(expensive_func(10))

print(expensive_func(4))

print(expensive_func(10))

print("end of script  -->{}".format(datetime.now()))

for k, v in ef_cache.iteritems():
    print("ef_cache-->{}:{}".format(k, v))

print(ef_cache)

    