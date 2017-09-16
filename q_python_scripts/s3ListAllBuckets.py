#!/bin/env python

from __future__ import print_function

import boto3
import string

#list buckets
s3 = boto3.client('s3')
response = s3.list_buckets()
#buckets = [bucket['Name'] for bucket in response['Buckets']]

l = []
for bucket in response['Buckets']:
        ###l = "".join(str(bucket['Name']))
        l.append(str(bucket['Name']))
print("Bucket List: %s" % l )

