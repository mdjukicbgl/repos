--/* 
--** Redshift Compliant
--
--do $$
--begin
--*/

begin transaction;
  UPDATE  conformed.dim_channel
  SET     channel_name            = changed_channel.channel_name,
          channel_description     = changed_channel.channel_description,
          channel_code            = changed_channel.channel_code
  FROM    (
    SELECT  sc.dim_retailer_id,
            sc.channel_key,
            sc.channel_name,
            sc.channel_description,
            sc.channel_code
    FROM    stage.channel         sc
    JOIN    conformed.dim_channel dc  ON  sc.dim_retailer_id = dc.dim_retailer_id
                                      AND sc.channel_key = dc.channel_bkey
                                      AND ( sc.channel_name <> dc.channel_name
                                      OR    sc.channel_description <> dc.channel_description
                                      OR    sc.channel_code <> dc.channel_code )
    WHERE   sc.batch_id             = ##BATCH_ID##
     ) as changed_channel
  where   dim_channel.dim_retailer_id         = changed_channel.dim_retailer_id
  and     dim_channel.channel_bkey            = changed_channel.channel_key;

  INSERT
  INTO  conformed.dim_channel
  (     dim_retailer_id,
        channel_bkey,
        channel_name,
        channel_description,
        channel_code
  )
  SELECT  dim_retailer_id,
          channel_key,
          channel_name,
          channel_description,
          channel_code
  FROM    stage.channel sc
  WHERE   NOT EXISTS( SELECT  *
                      FROM    conformed.dim_channel   dc
                      WHERE   dc.dim_retailer_id = sc.dim_retailer_id
                      AND     dc.channel_bkey = sc.channel_key)
  AND     sc.batch_id   = ##BATCH_ID##;

select '
--/* 
--** Redshift Compliant
--
--  commit;
--
--EXCEPTION WHEN OTHERS THEN
--    ROLLBACK;
--
--    raise notice 'Transaction was rolled back';
--
--    raise notice '% %', SQLERRM, SQLSTATE;
--END;
--$$ language 'plpgsql';
--*/
' ;
