SET ANSI_WARNINGS OFF;
SET NOCOUNT ON;

SELECT 
	CAST(Country AS VARCHAR(1)) AS price_ladder_id,
	DENSE_RANK() OVER (PARTITION BY Country ORDER by Discount) AS [order],
	Discount AS [value]
FROM 
	ref.DiscountLadder