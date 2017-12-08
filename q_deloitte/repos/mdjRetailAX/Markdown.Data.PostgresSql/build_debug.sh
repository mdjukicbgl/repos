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

#
# Create schema
#
echo Creating ephemeral schema
PGPASSWORD="$DEST_PASS" "$PSQL" -h $DEST_HOST -p $DEST_PORT -U $DEST_USER -d $DEST_DATABASE  -c "CREATE SCHEMA IF NOT EXISTS ephemeral; GRANT ALL ON SCHEMA ephemeral TO $DEST_USER;"
echo -e "Done.\n"

#
# Execute all Schema scripts, from ephemeral/*_schema_*.sql
#
echo "Running schema setup scripts"
for filename in ephemeral/*_schema_*.sql; do
    echo -e "\tExecuting $filename"
    cat "$filename" | sed -e 's/CREATE TEMP TABLE IF NOT EXISTS/CREATE TABLE IF NOT EXISTS/g' -e 's/ON COMMIT DROP//g' | PGPASSWORD="$DEST_PASS" "$PSQL" -h $DEST_HOST -p $DEST_PORT -U $DEST_USER -d $DEST_DATABASE -v "ON_ERROR_STOP=1" > /dev/null
    if [ $? -ne 0 ]; then { echo "$filename failed. Exiting." ; exit 1; } fi
done
echo -e "Done.\n"

#
# Execute all PROC scripts, from ephemeral/*_procs_*.sql
#
echo "Running proc setup scripts"
for filename in ephemeral/*_procs_*.sql; do
    echo -e "\tExecuting $filename"
    cat "$filename" | sed -e 's/CREATE TEMP TABLE IF NOT EXISTS/CREATE TABLE IF NOT EXISTS/g' -e 's/ON COMMIT DROP//g'  | PGPASSWORD="$DEST_PASS" "$PSQL" -h $DEST_HOST -p $DEST_PORT -U $DEST_USER -d $DEST_DATABASE -v "ON_ERROR_STOP=1" > /dev/null
    if [ $? -ne 0 ]; then { echo "$filename failed. Exiting." ; exit 1; } fi
done
echo -e "Done.\n"
