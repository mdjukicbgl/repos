CREATE TABLE IF NOT EXISTS conformed.dim_geography (
    dim_geography_id int8 identity(-1,1) not null,
    batch_id int8 not null default 1,
    dim_retailer_id int8 not null,
    geography_bkey varchar(20) not null,
    geography_type_bkey varchar(20) not null default '0'::character varying,
    effective_start_date_time timestamp not null default '2007-01-01 00:00:00'::timestamp without time zone,
    effective_end_date_time timestamp not null default '2500-01-01 00:00:00'::timestamp without time zone,
    geography_type varchar(20) not null default 'Unknown'::character varying,
    geography_name varchar(100) not null,
    city_name varchar(50),
    country_name varchar(50),
    region_name varchar(50),
    longitude_position varchar(50),
    latitude_position varchar(50),
    PRIMARY KEY (dim_geography_id)
);