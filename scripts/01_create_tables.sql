/*
===============================================================================
 Project         : Manufacturing Quality Intelligence System
 Script          : 01_create_tables.sql
 Author          : Amtoj Singh

 Description:
     Creates the staging table and the star schema
     (Fact + Dimension tables) for the Manufacturing Quality Intelligence System.

===============================================================================
*/

USE ManufacturingQualityIntelligence;
GO

/*==============================================================================
    Drop Existing Tables (if rerunning script)
==============================================================================*/

IF OBJECT_ID('manufacturing.fact_production','U') IS NOT NULL
DROP TABLE manufacturing.fact_production;

IF OBJECT_ID('manufacturing.dim_operation','U') IS NOT NULL
DROP TABLE manufacturing.dim_operation;

IF OBJECT_ID('manufacturing.dim_workforce','U') IS NOT NULL
DROP TABLE manufacturing.dim_workforce;

IF OBJECT_ID('manufacturing.dim_quality','U') IS NOT NULL
DROP TABLE manufacturing.dim_quality;

IF OBJECT_ID('manufacturing.stg_manufacturing_data','U') IS NOT NULL
DROP TABLE manufacturing.stg_manufacturing_data;

GO

/*==============================================================================
    STAGING TABLE
==============================================================================*/

CREATE TABLE manufacturing.stg_manufacturing_data
(
    ProductionVolume        INT,
    ProductionCost          DECIMAL(18,2),

    SupplierQuality         DECIMAL(6,2),
    DeliveryDelay           INT,

    DefectRate              DECIMAL(6,3),
    QualityScore            DECIMAL(6,2),

    MaintenanceHours        INT,
    DowntimePercentage      DECIMAL(6,3),

    InventoryTurnover       DECIMAL(6,2),
    StockoutRate            DECIMAL(6,3),

    WorkerProductivity      DECIMAL(6,2),
    SafetyIncidents         INT,

    EnergyConsumption       DECIMAL(12,2),
    EnergyEfficiency        DECIMAL(6,3),

    AdditiveProcessTime     DECIMAL(6,2),
    AdditiveMaterialCost    DECIMAL(12,2),

    DefectStatus            BIT
);

GO

/*==============================================================================
    QUALITY DIMENSION
==============================================================================*/

CREATE TABLE manufacturing.dim_quality
(
    QualityID INT IDENTITY(1,1) PRIMARY KEY,

    SupplierQuality DECIMAL(6,2) NOT NULL,

    QualityScore DECIMAL(6,2) NOT NULL,

    DefectRate DECIMAL(6,3) NOT NULL,

    DeliveryDelay INT NOT NULL,

    DefectStatus BIT NOT NULL
);

GO

/*==============================================================================
    WORKFORCE DIMENSION
==============================================================================*/

CREATE TABLE manufacturing.dim_workforce
(
    WorkforceID INT IDENTITY(1,1) PRIMARY KEY,

    WorkerProductivity DECIMAL(6,2) NOT NULL,

    SafetyIncidents INT NOT NULL
);

GO

/*==============================================================================
    OPERATION DIMENSION
==============================================================================*/

CREATE TABLE manufacturing.dim_operation
(
    OperationID INT IDENTITY(1,1) PRIMARY KEY,

    MaintenanceHours INT NOT NULL,

    DowntimePercentage DECIMAL(6,3) NOT NULL,

    InventoryTurnover DECIMAL(6,2) NOT NULL,

    StockoutRate DECIMAL(6,3) NOT NULL,

    EnergyConsumption DECIMAL(12,2) NOT NULL,

    EnergyEfficiency DECIMAL(6,3) NOT NULL,

    AdditiveProcessTime DECIMAL(6,2) NOT NULL,

    AdditiveMaterialCost DECIMAL(12,2) NOT NULL
);

GO

/*==============================================================================
    FACT TABLE
==============================================================================*/

CREATE TABLE manufacturing.fact_production
(
    ProductionID BIGINT IDENTITY(100001,1) PRIMARY KEY,

    ProductionVolume INT NOT NULL,

    ProductionCost DECIMAL(18,2) NOT NULL,

    QualityID INT NOT NULL,

    WorkforceID INT NOT NULL,

    OperationID INT NOT NULL,

    CONSTRAINT FK_Fact_Quality
        FOREIGN KEY (QualityID)
        REFERENCES manufacturing.dim_quality(QualityID),

    CONSTRAINT FK_Fact_Workforce
        FOREIGN KEY (WorkforceID)
        REFERENCES manufacturing.dim_workforce(WorkforceID),

    CONSTRAINT FK_Fact_Operation
        FOREIGN KEY (OperationID)
        REFERENCES manufacturing.dim_operation(OperationID)
);

GO

/*==============================================================================
    Verify Tables
==============================================================================*/

SELECT
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'manufacturing'
ORDER BY TABLE_NAME;

GO

PRINT '==========================================';
PRINT 'Manufacturing Warehouse Created Successfully';
PRINT '==========================================';

GO
