drop table if exists stage.channel_dim;

create table stage.channel_dim (
    batch_id int,
    dim_retailer_id bigint,
    reporting_date varchar(10),
    reporting_date_period_type char(1),
    channel_key varchar(20),
    channel_name varchar(50),
    channel_description varchar(100),
    channel_code varchar(10),
    row_id bigint identity(1,1) not null
);