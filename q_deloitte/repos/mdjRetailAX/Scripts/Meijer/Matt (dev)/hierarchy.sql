
SET NOCOUNT ON;

IF OBJECT_ID('tempdb..##temp_results') IS NOT NULL
	DROP TABLE ##temp_results
CREATE TABLE ##temp_results ([HierarchyId] NVARCHAR(10) NOT NULL, HierarchyName NVARCHAR(128) NOT NULL, ParentHierarchyId NVARCHAR(10) NOT NULL, ParentHierarchyName NVARCHAR(128))

IF OBJECT_ID('tempdb..##final_results') IS NOT NULL
	DROP TABLE ##final_results
CREATE TABLE ##final_results ([HierarchyId] NVARCHAR(10), ParentId NVARCHAR(10), Depth INT NOT NULL, [Name] NVARCHAR(128))

IF OBJECT_ID('tempdb..##correct_results') IS NOT NULL
	DROP TABLE ##correct_results
CREATE TABLE ##correct_results ([HierarchyId] NVARCHAR(10), ParentId NVARCHAR(10), Depth INT NOT NULL, [Name] NVARCHAR(128))

INSERT INTO ##temp_results
(
    [HierarchyId],
    HierarchyName,
    ParentHierarchyId,
    ParentHierarchyName
)
SELECT DISTINCT      
	[HierarchyID],
	HierarchyName,
	ParentId,
	ParentName
FROM (
	SELECT DISTINCT
		ClassId AS [HierarchyID],
		ClassName AS HierarchyName,
		SubCategoryId AS ParentId,
		SubCategoryName AS ParentName
    FROM [history].[MeijerProductHierarchy_Client] WHERE ClassId NOT LIKE '"%'
    UNION ALL
	SELECT DISTINCT
		SubCategoryId AS [HierarchyID],
		SubCategoryName AS HierarchyName,
		CategoryId AS ParentId,
		CategoryName AS ParentName
    FROM [history].[MeijerProductHierarchy_Client] WHERE ClassId NOT LIKE '"%'
    UNION ALL
	SELECT DISTINCT
        CategoryId AS [HierarchyID],
        CategoryName AS HierarchyName,
        BusinessSegmentId AS ParentId,
        BusinessSegmentName AS ParentName
	FROM [Meijer].[history].[MeijerProductHierarchy_Client] WHERE ClassId NOT LIKE '"%'
	UNION ALL
	SELECT DISTINCT
		BusinessSegmentId  as [HierarchyID],
		BusinessSegmentName as HierarchyName,
		MerchandiseAreaId as ParentId,
		MerchandiseAreaName as ParentName
	FROM [Meijer].[history].[MeijerProductHierarchy_Client] WHERE ClassId NOT LIKE '"%'
)  A

;WITH    
cte (ParentHierarchyId, [HierarchyId], [Level]) AS
( 
	SELECT DISTINCT ParentHierarchyId, [HierarchyId], 1 AS [Level] FROM ##temp_results
	UNION ALL
	SELECT cte.[HierarchyId] as ParentHierarchyId, S.HierarchyId, level + 1
	FROM ##temp_results s
	JOIN CTE ON CTE.HierarchyId = s.ParentHierarchyId
)
INSERT INTO ##correct_results ([HierarchyId], ParentId, Depth, [Name])
SELECT 
	cte.HierarchyId, 
	cte.ParentHierarchyId AS ParentId, 
	MAX(level) as Depth,
	CAST(RS.HierarchyName AS NVARCHAR(128)) AS [Name]
FROM cte
JOIN ##temp_results rs on rs.HierarchyId = cte.HierarchyId
GROUP BY cte.ParentHierarchyId, cte.HierarchyId, HierarchyName

INSERT INTO ##final_results ([HierarchyId], ParentId, Depth, [Name])
SELECT
	CAST(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE([HierarchyId],'L2-','2'),'L3-','3'),'L4-','4'),'L5-','5'),'L6-','6') AS INT) AS hierarchy_id, 
	NULLIF(COALESCE(CAST(MAX(Cast(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE([ParentId],'L2-','2'),'L3-','3'),'L4-','4'),'L5-','5'),'L6-','6') AS INT)) AS NVARCHAR(12)), ''), '') AS parent_id, 
	depth, 
	[name]
FROM (
	SELECT 
		HierarchyId,
		ParentId,
		Depth,
		[Name]
	FROM ##correct_results 
	UNION ALL
	SELECT
		fr.ParentId AS HierarchyId,
		NULL as ParentHierarchyId, 
		0 as Depth,
		tr.ParentHierarchyName
	FROM ##correct_results AS fr
	JOIN ##temp_results tr on tr.ParentHierarchyId = fr.ParentId
	WHERE fr.Depth = 1
) AS r
GROUP BY [HierarchyId], Depth, Name
ORDER BY Depth, HierarchyId

TRUNCATE TABLE Matt.dbo.Hierarchy
SET IDENTITY_INSERT Matt.dbo.Hierarchy ON
;WITH HierarchyCte (HierarchyId, ParentId, Depth, [Name], [Path]) AS (
	SELECT 
		HierarchyId, 
		ParentId, 
		0 AS Depth,
		Name,
		CAST(HierarchyId AS VARCHAR(Max)) + '.' AS Path
	FROM ##final_results h
	WHERE ParentId IS NULL
	UNION ALL
	SELECT 
		p.HierarchyId, 
		p.ParentId, 
		c.Depth + 1 AS Depth,
		p.Name,
		(c.Path + CAST(p.HierarchyId AS VARCHAR(Max)) + '.') AS Path
	FROM ##final_results p  
	JOIN HierarchyCte c ON c.HierarchyId = p.ParentId	
)
INSERT INTO Matt.dbo.Hierarchy (HierarchyId, ParentId, Depth, [Name], [Path])
SELECT 
	HierarchyId, 
	ParentId, 
	Depth, 
	[Name], 
	[Path]
FROM HierarchyCte
SET IDENTITY_INSERT Matt.dbo.Hierarchy OFF