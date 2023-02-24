SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS, NOCOUNT ON
GO
SET DATEFORMAT YMD
GO
SET XACT_ABORT ON
GO

PRINT(N'Update 6 rows in [SalesLT].[Customer]')
UPDATE [SalesLT].[Customer] SET [Suffix]=NULL WHERE [CustomerID] = 1
UPDATE [SalesLT].[Customer] SET [Suffix]=NULL WHERE [CustomerID] = 2
UPDATE [SalesLT].[Customer] SET [Suffix]=NULL WHERE [CustomerID] = 3
UPDATE [SalesLT].[Customer] SET [Suffix]=NULL WHERE [CustomerID] = 4
UPDATE [SalesLT].[Customer] SET [Suffix]=NULL WHERE [CustomerID] = 5
UPDATE [SalesLT].[Customer] SET [Suffix]=NULL WHERE [CustomerID] = 6

