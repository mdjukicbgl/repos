
select top 500
    '2017-05-30' + '|' +
    '1' + '|' +
    dg.geography_type_bkey + '|' +
    dg.geography_bkey + '|' +
    dp.product_bkey + '||||' +
    '1' + '|' +
    ch.channel_key + '|' +
    '4' + '|' +
    'GBP' + '|' +
    convert(varchar(20), ag.total_stock_quantity * ag.cost_price) + '|' +
    convert(varchar(20), ag.total_stock_quantity) + '|' +
    convert(varchar(20), ag.total_stock_quantity * ag.cost_price * 0.65 ) + '|' +
    case ag.price_status
        when 'Promotion'
            then '2'
        when 'Markdown'
            then '3'
        else '1'
    end + '|' +
    '4' + '|' +
    convert(varchar(20), ag.sales_quantity * ag.cost_price) + '|' +
    convert(varchar(20), ag.sales_quantity) + '|' +
    convert(varchar(20), ag.sales_quantity * ag.cost_price * 0.65) + '|' +
    convert(varchar(20), ag.sales_quantity * ag.cost_price * 0.10) + '|' +
    convert(varchar(20), convert(int,ag.sales_quantity * 0.10)) + '|' +
    convert(varchar(20), ag.sales_quantity * ag.cost_price * 0.15) + '|' +
    convert(varchar(20), convert(int,ag.sales_quantity * 0.15)) + '|' +
    convert(varchar(20), ag.cost_price) + '|' +
    convert(varchar(20), ag.cost_price * 1.4) + '|' +
    '12345|' +
    '10423|' +
    convert(varchar(20), ag.sales_quantity * ag.cost_price * 0.05) + '|' +
    convert(varchar(20), ag.sales_quantity * ag.cost_price * 0.12) + '|' +
    convert(varchar(20), ag.sales_quantity * ag.cost_price * 0.42) + '|' +
    '0.2'
from conformed.dim_hierarchy_node   hn
join conformed.bridge_product_hierarchy ph on hn.dim_hierarchy_node_id = ph.dim_hierarchy_node_id
join markdown_app.tbl_fact_weekly_sales_basic_aggregated fc on ph.dim_product_id = fc.dim_product_id
join conformed.dim_product dp on ph.dim_product_id = dp.dim_product_id
cross join stage.channel ch
cross join conformed.dim_geography dg
cross join markdown_app.tbl_fact_weekly_sales_basic_aggregated ag