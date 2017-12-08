#!/usr/bin/env python

from __future__ import print_function
import os

#
# Setup BATCH_FLAG, & BATCH_ID via environment variables
#
BATCH_FLAG = os.environ['BATCH_FLAG_ID'].split(" ", 1)[0]
BATCH_ID = os.environ['BATCH_FLAG_ID'].split("-b", 1)[-1]


TRANSFORM_FLAG = os.environ['TRANSFORM_FLAG_LABELS'].split(" ", 1)[0]
TRANSFORM_LABELS = os.environ['TRANSFORM_FLAG_LABELS'].split("-t", 1)[-1]

print('BATCH_FLAG, BATCH_ID-->%s %s' %(BATCH_FLAG, BATCH_ID))
print('TRANSFORM_FLAG, TRANSFORM_LABELS-->%s %s' %(TRANSFORM_FLAG, TRANSFORM_LABELS))


