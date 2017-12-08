CREATE VIEW stage.uv_dedup_node
AS
WITH dedup AS
	(
	SELECT
		n.hierarchy_node_b_key
		,CASE n.is_duplicate_bkey
			WHEN 0 THEN n.hierarchy_node_name
			ELSE 'Unknown Duplicate Name'
		END AS hierarchy_node_name
		,MIN(n.hierarchy_node_level) AS hierarchy_node_level
	FROM
		stage.node n
	GROUP BY
		n.hierarchy_node_b_key
		,CASE n.is_duplicate_bkey
			WHEN 0 THEN n.hierarchy_node_name
			ELSE 'Unknown Duplicate Name'
		END
	)
SELECT
	MIN(n.hierarchy_node_id) AS hierarchy_node_id
	,d.hierarchy_node_b_key
	,d.hierarchy_node_name
	,d.hierarchy_node_level
FROM
	Dedup d
INNER JOIN
	stage.node n ON d.hierarchy_node_b_key = n.hierarchy_node_b_key
					AND d.hierarchy_node_level = n.hierarchy_node_level
GROUP BY
	 d.hierarchy_node_b_key
	,d.hierarchy_node_name
	,d.hierarchy_node_level;