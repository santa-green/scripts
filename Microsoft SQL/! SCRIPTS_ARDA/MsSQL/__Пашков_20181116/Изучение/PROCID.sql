IF OBJECT_ID ( 'usp_FindName', 'P' ) IS NOT NULL 
DROP PROCEDURE usp_FindName;
GO
CREATE PROCEDURE usp_FindName
    @lastname varchar(40) = '%', 
    @firstname varchar(20) = '%'
AS
DECLARE @Count char(2);
DECLARE @ProcName nvarchar(128);
SELECT *
FROM r_DBIs;
SET @Count = (SELECT top 1 type FROM sys.sysobjects where id = @@PROCID);
select @@PROCID
SET @ProcName = OBJECT_NAME(@@PROCID);
RAISERROR ('Stored procedure %s returned %s rows. ', 16,10, @ProcName, @Count);
GO
EXECUTE dbo.usp_FindName 'P%', 'A%';



SELECT top 1 type FROM sys.sysobjects where id =234704880

SELECT * FROM sys.sysobjects where name ='usp_FindName'


select OBJECT_DEFINITION(234704880) 


SELECT name,type, OBJECT_DEFINITION(id) FROM sys.sysobjects where type in ('TR','p','FN') and OBJECT_DEFINITION(id) like '%RAISERROR%' ORDER BY 1
SELECT name,type, OBJECT_DEFINITION(id) FROM sys.sysobjects where type in ('TR','p','FN') and OBJECT_DEFINITION(id) like '%RAISERROR(''%' ORDER BY 1
SELECT name,type, OBJECT_DEFINITION(id) FROM sys.sysobjects where type in ('TR','p','FN') and OBJECT_DEFINITION(id) like '%RAISERROR (''%' ORDER BY 1
SELECT name,type, OBJECT_DEFINITION(id) FROM sys.sysobjects where type in ('TR','p','FN') and OBJECT_DEFINITION(id) like '%RAISERROR(%' ORDER BY 1

SELECT name,type, OBJECT_DEFINITION(id) FROM sys.sysobjects where type in ('TR','p','FN') and OBJECT_DEFINITION(id) like '%z_RelationErrorUni%' ORDER BY 1

z_RelationErrorUni

TRel1_Ins_at_t_IORes


SELECT *
FROM sys.sql_modules m
INNER JOIN sys.objects o
ON m.object_id = o.object_id

SELECT * FROM sys.sql_modules where object_id = 234704880

SELECT * FROM sys.objects where object_id = 234704880