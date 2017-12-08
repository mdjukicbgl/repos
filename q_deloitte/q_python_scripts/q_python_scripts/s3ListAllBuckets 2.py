#!/bin/env python

from __future__ import print_function

import boto3
import string

# Create an S3 client
s3 = boto3.client('s3')

# Call S3 to list current buckets
response = s3.list_buckets()

# Get a list of all bucket names from the response
buckets = [bucket['Name'] for bucket in response['Buckets']]

# Print out the bucket list
print("Bucket List: %s" % buckets)

a = str(response)
print("response-->", a.replace(',', '\n') )

CreationDates = [bucket['CreationDate'] for bucket in response['Buckets']]
# Print out the bucket list
print("CreationDates List: %s" % CreationDates)

