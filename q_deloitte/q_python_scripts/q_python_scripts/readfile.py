#!/usr/bin/env python
#import boto3
#import base64
#import random
import json
#from twython import Twython

# Credentials setup
# Loads in 'creds.json' values as a dictionary
with open('/home/ec2-user/sparrow/creds.json') as f:
    credentials = json.loads(f.read())

