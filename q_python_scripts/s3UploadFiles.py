#!/bin/env python

from __future__ import print_function

import boto3

# upload_file(Filename, Bucket, Key, ExtraArgs=None, Callback=None, Config=None)
# Upload a file to an S3 object.

# Usage:

# import boto3
# s3 = boto3.resource('s3')
# s3.meta.client.upload_file('/tmp/hello.txt', 'mybucket', 'hello.txt')

s3 = boto3.resource('s3')
s3.meta.client.upload_file('/home/ec2-user/customer-fw.tbl-001', 'mdj-bucket-010', 'examples/customer-fw.tbl-001')

s3 = boto3.resource('s3')
s3.meta.client.upload_file(filename to upload, target bucketname, Targetfolder/filename)


create(**kwargs)
Creates a new bucket.

See also: AWS API Documentation

Request Syntax

response = bucket.create(
    ACL='private'|'public-read'|'public-read-write'|'authenticated-read',
    CreateBucketConfiguration={
        'LocationConstraint': 'EU'|'eu-west-1'|'us-west-1'|'us-west-2'|'ap-south-1'|'ap-southeast-1'|'ap-southeast-2'|'ap-northeast-1'|'sa-east-1'|'cn-north-1'|'eu-central-1'
    },
    GrantFullControl='string',
    GrantRead='string',
    GrantReadACP='string',
    GrantWrite='string',
    GrantWriteACP='string'
)

import boto3
s3 = boto3.resource('s3')
copy_source = {
    'Bucket': 'mybucket',
    'Key': 'mykey'
}
bucket = s3.Bucket('otherbucket')
bucket.copy(copy_source, 'otherkey')

#!/bin/env python

from __future__ import print_function

import boto3

s3 = boto3.resource('s3')
bucket= s3.Bucket('mdj-bucket-011')
response = bucket.create(
	  ACL='public-read'
	, CreateBucketConfiguration = {
		'LocationConstraint': 'us-west-2'
	}
	, GrantFullControl = 'string'

)

# Create bucket
#!/bin/env python

from __future__ import print_function

import boto3

s3 = boto3.resource('s3')
s3.create_bucket(Bucket='mdj-bucket-011'
	           , CreateBucketConfiguration={
         			'LocationConstraint': 'us-west-2'
         		}
         		, ACL='public-read'	
         		)


# Delete Bucket
#!/bin/env python

from __future__ import print_function

import boto3

s3 = boto3.resource('s3')
bucket = s3.Bucket('mdj-bucket-005')
s3.bucket.delete()


# Delete Bucket Objects
#!/bin/env python

from __future__ import print_function

import boto3

s3 = boto3.client('s3')
s3.delete_object(Bucket='mdj-bucket-005', Key='examples/customer-fw.tbl-000')

# Delete Objects by looping through - try this Wednesday morning.....
#!/bin/env python

from __future__ import print_function

import boto3


s3 = boto3.resource('s3')
bucket = s3.Bucket('mdj-bucket-006')

objects_to_delete = []
for obj in bucket.objects.filter(Prefix='examples/'):
    objects_to_delete.append({'Key': obj.key})

bucket.delete_objects(
    Delete={
        'Objects': objects_to_delete
    }
)


import boto3
s3 = boto3.resource('s3')
copy_source = {
    'Bucket': 'mybucket',
    'Key': 'mykey'
}
bucket = s3.Bucket('otherbucket')
bucket.copy(copy_source, 'otherkey')

# Upload files
#!/bin/env python

from __future__ import print_function

import boto3
s3 = boto3.resource('s3')
bucket = s3.Bucket('mdj-bucket-006')

filelist = ["customer-fw.tbl-000", "customer-fw.tbl-001" ]
for i in filelist :
#bucket.upload_file('/home/ec2-user/customer-fw.tbl-000', 'examples/customer-fw.tbl-000')
#bucket.upload_file('/home/ec2-user/customer-fw.tbl-001', 'examples/customer-fw.tbl-001')
	print("filelist to process-->%s" %i)

###################################################################################################

# Get customer-fw.tbl-999 files from /home/ec2-user directory, and Upload them
#!/bin/env python

from __future__ import print_function
import sys
from os import listdir
from os.path import isfile, join
import fnmatch
import boto3

bucketName = "mdj-bucket-006"
homedir="/home/ec2-user"
filename="customer-fw.tbl*"
targetFolder = "examples"

filelist = []

# select only the customer-fw.tbl* files, which are present in my home dir to upload
for i in sorted(listdir(homedir)):
	if isfile(i):
		if fnmatch.fnmatch(i, filename):   ###'customer-fw.tbl*') :
			filelist.append(i)

# With the above list, write the files to s3 bucket
for i in filelist:
	print("filelist object to copy to s3-->%s" %i)

	# Upload files into s3 bucket
	s3 = boto3.resource('s3')
	bucket = s3.Bucket(bucketName)

	# loop around filelist to load files
	#for i in filelist :
	bucket.upload_file(homedir + '/' + i, targetFolder + '/' + i)

#################################################################################################


# Delete Objects by looping through - try this Wednesday morning.....
#!/bin/env python

from __future__ import print_function

import boto3
from os.path import *

bucketName = "mdj-bucket-006"
homedir="/home/ec2-user"
filename="customer-fw.tbl*"
targetFolder = "examples"

s3 = boto3.resource('s3')
bucket = s3.Bucket(bucketName)

if isdir(targetFolder):
	objects_to_delete = []
	for obj in bucket.objects.filter(Prefix=targetFolder):
	    objects_to_delete.append({'Key': obj.key})
	
	bucket.delete_objects(
	    Delete={
	        'Objects': objects_to_delete
	    }
	)
else :
	print("targetFolder within bucket, does not exist-->" + bucketName + '/' + targetFolder )



