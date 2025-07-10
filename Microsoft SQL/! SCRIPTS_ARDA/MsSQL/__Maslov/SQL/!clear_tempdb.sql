USE [tempdb]
GO
DBCC SHRINKFILE (N'tempdev' , 3)
GO