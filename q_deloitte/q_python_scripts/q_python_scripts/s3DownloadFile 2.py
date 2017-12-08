#!/bin/env python

import boto
from boto.s3.connection import Location

s3 = boto.connect_s3()
key = s3.get_bucket('mdj-bucket-005').get_key('examples/customer-fw.tbl-000').get_contents_to_filename('/home/ec2-user/mdj_downloadedfile')
