SET NOCOUNT ON;

TRUNCATE TABLE Matt.dbo.ProductHierarchy

INSERT INTO Matt.dbo.ProductHierarchy (ProductId, HierarchyId)
SELECT 
	ProductId AS product_id, 
	MAX(HierarchyId) AS hierarchy_id 
FROM
(
	SELECT DISTINCT      
		A.ProductID,
		CAST(REPLACE(A.[HierarchyID],'L2-','2') AS INT) AS [HierarchyId]
	FROM (
		SELECT DISTINCT
			ProductId,
			[ClassId] AS [HierarchyID]
		FROM [history].[MeijerProductHierarchy_Client] 
		WHERE ClassId NOT LIKE '"%'
	) AS A
) AS R
WHERE ProductId IN (SELECT ProductName from Config.CompleteList) 
GROUP BY ProductId
ORDER BY ProductId
