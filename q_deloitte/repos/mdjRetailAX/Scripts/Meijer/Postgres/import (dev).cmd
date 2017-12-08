@ECHO OFF

SET SEPARATOR=^|

SET USER=markdown
SET PWD=Mark-down14
SET DATABASE=testdb
SET HOSTNAME=pf-dev-01.c6fmhp4adr4a.eu-west-1.rds.amazonaws.com

SET PGPASSWORD=%PWD%

ECHO Truncating hierarchy.csv
psql -h %HOSTNAME% -d %DATABASE% -U %USER% -c "TRUNCATE TABLE hierarchy;"
ECHO Uploading hierarchy.csv
psql -h %HOSTNAME% -d %DATABASE% -U %USER% -c "\COPY hierarchy(hierarchy_id, parent_id, depth, name, path) FROM 'hierarchy.csv' DELIMITER '%SEPARATOR%' CSV HEADER QUOTE E'\b'"

ECHO Truncating product.csv
psql -h %HOSTNAME% -d %DATABASE% -U %USER% -c "TRUNCATE TABLE product;"
ECHO Uploading product.csv
psql -h %HOSTNAME% -d %DATABASE% -U %USER% -c "\COPY product(product_id, name, original_selling_price) FROM 'product.csv' DELIMITER '%SEPARATOR%' CSV HEADER QUOTE E'\b'"

ECHO Truncating product_hierarchy.csv
psql -h %HOSTNAME% -d %DATABASE% -U %USER% -c "TRUNCATE TABLE product_hierarchy;"
ECHO Uploading product.csv
psql -h %HOSTNAME% -d %DATABASE% -U %USER% -c "\COPY product_hierarchy(product_id, hierarchy_id) FROM 'product_hierarchy.csv' DELIMITER '%SEPARATOR%' CSV HEADER QUOTE E'\b'"

ECHO Truncating product_sales.csv
psql -h %HOSTNAME% -d %DATABASE% -U %USER% -c "TRUNCATE TABLE product_sales;"
ECHO Uploading product_sales.csv
psql -h %HOSTNAME% -d %DATABASE% -U %USER% -c "\COPY product_sales(product_id, week, price, quantity, stock, cost_price) FROM 'product_sales.csv' DELIMITER '%SEPARATOR%' CSV HEADER QUOTE E'\b'"

ECHO Truncating product_sales_tax.csv
psql -h %HOSTNAME% -d %DATABASE% -U %USER% -c "TRUNCATE TABLE product_sales_tax;"
ECHO Uploading product_sales_tax.csv
psql -h %HOSTNAME% -d %DATABASE% -U %USER% -c "\COPY product_sales_tax(product_id, week, rate) FROM 'product_sales_tax.csv' DELIMITER '%SEPARATOR%' CSV HEADER QUOTE E'\b'"

ECHO Truncating product_price_ladder.csv
psql -h %HOSTNAME% -d %DATABASE% -U %USER% -c "TRUNCATE TABLE product_price_ladder;"
ECHO Uploading product_price_ladder.csv
psql -h %HOSTNAME% -d %DATABASE% -U %USER% -c "\COPY product_price_ladder(product_id, price_ladder_id) FROM 'product_price_ladder.csv' DELIMITER '%SEPARATOR%' CSV HEADER QUOTE E'\b'"

ECHO Truncating price_ladder.csv
psql -h %HOSTNAME% -d %DATABASE% -U %USER% -c "TRUNCATE TABLE price_ladder;"
ECHO Uploading price_ladder.csv
psql -h %HOSTNAME% -d %DATABASE% -U %USER% -c "\COPY price_ladder(price_ladder_id, price_ladder_type_id, description) FROM 'price_ladder.csv' DELIMITER '%SEPARATOR%' CSV HEADER QUOTE E'\b'"

ECHO Truncating price_ladder_value.csv
psql -h %HOSTNAME% -d %DATABASE% -U %USER% -c "TRUNCATE TABLE price_ladder_value;"
ECHO Uploading price_ladder_value.csv
psql -h %HOSTNAME% -d %DATABASE% -U %USER% -c "\COPY price_ladder_value(price_ladder_id, \"order\", \"value\") FROM 'price_ladder_value.csv' DELIMITER '%SEPARATOR%' CSV HEADER QUOTE E'\b'"


PAUSE