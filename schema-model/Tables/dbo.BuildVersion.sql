CREATE TABLE [dbo].[BuildVersion]
(
[SystemInformationID] [tinyint] NOT NULL IDENTITY(1, 1),
[Database Version] [nvarchar] (25) NOT NULL,
[VersionDate] [datetime] NOT NULL,
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_BuildVersion_ModifiedDate] DEFAULT (getdate())
)
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current version number of the AdventureWorksLT 2012 sample database. ', 'SCHEMA', N'dbo', 'TABLE', N'BuildVersion', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Version number of the database in 9.yy.mm.dd.00 format.', 'SCHEMA', N'dbo', 'TABLE', N'BuildVersion', 'COLUMN', N'Database Version'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'dbo', 'TABLE', N'BuildVersion', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for BuildVersion records.', 'SCHEMA', N'dbo', 'TABLE', N'BuildVersion', 'COLUMN', N'SystemInformationID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'dbo', 'TABLE', N'BuildVersion', 'COLUMN', N'VersionDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'dbo', 'TABLE', N'BuildVersion', 'CONSTRAINT', N'DF_BuildVersion_ModifiedDate'
GO
