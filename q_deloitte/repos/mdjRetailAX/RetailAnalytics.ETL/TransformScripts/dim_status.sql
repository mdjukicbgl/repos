----------------------------------------------------------------------------------------------------------
-- update dim_status.....
----------------------------------------------------------------------------------------------------------
BEGIN TRANSACTION;

UPDATE
    conformed.dim_status
SET 
    batch_id               = changed_status.batch_id     
  , status_bkey            = changed_status.status_bkey         
  , parent_status_bkey     = changed_status.parent_status_bkey
  , status_type            = changed_status.status_type 
  , status_name            = changed_status.status_name
  , parent_dim_status_id   = changed_status.parent_dim_status_id
  , status_hierarchy_level = changed_status.status_hierarchy_level
  , status_breadcrumb      = changed_status.status_breadcrumb
  , is_leaf_node           = changed_status.is_leaf_node

FROM
    (
     SELECT
            ##BATCH_ID## as batch_id
          , sc.status_type_bkey     
          , sc.status_bkey          
          , sc.parent_status_bkey   
          , sc.status_type          
          , sc.status_name          
          , sc.parent_dim_status_id 
          , sc.status_hierarchy_level
          , sc.status_breadcrumb    
          , sc.is_leaf_node         
       FROM
            stage.status_dim sc
           JOIN
                conformed.dim_status dc
             ON
                sc.status_type_bkey = dc.status_type_bkey
            AND
                (
                       sc.status_bkey            <> dc.status_bkey           
                    OR sc.parent_status_bkey     <> dc.parent_status_bkey    
                    OR sc.status_type            <> dc.status_type           
                    OR sc.status_name            <> dc.status_name           
                    OR sc.parent_dim_status_id   <> dc.parent_dim_status_id  
                    OR sc.status_hierarchy_level <> dc.status_hierarchy_level
                    OR sc.status_breadcrumb      <> dc.status_breadcrumb     
                    OR sc.is_leaf_node           <> dc.is_leaf_node          
                )
    ) changed_status
WHERE
    dim_status.status_type_bkey = changed_status.status_type_bkey
;

----------------------------------------------------------------------------------------------------------
-- insert dim_status.....
----------------------------------------------------------------------------------------------------------
INSERT  INTO conformed.dim_status
  (
      batch_id
    , dim_status_id  
    , status_type_bkey     
    , status_bkey          
    , parent_status_bkey   
    , status_type          
    , status_name          
    , parent_dim_status_id 
    , status_hierarchy_level
    , status_breadcrumb    
    , is_leaf_node   
  )

SELECT
      ##BATCH_ID## as batch_id
    , max_dim_status_id + row_number() over () as dim_status_id  
    , status_type_bkey     
    , status_bkey          
    , parent_status_bkey   
    , status_type          
    , status_name          
    , parent_dim_status_id 
    , status_hierarchy_level
    , status_breadcrumb    
    , is_leaf_node  
FROM
     stage.status_dim sc
   , (select nvl(max(dim_status_id), 0) as max_dim_status_id from conformed.dim_status)     
WHERE
    NOT EXISTS
    (
     SELECT  1
       FROM
            conformed.dim_status dc
      WHERE
            dc.status_type_bkey = sc.status_type_bkey
    )
;