# -*- coding: utf-8 -*-
""" Read in and process dimension file. """
import os
# encoding=utf8  
import sys  

reload(sys)  
sys.setdefaultencoding('utf8')
import urllib
import errno
import getopt
import datetime
import boto3
sys.path.append(os.path.join(os.path.dirname(os.path.realpath(__file__)), "lib"))
sys.path.append(os.path.join(os.path.dirname(os.path.realpath(__file__)), "vendor"))

import json
import jsonschema
from jsonschema import validate

import psycopg2
import psycopg2.extras
import requests
import boto
from boto.s3.key import Key
import smart_open

# RedShift details
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

# File details
STAGING_FOLDER = os.environ['STAGING_FOLDER']
ERROR_FOLDER = os.environ['ERROR_FOLDER']
PROCESSED_FOLDER = os.environ['PROCESSED_FOLDER']
SCHEMA_FOLDER = os.environ['SCHEMA_FOLDER']

# Default batch id
BATCH_ID = 1


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

def open_file_write(filename, bucket):
    """ Delete file if exists then open new version """
    try:
        os.remove(filename)
    except OSError as erval:
        if erval.errno != errno.ENOENT: # errno.ENOENT = no such file or directory
            raise # re-raise exception if a different error occurred

    conn = boto.connect_s3()

    file_bucket = conn.get_bucket(bucket)
    key = Key(file_bucket, filename)
    file_conn = smart_open.smart_open(key, 'wb')

    return file_conn

def open_file_read(filename, bucket):
    """ Open file for read """
    try:
        conn = boto.connect_s3()

        file_bucket = conn.get_bucket(bucket)
        key = Key(file_bucket, filename)
        file_input = smart_open.smart_open(key)

    except OSError as erval:
        if erval.errno != errno.ENOENT: # errno.ENOENT = no such file or directory
            raise # re-raise exception if a different error occurred

    return file_input

def move_file(from_filename, to_filename, bucket):
    """ Move file between 'folders' in a bucket """
    conn = boto.connect_s3()

    processing_bucket = conn.get_bucket(bucket)

    processing_bucket.copy_key(to_filename, processing_bucket.name, from_filename)

    k = Key(processing_bucket)

    k.key = from_filename
    processing_bucket.delete_key(k)


def validate_header(header_row, header_expected, column_separator):

    """ Check the header record is as expected """
    valid_header = False
    record_key = ''
    db_key = ''

    # Build the expected value as a template record
    header_template = []
    for column_details in json.loads(header_expected):
        index = column_details['srcIndex']
        column = column_details['srcName']
        header_template.insert(index, column)
        if 'isKey' in column_details:
            if column_details['isKey'] is True:
                record_key = column_details['srcName']
                db_key = column_details['dstName']

    # Unpack the received record
    header_record = header_row.strip().split(column_separator)

    # Compare actual to template
    if header_record == header_template:
        valid_header = True
    else:
        log_error(header_row, 'Invalid file header')
        valid_header = False

    return valid_header, header_template, record_key, db_key


def validate_record(data_row,
                    error_file,
                    previous_key,
                    row_number,
                    header,
                    record_schema,
                    logical_key,
                    separator):
    """ Check the data record is as expected """

    # Read the record into a named array for json validation
    record_arr = {}
    key_value = ''

    # While we're here, we also construct the key value for later comparison
    i = 0
    for item in data_row:
        record_arr[header[i]] = item.strip()
        if header[i] in logical_key:
            key_value = key_value + separator + item.strip()
        i = i + 1
    # Remove the leading junk
    key_value = key_value.lstrip(separator)

    # Validate the schema using json validator
    try:
        validate(record_arr, record_schema, format_checker=jsonschema.FormatChecker())
        valid_record = True
    except jsonschema.ValidationError as error_value:
        error_file.write('Line {0}: {1}: {2}: {3}\n'.format( \
                         str(row_number), \
                         error_value.path[0], \
                         str.strip(error_value.message), \
                         data_row))
        valid_record = False

    # Check for repeated key values
    if key_value == str(previous_key):
        error_file.write('Line {0}: Repeated key value: {1}: {2}\n'.format( \
                         str(row_number), \
                         previous_key, \
                         data_row))
        valid_record = False

    # return valid_record, key_value
    return valid_record, key_value


def compare_rows(file_row, rs_row, header_schema):
    """ Compare db row with file row """
    records_match = True

    # Compare field by field and exit on the first difference
    counter = 0
    try:
        for column_details in json.loads(header_schema):
            index = column_details['srcIndex']
            if 'dstName' in column_details:
                if str(file_row[index]).strip() <> str(rs_row[counter]).strip():
                    records_match = False
                    break
                counter = counter + 1
    except Exception as compare_error:
        raise compare_error

    return records_match


def write_new_record(new_file,
                     record,
                     retailer_id,
                     key_value,
                     effective_start_date_time,
                     effective_end_date_time,
                     header_schema,
                     separator):
    """ Write record with timestamp """

    # Construct and sort the output record as an array
    output_array = []
    for column_details in json.loads(header_schema):
        # Not all source columns go to destination - ignore if not required
        if 'dstIndex' in column_details:
            output_index = column_details['srcIndex']
            output_array.append(output_index)
    output_array.sort()

    # Concatenate the array into a string for writing out
    i = 0
    array_count = len(output_array)
    first_rec = True

    output_record = ''
    while i < array_count:
        if not first_rec and i < array_count:
            output_record = output_record + separator
        first_rec = False
        output_record = output_record + record[output_array[i]]
        i = i + 1

    # Write out the record - we always start with batch id, retailer and key value
    new_file.write('{0}{1}{2}{3}{4}{5}{6}{7}{8}{9}{10}\n'.format( \
                   BATCH_ID, separator, \
                   retailer_id, separator, \
                   key_value, separator, \
                   effective_start_date_time, separator, \
                   effective_end_date_time, separator, \
                   output_record))

def log_error(data_row, message):
    """ Log to errors file """
    error_record = message + ':' + data_row
    return error_record


def create_retailer(retailer_name):
    """ Creates the retailer based on the retailer name on the file if required """

    query_string = 'insert ' + \
                   'into conformed.dim_retailer ' + \
                   '(batch_id, retailer_bkey, retailer_name)' + \
                   'values ( ' + str(BATCH_ID) + ',\'' + \
                   retailer_name + '\',\'' + \
                   retailer_name + '\');'

    rs_conn = create_conn(config=CONFIG)
    cursor = rs_conn.cursor()
    cursor.execute(query_string)
    rs_conn.commit()

    query_string = 'select dim_retailer_id ' + \
                   'from conformed.dim_retailer ' + \
                   'where retailer_bkey = \'' + retailer_name + '\''

    cursor.execute(query_string)

    # Fetch the first record from the db
    datarow = cursor.fetchone()
    retailer_id = datarow[0]
    rs_conn.close()

    return retailer_id


def get_retailer(from_file):
    """ Gets the retailed id based on the retailer name on the file """
    file_name = os.path.basename(from_file)
    retailer_name = file_name.split('-', 1)[0]

    # Lookup the id of the retailer
    query_string = 'select dim_retailer_id ' + \
                   'from conformed.dim_retailer ' + \
                   'where retailer_bkey = \'' + retailer_name + '\''

    rs_conn = create_conn(config=CONFIG)
    cursor = rs_conn.cursor()

    cursor.execute(query_string)

    # Fetch the first record from the db
    datarow = cursor.fetchone()

    if datarow is None:
        retailer_id = create_retailer(retailer_name)
    else:
        retailer_id = datarow[0]

    rs_conn.close()

    return str(retailer_id)


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


def declare_cursor(cursor, \
                   retailer_id, \
                   key_value, \
                   effective_from_date_time, \
                   header_schema, \
                   logical_key, \
                   db_key, \
                   db_table):
    """ Build the query to extract the existing data """

    key_array = []
    for column_details in json.loads(header_schema):
        # Not all source columns go to destination - ignore if not required
        if 'dstName' in column_details:
            db_index = column_details['srcIndex']
            db_column = column_details['dstName']
            key_array.insert(db_index, db_column)

    i = 0
    key_index = 0
    column_list = ''
    for item in key_array:
        column_list = column_list + item.strip() + ','
        if item == logical_key:
            key_index = i
        i = i + 1

    sql_statement = 'select ' + \
                    column_list + \
                    'effective_end_date_time, ' + \
                    db_key + ' ' + \
                    'from ' + db_table + ' ' + \
                    'where dim_retailer_id = ' + retailer_id + ' ' + \
                    'and ' + logical_key + ' >= \'' + str(key_value) + '\' ' + \
                    'and effective_start_date_time <= \'' + effective_from_date_time + '\'' + \
                    'and effective_end_date_time > \'' + effective_from_date_time + '\'' + \
                    'order by ' + logical_key + ' asc'

    cursor.execute(sql_statement)

    return key_index


def main(load_file, bucket):
    """ Loop through the load file and table """
    input_file = load_file.split('/')[1]

    if input_file == '':
        print 'No input file specified'
        sys.exit()

    # Pull apart the file name details
    file_date = input_file.split('-')[2][-12:]
    effective_from_date_time = '{0}-{1}-{2} {3}:{4}:00'.format(file_date[0:4],
                                                               file_date[4:6],
                                                               file_date[6:8],
                                                               file_date[8:10],
                                                               file_date[10:12])
    file_line_count = input_file.split('-')[3].split('.')[0]

    # We apply updates based on the date supplied on the file name. We take the supplied
    # date/time as the 'effective from' date so calculate the 'effective end' date as
    # one minute earlier.
    datetime_object = datetime.datetime.strptime(effective_from_date_time, '%Y-%m-%d %H:%M:%S')
    new_to_date = datetime_object - datetime.timedelta(minutes=1)

    new_file = open_file_write(STAGING_FOLDER + input_file + '.new', bucket)
    changed_file = open_file_write(STAGING_FOLDER + input_file +  '.upd', bucket)
    error_file = open_file_write(ERROR_FOLDER + input_file +  '.err', bucket)

    # Get the retailer
    retailer_id = get_retailer(input_file)
    retailer, file_type, extract_date, record_count = input_file.split('-')


    # Extract the schema data
    f_schema = get_schema(bucket, file_type)
    separator = f_schema['columnSep']
    header_record = json.dumps(f_schema['headerRecord'])
    record_schema = f_schema['schema']
    db_key = f_schema['dbPrimaryKey']
    db_table = f_schema['tableName']

    matched = True
    valid_line_count = 0
    actual_line_count = 0
    rs_conn = ''
    previous_key = ''

    # Roll through the file
    for line in open_file_read(load_file, bucket):
        actual_line_count = actual_line_count + 1

        # Check header
        if valid_line_count == 0:
            valid_header, headers, record_key, dbrec_key = validate_header(line, \
                                                                           header_record, \
                                                                           separator)
            if not valid_header:
                error_file.write('Invalid header:' + line)
                raise Exception('Invalid header')
            else:
                valid_line_count = valid_line_count + 1
        else:
            file_record = line.strip().split(separator)

            valid_rec, key_value = validate_record(file_record, \
                               error_file, \
                               previous_key, \
                               actual_line_count, \
                               headers, \
                               record_schema, \
                               record_key, \
                               separator)

            if valid_rec:
                valid_line_count = valid_line_count + 1
                previous_key = key_value

                # Take the first valid line and use it as a starting point for the cursor
                if valid_line_count == 2:
                    rs_conn = create_conn(config=CONFIG)
                    cursor = rs_conn.cursor()

                    key_index = declare_cursor(cursor, \
                                   retailer_id, \
                                   key_value, \
                                   effective_from_date_time, \
                                   header_record, \
                                   dbrec_key, \
                                   db_key, \
                                   db_table)

                    # Fetch the first record from the db
                    db_record = cursor.fetchone()
                    if db_record is None:
                        rs_bkey = ''
                    else:
                        rs_bkey = db_record[key_index]

                while rs_bkey < key_value and rs_bkey <> '':
                    db_record = cursor.fetchone()
                    if db_record is None:
                        rs_bkey = ''
                    else:
                        rs_bkey = db_record[key_index]

                if key_value == rs_bkey:
                    # Matching keys so compare records
                    matched = compare_rows(file_record, db_record, header_record)

                    if not matched:
                        # Last two fields are always effective end date and
                        # the primary key from the db
                        rs_effective_end_date_time = db_record[len(db_record) - 2]
                        rs_dim_id = db_record[len(db_record) - 1]

                        # Data has changed so write new record and change
                        write_new_record(new_file,
                                         file_record,
                                         retailer_id,
                                         key_value,
                                         effective_from_date_time,
                                         rs_effective_end_date_time,
                                         header_record,
                                         separator)

                        changed_file.write('{0}{1}{2}\n'.format(rs_dim_id,
                                                              separator,
                                                              str(new_to_date)))
                else:
                    # No match found so record is new
                    write_new_record(new_file,
                                     file_record,
                                     retailer_id,
                                     key_value,
                                     effective_from_date_time,
                                     '2500-01-01 00:00:00',
                                     header_record,
                                     separator)

    #  Confirm the record count
    if str(actual_line_count) <> file_line_count:
        error_file.write('Invalid line count. Stated Count: {0} Actual Count:{1}\n'.format( \
                                    file_line_count,
                                    actual_line_count))

    # Close the files/connections
    if rs_conn:
        rs_conn.close()

    new_file.close()
    changed_file.close()
    error_file.close()

    to_file = PROCESSED_FOLDER + input_file
    move_file(load_file, to_file, bucket)


def lambda_handler(event, context):
    """ Handler triggered by file delivery """

    # Get the object from the event
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = urllib.unquote_plus(event['Records'][0]['s3']['object']['key'].encode('utf8'))
    try:
        response = S3.get_object(Bucket=bucket, Key=key)

        print key
        main(key, bucket)
        return response['ContentType']

    except Exception as lambda_error:
        print lambda_error
        print 'Error processing {} from bucket {}.'.format(key, bucket)
        raise lambda_error


if __name__ == "__main__":
    # execute only if run as a script
    try:
        opts, args = getopt.getopt(sys.argv[1:], "hi:b:", ["help", "ifile=", "bucket="])
    except getopt.GetoptError as err:
        print 'GenerateNewUpdate.py -i <inputfile> -b <bucket>'
        print err
        print sys.argv[1:]
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print 'GenerateNewUpdate.py -i <inputfile> -b <bucket>'
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
