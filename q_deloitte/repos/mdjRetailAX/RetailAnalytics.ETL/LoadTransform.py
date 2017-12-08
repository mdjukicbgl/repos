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
sys.path.append(os.path.join(os.path.dirname(os.path.realpath(__file__)), "lib"))
sys.path.append(os.path.join(os.path.dirname(os.path.realpath(__file__)), "vendor"))
                
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
# SQS Queue name
#
SQS_QUEUE = os.environ['SQS_QUEUE']


#
# Add SQS service and details - Get the service resource
#
sqs = boto3.resource('sqs')


#
# Get msg queue
#
queue = sqs.get_queue_by_name(QueueName=SQS_QUEUE)


#
# Setup BATCH_FLAG, & BATCH_ID via environment variables
#
BATCH_FLAG = os.environ['BATCH_FLAG_ID'].split(" ", 1)[0]
BATCH_ID = os.environ['BATCH_FLAG_ID'].split("-b", 1)[-1]
 
TRANSFORM_FLAG = os.environ['TRANSFORM_FLAG_LABELS'].split(" ", 1)[0]
TRANSFORM_FILENAMES = os.environ['TRANSFORM_FLAG_LABELS'].split("-t", 1)[-1]
 
 
#
# Script name
#
SCRIPTNAME = sys.argv[0]
SCRIPTBASENAME = os.path.basename(SCRIPTNAME)
STARTTIME = datetime.datetime.now().strftime("%Y%m%d_%H%M%S.%f")
 
#
# Determine if script is called from lambda, or the command line
#
if SCRIPTBASENAME == 'bootstrap.py':
    #
    # called from lambda, therefore, log to Cloudwatch
    # Python logger in AWS Lambda has a preset format. To change the format of the logging statement, remove the logging handler
    # and add a new handler with the required format
    #
    logger = logging.getLogger()
    for handler in logger.handlers:
        logger.removeHandler(handler)
 
    #
    # create a file handler, and define logging format
    #
    handler = logging.StreamHandler(sys.stdout)
    handler.setFormatter(logging.Formatter('%(asctime)s - %(levelname)s - %(message)s'))
 
    #
    # add handler to the logger, and set logging level
    #
    logger.addHandler(handler)
    logger.setLevel(logging.INFO)
 
 
else:
    #
    # called from main()
    #
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)
 
    #
    # create a file handler
    #
    handler = logging.FileHandler(LOG_FOLDER + '/' + SCRIPTBASENAME + '_' + STARTTIME + '.log')
    handler.setLevel(logging.INFO)
 
    #
    # create a logging format
    #
    formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
    handler.setFormatter(formatter)
 
    #
    # add the handlers to the logger
    #
    logger.addHandler(handler)
 

#
# create database connection
#
def create_conn(**kwargs):
    logger.info(' | ')
    logger.info(' | In function "' + sys._getframe().f_code.co_name + '"' )
    logger.info(' |\t Opening Redshift connection')
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
    logger.info(' | In function "' + sys._getframe().f_code.co_name + '"' )
   
    logger.info(' |\t Validating BATCH_ID passed from command line')
    if BATCHID > 0 :
        return True
    else:
        return False
 
 
#
# Check for existence of transform filename - script will terminate if not present
#
def isTransformFilePresent(FILENAME):
    logger.info(' | In function "' + sys._getframe().f_code.co_name + '"' )
   
    if not os.path.isfile(FILENAME):
        logger.error('|\t Transform file does NOT exist-->%s' %(str(FILENAME)) )
        formatErrorLog(SCRIPTNAME, 'ENDED ABNORMALLY')
 
        sys.exit(1)
    else:
        logger.info(' |\t Transform file exists-->%s' %(str(FILENAME)) )
       
 
#
# check for existence of table - not currently used
#
def isStageTablePresent():
    logger.info(' | In function "' + sys._getframe().f_code.co_name + '"' )
   
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
    logger.info(' | In function "' + sys._getframe().f_code.co_name + '"' )
   
    #
    # define file pointer to transform file, and return contents
    #
    try:
        f = open(FILENAME)
 
    except IOError, e:
        logger.error('|\t Transform file does NOT exist-->%s' %(str(FILENAME)) )
        error_line_no = sys.exc_traceback.tb_lineno
        logger.error('|\t Line number: %s. Error: %s' %(error_line_no, e))
        formatErrorLog(SCRIPTNAME, 'ERROR - SCRIPT TERMINATING')
 
        sys.exit(1)
    else:
       
        logger.info(' |\t Transform file being retured to main() for population of "query_string" variable')
        return(f.read())
 
 
#
# Format INFO log msgs
#
def formatInfoLog(scriptname, msg):
 
    logger.info(" +" +  "-" * 100 + "+")
    logger.info(' | Script: ' + scriptname + ' ' + msg)
    logger.info(" +" +  "-" * 100 + "+")
 
 
#
# Format ERROR log msgs
#
def formatErrorLog(scriptname, msg):
 
    logger.info(" +" +  "-" * 100 + "+")
    logger.error('| Script: ' + scriptname + ' ' + msg)
    logger.info(" +" +  "-" * 100 + "+")
 
 
#
# Format Heading within log msgs
#
def formatHeadingLog(msg):
 
    logger.info(' +' + "-" * len(msg) )
    logger.info(' | ' + msg )
    logger.info(' +' + "-" * len(msg) )
    logger.info(' |' )
 
 
#
# Format INFO log msgs
#
def QueryProgressHeader():

    logger.info(' +' + '-' * 50)
    logger.info(' | QUERY PROGRESS COUNTER:')
    logger.info(' +' + '-' * 50)


#
# Format INFO log msgs
#
def QueryProgressInfo(msg):

    regex = re.compile('.*BEGIN.*|.*COMMIT.*')
 
    if not regex.match(msg):
 
         logger.info(' | ' + msg)

 
#
# main function - checking for errors
#
def main(BATCH_ID, FILENAME):
 
    #
    # logging information msg - conditional if called from lambda_handler or from command line
    #
    if SCRIPTBASENAME != 'bootstrap.py':
        formatInfoLog(SCRIPTNAME, 'STARTING')
 
    else:
        FILENAME = FILENAME.lstrip(" ").split(" ")
 
    logger.info(' | In function "' + sys._getframe().f_code.co_name + '"')
 
 
    #
    # Validation Check for Batch_Id
    #
    if isBatchIdValid(BATCH_ID):
        logger.info(' |\t BATCH_ID: ' + str(BATCH_ID) + ' passed is VALID')
    else:
        logger.error('|\t BATCH_ID: ' + str(BATCH_ID) + ' passed is INVALID') 
        formatErrorLog(SCRIPTNAME, 'ERROR - SCRIPT TERMINATING')
 
        sys.exit(1)
   
    #
    # process each transform file as passed via the '-t' parameter
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
        logger.info(' | Validating existence of transform file passed: %s' %(tf))
 
        isTransformFilePresent(tf)
       
 
        #
        # Call to the passed SQL transform
        #
        query_string = readfile(tf)
       

        #
        # Replacement query_string, containing transposed BATCH_ID
        #       
        repl_query_string = re.sub(r'##BATCH_ID##', str(BATCH_ID), query_string )
       
        if True:
 
            logger.info(' | Initializing REPLACEMENT query_string, from transform file')
            logger.info(' |' )
 
            formatHeadingLog('REPLACEMENT Transform below, called to execute: ')
 
            #
            # log REPLACEMENT executable steps with the transform file
            #
            for line in repl_query_string.splitlines():
                logger.info(' |\t %s' %(line))     
 
 
        #
        # split repl_query_string into a list for processing - used to get each Progress counter
        #
        sqlstring = repl_query_string.split(';')
 
        #
        # Remove elements from list which only contain '\n*'
        #
        regex = re.compile('^ *\n* *$')
        sqlstring = [line for line in sqlstring if not regex.match(line)]


        regex = re.compile(r'[^-]*--.*(\n)*.*$')
        sqlstring = [line for line in sqlstring if not regex.search(line)]
 

        #
        # enumerate this loop, to get index counter, starting at 1
        #
        progress_counters = []

        transform_error = 0

        for (index, sqlcode) in enumerate(sqlstring,1):
 
            runtime = datetime.datetime.now().strftime("%Y%m%d_%H%M%S.%f")

            repl_query_string = sqlcode
           
            #
            # Execute query_string from transform file, as cursor, and commit  
            #           
            try:
                cursor.execute(repl_query_string)


                #
                # Report Progress counter
                #          
                if cursor.statusmessage == 'SELECT':
   
                    progress_counters.append('** ' + cursor.statusmessage + ' ' + str(cursor.rowcount) + ' ROWS')
                        
                else:
   
                    progress_counters.append('** ' + cursor.statusmessage + ' ROWS')
                    
    
                #
                # This section of code is specific to a SELECT_*.sql transform file, in that it will only list the contents 
                # of the table to be updated
                # - This allows visibility within the logger as to the before/after executed code
                # 
                if os.path.basename(tf).startswith('SELECT_'):   
                    rows = []
                    rows = cursor.fetchall()
                    #
                    # list first 10 colums from all rows returned from SELECT
                    #
                    logger.info(' |' )
                    logger.info(' |\t Returning first 10 columns from SQL--> %s' %(os.path.basename(tf)) )
                   
                    for row in rows:
         
                        logger.info(' |\t %s' %( re.sub(r'  *', ' ', str(row[0:10]) )))   #row[0]
                       
                    logger.info(' |' )
   
            except psycopg2.Error, e:
   
                transform_error = 1

                rs_conn.rollback()
                logger.error('| ')
                logger.error('| ERROR! Failed to apply SQL as passed within transform file-->%s' %(str(tf)))
                logger.error('| ERROR! Transaction is being rolled back' )  
                  
                #
                # format output error msg for logging
                #
                for line in str(e).splitlines():
                    logger.error('|\t %s' %(line))
                logger.error('|')

   
                #
                # Send msg to SQS message queue
                #
                logger.error('|')

                data = "LoadTransform %s ERROR encountered" %(os.path.basename(str(tf)))

                queue.send_message(
                      MessageBody=str(data)
                    , MessageGroupId='LoadTransformERROR_%s_%s' %(os.path.basename(str(tf)), runtime )
                    , MessageDeduplicationId='LoadTransformERROR_%s_%s' %(os.path.basename(str(tf)), runtime )
                )

  
                #
                # Rollback encountered, therefore, progress_counters must reflect accordingly
                #
                progress_counters.append('** ERROR encountered within this transform script - transactions ROLLEDBACK')   


                break
                
            else:
   
                pass


        #
        # report on progress counters
        #
        for (index, progress_counter) in enumerate(progress_counters,1):

            if index == 1:
                QueryProgressHeader() # include heading on fist cycle
                    
            QueryProgressInfo(progress_counter)
        
        #
        # commit transactions at this point
        #
        rs_conn.commit()

        # 
        # No error encountered within load, send msg to SQS queue
        #
        if transform_error == 0:
            #
            # Send msg to SQS message queue
            #
            logger.info(' |')

            data = "LoadTransform %s completed successfully" %(os.path.basename(str(tf)))

            queue.send_message(
                  MessageBody=str(data)
                , MessageGroupId='LoadTransformSUCCESS_%s_%s' %(os.path.basename(str(tf)), runtime )
                , MessageDeduplicationId='LoadTransformSUCCESS_%s_%s' %(os.path.basename(str(tf)), runtime)
            )
 

    #
    # logging information msg
    #
    logger.info(' |')
    logger.info(' | End of def main()')
   
    formatInfoLog(SCRIPTNAME, 'ENDING')
 
 
def lambda_handler(event, context):
 
    #
    # Handler is triggered by completion of processing of a task, or multi-tasks.....
    #
    formatInfoLog(context.function_name + ': ' + SCRIPTNAME, 'STARTING')
    logger.info(' | In function "' + sys._getframe().f_code.co_name + '"')
   
    #
    # Setup BATCH_FLAG, & BATCH_ID via environment variables
    #
    BATCH_FLAG = os.environ['BATCH_FLAG_ID'].split(" ", 1)[0]
    BATCH_ID = os.environ['BATCH_FLAG_ID'].split("-b", 1)[-1]
 
    TRANSFORM_FLAG = os.environ['TRANSFORM_FLAG_LABELS'].split(" ", 1)[0]
    TRANSFORM_FILENAME = os.environ['TRANSFORM_FLAG_LABELS'].split("-t", 1)[-1]
 
    try:
        logger.info(' | Calling main() from within lambda_handler-->%s %s %s %s' %(BATCH_FLAG, BATCH_ID, TRANSFORM_FLAG, TRANSFORM_FILENAME) )
       
        main(BATCH_ID, TRANSFORM_FILENAME)
 
    except Exception as lambda_error:
 
        logger.error(' | ERROR! lambda error encountered-->%s' %(lambda_error))
 
        raise lambda_error
 
 
#
# Start of mainline.....
#
if __name__ == "__main__":
   
    logging.basicConfig(filename=LOG_FOLDER + '/' + SCRIPTBASENAME + '_' + STARTTIME + '.log',level=logging.DEBUG, format='%(asctime)s - %(levelname)s - %(message)s')
 
    #
    # This section is only be executed if called via the command line, else lambda_handler will be used as calling script
    #
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
 
 
    main(BATCH_ID, FILENAME)
 
 
#
# That's all Folks!!!!
#