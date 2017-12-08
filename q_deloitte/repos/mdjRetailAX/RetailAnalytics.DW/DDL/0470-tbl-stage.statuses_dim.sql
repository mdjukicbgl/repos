drop table if exists stage.statuses_dim;

create table stage.statuses_dim (
    batch_id int,
    dim_retailer_id int,
    reporting_date varchar(10),
    reporting_date_period_type char(1),
    status_type_bkey char(1),
    status_bkey varchar(20),
    status_name varchar(50),
    is_global_status char(1),
    is_unknown_member char(1),
    row_id bigint identity(1,1) not null
);
