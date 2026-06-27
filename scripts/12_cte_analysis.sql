/*
=============================================================
CTE Analysis
=============================================================
Business Questions:
1. Which production runs cost more than average?
2. Which production runs have above-average quality?
3. Which production runs have above-average productivity?
4. Identify high-risk production runs.
5. Find the top 10 most efficient production runs.
=============================================================
*/

USE ManufacturingQualityIntelligence;
GO

--===========================================================
-- 1. Production Runs Costing Above Average
--===========================================================

WITH AvgCost AS
(
    SELECT AVG(ProductionCost) AS AvgProductionCost
    FROM manufacturing.fact_manufacturing
)

SELECT
    ManufacturingID,
    ProductionCost
FROM manufacturing.fact_manufacturing
WHERE ProductionCost >
(
    SELECT AvgProductionCost
    FROM AvgCost
);

GO

--===========================================================
-- 2. Production Runs with Above Average Quality
--===========================================================

WITH AvgQuality AS
(
    SELECT AVG(QualityScore) AS AvgQualityScore
    FROM manufacturing.fact_manufacturing
)

SELECT
    ManufacturingID,
    QualityScore
FROM manufacturing.fact_manufacturing
WHERE QualityScore >
(
    SELECT AvgQualityScore
    FROM AvgQuality
);

GO

--===========================================================
-- 3. Above Average Worker Productivity
--===========================================================

WITH AvgProductivity AS
(
    SELECT AVG(WorkerProductivity) AS AvgProductivity
    FROM manufacturing.fact_manufacturing
)

SELECT
    ManufacturingID,
    WorkerProductivity
FROM manufacturing.fact_manufacturing
WHERE WorkerProductivity >
(
    SELECT AvgProductivity
    FROM AvgProductivity
);

GO

--===========================================================
-- 4. High-Risk Production Runs
--===========================================================

WITH HighRisk AS
(
    SELECT
        ManufacturingID,
        DefectRate,
        DowntimePercentage,
        QualityScore
    FROM manufacturing.fact_manufacturing
    WHERE DefectRate > 5
      AND DowntimePercentage > 10
)

SELECT *
FROM HighRisk
ORDER BY DefectRate DESC;

GO

--===========================================================
-- 5. Top 10 Most Efficient Production Runs
--===========================================================

WITH EfficientProduction AS
(
    SELECT
        ManufacturingID,
        ProductionVolume,
        ProductionCost,
        EnergyEfficiency,
        QualityScore
    FROM manufacturing.fact_manufacturing
)

SELECT TOP (10)
    ManufacturingID,
    ProductionVolume,
    ProductionCost,
    EnergyEfficiency,
    QualityScore
FROM EfficientProduction
ORDER BY
    EnergyEfficiency DESC,
    QualityScore DESC;

GO
