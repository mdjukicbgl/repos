DROP VIEW IF EXISTS markdown_app.uv_dim_product;

CREATE VIEW markdown_app.uv_dim_product
AS
SELECT
	 dp.dim_product_id
	,dp.dim_retailer_id
	,dp.product_bkey
	,dp.effective_start_date_time
	,dp.effective_end_date_time
	,dp.product_name
	,dp.product_description
	,dp.product_sku_code
	,dp.product_size
	,dp.product_colour_code
	,dp.product_colour
	,dp.product_gender
	,dp.product_age_group
	,dp.brand_name
	,dp.supplier_name
	,dp.product_status
	--	dynamic hiearchy attributes
	,dh.dim_hierarchy_id
	,dh.hierarchy_name
	,COALESCE(	dhn10.dim_hierarchy_node_id
				,dhn9.dim_hierarchy_node_id
				,dhn8.dim_hierarchy_node_id
				,dhn7.dim_hierarchy_node_id
				,dhn6.dim_hierarchy_node_id
				,dhn5.dim_hierarchy_node_id
				,dhn4.dim_hierarchy_node_id
				,dhn3.dim_hierarchy_node_id
				,dhn2.dim_hierarchy_node_id
				,dhn.dim_hierarchy_node_id
				) AS dim_hierarchy_node_id
	,dhn.hierarchy_node_name as hierarchy_level_0
	,dhn2.hierarchy_node_name as hierarchy_level_1
	,dhn3.hierarchy_node_name as hierarchy_level_2
	,dhn4.hierarchy_node_name as hierarchy_level_3
	,dhn5.hierarchy_node_name as hierarchy_level_4
	,dhn6.hierarchy_node_name as hierarchy_level_5
	,dhn7.hierarchy_node_name as hierarchy_level_6
	,dhn8.hierarchy_node_name as hierarchy_level_7
	,dhn9.hierarchy_node_name as hierarchy_level_8
	,dhn10.hierarchy_node_name as hierarchy_level_9
FROM
	conformed.dim_product dp
LEFT OUTER JOIN
	(
		conformed.bridge_product_hierarchy bph 
	INNER JOIN
		(
			conformed.dim_hierarchy dh
		JOIN
			conformed.dim_hierarchy_node dhn ON dh.dim_hierarchy_id = dhn.dim_hierarchy_id
											AND dhn.parent_dim_hierarchy_node_id IS NULL
											AND GETDATE() BETWEEN dhn.effective_start_date_time AND dhn.effective_end_date_time
		LEFT JOIN
			conformed.dim_hierarchy_node dhn2 ON dhn.dim_hierarchy_node_id = dhn2.parent_dim_hierarchy_node_id
											AND GETDATE() BETWEEN dhn2.effective_start_date_time AND dhn2.effective_end_date_time
		LEFT JOIN
			conformed.dim_hierarchy_node dhn3 ON dhn2.dim_hierarchy_node_id = dhn3.parent_dim_hierarchy_node_id
											AND GETDATE() BETWEEN dhn3.effective_start_date_time AND dhn3.effective_end_date_time
		LEFT JOIN
			conformed.dim_hierarchy_node dhn4 ON dhn3.dim_hierarchy_node_id = dhn4.parent_dim_hierarchy_node_id
											AND GETDATE() BETWEEN dhn4.effective_start_date_time AND dhn4.effective_end_date_time
		LEFT JOIN
			conformed.dim_hierarchy_node dhn5 ON dhn4.dim_hierarchy_node_id = dhn5.parent_dim_hierarchy_node_id
											AND GETDATE() BETWEEN dhn5.effective_start_date_time AND dhn5.effective_end_date_time
		LEFT JOIN
			conformed.dim_hierarchy_node dhn6 ON dhn5.dim_hierarchy_node_id = dhn6.parent_dim_hierarchy_node_id
											AND GETDATE() BETWEEN dhn6.effective_start_date_time AND dhn6.effective_end_date_time
		LEFT JOIN
			conformed.dim_hierarchy_node dhn7 ON dhn6.dim_hierarchy_node_id = dhn7.parent_dim_hierarchy_node_id
											AND GETDATE() BETWEEN dhn7.effective_start_date_time AND dhn7.effective_end_date_time
		LEFT JOIN
			conformed.dim_hierarchy_node dhn8 ON dhn7.dim_hierarchy_node_id = dhn8.parent_dim_hierarchy_node_id
											AND GETDATE() BETWEEN dhn8.effective_start_date_time AND dhn8.effective_end_date_time
		LEFT JOIN
			conformed.dim_hierarchy_node dhn9 ON dhn8.dim_hierarchy_node_id = dhn9.parent_dim_hierarchy_node_id
											AND GETDATE() BETWEEN dhn9.effective_start_date_time AND dhn9.effective_end_date_time
		LEFT JOIN
			conformed.dim_hierarchy_node dhn10 ON dhn9.dim_hierarchy_node_id = dhn10.parent_dim_hierarchy_node_id
											AND GETDATE() BETWEEN dhn10.effective_start_date_time AND dhn10.effective_end_date_time
		)ON COALESCE(	dhn10.dim_hierarchy_node_id
				,dhn9.dim_hierarchy_node_id
				,dhn8.dim_hierarchy_node_id
				,dhn7.dim_hierarchy_node_id
				,dhn6.dim_hierarchy_node_id
				,dhn5.dim_hierarchy_node_id
				,dhn4.dim_hierarchy_node_id
				,dhn3.dim_hierarchy_node_id
				,dhn2.dim_hierarchy_node_id
				,dhn.dim_hierarchy_node_id
				) = bph.dim_hierarchy_node_id
				AND GETDATE() BETWEEN bph.effective_start_date_time AND bph.effective_end_date_time
	) ON dp.dim_product_id = bph.dim_product_id
WHERE
	GETDATE() BETWEEN dp.effective_start_date_time AND dp.effective_end_date_time;