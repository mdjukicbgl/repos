
--aws_access_key_id = AKIAJ4H2LRQQYHJ2DK5Q
--aws_secret_access_key = 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

copy part from 's3://mdj-bucket-001/load/part-csv.tbl' 
credentials 'aws_access_key_id=AKIAJ4H2LRQQYHJ2DK5Q;aws_secret_access_key=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' 
csv
null as '\000'
;

---------------------------------------------------------------------------------------------------
-- load dwdate table from mdj-bucket-002 eu-west-1 region
--CREDENTIALS 'aws_iam_role=arn:aws:iam::678752479360:role/admin'
---------------------------------------------------------------------------------------------------
copy dwdate from 's3://mdj-bucket-002/load/dwdate-tab.tbl'
credentials 'aws_access_key_id=AKIAJ4H2LRQQYHJ2DK5Q;aws_secret_access_key=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'
delimiter '\t' 
region 'eu-west-1'
;

---------------------------------------------------------------------------------------------------
-- load supplier table from AWS bucket s3://awssampledbuswest2/ssbgz/supplier.tbl in 'us-west-1'
--CREDENTIALS 'aws_iam_role=arn:aws:iam::678752479360:role/RedshiftCopyUnload'
--CREDENTIALS 'aws_iam_role=arn:aws:iam::aws:policy/AmazonRedshiftFullAccess'
--credentials 'aws_access_key_id=AKIAJ4H2LRQQYHJ2DK5Q;aws_secret_access_key=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' 
                   iam_role 'arn:aws:iam::678752479360:role/MyRedshiftRole'
				   
				   
---------------------------------------------------------------------------------------------------
--truncate table mdjdb.public.supplier
--;

copy  mdjdb.public.supplier from 's3://awssampledbuswest2/ssbgz/supplier.tbl' 
CREDENTIALS 'aws_iam_role=arn:aws:iam::678752479360:role/RedshiftCopyUnload'
delimiter '|' 
gzip
region 'us-west-2'
;

---------------------------------------------------------------------------------------------------
-- analyze table and report back.....
---------------------------------------------------------------------------------------------------

--analyze compression supplier
--;

analyze  supplier
;

 select distinct 
                        a.xid 
      , trim(t.name) as name 
      , a.status 
      , a.rows 
      , a.modified_rows 
      , a.starttime 
      , a.endtime
   from 
        stl_analyze  a
   join stv_tbl_perm t on t.id=a.table_id
  where name                  = 'supplier'
order by 
        starttime
;
  
---------------------------------------------------------------------------------------------------
-- load customer table from my bucket mdj-bucket-001 in 'us-west-2'
--credentials 'aws_access_key_id=AKIAJ4H2LRQQYHJ2DK5Q;aws_secret_access_key=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' 
---------------------------------------------------------------------------------------------------
copy customer from 's3://mdj-bucket-001/load/customer-fw-manifest'
credentials 'aws_access_key_id=AKIAJ4H2LRQQYHJ2DK5Q;aws_secret_access_key=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' 
fixedwidth 'c_custkey:10, c_name:25, c_address:25, c_city:10, c_nation:15, c_region :12, c_phone:15,c_mktsegment:10'
maxerror 10 
ACCEPTINVCHARS AS '^'
manifest
region 'us-west-2'
;

--truncate table customer

copy customer from 's3://mdj-bucket-001/load/customer-fw.tbl'
CREDENTIALS 'aws_iam_role=arn:aws:iam::678752479360:role/RedshiftCopyUnload'
fixedwidth 'c_custkey:10, c_name:25, c_address:25, c_city:10, c_nation:15, c_region :12, c_phone:15,c_mktsegment:10'
maxerror 10
ACCEPTINVCHARS AS '^'
manifest
region 'us-west-2'
;

select top 11 *
  from mdjdb.public.customer
  where c_name = 'Customer#000000002'
  
  
  )
select *
  from stl_load_errors
order by starttime
;

---------------------------------------------------------------------------------------------------
-- load line order table from single source located in bucket 's3://awssampledb/load/lo/lineorder-single.tbl' 
---------------------------------------------------------------------------------------------------
--truncate table mdjdb.public.lineorder;
copy mdjdb.public.lineorder from 's3://awssampledb/load/lo/lineorder-single.tbl' 
credentials 'aws_access_key_id=AKIAJ4H2LRQQYHJ2DK5Q;aws_secret_access_key=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' 
gzip
compupdate off
region 'us-east-1'
;
--76 secs

--truncate table mdjdb.public.lineorder;
copy mdjdb.public.lineorder from 's3://awssampledb/load/lo/lineorder-multi.tbl' 
credentials 'aws_access_key_id=AKIAJ4H2LRQQYHJ2DK5Q;aws_secret_access_key=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' 
gzip
compupdate off
region 'us-east-1'
;
--81.7667748 secs

select query, trim(filename) as filename, curtime, status
from stl_load_commits
where filename like '%customer%' order by query;

analyze  mdjdb.public.lineorder;

  

select top 111 *
  from supplier
  
  --from stl_replacements
  --from stl_load_errors
  --from customer
--where c_name = 'Customer#000000001'  
  --from STV_LOAD_STATE
--  from STL_S3CLIENT 
--order by recordtime desc
  from STL_LOAD_COMMITS
order by starttime desc


select *  --l.query,rtrim(l.filename),q.xid
from stl_load_commits l, stl_query q
where l.query=q.query
and exists
(select xid from stl_utilitytext where xid=q.xid and rtrim("text")='COMMIT')
order by starttime desc

select slice, key, transfer_time 
from stl_s3client 
where query = pg_last_copy_id()
order by key
;

  
  
  
select * -- user_name, db_name, pid, query
from stv_recents
where db_name = 'mdjdb'
  and user_name = 'mdj_marko'
order by starttime desc


c_custkey	c_name				c_address			c_city		c_nation	c_region		c_phone			c_mktsegment
2			Customer#000000002  XSTf4,NCwDVaWNe6tE  JORDAN   6	JORDAN      MIDDLE EAST 	23-453-414-8560	AUTOMOBILE


 select * from svl_query_summary where userid > 1
 
 
select count(*)
  from customer
  
 select *
   from 
        --stv_blocklist b 
		stv_tbl_perm  p
 where name = 'supplier'
 order by slice
;

/*
To Review Compression Encodings
Find how much space each column uses.
Query the STV_BLOCKLIST system view to find the number of 1 MB blocks each column uses. 
The MAX aggregate function returns the highest block number for each column. 
This example uses col < 17 in the WHERE clause to exclude system-generated columns.
Execute the following command.
Copy
*/
 select 
        col 
      , max(blocknum)
   from 
        stv_blocklist b 
      , stv_tbl_perm  p
  where (b.tbl=p.id) 
        and name = 'supplier' --'''dwdate' --'lineorder'
        and col  < 17
group by 
        name 
      , col
order by 
        col
;


---------------------------------------------------------------------------------------------------
-- Create a Temporary Table That Is LIKE Another Table
-- This table also inherits the DISTKEY and SORTKEY attributes of its parent table:
---------------------------------------------------------------------------------------------------
The following example creates a temporary table called temppart, which inherits its columns from the part table.

create table if not exists temppart(like part);
select * from temppart;
drop table if exists temppart;

---------------------------------------------------------------------------------------------------
-- Show column attributes of table
---------------------------------------------------------------------------------------------------
 select 
        "column" 
      , type 
      , encoding 
      , distkey 
      , sortkey
   from 
        pg_table_def 
  where tablename = 'supplier'
;

-- http://docs.aws.amazon.com/redshift/latest/dg/tutorial-tuning-tables-retest.html

---------------------------------------------------------------------------------------------------
-- 1. Record Storage use.....
-- Determine how many 1 MB blocks of disk space are used for each table by querying the 
-- STV_BLOCKLIST table and record the results in your benchmarks table.
---------------------------------------------------------------------------------------------------
 select 
        stv_tbl_perm.name as "table" 
      , count(*)          as "blocks (mb)"
   from 
        stv_blocklist 
      , stv_tbl_perm
  where stv_blocklist.tbl       = stv_tbl_perm.id
        and stv_blocklist.slice = stv_tbl_perm.slice
        and stv_tbl_perm.name in ('customer' 
                                , 'part' 
                                , 'supplier' 
                                , 'dwdate' 
                                , 'lineorder')
group by 
        stv_tbl_perm.name
order by 
        1 asc
;
--table	blocks (mb)
--dwdate  40
--part    48

---------------------------------------------------------------------------------------------------
-- 2. Check for Distribution skew.....
-- Uneven distribution, or data distribution skew, forces some nodes to do more work than others, 
-- which limits query performance.
-- 
-- To check for distribution skew, query the SVV_DISKUSAGE system view. Each row in SVV_DISKUSAGE 
-- records the statistics for one disk block. 
-- The num_values column gives the number of rows in that disk block, so sum(num_values) returns 
-- the number of rows on each slice.
--
-- Execute the following query to see the distribution for all of the tables in the SSB database..
---------------------------------------------------------------------------------------------------
 select 
        trim(name) as table 
      , slice 
      , sum(num_values) as rows 
      , min(minvalue) 
      , max(maxvalue)
   from 
        svv_diskusage
  where name in ('customer' 
               , 'part' 
               , 'supplier' 
               , 'dwdate' 
               , 'lineorder')
        and col =0
group by 
        name 
      , slice
order by 
        name 
      , slice
;
--table	slice		rows	min			max
--dwdate	0		1278	19920101	19981229
--dwdate	1		1278	19911231	19981228
--part		0		24961	2			49998
--part		1		25038	1			49999


 select 
        query 
      , substring(filename,22,25)       as filename 
      , line_number                     as line 
      , substring(colname,0,12)         as column 
      , type 
      , position                        as pos 
      , substring(raw_line,0,30)        as line_text 
      , substring(raw_field_value,0,15) as field_text 
      , substring(err_reason,0,45)      as reason
   from 
        stl_load_errors
order by 
        query desc limit 10
;



 select *
   from 
        --stv_blocklist b 
		stv_tbl_perm  p
  where name = 'part'
 order by slice
;

analyze compression supplier
