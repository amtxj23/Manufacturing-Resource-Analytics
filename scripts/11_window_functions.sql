/*
=============================================================
Window Functions Analysis
=============================================================
Business Questions:
1. Rank production runs by production cost.
2. Rank production runs by quality score.
3. Running total of production cost.
4. Compare each production run with the previous one.
5. Divide production runs into performance quartiles.
=============================================================
*/

USE ManufacturingQualityIntelligence;
GO

--===========================================================
-- 1. Rank Production Runs by Production Cost
--===========================================================

SELECT

ManufacturingID,

ProductionCost,

RANK() OVER
(
    ORDER BY ProductionCost DESC
) AS CostRank

FROM manufacturing.fact_manufacturing;

GO

--===========================================================
-- 2. Rank Production Runs by Quality Score
--===========================================================

SELECT

ManufacturingID,

QualityScore,

DENSE_RANK() OVER
(
    ORDER BY QualityScore DESC
) AS QualityRank

FROM manufacturing.fact_manufacturing;

GO

--===========================================================
-- 3. Running Total of Production Cost
--===========================================================

SELECT

ManufacturingID,

ProductionCost,

SUM(ProductionCost) OVER
(
    ORDER BY ManufacturingID
) AS RunningProductionCost

FROM manufacturing.fact_manufacturing;

GO

--===========================================================
-- 4. Compare Current Cost with Previous Production Run
--===========================================================

SELECT

ManufacturingID,

ProductionCost,

LAG(ProductionCost)
OVER
(
    ORDER BY ManufacturingID
) AS PreviousProductionCost,

ProductionCost -
LAG(ProductionCost)
OVER
(
    ORDER BY ManufacturingID
) AS CostDifference

FROM manufacturing.fact_manufacturing;

GO

--===========================================================
-- 5. Divide Production Runs into Four Performance Groups
--===========================================================

SELECT

ManufacturingID,

QualityScore,

NTILE(4)
OVER
(
    ORDER BY QualityScore DESC
) AS PerformanceQuartile

FROM manufacturing.fact_manufacturing;

GO

--===========================================================
-- 6. Top Performer in Each Defect Category
--===========================================================

SELECT *

FROM
(
    SELECT

    ManufacturingID,

    DefectStatusID,

    QualityScore,

    ROW_NUMBER() OVER
    (
        PARTITION BY DefectStatusID
        ORDER BY QualityScore DESC
    ) AS RowNum

    FROM manufacturing.fact_manufacturing

) AS RankedData

WHERE RowNum = 1;

GO
