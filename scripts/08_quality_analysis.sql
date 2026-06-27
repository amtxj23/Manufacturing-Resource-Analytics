/*
=============================================================
Quality Analysis
=============================================================
Business Questions:
1. What is the average quality score?
2. Which production runs have the highest quality score?
3. Which production runs have the lowest quality score?
4. How does defect status affect quality score?
5. What is the average defect rate?
=============================================================
*/

USE ManufacturingQualityIntelligence;
GO

--===========================================================
-- 1. Average Quality Score
--===========================================================

SELECT
    ROUND(AVG(QualityScore),2) AS AverageQualityScore
FROM manufacturing.fact_manufacturing;

GO

--===========================================================
-- 2. Top 10 Highest Quality Production Runs
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
-- 3. Bottom 10 Quality Production Runs
--===========================================================

SELECT TOP (10)

ManufacturingID,
QualityScore,
DefectRate,
ProductionCost

FROM manufacturing.fact_manufacturing

ORDER BY QualityScore ASC;

GO

--===========================================================
-- 4. Quality Score by Defect Status
--===========================================================

SELECT

ds.DefectStatusName,

ROUND(AVG(f.QualityScore),2) AS AverageQualityScore,

ROUND(AVG(f.DefectRate),4) AS AverageDefectRate,

COUNT(*) AS TotalProductionRuns

FROM manufacturing.fact_manufacturing f

JOIN manufacturing.dim_defect_status ds
ON f.DefectStatusID = ds.DefectStatusID

GROUP BY ds.DefectStatusName;

GO

--===========================================================
-- 5. Production Runs with Highest Defect Rate
--===========================================================

SELECT TOP (10)

ManufacturingID,

DefectRate,

QualityScore,

ProductionCost,

SupplierQuality

FROM manufacturing.fact_manufacturing

ORDER BY DefectRate DESC;

GO

--===========================================================
-- 6. Average Defect Rate
--===========================================================

SELECT

ROUND(AVG(DefectRate),4) AS AverageDefectRate

FROM manufacturing.fact_manufacturing;

GO
