#
# boto - let's jump right in with some code using your favourite Python library.
# Start by creating a bucket in which to store files.
# Buckets are defined in a Globla Workspace, hence, each one across the AWS estate must be uniquely named
#

import boto
from boto.s3.connection import Location

# connect to s3
s3 = boto.connect_s3()  # create connection to s3

# creates an s3 bucket
bucket = s3.create_bucket('mdj-bucket-005')

# returns a new_key object, but it hasn't done anything on s3 yet.
key = bucket.new_key('examples/customer-fw.tbl-000') 	

# this call opens a file handle to the specified local file, and buffers read & write from teh file into the key object on s3
key.set_contents_from_filename('/home/ec2-user/customer-fw.tbl-000') 

# set the access control list to 'public-read', so that it can be accessed publically without permissions
key.set_acl('public-read')


###bucket = s3.create_bucket('mdj-bucket-005')
s3 = boto.connect_s3()
bucket = s3.create_bucket('mdj-bucket-005')
key = bucket.new_key('examples/customer-fw.tbl-000')
key.set_contents_from_filename('/home/ec2-user/customer-fw.tbl-000')
key.set_acl('public-read') 


s3 = boto.connect_s3()
bucket = s3.create_bucket(<bucketName>)
key = bucket.new_key('folder/to/upload/file/into/<filename>')
key.set_contents_from_filename('/home/ec2-user/<filename>')
key.set_acl('public-read')

s3 = boto.connect_S3()
bucket = s3.crate_bucket('bucketName')
key = bucket.new_key('targetFolder/filename')
key.set_contents_from_filename('/source/dir/of/file/filename')
key.set_acl('public-read')

s3 = boto.connect_s3()
bucket = s3.create_bucket('bucketname')
key = bucket.new_key('target/folder/in/bucket/filename')
key.set_contents_from_filename()
key.set_acl('public-read')


# create bucket




