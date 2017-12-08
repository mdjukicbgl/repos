#
# Now, say that you want to download that file to another machine.
# You could simply use the following command:
#

import boto
from boto.s3.connection import Location

s3 = boto.connect_s3()
key = s3.get_bucket('mdj-bucket-009').get_key('examples/customer-fw.tbl-000')
key.get_contents_to_filename('/home/ec2-user/mdj_downloadedfile')

s3 = boto.connect_S3()
key = s3.get_bucket('mdj-bucket-005')
key.get_key('examples/customer-fw.tbl-000').get_contents_to_filename('/home/ec2-user/mdj_downloadedfile')

key = s3.get_bucket(bucketname).get_key(bucketFolder/filname).get_contents_to_filename('/home/ec2-user/targerFilename')


key = bucket.create_bucket('mdj-bucket-001').set_contents_to_filename('bucketFolder/filename').set_acl

