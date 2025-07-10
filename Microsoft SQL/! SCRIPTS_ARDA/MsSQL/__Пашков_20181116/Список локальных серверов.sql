--Список локальных серверов

IF OBJECT_ID (N'tempdb..#TmpName', N'U') IS NOT NULL DROP TABLE #TmpName
Create table #TmpName 
(	
[ID] [int] IDENTITY(1,1) NOT NULL,
[CRID] [int] NULL,
[ServerName] [nvarchar](max) NULL,
[Notes] [nvarchar](200) NULL,
)

INSERT #TmpName ([CRID],[ServerName])
          select 501, '[S-MARKETA].[ElitV_DP].[dbo].' 
union all select 401, '[192.168.22.21].[ElitRTS401].[dbo].'
union all select 302, '[192.168.157.22].[ElitRTS302].[dbo].'
union all select 301, '[S-MARKETA3].[ElitRTS301].[dbo].'
union all select 220, '[192.168.174.38].[ElitRTS220].[dbo].'
union all select 201, '[192.168.174.30].[ElitRTS201].[dbo].'
union all select 181, '[S-MARKETA4].[ElitRTS181].[dbo].'

SELECT * FROM #TmpName
/*
--изменение размера округления в локальных базах
DECLARE @ServerName nvarchar(max)
DECLARE @SQL nvarchar(max)
DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD
FOR 
SELECT [ServerName] FROM #TmpName GROUP BY [ServerName] 

OPEN CURSOR1
	FETCH NEXT FROM CURSOR1 INTO @ServerName
WHILE @@FETCH_STATUS = 0
BEGIN
	--Script
	SET @SQL = 'SELECT VarValue FROM ' + @ServerName + 'z_Vars WHERE  VarName = ''z_RoundPriceSale'''
	SELECT @ServerName, @SQL
    EXEC(@SQL)
    
	--SET @SQL = 'UPDATE ' + @ServerName + 'z_Vars SET VarValue = 0.01 WHERE  VarName = ''z_RoundPriceSale'''
	--SELECT @ServerName, @SQL
 --   EXEC(@SQL)	
	
	FETCH NEXT FROM CURSOR1 INTO @ServerName
END
CLOSE CURSOR1
DEALLOCATE CURSOR1
*/


/*
--добавление отчетов в ТК на локальных серверах
DECLARE @ServerName nvarchar(max)
DECLARE @SQL nvarchar(max)
DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD
FOR 
SELECT [ServerName] FROM #TmpName GROUP BY [ServerName] 

OPEN CURSOR1
	FETCH NEXT FROM CURSOR1 INTO @ServerName
WHILE @@FETCH_STATUS = 0
BEGIN
	--Script
	SET @SQL = 'SELECT VarValue FROM ' + @ServerName + 'z_Vars WHERE  VarName = ''z_RoundPriceSale'''
	SELECT @ServerName, @SQL
    EXEC(@SQL)
    
	--SET @SQL = 'UPDATE ' + @ServerName + 'z_Vars SET VarValue = 0.01 WHERE  VarName = ''z_RoundPriceSale'''
	--SELECT @ServerName, @SQL
	--EXEC(@SQL)	
	
	FETCH NEXT FROM CURSOR1 INTO @ServerName
END
CLOSE CURSOR1
DEALLOCATE CURSOR1
*/

INSERT [192.168.157.22].[ElitRTS302].[dbo].z_AppPrints 
SELECT * FROM ElitR_test.dbo.z_AppPrints
WHERE  AppCode =  11010