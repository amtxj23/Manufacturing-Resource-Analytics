/*
=============================================================
Supplier Analysis
=============================================================
Business Questions:
1. What is the average supplier quality?
2. Which production runs have the highest supplier quality?
3. Does supplier quality impact defect rate?
4. Does supplier quality impact production cost?
=============================================================
*/

USE ManufacturingQualityIntelligence;
GO

--===========================================================
-- 1. Average Supplier Quality
--===========================================================

SELECT
    ROUND(AVG(SupplierQuality),2) AS AverageSupplierQuality
FROM manufacturing.fact_manufacturing;

GO

--===========================================================
-- 2. Top 10 Highest Supplier Quality Records
--===========================================================

SELECT TOP (10)

ManufacturingID,
SupplierQuality,
QualityScore,
DefectRate

FROM manufacturing.fact_manufacturing

ORDER BY SupplierQuality DESC;

GO

--===========================================================
-- 3. Supplier Quality vs Defect Rate
--===========================================================

SELECT

SupplierQuality,

ROUND(AVG(DefectRate),4) AS AverageDefectRate

FROM manufacturing.fact_manufacturing

GROUP BY SupplierQuality

ORDER BY SupplierQuality DESC;

GO

--===========================================================
-- 4. Supplier Quality vs Production Cost
--===========================================================

SELECT

SupplierQuality,

ROUND(AVG(ProductionCost),2) AS AverageProductionCost

FROM manufacturing.fact_manufacturing

GROUP BY SupplierQuality

ORDER BY SupplierQuality DESC;

GO

--===========================================================
-- 5. Top 10 Best Supplier Performance
--===========================================================

SELECT TOP (10)

ManufacturingID,

SupplierQuality,

QualityScore,

ProductionCost,

DefectRate

FROM manufacturing.fact_manufacturing

ORDER BY

SupplierQuality DESC,

QualityScore DESC;

GO
