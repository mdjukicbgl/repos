
-----------------------------------------------------------------------------------------------------------------------------
-- PROCESSING STAGE DIM_CHANNEL TABLE, JUST LOADED.....
-----------------------------------------------------------------------------------------------------------------------------
--
-- TRUNCATE MARKDOWN.STAGE.CHANNEL TABLE
--
truncate table markdown.stage.channel
;

--
-- CHECK ROW COUNT WITHIN THE CURRENT STAGE TABLE - NEED TO TRUNCATE BEFORE PROCESS STARTS
--
select 'markdown.stage.channel - AFTER TRUNCATE_DEMO1', count(*)
  from markdown.stage.channel
;

?column?										count
markdown.stage.channel - AFTER TRUNCATE_DEMO1		0

--
-- COPY DIM_CHANNEL FILE TO S3 IMPORT BUCKET
--
/Users/mdjukic/virtualenvironment/mynewapp/bin/s3_files_for_Framework_demo1_initial_load.sh

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- AWS lamba LoadStaging, will pick-up the DEMO1 file, and load it into MARKDOWN.STAGE.CHANNEL table 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

--
-- CHECK ROW COUNT WITHIN THE CURRENT STAGE TABLE - NEED TO TRUNCATE BEFORE PROCESS STARTS
--
select 'markdown.stage.channel - AFTER LOADSTAGING_DEMO1', *
  from markdown.stage.channel
;

?column?											batch_id	dim_retailer_id	reporting_date	reporting_date_period_type	channel_key	channel_name	channel_description	channel_code	row_id
markdown.stage.channel - AFTER LOADSTAGING_DEMO1			1				20		2017-05-30							1			0	Unknown			Unknown				Unknown				77
markdown.stage.channel - AFTER LOADSTAGING_DEMO1			1				20		2017-05-30							1			1	SalesChan1		Sales Channel #1	12345				81

-----------------------------------------------------------------------------------------------------------------------------
-- PROCESSING STAGE DIM_CHANNEL TABLE, JUST LOADED WITHIN TARGET TABLE CONFORMED.DIM_CHANNEL.....
-----------------------------------------------------------------------------------------------------------------------------

--
-- DELETE ROWS FROM CONFORMED.DIM_CHANNEL 
--
delete 
  from conformed.dim_channel
 where dim_channel_id > 0
 ;

--
-- SHOW RECORD COUNT WITHIN CONFORMED.DIM_CHANNEL AFTER CLEARDOWN
--
select 'conformed.dim_channel - AFTER DELETE_DEMO1', * 
  from conformed.dim_channel
;

?column?									dim_channel_id		dim_retailer_id	channel_bkey	channel_name	channel_description	channel_code
conformed.dim_channel - AFTER DELETE_DEMO1				-1					1				0	Unknown			Unknown				Unknown   

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- AWS lamba function, LoadTransform will process the STAGING data, and load it into CONFORMED.DIM_CHANNEL table.....
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

--
-- SHOW RECORD COUNT WITHIN CONFORMED.DIM_CHANNEL AFTER LoadTransform
--
select 'conformed.dim_channel - AFTER LoadTransform_DEMO1', * 
  from conformed.dim_channel
 order by 1 
;

?column?											dim_channel_id	dim_retailer_id	channel_bkey	channel_name	channel_description	channel_code
conformed.dim_channel - AFTER LoadTransform_DEMO1				-1				1			0		Unknown			Unknown				Unknown   
conformed.dim_channel - AFTER LoadTransform_DEMO1				16				20			1		SalesChan1		Sales Channel #1	12345     
conformed.dim_channel - AFTER LoadTransform_DEMO1				27				20			0		Unknown			Unknown				Unknown   

=============================================================================================================================
== DEMO2 - STAGE channel_name, channel_description, & channel_code have been amended
=============================================================================================================================

--
-- LOAD THE COPY DIM_CHANNEL FILE TO S3 IMPORT BUCKET
--
/Users/mdjukic/virtualenvironment/mynewapp/bin/s3_files_for_Framework_demo2_update.sh

select 'markdown.stage.channel - AFTER LOADSTAGING_DEMO2', *
  from markdown.stage.channel
;

?column?											batch_id	dim_retailer_id	reporting_date	reporting_date_period_type	channel_key	channel_name		channel_description		channel_code	row_id
markdown.stage.channel - AFTER LOADSTAGING_DEMO2			1				20	2017-05-30							1				0	Unknown_Demo2		Unknown_Demo2			UNK_Demo2			85
markdown.stage.channel - AFTER LOADSTAGING_DEMO2			1				20	2017-05-30							1				1	SalesChan1_Demo2	Sales Channel #1_Demo2	6789_Demo2			89

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- AWS lamba function, LoadTransform will process the STAGING data, and load it into CONFORMED.DIM_CHANNEL table.....
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

select 'conformed.dim_channel - AFTER LoadTransform_DEMO2', * 
  from conformed.dim_channel
order by dim_channel_id
;

?column?											dim_channel_id	dim_retailer_id	channel_bkey	channel_name		channel_description		channel_code
conformed.dim_channel - AFTER LoadTransform_DEMO2				-1				1				0	Unknown				Unknown					Unknown   
conformed.dim_channel - AFTER LoadTransform_DEMO2				12				20				1	SalesChan1_Demo2	Sales Channel #1_Demo2	6789_Demo2
conformed.dim_channel - AFTER LoadTransform_DEMO2				23				20				0	Unknown_Demo2		Unknown_Demo2			UNK_Demo2 

=============================================================================================================================
== DEMO3 - Only 2nd record from record has changed in DEMO3, STAGE channel_name, channel_description, & channel_code have been amended
=============================================================================================================================

--
-- LOAD THE COPY DIM_CHANNEL FILE TO S3 IMPORT BUCKET
--
/Users/mdjukic/virtualenvironment/mynewapp/bin/s3_files_for_Framework_demo3_update_one_record_in_error.sh

select 'markdown.stage.channel - AFTER LOADSTAGING_DEMO3', *
  from markdown.stage.channel
;

?column?											batch_id	dim_retailer_id		reporting_date	reporting_date_period_type	channel_key		channel_name	channel_description	channel_code	row_id
markdown.stage.channel - AFTER LOADSTAGING_DEMO3			1				20		2017-05-30								1				0	Unknown_Demo3	Unknown_Demo3		UNK_Demo3		65
  
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- AWS lamba function, LoadTransform will process the STAGING data, and load it into CONFORMED.DIM_CHANNEL table.....
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

select 'conformed.dim_channel - AFTER LoadTransform_DEMO3', * 
  from conformed.dim_channel
order by dim_channel_id
;

?column?											dim_channel_id	dim_retailer_id	channel_bkey	channel_name		channel_description		channel_code
conformed.dim_channel - AFTER LoadTransform_DEMO3				-1				1				0	Unknown				Unknown					Unknown   
conformed.dim_channel - AFTER LoadTransform_DEMO3				16				20				1	SalesChan1_Demo2	Sales Channel #1_Demo2	6789_Demo2
conformed.dim_channel - AFTER LoadTransform_DEMO3				27				20				0	Unknown_Demo3		Unknown_Demo3			UNK_Demo3 
