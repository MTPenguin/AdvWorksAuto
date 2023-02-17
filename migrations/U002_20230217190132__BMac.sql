SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
PRINT N'Creating schemas'
GO
IF SCHEMA_ID(N'flyway') IS NULL
EXEC sp_executesql N'CREATE SCHEMA [flyway]
AUTHORIZATION [dbo]'
GO
PRINT N'Dropping extended properties'
GO
EXEC sp_dropextendedproperty N'MS_Description', 'SCHEMA', N'SalesLT', 'TABLE', N'Customer', 'CONSTRAINT', N'DF_Customer_ModifiedDate'
GO
EXEC sp_dropextendedproperty N'MS_Description', 'SCHEMA', N'SalesLT', 'TABLE', N'Customer', 'CONSTRAINT', N'DF_Customer_NameStyle'
GO
EXEC sp_dropextendedproperty N'MS_Description', 'SCHEMA', N'SalesLT', 'TABLE', N'Customer', 'CONSTRAINT', N'DF_Customer_rowguid'
GO
EXEC sp_dropextendedproperty N'MS_Description', 'SCHEMA', N'SalesLT', 'TABLE', N'Customer', 'INDEX', N'PK_Customer_CustomerID'
GO
EXEC sp_dropextendedproperty N'MS_Description', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'FK_SalesOrderHeader_Customer_CustomerID'
GO
PRINT N'Dropping foreign keys from [SalesLT].[SalesOrderHeader]'
GO
ALTER TABLE [SalesLT].[SalesOrderHeader] DROP CONSTRAINT [FK_SalesOrderHeader_Customer_CustomerID]
GO
PRINT N'Altering [SalesLT].[Customer]'
GO
ALTER TABLE [SalesLT].[Customer] DROP
COLUMN [New2]
GO
PRINT N'Altering extended properties'
GO
EXEC sp_updateextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'SalesLT', 'TABLE', N'Customer', 'CONSTRAINT', N'PK_Customer_CustomerID'
GO

