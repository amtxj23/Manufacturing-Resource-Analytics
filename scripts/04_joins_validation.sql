/*
===============================================================================
 Project         : Manufacturing Quality Intelligence System
 Script          : 04_populate_data_warehouse.sql
 Author          : Amtoj Singh

 Description:
     Loads the cleaned staging data into the dimension tables
     and then populates the production fact table.

 ETL Flow

     Staging
        ↓
   Dimension Tables
        ↓
     Fact Table

===============================================================================
*/

USE ManufacturingQualityIntelligence;
GO

/*==============================================================================
    Clear Existing Data
==============================================================================*/

TRUNCATE TABLE manufacturing.fact_production;
TRUNCATE TABLE manufacturing.dim_operation;
TRUNCATE TABLE manufacturing.dim_workforce;
TRUNCATE TABLE manufacturing.dim_quality;

GO

/*==============================================================================
    Load Quality Dimension
==============================================================================*/

INSERT INTO manufacturing.dim_quality
(
    SupplierQuality,
    QualityScore,
    DefectRate,
    DeliveryDelay,
    DefectStatus
)

SELECT DISTINCT

    SupplierQuality,
    QualityScore,
    DefectRate,
    DeliveryDelay,
    DefectStatus

FROM manufacturing.stg_manufacturing_data;

GO

/*==============================================================================
    Load Workforce Dimension
==============================================================================*/

INSERT INTO manufacturing.dim_workforce
(
    WorkerProductivity,
    SafetyIncidents
)

SELECT DISTINCT

    WorkerProductivity,
    SafetyIncidents

FROM manufacturing.stg_manufacturing_data;

GO

/*==============================================================================
    Load Operation Dimension
==============================================================================*/

INSERT INTO manufacturing.dim_operation
(
    MaintenanceHours,
    DowntimePercentage,
    InventoryTurnover,
    StockoutRate,
    EnergyConsumption,
    EnergyEfficiency,
    AdditiveProcessTime,
    AdditiveMaterialCost
)

SELECT DISTINCT

    MaintenanceHours,
    DowntimePercentage,
    InventoryTurnover,
    StockoutRate,
    EnergyConsumption,
    EnergyEfficiency,
    AdditiveProcessTime,
    AdditiveMaterialCost

FROM manufacturing.stg_manufacturing_data;

GO

/*==============================================================================
    Populate Fact Table
==============================================================================*/

INSERT INTO manufacturing.fact_production
(
    ProductionVolume,
    ProductionCost,
    QualityID,
    WorkforceID,
    OperationID
)

SELECT

    s.ProductionVolume,

    s.ProductionCost,

    q.QualityID,

    w.WorkforceID,

    o.OperationID

FROM manufacturing.stg_manufacturing_data s

INNER JOIN manufacturing.dim_quality q

ON s.SupplierQuality = q.SupplierQuality
AND s.QualityScore = q.QualityScore
AND s.DefectRate = q.DefectRate
AND s.DeliveryDelay = q.DeliveryDelay
AND s.DefectStatus = q.DefectStatus

INNER JOIN manufacturing.dim_workforce w

ON s.WorkerProductivity = w.WorkerProductivity
AND s.SafetyIncidents = w.SafetyIncidents

INNER JOIN manufacturing.dim_operation o

ON s.MaintenanceHours = o.MaintenanceHours
AND s.DowntimePercentage = o.DowntimePercentage
AND s.InventoryTurnover = o.InventoryTurnover
AND s.StockoutRate = o.StockoutRate
AND s.EnergyConsumption = o.EnergyConsumption
AND s.EnergyEfficiency = o.EnergyEfficiency
AND s.AdditiveProcessTime = o.AdditiveProcessTime
AND s.AdditiveMaterialCost = o.AdditiveMaterialCost;

GO

/*==============================================================================
    Verification
==============================================================================*/

PRINT '=====================';
PRINT 'Warehouse Loaded';
PRINT '=====================';

SELECT COUNT(*) AS QualityDimension
FROM manufacturing.dim_quality;

SELECT COUNT(*) AS WorkforceDimension
FROM manufacturing.dim_workforce;

SELECT COUNT(*) AS OperationDimension
FROM manufacturing.dim_operation;

SELECT COUNT(*) AS FactTable
FROM manufacturing.fact_production;

GO

/*==============================================================================
    Sample Join Validation
==============================================================================*/

SELECT TOP (10)

    fp.ProductionID,

    fp.ProductionVolume,

    fp.ProductionCost,

    q.SupplierQuality,

    q.QualityScore,

    q.DefectRate,

    w.WorkerProductivity,

    w.SafetyIncidents,

    o.MaintenanceHours,

    o.DowntimePercentage

FROM manufacturing.fact_production fp

INNER JOIN manufacturing.dim_quality q

ON fp.QualityID = q.QualityID

INNER JOIN manufacturing.dim_workforce w

ON fp.WorkforceID = w.WorkforceID

INNER JOIN manufacturing.dim_operation o

ON fp.OperationID = o.OperationID;

GO

PRINT '==============================================';
PRINT 'Manufacturing Data Warehouse Ready for Analysis';
PRINT '==============================================';

GO
