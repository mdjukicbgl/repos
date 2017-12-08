# -*- coding: utf-8 -*-
""" Read in and process dimension new/update files. """
import os
import sys
import getopt
import urllib
import errno
sys.path.append(os.path.join(os.path.dirname(os.path.realpath(__file__)), "lib"))
sys.path.append(os.path.join(os.path.dirname(os.path.realpath(__file__)), "vendor"))

import boto
from boto.s3.connection import Key
import boto3
import psycopg2
import psycopg2.extras
import requests
import json
import jsonschema


# RedShift details
print 'Configuring RedShift details'
HOST = os.environ['HOST']
PORT = os.environ['PORT']
DBNAME = os.environ['DBNAME']
USER = os.environ['USER']
PWD = os.environ['PWD']
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
PROCESSED_FOLDER = os.environ['PROCESSED_FOLDER']
SCHEMA_FOLDER = os.environ['SCHEMA_FOLDER']

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

def move_file(from_filename, to_filename, bucket):
    """ Move file between 'folders' in a bucket """
    conn = boto.connect_s3()

    processing_bucket = conn.get_bucket(bucket)

    processing_bucket.copy_key(to_filename, processing_bucket.name, from_filename)

    k = Key(processing_bucket)

    k.key = from_filename
    processing_bucket.delete_key(k)

def get_schema(bucket, file_type):
    """ Get the schema to determine what to do with the file """

    try:
        conn = boto.connect_s3()
        filename = SCHEMA_FOLDER + file_type.lower() + '.json'

        file_bucket = conn.get_bucket(bucket)
        key = Key(file_bucket, filename)
        file_schema = json.loads(key.get_contents_as_string())

    except OSError as erval:
        if erval.errno != errno.ENOENT: # errno.ENOENT = no such file or directory
            raise # re-raise exception if a different error occurred

    return file_schema

def construct_column_list(header_schema):
    """ Write record with timestamp """

    # Construct and sort the output record as an array
    columns = []
    key_column = ''
    for column_details in json.loads(header_schema):
        # Not all source columns go to destination - ignore if not required
        if 'dstIndex' in column_details:
            output_index = column_details['dstIndex']
            output_column = column_details['dstName']
            columns.insert(output_index, output_column)
        if 'isKey' in column_details:
            key_column = column_details['dstName']

    # Concatenate the array into a string for writing out
    i = 0
    first_rec = True
    non_key_columns = ''
    for item in columns:
        if not first_rec:
            non_key_columns = non_key_columns + ','
        non_key_columns = non_key_columns + item.strip()
        first_rec = False
        i = i + 1

    column_list = '(batch_id,' + \
                   'dim_retailer_id,' + \
                   key_column + ',' + \
                   'effective_start_date_time,' + \
                   'effective_end_date_time,' + \
                   non_key_columns + ')'

    return column_list

def main(load_file, bucket):
    """ Load the dimension  new/upd files """

    staging_folder = load_file.split('/')[0]
    input_file = load_file.split('/')[1]
    retailer, file_type, extract_date, record_count = input_file.split('-')

    if input_file == '':
        print 'No input file specified'
        sys.exit()
    print input_file

    # Extract the schema data
    f_schema = get_schema(bucket, file_type)
    separator = f_schema['columnSep']
    header_record = json.dumps(f_schema['headerRecord'])
    db_key = f_schema['dbPrimaryKey']
    db_table = f_schema['tableName']
    column_list = construct_column_list(header_record)

    rs_conn = create_conn(config=CONFIG)
    cursor = rs_conn.cursor()

    cursor.execute('create temp table stage_change_id ' + \
                   '(   change_id varchar(50), ' +
                   '    update_date datetime );')
    rs_conn.commit()
    print 'Created temp table'

    # Upload the change list
    copy_script = 'copy stage_change_id ' + \
                   'from \'s3://' + bucket + '/' + \
                   staging_folder + '/' + input_file + '.upd' + '\' ' + \
                   'access_key_id \'' + ACCESS_KEY_ID + '\' ' + \
                   'secret_access_key \'' + SECRET_ACCESS_KEY + '\' ' + \
                   'delimiter \'' + separator + '\' ' + \
                   'timeformat \'YYYY-MM-DD HH24:MI:SS\';'

    cursor.execute(copy_script)
    rs_conn.commit()


    # Terminate the existing records
    update_statement = 'update  ' + db_table + ' ' + \
                       'set     effective_end_date_time = sci.update_date ' + \
                       'from    ' + db_table + '   cdp ' + \
                       'join    stage_change_id        sci on cdp.' + db_key + ' = sci.change_id;'
    cursor.execute(update_statement)
    rs_conn.commit()

    # Inset the new records
    copy_script = 'copy ' + db_table + ' ' + column_list + ' ' + \
                   'from \'s3://' + bucket + '/' + \
                   staging_folder + '/' + input_file + '.new' + '\' ' + \
                   'access_key_id \'' + ACCESS_KEY_ID + '\' ' + \
                   'secret_access_key \'' + SECRET_ACCESS_KEY + '\' ' + \
                   'delimiter \'' + separator + '\' ' + \
                   'timeformat \'YYYY-MM-DD HH24:MI:SS\';'

    cursor.execute(copy_script)
    rs_conn.commit()

    rs_conn.close()

    # Now move the files out to the 'processed' folder
    to_file_upd = PROCESSED_FOLDER + input_file + '.upd'
    from_file_upd = load_file + '.upd'

    to_file_new = PROCESSED_FOLDER + input_file + '.new'
    from_file_new = load_file + '.new'

    print to_file_upd
    print from_file_upd

    move_file(from_file_upd, to_file_upd, bucket)
    move_file(from_file_new, to_file_new, bucket)

def lambda_handler(event, context):
    """ Handler triggered by file delivery """

    # Get the object from the event
    source_bucket = event['Records'][0]['s3']['bucket']['name']
    key = urllib.unquote_plus(event['Records'][0]['s3']['object']['key'].encode('utf8'))
    try:
        response = S3.get_object(Bucket=source_bucket, Key=key)
        print source_bucket
        print key

        # Strip off the new/upd suffix
        main(os.path.splitext(key)[0], source_bucket)
        return response['ContentType']
    except Exception as lambda_error:
        print lambda_error
        print 'Error getting object {} from bucket {}.'.format(key, source_bucket)
        raise lambda_error

if __name__ == "__main__":
    # execute only if run as a script
    try:
        opts, args = getopt.getopt(sys.argv[1:], "hi:b:", ["ifile="])
    except getopt.GetoptError:
        print 'UpdateDB.py -i <inputfile> -h -b <bucket>'
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print 'UpdateDB.py -i <inputfile>'
            sys.exit()
        elif opt in ("-i", "--ifile"):
            paramfile = str.strip(arg)
        elif opt in ("-b", "--bucket"):
            source_bucket = str.strip(arg)

    try:
        main(paramfile, source_bucket)
    except Exception as main_error:
        print main_error
        raise main_error

