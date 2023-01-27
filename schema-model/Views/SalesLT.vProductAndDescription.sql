SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [SalesLT].[vProductAndDescription] 
WITH SCHEMABINDING 
AS 
-- View (indexed or standard) to display products and product descriptions by language.
SELECT 
    p.[ProductID] 
    ,p.[Name] 
    ,pm.[Name] AS [ProductModel] 
    ,pmx.[Culture] 
    ,pd.[Description] 
FROM [SalesLT].[Product] p 
    INNER JOIN [SalesLT].[ProductModel] pm 
    ON p.[ProductModelID] = pm.[ProductModelID] 
    INNER JOIN [SalesLT].[ProductModelProductDescription] pmx 
    ON pm.[ProductModelID] = pmx.[ProductModelID] 
    INNER JOIN [SalesLT].[ProductDescription] pd 
    ON pmx.[ProductDescriptionID] = pd.[ProductDescriptionID];
GO
CREATE UNIQUE CLUSTERED INDEX [IX_vProductAndDescription] ON [SalesLT].[vProductAndDescription] ([Culture], [ProductID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product names and descriptions. Product descriptions are provided in multiple languages.', 'SCHEMA', N'SalesLT', 'VIEW', N'vProductAndDescription', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index on the view vProductAndDescription.', 'SCHEMA', N'SalesLT', 'VIEW', N'vProductAndDescription', 'INDEX', N'IX_vProductAndDescription'
GO
