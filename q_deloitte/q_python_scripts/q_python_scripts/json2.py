
from __future__ import print_function  # need this to allow definition of SITE & EXPECTED


import os
import sys
from datetime import datetime
import json
#import ijson

#SITE = os.environ['site'] # URL of the site to check, stored in the site environment variable
#EXPECTED = os.environ['expected'] # String expected to be on the page, stored in the expected variable

def main(args):
	
	# '''
	# try:

	# except Exception as e:
	# 	raise
	# else:
	# 	pass
	# finally:
	# 	pass

	# Associating list elements
	# also know as an associative array, ie. key/value pairs

	# Dictionaries are the final type of data container available in Python.
	# In summary, the various types are:
	# Variable - stores a single value
	# List - stores multiple values in an ordered index
	# Tuple - stores multiple fixed values in a sequence
	# Set - stores multiple unique values in an unordered collection
	# Dictionary - stores multiple unordered key:value pairs	

	# '''
	# initialize a dictionary they display its key:value contents
	#dict = {'name':'Bob', 'ref':'Python', 'sys':'Win'}
	#print ('Dictionary:', dict )

	# next, display a single value referenced by its key
	#print ('\nReference:-->', dict['ref'] )
	#print ('\n')

	dict = {'key1':'value1', 'key2':'value2', 'key3':'value3'}
	print('Dict-->', dict)
	print('Dict-->' + str(dict))

	# select specific element from dict
	print("Reference, key2 value2-->", dict['key2'])

	# delete one pair from the dictionary and add a replacement pair then display the new key:value contents
	# del dict['name']
	# dict['user'] = 'Tom'
	# print ('Dictionary:', dict )

	# delete one pair from the dictionary, and add a replacemetn pair, then display the new key:value contents
	del dict['key1']
	dict['key4'] = 'Value4'
	print("List new dict-->", dict )
	print("List new sorted(dict) - returns only a key list-->", sorted(dict))


	dict = {
	    'first_name': 'Guido',
	    'second_name': 'Rossum',
	    'titles': ['BDFL', 'Developer'],
	}
	dict2json = json.dumps(dict)
	print("dict2json-->", dict2json)
	print("dict titles-->", dict['titles'])
	print("dict first element of titles-->", dict['titles'][1])

	dict = {
		"objects": [
				    {
				      "failureAndRerunMode": "CASCADE",
				      "resourceRole": "DataPipelineDefaultResourceRole",
				      "role": "DataPipelineDefaultRole",
				      "pipelineLogUri": "s3://mdj-bucket-logs/logs/",
				      "scheduleType": "ONDEMAND",
				      "name": "Default",
				      "id": "Default"
				    },
				    {
				      "name": "CliActivity",
				      "id": "CliActivity",
				      "runsOn": {
				        "ref": "Ec2Instance"
				      },
				      "type": "ShellCommandActivity",
				      "command": "(sudo yum -y update aws-cli) && (#{myAWSCLICmd})"
				    },
				    {
				      "instanceType": "t1.micro",
				      "name": "Ec2Instance",
				      "id": "Ec2Instance",
				      "type": "Ec2Resource",
				      "terminateAfter": "50 Minutes"
				    }
				  ],
		"parameters": [
		  			{
		  			  "watermark": "aws [options] <command> <subcommand> [parameters]",
		  			  "description": "AWS CLI command",
		  			  "id": "myAWSCLICmd",
		  			  "type": "String"
		  			}
		],
		"values": {
				    "myAWSCLICmd": "aws s3 ls s3://mdj-bucket-001/"
					}
}


	dict2jsondumps = json.dumps(dict)
	dict2jsonloads = json.loads(dict2jsondumps)
	print("\ndict2jsondumps-->", dict2jsondumps)
	print("\ndict2jsonloads-->", dict2jsonloads)

# json_str = json.dumps(data)
# Here is how you turn a JSON-encoded string back into a Python data structure:
# data = json.loads(json_str)

	# print("\ndict2json AWS-->", dict)
	# print("\ndict2json AWS myAWSCLICmd-->", dict['values']['myAWSCLICmd'])
	# print("\nObject-->paramters-->", dict['parameters'] )
	# print("\nObject-->paramters-->watermark-->", dict['parameters'][0]['watermark'] )
	#Object-->paramters-->watermark {'id': 'myAWSCLICmd', 'type': 'String', 'description': 'AWS CLI command', 'watermark': 'aws [options] <command> <subcommand> [parameters]'}
	# print("\nObjects-->0-->pipelineLogUri-->", dict['objects'][0]['pipelineLogUri'] )
	
	# list all elements of objects within loop
	# columns = list(dict)
	#column_names = [col["fieldName"] for col in columns]

	# the col in columns will return: objects, values, parameters
	# column_names = []
	# for col in columns:
	# 	print("\ncol-->", column_names) 
	# 	column_names.append(col)

	# print("\nColumn_names-->", column_names)

	
#import ijson

#filename = "md_traffic.json"
#with open(filename, 'r') as f:
    #objects = ijson.items(f, 'meta.view.columns.item')

	#objects = ijson.items(f, col)
    
	#columns = [col]


	# print("\ncolumns-->", [columns])  
	# for row in [column_names]:
	# 	print("dict[column_names]-->", row)	
	# 	for item in row:
	# 		#pass
	# 		print("item-->", row[column_names.index(item)]) 
			



if __name__ == '__main__':
		print ('Start of dict.py at-->' + format(str(datetime.now())))
		main(sys.argv[1:])
		print ('\nEnd of dict.py at-->' + format(str(datetime.now())))

	
	