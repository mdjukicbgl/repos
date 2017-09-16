#!/bin/env python

import sys
import boto3

def main(args):
	
	#bucket_name = sys.argv[1]

	s3 = boto3.resource("s3")
	for bucket_name in sys.argv[1:]:
	    try:
	        response = s3.create_bucket(Bucket=bucket_name, CreateBucketConfiguration={'LocationConstraint': 'us-west-2'})
	        print response
	    except Exception as error:
	        print error

if __name__ == '__main__':
	main(sys.argv[1:])


######################
from __future__ import print_function

import json
import urllib
import boto3

print('Loading function')

s3 = boto3.client('s3')


def lambda_handler(event, context):
    #print("Received event: " + json.dumps(event, indent=2))

    # Get the object from the event and show its content type
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = urllib.unquote_plus(event['Records'][0]['s3']['object']['key'].encode('utf8'))
    try:
        response = s3.get_object(Bucket=bucket, Key=key)
        print("CONTENT TYPE: " + response['ContentType'])
        return response['ContentType']
    except Exception as e:
        print(e)
        print('Error getting object {} from bucket {}. Make sure they exist and your bucket is in the same region as this function.'.format(key, bucket))
        raise e




###################################################################
# Configure Scheduled test, for Serverless Function - Qwiklabs.....

{
  "Records": [
    {
      "eventVersion": "2.0",
      "eventTime": "1970-01-01T00:00:00.000Z",
      "requestParameters": {
        "sourceIPAddress": "127.0.0.1"
      },
      "s3": {
        "configurationId": "testConfigRule",
        "object": {
          "eTag": "0123456789abcdef0123456789abcdef",
          "key": "00001_create_schema_sfmc*",
          "sequencer": "0A1B2C3D4E5F678901",
          "size": 1024
        },
        "bucket": {
          "ownerIdentity": {
            "principalId": "EXAMPLE"
          },
          "name": "mdj-lambda-001",
          "arn": "arn:aws:s3:::mdj-lambda-001"
        },
        "s3SchemaVersion": "1.0"
      },
      "responseElements": {
        "x-amz-id-2": "EXAMPLE123/5678abcdefghijklambdaisawesome/mnopqrstuvwxyzABCDEFGH",
        "x-amz-request-id": "EXAMPLE123456789"
      },
      "awsRegion": "us-east-1",
      "eventName": "ObjectCreated:Put",
      "userIdentity": {
        "principalId": "EXAMPLE"
      },
      "eventSource": "aws:s3"
    }
  ]
}

