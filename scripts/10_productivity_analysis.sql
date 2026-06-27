/*
=============================================================
Productivity Analysis
=============================================================
Business Questions:
1. What is the average worker productivity?
2. Which production runs achieved the highest productivity?
3. Does higher productivity improve quality?
4. Does productivity reduce production cost?
5. Do safety incidents affect productivity?
=============================================================
*/

USE ManufacturingQualityIntelligence;
GO

--===========================================================
-- 1. Average Worker Productivity
--===========================================================

SELECT
    ROUND(AVG(WorkerProductivity),2) AS AverageWorkerProductivity
FROM manufacturing.fact_manufacturing;

GO

--===========================================================
-- 2. Top 10 Most Productive Production Runs
--===========================================================

SELECT TOP (10)

ManufacturingID,
WorkerProductivity,
ProductionVolume,
QualityScore

FROM manufacturing.fact_manufacturing

ORDER BY WorkerProductivity DESC;

GO

--===========================================================
-- 3. Productivity vs Quality Score
--===========================================================

SELECT

WorkerProductivity,

ROUND(AVG(QualityScore),2) AS AverageQualityScore

FROM manufacturing.fact_manufacturing

GROUP BY WorkerProductivity

ORDER BY WorkerProductivity DESC;

GO

--===========================================================
-- 4. Productivity vs Production Cost
--===========================================================

SELECT

WorkerProductivity,

ROUND(AVG(ProductionCost),2) AS AverageProductionCost

FROM manufacturing.fact_manufacturing

GROUP BY WorkerProductivity

ORDER BY WorkerProductivity DESC;

GO

--===========================================================
-- 5. Safety Incidents vs Productivity
--===========================================================

SELECT

SafetyIncidents,

ROUND(AVG(WorkerProductivity),2) AS AverageWorkerProductivity,

COUNT(*) AS ProductionRuns

FROM manufacturing.fact_manufacturing

GROUP BY SafetyIncidents

ORDER BY SafetyIncidents;

GO

--===========================================================
-- 6. Top 10 Highest Safety Incident Records
--===========================================================

SELECT TOP (10)

ManufacturingID,
SafetyIncidents,
WorkerProductivity,
ProductionCost,
QualityScore

FROM manufacturing.fact_manufacturing

ORDER BY SafetyIncidents DESC;

GO

--===========================================================
-- 7. Productivity Summary
--===========================================================

SELECT

MIN(WorkerProductivity) AS MinimumProductivity,

MAX(WorkerProductivity) AS MaximumProductivity,

ROUND(AVG(WorkerProductivity),2) AS AverageProductivity

FROM manufacturing.fact_manufacturing;

GO
