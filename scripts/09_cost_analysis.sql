/*
=============================================================
Cost Analysis
=============================================================
Business Questions:
1. What is the total production cost?
2. What is the average production cost?
3. Which production runs are the most expensive?
4. Does maintenance increase production cost?
5. Does energy consumption affect production cost?
=============================================================
*/

USE ManufacturingQualityIntelligence;
GO

--===========================================================
-- 1. Total Production Cost
--===========================================================

SELECT
    SUM(ProductionCost) AS TotalProductionCost
FROM manufacturing.fact_manufacturing;

GO

--===========================================================
-- 2. Average Production Cost
--===========================================================

SELECT
    ROUND(AVG(ProductionCost),2) AS AverageProductionCost
FROM manufacturing.fact_manufacturing;

GO

--===========================================================
-- 3. Top 10 Most Expensive Production Runs
--===========================================================

SELECT TOP (10)

ManufacturingID,
ProductionCost,
ProductionVolume,
QualityScore

FROM manufacturing.fact_manufacturing

ORDER BY ProductionCost DESC;

GO

--===========================================================
-- 4. Average Production Cost by Maintenance Hours
--===========================================================

SELECT

MaintenanceHours,

ROUND(AVG(ProductionCost),2) AS AverageProductionCost

FROM manufacturing.fact_manufacturing

GROUP BY MaintenanceHours

ORDER BY MaintenanceHours;

GO

--===========================================================
-- 5. Average Production Cost by Energy Consumption
--===========================================================

SELECT

EnergyConsumption,

ROUND(AVG(ProductionCost),2) AS AverageProductionCost

FROM manufacturing.fact_manufacturing

GROUP BY EnergyConsumption

ORDER BY EnergyConsumption DESC;

GO

--===========================================================
-- 6. Highest Energy Consuming Production Runs
--===========================================================

SELECT TOP (10)

ManufacturingID,

EnergyConsumption,

ProductionCost,

EnergyEfficiency

FROM manufacturing.fact_manufacturing

ORDER BY EnergyConsumption DESC;

GO

--===========================================================
-- 7. Highest Material Cost Production Runs
--===========================================================

SELECT TOP (10)

ManufacturingID,

AdditiveMaterialCost,

ProductionCost,

ProductionVolume

FROM manufacturing.fact_manufacturing

ORDER BY AdditiveMaterialCost DESC;

GO

--===========================================================
-- 8. Cost Summary
--===========================================================

SELECT

MIN(ProductionCost) AS MinimumCost,

MAX(ProductionCost) AS MaximumCost,

ROUND(AVG(ProductionCost),2) AS AverageCost

FROM manufacturing.fact_manufacturing;

GO
