/*
===============================================================================
 Project         : Manufacturing Quality Intelligence System
 Script          : 04_populate_data_warehouse.sql
 Author          : Amtoj Singh

 Description:
     Populates the dimensional data warehouse from the cleaned staging table.

 ETL Flow

     Staging Table
            │
            ▼
     Dimension Tables
            │
            ▼
      Fact Manufacturing

===============================================================================
*/

USE ManufacturingQualityIntelligence;
GO

/*==============================================================================
    Clear Existing Data
==============================================================================*/

DELETE FROM manufacturing.fact_manufacturing;
DELETE FROM manufacturing.dim_date;
DELETE FROM manufacturing.dim_defect_status;

GO

/*==============================================================================
    Populate Defect Status Dimension
==============================================================================*/

INSERT INTO manufacturing.dim_defect_status
(
    DefectStatusID,
    DefectStatusName
)

VALUES
(0,'Non-Defective'),
(1,'Defective');

GO

/*==============================================================================
    Populate Date Dimension

    Generate one date for each production record.
==============================================================================*/

;WITH DateSequence AS
(
    SELECT

        ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS RowNum,

        DATEADD
        (
            DAY,
            ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) - 1,
            '2025-01-01'
        ) AS ProductionDate

    FROM manufacturing.stg_manufacturing_data
)

INSERT INTO manufacturing.dim_date
(
    ProductionDate,
    DayNumber,
    MonthNumber,
    MonthName,
    QuarterNumber,
    YearNumber
)

SELECT

ProductionDate,

DAY(ProductionDate),

MONTH(ProductionDate),

DATENAME(MONTH,ProductionDate),

DATEPART(QUARTER,ProductionDate),

YEAR(ProductionDate)

FROM DateSequence;

GO

/*==============================================================================
    Populate Fact Table
==============================================================================*/

INSERT INTO manufacturing.fact_manufacturing
(
    DateID,

    DefectStatusID,

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

    AdditiveMaterialCost
)

SELECT

d.DateID,

s.DefectStatus,

s.ProductionVolume,

s.ProductionCost,

s.SupplierQuality,

s.DeliveryDelay,

s.DefectRate,

s.QualityScore,

s.MaintenanceHours,

s.DowntimePercentage,

s.InventoryTurnover,

s.StockoutRate,

s.WorkerProductivity,

s.SafetyIncidents,

s.EnergyConsumption,

s.EnergyEfficiency,

s.AdditiveProcessTime,

s.AdditiveMaterialCost

FROM manufacturing.stg_manufacturing_data s

INNER JOIN
(
    SELECT

    DateID,

    ROW_NUMBER() OVER(ORDER BY DateID) AS rn

    FROM manufacturing.dim_date

)d

ON d.rn =
(
    SELECT COUNT(*)
    FROM manufacturing.stg_manufacturing_data s2
    WHERE
    s2.ProductionVolume < s.ProductionVolume
    OR
    (
        s2.ProductionVolume = s.ProductionVolume
        AND
        s2.ProductionCost <= s.ProductionCost
    )
);

GO

/*==============================================================================
    Verification
==============================================================================*/

PRINT '==============================';
PRINT 'Warehouse Successfully Loaded';
PRINT '==============================';

SELECT COUNT(*) AS DateDimension
FROM manufacturing.dim_date;

SELECT COUNT(*) AS DefectDimension
FROM manufacturing.dim_defect_status;

SELECT COUNT(*) AS FactTable
FROM manufacturing.fact_manufacturing;

GO

/*==============================================================================
    Sample Join
==============================================================================*/

SELECT TOP 10

f.ManufacturingID,

d.ProductionDate,

ds.DefectStatusName,

f.ProductionVolume,

f.ProductionCost,

f.QualityScore,

f.DefectRate,

f.WorkerProductivity

FROM manufacturing.fact_manufacturing f

INNER JOIN manufacturing.dim_date d

ON f.DateID=d.DateID

INNER JOIN manufacturing.dim_defect_status ds

ON f.DefectStatusID=ds.DefectStatusID;

GO

PRINT '=============================================';
PRINT 'Data Warehouse Ready for Business Analytics';
PRINT '=============================================';

GO
