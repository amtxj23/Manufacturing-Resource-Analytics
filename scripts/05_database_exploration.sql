/*
===============================================================================
 Project         : Manufacturing Quality Intelligence System
 Script          : 05_database_exploration.sql
 Author          : Amtoj Singh

 Description:
     Performs an initial exploration of the Manufacturing Data Warehouse
     to understand the data before business analysis.

===============================================================================
*/

USE ManufacturingQualityIntelligence;
GO

/*==============================================================================
1. List All Tables
==============================================================================*/

PRINT '===== DATABASE TABLES =====';

SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
ORDER BY TABLE_NAME;

GO

/*==============================================================================
2. Total Records in Each Table
==============================================================================*/

PRINT '===== TOTAL RECORDS =====';

SELECT 'Fact Manufacturing' AS TableName,
COUNT(*) AS TotalRecords
FROM manufacturing.fact_manufacturing

UNION ALL

SELECT 'Dim Date',
COUNT(*)
FROM manufacturing.dim_date

UNION ALL

SELECT 'Dim Defect Status',
COUNT(*)
FROM manufacturing.dim_defect_status;

GO

/*==============================================================================
3. Preview Fact Table
==============================================================================*/

PRINT '===== FACT TABLE SAMPLE =====';

SELECT TOP 10 *
FROM manufacturing.fact_manufacturing;

GO

/*==============================================================================
4. Preview Date Dimension
==============================================================================*/

PRINT '===== DATE DIMENSION =====';

SELECT TOP 10 *
FROM manufacturing.dim_date;

GO

/*==============================================================================
5. Preview Defect Status Dimension
==============================================================================*/

PRINT '===== DEFECT STATUS DIMENSION =====';

SELECT *
FROM manufacturing.dim_defect_status;

GO

/*==============================================================================
6. Date Range
==============================================================================*/

PRINT '===== PRODUCTION DATE RANGE =====';

SELECT

MIN(d.ProductionDate) AS StartDate,

MAX(d.ProductionDate) AS EndDate,

COUNT(DISTINCT d.ProductionDate) AS TotalProductionDays

FROM manufacturing.fact_manufacturing f

JOIN manufacturing.dim_date d
ON f.DateID = d.DateID;

GO

/*==============================================================================
7. Distinct Defect Status
==============================================================================*/

PRINT '===== DEFECT STATUS =====';

SELECT

ds.DefectStatusName,

COUNT(*) AS TotalRecords

FROM manufacturing.fact_manufacturing f

JOIN manufacturing.dim_defect_status ds
ON f.DefectStatusID = ds.DefectStatusID

GROUP BY ds.DefectStatusName;

GO

/*==============================================================================
8. Data Completeness Check
==============================================================================*/

PRINT '===== NULL VALUE CHECK =====';

SELECT

SUM(CASE WHEN ProductionVolume IS NULL THEN 1 ELSE 0 END) AS ProductionVolume,

SUM(CASE WHEN ProductionCost IS NULL THEN 1 ELSE 0 END) AS ProductionCost,

SUM(CASE WHEN SupplierQuality IS NULL THEN 1 ELSE 0 END) AS SupplierQuality,

SUM(CASE WHEN DefectRate IS NULL THEN 1 ELSE 0 END) AS DefectRate,

SUM(CASE WHEN QualityScore IS NULL THEN 1 ELSE 0 END) AS QualityScore,

SUM(CASE WHEN WorkerProductivity IS NULL THEN 1 ELSE 0 END) AS WorkerProductivity

FROM manufacturing.fact_manufacturing;

GO

/*==============================================================================
9. Basic Statistics
==============================================================================*/

PRINT '===== BASIC STATISTICS =====';

SELECT

COUNT(*) AS TotalProductionRecords,

AVG(ProductionVolume) AS AvgProductionVolume,

AVG(ProductionCost) AS AvgProductionCost,

AVG(QualityScore) AS AvgQualityScore,

AVG(DefectRate) AS AvgDefectRate,

AVG(WorkerProductivity) AS AvgWorkerProductivity,

AVG(EnergyConsumption) AS AvgEnergyConsumption

FROM manufacturing.fact_manufacturing;

GO

/*==============================================================================
10. Min & Max Values
==============================================================================*/

PRINT '===== MINIMUM & MAXIMUM VALUES =====';

SELECT

MIN(ProductionCost) AS MinCost,
MAX(ProductionCost) AS MaxCost,

MIN(QualityScore) AS MinQuality,
MAX(QualityScore) AS MaxQuality,

MIN(DefectRate) AS MinDefectRate,
MAX(DefectRate) AS MaxDefectRate,

MIN(WorkerProductivity) AS MinProductivity,
MAX(WorkerProductivity) AS MaxProductivity

FROM manufacturing.fact_manufacturing;

GO

PRINT '============================================';
PRINT 'Database Exploration Completed Successfully';
PRINT '============================================';
GO
