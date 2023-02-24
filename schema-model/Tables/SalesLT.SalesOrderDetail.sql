CREATE TABLE [SalesLT].[SalesOrderDetail]
(
[SalesOrderID] [int] NOT NULL,
[SalesOrderDetailID] [int] NOT NULL IDENTITY(1, 1),
[OrderQty] [smallint] NOT NULL,
[ProductID] [int] NOT NULL,
[UnitPrice] [money] NOT NULL,
[UnitPriceDiscount] [money] NOT NULL CONSTRAINT [DF_SalesOrderDetail_UnitPriceDiscount] DEFAULT ((0.0)),
[LineTotal] AS (isnull(([UnitPrice]*((1.0)-[UnitPriceDiscount]))*[OrderQty],(0.0))),
[rowguid] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF_SalesOrderDetail_rowguid] DEFAULT (newid()),
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_SalesOrderDetail_ModifiedDate] DEFAULT (getdate())
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE TRIGGER [SalesLT].[iduSalesOrderDetail] ON [SalesLT].[SalesOrderDetail] 
AFTER INSERT, DELETE, UPDATE AS 
BEGIN
    DECLARE @Count int;

    SET @Count = @@ROWCOUNT;
    IF @Count = 0 
        RETURN;

    SET NOCOUNT ON;

    BEGIN TRY
        -- If inserting or updating these columns
        IF UPDATE([ProductID]) OR UPDATE([OrderQty]) OR UPDATE([UnitPrice]) OR UPDATE([UnitPriceDiscount]) 

        -- Update SubTotal in SalesOrderHeader record. Note that this causes the 
        -- SalesOrderHeader trigger to fire which will update the RevisionNumber.
        UPDATE [SalesLT].[SalesOrderHeader]
        SET [SalesLT].[SalesOrderHeader].[SubTotal] = 
            (SELECT SUM([SalesLT].[SalesOrderDetail].[LineTotal])
                FROM [SalesLT].[SalesOrderDetail]
                WHERE [SalesLT].[SalesOrderHeader].[SalesOrderID] = [SalesLT].[SalesOrderDetail].[SalesOrderID])
        WHERE [SalesLT].[SalesOrderHeader].[SalesOrderID] IN (SELECT inserted.[SalesOrderID] FROM inserted);

    END TRY
    BEGIN CATCH
        EXECUTE [dbo].[uspPrintError];

        -- Rollback any active or uncommittable transactions before
        -- inserting information in the ErrorLog
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE [dbo].[uspLogError];
    END CATCH;
END;
GO
ALTER TABLE [SalesLT].[SalesOrderDetail] ADD CONSTRAINT [CK_SalesOrderDetail_OrderQty] CHECK (([OrderQty]>(0)))
GO
ALTER TABLE [SalesLT].[SalesOrderDetail] ADD CONSTRAINT [CK_SalesOrderDetail_UnitPrice] CHECK (([UnitPrice]>=(0.00)))
GO
ALTER TABLE [SalesLT].[SalesOrderDetail] ADD CONSTRAINT [CK_SalesOrderDetail_UnitPriceDiscount] CHECK (([UnitPriceDiscount]>=(0.00)))
GO
ALTER TABLE [SalesLT].[SalesOrderDetail] ADD CONSTRAINT [PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailID] PRIMARY KEY CLUSTERED ([SalesOrderID], [SalesOrderDetailID])
GO
CREATE NONCLUSTERED INDEX [IX_SalesOrderDetail_ProductID] ON [SalesLT].[SalesOrderDetail] ([ProductID])
GO
ALTER TABLE [SalesLT].[SalesOrderDetail] ADD CONSTRAINT [AK_SalesOrderDetail_rowguid] UNIQUE NONCLUSTERED ([rowguid])
GO
ALTER TABLE [SalesLT].[SalesOrderDetail] ADD CONSTRAINT [FK_SalesOrderDetail_Product_ProductID] FOREIGN KEY ([ProductID]) REFERENCES [SalesLT].[Product] ([ProductID])
GO
ALTER TABLE [SalesLT].[SalesOrderDetail] ADD CONSTRAINT [FK_SalesOrderDetail_SalesOrderHeader_SalesOrderID] FOREIGN KEY ([SalesOrderID]) REFERENCES [SalesLT].[SalesOrderHeader] ([SalesOrderID]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'Individual products associated with a specific sales order. See SalesOrderHeader.', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderDetail', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Per product subtotal. Computed as UnitPrice * (1 - UnitPriceDiscount) * OrderQty.', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderDetail', 'COLUMN', N'LineTotal'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderDetail', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Quantity ordered per product.', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderDetail', 'COLUMN', N'OrderQty'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product sold to customer. Foreign key to Product.ProductID.', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderDetail', 'COLUMN', N'ProductID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderDetail', 'COLUMN', N'rowguid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key. One incremental unique number per product sold.', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderDetail', 'COLUMN', N'SalesOrderDetailID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key. Foreign key to SalesOrderHeader.SalesOrderID.', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderDetail', 'COLUMN', N'SalesOrderID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Selling price of a single product.', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderDetail', 'COLUMN', N'UnitPrice'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Discount amount.', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderDetail', 'COLUMN', N'UnitPriceDiscount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered constraint. Used to support replication samples.', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderDetail', 'CONSTRAINT', N'AK_SalesOrderDetail_rowguid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [OrderQty] > (0)', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderDetail', 'CONSTRAINT', N'CK_SalesOrderDetail_OrderQty'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [UnitPrice] >= (0.00)', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderDetail', 'CONSTRAINT', N'CK_SalesOrderDetail_UnitPrice'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [UnitPriceDiscount] >= (0.00)', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderDetail', 'CONSTRAINT', N'CK_SalesOrderDetail_UnitPriceDiscount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderDetail', 'CONSTRAINT', N'DF_SalesOrderDetail_ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of NEWID()', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderDetail', 'CONSTRAINT', N'DF_SalesOrderDetail_rowguid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 0.0', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderDetail', 'CONSTRAINT', N'DF_SalesOrderDetail_UnitPriceDiscount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing SalesOrderHeader.SalesOrderID.', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderDetail', 'CONSTRAINT', N'FK_SalesOrderDetail_SalesOrderHeader_SalesOrderID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderDetail', 'CONSTRAINT', N'PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nonclustered index.', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderDetail', 'INDEX', N'IX_SalesOrderDetail_ProductID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderDetail', 'INDEX', N'PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailID'
GO
