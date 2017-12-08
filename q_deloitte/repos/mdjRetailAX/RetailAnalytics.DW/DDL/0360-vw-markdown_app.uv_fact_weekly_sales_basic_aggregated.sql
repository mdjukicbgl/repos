DROP VIEW IF EXISTS markdown_app.uv_fact_weekly_sales_basic_aggregated;

CREATE VIEW markdown_app.uv_fact_weekly_sales_basic_aggregated
AS
 SELECT dt.dim_product_id, 
        dt.week_sequence_number_usa, 
        dt.optimisation_csp, 
        dt.sales_quantity, 
        dt.total_stock_quantity, 
        dt.cost_price, 
        dt.price_status, 
        dt.price_status_id, 
        dt.previous_price_status, 
        dt.previous_price_status_id,
        CASE
            WHEN dt.price_status_id::text = 1::text 
                THEN 1
            ELSE 0
        END AS is_md_preceded_by_promotion,
        CASE
            WHEN dt.price_status_id::text = 3::text 
                THEN 1
            ELSE 0
        END AS is_promotional_price_change,
        CASE
            WHEN dt.price_status_id::text = 2::text 
            AND dt.previous_price_status_id = 3::text 
                THEN 1
            ELSE 0
        END AS is_full_price
   FROM ( SELECT    fwsb.dim_product_id, 
                    ddwuv.week_sequence_number_usa, 
                    "max"(fwsb.optimisation_osp)::numeric(34,4) AS optimisation_osp, 
                    avg(fwsb.optimisation_csp)::numeric(34,4) AS optimisation_csp, 
                    avg(fwsb.sales_quantity)::integer AS sales_quantity, 
                    avg(fwsb.total_stock_quantity)::integer AS total_stock_quantity, 
                    avg(fwsb.cost_price)::numeric(34,4) AS cost_price, 
                    cps.price_status, cps.price_status_bkey AS price_status_id, 
                    pg_catalog.lead(cps.price_status::text, 1)
                                OVER(
                                    PARTITION BY fwsb.dim_product_id
                                    ORDER BY ddwuv.week_sequence_number_usa DESC) AS previous_price_status, 
                    pg_catalog.lead(cps.price_status_bkey::text, 1)
                                OVER(
                                    PARTITION BY fwsb.dim_product_id
                                    ORDER BY ddwuv.week_sequence_number_usa DESC) AS previous_price_status_id
           FROM markdown_app.uv_dim_date_weekly_usa ddwuv
            JOIN markdown_app.uv_fact_weekly_sales_basic fwsb ON ddwuv.dim_date_id = fwsb.dim_date_id
            JOIN ( SELECT   pg_catalog.row_number()
                                    OVER(
                                    PARTITION BY cpsbc.dim_product_id, cpsbc.week_sequence_number_usa
                                    ORDER BY cpsbc.total_stock_quantity DESC) AS rank, 
                            cpsbc.dim_product_id, 
                            cpsbc.week_sequence_number_usa, 
                            cpsbc.price_status, 
                            cpsbc.price_status_bkey, 
                            cpsbc.price_status_rank, 
                            cpsbc.total_stock_quantity
                    FROM (  SELECT  fwsb.dim_product_id, 
                                    ddwuv.week_sequence_number_usa, 
                                    dps.price_status, 
                                    dps.price_status_bkey, 
                                    pg_catalog.dense_rank()
                                            OVER(
                                            PARTITION BY fwsb.dim_product_id, ddwuv.week_sequence_number_usa
                                            ORDER BY count(dps.price_status) DESC) AS price_status_rank, sum(fwsb.total_stock_quantity) AS total_stock_quantity
                            FROM markdown_app.uv_dim_date_weekly_usa ddwuv
                            JOIN markdown_app.uv_fact_weekly_sales_basic fwsb ON ddwuv.dim_date_id = fwsb.dim_date_id
                            JOIN markdown_app.uv_dim_price_status dps ON fwsb.dim_price_status_id = dps.dim_price_status_id
                            GROUP BY    fwsb.dim_product_id, 
                                        ddwuv.week_sequence_number_usa, 
                                        dps.price_status, 
                                        dps.price_status_bkey) cpsbc
                    WHERE   cpsbc.price_status_rank = 1
                    GROUP BY    cpsbc.dim_product_id, 
                                cpsbc.week_sequence_number_usa, 
                                cpsbc.price_status, 
                                cpsbc.price_status_bkey, 
                                cpsbc.price_status_rank, 
                                cpsbc.total_stock_quantity) cps ON cps.dim_product_id = fwsb.dim_product_id 
                                                                AND cps.week_sequence_number_usa = ddwuv.week_sequence_number_usa 
                                                                AND cps.rank = 1
            WHERE fwsb.dim_retailer_id = 1 
            AND fwsb.optimisation_csp IS NOT NULL
            GROUP BY    fwsb.dim_product_id, 
                        ddwuv.week_sequence_number_usa, 
                        cps.price_status, 
                        cps.price_status_bkey, 
                        cps.price_status_rank) dt;
