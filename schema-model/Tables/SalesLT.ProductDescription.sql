CREATE TABLE [SalesLT].[ProductDescription]
(
[ProductDescriptionID] [int] NOT NULL IDENTITY(1, 1),
[Description] [nvarchar] (400) NOT NULL,
[rowguid] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF_ProductDescription_rowguid] DEFAULT (newid()),
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_ProductDescription_ModifiedDate] DEFAULT (getdate())
)
GO
ALTER TABLE [SalesLT].[ProductDescription] ADD CONSTRAINT [PK_ProductDescription_ProductDescriptionID] PRIMARY KEY CLUSTERED ([ProductDescriptionID])
GO
ALTER TABLE [SalesLT].[ProductDescription] ADD CONSTRAINT [AK_ProductDescription_rowguid] UNIQUE NONCLUSTERED ([rowguid])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product descriptions in several languages.', 'SCHEMA', N'SalesLT', 'TABLE', N'ProductDescription', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Description of the product.', 'SCHEMA', N'SalesLT', 'TABLE', N'ProductDescription', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'SalesLT', 'TABLE', N'ProductDescription', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for ProductDescription records.', 'SCHEMA', N'SalesLT', 'TABLE', N'ProductDescription', 'COLUMN', N'ProductDescriptionID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', 'SCHEMA', N'SalesLT', 'TABLE', N'ProductDescription', 'COLUMN', N'rowguid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered constraint. Used to support replication samples.', 'SCHEMA', N'SalesLT', 'TABLE', N'ProductDescription', 'CONSTRAINT', N'AK_ProductDescription_rowguid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'SalesLT', 'TABLE', N'ProductDescription', 'CONSTRAINT', N'DF_ProductDescription_ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of NEWID()', 'SCHEMA', N'SalesLT', 'TABLE', N'ProductDescription', 'CONSTRAINT', N'DF_ProductDescription_rowguid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'SalesLT', 'TABLE', N'ProductDescription', 'CONSTRAINT', N'PK_ProductDescription_ProductDescriptionID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'SalesLT', 'TABLE', N'ProductDescription', 'INDEX', N'PK_ProductDescription_ProductDescriptionID'
GO
