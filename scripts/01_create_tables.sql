/*
===============================================================================
 Project         : Manufacturing Quality Intelligence System
 Script          : 01_create_tables.sql
 Author          : Amtoj Singh

 Description:
     Creates the staging table and dimensional data warehouse tables.

 Database Model:

     Staging
        │
        ▼
 Fact_Manufacturing
      │        │
      ▼        ▼
Dim_Date   Dim_DefectStatus

===============================================================================
*/

USE ManufacturingQualityIntelligence;
GO

/*==============================================================================
DROP TABLES IF THEY ALREADY EXIST
==============================================================================*/

IF OBJECT_ID('manufacturing.fact_manufacturing','U') IS NOT NULL
DROP TABLE manufacturing.fact_manufacturing;

IF OBJECT_ID('manufacturing.dim_date','U') IS NOT NULL
DROP TABLE manufacturing.dim_date;

IF OBJECT_ID('manufacturing.dim_defect_status','U') IS NOT NULL
DROP TABLE manufacturing.dim_defect_status;

IF OBJECT_ID('manufacturing.stg_manufacturing_data','U') IS NOT NULL
DROP TABLE manufacturing.stg_manufacturing_data;

GO

/*==============================================================================
STAGING TABLE
==============================================================================*/

CREATE TABLE manufacturing.stg_manufacturing_data
(
    ProductionVolume INT,
    ProductionCost DECIMAL(18,2),

    SupplierQuality FLOAT,
    DeliveryDelay INT,

    DefectRate FLOAT,
    QualityScore FLOAT,

    MaintenanceHours INT,
    DowntimePercentage FLOAT,

    InventoryTurnover FLOAT,
    StockoutRate FLOAT,

    WorkerProductivity FLOAT,
    SafetyIncidents INT,

    EnergyConsumption FLOAT,
    EnergyEfficiency FLOAT,

    AdditiveProcessTime FLOAT,
    AdditiveMaterialCost FLOAT,

    DefectStatus BIT
);

GO

/*==============================================================================
DATE DIMENSION
==============================================================================*/

CREATE TABLE manufacturing.dim_date
(
    DateID INT IDENTITY(1,1) PRIMARY KEY,

    ProductionDate DATE NOT NULL,

    DayNumber TINYINT,

    MonthNumber TINYINT,

    MonthName VARCHAR(20),

    QuarterNumber TINYINT,

    YearNumber SMALLINT
);

GO

/*==============================================================================
DEFECT STATUS DIMENSION
==============================================================================*/

CREATE TABLE manufacturing.dim_defect_status
(
    DefectStatusID INT PRIMARY KEY,

    DefectStatusName VARCHAR(30) NOT NULL
);

GO

/*==============================================================================
FACT TABLE
==============================================================================*/

CREATE TABLE manufacturing.fact_manufacturing
(
    ManufacturingID INT IDENTITY(100001,1) PRIMARY KEY,

    DateID INT NOT NULL,

    DefectStatusID INT NOT NULL,

    ProductionVolume INT,

    ProductionCost DECIMAL(18,2),

    SupplierQuality FLOAT,

    DeliveryDelay INT,

    DefectRate FLOAT,

    QualityScore FLOAT,

    MaintenanceHours INT,

    DowntimePercentage FLOAT,

    InventoryTurnover FLOAT,

    StockoutRate FLOAT,

    WorkerProductivity FLOAT,

    SafetyIncidents INT,

    EnergyConsumption FLOAT,

    EnergyEfficiency FLOAT,

    AdditiveProcessTime FLOAT,

    AdditiveMaterialCost FLOAT,

    CONSTRAINT FK_Fact_Date
        FOREIGN KEY(DateID)
        REFERENCES manufacturing.dim_date(DateID),

    CONSTRAINT FK_Fact_Defect
        FOREIGN KEY(DefectStatusID)
        REFERENCES manufacturing.dim_defect_status(DefectStatusID)
);

GO

/*==============================================================================
VERIFY TABLES
==============================================================================*/

SELECT
TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA='manufacturing'
ORDER BY TABLE_NAME;

GO

PRINT '==========================================';
PRINT 'Manufacturing Warehouse Created';
PRINT '==========================================';

GO
