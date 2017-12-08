#!/usr/bin/env python

from __future__ import print_function
import argparse, ConfigParser, logging, os, re, sys 


#
# Script name
#
SCRIPTNAME = sys.argv[0]

#
# logging 
#
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logging.info('Script: ' + SCRIPTNAME + ' Starting.')

#
# Sample file to test with
#
#FILENAME = '/Users/mdjukic/Desktop/q_python_scripts/q_python_scripts/sampleSQLfile.dat.pys'

#
# Validation check for BATCH_ID - must be greater than 0
#
def isBatchIdValid(BATCHID):

	if BATCHID > 0 :
		return True
	else:
		return False


#
# Valication of Staging Table existence
#
def isStageTablePresent():
    cursor.execute("SELECT COUNT(*) AS resultcount FROM pg_tables WHERE schemaname = 'stage' and table = '" + tablename + "'")
    resultrow = cursor.fetchone()
    
    if resultrow['resultcount'] == 1:
        return True
    else:
        return False 


#
# readfile, and return contents
#
def readfile(FILENAME):
	#
    # define file pointer to transform file, and return contents
    #

	f = open(FILENAME) 
	
	return(f.read())

#
# check for existence of transform filename
#
def isTransformFilePresent(FILENAME):

	logging.info('Checking the existence of the transform file')
	try:
		os.path.isfile(FILENAME)

 	except Exception, e:
		error_line_no = sys.exc_traceback.tb_lineno
		logging.error('Line number: %s. Error: %s' % (error_line_no,e))
		sys.exit(1)


#
# Start of Mainline.....
#
def main(args):

	print('args as passed from main-->', args)
	#
	# logging information msg
	#
	logging.info('Start of main()')


	#
	# Validation Check for Batch_Id 
    #
	if isBatchIdValid(BATCH_ID):

		logging.info('BATCH_ID passed is valid')
	
	else:
	
		logging.info('BATCH_ID passed is invalid')	


    #
    # Existence Check for transform file
    #
	logging.info('Validating existence of transform file passed')

 	isTransformFilePresent(FILENAME)
 	
 	
	#
	# Call readfile()
	#
	try:
		#query_string = readfile(FILENAME)
		query_string = str(readfile(FILENAME))
    
		print('query_string-->%s' %(query_string))

 	except Exception, e:
		error_line_no = sys.exc_traceback.tb_lineno
		logging.error('Line number: %s. Error: %s' % (error_line_no,e))
		sys.exit(1)


	#
	# logging information msg
	#
	logging.info('End of main()')


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
    
    parser_args = parser.parse_args()
    
    #
    # pass in batchid
    #
    if not (vars(parser_args))['batchid']:
        parser.print_help()
        sys.exit(1)

    #
    # pass in transform to execute
    #
    if not (vars(parser_args))['transform']:
        parser.print_help()
        sys.exit(1)    
    
    BATCH_ID = str(parser_args.batchid)
    FILENAME = str(parser_args.transform)
    
    main(sys.argv[1:])

#
# That's all Folks!!!!
#
