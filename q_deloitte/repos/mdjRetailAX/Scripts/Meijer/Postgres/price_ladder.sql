SET ANSI_WARNINGS OFF;
SET NOCOUNT ON;

SELECT 
	CAST(Country AS VARCHAR(1)) AS price_ladder_id,
	2 AS price_ladder_type_id,
	'Unnamed country price ladder (' + CAST(Country AS VARCHAR(1)) + ')' AS [description]
FROM 
	ref.DiscountLadder
GROUP BY
	Country