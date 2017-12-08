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
# Load scenario data
#
echo Loading scenario data
PGPASSWORD="$DEST_PASS" "$PSQL" -h $DEST_HOST -p $DEST_PORT -U $DEST_USER -d $DEST_DATABASE -c "EXPLAIN ANALYZE SELECT ephemeral.get_scenario_data(p_model_run_id:=100, p_scenario_id:=100, p_scenario_week:=897, p_schedule_week_min:=890, p_weeks_to_extrapolate_on:=3, p_decay_backdrop:=0.9, p_observed_decay_min:=0.3, p_observed_decay_max:=1.2, p_markdown_count_start_week:=800, p_partition_count:=1,p_allow_promo_as_markdown := TRUE, p_minimum_promo_percentage := 0.3, p_observed_decay_cap := 4);"
PGPASSWORD="$DEST_PASS" "$PSQL" -h $DEST_HOST -p $DEST_PORT -U $DEST_USER -d $DEST_DATABASE -c "EXPLAIN ANALYZE SELECT ephemeral.get_scenario_data(p_model_run_id:=100, p_scenario_id:=103, p_scenario_week:=897, p_schedule_week_min:=890, p_weeks_to_extrapolate_on:=3, p_decay_backdrop:=0.9, p_observed_decay_min:=0.3, p_observed_decay_max:=1.2, p_markdown_count_start_week:=800, p_partition_count:=1,p_allow_promo_as_markdown := TRUE, p_minimum_promo_percentage := 0.3, p_observed_decay_cap := 4);"
