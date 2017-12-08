@ECHO OFF

SET FILES=hierarchy product product_sales product_sales_tax product_hierarchy product_price_ladder price_ladder price_ladder_value
SET SEPARATOR="|"

SET DATABASE=Meijer
SET USERNAME=markdown
SET PASSWORD=Mark-down14
SET HOSTNAME=v8-md-dev-sql-1.int.deloittecloud.co.uk

ECHO Using %USERNAME%@%HOSTNAME%:/%DATABASE%
ECHO. 

FOR %%a IN (%FILES%) DO IF EXIST %%a.csv DEL /Q %%a.csv

FOR %%x IN (%FILES%) DO	( 
	ECHO Retrieving %%x.sql ^> %%x.csv
	sqlcmd -U %USERNAME% -P %PASSWORD% -S %HOSTNAME% -d %DATABASE% -i %%x.sql -u -W -w 1024 -s%SEPARATOR% | findstr /v /c:"----" > %%x.csv 
)	

ECHO.
ECHO Done
PAUSE 

