/*
===============================================================================
 Project         : Manufacturing Quality Intelligence System
 Script          : 00_create_database.sql
 Author          : Amtoj Singh
 Description     : Creates the Manufacturing Quality Intelligence database
                   along with the required schema for the project.

 WARNING:
 This script will permanently delete the existing database if it already exists.
===============================================================================
*/

--=============================================================================
-- Drop Existing Database (If Exists)
--=============================================================================

USE master;
GO

IF EXISTS (
    SELECT 1
    FROM sys.databases
    WHERE name = 'ManufacturingQualityIntelligence'
)
BEGIN
    ALTER DATABASE ManufacturingQualityIntelligence
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

    DROP DATABASE ManufacturingQualityIntelligence;
END
GO

--=============================================================================
-- Create Database
--=============================================================================

CREATE DATABASE ManufacturingQualityIntelligence;
GO

USE ManufacturingQualityIntelligence;
GO

--=============================================================================
-- Create Schema
--=============================================================================

CREATE SCHEMA manufacturing;
GO

--=============================================================================
-- Verify Database
--=============================================================================

PRINT '=====================================================';
PRINT 'ManufacturingQualityIntelligence Database Created';
PRINT 'Schema Created : manufacturing';
PRINT 'Database is Ready.';
PRINT '=====================================================';
GO
