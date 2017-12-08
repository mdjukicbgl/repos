CREATE TABLE IF NOT EXISTS markdown_app.tbl_markdown_events (
    dim_product_id int8,
    week_sequence_number_usa int4,
    sales_quantity int4,
    previous_quantity int4,
    optimisation_csp numeric(34, 4),
    previous_price numeric(34, 4),
    is_md_preceded_by_promotion int4,
    is_promotional_price_change int4,
    is_full_price int4
);