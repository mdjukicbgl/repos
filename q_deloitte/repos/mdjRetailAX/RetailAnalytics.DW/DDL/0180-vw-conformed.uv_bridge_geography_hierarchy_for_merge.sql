DROP VIEW IF EXISTS conformed.uv_bridge_geography_hierarchy_for_merge;

CREATE VIEW conformed.uv_bridge_geography_hierarchy_for_merge
AS
SELECT
	 dh.dim_hierarchy_id
	,bphf.dim_hierarchy_node_id
	,bphf.dim_geography_id
	,bphf.effective_start_date_time
	,bphf.effective_end_date_time
	,bphf.batch_id
FROM
	conformed.dim_hierarchy dh
JOIN
	conformed.dim_hierarchy_node dhn ON dh.dim_hierarchy_id = dhn.dim_hierarchy_id
JOIN
	conformed.bridge_geography_hierarchy bphf ON dhn.dim_hierarchy_node_id = bphf.dim_hierarchy_node_id;
