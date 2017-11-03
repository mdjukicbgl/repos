#!/usr/bin/env python
#
from __future__ import print_function
import pandas as pd
import numpy as np
#import sys
import datetime

# formatting a string
#
#print("I love {firstname} in {lastname}".format(firstname="marko", lastname="djukic"))

df = pd.DataFrame(np.random.randn(5, 3), index=list('abcde'), columns=list('xyz'))
#print("df[1:]-->%s" %(df[1:]))

