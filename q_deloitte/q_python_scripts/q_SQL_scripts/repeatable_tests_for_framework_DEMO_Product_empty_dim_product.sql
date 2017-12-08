--
-- INITIALIZATION SECTION
--

SELECT count(*)
  FROM mdj.conformed_dim_product_repeat
;
--1,931,465

SELECT *
  FROM markdown.stage.product
  ;

--
-- initialize conformed.dim_product table - clear down and re-populate
--

--truncate table conformed.dim_product;

-----------------------------------------------------------------------------------------------------------------------------
-- PROCESSING STAGE DIM_PRODUCT TABLE.....
-----------------------------------------------------------------------------------------------------------------------------
--
-- TRUNCATE MARKDOWN.STAGE.PROCUCT TABLE
--
truncate table markdown.stage.product
;

--
-- CHECK ROW COUNT WITHIN THE CURRENT STAGE TABLE - after removal of records to be inserted
--
select 'markdown.stage.product - AFTER TRUNCATE_DEMO1', count(*)
  from markdown.stage.product
;

?column?										count
markdown.stage.product - AFTER TRUNCATE_DEMO1		0

--
-- COPY DIM_CHANNEL FILE TO S3 IMPORT BUCKET
--
/Users/mdjukic/virtualenvironment/mynewapp/bin/s3_files_for_Framework_Product_demo1_initial_load.sh

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- AWS lamba LoadStaging, will pick-up the DEMO1 file, and load it into MARKDOWN.STAGE.CHANNEL table 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

--
-- CHECK ROW COUNT WITHIN THE CURRENT STAGE TABLE - NEED TO TRUNCATE BEFORE PROCESS STARTS
--
select 'markdown.stage.product - AFTER LOADSTAGING_DEMO1', *
  from markdown.stage.product
order by product_key1
;

?column?	batch_id	dim_retailer_id	reporting_date	reporting_date_period_type	product_key1	product_key2	product_key3	product_key4	product_name	product_description	product_sku_code	product_size	product_colour_code	product_colour	product_gender	product_age_group	brand_name	supplier_name	product_status	row_id
markdown.stage.product - AFTER LOADSTAGING_DEMO1	1	20	2017-05-27	0	32000056				HORSE		56									1097
markdown.stage.product - AFTER LOADSTAGING_DEMO1	1	20	2017-05-27	0	32000057				MINI Q AND A ANIMALS		57									1101
markdown.stage.product - AFTER LOADSTAGING_DEMO1	1	20	2017-05-27	0	32000058				TRUCK		58									1105
markdown.stage.product - AFTER LOADSTAGING_DEMO1	1	20	2017-05-27	0	32000059				FOR ONE OR TWO		59									1109
markdown.stage.product - AFTER LOADSTAGING_DEMO1	1	20	2017-05-27	0	32000060				MISC. MIRS ADJUSTMENT		60									1113
markdown.stage.product - AFTER LOADSTAGING_DEMO1	1	20	2017-05-27	0	32000061				ROCK A BYE BRDS: I LOVE T		61									1117
markdown.stage.product - AFTER LOADSTAGING_DEMO1	1	20	2017-05-27	0	32000062				STICKY EYES LARGE FORMAT		62									1121
markdown.stage.product - AFTER LOADSTAGING_DEMO1	1	20	2017-05-27	0	32000063				COFFEE TABLE BOOK - HOROSCOPES		63									1125
markdown.stage.product - AFTER LOADSTAGING_DEMO1	1	20	2017-05-27	0	32000064				WITCH		64									1129
markdown.stage.product - AFTER LOADSTAGING_DEMO1	1	20	2017-05-27	0	32000065				MISC. MIRS ADJUSTMENT		65									1133
markdown.stage.product - AFTER LOADSTAGING_DEMO1	1	20	2017-05-27	0	32000066				B.C. CAVE-IN		66									1137
markdown.stage.product - AFTER LOADSTAGING_DEMO1	1	20	2017-05-27	0	32000067				I LOVE MY PETS		67									1141
markdown.stage.product - AFTER LOADSTAGING_DEMO1	1	20	2017-05-27	0	32000068				VEGETARIAN		68									1145
markdown.stage.product - AFTER LOADSTAGING_DEMO1	1	20	2017-05-27	0	32000069				VEHICLE SHAPED TRACTOR		69									1149
markdown.stage.product - AFTER LOADSTAGING_DEMO1	1	20	2017-05-27	0	32000071				DINOMITE STICKER FLYING		71									1153
markdown.stage.product - AFTER LOADSTAGING_DEMO1	1	20	2017-05-27	0	32000072				Q&A SERIES - MACHINES		72									1157
markdown.stage.product - AFTER LOADSTAGING_DEMO1	1	20	2017-05-27	0	32000073				FISH & SEAFOOD		73									1161
markdown.stage.product - AFTER LOADSTAGING_DEMO1	1	20	2017-05-27	0	32000074				FAIRY FERN		74									1165
markdown.stage.product - AFTER LOADSTAGING_DEMO1	1	20	2017-05-27	0	32000075				GREATEST EVER COOKBOOK		75									1169
markdown.stage.product - AFTER LOADSTAGING_DEMO1	1	20	2017-05-27	0	32000076				JOLLY CHRISTMAS		76									1173
markdown.stage.product - AFTER LOADSTAGING_DEMO1	1	20	2017-05-27	0	32000077				TRUCKS		77									1177
markdown.stage.product - AFTER LOADSTAGING_DEMO1	1	20	2017-05-27	0	32000078				MISC. MIRS ADJUSTMENT		78									1181
markdown.stage.product - AFTER LOADSTAGING_DEMO1	1	20	2017-05-27	0	32000079				ULTIMATE BK OF DINOS RED		79									1185
markdown.stage.product - AFTER LOADSTAGING_DEMO1	1	20	2017-05-27	0	32000080				OLD MACDONALD STICKERS - HENS		80									1189
markdown.stage.product - AFTER LOADSTAGING_DEMO1	1	20	2017-05-27	0	32000081				PRACTICAL COOKERY: CHICKEN		81									1193

-----------------------------------------------------------------------------------------------------------------------------
-- PROCESSING STAGE DIM_CHANNEL TABLE, JUST LOADED WITHIN TARGET TABLE CONFORMED.DIM_CHANNEL.....
-----------------------------------------------------------------------------------------------------------------------------

--
--TRUNCATE TABLE markdown.conformed.dim_product;
 
 
--
-- SHOW RECORD COUNT WITHIN CONFORMED.DIM_PRODUCT AFTER CLEARDOWN
--
select 'conformed.dim_product - AFTER DELETE_DEMO1', count(*) 
  from conformed.dim_product
;

?column?										count
conformed.dim_product - AFTER DELETE_DEMO1		1931440

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- AWS lamba function, LoadTransform will process the STAGING data, and load it into CONFORMED.DIM_PRODUCT table.....
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

--
-- SHOW RECORD COUNT WITHIN CONFORMED.DIM_PRODUCT AFTER LoadTransform
--
select 'conformed.dim_product - AFTER LoadTransform_DEMO1', *
  from markdown.conformed.dim_product
order by product_bkey, effective_start_date_time, effective_end_date_time
;


?column?	dim_product_id	batch_id	dim_retailer_id	product_bkey	effective_start_date_time	effective_end_date_time	product_name	product_description	product_sku_code	product_size	product_colour_code	product_colour	product_gender	product_age_group	brand_name	supplier_name	product_status
conformed.dim_product - AFTER LoadTransform_DEMO1	14779803	1	20	32000056|||	2017-05-26 10:04:00	2017-05-26 23:59:59	WILD HORSES		56		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO1	15451889	1	20	32000056|||	2017-05-27 00:00:00	2500-01-01 00:00:00	HORSE		56		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO1	15451952	1	20	32000057|||	2017-05-27 00:00:00	2500-01-01 00:00:00	MINI Q AND A ANIMALS		57		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO1	15451897	1	20	32000058|||	2017-05-27 00:00:00	2500-01-01 00:00:00	TRUCK		58		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO1	15454478	1	20	32000059|||	2017-05-27 00:00:00	2500-01-01 00:00:00	FOR ONE OR TWO		59		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO1	15455071	1	20	32000060|||	2017-05-27 00:00:00	2500-01-01 00:00:00	MISC. MIRS ADJUSTMENT		60		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO1	15451956	1	20	32000061|||	2017-05-27 00:00:00	2500-01-01 00:00:00	ROCK A BYE BRDS: I LOVE T		61		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO1	15451901	1	20	32000062|||	2017-05-27 00:00:00	2500-01-01 00:00:00	STICKY EYES LARGE FORMAT		62		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO1	14886238	1	20	32000063|||	2017-05-26 10:04:00	2017-05-26 23:59:59	COFFEE TABLE BOOK - HOROSCOPES FOR HORSES		63		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO1	15454470	1	20	32000063|||	2017-05-27 00:00:00	2500-01-01 00:00:00	COFFEE TABLE BOOK - HOROSCOPES		63		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO1	15455075	1	20	32000064|||	2017-05-27 00:00:00	2500-01-01 00:00:00	WITCH		64		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO1	15451960	1	20	32000065|||	2017-05-27 00:00:00	2500-01-01 00:00:00	MISC. MIRS ADJUSTMENT		65		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO1	15451905	1	20	32000066|||	2017-05-27 00:00:00	2500-01-01 00:00:00	B.C. CAVE-IN		66		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO1	15451631	1	20	32000067|||	2017-05-26 10:04:00	2017-05-26 23:59:59	I LOVE MY PETS HAMSTER		67		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO1	15454474	1	20	32000067|||	2017-05-27 00:00:00	2500-01-01 00:00:00	I LOVE MY PETS		67		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO1	15455079	1	20	32000068|||	2017-05-27 00:00:00	2500-01-01 00:00:00	VEGETARIAN		68		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO1	15451964	1	20	32000069|||	2017-05-27 00:00:00	2500-01-01 00:00:00	VEHICLE SHAPED TRACTOR		69		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO1	15451909	1	20	32000071|||	2017-05-27 00:00:00	2500-01-01 00:00:00	DINOMITE STICKER FLYING		71		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO1	15454482	1	20	32000072|||	2017-05-27 00:00:00	2500-01-01 00:00:00	Q&A SERIES - MACHINES		72		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO1	15451881	1	20	32000073|||	2017-05-26 10:04:00	2017-05-26 23:59:59	FISH & SEAFOOD & CHIPS & GRAVY		73		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO1	15451893	1	20	32000073|||	2017-05-27 00:00:00	2500-01-01 00:00:00	FISH & SEAFOOD		73		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO1	15451968	1	20	32000074|||	2017-05-27 00:00:00	2500-01-01 00:00:00	FAIRY FERN		74		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO1	15451913	1	20	32000075|||	2017-05-27 00:00:00	2500-01-01 00:00:00	GREATEST EVER COOKBOOK		75		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO1	14930660	1	20	32000076|||	2017-05-26 10:04:00	2017-05-26 23:59:59	SAD CHRISTMAS		76		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO1	15455067	1	20	32000076|||	2017-05-27 00:00:00	2500-01-01 00:00:00	JOLLY CHRISTMAS		76		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO1	15455083	1	20	32000077|||	2017-05-27 00:00:00	2500-01-01 00:00:00	TRUCKS		77		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO1	15451972	1	20	32000078|||	2017-05-27 00:00:00	2500-01-01 00:00:00	MISC. MIRS ADJUSTMENT		78		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO1	15451917	1	20	32000079|||	2017-05-27 00:00:00	2500-01-01 00:00:00	ULTIMATE BK OF DINOS RED		79		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO1	15454486	1	20	32000080|||	2017-05-27 00:00:00	2500-01-01 00:00:00	OLD MACDONALD STICKERS - HENS		80		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO1	15455087	1	20	32000081|||	2017-05-27 00:00:00	2500-01-01 00:00:00	PRACTICAL COOKERY: CHICKEN		81		          		          				


=============================================================================================================================
== DEMO2 - STAGE product_name has changed
=============================================================================================================================

--
-- LOAD THE COPY DIM_PRODUCT FILE TO S3 IMPORT BUCKET
--
/Users/mdjukic/virtualenvironment/mynewapp/bin/s3_files_for_Framework_Product_demo2_update_25_recs.sh

select 'markdown.stage.channel - AFTER LOADSTAGING_DEMO2', *
  from markdown.stage.product
order by product_key1
;

?column?	batch_id	dim_retailer_id	reporting_date	reporting_date_period_type	product_key1	product_key2	product_key3	product_key4	product_name	product_description	product_sku_code	product_size	product_colour_code	product_colour	product_gender	product_age_group	brand_name	supplier_name	product_status	row_id
markdown.stage.channel - AFTER LOADSTAGING_DEMO2	1	20	2017-05-28	0	32000056				HORSE_DEMO2		56									800
markdown.stage.channel - AFTER LOADSTAGING_DEMO2	1	20	2017-05-28	0	32000057				MINI Q AND A ANIMALS_DEMO2		57									804
markdown.stage.channel - AFTER LOADSTAGING_DEMO2	1	20	2017-05-28	0	32000058				TRUCK_DEMO2		58									808
markdown.stage.channel - AFTER LOADSTAGING_DEMO2	1	20	2017-05-28	0	32000059				FOR ONE OR TWO_DEMO2		59									812
markdown.stage.channel - AFTER LOADSTAGING_DEMO2	1	20	2017-05-28	0	32000060				MISC. MIRS ADJUSTMENT_DEMO2		60									816
markdown.stage.channel - AFTER LOADSTAGING_DEMO2	1	20	2017-05-28	0	32000061				ROCK A BYE BRDS: I LOVE T_DEMO2		61									820
markdown.stage.channel - AFTER LOADSTAGING_DEMO2	1	20	2017-05-28	0	32000062				STICKY EYES LARGE FORMAT_DEMO2		62									824
markdown.stage.channel - AFTER LOADSTAGING_DEMO2	1	20	2017-05-28	0	32000063				COFFEE TABLE BOOK - HOROSCOPES_DEMO2		63									828
markdown.stage.channel - AFTER LOADSTAGING_DEMO2	1	20	2017-05-28	0	32000064				WITCH_DEMO2		64									832
markdown.stage.channel - AFTER LOADSTAGING_DEMO2	1	20	2017-05-28	0	32000065				MISC. MIRS ADJUSTMENT_DEMO2		65									836
markdown.stage.channel - AFTER LOADSTAGING_DEMO2	1	20	2017-05-28	0	32000066				B.C. CAVE-IN_DEMO2		66									840
markdown.stage.channel - AFTER LOADSTAGING_DEMO2	1	20	2017-05-28	0	32000067				I LOVE MY PETS_DEMO2		67									844
markdown.stage.channel - AFTER LOADSTAGING_DEMO2	1	20	2017-05-28	0	32000068				VEGETARIAN_DEMO2		68									848
markdown.stage.channel - AFTER LOADSTAGING_DEMO2	1	20	2017-05-28	0	32000069				VEHICLE SHAPED TRACTOR_DEMO2		69									852
markdown.stage.channel - AFTER LOADSTAGING_DEMO2	1	20	2017-05-28	0	32000071				DINOMITE STICKER FLYING_DEMO2		71									856
markdown.stage.channel - AFTER LOADSTAGING_DEMO2	1	20	2017-05-28	0	32000072				Q&A SERIES - MACHINES_DEMO2		72									860
markdown.stage.channel - AFTER LOADSTAGING_DEMO2	1	20	2017-05-28	0	32000073				FISH & SEAFOOD_DEMO2		73									864
markdown.stage.channel - AFTER LOADSTAGING_DEMO2	1	20	2017-05-28	0	32000074				FAIRY FERN_DEMO2		74									868
markdown.stage.channel - AFTER LOADSTAGING_DEMO2	1	20	2017-05-28	0	32000075				GREATEST EVER COOKBOOK_DEMO2		75									872
markdown.stage.channel - AFTER LOADSTAGING_DEMO2	1	20	2017-05-28	0	32000076				JOLLY CHRISTMAS_DEMO2		76									876
markdown.stage.channel - AFTER LOADSTAGING_DEMO2	1	20	2017-05-28	0	32000077				TRUCKS_DEMO2		77									880
markdown.stage.channel - AFTER LOADSTAGING_DEMO2	1	20	2017-05-28	0	32000078				MISC. MIRS ADJUSTMENT_DEMO2		78									884
markdown.stage.channel - AFTER LOADSTAGING_DEMO2	1	20	2017-05-28	0	32000079				ULTIMATE BK OF DINOS RED_DEMO2		79									888
markdown.stage.channel - AFTER LOADSTAGING_DEMO2	1	20	2017-05-28	0	32000080				OLD MACDONALD STICKERS - HENS_DEMO2		80									892
markdown.stage.channel - AFTER LOADSTAGING_DEMO2	1	20	2017-05-28	0	32000081				PRACTICAL COOKERY: CHICKEN_DEMO2		81									896


+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- AWS lamba function, LoadTransform will process the STAGING data, and load it into CONFORMED.DIM_PRODUCT table.....
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

select 'conformed.dim_product - AFTER LoadTransform_DEMO2', * 
  from conformed.dim_product
order by product_bkey, effective_start_date_time, effective_end_date_time
;

?column?	dim_product_id	batch_id	dim_retailer_id	product_bkey	effective_start_date_time	effective_end_date_time	product_name	product_description	product_sku_code	product_size	product_colour_code	product_colour	product_gender	product_age_group	brand_name	supplier_name	product_status
conformed.dim_product - AFTER LoadTransform_DEMO2	7725872	1	20	32000056|||	2017-05-24 00:00:00	2017-05-23 23:59:59	HORSE		56		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7053771	1	20	32000056|||	2017-05-26 10:04:00	2017-05-23 23:59:59	WILD HORSES		56		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7725908	1	20	32000056|||	2017-05-24 00:00:00	2017-05-23 23:59:59	HORSE_DEMO2		56		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7728538	1	20	32000056|||	2017-05-24 00:00:00	2500-01-01 00:00:00	HORSE_DEMO2		56		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7725884	1	20	32000057|||	2017-05-24 00:00:00	2017-05-23 23:59:59	MINI Q AND A ANIMALS		57		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7725893	1	20	32000057|||	2017-05-24 00:00:00	2500-01-01 00:00:00	MINI Q AND A ANIMALS_DEMO2		57		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7725865	1	20	32000058|||	2017-05-24 00:00:00	2017-05-23 23:59:59	TRUCK		58		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7725912	1	20	32000058|||	2017-05-24 00:00:00	2500-01-01 00:00:00	TRUCK_DEMO2		58		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7728526	1	20	32000059|||	2017-05-24 00:00:00	2017-05-23 23:59:59	FOR ONE OR TWO		59		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7729075	1	20	32000059|||	2017-05-24 00:00:00	2500-01-01 00:00:00	FOR ONE OR TWO_DEMO2		59		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7729039	1	20	32000060|||	2017-05-24 00:00:00	2017-05-23 23:59:59	MISC. MIRS ADJUSTMENT		60		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7728546	1	20	32000060|||	2017-05-24 00:00:00	2500-01-01 00:00:00	MISC. MIRS ADJUSTMENT_DEMO2		60		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7725888	1	20	32000061|||	2017-05-24 00:00:00	2017-05-23 23:59:59	ROCK A BYE BRDS: I LOVE T		61		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7725897	1	20	32000061|||	2017-05-24 00:00:00	2500-01-01 00:00:00	ROCK A BYE BRDS: I LOVE T_DEMO2		61		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7725869	1	20	32000062|||	2017-05-24 00:00:00	2017-05-23 23:59:59	STICKY EYES LARGE FORMAT		62		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7729059	1	20	32000062|||	2017-05-24 00:00:00	2500-01-01 00:00:00	STICKY EYES LARGE FORMAT_DEMO2		62		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7160294	1	20	32000063|||	2017-05-26 10:04:00	2017-05-23 23:59:59	COFFEE TABLE BOOK - HOROSCOPES FOR HORSES		63		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7725861	1	20	32000063|||	2017-05-24 00:00:00	2017-05-23 23:59:59	COFFEE TABLE BOOK - HOROSCOPES		63		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7725889	1	20	32000063|||	2017-05-24 00:00:00	2017-05-23 23:59:59	COFFEE TABLE BOOK - HOROSCOPES_DEMO2		63		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7725916	1	20	32000063|||	2017-05-24 00:00:00	2500-01-01 00:00:00	COFFEE TABLE BOOK - HOROSCOPES_DEMO2		63		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7729043	1	20	32000064|||	2017-05-24 00:00:00	2017-05-23 23:59:59	WITCH		64		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7729079	1	20	32000064|||	2017-05-24 00:00:00	2500-01-01 00:00:00	WITCH_DEMO2		64		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7725892	1	20	32000065|||	2017-05-24 00:00:00	2017-05-23 23:59:59	MISC. MIRS ADJUSTMENT		65		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7725901	1	20	32000065|||	2017-05-24 00:00:00	2500-01-01 00:00:00	MISC. MIRS ADJUSTMENT_DEMO2		65		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7725873	1	20	32000066|||	2017-05-24 00:00:00	2017-05-23 23:59:59	B.C. CAVE-IN		66		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7725920	1	20	32000066|||	2017-05-24 00:00:00	2500-01-01 00:00:00	B.C. CAVE-IN_DEMO2		66		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7725599	1	20	32000067|||	2017-05-26 10:04:00	2017-05-23 23:59:59	I LOVE MY PETS HAMSTER		67		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7725924	1	20	32000067|||	2017-05-24 00:00:00	2017-05-23 23:59:59	I LOVE MY PETS_DEMO2		67		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7725880	1	20	32000067|||	2017-05-24 00:00:00	2017-05-23 23:59:59	I LOVE MY PETS		67		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7725932	1	20	32000067|||	2017-05-24 00:00:00	2500-01-01 00:00:00	I LOVE MY PETS_DEMO2		67		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7729047	1	20	32000068|||	2017-05-24 00:00:00	2017-05-23 23:59:59	VEGETARIAN		68		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7725905	1	20	32000068|||	2017-05-24 00:00:00	2500-01-01 00:00:00	VEGETARIAN_DEMO2		68		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7725896	1	20	32000069|||	2017-05-24 00:00:00	2017-05-23 23:59:59	VEHICLE SHAPED TRACTOR		69		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7728550	1	20	32000069|||	2017-05-24 00:00:00	2500-01-01 00:00:00	VEHICLE SHAPED TRACTOR_DEMO2		69		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7725877	1	20	32000071|||	2017-05-24 00:00:00	2017-05-23 23:59:59	DINOMITE STICKER FLYING		71		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7729067	1	20	32000071|||	2017-05-24 00:00:00	2500-01-01 00:00:00	DINOMITE STICKER FLYING_DEMO2		71		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7728530	1	20	32000072|||	2017-05-24 00:00:00	2017-05-23 23:59:59	Q&A SERIES - MACHINES		72		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7725944	1	20	32000072|||	2017-05-24 00:00:00	2500-01-01 00:00:00	Q&A SERIES - MACHINES_DEMO2		72		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7729035	1	20	32000073|||	2017-05-24 00:00:00	2017-05-23 23:59:59	FISH & SEAFOOD		73		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7729063	1	20	32000073|||	2017-05-24 00:00:00	2017-05-23 23:59:59	FISH & SEAFOOD_DEMO2		73		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7725853	1	20	32000073|||	2017-05-26 10:04:00	2017-05-23 23:59:59	FISH & SEAFOOD & CHIPS & GRAVY		73		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7725948	1	20	32000073|||	2017-05-24 00:00:00	2500-01-01 00:00:00	FISH & SEAFOOD_DEMO2		73		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7725900	1	20	32000074|||	2017-05-24 00:00:00	2017-05-23 23:59:59	FAIRY FERN		74		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7729083	1	20	32000074|||	2017-05-24 00:00:00	2500-01-01 00:00:00	FAIRY FERN_DEMO2		74		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7725881	1	20	32000075|||	2017-05-24 00:00:00	2017-05-23 23:59:59	GREATEST EVER COOKBOOK		75		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7728542	1	20	32000075|||	2017-05-24 00:00:00	2500-01-01 00:00:00	GREATEST EVER COOKBOOK_DEMO2		75		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7725876	1	20	32000076|||	2017-05-24 00:00:00	2017-05-23 23:59:59	JOLLY CHRISTMAS		76		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7204580	1	20	32000076|||	2017-05-26 10:04:00	2017-05-23 23:59:59	SAD CHRISTMAS		76		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7725928	1	20	32000076|||	2017-05-24 00:00:00	2017-05-23 23:59:59	JOLLY CHRISTMAS_DEMO2		76		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7729071	1	20	32000076|||	2017-05-24 00:00:00	2500-01-01 00:00:00	JOLLY CHRISTMAS_DEMO2		76		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7729051	1	20	32000077|||	2017-05-24 00:00:00	2017-05-23 23:59:59	TRUCKS		77		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7725913	1	20	32000077|||	2017-05-24 00:00:00	2500-01-01 00:00:00	TRUCKS_DEMO2		77		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7725904	1	20	32000078|||	2017-05-24 00:00:00	2017-05-23 23:59:59	MISC. MIRS ADJUSTMENT		78		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7725940	1	20	32000078|||	2017-05-24 00:00:00	2500-01-01 00:00:00	MISC. MIRS ADJUSTMENT_DEMO2		78		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7725885	1	20	32000079|||	2017-05-24 00:00:00	2017-05-23 23:59:59	ULTIMATE BK OF DINOS RED		79		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7725936	1	20	32000079|||	2017-05-24 00:00:00	2500-01-01 00:00:00	ULTIMATE BK OF DINOS RED_DEMO2		79		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7728534	1	20	32000080|||	2017-05-24 00:00:00	2017-05-23 23:59:59	OLD MACDONALD STICKERS - HENS		80		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7725909	1	20	32000080|||	2017-05-24 00:00:00	2500-01-01 00:00:00	OLD MACDONALD STICKERS - HENS_DEMO2		80		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7729055	1	20	32000081|||	2017-05-24 00:00:00	2017-05-23 23:59:59	PRACTICAL COOKERY: CHICKEN		81		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO2	7725917	1	20	32000081|||	2017-05-24 00:00:00	2500-01-01 00:00:00	PRACTICAL COOKERY: CHICKEN_DEMO2		81		          		          				

=============================================================================================================================
== DEMO3 - Only 2nd record from record has changed in DEMO3, STAGE channel_name, channel_description, & channel_code have been amendedstage.
=============================================================================================================================

--
-- LOAD THE COPY DIM_PRODUCT FILE TO S3 IMPORT BUCKET
--
/Users/mdjukic/virtualenvironment/mynewapp/bin/s3_files_for_Framework_Product_demo3_one_record_in_error.sh

select 'conformed.dim_product - AFTER LoadTransform_DEMO3', * 
  from conformed.dim_product
order by product_bkey, effective_start_date_time, effective_end_date_time
;


?column?	batch_id	dim_retailer_id	reporting_date	reporting_date_period_type	product_key1	product_key2	product_key3	product_key4	product_name	product_description	product_sku_code	product_size	product_colour_code	product_colour	product_gender	product_age_group	brand_name	supplier_name	product_status	row_id
markdown.stage.product - AFTER LOADSTAGING_DEMO3	1	20	2017-05-26	0	32000057				MINI Q AND A ANIMALS_DEMO3		57									404
markdown.stage.product - AFTER LOADSTAGING_DEMO3	1	20	2017-05-26	0	32000058				TRUCK_DEMO3		58									408
markdown.stage.product - AFTER LOADSTAGING_DEMO3	1	20	2017-05-26	0	32000059				FOR ONE OR TWO_DEMO3		59									412
markdown.stage.product - AFTER LOADSTAGING_DEMO3	1	20	2017-05-26	0	32000060				MISC. MIRS ADJUSTMENT_DEMO3		60									416
markdown.stage.product - AFTER LOADSTAGING_DEMO3	1	20	2017-05-26	0	32000061				ROCK A BYE BRDS: I LOVE T_DEMO3		61									420
markdown.stage.product - AFTER LOADSTAGING_DEMO3	1	20	2017-05-26	0	32000062				STICKY EYES LARGE FORMAT_DEMO3		62									424
markdown.stage.product - AFTER LOADSTAGING_DEMO3	1	20	2017-05-26	0	32000063				COFFEE TABLE BOOK - HOROSCOPES_DEMO3		63									428
markdown.stage.product - AFTER LOADSTAGING_DEMO3	1	20	2017-05-26	0	32000064				WITCH_DEMO3		64									432
markdown.stage.product - AFTER LOADSTAGING_DEMO3	1	20	2017-05-26	0	32000065				MISC. MIRS ADJUSTMENT_DEMO3		65									436
markdown.stage.product - AFTER LOADSTAGING_DEMO3	1	20	2017-05-26	0	32000066				B.C. CAVE-IN_DEMO3		66									440
markdown.stage.product - AFTER LOADSTAGING_DEMO3	1	20	2017-05-26	0	32000067				I LOVE MY PETS_DEMO3		67									444
markdown.stage.product - AFTER LOADSTAGING_DEMO3	1	20	2017-05-26	0	32000068				VEGETARIAN_DEMO3		68									448
markdown.stage.product - AFTER LOADSTAGING_DEMO3	1	20	2017-05-26	0	32000069				VEHICLE SHAPED TRACTOR_DEMO3		69									452
markdown.stage.product - AFTER LOADSTAGING_DEMO3	1	20	2017-05-26	0	32000071				DINOMITE STICKER FLYING_DEMO3		71									456
markdown.stage.product - AFTER LOADSTAGING_DEMO3	1	20	2017-05-26	0	32000072				Q&A SERIES - MACHINES_DEMO3		72									460
markdown.stage.product - AFTER LOADSTAGING_DEMO3	1	20	2017-05-26	0	32000073				FISH & SEAFOOD_DEMO3		73									464
markdown.stage.product - AFTER LOADSTAGING_DEMO3	1	20	2017-05-26	0	32000074				FAIRY FERN_DEMO3		74									468
markdown.stage.product - AFTER LOADSTAGING_DEMO3	1	20	2017-05-26	0	32000075				GREATEST EVER COOKBOOK_DEMO3		75									472
markdown.stage.product - AFTER LOADSTAGING_DEMO3	1	20	2017-05-26	0	32000076				JOLLY CHRISTMAS_DEMO3		76									476
markdown.stage.product - AFTER LOADSTAGING_DEMO3	1	20	2017-05-26	0	32000077				TRUCKS_DEMO3		77									480
markdown.stage.product - AFTER LOADSTAGING_DEMO3	1	20	2017-05-26	0	32000078				MISC. MIRS ADJUSTMENT_DEMO3		78									484
markdown.stage.product - AFTER LOADSTAGING_DEMO3	1	20	2017-05-26	0	32000079				ULTIMATE BK OF DINOS RED_DEMO3		79									488
markdown.stage.product - AFTER LOADSTAGING_DEMO3	1	20	2017-05-26	0	32000080				OLD MACDONALD STICKERS - HENS_DEMO3		80									492
markdown.stage.product - AFTER LOADSTAGING_DEMO3	1	20	2017-05-26	0	32000081				PRACTICAL COOKERY: CHICKEN_DEMO3		81									496

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- AWS lamba function, LoadTransform will process the STAGING data, and load it into CONFORMED.DIM_CHANNEL table.....
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

select 'conformed.dim_product - AFTER LoadTransform_DEMO3', * 
  from conformed.dim_product
order by product_bkey, effective_start_date_time, effective_end_date_time
;


?column?	dim_product_id	batch_id	dim_retailer_id	product_bkey	effective_start_date_time	effective_end_date_time	product_name	product_description	product_sku_code	product_size	product_colour_code	product_colour	product_gender	product_age_group	brand_name	supplier_name	product_status
conformed.dim_product - AFTER LoadTransform_DEMO3	19317522	1	20	32000056|||	2017-05-27 00:00:00	2017-05-27 23:59:59	HORSE		56		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19318143	1	20	32000056|||	2017-05-28 00:00:00	2500-01-01 00:00:00	HORSE_DEMO2		56		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19318107	1	20	32000057|||	2017-05-27 00:00:00	2017-05-28 23:59:59	MINI Q AND A ANIMALS		57		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19314961	1	20	32000057|||	2017-05-28 00:00:00	2017-05-28 23:59:59	MINI Q AND A ANIMALS_DEMO2		57		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19315000	1	20	32000057|||	2017-05-29 00:00:00	2500-01-01 00:00:00	MINI Q AND A ANIMALS_DEMO3		57		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19314968	1	20	32000058|||	2017-05-27 00:00:00	2017-05-28 23:59:59	TRUCK		58		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19317550	1	20	32000058|||	2017-05-28 00:00:00	2017-05-28 23:59:59	TRUCK_DEMO2		58		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19317606	1	20	32000058|||	2017-05-29 00:00:00	2500-01-01 00:00:00	TRUCK_DEMO3		58		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19314921	1	20	32000059|||	2017-05-27 00:00:00	2017-05-28 23:59:59	FOR ONE OR TWO		59		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19318131	1	20	32000059|||	2017-05-28 00:00:00	2017-05-28 23:59:59	FOR ONE OR TWO_DEMO2		59		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19315009	1	20	32000059|||	2017-05-29 00:00:00	2500-01-01 00:00:00	FOR ONE OR TWO_DEMO3		59		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19317526	1	20	32000060|||	2017-05-27 00:00:00	2017-05-28 23:59:59	MISC. MIRS ADJUSTMENT		60		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19314996	1	20	32000060|||	2017-05-28 00:00:00	2017-05-28 23:59:59	MISC. MIRS ADJUSTMENT_DEMO2		60		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19318175	1	20	32000060|||	2017-05-29 00:00:00	2500-01-01 00:00:00	MISC. MIRS ADJUSTMENT_DEMO3		60		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19318111	1	20	32000061|||	2017-05-27 00:00:00	2017-05-28 23:59:59	ROCK A BYE BRDS: I LOVE T		61		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19314965	1	20	32000061|||	2017-05-28 00:00:00	2017-05-28 23:59:59	ROCK A BYE BRDS: I LOVE T_DEMO2		61		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19318163	1	20	32000061|||	2017-05-29 00:00:00	2500-01-01 00:00:00	ROCK A BYE BRDS: I LOVE T_DEMO3		61		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19314972	1	20	32000062|||	2017-05-27 00:00:00	2017-05-28 23:59:59	STICKY EYES LARGE FORMAT		62		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19317554	1	20	32000062|||	2017-05-28 00:00:00	2017-05-28 23:59:59	STICKY EYES LARGE FORMAT_DEMO2		62		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19318179	1	20	32000062|||	2017-05-29 00:00:00	2500-01-01 00:00:00	STICKY EYES LARGE FORMAT_DEMO3		62		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19314925	1	20	32000063|||	2017-05-27 00:00:00	2017-05-28 23:59:59	COFFEE TABLE BOOK - HOROSCOPES		63		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19318135	1	20	32000063|||	2017-05-28 00:00:00	2017-05-28 23:59:59	COFFEE TABLE BOOK - HOROSCOPES_DEMO2		63		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19315017	1	20	32000063|||	2017-05-29 00:00:00	2500-01-01 00:00:00	COFFEE TABLE BOOK - HOROSCOPES_DEMO3		63		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19317530	1	20	32000064|||	2017-05-27 00:00:00	2017-05-28 23:59:59	WITCH		64		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19314957	1	20	32000064|||	2017-05-28 00:00:00	2017-05-28 23:59:59	WITCH_DEMO2		64		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19315004	1	20	32000064|||	2017-05-29 00:00:00	2500-01-01 00:00:00	WITCH_DEMO3		64		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19318115	1	20	32000065|||	2017-05-27 00:00:00	2017-05-28 23:59:59	MISC. MIRS ADJUSTMENT		65		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19314969	1	20	32000065|||	2017-05-28 00:00:00	2017-05-28 23:59:59	MISC. MIRS ADJUSTMENT_DEMO2		65		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19315012	1	20	32000065|||	2017-05-29 00:00:00	2500-01-01 00:00:00	MISC. MIRS ADJUSTMENT_DEMO3		65		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19314976	1	20	32000066|||	2017-05-27 00:00:00	2017-05-28 23:59:59	B.C. CAVE-IN		66		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19314992	1	20	32000066|||	2017-05-28 00:00:00	2017-05-28 23:59:59	B.C. CAVE-IN_DEMO2		66		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19318167	1	20	32000066|||	2017-05-29 00:00:00	2500-01-01 00:00:00	B.C. CAVE-IN_DEMO3		66		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19314929	1	20	32000067|||	2017-05-27 00:00:00	2017-05-28 23:59:59	I LOVE MY PETS		67		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19314945	1	20	32000067|||	2017-05-28 00:00:00	2017-05-28 23:59:59	I LOVE MY PETS_DEMO2		67		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19315008	1	20	32000067|||	2017-05-29 00:00:00	2500-01-01 00:00:00	I LOVE MY PETS_DEMO3		67		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19317534	1	20	32000068|||	2017-05-27 00:00:00	2017-05-28 23:59:59	VEGETARIAN		68		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19317570	1	20	32000068|||	2017-05-28 00:00:00	2017-05-28 23:59:59	VEGETARIAN_DEMO2		68		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19317614	1	20	32000068|||	2017-05-29 00:00:00	2500-01-01 00:00:00	VEGETARIAN_DEMO3		68		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19318119	1	20	32000069|||	2017-05-27 00:00:00	2017-05-28 23:59:59	VEHICLE SHAPED TRACTOR		69		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19318147	1	20	32000069|||	2017-05-28 00:00:00	2017-05-28 23:59:59	VEHICLE SHAPED TRACTOR_DEMO2		69		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19318195	1	20	32000069|||	2017-05-29 00:00:00	2500-01-01 00:00:00	VEHICLE SHAPED TRACTOR_DEMO3		69		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19314980	1	20	32000071|||	2017-05-27 00:00:00	2017-05-28 23:59:59	DINOMITE STICKER FLYING		71		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19317562	1	20	32000071|||	2017-05-28 00:00:00	2017-05-28 23:59:59	DINOMITE STICKER FLYING_DEMO2		71		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19315036	1	20	32000071|||	2017-05-29 00:00:00	2500-01-01 00:00:00	DINOMITE STICKER FLYING_DEMO3		71		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19314933	1	20	32000072|||	2017-05-27 00:00:00	2017-05-28 23:59:59	Q&A SERIES - MACHINES		72		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19318139	1	20	32000072|||	2017-05-28 00:00:00	2017-05-28 23:59:59	Q&A SERIES - MACHINES_DEMO2		72		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19318199	1	20	32000072|||	2017-05-29 00:00:00	2500-01-01 00:00:00	Q&A SERIES - MACHINES_DEMO3		72		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19317538	1	20	32000073|||	2017-05-27 00:00:00	2017-05-28 23:59:59	FISH & SEAFOOD		73		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19314973	1	20	32000073|||	2017-05-28 00:00:00	2017-05-28 23:59:59	FISH & SEAFOOD_DEMO2		73		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19315020	1	20	32000073|||	2017-05-29 00:00:00	2500-01-01 00:00:00	FISH & SEAFOOD_DEMO3		73		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19318123	1	20	32000074|||	2017-05-27 00:00:00	2017-05-28 23:59:59	FAIRY FERN		74		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19317574	1	20	32000074|||	2017-05-28 00:00:00	2017-05-28 23:59:59	FAIRY FERN_DEMO2		74		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19317618	1	20	32000074|||	2017-05-29 00:00:00	2500-01-01 00:00:00	FAIRY FERN_DEMO3		74		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19314984	1	20	32000075|||	2017-05-27 00:00:00	2017-05-28 23:59:59	GREATEST EVER COOKBOOK		75		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19317566	1	20	32000075|||	2017-05-28 00:00:00	2017-05-28 23:59:59	GREATEST EVER COOKBOOK_DEMO2		75		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19315040	1	20	32000075|||	2017-05-29 00:00:00	2500-01-01 00:00:00	GREATEST EVER COOKBOOK_DEMO3		75		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19314937	1	20	32000076|||	2017-05-27 00:00:00	2017-05-28 23:59:59	JOLLY CHRISTMAS		76		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19314949	1	20	32000076|||	2017-05-28 00:00:00	2017-05-28 23:59:59	JOLLY CHRISTMAS_DEMO2		76		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19317586	1	20	32000076|||	2017-05-29 00:00:00	2500-01-01 00:00:00	JOLLY CHRISTMAS_DEMO3		76		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19317542	1	20	32000077|||	2017-05-27 00:00:00	2017-05-28 23:59:59	TRUCKS		77		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19314977	1	20	32000077|||	2017-05-28 00:00:00	2017-05-28 23:59:59	TRUCKS_DEMO2		77		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19315024	1	20	32000077|||	2017-05-29 00:00:00	2500-01-01 00:00:00	TRUCKS_DEMO3		77		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19318127	1	20	32000078|||	2017-05-27 00:00:00	2017-05-28 23:59:59	MISC. MIRS ADJUSTMENT		78		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19314981	1	20	32000078|||	2017-05-28 00:00:00	2017-05-28 23:59:59	MISC. MIRS ADJUSTMENT_DEMO2		78		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19315028	1	20	32000078|||	2017-05-29 00:00:00	2500-01-01 00:00:00	MISC. MIRS ADJUSTMENT_DEMO3		78		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19314988	1	20	32000079|||	2017-05-27 00:00:00	2017-05-28 23:59:59	ULTIMATE BK OF DINOS RED		79		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19314953	1	20	32000079|||	2017-05-28 00:00:00	2017-05-28 23:59:59	ULTIMATE BK OF DINOS RED_DEMO2		79		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19317594	1	20	32000079|||	2017-05-29 00:00:00	2500-01-01 00:00:00	ULTIMATE BK OF DINOS RED_DEMO3		79		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19314941	1	20	32000080|||	2017-05-27 00:00:00	2017-05-28 23:59:59	OLD MACDONALD STICKERS - HENS		80		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19317558	1	20	32000080|||	2017-05-28 00:00:00	2017-05-28 23:59:59	OLD MACDONALD STICKERS - HENS_DEMO2		80		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19318187	1	20	32000080|||	2017-05-29 00:00:00	2500-01-01 00:00:00	OLD MACDONALD STICKERS - HENS_DEMO3		80		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19317546	1	20	32000081|||	2017-05-27 00:00:00	2017-05-28 23:59:59	PRACTICAL COOKERY: CHICKEN		81		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19318151	1	20	32000081|||	2017-05-28 00:00:00	2017-05-28 23:59:59	PRACTICAL COOKERY: CHICKEN_DEMO2		81		          		          				
conformed.dim_product - AFTER LoadTransform_DEMO3	19315033	1	20	32000081|||	2017-05-29 00:00:00	2500-01-01 00:00:00	PRACTICAL COOKERY: CHICKEN_DEMO3		81		          		          				
  