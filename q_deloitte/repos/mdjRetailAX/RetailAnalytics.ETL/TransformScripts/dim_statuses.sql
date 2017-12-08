
BEGIN TRANSACTION;

DELETE  markdown.dim_price_status
WHERE   EXISTS( SELECT  *
                FROM    stage.statuses_dim
                WHERE   status_type_bkey    = 2
                AND     dim_retailer_id     = dim_price_status.dim_retailer_id
                AND     status_bkey         = dim_price_status.price_status_bkey
                AND     batch_id            = ##BATCH_ID## ) -- 2 = price status
;

INSERT
INTO    markdown.dim_price_status
(       batch_id,
        dim_retailer_id,
        price_status_bkey,
        price_status
)
SELECT  ##BATCH_ID##,
        dim_retailer_id,
        status_bkey,
        status_name
FROM    stage.statuses_dim      ss
WHERE   NOT EXISTS( SELECT  *
                    FROM    markdown.dim_price_status   ps
                    WHERE   ss.dim_retailer_id = ps.dim_retailer_id
                     )
AND     ss.batch_id         = ##BATCH_ID##
;
