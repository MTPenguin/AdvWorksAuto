CREATE TABLE [SalesLT].[Product]
(
[ProductID] [int] NOT NULL IDENTITY(1, 1),
[Name] [dbo].[Name] NOT NULL,
[ProductNumber] [nvarchar] (25) NOT NULL,
[Color] [nvarchar] (15) NULL,
[StandardCost] [money] NOT NULL,
[ListPrice] [money] NOT NULL,
[Size] [nvarchar] (5) NULL,
[Weight] [decimal] (8, 2) NULL,
[ProductCategoryID] [int] NULL,
[ProductModelID] [int] NULL,
[SellStartDate] [datetime] NOT NULL,
[SellEndDate] [datetime] NULL,
[DiscontinuedDate] [datetime] NULL,
[ThumbNailPhoto] [varbinary] (max) NULL,
[ThumbnailPhotoFileName] [nvarchar] (50) NULL,
[rowguid] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF_Product_rowguid] DEFAULT (newid()),
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_Product_ModifiedDate] DEFAULT (getdate())
)
GO
ALTER TABLE [SalesLT].[Product] ADD CONSTRAINT [CK_Product_ListPrice] CHECK (([ListPrice]>=(0.00)))
GO
ALTER TABLE [SalesLT].[Product] ADD CONSTRAINT [CK_Product_SellEndDate] CHECK (([SellEndDate]>=[SellStartDate] OR [SellEndDate] IS NULL))
GO
ALTER TABLE [SalesLT].[Product] ADD CONSTRAINT [CK_Product_StandardCost] CHECK (([StandardCost]>=(0.00)))
GO
ALTER TABLE [SalesLT].[Product] ADD CONSTRAINT [CK_Product_Weight] CHECK (([Weight]>(0.00)))
GO
ALTER TABLE [SalesLT].[Product] ADD CONSTRAINT [PK_Product_ProductID] PRIMARY KEY CLUSTERED ([ProductID])
GO
ALTER TABLE [SalesLT].[Product] ADD CONSTRAINT [AK_Product_Name] UNIQUE NONCLUSTERED ([Name])
GO
ALTER TABLE [SalesLT].[Product] ADD CONSTRAINT [AK_Product_ProductNumber] UNIQUE NONCLUSTERED ([ProductNumber])
GO
ALTER TABLE [SalesLT].[Product] ADD CONSTRAINT [AK_Product_rowguid] UNIQUE NONCLUSTERED ([rowguid])
GO
ALTER TABLE [SalesLT].[Product] ADD CONSTRAINT [FK_Product_ProductCategory_ProductCategoryID] FOREIGN KEY ([ProductCategoryID]) REFERENCES [SalesLT].[ProductCategory] ([ProductCategoryID])
GO
ALTER TABLE [SalesLT].[Product] ADD CONSTRAINT [FK_Product_ProductModel_ProductModelID] FOREIGN KEY ([ProductModelID]) REFERENCES [SalesLT].[ProductModel] ([ProductModelID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Products sold or used in the manfacturing of sold products.', 'SCHEMA', N'SalesLT', 'TABLE', N'Product', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product color.', 'SCHEMA', N'SalesLT', 'TABLE', N'Product', 'COLUMN', N'Color'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date the product was discontinued.', 'SCHEMA', N'SalesLT', 'TABLE', N'Product', 'COLUMN', N'DiscontinuedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Selling price.', 'SCHEMA', N'SalesLT', 'TABLE', N'Product', 'COLUMN', N'ListPrice'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'SalesLT', 'TABLE', N'Product', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of the product.', 'SCHEMA', N'SalesLT', 'TABLE', N'Product', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product is a member of this product category. Foreign key to ProductCategory.ProductCategoryID. ', 'SCHEMA', N'SalesLT', 'TABLE', N'Product', 'COLUMN', N'ProductCategoryID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for Product records.', 'SCHEMA', N'SalesLT', 'TABLE', N'Product', 'COLUMN', N'ProductID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product is a member of this product model. Foreign key to ProductModel.ProductModelID.', 'SCHEMA', N'SalesLT', 'TABLE', N'Product', 'COLUMN', N'ProductModelID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique product identification number.', 'SCHEMA', N'SalesLT', 'TABLE', N'Product', 'COLUMN', N'ProductNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', 'SCHEMA', N'SalesLT', 'TABLE', N'Product', 'COLUMN', N'rowguid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date the product was no longer available for sale.', 'SCHEMA', N'SalesLT', 'TABLE', N'Product', 'COLUMN', N'SellEndDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date the product was available for sale.', 'SCHEMA', N'SalesLT', 'TABLE', N'Product', 'COLUMN', N'SellStartDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product size.', 'SCHEMA', N'SalesLT', 'TABLE', N'Product', 'COLUMN', N'Size'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Standard cost of the product.', 'SCHEMA', N'SalesLT', 'TABLE', N'Product', 'COLUMN', N'StandardCost'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Small image of the product.', 'SCHEMA', N'SalesLT', 'TABLE', N'Product', 'COLUMN', N'ThumbNailPhoto'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Small image file name.', 'SCHEMA', N'SalesLT', 'TABLE', N'Product', 'COLUMN', N'ThumbnailPhotoFileName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product weight.', 'SCHEMA', N'SalesLT', 'TABLE', N'Product', 'COLUMN', N'Weight'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered constraint.', 'SCHEMA', N'SalesLT', 'TABLE', N'Product', 'CONSTRAINT', N'AK_Product_Name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered constraint.', 'SCHEMA', N'SalesLT', 'TABLE', N'Product', 'CONSTRAINT', N'AK_Product_ProductNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered constraint. Used to support replication samples.', 'SCHEMA', N'SalesLT', 'TABLE', N'Product', 'CONSTRAINT', N'AK_Product_rowguid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [ListPrice] >= (0.00)', 'SCHEMA', N'SalesLT', 'TABLE', N'Product', 'CONSTRAINT', N'CK_Product_ListPrice'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [SellEndDate] >= [SellStartDate] OR [SellEndDate] IS NULL', 'SCHEMA', N'SalesLT', 'TABLE', N'Product', 'CONSTRAINT', N'CK_Product_SellEndDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [Weight] > (0.00)', 'SCHEMA', N'SalesLT', 'TABLE', N'Product', 'CONSTRAINT', N'CK_Product_Weight'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'SalesLT', 'TABLE', N'Product', 'CONSTRAINT', N'DF_Product_ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of NEWID()', 'SCHEMA', N'SalesLT', 'TABLE', N'Product', 'CONSTRAINT', N'DF_Product_rowguid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing ProductCategory.ProductCategoryID.', 'SCHEMA', N'SalesLT', 'TABLE', N'Product', 'CONSTRAINT', N'FK_Product_ProductCategory_ProductCategoryID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing ProductModel.ProductModelID.', 'SCHEMA', N'SalesLT', 'TABLE', N'Product', 'CONSTRAINT', N'FK_Product_ProductModel_ProductModelID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'SalesLT', 'TABLE', N'Product', 'CONSTRAINT', N'PK_Product_ProductID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'SalesLT', 'TABLE', N'Product', 'INDEX', N'PK_Product_ProductID'
GO
