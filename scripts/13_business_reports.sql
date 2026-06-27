/*
=============================================================
Business Reports
=============================================================
Purpose:
Generate executive reports for management to support
strategic manufacturing decisions.
=============================================================
*/

USE ManufacturingQualityIntelligence;
GO

--===========================================================
-- Report 1 : Executive Summary
--===========================================================

SELECT

COUNT(*) AS TotalProductionRuns,

SUM(ProductionVolume) AS TotalProductionVolume,

ROUND(AVG(ProductionCost),2) AS AverageProductionCost,

ROUND(AVG(QualityScore),2) AS AverageQualityScore,

ROUND(AVG(DefectRate),2) AS AverageDefectRate,

ROUND(AVG(WorkerProductivity),2) AS AverageWorkerProductivity

FROM manufacturing.fact_manufacturing;

GO

--===========================================================
-- Report 2 : Top 10 Highest Cost Production Runs
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
-- Report 3 : Top 10 Highest Quality Production Runs
--===========================================================

SELECT TOP (10)

ManufacturingID,

QualityScore,

DefectRate,

ProductionCost

FROM manufacturing.fact_manufacturing

ORDER BY QualityScore DESC;

GO

--===========================================================
-- Report 4 : Defect Status Summary
--===========================================================

SELECT

ds.DefectStatusName,

COUNT(*) AS TotalProductionRuns,

ROUND(AVG(f.DefectRate),2) AS AverageDefectRate,

ROUND(AVG(f.QualityScore),2) AS AverageQualityScore

FROM manufacturing.fact_manufacturing f

JOIN manufacturing.dim_defect_status ds

ON f.DefectStatusID = ds.DefectStatusID

GROUP BY ds.DefectStatusName;

GO

--===========================================================
-- Report 5 : Monthly Production Summary
--===========================================================

SELECT

d.YearNumber,

d.MonthName,

SUM(f.ProductionVolume) AS TotalProduction,

ROUND(AVG(f.ProductionCost),2) AS AverageProductionCost,

ROUND(AVG(f.QualityScore),2) AS AverageQualityScore

FROM manufacturing.fact_manufacturing f

JOIN manufacturing.dim_date d

ON f.DateID = d.DateID

GROUP BY

d.YearNumber,

d.MonthNumber,

d.MonthName

ORDER BY

d.YearNumber,

d.MonthNumber;

GO

--===========================================================
-- Report 6 : Top 10 Most Productive Runs
--===========================================================

SELECT TOP (10)

ManufacturingID,

WorkerProductivity,

ProductionVolume,

QualityScore,

ProductionCost

FROM manufacturing.fact_manufacturing

ORDER BY WorkerProductivity DESC;

GO

--===========================================================
-- Report 7 : Production Cost Distribution
--===========================================================

SELECT

CASE

WHEN ProductionCost < 3000 THEN 'Low Cost'

WHEN ProductionCost BETWEEN 3000 AND 6000 THEN 'Medium Cost'

ELSE 'High Cost'

END AS CostCategory,

COUNT(*) AS TotalRuns,

ROUND(AVG(QualityScore),2) AS AverageQualityScore

FROM manufacturing.fact_manufacturing

GROUP BY

CASE

WHEN ProductionCost < 3000 THEN 'Low Cost'

WHEN ProductionCost BETWEEN 3000 AND 6000 THEN 'Medium Cost'

ELSE 'High Cost'

END

ORDER BY TotalRuns DESC;

GO
