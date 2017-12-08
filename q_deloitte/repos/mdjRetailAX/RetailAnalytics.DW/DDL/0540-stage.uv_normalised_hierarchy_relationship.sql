CREATE VIEW stage.uv_normalised_hierarchy_relationship
AS
SELECT
	hr.parent_hierarchy_node_id
	,hr.child_hierarchy_node_id
FROM
	Stage.hierarchy_relationship hr
WHERE
	hr.is_broken = 0
GROUP BY
	hr.parent_hierarchy_node_id
	,hr.child_hierarchy_node_id;