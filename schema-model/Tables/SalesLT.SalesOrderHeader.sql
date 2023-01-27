CREATE TABLE [SalesLT].[SalesOrderHeader]
(
[SalesOrderID] [int] NOT NULL IDENTITY(1, 1),
[RevisionNumber] [tinyint] NOT NULL CONSTRAINT [DF_SalesOrderHeader_RevisionNumber] DEFAULT ((0)),
[OrderDate] [datetime] NOT NULL CONSTRAINT [DF_SalesOrderHeader_OrderDate] DEFAULT (getdate()),
[DueDate] [datetime] NOT NULL,
[ShipDate] [datetime] NULL,
[Status] [tinyint] NOT NULL CONSTRAINT [DF_SalesOrderHeader_Status] DEFAULT ((1)),
[OnlineOrderFlag] [dbo].[Flag] NOT NULL CONSTRAINT [DF_SalesOrderHeader_OnlineOrderFlag] DEFAULT ((1)),
[SalesOrderNumber] AS (isnull(N'SO'+CONVERT([nvarchar](23),[SalesOrderID],(0)),N'*** ERROR ***')),
[PurchaseOrderNumber] [dbo].[OrderNumber] NULL,
[AccountNumber] [dbo].[AccountNumber] NULL,
[CustomerID] [int] NOT NULL,
[ShipToAddressID] [int] NULL,
[BillToAddressID] [int] NULL,
[ShipMethod] [nvarchar] (50) NOT NULL,
[CreditCardApprovalCode] [varchar] (15) NULL,
[SubTotal] [money] NOT NULL CONSTRAINT [DF_SalesOrderHeader_SubTotal] DEFAULT ((0.00)),
[TaxAmt] [money] NOT NULL CONSTRAINT [DF_SalesOrderHeader_TaxAmt] DEFAULT ((0.00)),
[Freight] [money] NOT NULL CONSTRAINT [DF_SalesOrderHeader_Freight] DEFAULT ((0.00)),
[TotalDue] AS (isnull(([SubTotal]+[TaxAmt])+[Freight],(0))),
[Comment] [nvarchar] (max) NULL,
[rowguid] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF_SalesOrderHeader_rowguid] DEFAULT (newid()),
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_SalesOrderHeader_ModifiedDate] DEFAULT (getdate())
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE TRIGGER [SalesLT].[uSalesOrderHeader] ON [SalesLT].[SalesOrderHeader] 
AFTER UPDATE AS 
BEGIN
    DECLARE @Count int;

    SET @Count = @@ROWCOUNT;
    IF @Count = 0 
        RETURN;

    SET NOCOUNT ON;

    BEGIN TRY
        -- Update RevisionNumber for modification of any field EXCEPT the Status.
        IF NOT (UPDATE([Status]) OR UPDATE([RevisionNumber]))
        BEGIN
            UPDATE [SalesLT].[SalesOrderHeader]
            SET [SalesLT].[SalesOrderHeader].[RevisionNumber] = 
                [SalesLT].[SalesOrderHeader].[RevisionNumber] + 1
            WHERE [SalesLT].[SalesOrderHeader].[SalesOrderID] IN 
                (SELECT inserted.[SalesOrderID] FROM inserted);
        END;
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
ALTER TABLE [SalesLT].[SalesOrderHeader] ADD CONSTRAINT [CK_SalesOrderHeader_DueDate] CHECK (([DueDate]>=[OrderDate]))
GO
ALTER TABLE [SalesLT].[SalesOrderHeader] ADD CONSTRAINT [CK_SalesOrderHeader_Freight] CHECK (([Freight]>=(0.00)))
GO
ALTER TABLE [SalesLT].[SalesOrderHeader] ADD CONSTRAINT [CK_SalesOrderHeader_ShipDate] CHECK (([ShipDate]>=[OrderDate] OR [ShipDate] IS NULL))
GO
ALTER TABLE [SalesLT].[SalesOrderHeader] ADD CONSTRAINT [CK_SalesOrderHeader_Status] CHECK (([Status]>=(0) AND [Status]<=(8)))
GO
ALTER TABLE [SalesLT].[SalesOrderHeader] ADD CONSTRAINT [CK_SalesOrderHeader_SubTotal] CHECK (([SubTotal]>=(0.00)))
GO
ALTER TABLE [SalesLT].[SalesOrderHeader] ADD CONSTRAINT [CK_SalesOrderHeader_TaxAmt] CHECK (([TaxAmt]>=(0.00)))
GO
ALTER TABLE [SalesLT].[SalesOrderHeader] ADD CONSTRAINT [PK_SalesOrderHeader_SalesOrderID] PRIMARY KEY CLUSTERED ([SalesOrderID])
GO
CREATE NONCLUSTERED INDEX [IX_SalesOrderHeader_CustomerID] ON [SalesLT].[SalesOrderHeader] ([CustomerID])
GO
ALTER TABLE [SalesLT].[SalesOrderHeader] ADD CONSTRAINT [AK_SalesOrderHeader_rowguid] UNIQUE NONCLUSTERED ([rowguid])
GO
ALTER TABLE [SalesLT].[SalesOrderHeader] ADD CONSTRAINT [AK_SalesOrderHeader_SalesOrderNumber] UNIQUE NONCLUSTERED ([SalesOrderNumber])
GO
ALTER TABLE [SalesLT].[SalesOrderHeader] ADD CONSTRAINT [FK_SalesOrderHeader_Address_BillTo_AddressID] FOREIGN KEY ([BillToAddressID]) REFERENCES [SalesLT].[Address] ([AddressID])
GO
ALTER TABLE [SalesLT].[SalesOrderHeader] ADD CONSTRAINT [FK_SalesOrderHeader_Address_ShipTo_AddressID] FOREIGN KEY ([ShipToAddressID]) REFERENCES [SalesLT].[Address] ([AddressID])
GO
ALTER TABLE [SalesLT].[SalesOrderHeader] ADD CONSTRAINT [FK_SalesOrderHeader_Customer_CustomerID] FOREIGN KEY ([CustomerID]) REFERENCES [SalesLT].[Customer] ([CustomerID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'General sales order information.', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Financial accounting number reference.', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'AccountNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The ID of the location to send invoices.  Foreign key to the Address table.', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'BillToAddressID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sales representative comments.', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'Comment'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Approval code provided by the credit card company.', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'CreditCardApprovalCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer identification number. Foreign key to Customer.CustomerID.', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'CustomerID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date the order is due to the customer.', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'DueDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Shipping cost.', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'Freight'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'0 = Order placed by sales person. 1 = Order placed online by customer.', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'OnlineOrderFlag'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dates the sales order was created.', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'OrderDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer purchase order number reference. ', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'PurchaseOrderNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Incremental number to track changes to the sales order over time.', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'RevisionNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'rowguid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key.', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'SalesOrderID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique sales order identification number.', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'SalesOrderNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date the order was shipped to the customer.', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'ShipDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Shipping method. Foreign key to ShipMethod.ShipMethodID.', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'ShipMethod'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The ID of the location to send goods.  Foreign key to the Address table.', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'ShipToAddressID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Order current status. 1 = In process; 2 = Approved; 3 = Backordered; 4 = Rejected; 5 = Shipped; 6 = Cancelled', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'Status'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sales subtotal. Computed as SUM(SalesOrderDetail.LineTotal)for the appropriate SalesOrderID.', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'SubTotal'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tax amount.', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'TaxAmt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total due from customer. Computed as Subtotal + TaxAmt + Freight.', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'TotalDue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered constraint. Used to support replication samples.', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'AK_SalesOrderHeader_rowguid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered constraint.', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'AK_SalesOrderHeader_SalesOrderNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [DueDate] >= [OrderDate]', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'CK_SalesOrderHeader_DueDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [Freight] >= (0.00)', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'CK_SalesOrderHeader_Freight'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [ShipDate] >= [OrderDate] OR [ShipDate] IS NULL', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'CK_SalesOrderHeader_ShipDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [Status] BETWEEN (0) AND (8)', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'CK_SalesOrderHeader_Status'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [SubTotal] >= (0.00)', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'CK_SalesOrderHeader_SubTotal'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [TaxAmt] >= (0.00)', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'CK_SalesOrderHeader_TaxAmt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 0.0', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'DF_SalesOrderHeader_Freight'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'DF_SalesOrderHeader_ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 1 (TRUE)', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'DF_SalesOrderHeader_OnlineOrderFlag'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'DF_SalesOrderHeader_OrderDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 0', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'DF_SalesOrderHeader_RevisionNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of NEWID()', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'DF_SalesOrderHeader_rowguid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 1', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'DF_SalesOrderHeader_Status'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 0.0', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'DF_SalesOrderHeader_SubTotal'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 0.0', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'DF_SalesOrderHeader_TaxAmt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Address.AddressID for BillTo.', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'FK_SalesOrderHeader_Address_BillTo_AddressID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Address.AddressID for ShipTo.', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'FK_SalesOrderHeader_Address_ShipTo_AddressID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Customer.CustomerID.', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'FK_SalesOrderHeader_Customer_CustomerID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'PK_SalesOrderHeader_SalesOrderID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nonclustered index.', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'INDEX', N'IX_SalesOrderHeader_CustomerID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'INDEX', N'PK_SalesOrderHeader_SalesOrderID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'AFTER UPDATE trigger that updates the RevisionNumber and ModifiedDate columns in the SalesOrderHeader table.', 'SCHEMA', N'SalesLT', 'TABLE', N'SalesOrderHeader', 'TRIGGER', N'uSalesOrderHeader'
GO
