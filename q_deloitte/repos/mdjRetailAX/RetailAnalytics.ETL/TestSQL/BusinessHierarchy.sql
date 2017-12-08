
select top 500
  '2017-05-30' + '|' +
    '1' + '|' +
  dh.hierarchy_name + '|' +
  dp.product_bkey + '||||' +
  'product' + '|' +
  substring(l1.hierarchy_node_bkey,1,20) + '|' +
  substring(l1.hierarchy_node_name,1,50) + '|' +
  substring(l2.hierarchy_node_bkey,1,20) + '|' +
  substring(l2.hierarchy_node_name,1,50) + '|' +
  substring(l3.hierarchy_node_bkey,1,20) + '|' +
  substring(l3.hierarchy_node_name,1,50) + '|' +
  substring(l4.hierarchy_node_bkey,1,20) + '|' +
  substring(l4.hierarchy_node_name,1,50) + '|' +
  substring(l5.hierarchy_node_bkey,1,20) + '|' +
  substring(l5.hierarchy_node_name,1,50) + '|' +
  substring(l6.hierarchy_node_bkey,1,20) + '|' +
  substring(l6.hierarchy_node_name,1,50) + '||||||'
from conformed.dim_hierarchy_node l7
  join conformed.dim_hierarchy_node l6 on l7.parent_dim_hierarchy_node_id = l6.dim_hierarchy_node_id
  join conformed.dim_hierarchy_node l5 on l6.parent_dim_hierarchy_node_id = l5.dim_hierarchy_node_id
  join conformed.dim_hierarchy_node l4 on l5.parent_dim_hierarchy_node_id = l4.dim_hierarchy_node_id
  join conformed.dim_hierarchy_node l3 on l4.parent_dim_hierarchy_node_id = l3.dim_hierarchy_node_id
  join conformed.dim_hierarchy_node l2 on l3.parent_dim_hierarchy_node_id = l2.dim_hierarchy_node_id
  join conformed.dim_hierarchy_node l1 on l2.parent_dim_hierarchy_node_id = l1.dim_hierarchy_node_id
  join conformed.bridge_product_hierarchy br on l7.dim_hierarchy_node_id = br.dim_hierarchy_node_id
  join conformed.dim_product dp on br.dim_product_id = dp.dim_product_id
  join conformed.dim_hierarchy dh on l7.dim_hierarchy_id = dh.dim_hierarchy_id

