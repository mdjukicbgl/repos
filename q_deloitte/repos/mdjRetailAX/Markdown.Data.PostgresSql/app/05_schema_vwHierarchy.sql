create or replace view hierarchy
  as
SELECT  hierarchy_id,
        parent_id,
        depth,
        name,
        path
FROM dblink('datawarehouse',$REDSHIFT$
SELECT
       dim_hierarchy_node_id as hierarchy_id,
       parent_dim_hierarchy_node_id as parent_id,
       hierarchy_node_level as depth,
       hierarchy_node_name as name,
       hierarchy_breadcrumb_node_id as path
FROM
       markdown_app.uv_dim_hierarchy_node dh
LEFT OUTER JOIN  ((SELECT MAX(hierarchy_node_level) as MaxNode, dim_hierarchy_id FROM markdown_app.uv_dim_hierarchy_node GROUP BY dim_hierarchy_id)) MN
              ON MN.dim_hierarchy_id = dh.dim_hierarchy_id
WHERE
        dh.dim_hierarchy_id = 3 --Currently pulling in a specific hierarchy
       AND effective_end_date_time = '2500-01-01 00:00:00' --Currently only pulling in the latest version of this type of hierarchy
       AND hierarchy_node_level != MN.MaxNode --Filter out the product level
;
$REDSHIFT$) AS hierarchy (hierarchy_id int,parent_id int, depth int, name varchar(128) , path varchar(128));

