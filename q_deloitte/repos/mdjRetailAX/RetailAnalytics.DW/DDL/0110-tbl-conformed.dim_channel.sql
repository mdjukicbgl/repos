CREATE TABLE IF NOT EXISTS conformed.dim_channel (
    dim_channel_id int8 identity(-1,1) not null,
    dim_retailer_id int8 not null,
    channel_bkey varchar(50) not null,
    channel_name varchar(50) not null,
    channel_description varchar(250),
    channel_code char(10),
    PRIMARY KEY (dim_channel_id),
    FOREIGN KEY (dim_retailer_id) REFERENCES conformed.dim_retailer (dim_retailer_id)
);
