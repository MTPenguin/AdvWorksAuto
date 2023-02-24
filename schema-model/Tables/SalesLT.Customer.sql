CREATE TABLE [SalesLT].[Customer]
(
[CustomerID] [int] NOT NULL IDENTITY(1, 1),
[NameStyle] [dbo].[NameStyle] NOT NULL CONSTRAINT [DF_Customer_NameStyle] DEFAULT ((0)),
[Title] [nvarchar] (8) NULL,
[FirstName] [dbo].[Name] NOT NULL,
[MiddleName] [dbo].[Name] NULL,
[LastName] [dbo].[Name] NOT NULL,
[Suffix] [nvarchar] (10) NULL,
[CompanyName] [nvarchar] (128) NULL,
[SalesPerson] [nvarchar] (256) NULL,
[EmailAddress] [nvarchar] (50) NULL,
[Phone] [dbo].[Phone] NULL,
[PasswordHash] [varchar] (128) NOT NULL,
[rowguid] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF_Customer_rowguid] DEFAULT (newid()),
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_Customer_ModifiedDate] DEFAULT (getdate()),
[New] [nchar] (10) NULL,
[PasswordSalt] [nchar] (10) NULL,
[New2] [nchar] (10) NULL
)
GO
ALTER TABLE [SalesLT].[Customer] ADD CONSTRAINT [PK_Customer_CustomerID] PRIMARY KEY CLUSTERED ([CustomerID])
GO
CREATE NONCLUSTERED INDEX [IX_Customer_EmailAddress] ON [SalesLT].[Customer] ([EmailAddress])
GO
ALTER TABLE [SalesLT].[Customer] ADD CONSTRAINT [AK_Customer_rowguid] UNIQUE NONCLUSTERED ([rowguid])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer information.', 'SCHEMA', N'SalesLT', 'TABLE', N'Customer', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The customer''s organization.', 'SCHEMA', N'SalesLT', 'TABLE', N'Customer', 'COLUMN', N'CompanyName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for Customer records.', 'SCHEMA', N'SalesLT', 'TABLE', N'Customer', 'COLUMN', N'CustomerID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'E-mail address for the person.', 'SCHEMA', N'SalesLT', 'TABLE', N'Customer', 'COLUMN', N'EmailAddress'
GO
EXEC sp_addextendedproperty N'MS_Description', N'First name of the person.', 'SCHEMA', N'SalesLT', 'TABLE', N'Customer', 'COLUMN', N'FirstName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Last name of the person.', 'SCHEMA', N'SalesLT', 'TABLE', N'Customer', 'COLUMN', N'LastName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Middle name or middle initial of the person.', 'SCHEMA', N'SalesLT', 'TABLE', N'Customer', 'COLUMN', N'MiddleName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'SalesLT', 'TABLE', N'Customer', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'0 = The data in FirstName and LastName are stored in western style (first name, last name) order.  1 = Eastern style (last name, first name) order.', 'SCHEMA', N'SalesLT', 'TABLE', N'Customer', 'COLUMN', N'NameStyle'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Password for the e-mail account.', 'SCHEMA', N'SalesLT', 'TABLE', N'Customer', 'COLUMN', N'PasswordHash'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Phone number associated with the person.', 'SCHEMA', N'SalesLT', 'TABLE', N'Customer', 'COLUMN', N'Phone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', 'SCHEMA', N'SalesLT', 'TABLE', N'Customer', 'COLUMN', N'rowguid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The customer''s sales person, an employee of AdventureWorks Cycles.', 'SCHEMA', N'SalesLT', 'TABLE', N'Customer', 'COLUMN', N'SalesPerson'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Surname suffix. For example, Sr. or Jr.', 'SCHEMA', N'SalesLT', 'TABLE', N'Customer', 'COLUMN', N'Suffix'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A courtesy title. For example, Mr. or Ms.', 'SCHEMA', N'SalesLT', 'TABLE', N'Customer', 'COLUMN', N'Title'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered constraint. Used to support replication samples.', 'SCHEMA', N'SalesLT', 'TABLE', N'Customer', 'CONSTRAINT', N'AK_Customer_rowguid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'SalesLT', 'TABLE', N'Customer', 'CONSTRAINT', N'DF_Customer_ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 0', 'SCHEMA', N'SalesLT', 'TABLE', N'Customer', 'CONSTRAINT', N'DF_Customer_NameStyle'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of NEWID()', 'SCHEMA', N'SalesLT', 'TABLE', N'Customer', 'CONSTRAINT', N'DF_Customer_rowguid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'SalesLT', 'TABLE', N'Customer', 'CONSTRAINT', N'PK_Customer_CustomerID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nonclustered index.', 'SCHEMA', N'SalesLT', 'TABLE', N'Customer', 'INDEX', N'IX_Customer_EmailAddress'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'SalesLT', 'TABLE', N'Customer', 'INDEX', N'PK_Customer_CustomerID'
GO
