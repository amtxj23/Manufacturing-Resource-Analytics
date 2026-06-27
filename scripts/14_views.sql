/*
=============================================================
Create Reporting Views
=============================================================
Description:
Reusable SQL Views for reporting and dashboarding.
=============================================================
*/

USE ManufacturingQualityIntelligence;
GO

/*===========================================================
Drop Existing Views
===========================================================*/

DROP VIEW IF EXISTS manufacturing.vw_Executive_KPIs;
DROP VIEW IF EXISTS manufacturing.vw_Quality_Summary;
DROP VIEW IF EXISTS manufacturing.vw_Cost_Summary;
DROP VIEW IF EXISTS manufacturing.vw_Productivity_Summary;

GO

/*===========================================================
View 1 : Executive KPI Dashboard
===========================================================*/

CREATE VIEW manufacturing.vw_Executive_KPIs
AS

SELECT

COUNT(*) AS TotalProductionRuns,

SUM(ProductionVolume) AS TotalProductionVolume,

SUM(ProductionCost) AS TotalProductionCost,

ROUND(AVG(ProductionCost),2) AS AverageProductionCost,

ROUND(AVG(QualityScore),2) AS AverageQualityScore,

ROUND(AVG(DefectRate),2) AS AverageDefectRate,

ROUND(AVG(WorkerProductivity),2) AS AverageWorkerProductivity

FROM manufacturing.fact_manufacturing;

GO

/*===========================================================
View 2 : Quality Summary
===========================================================*/

CREATE VIEW manufacturing.vw_Quality_Summary
AS

SELECT

ds.DefectStatusName,

COUNT(*) AS ProductionRuns,

ROUND(AVG(f.QualityScore),2) AS AverageQualityScore,

ROUND(AVG(f.DefectRate),2) AS AverageDefectRate

FROM manufacturing.fact_manufacturing f

JOIN manufacturing.dim_defect_status ds

ON f.DefectStatusID = ds.DefectStatusID

GROUP BY ds.DefectStatusName;

GO

/*===========================================================
View 3 : Cost Summary
===========================================================*/

CREATE VIEW manufacturing.vw_Cost_Summary
AS

SELECT

ProductionVolume,

ROUND(AVG(ProductionCost),2) AS AverageProductionCost,

ROUND(AVG(EnergyConsumption),2) AS AverageEnergyConsumption

FROM manufacturing.fact_manufacturing

GROUP BY ProductionVolume;

GO

/*===========================================================
View 4 : Productivity Summary
===========================================================*/

CREATE VIEW manufacturing.vw_Productivity_Summary
AS

SELECT

SafetyIncidents,

ROUND(AVG(WorkerProductivity),2) AS AverageWorkerProductivity,

ROUND(AVG(QualityScore),2) AS AverageQualityScore,

ROUND(AVG(ProductionCost),2) AS AverageProductionCost

FROM manufacturing.fact_manufacturing

GROUP BY SafetyIncidents;

GO

/*===========================================================
Verify Views
===========================================================*/

SELECT *

FROM manufacturing.vw_Executive_KPIs;

GO

SELECT *

FROM manufacturing.vw_Quality_Summary;

GO

SELECT TOP (10) *

FROM manufacturing.vw_Cost_Summary;

GO

SELECT *

FROM manufacturing.vw_Productivity_Summary;

GO
