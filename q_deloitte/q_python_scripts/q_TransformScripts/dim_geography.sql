--
--** Redshift Compliant
--DO $$
--BEGIN

  CREATE TEMP TABLE temp_geography
  ( dim_geography_id int8 ,
    dim_retailer_id int8 not null,
    geography_bkey varchar(20) not null,
    geography_type_bkey varchar(20) not null,
    geography_type varchar(20) not null,
    geography_name varchar(100) not null,
    city_name varchar(50),
    country_name varchar(50),
    region_name varchar(50),
    longitude_position varchar(50),
    latitude_position varchar(50),
    reporting_date timestamp,
    effective_end_date_time timestamp
  );

  --   Changed records
  INSERT
  INTO  temp_geography
  ( dim_geography_id,
    dim_retailer_id,
    geography_bkey,
    geography_type_bkey,
    geography_type,
    geography_name,
    city_name,
    country_name,
    region_name,
    longitude_position,
    latitude_position,
    reporting_date,
    effective_end_date_time
  )
  SELECT    dg.dim_geography_id,
            sg.dim_retailer_id,
            sg.geography_key                    AS geography_bkey,
            sg.geography_type_key               AS geography_type_bkey,
            CASE geography_type_bkey
              WHEN '1'
                THEN 'Depot'
              WHEN '2'
                THEN 'Store'
              ELSE 'Unknown'
            END                                 AS geography_type,
            sg.geographical_location_name       AS geography_name,
            sg.geographical_location_subregion  AS city_name,
            sg.geographical_location_country    AS country_name,
            sg.geographical_location_region     AS region_name,
            sg.longitude                        AS longitude_position,
            sg.latitude                         AS latitude_position,
            CAST(sg.reporting_date AS date),
            dg.effective_end_date_time
    FROM    stage.geography         sg
    JOIN    conformed.dim_geography dg  ON  sg.dim_retailer_id = dg.dim_retailer_id
                                        AND sg.geography_type_key = dg.geography_type_bkey
                                        AND sg.geography_key = dg.geography_bkey
                                        AND sg.reporting_date >= dg.effective_start_date_time
                                        AND sg.reporting_date <= dg.effective_end_date_time
                                        AND ( sg.geographical_location_name <> dg.geography_name
                                        OR    sg.geographical_location_subregion <> dg.city_name
                                        OR    sg.geographical_location_country <> dg.country_name
                                        OR    sg.geographical_location_region <> dg.region_name
                                        OR    sg.longitude <> dg.longitude_position
                                        OR    sg.latitude <> dg.latitude_position )
    WHERE   sg.batch_id    = ##BATCH_ID##;


BEGIN TRANSACTION;
  -- Close out the current record
  UPDATE  conformed.dim_geography
  SET     effective_end_date_time         = dateadd(sec, -1, tg.reporting_date)
  FROM    temp_geography                  tg
  WHERE   dim_geography.dim_geography_id  = tg.dim_geography_id;


  --   Insert new version
  INSERT
  INTO  conformed.dim_geography
  (     batch_id,
        dim_retailer_id,
        geography_bkey,
        geography_type_bkey,
        geography_type,
        geography_name,
        city_name,
        country_name,
        region_name,
        longitude_position,
        latitude_position,
        effective_start_date_time,
        effective_end_date_time
  )
  SELECT  ##BATCH_ID##,
          dim_retailer_id,
          geography_bkey,
          geography_type_bkey,
          geography_type,
          geography_name,
          city_name,
          country_name,
          region_name,
          longitude_position,
          latitude_position,
          reporting_date,
          '2500-01-01'
  FROM    temp_geography;


  INSERT
  INTO  conformed.dim_geography
  (     batch_id,
        dim_retailer_id,
        geography_bkey,
        geography_type_bkey,
        geography_type,
        geography_name,
        city_name,
        country_name,
        region_name,
        longitude_position,
        latitude_position,
        effective_start_date_time,
        effective_end_date_time
  )
  SELECT  ##BATCH_ID##,
          sg.dim_retailer_id,
          sg.geography_key                    as geography_bkey,
          sg.geography_type_key               as geography_type_bkey,
          case geography_type_bkey
            when '1'
              then 'Depot'
            when '2'
              then 'Store'
            else 'Unknown'
          end                                 AS geography_type,
          sg.geographical_location_name       as geography_name,
          sg.geographical_location_subregion  as city_name,
          sg.geographical_location_country    as country_name,
          sg.geographical_location_region     as region_name,
          sg.longitude                        as longitude_position,
          sg.latitude                         as latitude_position,
          cast(sg.reporting_date as date)     as effective_start_date_time,
          '2500-01-01'                        as effective_end_date_time
  FROM    stage.geography         sg
  WHERE   NOT EXISTS( SELECT  *
                      FROM    conformed.dim_geography   dg
                      WHERE   dg.dim_retailer_id        = sg.dim_retailer_id
                      AND     dg.geography_bkey         = sg.geography_key
                      AND     dg.geography_type_bkey    = sg.geography_type_key )
  AND     sb.batch_id   = ##BATCH_ID##;

  COMMIT;

--
--** Redshift Compliant
--EXCEPTION WHEN OTHERS THEN
--    ROLLBACK;
--
--    RAISE NOTICE 'Transaction was rolled back';
--
--    RAISE NOTICE '% %', SQLERRM, SQLSTATE;
--END;
--$$ language 'plpgsql';