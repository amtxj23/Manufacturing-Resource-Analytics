/*
=============================================================
Stored Procedures
=============================================================
Description:
Creates reusable stored procedures for common
manufacturing reports.
=============================================================
*/

USE ManufacturingQualityIntelligence;
GO

/*===========================================================
Drop Existing Procedures
===========================================================*/

DROP PROCEDURE IF EXISTS manufacturing.sp_ExecutiveDashboard;
DROP PROCEDURE IF EXISTS manufacturing.sp_TopCostlyProductionRuns;
DROP PROCEDURE IF EXISTS manufacturing.sp_QualityReport;
DROP PROCEDURE IF EXISTS manufacturing.sp_ProductivityReport;

GO

/*===========================================================
Procedure 1 : Executive Dashboard
===========================================================*/

CREATE PROCEDURE manufacturing.sp_ExecutiveDashboard
AS
BEGIN

SET NOCOUNT ON;

SELECT

COUNT(*) AS TotalProductionRuns,

SUM(ProductionVolume) AS TotalProductionVolume,

SUM(ProductionCost) AS TotalProductionCost,

ROUND(AVG(ProductionCost),2) AS AverageProductionCost,

ROUND(AVG(QualityScore),2) AS AverageQualityScore,

ROUND(AVG(DefectRate),2) AS AverageDefectRate,

ROUND(AVG(WorkerProductivity),2) AS AverageWorkerProductivity

FROM manufacturing.fact_manufacturing;

END;

GO

/*===========================================================
Procedure 2 : Top Costly Production Runs
===========================================================*/

CREATE PROCEDURE manufacturing.sp_TopCostlyProductionRuns
(
    @TopRecords INT = 10
)
AS
BEGIN

SET NOCOUNT ON;

SELECT TOP (@TopRecords)

ManufacturingID,

ProductionCost,

ProductionVolume,

QualityScore

FROM manufacturing.fact_manufacturing

ORDER BY ProductionCost DESC;

END;

GO

/*===========================================================
Procedure 3 : Quality Report
===========================================================*/

CREATE PROCEDURE manufacturing.sp_QualityReport
AS
BEGIN

SET NOCOUNT ON;

SELECT

ds.DefectStatusName,

COUNT(*) AS ProductionRuns,

ROUND(AVG(f.QualityScore),2) AS AverageQualityScore,

ROUND(AVG(f.DefectRate),2) AS AverageDefectRate

FROM manufacturing.fact_manufacturing f

JOIN manufacturing.dim_defect_status ds

ON f.DefectStatusID = ds.DefectStatusID

GROUP BY ds.DefectStatusName;

END;

GO

/*===========================================================
Procedure 4 : Productivity Report
===========================================================*/

CREATE PROCEDURE manufacturing.sp_ProductivityReport
AS
BEGIN

SET NOCOUNT ON;

SELECT

SafetyIncidents,

ROUND(AVG(WorkerProductivity),2) AS AverageWorkerProductivity,

ROUND(AVG(QualityScore),2) AS AverageQualityScore,

ROUND(AVG(ProductionCost),2) AS AverageProductionCost

FROM manufacturing.fact_manufacturing

GROUP BY SafetyIncidents

ORDER BY SafetyIncidents;

END;

GO

/*===========================================================
Execute Stored Procedures
===========================================================*/

EXEC manufacturing.sp_ExecutiveDashboard;
GO

EXEC manufacturing.sp_TopCostlyProductionRuns;
GO

EXEC manufacturing.sp_TopCostlyProductionRuns @TopRecords = 5;
GO

EXEC manufacturing.sp_QualityReport;
GO

EXEC manufacturing.sp_ProductivityReport;
GO
