#!/bin/env python

from __future__ import print_function

import sys
import os

HOST   = os.environ['PATH']
#PORT   = os.environ['PORT']
#DBNAME = os.environ['DBNAME']
#USER   = os.environ['USER']
#PWD    = os.environ['PWD']

CONFIG = {'dbname':'DBNAME',
          'user'  :'USER',
          'pwd'   :'PWD',
          'host'  :'HOST',
          'port'  :'PORT'
         }

print('host-->', HOST)

print('config[dbname]-->', CONFIG.keys() )
print('config[dbname]-->', CONFIG['host'] )
'''
print('....')
for i in dir(os.environ):
  print(i)
'''

'''
....
__cmp__
__contains__
__delitem__
__doc__
__getitem__
__hash__
__init__
__iter__
__len__
__module__
__repr__
__setitem__
clear
copy
data
fromkeys
get
has_key
items
iteritems
iterkeys
itervalues
keys
pop
popitem
setdefault
update
values
[Finished in 0.1s]
'''

