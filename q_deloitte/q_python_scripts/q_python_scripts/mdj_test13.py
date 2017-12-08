#!/usr/bin/env python

from __future__ import print_function
# -*- coding: utf-8 -*-
""" Read in and process dimension file. """
import os

# encoding=utf8  
import sys  
import re

reload(sys)  
sys.setdefaultencoding('utf8')
import urllib

import time
import datetime

import argparse     
import logging

import boto3
import botocore
                 
import psycopg2
import psycopg2.extras
import requests


#
# RedShift details
#
HOST = os.environ['HOST']
PORT = os.environ['PORT']
DBNAME = os.environ['DBNAME']
USER = os.environ['USER']
PASS = os.environ['PASS']  # amended this from 'PWD' to 'PASS' as '$PWD' is a LINUX reserved variable
CONFIG = {'dbname':DBNAME,
          'user':USER,
          'pwd':PASS,
          'host':HOST,
          'port':PORT
         }


#
# File details
#
LOG_FOLDER = os.environ['LOG_FOLDER'] # NEW definition: all logs from this script will reside in this folder
STAGING_FOLDER = os.environ['STAGING_FOLDER']
ERROR_FOLDER = os.environ['ERROR_FOLDER']
PROCESSED_FOLDER = os.environ['PROCESSED_FOLDER']
SCHEMA_FOLDER = os.environ['SCHEMA_FOLDER']


#
# Script name
#
SCRIPTNAME = sys.argv[0]
SCRIPTBASENAME = os.path.basename(SCRIPTNAME)
STARTTIME = datetime.datetime.now().strftime("%Y%m%d_%H%M%S.%f")


#
# logging to log file
#
logging.basicConfig(filename=LOG_FOLDER + '/' + SCRIPTBASENAME + '_' + STARTTIME + '.log',level=logging.DEBUG, format='%(asctime)s - %(levelname)s - %(message)s')
#logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')


#
# create database connection
#
def create_conn(**kwargs):
    logging.info(' | In function "' + sys._getframe().f_code.co_name + '"' )
    logging.info(' |\t Opening Redshift connection')
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
# Validation check for BATCH_ID - must be greater than 0. If not, script will terminate
#
def isBatchIdValid(BATCHID):
    logging.info(' | In function "' + sys._getframe().f_code.co_name + '"' )
    
    logging.info(' |\t Validating BATCH_ID passed from command line')
    if BATCHID > 0 :
        return True
    else:
        return False


#
# Check for existence of transform filename - script will terminate if not present
#
def isTransformFilePresent(FILENAME):
    logging.info(' | In function "' + sys._getframe().f_code.co_name + '"' )
    
    if not os.path.isfile(FILENAME):
        logging.error('|\t Transform file does NOT exist-->%s' %(str(FILENAME)) )
        formatErrorLog(SCRIPTNAME, 'ENDED ABNORMALLY')

        sys.exit(1)
    else:
        logging.info(' |\t Transform file exists-->%s' %(str(FILENAME)) )
        

#
# check for existence of table - not currently used
#
def isStageTablePresent():
    logging.info(' | In function "' + sys._getframe().f_code.co_name + '"' )
    
    cursor.execute("SELECT COUNT(*) AS resultcount FROM pg_tables WHERE schemaname = 'stage' and table = '" + tablename + "'")
    resultrow = cursor.fetchone()
    
    if resultrow['resultcount'] == 1:
        return True
    else:
        return False 


#
# readfile function - read through the transform file, and return the content
#
def readfile(FILENAME):
    logging.info(' | In function "' + sys._getframe().f_code.co_name + '"' )
    
    #
    # define file pointer to transform file, and return contents
    #
    try:
        f = open(FILENAME)

    except IOError, e:
        logging.error('|\t Transform file does NOT exist-->%s' %(str(FILENAME)) )
        error_line_no = sys.exc_traceback.tb_lineno
        logging.error('|\t Line number: %s. Error: %s' %(error_line_no, e))
        formatErrorLog(SCRIPTNAME, 'ERROR - SCRIPT TERMINATING')

        sys.exit(1)
    else:
        
        logging.info(' |\t Transform file being retured to main() for population of "query_string" variable')
        return(f.read())


#
# Format INFO log msgs
#
def formatInfoLog(scriptname, msg):

    logging.info(" +" +  "-" * 100 + "+")
    logging.info(' | Script: ' + scriptname + ' ' + msg)
    logging.info(" +" +  "-" * 100 + "+")


#
# Format ERROR log msgs
#
def formatErrorLog(scriptname, msg):

    logging.info(" +" +  "-" * 100 + "+")
    logging.error('| Script: ' + scriptname + ' ' + msg)
    logging.info(" +" +  "-" * 100 + "+")


#
# Format Heading within log msgs
#
def formatHeadingLog(msg):

    logging.info(' | ' + "-" * len(msg) )
    logging.info(' | ' + msg )
    logging.info(' | ' + "-" * len(msg) )
    logging.info(' |' )

#
# main function - checking for errors
#
def main(args):

    #
    # logging information msg
    #
    formatInfoLog(SCRIPTNAME, 'STARTING')
    logging.info(' | In function "' + sys._getframe().f_code.co_name + '"')


    #
    # Validation Check for Batch_Id 
    #
    if isBatchIdValid(BATCH_ID):
        logging.info(' |\t BATCH_ID: ' + str(BATCH_ID) + ' passed is VALID')
    else:
        logging.error('|\t BATCH_ID: ' + str(BATCH_ID) + ' passed is INVALID')  
        formatErrorLog(SCRIPTNAME, 'ERROR - SCRIPT TERMINATING')

        sys.exit(1)
    
    #
    ############################################################################################################
    # CHECK TO SEE IF WE NEED TO FURHTER VALIDATE BATCH_ID passed, such that we don't pass duplicate BATCH_ID'S
    ############################################################################################################
    #
    
    batchid = int(BATCH_ID)

    for tf in FILENAME:

        #
        # open connection to Redshift
        #
        rs_conn = create_conn(config=CONFIG)
        cursor = rs_conn.cursor()

        
        #
        # Existence Check for transform file
        #
        logging.info(' | Validating existence of transform file passed: %s' %(tf))

        isTransformFilePresent(tf)
        

	    #
	    # Call to the passed SQL transform
        #
        query_string = readfile(tf)
        
        logging.info(' | Initializing query_string, from transform file')

        formatHeadingLog('Transform below, called to execute:')
        

        #
        # log executable steps with the transform file 
        #
        for line in query_string.splitlines():
            logging.info(' |\t %s' %(line))      


        #
        # Replacement query_string, containing transposed BATCH_ID
        #        
        repl_query_string = re.sub(r'##BATCH_ID##', str(BATCH_ID), query_string )
        
        if repl_query_string != query_string:

            logging.info(' | Initializing REPLACEMENT query_string, from transform file')

            formatHeadingLog('REPLACEMENT Transform below, called to execute:')

            #
            # log REPLACEMENT executable steps with the transform file 
            #
            for line in repl_query_string.splitlines():
                logging.info(' |\t %s' %(line))      


        #
        # Execute query_string from transform file, as cursor, and commit   
        #            
        try:
            cursor.execute(repl_query_string)
            rs_conn .commit() 
            

            #
            # This section of code is specific to a SELECT_*.sql transform file, in that it will only list the contents of the table to be updated
            # - This allows visibility within the LOG as to the before/after executed code
            #  
            if os.path.basename(tf).startswith('SELECT_'):
                rows = []
                rows = cursor.fetchall()
                #
                # list first 10 colums from all rows returned from SELECT
                #
                logging.info(' |' )
                logging.info(' |\t Returning first 10 columns from SQL--> %s' %(os.path.basename(tf)) )
                
                for row in rows:
      
                    logging.info(' |\t %s' %( re.sub(r'  *', ' ', str(row[0:10]) )))   #row[0]
                    
                logging.info(' |' )

        except psycopg2.Error, e:

            logging.error('| ERROR! Failed to apply SQL as passed within transform file-->%s' %(str(tf)))    
            logging.error('| Error %s' %(re.sub(r'\n', '', str(e))))


        #
        # increment batchid in readiness for next process - Used for testing
        #
        #batchid += 1


    #
    # logging information msg
    #
    logging.info(' | End of def main()')
    
    formatInfoLog(SCRIPTNAME, 'ENDING')


def lambda_handler(event, context):
#
# Handler is triggered manually, or by cron - there is no file delivery per say
#
    pass    # need to sort this out


#
# Start of mainline.....
#
if __name__ == "__main__":
    
    parser = argparse.ArgumentParser(description='PYTHON FRAMEWORK FOR PROCESSING "SQL" TRANSFORM FILES ON REDSHIFT' )
    
    parser.add_argument(
        "-b",
        "--batchid",
        help="The Batch Id of the process being passed",
        #       default=1,
        type=int)
    
    parser.add_argument(
        "-t",
        "--transforms",
        help="The name(s) of the transforms to load",
        nargs = "*",
        #default = argparse.SUPPRESS,
        type=str)
    
    args = parser.parse_args()

    
    #
    # pass in batchid
    #
    if not (vars(args))['batchid']:
        parser.print_help()

        sys.exit(1)

    BATCH_ID = args.batchid


    #
    # pass in transform to execute
    #
    if not (vars(args))['transforms']:
        parser.print_help()

        sys.exit(1)  


    #
    # pass in transform filenames
    #
    for key, value in vars(args).iteritems():
    
        if key == 'transforms':
            rec = []        
            rec = value


    #
    # allow multiple filenames to be passed via command line
    #   
    FILENAME = []
    
    for key, value in vars(args).iteritems():
        FILENAME = value


    main(sys.argv[1:])

#
# That's all Folks!!!!
#
