CREATE TABLE IF NOT EXISTS sales.dim_junk (
    dim_junk_id int8 identity(0,1) not null,
    batch_id numeric(10, 0) not null default 1,
    PRIMARY KEY (dim_junk_id)
);