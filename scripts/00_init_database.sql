/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'ManufacturingResourceAnalytics'
    after checking if it already exists.

    If the database exists, it is dropped and recreated.
    It also creates the schema used for the analytics project.

WARNING:
    Running this script will permanently delete the existing
    'ManufacturingResourceAnalytics' database along with all
    stored data. Ensure proper backups before execution.
=============================================================
*/

USE master;
GO

-------------------------------------------------------------
-- Drop Existing Database
-------------------------------------------------------------
IF EXISTS (
    SELECT 1
    FROM sys.databases
    WHERE name = 'ManufacturingResourceAnalytics'
)
BEGIN
    ALTER DATABASE ManufacturingResourceAnalytics
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

    DROP DATABASE ManufacturingResourceAnalytics;
END;
GO

-------------------------------------------------------------
-- Create Database
-------------------------------------------------------------
CREATE DATABASE ManufacturingResourceAnalytics;
GO

USE ManufacturingResourceAnalytics;
GO

-------------------------------------------------------------
-- Create Schema
-------------------------------------------------------------
CREATE SCHEMA manufacturing;
GO

-------------------------------------------------------------
-- Create Machines Dimension
-------------------------------------------------------------
CREATE TABLE manufacturing.dim_machines
(
    machine_key        INT PRIMARY KEY,
    machine_id         INT,
    machine_name       NVARCHAR(100),
    machine_type       NVARCHAR(100),
    department         NVARCHAR(100),
    installation_date  DATE,
    status             NVARCHAR(50)
);
GO

-------------------------------------------------------------
-- Create Products Dimension
-------------------------------------------------------------
CREATE TABLE manufacturing.dim_products
(
    product_key        INT PRIMARY KEY,
    product_id         INT,
    product_name       NVARCHAR(100),
    category           NVARCHAR(100),
    unit_cost          DECIMAL(10,2)
);
GO

-------------------------------------------------------------
-- Create Date Dimension
-------------------------------------------------------------
CREATE TABLE manufacturing.dim_date
(
    date_key           INT PRIMARY KEY,
    production_date    DATE,
    year               INT,
    quarter            INT,
    month              INT,
    month_name         NVARCHAR(20),
    week_number        INT,
    day_name           NVARCHAR(20)
);
GO

-------------------------------------------------------------
-- Create Production Fact Table
-------------------------------------------------------------
CREATE TABLE manufacturing.fact_production
(
    production_id          INT PRIMARY KEY,
    date_key               INT,
    machine_key            INT,
    product_key            INT,
    quantity_produced      INT,
    production_hours       DECIMAL(10,2),
    downtime_minutes       INT,
    defective_units        INT,
    efficiency_percentage  DECIMAL(5,2)
);
GO

-------------------------------------------------------------
-- Load Machines Data
-------------------------------------------------------------
TRUNCATE TABLE manufacturing.dim_machines;
GO

BULK INSERT manufacturing.dim_machines
FROM 'C:\Manufacturing-Resource-Analytics\data\dim_machines.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    TABLOCK
);
GO

-------------------------------------------------------------
-- Load Products Data
-------------------------------------------------------------
TRUNCATE TABLE manufacturing.dim_products;
GO

BULK INSERT manufacturing.dim_products
FROM 'C:\Manufacturing-Resource-Analytics\data\dim_products.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    TABLOCK
);
GO

-------------------------------------------------------------
-- Load Date Dimension
-------------------------------------------------------------
TRUNCATE TABLE manufacturing.dim_date;
GO

BULK INSERT manufacturing.dim_date
FROM 'C:\Manufacturing-Resource-Analytics\data\dim_date.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    TABLOCK
);
GO

-------------------------------------------------------------
-- Load Production Fact
-------------------------------------------------------------
TRUNCATE TABLE manufacturing.fact_production;
GO

BULK INSERT manufacturing.fact_production
FROM 'C:\Manufacturing-Resource-Analytics\data\fact_production.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    TABLOCK
);
GO
