select * from pg_tbl_Def

---------------------------------------------------------------------------------------------------
-- Create supplier table and load table with auto-compression
---------------------------------------------------------------------------------------------------
CREATE TABLE supplier 
    (
        s_suppkey int4 NOT NULL 
      , s_name    char(25) NOT NULL 
      , s_address varchar(40) NOT NULL 
      , s_nationkey int4 NOT NULL 
      , s_phone   char(15) NOT NULL 
      , s_acctbal numeric(12,2) NOT NULL 
      , s_comment varchar(101) NOT NULL
    );


copy supplier from 's3://us-west-2-aws-training/awsu-spl/redshift-quest/supplier/supplier.json' 
CREDENTIALS 'aws_iam_role=arn:aws:iam::678752479360:role/RedshiftCopyUnload'
lzop delimiter '|' 
COMPUPDATE ON 
manifest;


select "column", type, encoding from pg_table_def where tablename = 'supplier';
--column	type	encoding
--s_address		character varying(25)	zstd
--s_city		character varying(10)	bytedict
--s_name		character varying(25)	zstd
--s_nation		character varying(15)	bytedict
--s_phone		character varying(15)	zstd
--s_region		character varying(12)	bytedict
--s_suppkey		integer					delta
--;

analyze compression supplier
;

---------------------------------------------------------------------------------------------------
-- Create supplier table without encoding, and load data into the table
---------------------------------------------------------------------------------------------------
CREATE TABLE supplier_wo_encoding 
(
        s_suppkey int4 NOT NULL 
      , s_name    char(25) NOT NULL 
      , s_address varchar(40) NOT NULL 
      , s_nationkey int4 NOT NULL 
      , s_phone   char(15) NOT NULL 
      , s_acctbal numeric(12,2) NOT NULL 
      , s_comment varchar(101) NOT NULL
)
;

copy supplier_wo_encoding from 's3://us-west-2-aws-training/awsu-spl/redshift-quest/supplier/supplier.json' 
CREDENTIALS 'aws_iam_role=arn:aws:iam::678752479360:role/RedshiftCopyUnload'
lzop delimiter '|' 
COMPUPDATE OFF 
manifest
;

---------------------------------------------------------------------------------------------------
-- comparison of number of blocks allocated to each table, with and without encoding
---------------------------------------------------------------------------------------------------
 select 
        stv_tbl_perm.name 
      , col 
      , count(*) 
   from 
        stv_blocklist 
      , stv_tbl_perm 
  where stv_blocklist.tbl       = stv_tbl_perm.id 
        and stv_blocklist.slice = stv_tbl_perm.slice 
        and stv_tbl_perm.name in ('supplier' 
                                , 'supplier_wo_encoding') 
group by 
        stv_tbl_perm.name 
      , col 
order by 
        stv_tbl_perm.name 
      , col
;
name					col	count
supplier                  0	4
supplier                  1	6
supplier                  2	16
supplier                  3	4
supplier                  4	4
supplier                  5	4
supplier                  6	10
supplier                  7	4
supplier                  8	4
supplier                  9	10
supplier_wo_encoding      0	6
supplier_wo_encoding      1	6
supplier_wo_encoding      2	32
supplier_wo_encoding      3	4
supplier_wo_encoding      4	12
supplier_wo_encoding      5	6
supplier_wo_encoding      6	28
supplier_wo_encoding      7	2
supplier_wo_encoding      8	2
supplier_wo_encoding      9	10

-- Troubleshooting Data Load Issues
-- The following 2 tables are helpful in this regard:
-- stl_load_errors - Contains a history of all Amazon Redshift load errors
-- stl_file_scan - Returns the files that Amazon Redshift read while loading data via COPY command
--
-- Also, you can validate the load of data by using the NOLOAD option.  This will highlight any 
-- potential errors which may occur while loading

create or replace view 
    mdjloadview as 
    (select distinct 
                      tbl 
      , trim(name) as table_name 
      , query 
      , starttime 
      , trim(filename) as input 
      , line_number 
      , colname 
      , err_code 
      , trim(err_reason) as reason 
   from 
        stl_load_errors sl 
      , stv_tbl_perm    sp 
  where sl.tbl = sp.id 
    ) 
;


select *
  from stl_file_scan
;

-- Load remotely

copy supplier_remote_load from 'mdj-bucket-001/load/supplier_manifest.json'
CREDENTIALS 'aws_iam_role=arn:aws:iam::678752479360:role/RedshiftCopyUnload' 
delimiter '|' 
COMPUPDATE ON
ssh
;


copy supplier_remote_load from 'mdj-bucket-001/load/supplier_manifest.json'
credentials 'aws_access_key_id=AKIAIZWDU37VQR6BZWJA;aws_secret_access_key=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'
delimiter '|' 
COMPUPDATE ON
ssh
;

 

CREATE TABLE mdj_test.supplier_wo_encoding 
(
        s_suppkey int4 NOT NULL 
      , s_name    char(25) NOT NULL 
      , s_address varchar(40) NOT NULL 
      , s_nationkey int4 NOT NULL 
      , s_phone   char(15) NOT NULL 
      , s_acctbal numeric(12,2) NOT NULL 
      , s_comment varchar(101) NOT NULL
)
;

select count(*)
  from mdjdb.public.customer
;
select top 111 *
  from mdjdb.public.customer
;

  
  
select query, rtrim(querytxt), starttime

from stl_query

where querytxt like 'padb_fetch_sample%' and querytxt like '%customer%'

order by query desc;


select master_guid as Master_GUID from app_build limit 1
