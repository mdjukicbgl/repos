#!/usr/bin/env bash

# Set path to include Postgres bin folder
PATH=$PATH:/usr/local/Cellar/postgresql@9.5/9.5.6/bin:/usr/lib/postgresql/9.5/bin/

if ! [ -x "$(command -v pg_tmp)" ]; then
  echo 'Error: pg_tmp is not installed or in PATH.' >&2
  exit 1
fi

if ! [ -x "$(command -v postgres)" ]; then
  echo 'Error: postgres is not installed or in PATH.' >&2
  exit 1
fi

if ! [ -x "$(command -v psql)" ]; then
  echo 'Error: psql is not installed or in PATH.' >&2
  exit 1
fi

if ! [ -x "$(command -v pg_prove)" ]; then
  echo 'Error: pg_prove is not installed or in PATH.' >&2
  exit 1
fi

# Create temp instance of Postgres
echo -n "Starting Postgres: "
PG_INSTANCE=$(pg_tmp -t) 
PG_PORT=$(echo $PG_INSTANCE | sed -e 's,^.*:,:,g' -e 's,.*:\([0-9]*\).*,\1,g' -e 's,[^0-9],,g')
echo "OK. ($PG_INSTANCE / psql -d test -h localhost -p $PG_PORT)"

# Install PG TAP
echo "Adding pgtap"
psql -q -d test -h localhost -p $PG_PORT -Xf pgtap.sql

# Test setup -- TODO expand on this, refactor scripts
echo "Adding markdown schema"
psql -q -d test -h localhost -p $PG_PORT -Xf ../Markdown.Data.PostgresSql/app/00_setup_fnAssertString.sql

echo -e "Running pg_prove...\n"
# Run unit tests generate report
JUNIT_OUTPUT_FILE=results-junit.xml pg_prove -r -h localhost -p $PG_PORT -d test --harness TAP::Harness::JUnit t/*.sql 
