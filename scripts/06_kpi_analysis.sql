/*
===============================================================================
 Project         : Manufacturing Quality Intelligence System
 Script          : 06_kpi_analysis.sql
 Author          : Amtoj Singh

 Description:
     Executive KPI Dashboard
     Calculates the most important manufacturing KPIs used by
     plant managers and senior management.

===============================================================================
*/

USE ManufacturingQualityIntelligence;
GO

/*==============================================================================
KPI 1 : Total Production Volume
==============================================================================*/

PRINT 'KPI 1 : Total Production Volume';

SELECT
    SUM(ProductionVolume) AS TotalProductionVolume
FROM manufacturing.fact_manufacturing;

GO

/*==============================================================================
KPI 2 : Total Production Cost
==============================================================================*/

PRINT 'KPI 2 : Total Production Cost';

SELECT
    SUM(ProductionCost) AS TotalProductionCost
FROM manufacturing.fact_manufacturing;

GO

/*==============================================================================
KPI 3 : Average Production Cost
==============================================================================*/

PRINT 'KPI 3 : Average Production Cost';

SELECT
    AVG(ProductionCost) AS AverageProductionCost
FROM manufacturing.fact_manufacturing;

GO

/*==============================================================================
KPI 4 : Average Quality Score
==============================================================================*/

PRINT 'KPI 4 : Average Quality Score';

SELECT
    AVG(QualityScore) AS AverageQualityScore
FROM manufacturing.fact_manufacturing;

GO

/*==============================================================================
KPI 5 : Average Defect Rate
==============================================================================*/

PRINT 'KPI 5 : Average Defect Rate';

SELECT
    AVG(DefectRate) AS AverageDefectRate
FROM manufacturing.fact_manufacturing;

GO

/*==============================================================================
KPI 6 : Total Defective Products
==============================================================================*/

PRINT 'KPI 6 : Total Defective Records';

SELECT
    COUNT(*) AS DefectiveRecords
FROM manufacturing.fact_manufacturing
WHERE DefectStatusID = 1;

GO

/*==============================================================================
KPI 7 : Defect Percentage
==============================================================================*/

PRINT 'KPI 7 : Defect Percentage';

SELECT

CAST(
100.0 *
SUM(CASE WHEN DefectStatusID = 1 THEN 1 ELSE 0 END)
/COUNT(*)

AS DECIMAL(8,2))

AS DefectPercentage

FROM manufacturing.fact_manufacturing;

GO

/*==============================================================================
KPI 8 : Average Worker Productivity
==============================================================================*/

PRINT 'KPI 8 : Average Worker Productivity';

SELECT
    AVG(WorkerProductivity) AS AverageWorkerProductivity
FROM manufacturing.fact_manufacturing;

GO

/*==============================================================================
KPI 9 : Average Supplier Quality
==============================================================================*/

PRINT 'KPI 9 : Average Supplier Quality';

SELECT
    AVG(SupplierQuality) AS AverageSupplierQuality
FROM manufacturing.fact_manufacturing;

GO

/*==============================================================================
KPI 10 : Average Energy Efficiency
==============================================================================*/

PRINT 'KPI 10 : Average Energy Efficiency';

SELECT
    AVG(EnergyEfficiency) AS AverageEnergyEfficiency
FROM manufacturing.fact_manufacturing;

GO

/*==============================================================================
KPI 11 : Average Downtime
==============================================================================*/

PRINT 'KPI 11 : Average Downtime Percentage';

SELECT
    AVG(DowntimePercentage) AS AverageDowntimePercentage
FROM manufacturing.fact_manufacturing;

GO

/*==============================================================================
KPI 12 : Executive KPI Dashboard
==============================================================================*/

PRINT 'EXECUTIVE KPI DASHBOARD';

SELECT

COUNT(*) AS TotalProductionRuns,

SUM(ProductionVolume) AS TotalProductionVolume,

SUM(ProductionCost) AS TotalProductionCost,

AVG(ProductionCost) AS AvgProductionCost,

AVG(QualityScore) AS AvgQualityScore,

AVG(DefectRate) AS AvgDefectRate,

AVG(WorkerProductivity) AS AvgWorkerProductivity,

AVG(SupplierQuality) AS AvgSupplierQuality,

AVG(EnergyEfficiency) AS AvgEnergyEfficiency,

AVG(DowntimePercentage) AS AvgDowntimePercentage,

CAST(
100.0 *
SUM(CASE WHEN DefectStatusID = 1 THEN 1 ELSE 0 END)
/COUNT(*)

AS DECIMAL(8,2))

AS DefectPercentage

FROM manufacturing.fact_manufacturing;

GO

PRINT '=============================================';
PRINT 'Executive KPI Analysis Completed';
PRINT '=============================================';
GO
