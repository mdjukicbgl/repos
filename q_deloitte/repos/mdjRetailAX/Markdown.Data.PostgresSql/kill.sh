#!/usr/bin/env bash
PATH=$PATH:~/opt/bin:/usr/local/opt/gettext/bin:/usr/local/opt/postgresql@9.5/bin

PSQL=$(which psql)
if [ -z $PSQL ] ; then
  echo "Can't find psql"
  exit 1;
fi

PSQLVER="$($PSQL -V | egrep -o '[0-9]{1,}\.[0-9]{1,}')"
PSQLVERREQUIRED="9.6"

if [ $PSQLVER != $PSQLVERREQUIRED ] ; then
  echo "Found psql version $PSQLVER.x. Expected psql version $PSQLVERREQUIRED.x. Please install with brew and link --force"
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

PGPASSWORD="$DEST_PASS" $PSQL -h $DEST_HOST -p $DEST_PORT -U $DEST_USER -d $DEST_DEFAULTDATABASE -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '$DEST_DATABASE';"

