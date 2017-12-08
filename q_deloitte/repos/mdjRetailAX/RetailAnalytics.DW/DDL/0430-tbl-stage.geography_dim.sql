drop table if exists stage.geography_dim;

create table stage.geography_dim (
    batch_id int,
    dim_retailer_id int,
    reporting_date varchar(10),
    reporting_date_period_type char(1),
    geography_type_key char(1),
    geography_key varchar(20),
    geographical_location_name varchar(100),
    geographical_location_description varchar(256),
    geographical_location_status varchar(100),
    geographical_location_county_state varchar(100),
    geographical_location_country varchar(100),
    geographical_location_region varchar(100),
    geographical_location_subregion varchar(100),
    longitude varchar(50),
    latitude varchar(50),
    row_id bigint identity(1,1) not null
);
