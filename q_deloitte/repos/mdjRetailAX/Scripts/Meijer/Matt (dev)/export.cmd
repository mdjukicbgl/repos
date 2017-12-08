@ECHO OFF

SET FILES=hierarchy product product_sales product_sales_tax product_hierarchy
SET SEPARATOR="|"

SET DATABASE=Meijer
SET USERNAME=markdown
SET PASSWORD=Mark-down14
SET HOSTNAME=v8-md-dev-sql-1.int.deloittecloud.co.uk

ECHO Using %USERNAME%@%HOSTNAME%:/%DATABASE%
ECHO. 

FOR %%x IN (%FILES%) DO	( 
	ECHO Running %%x.sql
	sqlcmd -U %USERNAME% -P %PASSWORD% -S %HOSTNAME% -d %DATABASE% -i %%x.sql
)	

ECHO.
ECHO Done
PAUSE 

