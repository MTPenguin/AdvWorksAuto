SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS, NOCOUNT ON
GO
SET DATEFORMAT YMD
GO
SET XACT_ABORT ON
GO

PRINT(N'Delete 8 rows from [SalesLT].[Customer]')
DELETE FROM [SalesLT].[Customer] WHERE [CustomerID] = 1
DELETE FROM [SalesLT].[Customer] WHERE [CustomerID] = 2
DELETE FROM [SalesLT].[Customer] WHERE [CustomerID] = 3
DELETE FROM [SalesLT].[Customer] WHERE [CustomerID] = 4
DELETE FROM [SalesLT].[Customer] WHERE [CustomerID] = 5
DELETE FROM [SalesLT].[Customer] WHERE [CustomerID] = 6
DELETE FROM [SalesLT].[Customer] WHERE [CustomerID] = 7
DELETE FROM [SalesLT].[Customer] WHERE [CustomerID] = 10



