
    -------------------------------------------------------------------------
    --  Add Hierarchy to DimHierarchy
    -------------------------------------------------------------------------
    INSERT
    INTO    conformed.dim_hierarchy
    (
        batch_id,
        dim_retailer_id,
        hierarchy_name
    )
    SELECT DISTINCT 
            ##BATCH_ID##,
            dim_retailer_id,
            hierarchy_name
    FROM    stage.business_hierarchy_dim        bh1
    WHERE   NOT EXISTS (
                SELECT  *
                FROM    conformed.dim_hierarchy bh2
                WHERE   bh1.dim_retailer_id     = bh2.dim_retailer_id
                AND     bh1.hierarchy_name      = bh2.hierarchy_name
                AND     bh1.batch_id            = bh2.batch_id
    )
    AND     bh1.batch_id    = ##BATCH_ID##;

    -------------------------------------------------------------------------
    --  Store the hierarchy data
    -------------------------------------------------------------------------
    CREATE TEMP TABLE hierarchy_data
    (       business_date       date,
            dim_retailer_id     int,
            dim_hierarchy_id    int
    );

    INSERT
    INTO    hierarchy_data
    (       business_date,
            dim_retailer_id,
            dim_hierarchy_id
    )
    SELECT  DISTINCT cast( bh.reporting_date as date ),
            bh.dim_retailer_id,
            dh.dim_hierarchy_id
    FROM    stage.business_hierarchy_dim    bh
    JOIN    conformed.dim_hierarchy     dh  ON  bh.dim_retailer_id = dh.dim_retailer_id
                                            AND bh.hierarchy_name = dh.hierarchy_name
                                            AND bh.batch_id = ##BATCH_ID##;

    -------------------------------------------------------------------------
    -- Unpivot the stage table
    -------------------------------------------------------------------------
    -- Unpivot bkey
    CREATE TEMP TABLE bkey_unpivot
    (
        business_key                    varchar(255),
        hierarchy_node_bkey             varchar(50),
        hierarchy_level_description     varchar(128),
        hierarchy_level                 numeric(10,0)
    );

    INSERT
    INTO    bkey_unpivot
    (       business_key,
            hierarchy_node_bkey,
            hierarchy_level_description,
            hierarchy_level
    )
    SELECT  business_key1 + '|' + isnull(business_key2,'') + '|' + isnull(business_key3,'') + '|' + isnull(business_key4,''),
            node_id_level1          as hierarchy_node_bkey,
            'hierarchy_level1_bkey' as hierarchy_level_description,
            1                       as hierarchy_level
    FROM    stage.business_hierarchy_dim
    WHERE   node_id_level1  is not null
    AND     node_id_level1  <> ''
    AND     batch_id        = ##BATCH_ID##
    UNION ALL
    SELECT  business_key1 + '|' + isnull(business_key2,'') + '|' + isnull(business_key3,'') + '|' + isnull(business_key4,''),
            node_id_level2          as hierarchy_node_bkey,
            'hierarchy_level2_bkey' as hierarchy_level_description,
            2                       as hierarchy_level
    FROM    stage.business_hierarchy_dim
    WHERE   node_id_level2  is not null
    AND     node_id_level2  <> ''
    AND     batch_id        = ##BATCH_ID##
    UNION ALL
    SELECT  business_key1 + '|' + isnull(business_key2,'') + '|' + isnull(business_key3,'') + '|' + isnull(business_key4,''),
            node_id_level3          as hierarchy_node_bkey,
            'hierarchy_level3_bkey' as hierarchy_level_description,
            3                       as hierarchy_level
    FROM    stage.business_hierarchy_dim
    WHERE   node_id_level3  is not null
    AND     node_id_level3  <> ''
    AND     batch_id        = ##BATCH_ID##
    UNION ALL
    SELECT  business_key1 + '|' + isnull(business_key2,'') + '|' + isnull(business_key3,'') + '|' + isnull(business_key4,''),
            node_id_level4          as hierarchy_node_bkey,
            'hierarchy_level4_bkey' as hierarchy_level_description,
            4                       as hierarchy_level
    FROM    stage.business_hierarchy_dim
    WHERE   node_id_level4  is not null
    AND     node_id_level4  <> ''
    AND     batch_id        = ##BATCH_ID##
    UNION ALL
    SELECT  business_key1 + '|' + isnull(business_key2,'') + '|' + isnull(business_key3,'') + '|' + isnull(business_key4,''),
            node_id_level5          as hierarchy_node_bkey,
            'hierarchy_level5_bkey' as hierarchy_level_description,
            5                       as hierarchy_level
    FROM    stage.business_hierarchy_dim
    WHERE   node_id_level5  is not null
    AND     node_id_level5  <> ''
    AND     batch_id        = ##BATCH_ID##
    UNION ALL
    SELECT  business_key1 + '|' + isnull(business_key2,'') + '|' + isnull(business_key3,'') + '|' + isnull(business_key4,''),
            node_id_level6          as hierarchy_node_bkey,
            'hierarchy_level6_bkey' as hierarchy_level_description,
            6                       as hierarchy_level
    FROM    stage.business_hierarchy_dim
    WHERE   node_id_level6  is not null
    AND     node_id_level6  <> ''
    AND     batch_id        = ##BATCH_ID##
    UNION ALL
    SELECT  business_key1 + '|' + isnull(business_key2,'') + '|' + isnull(business_key3,'') + '|' + isnull(business_key4,''),
            node_id_level7          as hierarchy_node_bkey,
            'hierarchy_level7_bkey' as hierarchy_level_description,
            7                       as hierarchy_level
    FROM    stage.business_hierarchy_dim
    WHERE   node_id_level7  is not null
    AND     node_id_level7  <> ''
    AND     batch_id        = ##BATCH_ID##
    UNION ALL
    SELECT  business_key1 + '|' + isnull(business_key2,'') + '|' + isnull(business_key3,'') + '|' + isnull(business_key4,''),
            node_id_level8          as hierarchy_node_bkey,
            'hierarchy_level8_bkey' as hierarchy_level_description,
            8                       as hierarchy_level
    FROM    stage.business_hierarchy_dim
    WHERE   node_id_level8  is not null
    AND     node_id_level8  <> ''
    AND     batch_id        = ##BATCH_ID##
    UNION ALL
    SELECT  business_key1 + '|' + isnull(business_key2,'') + '|' + isnull(business_key3,'') + '|' + isnull(business_key4,''),
            node_id_level9          as hierarchy_node_bkey,
            'hierarchy_level9_bkey' as hierarchy_level_description,
            9                       as hierarchy_level
    FROM    stage.business_hierarchy_dim
    WHERE   node_id_level9  is not null
    AND     node_id_level9  <> ''
    AND     batch_id        = ##BATCH_ID##;


    -- Unpivot node
    CREATE TEMP TABLE node_name_unpivot
    (
        business_key                    varchar(255),
        hierarchy_node_name             varchar(50),
        hierarchy_level_description2    varchar(128),
        hierarchy_level                 numeric(10,0)
    );

    INSERT
    INTO    node_name_unpivot
    (       business_key,
            hierarchy_node_name,
            hierarchy_level_description2,
            hierarchy_level
    )
    SELECT  business_key1 + '|' + isnull(business_key2,'') + '|' + isnull(business_key3,'') + '|' + isnull(business_key4,''),
            node_name_level1                as hierarchy_node_name,
            'hierarchy_level1'              as hierarchy_level_description2,
            1                               as hierarchy_level
    FROM    stage.business_hierarchy_dim
    WHERE   node_name_level1    <> ''
    AND     node_name_level1    is not null
    AND     batch_id            = ##BATCH_ID##
    UNION
    SELECT  business_key1 + '|' + isnull(business_key2,'') + '|' + isnull(business_key3,'') + '|' + isnull(business_key4,''),
            node_name_level2                as hierarchy_node_name,
            'hierarchy_level2'              as hierarchy_level_description2,
            2                               as hierarchy_level
    FROM    stage.business_hierarchy_dim
    WHERE   node_name_level2    <> ''
    AND     node_name_level2    is not null
    AND     batch_id            = ##BATCH_ID##
    UNION
    SELECT  business_key1 + '|' + isnull(business_key2,'') + '|' + isnull(business_key3,'') + '|' + isnull(business_key4,''),
            node_name_level3                as hierarchy_node_name,
            'hierarchy_level3'              as hierarchy_level_description2,
            3                               as hierarchy_level
    FROM    stage.business_hierarchy_dim
    WHERE   node_name_level3    <> ''
    AND     node_name_level3    is not null
    AND     batch_id            = ##BATCH_ID##
    UNION
    SELECT  business_key1 + '|' + isnull(business_key2,'') + '|' + isnull(business_key3,'') + '|' + isnull(business_key4,''),
            node_name_level4                as hierarchy_node_name,
            'hierarchy_level4'              as hierarchy_level_description2,
            4                               as hierarchy_level
    FROM    stage.business_hierarchy_dim
    WHERE   node_name_level4    <> ''
    AND     node_name_level4    is not null
    AND     batch_id            = ##BATCH_ID##
    UNION
    SELECT  business_key1 + '|' + isnull(business_key2,'') + '|' + isnull(business_key3,'') + '|' + isnull(business_key4,''),
            node_name_level5                as hierarchy_node_name,
            'hierarchy_level5'              as hierarchy_level_description2,
            5                               as hierarchy_level
    FROM    stage.business_hierarchy_dim
    WHERE   node_name_level5    <> ''
    AND     node_name_level5    is not null
    AND     batch_id            = ##BATCH_ID##
    UNION
    SELECT  business_key1 + '|' + isnull(business_key2,'') + '|' + isnull(business_key3,'') + '|' + isnull(business_key4,''),
            node_name_level6                as hierarchy_node_name,
            'hierarchy_level6'              as hierarchy_level_description2,
            6                               as hierarchy_level
    FROM    stage.business_hierarchy_dim
    WHERE   node_name_level6    <> ''
    AND     node_name_level6    is not null
    AND     batch_id            = ##BATCH_ID##
    UNION
    SELECT  business_key1 + '|' + isnull(business_key2,'') + '|' + isnull(business_key3,'') + '|' + isnull(business_key4,''),
            node_name_level7                as hierarchy_node_name,
            'hierarchy_level7'              as hierarchy_level_description2,
            7                               as hierarchy_level
    FROM    stage.business_hierarchy_dim
    WHERE   node_name_level7    <> ''
    AND     node_name_level7    is not null
    AND     batch_id            = ##BATCH_ID##
    UNION
    SELECT  business_key1 + '|' + isnull(business_key2,'') + '|' + isnull(business_key3,'') + '|' + isnull(business_key4,''),
            node_name_level8                as hierarchy_node_name,
            'hierarchy_level8'              as hierarchy_level_description2,
            8                               as hierarchy_level
    FROM    stage.business_hierarchy_dim
    WHERE   node_name_level8    <> ''
    AND     node_name_level8    is not null
    AND     batch_id            = ##BATCH_ID##
    UNION
    SELECT  business_key1 + '|' + isnull(business_key2,'') + '|' + isnull(business_key3,'') + '|' + isnull(business_key4,''),
            node_name_level9                as hierarchy_node_name,
            'hierarchy_level9'              as hierarchy_level_description2,
            9                               as hierarchy_level
    FROM    stage.business_hierarchy_dim
    WHERE   node_name_level9    <> ''
    AND     node_name_level9    is not null
    AND     batch_id            = ##BATCH_ID##
    ;


    -- Repopulate staging table
    TRUNCATE TABLE stage.hierarchy_unpivoted;

    INSERT
    INTO    stage.hierarchy_unpivoted
    (       business_key
            ,hierarchy_node_b_key
            ,hierarchy_node_name
            ,hierarchy_level_description
            ,hierarchy_level
    )
    SELECT  ISNULL(bu.business_key,nnu.business_key) AS business_key
            ,bu.hierarchy_node_bkey
            ,nnu.hierarchy_node_name
            ,bu.hierarchy_level_description 
            ,ISNULL(bu.hierarchy_level,nnu.hierarchy_level) AS hierarchy_level
    FROM    bkey_unpivot        bu
    FULL OUTER JOIN
            node_name_unpivot   nnu ON bu.business_key = nnu.business_key
                                    AND bu.hierarchy_level = nnu.hierarchy_level;

    DROP TABLE  bkey_unpivot;
    DROP TABLE  node_name_unpivot;


    -------------------------------------------------------------------------
    -- Populate stage.node
    -------------------------------------------------------------------------
    TRUNCATE TABLE stage.node;

    INSERT 
    INTO stage.node
    (
        hierarchy_node_b_key
        ,hierarchy_node_name
        ,hierarchy_node_level
    )
    WITH list
    AS  (
        SELECT
            hu.business_key
            ,ISNULL(hu.hierarchy_node_b_key,hu.hierarchy_node_name) AS hierarchy_node_b_key
            ,hu.hierarchy_node_name
            ,hu.hierarchy_level
        FROM
            stage.hierarchy_unpivoted hu
        )
    SELECT 
         hierarchy_node_b_key
        ,hierarchy_node_name
        ,MIN(hierarchy_level) AS hierarchy_level
    FROM
        list
    GROUP BY
        hierarchy_node_b_key
        ,hierarchy_node_name;


    -------------------------------------------------------------------------
    -- Populate stage.hierarchy_relationship
    -------------------------------------------------------------------------
    TRUNCATE TABLE stage.hierarchy_relationship;

    INSERT INTO stage.hierarchy_relationship
            (
                parent_hierarchy_node_id
                ,child_hierarchy_node_id
                ,hierarchy_node_level
                ,business_key
            )
    WITH all_list
    AS  (   
        SELECT
             hn.hierarchy_node_id
            ,hn.hierarchy_node_b_key
            ,hn.hierarchy_node_name
            ,hn.hierarchy_node_level AS hierarchy_level
            ,u.business_key
        FROM
            stage.uv_dedup_node hn
        JOIN
            stage.hierarchy_unpivoted u ON hn.hierarchy_node_b_key = ISNULL(u.hierarchy_node_b_key,u.hierarchy_node_name)
                                    AND hn.hierarchy_node_level = u.hierarchy_level
        )
    ,list
    AS  (
        SELECT 
             p.hierarchy_node_id AS Parent_hierarchy_node_id
            ,c.hierarchy_node_id AS Child_hierarchy_node_id
            ,c.hierarchy_level AS hierarchy_node_level
            ,c.business_key
            ,c.hierarchy_node_name
        FROM
            all_list c
        LEFT OUTER JOIN
            all_list p ON p.business_key = c.business_key
                    AND p.hierarchy_level = c.hierarchy_level - 1
        )
    SELECT
         parent_hierarchy_node_id
        ,child_hierarchy_node_id
        ,hierarchy_node_level
        ,business_key
    FROM
        list
    ORDER BY
        business_key,
        hierarchy_node_level,
        child_hierarchy_node_id;


    -------------------------------------------------------------------------
    --  Update column IsBroken in table hierarchy_relationship
    -------------------------------------------------------------------------
    UPDATE stage.hierarchy_relationship
    SET is_broken = 1
    FROM
        stage.hierarchy_relationship hr2
    WHERE
        business_key = hr2.business_key
    AND
        EXISTS  (
                SELECT 1
                FROM
                    stage.uv_multiple_parent mp
                WHERE
                    hr2.child_hierarchy_node_id = mp.child_hierarchy_node_id
                );


    -------------------------------------------------------------------------
    -- Push the data to the dim table
    -------------------------------------------------------------------------
    DELETE  conformed.dim_hierarchy_node
    FROM    conformed.dim_hierarchy     dh
    JOIN    (   SELECT  distinct
                        dim_retailer_id,
                        hierarchy_name
                FROM    stage.business_hierarchy_dim
                WHERE   batch_id        = ##BATCH_ID## )           re  ON dh.dim_retailer_id = re.dim_retailer_id
                                                                       AND re.hierarchy_name = dh.hierarchy_name
    WHERE   dh.dim_hierarchy_id         = dim_hierarchy_node.dim_hierarchy_id;


    INSERT
    INTO    conformed.dim_hierarchy_node
    (
            batch_id,
            dim_hierarchy_id,
            hierarchy_node_bkey,
            parent_hierarchy_node_bkey,
            hierarchy_node_name,
            hierarchy_node_level,
            hierarchy_breadcrumb_node_name,
            hierarchy_breadcrumb_node_id,
            is_leaf_node
    )
    WITH
    cteRetailer
    AS  (   SELECT  distinct
                    bh.dim_retailer_id,
                    dh.dim_hierarchy_id
            FROM    stage.business_hierarchy_dim    bh
            JOIN    conformed.dim_hierarchy     dh  on bh.dim_retailer_id = dh.dim_retailer_id
                                                    AND bh.hierarchy_name = dh.hierarchy_name
            WHERE   bh.batch_id             = ##BATCH_ID##
    )
    SELECT  DISTINCT
            ##BATCH_ID##,
            re.dim_hierarchy_id,
            hn.hierarchy_node_bkey,
            hn.parent_hierarchy_node_bkey,
            hn.hierarchy_node_name,
            hu.hierarchy_level,
            '',
            '',
            0
    FROM    stage.hierarchy_unpivoted       hu
    JOIN    stage.hierarchy_node            hn  on  hn.hierarchy_node_bkey = hu.hierarchy_node_b_key
    CROSS JOIN    cteRetailer               re;


    -- Populate parent id
    UPDATE  conformed.dim_hierarchy_node
    SET     parent_dim_hierarchy_node_id    = par.dim_hierarchy_node_id
    FROM    conformed.dim_hierarchy_node    par
    WHERE   parent_hierarchy_node_bkey
                                            = par.hierarchy_node_bkey
    AND     batch_id                        = ##BATCH_ID##;

    -------------------------------------------------------------------------
    --  Set up hierarchy_node_list
    -------------------------------------------------------------------------
    CREATE TEMP TABLE hierarchy_node_list
    (   dim_hierarchy_node_id   int8,
        hierarchy_breadcrumb_node_name varchar(1024),
        hierarchy_breadcrumb_node_id varchar(256)
    );

    -------------------------------------------------------------------------
    --  Build the breadcrumbs (without recursion!)
    -------------------------------------------------------------------------
    INSERT
    INTO    hierarchy_node_list
    (       dim_hierarchy_node_id, hierarchy_breadcrumb_node_name, hierarchy_breadcrumb_node_id )
    SELECT  chi.dim_hierarchy_node_id,
            par.hierarchy_node_name + ' - ' + chi.hierarchy_node_name,
            convert( varchar, par.hierarchy_breadcrumb_node_id ) + convert( varchar, chi.dim_hierarchy_node_id ) + ':'
    FROM    conformed.dim_hierarchy_node    chi
    JOIN    conformed.dim_hierarchy_node    par ON par.hierarchy_node_level = chi.hierarchy_node_level - 1
                                                AND par.hierarchy_node_bkey = chi.parent_hierarchy_node_bkey
                                                AND par.batch_id = chi.batch_id
                                                AND par.dim_hierarchy_id = chi.dim_hierarchy_id
    WHERE   chi.batch_id                = ##BATCH_ID##
    AND     chi.hierarchy_node_level    = 1;

    INSERT
    INTO    hierarchy_node_list
    (       dim_hierarchy_node_id, hierarchy_breadcrumb_node_name, hierarchy_breadcrumb_node_id)
    SELECT  chi.dim_hierarchy_node_id,
            hnl.hierarchy_breadcrumb_node_name + ' - ' + chi.hierarchy_node_name,
            hnl.hierarchy_breadcrumb_node_id + convert( varchar, chi.dim_hierarchy_node_id ) + ':'
    FROM    conformed.dim_hierarchy_node    chi
    JOIN    conformed.dim_hierarchy_node    par ON par.hierarchy_node_level = chi.hierarchy_node_level - 1
                                                AND par.hierarchy_node_bkey = chi.parent_hierarchy_node_bkey
                                                AND par.batch_id = chi.batch_id
                                                AND par.dim_hierarchy_id = chi.dim_hierarchy_id
    JOIN    hierarchy_node_list             hnl ON hnl.dim_hierarchy_node_id = par.dim_hierarchy_node_id
    WHERE   chi.batch_id                = ##BATCH_ID##
    AND     chi.hierarchy_node_level    = 2;

    INSERT
    INTO    hierarchy_node_list
    (       dim_hierarchy_node_id, hierarchy_breadcrumb_node_name, hierarchy_breadcrumb_node_id)
    SELECT  chi.dim_hierarchy_node_id,
            hnl.hierarchy_breadcrumb_node_name + ' - ' + chi.hierarchy_node_name,
            hnl.hierarchy_breadcrumb_node_id + convert( varchar, chi.dim_hierarchy_node_id ) + ':'
    FROM    conformed.dim_hierarchy_node    chi
    JOIN    conformed.dim_hierarchy_node    par ON par.hierarchy_node_level = chi.hierarchy_node_level - 1
                                                AND par.hierarchy_node_bkey = chi.parent_hierarchy_node_bkey
                                                AND par.batch_id = chi.batch_id
                                                AND par.dim_hierarchy_id = chi.dim_hierarchy_id
    JOIN    hierarchy_node_list             hnl ON hnl.dim_hierarchy_node_id = par.dim_hierarchy_node_id
    WHERE   chi.batch_id                = ##BATCH_ID##
    AND     chi.hierarchy_node_level    = 3;

    INSERT
    INTO    hierarchy_node_list
    (       dim_hierarchy_node_id, hierarchy_breadcrumb_node_name, hierarchy_breadcrumb_node_id)
    SELECT  chi.dim_hierarchy_node_id,
            hnl.hierarchy_breadcrumb_node_name + ' - ' + chi.hierarchy_node_name,
            hnl.hierarchy_breadcrumb_node_id + convert( varchar, chi.dim_hierarchy_node_id ) + ':'
    FROM    conformed.dim_hierarchy_node    chi
    JOIN    conformed.dim_hierarchy_node    par ON par.hierarchy_node_level = chi.hierarchy_node_level - 1
                                                AND par.hierarchy_node_bkey = chi.parent_hierarchy_node_bkey
                                                AND par.batch_id = chi.batch_id
                                                AND par.dim_hierarchy_id = chi.dim_hierarchy_id
    JOIN    hierarchy_node_list             hnl ON hnl.dim_hierarchy_node_id = par.dim_hierarchy_node_id
    WHERE   chi.batch_id                = ##BATCH_ID##
    AND     chi.hierarchy_node_level    = 4;

    INSERT
    INTO    hierarchy_node_list
    (       dim_hierarchy_node_id, hierarchy_breadcrumb_node_name, hierarchy_breadcrumb_node_id)
    SELECT  chi.dim_hierarchy_node_id,
            hnl.hierarchy_breadcrumb_node_name + ' - ' + chi.hierarchy_node_name,
            hnl.hierarchy_breadcrumb_node_id + convert( varchar, chi.dim_hierarchy_node_id ) + ':'
    FROM    conformed.dim_hierarchy_node    chi
    JOIN    conformed.dim_hierarchy_node    par ON par.hierarchy_node_level = chi.hierarchy_node_level - 1
                                                AND par.hierarchy_node_bkey = chi.parent_hierarchy_node_bkey
                                                AND par.batch_id = chi.batch_id
                                                AND par.dim_hierarchy_id = chi.dim_hierarchy_id
    JOIN    hierarchy_node_list             hnl ON hnl.dim_hierarchy_node_id = par.dim_hierarchy_node_id
    WHERE   chi.batch_id                = ##BATCH_ID##
    AND     chi.hierarchy_node_level    = 5;

    INSERT
    INTO    hierarchy_node_list
    (       dim_hierarchy_node_id, hierarchy_breadcrumb_node_name, hierarchy_breadcrumb_node_id)
    SELECT  chi.dim_hierarchy_node_id,
            hnl.hierarchy_breadcrumb_node_name + ' - ' + chi.hierarchy_node_name,
            hnl.hierarchy_breadcrumb_node_id + convert( varchar, chi.dim_hierarchy_node_id ) + ':'
    FROM    conformed.dim_hierarchy_node    chi
    JOIN    conformed.dim_hierarchy_node    par ON par.hierarchy_node_level = chi.hierarchy_node_level - 1
                                                AND par.hierarchy_node_bkey = chi.parent_hierarchy_node_bkey
                                                AND par.batch_id = chi.batch_id
                                                AND par.dim_hierarchy_id = chi.dim_hierarchy_id
    JOIN    hierarchy_node_list             hnl ON hnl.dim_hierarchy_node_id = par.dim_hierarchy_node_id
    WHERE   chi.batch_id                = ##BATCH_ID##
    AND     chi.hierarchy_node_level    = 6;

    INSERT
    INTO    hierarchy_node_list
    (       dim_hierarchy_node_id, hierarchy_breadcrumb_node_name, hierarchy_breadcrumb_node_id)
    SELECT  chi.dim_hierarchy_node_id,
            hnl.hierarchy_breadcrumb_node_name + ' - ' + chi.hierarchy_node_name,
            hnl.hierarchy_breadcrumb_node_id + convert( varchar, chi.dim_hierarchy_node_id ) + ':'
    FROM    conformed.dim_hierarchy_node    chi
    JOIN    conformed.dim_hierarchy_node    par ON par.hierarchy_node_level = chi.hierarchy_node_level - 1
                                                AND par.hierarchy_node_bkey = chi.parent_hierarchy_node_bkey
                                                AND par.batch_id = chi.batch_id
                                                AND par.dim_hierarchy_id = chi.dim_hierarchy_id
    JOIN    hierarchy_node_list             hnl ON hnl.dim_hierarchy_node_id = par.dim_hierarchy_node_id
    WHERE   chi.batch_id                = ##BATCH_ID##
    AND     chi.hierarchy_node_level    = 7;

    INSERT
    INTO    hierarchy_node_list
    (       dim_hierarchy_node_id, hierarchy_breadcrumb_node_name, hierarchy_breadcrumb_node_id)
    SELECT  chi.dim_hierarchy_node_id,
            hnl.hierarchy_breadcrumb_node_name + ' - ' + chi.hierarchy_node_name,
            hnl.hierarchy_breadcrumb_node_id + convert( varchar, chi.dim_hierarchy_node_id ) + ':'
    FROM    conformed.dim_hierarchy_node    chi
    JOIN    conformed.dim_hierarchy_node    par ON par.hierarchy_node_level = chi.hierarchy_node_level - 1
                                                AND par.hierarchy_node_bkey = chi.parent_hierarchy_node_bkey
                                                AND par.batch_id = chi.batch_id
                                                AND par.dim_hierarchy_id = chi.dim_hierarchy_id
    JOIN    hierarchy_node_list             hnl ON hnl.dim_hierarchy_node_id = par.dim_hierarchy_node_id
    WHERE   chi.batch_id                = ##BATCH_ID##
    AND     chi.hierarchy_node_level    = 8;

    INSERT
    INTO    hierarchy_node_list
    (       dim_hierarchy_node_id, hierarchy_breadcrumb_node_name, hierarchy_breadcrumb_node_id)
    SELECT  chi.dim_hierarchy_node_id,
            hnl.hierarchy_breadcrumb_node_name + ' - ' + chi.hierarchy_node_name,
            hnl.hierarchy_breadcrumb_node_id + convert( varchar, chi.dim_hierarchy_node_id ) + ':'
    FROM    conformed.dim_hierarchy_node    chi
    JOIN    conformed.dim_hierarchy_node    par ON par.hierarchy_node_level = chi.hierarchy_node_level - 1
                                                AND par.hierarchy_node_bkey = chi.parent_hierarchy_node_bkey
                                                AND par.batch_id = chi.batch_id
                                                AND par.dim_hierarchy_id = chi.dim_hierarchy_id
    JOIN    hierarchy_node_list             hnl ON hnl.dim_hierarchy_node_id = par.dim_hierarchy_node_id
    WHERE   chi.batch_id                = ##BATCH_ID##
    AND     chi.hierarchy_node_level    = 9;

    -------------------------------------------------------------------------
    --  Apply the breadcrumbs
    -------------------------------------------------------------------------
    UPDATE  conformed.dim_hierarchy_node
    SET     hierarchy_breadcrumb_node_name = hnl.hierarchy_breadcrumb_node_name,
            hierarchy_breadcrumb_node_id = hnl.hierarchy_breadcrumb_node_id
    FROM    hierarchy_node_list         hnl
    WHERE   hnl.dim_hierarchy_node_id   = dim_hierarchy_node.dim_hierarchy_node_id
    AND     dim_hierarchy_node.batch_id = ##BATCH_ID##;

    DROP TABLE hierarchy_node_list;

    -------------------------------------------------------------------------
    --  Build the bridge tables
    --  Product
    -------------------------------------------------------------------------
    CREATE TEMP TABLE product_link
    (   reporting_date          date,
        dim_hierarchy_id        int,
        dim_product_id          int,
        dim_hierarchy_node_id   int
    );

    INSERT
    INTO    product_link
    (       reporting_date,
            dim_hierarchy_id,
            dim_product_id,
            dim_hierarchy_node_id
    )
    WITH
    cteProduct
    AS  (   SELECT  DISTINCT business_key1 + '|' + isnull(business_key2,'') + '|' + isnull(business_key3,'') + '|' + isnull(business_key4,'') as business_key
            FROM    stage.business_hierarchy_dim
            WHERE   business_area = 'product'
            AND     batch_id = ##BATCH_ID##

    ),
    cteSource
    AS (    SELECT  pr.business_key,
                    MAX( hierarchy_node_level) AS hierarchy_node_level
            FROM    stage.hierarchy_relationship    hr
            JOIN    cteProduct                      pr  ON  hr.business_key = pr.business_key
            GROUP BY
                    pr.business_key
    ),
    cteNode
    AS (    SELECT  hr.business_key                AS product_key,
                    hr.child_hierarchy_node_id,
                    hr.hierarchy_node_level
            FROM    stage.hierarchy_relationship    hr
            JOIN    cteSource                       cs  ON  hr.business_key = cs.business_key
                                                        AND hr.hierarchy_node_level = cs.hierarchy_node_level
    )
    SELECT  --hd.reporting_date,
            hd.business_date,
            hd.dim_hierarchy_id,
            dp.dim_product_id,
            hn.dim_hierarchy_node_id
    FROM    cteNode                         cn
    JOIN    stage.node                      sn  ON  cn.child_hierarchy_node_id = sn.hierarchy_node_id
    CROSS JOIN
            hierarchy_data                  hd
    JOIN    conformed.dim_product           dp  ON  cn.product_key = dp.product_bkey
                                                AND hd.dim_retailer_id = dp.dim_retailer_id
    JOIN    conformed.dim_hierarchy_node    hn  ON  sn.hierarchy_node_b_key = hn.hierarchy_node_bkey
                                                AND cn.hierarchy_node_level = hn.hierarchy_node_level
                                                AND hd.dim_hierarchy_id = hn.dim_hierarchy_id;


    BEGIN TRANSACTION;
        UPDATE  conformed.bridge_product_hierarchy
        SET     effective_end_date_time     = dateadd(sec, -1, pl.reporting_date)
        FROM    product_link                pl  
        WHERE   bridge_product_hierarchy.dim_product_id = pl.dim_product_id
        AND     bridge_product_hierarchy.effective_start_date_time  <= pl.reporting_date
        AND     bridge_product_hierarchy.effective_end_date_time    >= pl.reporting_date;
        
        INSERT
        INTO    conformed.bridge_product_hierarchy
        (       batch_id,
                dim_product_id,
                dim_hierarchy_node_id,
                effective_start_date_time,
                effective_end_date_time
        )
        SELECT  ##BATCH_ID##,
                pl.dim_product_id,
                pl.dim_hierarchy_node_id,
                pl.reporting_date,
                '2500-01-01'
        FROM    product_link                pl
        WHERE NOT EXISTS(   SELECT  *
                            FROM    conformed.bridge_product_hierarchy  ph
                            WHERE   ph.dim_product_id           = pl.dim_product_id
                            AND     ph.dim_hierarchy_node_id    = pl.dim_hierarchy_node_id );

    COMMIT;

    DROP TABLE product_link;

    -------------------------------------------------------------------------
    --  Geography
    -------------------------------------------------------------------------
    CREATE TEMP TABLE geography_link
    (   reporting_date          date,
        dim_hierarchy_id        int,
        dim_geography_id          int,
        dim_hierarchy_node_id   int
    );

    INSERT
    INTO    geography_link
    (       reporting_date,
            dim_hierarchy_id,
            dim_geography_id,
            dim_hierarchy_node_id
    )
    WITH
    cteGeography
    AS  (   SELECT  DISTINCT business_key1 + '|' + isnull(business_key2,'') + '|' + isnull(business_key3,'') + '|' + isnull(business_key4,'') as business_key
            FROM    stage.business_hierarchy_dim
            WHERE   business_area = 'geography'
            AND     batch_id = ##BATCH_ID##

    ),
    cteSource
    AS (    SELECT  pr.business_key,
                    MAX( hierarchy_node_level)      AS hierarchy_node_level
            FROM    stage.hierarchy_relationship    hr
            JOIN    cteGeography                    pr  ON  hr.business_key = pr.business_key
            GROUP BY
                    pr.business_key
    ),
    cteNode
    AS (    SELECT  hr.business_key                 AS geography_key,
                    hr.child_hierarchy_node_id,
                    hr.hierarchy_node_level
            FROM    stage.hierarchy_relationship    hr
            JOIN    cteSource                       cs  ON  hr.business_key = cs.business_key
                                                        AND hr.hierarchy_node_level = cs.hierarchy_node_level
    )
    SELECT  --hd.reporting_date,
            hd.business_date,
            hd.dim_hierarchy_id,
            dp.dim_geography_id,
            hn.dim_hierarchy_node_id
    FROM    cteNode                         cn
    JOIN    stage.node                      sn  ON  cn.child_hierarchy_node_id = sn.hierarchy_node_id
    CROSS JOIN
            hierarchy_data                  hd
    JOIN    conformed.dim_geography         dp  ON  cn.geography_key = dp.geography_bkey
                                                AND hd.dim_retailer_id = dp.dim_retailer_id
    JOIN    conformed.dim_hierarchy_node    hn  ON  sn.hierarchy_node_b_key = hn.hierarchy_node_bkey
                                                AND cn.hierarchy_node_level = hn.hierarchy_node_level
                                                AND hd.dim_hierarchy_id = hn.dim_hierarchy_id;


    BEGIN TRANSACTION;
        UPDATE  conformed.bridge_geography_hierarchy
        SET     effective_end_date_time     = dateadd(sec, -1, pl.reporting_date)
        FROM    geography_link              pl  
        WHERE   bridge_geography_hierarchy.dim_geography_id = pl.dim_geography_id
        AND     bridge_geography_hierarchy.effective_start_date_time  <= pl.reporting_date
        AND     bridge_geography_hierarchy.effective_end_date_time    >= pl.reporting_date;
        
        INSERT
        INTO    conformed.bridge_geography_hierarchy
        (       batch_id,
                dim_geography_id,
                dim_hierarchy_node_id,
                effective_start_date_time,
                effective_end_date_time
        )
        SELECT  ##BATCH_ID##,
                pl.dim_geography_id,
                pl.dim_hierarchy_node_id,
                pl.reporting_date,
                '2500-01-01'
        FROM    geography_link                pl
        WHERE NOT EXISTS(   SELECT  *
                            FROM    conformed.bridge_geography_hierarchy  ph
                            WHERE   ph.dim_geography_id         = pl.dim_geography_id
                            AND     ph.dim_hierarchy_node_id    = pl.dim_hierarchy_node_id );

    COMMIT;

    DROP TABLE geography_link;
    
    DROP TABLE hierarchy_data;
