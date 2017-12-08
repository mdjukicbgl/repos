CREATE VIEW stage.uv_multiple_parent
AS
SELECT
	nhr.child_hierarchy_node_id
	,COUNT(nhr.parent_hierarchy_node_id) AS parent_count
FROM
	Stage.uv_normalised_hierarchy_relationship nhr
GROUP BY
	nhr.child_hierarchy_node_id
HAVING
	1<COUNT(nhr.parent_hierarchy_node_id);