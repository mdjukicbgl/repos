#!/bin/usr/env python

from __future__ import print_function
import json


l = ['a','b','c','d','e','f','g','h']

for i in l:
    print(i)


d = {'marko':'father', 'debbie':'mother', 'alicia':'daughter', 'alex':'son'}

for key in d:
    print("key-->%s value-->%s" %(key, d[key]))
print("")

for key, value in sorted(d.iteritems(), reverse=True):
    print("key-->%s value-->%s" %(key, d[key]))
print("")
#for key, value in (reverse().d.iteritems()):
#    print("key-->%s value-->%s" %(key, value))


"""
 Dictionaries implement a tp_iter slot that returns an efficient iterator that iterates over the keys of the dictionary. [...] This means that we can write


for k in dict: ...
which is equivalent to, but much faster than

for k in dict.keys(): ...
as long as the restriction on modifications to the dictionary (either by the loop or by another thread) are not violated.
Add methods to dictionaries that return different kinds of iterators explicitly:

for key in dict.iterkeys(): ...

for value in dict.itervalues(): ...

for key, value in dict.iteritems(): ...
This means that for x in dict is shorthand for for x in
   dict.iterkeys().
"""   

#
# convert dictionary to JSON format
#   
print(json.dumps(d, indent=1))
