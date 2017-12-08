CREATE TABLE IF NOT EXISTS markdown_app.tbl_fact_weekly_sales_basic_aggregated (
    dim_product_id int8,
    week_sequence_number_usa int4,
    optimisation_csp numeric(34, 4),
    sales_quantity int4,
    total_stock_quantity int4,
    cost_price numeric(34, 4),
    price_status varchar(50),
    price_status_id varchar(20),
    previous_price_status varchar(50),
    previous_price_status_id varchar(20),
    is_md_preceded_by_promotion int4,
    is_promotional_price_change int4,
    is_full_price int4
);