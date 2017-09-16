#!/bin/env python

from __future__ import print_function

import json
import os
import sys
import re

recs = []
#with codecs.open('C:\Users\mdjuk\q_json\data.json') as f:
with open('C:\Users\mdjuk\q_json\data.json') as f:
        for line in f.readlines():
                recs.append(json.loads(line))

print ('print rec-->', recs)

for rec in recs:

# 
#phone = "2004-959-559 # This is Phone Number"

# Delete Python-style comments
#num = re.sub(r'#.*$', "", phone)
#print "Phone Num : ", num

    print("start of output here..................................................")
    print (re.sub('(})', "\n}\n",(re.sub('({)', "\n{", str(rec) ) ) ))
    print (rec.keys() )
    print (rec.values() )
    #print (rec['hometown']['id'] )
    print("%s %s %s" %(rec["name"], rec["hometown"]["name"], rec["hometown"]["id"] ))


