#!/bin/env python

from __future__ import print_function

import sys
import os
import argparse

#############################################################
# mdj implementation for passing :

print('Start of mdj_test4.py.....')

parser = argparse.ArgumentParser()
    
parser.add_argument(
    "-b",
    "--buildid",
    help="The Build Id of the process being passed",
    type=int)
    
parser.add_argument(
    "-t",
    "--transform",
    help="The name of the transform to load",
    type=str)
    
parser_args = parser.parse_args()
   
if not (vars(parser_args))['buildid']:
    parser.print_help()
    sys.exit(1)

if not (vars(parser_args))['transform']:
    parser.print_help()
    sys.exit(1)    
    
aws_batchid = str(parser_args.batchid)
aws_transform = str(parser_args.transform)
#
#############################################################

print('build-->', aws_batchid)
print('transform-->', aws_transform)

#parser = argparse.ArgumentParser()
#parser.add_argument("echo", help="echo the string you use here")
#args = parser.parse_args()
#print args.echo




HOST   = os.environ['HOST']
PORT   = os.environ['PORT']
DBNAME = os.environ['DBNAME']
USER   = os.environ['USER']
PWD    = os.environ['PWD']

CONFIG = {'dbname':DBNAME,
          'user':USER,
          'pwd':PWD,
          'host':HOST,
          'port':PORT
         }

print('host-->',)
