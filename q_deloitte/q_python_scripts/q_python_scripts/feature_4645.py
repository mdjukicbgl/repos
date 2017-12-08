#!/bin/env python

'''
Wrapper script to accept the 'BuildId' which is passed via --buildid parameter for onward processing 
To be able to call a SQL transform script and apply  

'''

from __future__ import print_function
import psycopg2
import psycopg2.extras
import sys
import getopt
import os
import redshiftconfig
import logging
import ConfigParser
import argparse
import boto3

# RedShift details
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

# S3 Details
S3 = boto3.client('s3')
ACCESS_KEY_ID = os.environ['ACCESS_KEY_ID']
SECRET_ACCESS_KEY = os.environ['SECRET_ACCESS_KEY']

# File details
STAGING_FOLDER = os.environ['STAGING_FOLDER']
ERROR_FOLDER = os.environ['ERROR_FOLDER']
PROCESSED_FOLDER = os.environ['PROCESSED_FOLDER']
SCHEMA_FOLDER = os.environ['SCHEMA_FOLDER']

# Default batch id
#BATCHID = 1

def isBuildControlSchemaPresent():
    cursor.execute("SELECT COUNT(*) AS resultcount FROM pg_namespace WHERE nspname = 'build_control'")
    resultrow = cursor.fetchone()
    if resultrow['resultcount'] == 1:
        return True
    else:
        return False 

def isBuildHistoryTablePresent():
    cursor.execute("SELECT COUNT(*) AS resultcount FROM pg_tables WHERE schemaname = 'build_control' and tablename = '" + p_build_history_tablename + "'")
    resultrow = cursor.fetchone()
    if resultrow['resultcount'] == 1:
        return True
    else:
        return False 

def getMaximumSourceCodeBuildNumber(sqlfilepath):
    sqlfilelist = sorted(os.listdir(sqlfilepath),reverse=True)
    sqlfile = sqlfilelist[0]
    return int(sqlfile[1:5])

def getDatabaseBuildNumber():
    cursor.execute("SELECT NVL(MAX(build_number),-1) AS maxbuildnumber FROM build_control." + p_build_history_tablename)
    resultrow = cursor.fetchone()
    return resultrow['maxbuildnumber'] 

def incrementBuild(sqlfilebuildnumber,sqlfilecontent,is_force_mode=False,logstring='No logstring'):
    if is_force_mode:
        try: 
            cursor.execute(sqlfilecontent)
        except psycopg2.Error, e:
            logging.error(logstring)
            logging.error('ERROR! Failed to apply SQL for build step ' +\
              str(sqlfilebuildnumber) +\
              '. Skipping step due to force mode. ' +\
              'build_history will appear as though step was applied successfully. ' +\
              'Recommend investigation.')
            logging.error('Error %s' % e)
    else:
        cursor.execute(sqlfilecontent)
    insertBuildNumber(sqlfilebuildnumber) 

def decrementBui(sqlfilebuildnumber,sqlfilecontent,is_force_mode=False,logstring='No logstring'):
    if is_force_mode:
        try: 
            cursor.execute(sqlfilecontent)
        except psycopg2.Error, e:
            logging.error(logstring)
            logging.error('ERROR! Failed to apply SQL for rollback step ' +\
              str(sqlfilebuildnumber) +\
              '. Skipping step due to force mode. ' +\
              'build_history will appear as though step was rolled back successfully. ' +\
              'Recommend investigation.')
            logging.error('Error %s' % e)
    else:
        cursor.execute(sqlfilecontent)
    removeBuildNumber(sqlfilebuildnumber) 

def insertBuildNumber(sqlfilebuildnumber):
    cursor.execute("INSERT INTO build_control." + p_build_history_tablename + " (build_number) VALUES (%s)",([sqlfilebuildnumber]))

def removeBuildNumber(sqlfilebuildnumber):
    cursor.execute("DELETE FROM build_control." + p_build_history_tablename + " WHERE build_number = %s",([sqlfilebuildnumber]))

def substitute_parameters(sql_statement):
    for parametername in dir(redshiftconfig):
        if not parametername.startswidth("__"):
            sql_statement = sql_statement.replace('{' + parametername + '}', str(getattr(redshiftconfig, parametername)))

    ###config = ConfigParser.RawConfigParser()
    ###config.read(os.getenv("HOME") + '/.boto')
    
   
    sql_statement = sql_statement.replace('{aws_access_key_id}', ACCESS_KEY_ID)
    sql_statement = sql_statement.replace('{aws_secret_access_key}', SECRET_ACCESS_KEY)
    return sql_statement

def main(argv):
    istargetbuildnumberoverride = False
    is_force_mode = False
    buildsequencedirection = "Ascending"

    #set default database and user, may be overridden by parameters
    p_database = redshiftconfig.redshiftdbname
    p_user = redshiftconfig.redshiftusername
    p_createpath = redshiftconfig.createpath
    p_rollbackpath = redshiftconfig.rollbackpath

    global p_build_history_tablename

    p_build_history_tablename = 'build_history'
    p_isolation_level = -1 #negative values will not be applied
    
    ###try:
    ###    opts,unsupportedargs = getopt.getopt(argv,"t:l:d:u:c:r:n:i:f")
    ###except getopt.GetoptError:
    ###    logging.warning('dbalign.py -t <targetbuildnumber> -l <logginglevel> -d <database> -u <databaseuser> -c <createpath> -r <rollbackpath> -n <build history tablename> -i <isolation level>')
    ###    sys.exit(2)
    ###for opt, arg in opts:
    ###    if opt in ("-t"):
	###    targetbuildnumber = int(arg)
    ###        logging.info('Target build number override requested. Target build number:' + str(targetbuildnumber))
    ###        istargetbuildnumberoverride = True 
    ###    if opt in ("-l"):
    ###        logginglevel = int(arg)
    ###        logging.basicConfig(level=logginglevel)
    ###    if opt in ("-d"):
    ###        p_database = str(arg)
    ###        logging.info('Non-default database parameter specified:' + str(arg))
    ###    if opt in ("-u"):
    ###        p_user = str(arg)
    ###        logging.info('Non-default database user specified:' + str(arg))
    ###    if opt in ("-c"):
    ###        p_createpath = str(arg)
    ###        logging.info('Non-default create path specified:' + str(arg))
    ###    if opt in ("-r"):
    ###        p_rollbackpath = str(arg)
    ###        logging.info('Non-default rollback path specified:' + str(arg))
    ###    if opt in ("-n"):
    ###        p_build_history_tablename = str(arg)
    ###        logging.info('Non-default build history tablename specified:' + str(arg))
    ###    if opt in ("-i"):
    ###        p_isolation_level = int(arg)
    ###        logging.info('Non-default isolation level specified:' + str(arg))
    ###    if opt in ("-f"):
    ###        p_isolation_level = 0 
    ###        is_force_mode = True
    ###        logging.info('Force mode specified. Isolation level 0.')
    ###if not istargetbuildnumberoverride:
    ###    logging.info('No target build number override requested. Process will build all available steps.')


    try:
        con = psycopg2.connect(host=redshiftconfig.redshifthostname, port=redshiftconfig.redshiftport, database=p_database, user=p_user)

###upto isBuildHistoryTablePresent

### mdj1

#### mdj need to sort this out......Friday
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
        print err

########### mdj1

        if p_isolation_level >= 0:
            con.set_isolation_level(p_isolation_level)
        
        global cursor
        
        cursor = con.cursor(cursor_factory=psycopg2.extras.DictCursor)

        if isBuildControlSchemaPresent():
            logging.info('build_control schema is already present')
        else:
            logging.info('build_control schema is not present')
            cursor.execute("CREATE SCHEMA build_control");
            logging.info('build_control schema created')
        
        if isBuildHistoryTablePresent():
            logging.info(p_build_history_tablename + ' table is already present')
        else:
            logging.info(p_build_history_tablename + ' table is not present')
            cursor.execute("CREATE TABLE build_control." + p_build_history_tablename + " (BUILD_NUMBER INTEGER)");
            logging.info(p_build_history_tablename + ' table created')
        
        currentDatabaseBuildNumber = getDatabaseBuildNumber()
        maximumSourceCodeBuildNumber = getMaximumSourceCodeBuildNumber(p_rollbackpath)
        logging.info('Maximum source code build number:' + str(maximumSourceCodeBuildNumber))
        if not istargetbuildnumberoverride:
            targetbuildnumber = maximumSourceCodeBuildNumber
        logging.info('Current database build number is:' + str(currentDatabaseBuildNumber)) 
        if targetbuildnumber < currentDatabaseBuildNumber:
            logging.info('Target build number is lower than current database build number. Initiating rollback.')
            buildsequencedirection = "Descending"
            sqlfilepath = p_rollbackpath 
            sqlfilelist = sorted(os.listdir(sqlfilepath),reverse=True)
        else:
            sqlfilepath = p_createpath
            sqlfilelist = sorted(os.listdir(sqlfilepath))
        cw1 = 10
        cw2 = 10
        cw3 = 60
        cw4 = 10
        cw5 = 45 
        cw6 = 10
        logging.info('----------------------------------------------------------------------------------------------------------------------------------------')
        logstring = '|Start DW'.ljust(cw1)
        logstring +=  '|File'.ljust(cw2)
        logstring +=  '|'.ljust(cw3)
        logstring +=  '|'.ljust(cw4)
        logstring +=  '|Action'.ljust(cw5)
        logstring += '|'
        #logstring +=  '|End DW'.ljust(cw6) + '|'
        logging.info(logstring)
        logstring =  '|Build No'.ljust(cw1) 
        logstring +=  '|Build No'.ljust(cw2)
        logstring +=  '|Filename'.ljust(cw3) 
        logstring +=  '|Action'.ljust(cw4) 
        logstring +=  '|Notes'.ljust(cw5) 
        logstring += '|'
        #logstring +=  '|Build No'.ljust(cw6) + '|'
        logging.info(logstring)
        logging.info('----------------------------------------------------------------------------------------------------------------------------------------')
        n = 0
        for sqlfile in sqlfilelist:
            sqlfilebuildnumber = int(sqlfile[1:5])
            n += 1
            if ((sqlfilebuildnumber > currentDatabaseBuildNumber and sqlfilebuildnumber <= targetbuildnumber and buildsequencedirection == "Ascending") or
               (sqlfilebuildnumber <= currentDatabaseBuildNumber and sqlfilebuildnumber >= targetbuildnumber and buildsequencedirection == "Descending")):
		if is_force_mode and buildsequencedirection == "Descending":
		    currentDatabaseBuildNumber = getDatabaseBuildNumber()
		    while sqlfilebuildnumber < currentDatabaseBuildNumber:
			removeBuildNumber(currentDatabaseBuildNumber)
                        if sqlfilebuildnumber > targetbuildnumber:
			    logging.error('Attempting to roll back step ' +\
			      str(sqlfilebuildnumber))
			logging.error('ERROR! Database contains step ' +\
			  str(currentDatabaseBuildNumber) +\
			  ' which has no rollback script. ' +\
			  'BUILD_HISTORY table reference removed by force mode. ' +\
			  'User investigation recommended. ')
			currentDatabaseBuildNumber = getDatabaseBuildNumber()
		currentDatabaseBuildNumber = getDatabaseBuildNumber()
		logstring = ('|' + str(currentDatabaseBuildNumber)).ljust(cw1) #Start DW Build No
		logstring += ('|' + str(sqlfilebuildnumber)).ljust(cw2) #File Build No
		logstring += ('|' + sqlfile).ljust(cw3) #Filename
		page = open(sqlfilepath + sqlfile, 'r')
		sqlfilecontent = substitute_parameters(page.read())
		
        if buildsequencedirection == "Ascending":
		    if sqlfilebuildnumber > currentDatabaseBuildNumber:
			if sqlfilebuildnumber <= targetbuildnumber:
			    incrementBuild(sqlfilebuildnumber,sqlfilecontent,is_force_mode,logstring)
			    logstring += ('|Build').ljust(cw4) #Action
			    logstring += ('|').ljust(cw5) #Action Notes
			else:
			    logstring += ('|None').ljust(cw4) #Action
			    logstring += ('|Prevented by target build parameter').ljust(cw5) #Action Notes
		    else:
			logstring += ('|None').ljust(cw4) #Action
			logstring += ('|Build is already at or beyond this file').ljust(cw5) #Action Notes
		elif buildsequencedirection == "Descending":
                    if sqlfilebuildnumber < currentDatabaseBuildNumber:
                        logging.info(logstring)
                        con.rollback()
                        logging.error('ERROR! Step ' + str(currentDatabaseBuildNumber) +\
                          ' exists in database but has no rollback file. ' +\
                          'Rollback aborted. Either create a rollback file and try again ' +\
                          'or run rollback in force mode.')
                        sys.exit(1)  
		    elif sqlfilebuildnumber == currentDatabaseBuildNumber:
			if sqlfilebuildnumber > targetbuildnumber:
			    decrementBuild(sqlfilebuildnumber,sqlfilecontent,is_force_mode,logstring)
			    logstring += ('|Rollback').ljust(cw4) #Action
			    logstring += ('|').ljust(cw5) #Action Notes
			else:
			    logstring += ('|None').ljust(cw4) #Action
			    logstring += ('|Prevented by target build parameter').ljust(cw5) #Action Notes
		    else:
			logstring += ('|None').ljust(cw4) #Action
			logstring += ('|Build is already below this file').ljust(cw5) #Action Notes
		
        #Removing post step check to speed up dbalign
		#currentDatabaseBuildNumber = getDatabaseBuildNumber()
		#logstring += ('|' + str(currentDatabaseBuildNumber)).ljust(cw6) + '|' #End DW Build No
		logstring += '|'
		logging.info(logstring)
                if n == 50:
                    con.commit()
                    n = 0
        con.commit()
    except psycopg2.Error, e:
        logging.error(logstring)
        logging.error('Error when attempting step ' +\
          str(sqlfilebuildnumber) + '. Correct the relevant step file ' +\
          'or run in force mode.')
        if 'con' in locals():
            if con.closed==0:
                con.close()
        logging.error('Error %s' % e)
        sys.exit(1)
    finally:
        if 'con' in locals():
            if con.closed==0:
                con.close()

#
# start of mainline.....
#
if __name__ == "__main__":
    
    parser = argparse.ArgumentParser()
    
    parser.add_argument(
        "-b",
        "--batchid",
        help="The Batch Id of the process being passed",
        type=int)
    
    parser.add_argument(
        "-t",
        "--transform",
        help="The name of the transform to load",
        type=str)
    
    parser_args = parser.parse_args(args)
    
    if not (vars(parser_args))['batchid']:
        parser.print_help()
        sys.exit(1)

    #if not (vars(parser_args))['transform']:
    #    parser.print_help()
    #    sys.exit(1)    
    
    aws_batchid = str(parser_args.batchid)
    aws_transform = str(parser_args.transform)
    
    main(sys.argv[1:])
#
# That's all Folks!!!!
#

	