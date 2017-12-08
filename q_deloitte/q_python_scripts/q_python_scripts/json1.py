
#!/bin/env python

# {"name": "Frank", "age": 39, "isEmployed": true  }
from __future__ import print_function

import json
import sys


class Employee(object):
    def __init__(self, name):
        self.name = name


def main(args):
	
	dict = {"ChristianName": "Frank", "age": 39, "isEmployed": True  }
	dict2json = json.dumps(dict)
	
	print("dict2json-->" + dict2json)

	abder = Employee('Abder')
	jsonAbder = json.dumps(abder, default=jsonDefault)
	
	print("jsonabder-->" + jsonAbder)


def jsonDefault(object):
    return object.__dict__


if __name__ == '__main__':

	main(sys.argv[1:])

