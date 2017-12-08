drop table part cascade;
drop table supplier;
drop table customer;
drop table dwdate;
drop table lineorder;

--alter table mdjdb.public.part rename to mdjdb_public_part_old
--;

--truncate table customer;

---------------------------------------------------------------------------------------------------
-- create part table.....
---------------------------------------------------------------------------------------------------
CREATE TABLE part 
(
  p_partkey     INTEGER     NOT NULL encode delta,
  p_name        VARCHAR(22) NOT NULL encode text255,
  p_mfgr        VARCHAR(6)           encode zstd,
  p_category    VARCHAR(7)  NOT NULL encode bytedict,
  p_brand1      VARCHAR(9)  NOT NULL encode zstd,
  p_color       VARCHAR(11) NOT NULL encode bytedict,
  p_type        VARCHAR(25) NOT NULL encode bytedict,
  p_size        INTEGER     NOT NULL encode delta,
  p_container   VARCHAR(10) NOT NULL encode bytedict
)
distkey(p_partkey)
sortkey(p_partkey)
;

--insert into mdjdb.public.part
--select *
--  from mdjdb_public_part_old
--;

--drop table public.mdjdb_public_part_old
--;

--analyse compression mdjdb.public.part
--;

select top 111 *
  from mdjdb.public.part
  
---------------------------------------------------------------------------------------------------
-- create supplier table.....
---------------------------------------------------------------------------------------------------
drop table if exists supplier
;

CREATE TABLE supplier 
(
  s_suppkey   INTEGER     NOT NULL encode delta,
  s_name      VARCHAR(25) NOT NULL encode zstd,
  s_address   VARCHAR(25) NOT NULL encode zstd,
  s_city      VARCHAR(10) NOT NULL encode bytedict,
  s_nation    VARCHAR(15) NOT NULL encode bytedict,
  s_region    VARCHAR(12) NOT NULL encode bytedict,
  s_phone     VARCHAR(15) NOT NULL encode zstd
  )
distkey(s_suppkey)
sortkey(s_suppkey)
;

---------------------------------------------------------------------------------------------------
-- Show column attributes of supplier table.....
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

--analyse compression mdjdb.public.supplier
--;

DROP TABLE if exists mdjdb.public.customer
;

CREATE TABLE if not exists customer 
(
  c_custkey      INTEGER     NOT NULL encode zstd,
  c_name         VARCHAR(25) NOT NULL encode zstd,
  c_address      VARCHAR(25) NOT NULL encode zstd,
  c_city         VARCHAR(10) NOT NULL encode bytedict,
  c_nation       VARCHAR(15) NOT NULL encode bytedict,
  c_region       VARCHAR(12) NOT NULL encode zstd,
  c_phone        VARCHAR(15) NOT NULL encode zstd,
  c_mktsegment   VARCHAR(10) NOT NULL encode zstd
)
distkey(c_custkey)
sortkey(c_custkey)
;

--analyse compression mdjdb.public.customer
--;

CREATE TABLE dwdate
(
  d_datekey            INTEGER NOT NULL,
  d_date               VARCHAR(19) NOT NULL,
  d_dayofweek          VARCHAR(10) NOT NULL,
  d_month              VARCHAR(10) NOT NULL,
  d_year               INTEGER NOT NULL,
  d_yearmonthnum       INTEGER NOT NULL,
  d_yearmonth          VARCHAR(8) NOT NULL,
  d_daynuminweek       INTEGER NOT NULL,
  d_daynuminmonth      INTEGER NOT NULL,
  d_daynuminyear       INTEGER NOT NULL,
  d_monthnuminyear     INTEGER NOT NULL,
  d_weeknuminyear      INTEGER NOT NULL,
  d_sellingseason      VARCHAR(13) NOT NULL,
  d_lastdayinweekfl    VARCHAR(1) NOT NULL,
  d_lastdayinmonthfl   VARCHAR(1) NOT NULL,
  d_holidayfl          VARCHAR(1) NOT NULL,
  d_weekdayfl          VARCHAR(1) NOT NULL
)
distkey (d_datekey)
sortkey (d_datekey)
;


--analyse compression mdjdb.public.dwdate
--;

drop table if exists lineorder
;

CREATE TABLE lineorder 
(
  lo_orderkey          INTEGER NOT NULL encode zstd,
  lo_linenumber        INTEGER NOT NULL encode zstd,
  lo_custkey           INTEGER NOT NULL encode zstd,
  lo_partkey           INTEGER NOT NULL encode zstd,
  lo_suppkey           INTEGER NOT NULL encode zstd,
  lo_orderdate         INTEGER NOT NULL encode zstd,
  lo_orderpriority     VARCHAR(15) NOT NULL encode zstd,
  lo_shippriority      VARCHAR(1) NOT NULL encode zstd,
  lo_quantity          INTEGER NOT NULL encode delta,
  lo_extendedprice     INTEGER NOT NULL encode zstd,
  lo_ordertotalprice   INTEGER NOT NULL encode zstd,
  lo_discount          INTEGER NOT NULL encode zstd,
  lo_revenue           INTEGER NOT NULL encode zstd,
  lo_supplycost        INTEGER NOT NULL encode zstd,
  lo_tax               INTEGER NOT NULL encode zstd,
  lo_commitdate        INTEGER NOT NULL encode zstd,
  lo_shipmode          VARCHAR(10) NOT NULL  encode bytedict
)
distkey(lo_orderkey)
sortkey(lo_orderkey, lo_custkey, lo_partkey, lo_suppkey, lo_orderdate, lo_commitdate )
;

--analyse compression mdjdb.public.lineorder
--;

