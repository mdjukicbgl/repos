#!/bin/env python

from __future__ import print_function
import boto3

# Change to the bucket you create on your AWS account
TEMPLATE_S3_BUCKET = 'mdj-bucket-fmc'

#def get_template_from_s3(key):
"""Loads and returns html template from Amazon S3"""
s3 = boto3.client('s3')
s3 = boto3.client('s3')
s3_file = s3.get_object(Bucket = TEMPLATE_S3_BUCKET	, Key = 'come_to_work.html')  ###key)
try:
    template = Template(s3_file['Body'].read())
    print("Template-->" + template)
except Exception as error:
    print('Failed to load template')
    raise error
#return template


#if __name__ == '__get_template_from_s3__':
#	get_template_from_s3()