CREATE TABLE public.customer
(
	c_custkey INTEGER NOT NULL ENCODE zstd DISTKEY,
	c_name VARCHAR(25) NOT NULL ENCODE zstd,
	c_address VARCHAR(25) NOT NULL ENCODE zstd,
	c_city VARCHAR(10) NOT NULL ENCODE bytedict,
	c_nation VARCHAR(15) NOT NULL ENCODE bytedict,
	c_region VARCHAR(12) NOT NULL ENCODE zstd,
	c_phone VARCHAR(15) NOT NULL ENCODE zstd,
	c_mktsegment VARCHAR(10) NOT NULL ENCODE zstd
)
SORTKEY
(
	c_custkey
);


CREATE TABLE public.dwdate
(
	d_datekey INTEGER NOT NULL,
	d_date VARCHAR(19) NOT NULL,
	d_dayofweek VARCHAR(10) NOT NULL,
	d_month VARCHAR(10) NOT NULL,
	d_year INTEGER NOT NULL,
	d_yearmonthnum INTEGER NOT NULL,
	d_yearmonth VARCHAR(8) NOT NULL,
	d_daynuminweek INTEGER NOT NULL,
	d_daynuminmonth INTEGER NOT NULL,
	d_daynuminyear INTEGER NOT NULL,
	d_monthnuminyear INTEGER NOT NULL,
	d_weeknuminyear INTEGER NOT NULL,
	d_sellingseason VARCHAR(13) NOT NULL,
	d_lastdayinweekfl VARCHAR(1) NOT NULL,
	d_lastdayinmonthfl VARCHAR(1) NOT NULL,
	d_holidayfl VARCHAR(1) NOT NULL,
	d_weekdayfl VARCHAR(1) NOT NULL
)
DISTSTYLE EVEN;


CREATE TABLE public.lineorder
(
	lo_orderkey INTEGER NOT NULL ENCODE zstd DISTKEY,
	lo_linenumber INTEGER NOT NULL ENCODE zstd,
	lo_custkey INTEGER NOT NULL ENCODE zstd,
	lo_partkey INTEGER NOT NULL ENCODE zstd,
	lo_suppkey INTEGER NOT NULL ENCODE zstd,
	lo_orderdate INTEGER NOT NULL ENCODE zstd,
	lo_orderpriority VARCHAR(15) NOT NULL ENCODE zstd,
	lo_shippriority VARCHAR(1) NOT NULL ENCODE zstd,
	lo_quantity INTEGER NOT NULL ENCODE delta,
	lo_extendedprice INTEGER NOT NULL ENCODE zstd,
	lo_ordertotalprice INTEGER NOT NULL ENCODE zstd,
	lo_discount INTEGER NOT NULL ENCODE zstd,
	lo_revenue INTEGER NOT NULL ENCODE zstd,
	lo_supplycost INTEGER NOT NULL ENCODE zstd,
	lo_tax INTEGER NOT NULL ENCODE zstd,
	lo_commitdate INTEGER NOT NULL ENCODE zstd,
	lo_shipmode VARCHAR(10) NOT NULL ENCODE bytedict
)
SORTKEY
(
	lo_orderkey,
	lo_custkey,
	lo_partkey,
	lo_suppkey,
	lo_orderdate,
	lo_commitdate
);


CREATE TABLE public.part
(
	p_partkey INTEGER NOT NULL ENCODE delta DISTKEY,
	p_name VARCHAR(22) NOT NULL ENCODE text255,
	p_mfgr VARCHAR(6) ENCODE zstd,
	p_category VARCHAR(7) NOT NULL ENCODE bytedict,
	p_brand1 VARCHAR(9) NOT NULL ENCODE zstd,
	p_color VARCHAR(11) NOT NULL ENCODE bytedict,
	p_type VARCHAR(25) NOT NULL ENCODE bytedict,
	p_size INTEGER NOT NULL ENCODE delta,
	p_container VARCHAR(10) NOT NULL ENCODE bytedict
)
SORTKEY
(
	p_partkey
);


CREATE TABLE public.part_pipeline_example
(
	p_partkey BIGINT NOT NULL ENCODE lzo DISTKEY,
	p_name VARCHAR(55) NOT NULL ENCODE lzo,
	p_mfgr CHAR(25) NOT NULL ENCODE lzo,
	p_brand CHAR(10) NOT NULL ENCODE lzo,
	p_type VARCHAR(25) NOT NULL ENCODE lzo,
	p_size INTEGER NOT NULL ENCODE lzo,
	p_container CHAR(10) NOT NULL ENCODE lzo,
	p_retailprice NUMERIC(12, 2) NOT NULL ENCODE lzo,
	p_comment VARCHAR(30) NOT NULL ENCODE lzo
);

ALTER TABLE public.part_pipeline_example
ADD CONSTRAINT part_pipeline_example_pkey
PRIMARY KEY (p_partkey);



CREATE TABLE public.supplier
(
	s_suppkey INTEGER NOT NULL ENCODE delta DISTKEY,
	s_name VARCHAR(25) NOT NULL ENCODE zstd,
	s_address VARCHAR(25) NOT NULL ENCODE zstd,
	s_city VARCHAR(10) NOT NULL ENCODE bytedict,
	s_nation VARCHAR(15) NOT NULL ENCODE bytedict,
	s_region VARCHAR(12) NOT NULL ENCODE bytedict,
	s_phone VARCHAR(15) NOT NULL ENCODE zstd
)
SORTKEY
(
	s_suppkey
);


CREATE TABLE public.supplier_wo_encoding
(
	s_suppkey INTEGER NOT NULL ENCODE lzo,
	s_name CHAR(25) NOT NULL ENCODE lzo,
	s_address VARCHAR(40) NOT NULL ENCODE lzo,
	s_nationkey INTEGER NOT NULL ENCODE lzo,
	s_phone CHAR(15) NOT NULL ENCODE lzo,
	s_acctbal NUMERIC(12, 2) NOT NULL ENCODE lzo,
	s_comment VARCHAR(101) NOT NULL ENCODE lzo
)
DISTSTYLE EVEN;


CREATE OR REPLACE VIEW admin.v_generate_tbl_ddl AS 
 SELECT derived_table4.schemaname, derived_table4.tablename, derived_table4.seq, derived_table4.ddl
   FROM ( SELECT derived_table3.schemaname, derived_table3.tablename, derived_table3.seq, derived_table3.ddl
           FROM ((((((((((((( SELECT n.nspname AS schemaname, c.relname AS tablename, 0 AS seq, ('--DROP TABLE "'::text + n.nspname::text + '"."'::text + c.relname::text + '";'::text)::character varying AS ddl
                   FROM pg_namespace n
              JOIN pg_class c ON n.oid = c.relnamespace
             WHERE c.relkind = 'r'::"char"
        UNION 
                 SELECT n.nspname AS schemaname, c.relname AS tablename, 2 AS seq, ('CREATE TABLE IF NOT EXISTS "'::text + n.nspname::text + '"."'::text + c.relname::text + '"'::text)::character varying AS ddl
                   FROM pg_namespace n
              JOIN pg_class c ON n.oid = c.relnamespace
             WHERE c.relkind = 'r'::"char")
        UNION 
                 SELECT n.nspname AS schemaname, c.relname AS tablename, 5 AS seq, '('::character varying AS ddl
                   FROM pg_namespace n
              JOIN pg_class c ON n.oid = c.relnamespace
             WHERE c.relkind = 'r'::"char")
        UNION 
                 SELECT derived_table1.schemaname, derived_table1.tablename, derived_table1.seq, ('\011'::text + derived_table1.col_delim + derived_table1.col_name + ' '::text + derived_table1.col_datatype + ' '::text + derived_table1.col_nullable + ' '::text + derived_table1.col_default + ' '::text + derived_table1.col_encoding)::character varying AS ddl
                   FROM ( SELECT n.nspname AS schemaname, c.relname AS tablename, 100000000 + a.attnum AS seq, 
                                CASE
                                    WHEN a.attnum > 1 THEN ','::text
                                    ELSE ''::text
                                END AS col_delim, '"'::text + a.attname::text + '"'::text AS col_name, 
                                CASE
                                    WHEN strpos(upper(format_type(a.atttypid, a.atttypmod)), 'CHARACTER VARYING'::text) > 0 THEN "replace"(upper(format_type(a.atttypid, a.atttypmod)), 'CHARACTER VARYING'::text, 'VARCHAR'::text)
                                    WHEN strpos(upper(format_type(a.atttypid, a.atttypmod)), 'CHARACTER'::text) > 0 THEN "replace"(upper(format_type(a.atttypid, a.atttypmod)), 'CHARACTER'::text, 'CHAR'::text)
                                    ELSE upper(format_type(a.atttypid, a.atttypmod))
                                END AS col_datatype, 
                                CASE
                                    WHEN format_encoding(a.attencodingtype::integer) = 'none'::bpchar THEN ''::text
                                    ELSE 'ENCODE '::text + format_encoding(a.attencodingtype::integer)::text
                                END AS col_encoding, 
                                CASE
                                    WHEN a.atthasdef IS TRUE THEN 'DEFAULT '::text + adef.adsrc
                                    ELSE ''::text
                                END AS col_default, 
                                CASE
                                    WHEN a.attnotnull IS TRUE THEN 'NOT NULL'::text
                                    ELSE ''::text
                                END AS col_nullable
                           FROM pg_namespace n
                      JOIN pg_class c ON n.oid = c.relnamespace
                 JOIN pg_attribute a ON c.oid = a.attrelid
            LEFT JOIN pg_attrdef adef ON a.attrelid = adef.adrelid AND a.attnum = adef.adnum
           WHERE c.relkind = 'r'::"char" AND a.attnum > 0
           ORDER BY a.attnum) derived_table1)
        UNION 
                ( SELECT n.nspname AS schemaname, c.relname AS tablename, 200000000 + con.oid::integer AS seq, ('\011,'::text + pg_get_constraintdef(con.oid))::character varying AS ddl
                   FROM pg_constraint con
              JOIN pg_class c ON c.relnamespace = con.connamespace AND c.oid = con.conrelid
         JOIN pg_namespace n ON n.oid = c.relnamespace
        WHERE c.relkind = 'r'::"char" AND pg_get_constraintdef(con.oid) !~~ 'FOREIGN KEY%'::text
        ORDER BY 200000000 + con.oid::integer))
        UNION 
                 SELECT n.nspname AS schemaname, c.relname AS tablename, 299999999 AS seq, ')'::character varying AS ddl
                   FROM pg_namespace n
              JOIN pg_class c ON n.oid = c.relnamespace
             WHERE c.relkind = 'r'::"char")
        UNION 
                 SELECT n.nspname AS schemaname, c.relname AS tablename, 300000000 AS seq, 'BACKUP NO'::character varying AS ddl
                   FROM pg_namespace n
              JOIN pg_class c ON n.oid = c.relnamespace
         JOIN ( SELECT split_part(pg_conf."key"::text, '_'::text, 5) AS id
                      FROM pg_conf
                     WHERE pg_conf."key" ~~ 'pg_class_backup_%'::text AND split_part(pg_conf."key"::text, '_'::text, 4) = (( SELECT pg_database.oid
                              FROM pg_database
                             WHERE pg_database.datname = current_database()))::text) t ON t.id = c.oid::text
        WHERE c.relkind = 'r'::"char")
        UNION 
                 SELECT n.nspname AS schemaname, c.relname AS tablename, 1 AS seq, '--WARNING: This DDL inherited the BACKUP NO property from the source table'::character varying AS ddl
                   FROM pg_namespace n
              JOIN pg_class c ON n.oid = c.relnamespace
         JOIN ( SELECT split_part(pg_conf."key"::text, '_'::text, 5) AS id
                      FROM pg_conf
                     WHERE pg_conf."key" ~~ 'pg_class_backup_%'::text AND split_part(pg_conf."key"::text, '_'::text, 4) = (( SELECT pg_database.oid
                              FROM pg_database
                             WHERE pg_database.datname = current_database()))::text) t ON t.id = c.oid::text
        WHERE c.relkind = 'r'::"char")
        UNION 
                 SELECT n.nspname AS schemaname, c.relname AS tablename, 300000001 AS seq, 
                        CASE
                            WHEN c.reldiststyle = 0 THEN 'DISTSTYLE EVEN'::text
                            WHEN c.reldiststyle = 1 THEN 'DISTSTYLE KEY'::text
                            WHEN c.reldiststyle = 8 THEN 'DISTSTYLE ALL'::text
                            ELSE '<<Error - UNKNOWN DISTSTYLE>>'::text
                        END::character varying AS ddl
                   FROM pg_namespace n
              JOIN pg_class c ON n.oid = c.relnamespace
             WHERE c.relkind = 'r'::"char")
        UNION 
                 SELECT n.nspname AS schemaname, c.relname AS tablename, 400000000 + a.attnum AS seq, ('DISTKEY ("'::text + a.attname::text + '")'::text)::character varying AS ddl
                   FROM pg_namespace n
              JOIN pg_class c ON n.oid = c.relnamespace
         JOIN pg_attribute a ON c.oid = a.attrelid
        WHERE c.relkind = 'r'::"char" AND a.attisdistkey IS TRUE AND a.attnum > 0)
        UNION 
                 SELECT derived_table2.schemaname, derived_table2.tablename, derived_table2.seq, 
                        CASE
                            WHEN derived_table2.min_sort < 0 THEN 'INTERLEAVED SORTKEY ('::text
                            ELSE 'SORTKEY ('::text
                        END::character varying AS ddl
                   FROM ( SELECT n.nspname AS schemaname, c.relname AS tablename, 499999999 AS seq, min(a.attsortkeyord) AS min_sort
                           FROM pg_namespace n
                      JOIN pg_class c ON n.oid = c.relnamespace
                 JOIN pg_attribute a ON c.oid = a.attrelid
                WHERE c.relkind = 'r'::"char" AND abs(a.attsortkeyord) > 0 AND a.attnum > 0
                GROUP BY n.nspname, c.relname, 3) derived_table2)
        UNION 
                ( SELECT n.nspname AS schemaname, c.relname AS tablename, 500000000 + abs(a.attsortkeyord) AS seq, 
                        CASE
                            WHEN abs(a.attsortkeyord) = 1 THEN '\011"'::text + a.attname::text + '"'::text
                            ELSE '\011, "'::text + a.attname::text + '"'::text
                        END::character varying AS ddl
                   FROM pg_namespace n
              JOIN pg_class c ON n.oid = c.relnamespace
         JOIN pg_attribute a ON c.oid = a.attrelid
        WHERE c.relkind = 'r'::"char" AND abs(a.attsortkeyord) > 0 AND a.attnum > 0
        ORDER BY abs(a.attsortkeyord)))
        UNION 
                 SELECT n.nspname AS schemaname, c.relname AS tablename, 599999999 AS seq, '\011)'::character varying AS ddl
                   FROM pg_namespace n
              JOIN pg_class c ON n.oid = c.relnamespace
         JOIN pg_attribute a ON c.oid = a.attrelid
        WHERE c.relkind = 'r'::"char" AND abs(a.attsortkeyord) > 0 AND a.attnum > 0)
        UNION 
                 SELECT n.nspname AS schemaname, c.relname AS tablename, 600000000 AS seq, ';'::character varying AS ddl
                   FROM pg_namespace n
              JOIN pg_class c ON n.oid = c.relnamespace
             WHERE c.relkind = 'r'::"char") derived_table3
UNION 
        ( SELECT 'zzzzzzzz'::name AS schemaname, 'zzzzzzzz'::name AS tablename, 700000000 + con.oid::integer AS seq, ('ALTER TABLE '::text + n.nspname::text + '.'::text + c.relname::text + ' ADD '::text + pg_get_constraintdef(con.oid)::character varying(1024)::text + ';'::text)::character varying AS ddl
           FROM pg_constraint con
      JOIN pg_class c ON c.relnamespace = con.connamespace AND c.oid = con.conrelid
   JOIN pg_namespace n ON n.oid = c.relnamespace
  WHERE c.relkind = 'r'::"char" AND pg_get_constraintdef(con.oid) ~~ 'FOREIGN KEY%'::text
  ORDER BY 700000000 + con.oid::integer)
  ORDER BY 1, 2, 3) derived_table4;


CREATE OR REPLACE VIEW public.mdjloadview AS 
 SELECT DISTINCT sl.tbl, btrim(sp.name::text) AS table_name, sl.query, sl.starttime, btrim(sl.filename::text) AS "input", sl.line_number, sl.colname, sl.err_code, btrim(sl.err_reason::text) AS reason
   FROM stl_load_errors sl, stv_tbl_perm sp
  WHERE sl.tbl = sp.id;


