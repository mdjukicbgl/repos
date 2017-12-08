@echo off
pushd %~dp0

IF NOT EXIST ..\Markdown.Function\Scripts md ..\Markdown.Function\Scripts
IF EXIST ..\Markdown.Function\Scripts\*_script.sql del /q ..\Markdown.Function\Scripts\*_script.sql
copy /b ephemeral\*_schema_*.sql ..\Markdown.Function\Scripts\schema_script.sql 1>NUL
copy /b ephemeral\*_procs_*.sql ..\Markdown.Function\Scripts\procs_script.sql 1>NUL

popd