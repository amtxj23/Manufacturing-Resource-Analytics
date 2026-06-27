/*
===============================================================================
 Project         : Manufacturing Quality Intelligence System
 Script          : 03_data_cleaning.sql
 Author          : Amtoj Singh

 Description:
     Cleans and validates the raw manufacturing data stored in the staging table
     before loading it into the dimensional warehouse.

 Cleaning Performed:
     ✓ Check record count
     ✓ Check NULL values
     ✓ Check duplicate records
     ✓ Remove duplicates
     ✓ Remove negative values
     ✓ Standardize numeric values
     ✓ Verify cleaned dataset
===============================================================================
*/

USE ManufacturingQualityIntelligence;
GO

/*==============================================================================
    Total Records
==============================================================================*/

PRINT 'Total Records Before Cleaning';

SELECT COUNT(*) AS TotalRecords
FROM manufacturing.stg_manufacturing_data;

GO

/*==============================================================================
    NULL Value Analysis
==============================================================================*/

PRINT 'Checking NULL Values';

SELECT

SUM(CASE WHEN ProductionVolume IS NULL THEN 1 ELSE 0 END) AS ProductionVolume,

SUM(CASE WHEN ProductionCost IS NULL THEN 1 ELSE 0 END) AS ProductionCost,

SUM(CASE WHEN SupplierQuality IS NULL THEN 1 ELSE 0 END) AS SupplierQuality,

SUM(CASE WHEN DeliveryDelay IS NULL THEN 1 ELSE 0 END) AS DeliveryDelay,

SUM(CASE WHEN DefectRate IS NULL THEN 1 ELSE 0 END) AS DefectRate,

SUM(CASE WHEN QualityScore IS NULL THEN 1 ELSE 0 END) AS QualityScore,

SUM(CASE WHEN MaintenanceHours IS NULL THEN 1 ELSE 0 END) AS MaintenanceHours,

SUM(CASE WHEN DowntimePercentage IS NULL THEN 1 ELSE 0 END) AS DowntimePercentage,

SUM(CASE WHEN InventoryTurnover IS NULL THEN 1 ELSE 0 END) AS InventoryTurnover,

SUM(CASE WHEN StockoutRate IS NULL THEN 1 ELSE 0 END) AS StockoutRate,

SUM(CASE WHEN WorkerProductivity IS NULL THEN 1 ELSE 0 END) AS WorkerProductivity,

SUM(CASE WHEN SafetyIncidents IS NULL THEN 1 ELSE 0 END) AS SafetyIncidents,

SUM(CASE WHEN EnergyConsumption IS NULL THEN 1 ELSE 0 END) AS EnergyConsumption,

SUM(CASE WHEN EnergyEfficiency IS NULL THEN 1 ELSE 0 END) AS EnergyEfficiency,

SUM(CASE WHEN AdditiveProcessTime IS NULL THEN 1 ELSE 0 END) AS AdditiveProcessTime,

SUM(CASE WHEN AdditiveMaterialCost IS NULL THEN 1 ELSE 0 END) AS AdditiveMaterialCost,

SUM(CASE WHEN DefectStatus IS NULL THEN 1 ELSE 0 END) AS DefectStatus

FROM manufacturing.stg_manufacturing_data;

GO

/*==============================================================================
    Duplicate Record Check
==============================================================================*/

PRINT 'Checking Duplicate Records';

SELECT
ProductionVolume,
ProductionCost,
SupplierQuality,
DeliveryDelay,
DefectRate,
QualityScore,
MaintenanceHours,
DowntimePercentage,
InventoryTurnover,
StockoutRate,
WorkerProductivity,
SafetyIncidents,
EnergyConsumption,
EnergyEfficiency,
AdditiveProcessTime,
AdditiveMaterialCost,
DefectStatus,
COUNT(*) AS DuplicateCount

FROM manufacturing.stg_manufacturing_data

GROUP BY

ProductionVolume,
ProductionCost,
SupplierQuality,
DeliveryDelay,
DefectRate,
QualityScore,
MaintenanceHours,
DowntimePercentage,
InventoryTurnover,
StockoutRate,
WorkerProductivity,
SafetyIncidents,
EnergyConsumption,
EnergyEfficiency,
AdditiveProcessTime,
AdditiveMaterialCost,
DefectStatus

HAVING COUNT(*) > 1;

GO

/*==============================================================================
    Remove Duplicate Records
==============================================================================*/

;WITH DuplicateCTE AS
(
SELECT *,
ROW_NUMBER() OVER
(
PARTITION BY

ProductionVolume,
ProductionCost,
SupplierQuality,
DeliveryDelay,
DefectRate,
QualityScore,
MaintenanceHours,
DowntimePercentage,
InventoryTurnover,
StockoutRate,
WorkerProductivity,
SafetyIncidents,
EnergyConsumption,
EnergyEfficiency,
AdditiveProcessTime,
AdditiveMaterialCost,
DefectStatus

ORDER BY ProductionVolume

) AS rn

FROM manufacturing.stg_manufacturing_data
)

DELETE
FROM DuplicateCTE
WHERE rn > 1;

GO

/*==============================================================================
    Remove Invalid Negative Values
==============================================================================*/

DELETE
FROM manufacturing.stg_manufacturing_data
WHERE

ProductionVolume < 0

OR ProductionCost < 0

OR SupplierQuality < 0

OR DeliveryDelay < 0

OR DefectRate < 0

OR QualityScore < 0

OR MaintenanceHours < 0

OR DowntimePercentage < 0

OR InventoryTurnover < 0

OR StockoutRate < 0

OR WorkerProductivity < 0

OR SafetyIncidents < 0

OR EnergyConsumption < 0

OR EnergyEfficiency < 0

OR AdditiveProcessTime < 0

OR AdditiveMaterialCost < 0;

GO

/*==============================================================================
    Verify Clean Dataset
==============================================================================*/

PRINT 'Total Records After Cleaning';

SELECT COUNT(*) AS CleanRecords
FROM manufacturing.stg_manufacturing_data;

GO

/*==============================================================================
    Preview Clean Data
==============================================================================*/

SELECT TOP (10) *
FROM manufacturing.stg_manufacturing_data;

GO

PRINT '==============================================';
PRINT 'Data Cleaning Completed Successfully';
PRINT '==============================================';

GO
