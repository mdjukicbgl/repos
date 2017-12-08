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
# Build
#
. ./build.sh

#
# Add debug
#
. ./build_debug.sh

#
# Load model
#
echo Loading model
PGPASSWORD="$DEST_PASS" "$PSQL" -h $DEST_HOST -p $DEST_PORT -U $DEST_USER -d $DEST_DATABASE -c "EXPLAIN ANALYZE SELECT ephemeral.get_model_data(p_model_week:= 870);"

#
# Generate model
#
echo -e "\nGenerating model"
PGPASSWORD="$DEST_PASS" "$PSQL" -h $DEST_HOST -p $DEST_PORT -U $DEST_USER -d $DEST_DATABASE -c "EXPLAIN ANALYZE SELECT ephemeral.generate_model(p_model_id:= 100);"

