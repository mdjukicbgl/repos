DROP VIEW IF EXISTS markdown_app.uv_dim_geography;

CREATE VIEW markdown_app.uv_dim_geography
  AS
SELECT
	dg.dim_geography_id
	,dg.dim_retailer_id
	,dg.geography_bkey
	,dg.geography_type_bkey
	,dg.effective_start_date_time
	,dg.effective_end_date_time
	,dg.geography_type
	,dg.geography_name
	,dg.city_name
	,dg.country_name
	,dg.region_name
	,dg.longitude_position
	,dg.latitude_position
	-- dynamic hiearchy attributes
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
	conformed.dim_geography dg
LEFT OUTER JOIN
	conformed.bridge_geography_hierarchy bgh ON dg.dim_geography_id = bgh.dim_geography_id
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
	) ON COALESCE(	dhn10.dim_hierarchy_node_id
				,dhn9.dim_hierarchy_node_id
				,dhn8.dim_hierarchy_node_id
				,dhn7.dim_hierarchy_node_id
				,dhn6.dim_hierarchy_node_id
				,dhn5.dim_hierarchy_node_id
				,dhn4.dim_hierarchy_node_id
				,dhn3.dim_hierarchy_node_id
				,dhn2.dim_hierarchy_node_id
				,dhn.dim_hierarchy_node_id
				) = bgh.dim_hierarchy_node_id
				AND GETDATE() BETWEEN bgh.effective_start_date_time AND bgh.effective_end_date_time
WHERE
	GETDATE() BETWEEN dg.effective_start_date_time AND dg.effective_end_date_time;