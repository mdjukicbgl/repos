

CREATE TABLE IF NOT EXISTS stage.status_dim ( 
	row_id               bigint identity NOT NULL ,
	batch_id             integer DEFAULT 1 NOT NULL ,
	status_type_bkey     varchar(20)  NOT NULL ,
	status_bkey          varchar(20)  NOT NULL ,
	parent_status_bkey   varchar(20)   ,
	status_type          varchar(50)  NOT NULL ,
	status_name          varchar(50)  NOT NULL ,
	parent_dim_status_id smallint   ,
	status_hierarchy_level smallint DEFAULT 0 NOT NULL ,
	status_breadcrumb    varchar(512) DEFAULT ''::character varying NOT NULL ,
	is_leaf_node         bool DEFAULT 0 NOT NULL 
 );



CREATE TABLE IF NOT EXISTS conformed.dim_status ( 
	batch_id             integer DEFAULT 1 NOT NULL ,
	dim_status_id        integer  NOT NULL ,
	status_type_bkey     varchar(20)  NOT NULL ,
	status_bkey          varchar(20)  NOT NULL ,
	parent_status_bkey   varchar(20)   ,
	status_type          varchar(50)  NOT NULL ,
	status_name          varchar(50)  NOT NULL ,
	parent_dim_status_id integer   ,
	status_hierarchy_level smallint DEFAULT 0 NOT NULL ,
	status_breadcrumb    varchar(512) DEFAULT ''::character varying NOT NULL ,
	is_leaf_node         bool DEFAULT 0 NOT NULL ,
	CONSTRAINT pk_dim_status PRIMARY KEY ( dim_status_id )
 )  COMPOUND SORTKEY (dim_status_id, status_type_bkey, parent_status_bkey, status_name, status_type, is_leaf_node, status_hierarchy_level, status_breadcrumb, batch_id);

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