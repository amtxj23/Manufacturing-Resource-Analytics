/*
===============================================================================
 Project         : Manufacturing Quality Intelligence System
 Script          : 02_load_staging.sql
 Author          : Amtoj Singh

 Description:
     Loads the raw manufacturing dataset into the staging table.

 NOTE:
     Update the file path before running this script.

===============================================================================
*/

USE ManufacturingQualityIntelligence;
GO

/*==============================================================================
    Empty Staging Table
==============================================================================*/

TRUNCATE TABLE manufacturing.stg_manufacturing_data;
GO

/*==============================================================================
    Load CSV into Staging Table
==============================================================================*/

BULK INSERT manufacturing.stg_manufacturing_data
FROM 'D:\downloads\archive (2)\manufacturing_defect_dataset.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001',
    KEEPNULLS
);

/*==============================================================================
    Verify Load
==============================================================================*/

PRINT 'Total Records Loaded';

SELECT COUNT(*) AS TotalRecords
FROM manufacturing.stg_manufacturing_data;

GO

/*==============================================================================
    Preview Data
==============================================================================*/

SELECT TOP (10) *
FROM manufacturing.stg_manufacturing_data;

GO

/*==============================================================================
    Column Summary
==============================================================================*/

SELECT
    MIN(ProductionVolume) AS MinProductionVolume,
    MAX(ProductionVolume) AS MaxProductionVolume,

    MIN(ProductionCost) AS MinProductionCost,
    MAX(ProductionCost) AS MaxProductionCost,

    MIN(QualityScore) AS MinQualityScore,
    MAX(QualityScore) AS MaxQualityScore,

    MIN(DefectRate) AS MinDefectRate,
    MAX(DefectRate) AS MaxDefectRate
FROM manufacturing.stg_manufacturing_data;

GO

PRINT '=============================================';
PRINT 'Raw Dataset Successfully Loaded into Staging';
PRINT '=============================================';

GO
