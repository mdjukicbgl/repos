select 'channel', count(*)
  from markdown.stage.channel
;
select 'Statuses', count(*)
  from markdown.stage.statuses
;
select 'Product', count(*)
  from markdown.stage.product
;
select 'Geography', count(*)
  from markdown.stage.geography
;
select 'Hierarchy', count(*)
  from markdown.stage.business_hierarchy
;
select 'ProductSeasonality', count(*)
  from markdown.stage.product_seasonality
;
select 'StageSales', count(*)
  from markdown.stage.sales
;

--
-----------------------------------------------------------------------------------------------------------------------------
-- make copy of existing stage tables.....
-----------------------------------------------------------------------------------------------------------------------------
--
create table mdj.stage_channel_repeat
as
select *
  from markdown.stage.channel
;

create table mdj.stage_statuses_repeat
as
select *
  from markdown.stage.statuses
;

create table mdj.stage_product_repeat
as
select *
  from markdown.stage.product
;

create table mdj.stage_geography_repeat
as
select *
  from markdown.stage.geography
;

create table mdj.stage_business_hierarchy_repeat
as
select *
  from markdown.stage.business_hierarchy
;

create table mdj.stage_product_seasonality_repeat
as
select *
  from markdown.stage.product_seasonality
;

create table mdj.stage_sales_repeat
as
select *
  from markdown.stage.sales
;

--
-----------------------------------------------------------------------------------------------------------------------------
-- confirm counts of create table statements above, by comaring with tables prior to copy - should be identical.....
-----------------------------------------------------------------------------------------------------------------------------
--
select 'channel_repeat', count(*)
  from mdj.stage_channel_repeat
union all
select 'channel', count(*)
  from markdown.stage.channel
order by 1 desc
;
--2--2

select 'Statuses_repeat', count(*)
  from mdj.stage_statuses_repeat
union all 
select 'Statuses', count(*)
  from markdown.stage.statuses
order by 1 desc
;
--2--2

select 'Product_repeat', count(*)
  from mdj.stage_product_repeat
union all
select 'Product', count(*)
  from markdown.stage.product
order by 1 desc
;
--25--25

select 'Geography_repeat', count(*)
  from mdj.stage_geography_repeat
union all
select 'Geography', count(*)
  from markdown.stage.geography
order by 1 desc
;
--2--2

select 'Hierarchy_repeat', count(*)
  from mdj.stage_business_hierarchy_repeat
union all
select 'Hierarchy', count(*)
  from markdown.stage.business_hierarchy
order by 1 desc
;
--500--500

select 'ProductSeasonality_repeat', count(*)
  from mdj.stage_product_seasonality_repeat
union all
select 'ProductSeasonality', count(*)
  from markdown.stage.product_seasonality
order by 1 desc
;
--3--3

select 'StageSales_repeat', count(*)
  from mdj.stage_sales_repeat
union all
select 'StageSales', count(*)
  from markdown.stage.sales
order by 1 desc
;


--
-----------------------------------------------------------------------------------------------------------------------------
-- Truncate staging tables.....
-----------------------------------------------------------------------------------------------------------------------------
--
truncate table markdown.stage.channel
;

truncate table markdown.stage.statuses
;

truncate table markdown.stage.product
;

truncate table markdown.stage.geography
;

truncate table markdown.stage.business_hierarchy
;

truncate table markdown.stage.product_seasonality
;

truncate table markdown.stage.sales
;

--
-----------------------------------------------------------------------------------------------------------------------------
-- need to create copy of dim tables.....
-----------------------------------------------------------------------------------------------------------------------------
--
create table mdj.conformed_dim_channel_repeat
as
select *
  from conformed.dim_channel
;

create table mdj.markdown_dim_price_status_repeat
as
select *
  from markdown.dim_price_status
;

create table mdj.conformed_dim_product_repeat
as
select *
  from conformed.dim_product
;

select count(*) 
from mdj.conformed_dim_geography_repeat
---
--insert into markdown.conformed.dim_geography (
--          batch_id
--       , dim_retailer_id
--       , geography_bkey
--       , geography_type_bkey
--       , effective_start_date_time
--       , effective_end_date_time
--       , geography_type
--       , geography_name
--       , city_name
--       , country_name
--       , region_name
--       , longitude_position
--       , latitude_position
--) 
--select batch_id
--       , dim_retailer_id
--       , geography_bkey
--       , geography_type_bkey
--       , effective_start_date_time
--       , effective_end_date_time
--       , geography_type
--       , geography_name
--       , city_name
--       , country_name
--       , region_name
--       , longitude_position
--       , latitude_position from mdj.conformed_dim_geography_repeat


create table mdj.conformed_dim_geography_repeat
as
select *
  from conformed.dim_geography
;

create table mdj.conformed_dim_hierarchy_repeat
as
select *
  from conformed.dim_hierarchy
;

create table mdj.conformed_dim_seasonality_repeat
as
select *
  from conformed.dim_seasonality
;

create table mdj.sales_fact_weekly_sales_initial_repeat
as
select *
  from sales.fact_weekly_sales_initial
;

--
-----------------------------------------------------------------------------------------------------------------------------
-- check count of backup tables compared to original tables - counts should be identical
-----------------------------------------------------------------------------------------------------------------------------
--
select 'dim_channel_repeat', count(*)
  from mdj.conformed_dim_channel_repeat
union all
select 'dim_channel', count(*)
  from conformed.dim_channel
order by 1 desc
;

select 'markdown_dim_price_status_repeat', count(*)
  from mdj.markdown_dim_price_status_repeat
union all
select 'markdown_dim_price_status', count(*)
  from markdown.dim_price_status
order by 1 desc
;

select 'conformed_dim_product_repeat', count(*)
  from mdj.conformed_dim_product_repeat
union all
select 'conformed_dim_product', count(*)
  from conformed.dim_product
order by 1 desc
;

select 'conformed_dim_geography_repeat', count(*)
  from mdj.conformed_dim_geography_repeat
union all
select 'conformed_dim_geography', count(*)
  from conformed.dim_geography
order by 1 desc
;

select 'conformed_dim_hierarchy_repeat', count(*)
  from mdj.conformed_dim_hierarchy_repeat
union all
select 'conformed_dim_hierarchy', count(*)
  from conformed.dim_hierarchy
order by 1 desc
;

select 'conformed_dim_seasonality_repeat', count(*)
  from mdj.conformed_dim_seasonality_repeat
union all
select 'conformed_dim_seasonality', count(*)
  from conformed.dim_seasonality
order by 1 desc
;

select 'sales_fact_weekly_sales_initial_repeat', count(*)
  from mdj.sales_fact_weekly_sales_initial_repeat
union all
select 'sales_fact_weekly_sales_initial', count(*)
  from sales.fact_weekly_sales_initial
order by 1 desc
;
--
-----------------------------------------------------------------------------------------------------------------------------
-- need to clear out dimension tables to be able to reload.....
-----------------------------------------------------------------------------------------------------------------------------
--
delete 
  from conformed.dim_channel
 where dim_channel_id > 0
 ;

delete 
  from markdown.dim_price_status
 where dim_price_status_id > 3
;

delete 
  from markdown.conformed.dim_product
 where trim(product_bkey, '|||')::int  in
 (
 32000056
,32000057
,32000058
,32000059
,32000060
,32000061
,32000062
,32000063
,32000064
,32000065
,32000066
,32000067
,32000068
,32000069
,32000071
,32000072
,32000073
,32000074
,32000075
,32000076
,32000077
,32000078
,32000079
,32000080
,32000081
 )
and effective_end_date_time = '2500-01-01' 
;

delete 
  from conformed.dim_geography
 where geography_bkey = 4321
   and geography_name = 'Bobs depot'
;


delete 
  from conformed.dim_hierarchy
 where batch_id = 1
   and dim_retailer_id = 20
   and hierarchy_name = 'Meijer Product Style Hierarchy'
;


truncate table conformed.dim_seasonality
;

truncate table sales.fact_weekly_sales_initial
;


--
-----------------------------------------------------------------------------------------------------------------------------
-- check count of backup tables compared to original tables - counts should be identical
-----------------------------------------------------------------------------------------------------------------------------
--
--
select 'dim_channel_repeat', count(*)
  from mdj.conformed_dim_channel_repeat
union all
select 'dim_channel', count(*)
  from conformed.dim_channel
order by 1 desc
;

select 'markdown_dim_price_status_repeat', count(*)
  from mdj.markdown_dim_price_status_repeat
union all
select 'markdown_dim_price_status', count(*)
  from markdown.dim_price_status
order by 1 desc
;

select 'conformed_dim_product_repeat', count(*)
  from mdj.conformed_dim_product_repeat
union all
select 'conformed_dim_product', count(*)
  from conformed.dim_product
order by 1 desc
;

select 'conformed_dim_geography_repeat', count(*)
  from mdj.conformed_dim_geography_repeat
union all
select 'conformed_dim_geography', count(*)
  from conformed.dim_geography
order by 1 desc
;

select 'conformed_dim_hierarchy_repeat', count(*)
  from mdj.conformed_dim_hierarchy_repeat
union all
select 'conformed_dim_hierarchy', count(*)
  from conformed.dim_hierarchy
order by 1 desc
;

select 'conformed_dim_seasonality_repeat', count(*)
  from mdj.conformed_dim_seasonality_repeat
union all
select 'conformed_dim_seasonality', count(*)
  from conformed.dim_seasonality
order by 1 desc
;

select 'sales_fact_weekly_sales_initial_repeat', count(*)
  from mdj.sales_fact_weekly_sales_initial_repeat
union all
select 'sales_fact_weekly_sales_initial', count(*)
  from sales.fact_weekly_sales_initial
order by 1 desc
;

--
-----------------------------------------------------------------------------------------------------------------------------
-- run the s3_files_for_Framework_test script at this time, to copy files from processed to import s3 bucket.....
-----------------------------------------------------------------------------------------------------------------------------
--
/Users/mdjukic/virtualenvironment/mynewapp/bin/s3_files_for_Framework_test

--
-----------------------------------------------------------------------------------------------------------------------------
-- confirm counts after s3 import files have been processed.....
-----------------------------------------------------------------------------------------------------------------------------
--
select 'channel_repeat', count(*)
  from mdj.stage_channel_repeat
union all
select 'channel', count(*)
  from markdown.stage.channel
order by 1 desc
;

select 'Statuses_repeat', count(*)
  from mdj.stage_statuses_repeat
union all 
select 'Statuses', count(*)
  from markdown.stage.statuses
order by 1 desc
;

select 'Product_repeat', count(*)
  from mdj.stage_product_repeat
union all
select 'Product', count(*)
  from markdown.stage.product
order by 1 desc
;

select 'Geography_repeat', count(*)
  from mdj.stage_geography_repeat
union all
select 'Geography', count(*)
  from markdown.stage.geography
order by 1 desc
;

select 'Hierarchy_repeat', count(*)
  from mdj.stage_business_hierarchy_repeat
union all
select 'Hierarchy', count(*)
  from markdown.stage.business_hierarchy
order by 1 desc
;

select 'ProductSeasonality_repeat', count(*)
  from mdj.stage_product_seasonality_repeat
union all
select 'ProductSeasonality', count(*)
  from markdown.stage.product_seasonality
order by 1 desc
;

select 'StageSales_repeat', count(*)
  from mdj.stage_sales_repeat
union all
select 'StageSales', count(*)
  from markdown.stage.sales
order by 1 desc
;

--
-----------------------------------------------------------------------------------------------------------------------------
-- run the mdj_export script at this time.....
-----------------------------------------------------------------------------------------------------------------------------
--
make sure that script:

~/mdj_export

is set with the following  

export BATCH_FLAG_ID='-b 1'
export TRANSFORM_FLAG_LABELS='-t /Users/mdjukic/repos/RetailAX/RetailAnalytics.ETL/TransformScripts/dim_channel.sql /Users/mdjukic/repos/RetailAX/RetailAnalytics.ETL/TransformScripts/dim_seasonality.sql /Users/mdjukic/repos/RetailAX/RetailAnalytics.ETL/TransformScripts/dim_statuses.sql /Users/mdjukic/repos/RetailAX/RetailAnalytics.ETL/TransformScripts/dim_product.sql /Users/mdjukic/repos/RetailAX/RetailAnalytics.ETL/TransformScripts/dim_geography.sql /Users/mdjukic/repos/RetailAX/RetailAnalytics.ETL/TransformScripts/dim_hierarchy.sql'

and source it, to set the variables

. ~/mdj_export

--
-----------------------------------------------------------------------------------------------------------------------------
-- run the LoadTransform script at this time.....
-----------------------------------------------------------------------------------------------------------------------------
--
/Users/mdjukic/repos/RetailAX/RetailAnalytics.ETL/LoadTransform.py ${BATCH_FLAG_ID} ${TRANSFORM_FLAG_LABELS}

--
-----------------------------------------------------------------------------------------------------------------------------
-- CHECK DIMENSION LOAD COUNTS.....
-----------------------------------------------------------------------------------------------------------------------------
--
select 'dim_channel_repeat', count(*)
  from mdj.conformed_dim_channel_repeat
union all
select 'dim_channel', count(*)
  from conformed.dim_channel
order by 1 desc
;

select 'markdown_dim_price_status_repeat', count(*)
  from mdj.markdown_dim_price_status_repeat
union all
select 'markdown_dim_price_status', count(*)
  from markdown.dim_price_status
order by 1 desc
;

select 'conformed_dim_product_repeat', count(*)
  from mdj.conformed_dim_product_repeat
union all
select 'conformed_dim_product', count(*)
  from conformed.dim_product
order by 1 desc
;

select 'conformed_dim_geography_repeat', count(*)
  from mdj.conformed_dim_geography_repeat
union all
select 'conformed_dim_geography', count(*)
  from conformed.dim_geography
order by 1 desc
;

select 'conformed_dim_hierarchy_repeat', count(*)
  from mdj.conformed_dim_hierarchy_repeat
union all
select 'conformed_dim_hierarchy', count(*)
  from conformed.dim_hierarchy
order by 1 desc
;

select 'conformed_dim_seasonality_repeat', count(*)
  from mdj.conformed_dim_seasonality_repeat
union all
select 'conformed_dim_seasonality', count(*)
  from conformed.dim_seasonality
order by 1 desc
;

select 'sales.fact_weekly_sales_initial_repeat', count(*)
  from mdj.sales_fact_weekly_sales_initial_repeat
union all
select 'sales.fact_weekly_sales_initial', count(*)
  from sales.fact_weekly_sales_initial
order by 1 desc
;

