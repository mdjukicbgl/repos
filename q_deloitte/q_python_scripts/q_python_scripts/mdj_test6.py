#!/usr/bin/env python

from __future__ import print_function
# -*- coding: utf-8 -*-
""" Read in and process dimension file. """
import os

# encoding=utf8  
import sys  

reload(sys)  
sys.setdefaultencoding('utf8')
import urllib
#import errno
#import getopt
import datetime

import argparse     
import logging

import boto3
import botocore
#sys.path.append(os.path.join(os.path.dirname(os.path.realpath(__file__)), "lib"))
#sys.path.append(os.path.join(os.path.dirname(os.path.realpath(__file__)), "vendor"))

#import json
#import jsonschema
#from jsonschema import validate

import psycopg2

import psycopg2.extras
import requests
#import boto
#from boto.s3.key import Key
#import smart_open


#
# RedShift details
#
HOST = os.environ['HOST']
PORT = os.environ['PORT']
DBNAME = os.environ['DBNAME']
USER = os.environ['USER']
PASS = os.environ['PASS']
CONFIG = {'dbname':DBNAME,
          'user':USER,
          'pwd':PASS,
          'host':HOST,
          'port':PORT
         }

#
# S3 Details
#
#S3 = boto3.client('s3')
#ACCESS_KEY_ID = os.environ['ACCESS_KEY_ID']
#SECRET_ACCESS_KEY = os.environ['SECRET_ACCESS_KEY']


#
# File details
#
#STAGING_FOLDER = os.environ['STAGING_FOLDER']
#ERROR_FOLDER = os.environ['ERROR_FOLDER']
#PROCESSED_FOLDER = os.environ['PROCESSED_FOLDER']
#SCHEMA_FOLDER = os.environ['SCHEMA_FOLDER']


#
# Default batch id
#
#BATCH_ID = 1
# passed in from the command line via argparse


#
# Script name
#
SCRIPTNAME = sys.argv[0]
#SCRIPTNAME = os.path.basename(SCRIPT)


#
# logging 
#
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logging.info('Script: ' + SCRIPTNAME + ' Starting.')


#
# Sample file to test with
#
#FILENAME = '/Users/mdjukic/Desktop/q_python_scripts/q_python_scripts/sampleSQLfile.dat.py'


#
# create database connection
#
def create_conn(**kwargs):
    """ Connection details """
    config = kwargs['config']
    try:
        con = psycopg2.connect(dbname=config['dbname'],
                               host=config['host'],
                               port=config['port'],
                               user=config['user'],
                               password=config['pwd'])
        return con
    except requests.ConnectionError as err:
        print(err)


#
# Validation check for BATCH_ID - must be greater than 0
#
def isBatchIdValid(BATCHID):

    if BATCHID > 0 :
        return True
    else:
        return False


#
# check for existence of transform filename - Not really needed as transform could be anything
#
def isTransformFilePresent(FILENAME):
    try:
        os.path.isfile(FILENAME)

    except Exception, e:
        error_line_no = sys.exc_traceback.tb_lineno
        logging.error('Line number: %s. Error: %s' % (error_line_no,e))
        sys.exit(1)


#
# check for existence of table
#
def isStageTablePresent():
    cursor.execute("SELECT COUNT(*) AS resultcount FROM pg_tables WHERE schemaname = 'stage' and table = '" + tablename + "'")
    resultrow = cursor.fetchone()
    
    if resultrow['resultcount'] == 1:
        return True
    else:
        return False 


#
# substitute parameters if needed
#
#def substitute_parameters(sql_statement):
#    for parametername in dir(redshiftconfig):
#        if not parametername.startswidth("__"):
#            sql_statement = sql_statement.replace('{' + parametername + '}', str(getattr(redshiftconfig, parametername)))

#    config = ConfigParser.RawConfigParser()
#    config.read(os.getenv("HOME") + '/.boto')
       
#    sql_statement = sql_statement.replace('{aws_access_key_id}', ACCESS_KEY_ID)
#    sql_statement = sql_statement.replace('{aws_secret_access_key}', SECRET_ACCESS_KEY)
    
#    return sql_statement


#
# readfile function - read through the transform file, and return the content
#
def readfile(FILENAME):
    
    #
    # define file pointer to transform file, and return contents
    #
    f = open(FILENAME) 
    
    return(f.read())

#
# main function - checking for errors
#
def main(args):

    #
    # logging information msg
    #
    logging.info('Start of def main()')


	#
	# open connection to Redshift
	#
    logging.info('Opening Redshift connection')
    
    rs_conn = create_conn(config=CONFIG)
    cursor = rs_conn.cursor()


    #
    # Validation Check for Batch_Id 
    #
    logging.info('Validating BATCH_ID passed from command line')
    
    if isBatchIdValid(BATCH_ID):
        logging.info('BATCH_ID passed is valid')
    else:
        logging.info('BATCH_ID passed is invalid')  

    
    #
    ############################################################################################################
    # CHECK TO SEE IF WE NEED TO FURHTER VALIDATE BATCH_ID passed, such that we don't pass duplicate BATCH_ID'S
    ############################################################################################################
    #
    

    #
    # Existence Check for transform file
    #
    logging.info('Validating existence of transform file passed')

    isTransformFilePresent(FILENAME)


	#
	# Call to the passed SQL transform
    #
    logging.info('Initializing query_string, from transform file')

    query_string = readfile(FILENAME)
    
    try:
        cursor.execute(query_string)
    
    except psycopg2.Error, e:

        logging.error('ERROR! Failed to apply SQL as passed within transform file', str(FILENAME))    
        logging.error('Error %s' %e)
    
    raise e              


    #
    # logging information msg
    #
    logging.info('End of def main()')

    
#
# Start of mainline.....
#
if __name__ == "__main__":
    
    parser = argparse.ArgumentParser()
    
    parser.add_argument(
        "-b",
        "--batchid",
        help="The Batch Id of the process being passed",
        default=1,
        type=int)
    
    parser.add_argument(
        "-t",
        "--transform",
        help="The name of the transform to load",
        default='/Users/mdjukic/Desktop/q_python_scripts/q_python_scripts/sampleSQLfile.dat',
        type=str)
    
    args = parser.parse_args()

    
    #
    # pass in batchid
    #
    if not (vars(args))['batchid']:
        parser.print_help()
        sys.exit(1)

    #
    # pass in transform to execute
    #
    if not (vars(args))['transform']:
        parser.print_help()
        sys.exit(1)    
    
    BATCH_ID = str(args.batchid)
    FILENAME = str(args.transform)
    
    main(sys.argv[1:])

#
# That's all Folks!!!!
#
