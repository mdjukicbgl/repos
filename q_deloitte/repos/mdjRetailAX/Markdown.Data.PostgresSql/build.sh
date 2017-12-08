#!/usr/bin/env bash
PATH=$PATH:~/opt/bin:/usr/local/opt/gettext/bin:/usr/local/opt/postgresql@9.5/bin

PSQL=$(which psql)
if [ -z "$PSQL" ] ; then
  echo "Can't find psql"
  exit 1;
fi

PSQLVER="$("$PSQL" -V | egrep -o '[0-9]{1,}\.[0-9]{1,}')"
PSQLVERREQUIRED="9.5"

if [ $(echo "$PSQLVER >= $PSQLVERREQUIRED" | bc) -eq 0 ] ; then
  echo "Found psql version $PSQLVER.x. Expected psql version $PSQLVERREQUIRED.x."
  exit 1;
fi

#
# Check for env file
#
#if [ $# -ne 1 ] ; then 
#  echo "Expected variables file. eg: $0 env_local"
#  exit 1;
#fi

if [ ! -z $1 ]; then
  if [ ! -f $1 ]; then
    echo "Unable to find env file: $1";
    exit 1;
  fi
  source $1;
fi

if [ -z $DEST_HOST ] ; then
  echo "DEST_HOST variable not set"
  exit 1;
fi

# Locate envsubst, part of gettext. envsubst is used to substitute
# exported environment variables in an input stream.
#
ENVSUBST_PATH=$(which envsubst)
if [ ! -x "$ENVSUBST_PATH" ] ; then
  echo "envsubst not found in path. Please install gettext with 'brew install gettext' or 'apt-get install gettext'"
  exit 1;
fi

#
# Sanity check - if $DEST_DATABASE exists, drop it.
#
if [[ ! -z `PGPASSWORD="$DEST_PASS" "$PSQL" -h $DEST_HOST -p $DEST_PORT -U $DEST_USER -lqt | cut -d \| -f 1 | grep -w $DEST_DATABASE` ]]; then
  echo "Database $DEST_DATABASE exists. Dropping."
  PGPASSWORD="$DEST_PASS" "$PSQL" -h $DEST_HOST -p $DEST_PORT -U $DEST_USER -d $DEST_DEFAULTDATABASE -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '$DEST_DATABASE';" > /dev/null
  if [ $? -ne 0 ]; then { echo "Dropping connections to $DEST_DATABASE failed. Exiting." ; exit 1; } fi
  PGPASSWORD="$DEST_PASS" "$PSQL" -h $DEST_HOST -p $DEST_PORT -U $DEST_USER -d $DEST_DEFAULTDATABASE -c "DROP DATABASE $DEST_DATABASE;" > /dev/null
  if [ $? -ne 0 ]; then { echo "DROP DATABASE $DEST_DATABASE failed. Exiting." ; exit 1; } fi
  echo -e "Done.\n"
fi

#
# Create DEST_DATABASE
#
echo "Database $DEST_DATABASE not found. Creating."
PGPASSWORD="$DEST_PASS" "$PSQL" -h $DEST_HOST -p $DEST_PORT -U $DEST_USER -d $DEST_DEFAULTDATABASE -c "CREATE DATABASE $DEST_DATABASE;" > /dev/null
if [ $? -ne 0 ]; then { echo "CREATE DATABASE $DEST_DATABASE failed. Exiting." ; exit 1; } fi
echo -e "Done.\n"

#
# Run 'supra-schema' setup scripts, from app/*_setup_*.sql
# 
echo "Running setup scripts"
for filename in app/*_setup_*.sql; do
    echo -e "\tExecuting $filename"
    $ENVSUBST_PATH < "$filename" | PGPASSWORD="$DEST_PASS" "$PSQL" -h $DEST_HOST -p $DEST_PORT -U $DEST_USER -d $DEST_DATABASE -v "ON_ERROR_STOP=1" > /dev/null
    if [ $? -ne 0 ]; then { echo "$filename failed. Exiting." ; exit 1; } fi
done
echo -e "Done.\n"

#
# Execute all DML scripts, from app/*_schema_*.sql
#
echo "Running schema setup scripts"
for filename in app/*_schema_*.sql; do
    echo -e "\tExecuting $filename"
    PGPASSWORD="$DEST_PASS" "$PSQL" -h $DEST_HOST -p $DEST_PORT -U $DEST_USER -d $DEST_DATABASE -f "$filename" -v "ON_ERROR_STOP=1" > /dev/null
    if [ $? -ne 0 ]; then { echo "$filename failed. Exiting." ; exit 1; } fi
done
echo -e "Done.\n"

#
# Execute all PROC scripts, from app/*_procs_*.sql
#
echo "Running proc setup scripts"
for filename in app/*_procs_*.sql; do
    echo -e "\tExecuting $filename"
    PGPASSWORD="$DEST_PASS" "$PSQL" -h $DEST_HOST -p $DEST_PORT -U $DEST_USER -d $DEST_DATABASE -f "$filename" -v "ON_ERROR_STOP=1" > /dev/null
    if [ $? -ne 0 ]; then { echo "$filename failed. Exiting." ; exit 1; } fi
done
echo -e "Done.\n"

#
# Test data
#
echo "Setting test data"
$ENVSUBST_PATH < TestData.sql | PGPASSWORD="$DEST_PASS" "$PSQL" -h $DEST_HOST -p $DEST_PORT -U $DEST_USER -d $DEST_DATABASE -v "ON_ERROR_STOP=1" > /dev/null
if [ $? -ne 0 ]; then { echo "Test data failed. Exiting." ; exit 1; } fi
echo -e "Done.\n"
