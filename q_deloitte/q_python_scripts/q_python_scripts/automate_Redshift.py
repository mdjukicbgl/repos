### List all buckets and their contents
#!/bin/env python

import boto3

s3 = boto3.resource('s3')
for bucket in s3.buckets.all():
    print bucket.name
    print "----->"
    for item in bucket.objects.all():
        print "\t%s" % item.key


### Create a bucket, as passed into script
#!/bin/env python

import sys
import boto3

s3 = boto3.resource("s3")
for bucket_name in sys.argv[1:]:
    try:
        response = s3.create_bucket(Bucket=bucket_name)
        print response
    except Exception as error:
        print error


### Write a file to a bucket
#!/bin/env python
import sys
import boto3

s3 = boto3.resource("s3")
bucket_name = sys.argv[1]
object_name = sys.argv[2]

try:
    response = s3.Object(bucket_name, object_name).put(Body=open(object_name, 'rb'))
    print response
except Exception as error:
    print error


### Delete a bucket
#!/bin/env python

import sys
import boto3

s3 = boto3.resource("s3")
for bucket_name in sys.argv[1:]:
    bucket = s3.Bucket(bucket_name)
    try:
        response = bucket.delete()
        print response
    except Exception as error:
        print error


### Delete bucket contents
#!/bin/env python

import sys
import boto3

# delete bucket objects section
s3 = boto3.resource('s3')
for bucket_name in sys.argv[1:]:
	bucket = s3.Bucket(bucket_name)
	for key in bucket.objects.all():
		try:
			response = key.delete()
			print response
		except Exception as error:
			print error

# delete bucket as well, after bucket objects have been deleted
	try:
		response = bucket.delete()
		print response
	except Exception as error:
		print error


### list Redshift clusters
#!/bin/env python

from __future__ import print_function
import boto3
from pprint import pprint

redshift = boto3.client('redshift')
try:
# get all of the db instances
    dbs = redshift.describe_clusters()
    pprint(dbs, indent=4)
    for db in dbs['Clusters']:
        #print("\ndb-->", db)
        print ("\nMasterUsername-->%s" %(db['MasterUsername']) )
        print ("\nEndpoint-->Address-->%s" %(db['Endpoint']['Address']) )
        print ("\nMasterUsername-->%s@%s %s %s" %(db['MasterUsername'], db['Endpoint']['Address'], db['Endpoint']['Port'], db['ClusterStatus']) )

except Exception as error:
        print("\nprint error-->",  error)

### List ec2-instances
#!/bin/env python

from __future__ import print_function
import json
import sys
from pprint import pprint

jdata = sys.stdin.read()

data = json.loads(jdata)

print("InstanceId", " - ", "Name", " - ", "Owner")
print(data["Instances"][0]["InstanceId"] ) ###, " - " ) ,data["Instances"][0]["Tags"][1]["Value"], " - " ,data["Instances"][0]["Tags"][2]["Value"] )
###print(data["Instances"][0]["InstanceId"], " - " ,data["Instances"][0]["Tags"][1]["Value"], " - " ,data["Instances"][0]["Tags"][2]["Value"] )


### Create a bucket, as passed into script
#!/bin/env python

import sys
import boto3

s3 = boto3.resource("s3")
for bucket in s3.buckets.all():
	print("bucket names-->", bucket)

#print("\ns3.buckets.all()-->", s3.buckets.all() )

# convert output to a list
buckets = list(s3.buckets.all())

for bucket in buckets:
	print("buckets_list-->", bucket)


### Filtering
#!/bin/env python

from __future__ import print_function
import boto3

s3 = boto3.resource('s3')
for bucket in s3.buckets.all():
	for object in bucket.objects.filter(Prefix='load/customer'):
		print('{0}:{1}'.format(bucket.name, object.key)


##########################

#!/bin/env python

import sys
import boto3

bucket_name = sys.argv[1]
folder_name = sys.argv[2]

# if folder_name:
#         bucket_name = bucket_name + '/' + folder_name
#         print('bucket_name-->', bucket_name)
# else:
#         bucket_name = bucket_name
#         print('bucket_name-->', bucket_name)



s3 = boto3.resource("s3")
for bucket_name in sys.argv[1:]:
    try:
        response = s3.create_bucket(Bucket=bucket_name + '/' + folder_name, CreateBucketConfiguration={'LocationConstraint': 'us-west-2'})
        print response
    except Exception as error:
        print error
