
  DROP TABLE IF EXISTS temp_geography;

  CREATE TEMP TABLE temp_geography
  (
      batch_id
    , dim_geography_id  
    , dim_retailer_id
    , reporting_date
    , reporting_date_period_type
    , location_bkey
    , location_type_bkey
    , location_type
    , location_name
    , location_description
    , location_subtype
    , location_status
    , city_town
    , county_state
    , country
    , region
    , subregion
    , longitude_position
    , latitude_position
    , trading_start_date
    , trading_end_date
    , default_cluster
    , building_floor_space
    , stock_allocation_grade
    , effective_end_date_time
)    
DISTKEY(dim_geography_id)
INTERLEAVED SORTKEY(dim_geography_id, dim_retailer_id, location_bkey, location_type_bkey, reporting_date)
AS
SELECT    
       ##BATCH_ID## as batch_id 
     , dg.dim_geography_id
     , sg.dim_retailer_id
     , sg.reporting_date
     , sg.reporting_date_period_type
     , sg.location_bkey
     , sg.location_type_bkey
     , CASE sg.location_type_bkey
         WHEN '1'
           THEN 'Depot'
         WHEN '2'
           THEN 'Store'
         ELSE 'Unknown'
       END                                 AS location_type
     , sg.location_name
     , sg.location_description
     , sg.location_subtype
     , sg.location_status
     , sg.city_town
     , sg.county_state
     , sg.country
     , sg.region
     , sg.subregion
     , sg.longitude_position
     , sg.latitude_position
     , sg.trading_start_date
     , sg.trading_end_date
     , sg.default_cluster
     , sg.building_floor_space
     , sg.stock_allocation_grade
     , dg.effective_end_date_time
    FROM    stage.geography_dim         sg
    JOIN    conformed.dim_geography dg  ON sg.dim_retailer_id               = dg.dim_retailer_id
                                       AND sg.location_type_bkey            = dg.location_type_bkey
                                       AND sg.location_bkey                 = dg.location_bkey
                                       AND CAST(sg.reporting_date AS date) >= dg.effective_start_date_time
                                       AND CAST(sg.reporting_date AS date) <= dg.effective_end_date_time
                                       AND ( 
                                             sg.location_name              <> dg.location_name
                                        OR   sg.location_description       <> dg.location_description
                                        OR   sg.location_subtype           <> dg.location_subtype
                                        OR   sg.location_status            <> dg.location_status
                                        OR   sg.city_town                  <> dg.city_town
                                        OR   sg.county_state               <> dg.county_state
                                        OR   sg.country                    <> dg.country
                                        OR   sg.region                     <> dg.region
                                        OR   sg.subregion                  <> dg.subregion
                                        OR   sg.longitude_position         <> dg.longitude_position
                                        OR   sg.latitude_position          <> dg.latitude_position
                                        OR   sg.trading_start_date         <> dg.trading_start_date
                                        OR   sg.trading_end_date           <> dg.trading_end_date
                                        OR   sg.default_cluster            <> dg.default_cluster
                                        OR   sg.building_floor_space       <> dg.building_floor_space
                                        OR   sg.stock_allocation_grade     <> dg.stock_allocation_grade 
                                         )
WHERE
        dg.effective_end_date_time = '2500-01-01'
;

---------------------------------------------------------------------------------------------------
-- Close out the current record.....
---------------------------------------------------------------------------------------------------

BEGIN TRANSACTION;

UPDATE conformed.dim_geography
   SET effective_end_date_time               = dateadd(sec, -1, tg.reporting_date)
  FROM temp_geography                        tg
 WHERE dim_geography.dim_geography_id        = tg.dim_geography_id
   AND dim_geography.effective_end_date_time = '2500-01-01'
  ;

---------------------------------------------------------------------------------------------------
-- Insert new version.....
---------------------------------------------------------------------------------------------------
  INSERT
  INTO  conformed.dim_geography
  (     
        batch_id
      , dim_geography_id
      , dim_retailer_id
      , location_bkey
      , location_type_bkey
      , effective_start_date_time
      , effective_end_date_time
      , location_type
      , location_name
      , location_description
      , location_subtype
      , location_status
      , city_town
      , county_state
      , country
      , region
      , subregion
      , longitude_position
      , latitude_position
      , trading_start_date
      , trading_end_date
      , default_cluster
      , building_floor_space
      , stock_allocation_grade
  )
  SELECT  
        ##BATCH_ID## AS batch_id
      , max_dim_geography_id + row_number() over () as dim_geography_id 
      , dim_retailer_id
      , location_bkey
      , location_type_bkey
      , CAST(reporting_date AS date) AS effective_start_date_time
      , '2500-01-01'                 AS effective_end_date_time
      , location_type
      , location_name
      , location_description
      , location_subtype
      , location_status
      , city_town
      , county_state
      , country
      , region
      , subregion
      , longitude_position
      , latitude_position
      , trading_start_date
      , trading_end_date
      , default_cluster
      , building_floor_space
      , stock_allocation_grade
  FROM    
        temp_geography
      , (select nvl(max(dim_geography_id), 0) as max_dim_geography_id from conformed.dim_geography) 
  ;

---------------------------------------------------------------------------------------------------
-- Insert new active record.....
---------------------------------------------------------------------------------------------------
  INSERT
  INTO  conformed.dim_geography
  (     
        batch_id
      , dim_geography_id
      , dim_retailer_id
      , location_bkey
      , location_type_bkey
      , effective_start_date_time
      , effective_end_date_time
      , location_type
      , location_name
      , location_description
      , location_subtype
      , location_status
      , city_town
      , county_state
      , country
      , region
      , subregion
      , longitude_position
      , latitude_position
      , trading_start_date
      , trading_end_date
      , default_cluster
      , building_floor_space
      , stock_allocation_grade
  )
  SELECT  
       ##BATCH_ID## as batch_id 
     , max_dim_geography_id + row_number() over () as dim_geography_id 
     , sg.dim_retailer_id
     , sg.location_bkey
     , sg.location_type_bkey
     , cast(sg.reporting_date as date)        AS effective_start_date_time
     , '2500-01-01'                           AS effective_end_date_time
     , CASE sg.location_type_bkey
         WHEN '1'
           THEN 'Depot'
         WHEN '2'
           THEN 'Store'
         ELSE 'Unknown'
       END                                    AS location_type
     , sg.location_name
     , sg.location_description
     , sg.location_subtype
     , sg.location_status
     , sg.city_town
     , sg.county_state
     , sg.country
     , sg.region
     , sg.subregion
     , sg.longitude_position
     , sg.latitude_position
     , sg.trading_start_date
     , sg.trading_end_date
     , sg.default_cluster
     , sg.building_floor_space
     , sg.stock_allocation_grade
  FROM stage.geography_dim         sg
     , (select nvl(max(dim_geography_id), 0) as max_dim_geography_id from conformed.dim_geography) 
  
  WHERE   NOT EXISTS( SELECT  1
                      FROM    conformed.dim_geography   dg
                      WHERE   dg.dim_retailer_id        = sg.dim_retailer_id
                      AND     dg.location_bkey          = sg.location_bkey
                      AND     dg.location_type_bkey     = sg.location_type_bkey )
;
