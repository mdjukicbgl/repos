#!/usr/bin/env bash

if [[ ! -e ../Markdown.Function/Scripts ]]; then
    mkdir -p ../Markdown.Function/Scripts
fi	

rm -f ../Markdown.Function/Scripts/*_script.sql

cat ephemeral/*schema*.sql > ../Markdown.Function/Scripts/schema_script.sql
cat ephemeral/*procs*.sql > ../Markdown.Function/Scripts/procs_script.sql
