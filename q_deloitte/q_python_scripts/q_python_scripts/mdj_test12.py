#!/usr/bin/env python

from __future__ import print_function
import sys
import logging
import re

FILENAME='MDJ_TEST11.PY'
BATCH_ID=123456
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def main(args):
	print("+" +  "-" * 100 + "+")
	print("|" +  "Start of log for " + FILENAME)
	print("+" +  "-" * 100 + "+")
    
	#isBatchIdValid(BATCHID)

    #
    # Validation Check for Batch_Id 
    #
	if isBatchIdValid(int(BATCH_ID)):
		logging.info(' |\t BATCH_ID: ' + str(BATCH_ID) + ' passed is valid')
	else:
		logging.error('|\t BATCH_ID: ' + str(BATCH_ID) + ' passed is invalid') 

	phone = "2004-959-559 # This is Phone Number"

	# Delete Python-style comments
	num = re.sub(r'#.*$', "", phone)
	print("Phone Num1 : ", num )

	# Remove anything other than digits
	num = re.sub(r'\D', "", phone)    
	print("Phone Num2 : ", num )

	# Remove anything other than digits
	num = re.sub('\D', "", phone)    
	print("Phone Num3 : ", num )


#
# Validation check for BATCH_ID - must be greater than 0
#
def isBatchIdValid(BATCHID):
    logging.info(' | In function "' + sys._getframe().f_code.co_name + '"' )
    
    logging.info(' |\t Validating BATCH_ID passed from command line')
    if BATCHID > 0 :
        return True
    else:
        return False




if __name__ == '__main__':
	main(sys.argv[1:])


#
# Script Synopsis:
#
# script.py -b <batch_id> -t <transform1.sql> [transform2.sql ........]
# 
# script.py -b 123456 -t transform1.sql transform2.sql
#
# NOTE: The batch_id is mandatory, and requires to be passed (although we could default it, should we require to do so
#.      The transfrom file is also mandatory, although multiple transform files can be passed to the python script if desired
#
# If the batch_id and or a single transform file  the the transformA single transform.sql file also requires to be passed.  and arequires to be passed on the command line as do
#
# Test cases defined:
#
# 1. Enter just the script name with:
#     - without both a batch_id and/or transform.sql
# Expected Result: script help sysnopsis should return
#
# 2. Enter the script name together with:
#     - a VALID batch_id number
# Expected Result: script help sysnopsis should return
#
# 3. Enter the script name with an INVALID batch_id ie. with a value of less than 0
# Expected Result: script help sysnopsis should return
#
# 4. Enter the script name with a VALID batch_id and an INVALID transform.sql file
# Expected Result: Script will run, but will be terminated and the respective log file will report the following error:
# 	Transform file does NOT exist-->/Users/mdjukic/Desktop/q_python_scripts/q_python_scripts/drop_sampleSQLfileTables.daat
#
# 5. Enter the script name with an INVALID batch_id and a VALID transform.sql file
# Expected Result: S 


#
# mdj_b='-b 123456789'
# mdj_t='-t /Users/mdjukic/Desktop/q_python_scripts/q_python_scripts/SELECT_mdj.mdj_stlloaderrors.sql /Users/mdjukic/Desktop/q_python_scripts/q_python_scripts/UPDATE_mdj.mdj_stlloaderrors.sql /Users/mdjukic/Desktop/q_python_scripts/q_python_scripts/SELECT_mdj.mdj_stlloaderrors.sql'
#

