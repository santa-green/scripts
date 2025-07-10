--—писок локальных серверов
--проверка разницы данных в строках между главной базой и локальными
set nocount on

IF OBJECT_ID (N'tempdb..#TmpName', N'U') IS NOT NULL DROP TABLE #TmpName
Create table #TmpName 
(	
[ID] [int] IDENTITY(1,1) NOT NULL,
[CRID] [int] NULL,
[ServerName] [nvarchar](max) NULL,
[Notes] [nvarchar](200) NULL,
)

IF OBJECT_ID (N'tempdb..#TmpResult', N'U') IS NOT NULL DROP TABLE #TmpResult
Create table #TmpResult 
(	
[ID] [int] IDENTITY(1,1) NOT NULL,
[Result] [nvarchar](max) NULL,
[EXCEPT] [int] NULL,
)


INSERT #TmpName ([CRID],[ServerName])
          select 501, '[S-MARKETA].[ElitV_DP].[dbo].' 
union all select 302, '[192.168.157.22].[ElitRTS302].[dbo].'
union all select 301, '[S-MARKETA3].[ElitRTS301].[dbo].'
union all select 220, '[192.168.174.38].[ElitRTS220].[dbo].'
union all select 201, '[192.168.174.30].[ElitRTS201].[dbo].'
union all select 181, '[S-MARKETA4].[ElitRTS181].[dbo].'
union all select 601, '[192.168.42.6].FFood601.dbo.'

--SELECT * FROM #TmpName


--проверка разницы в строках между главной базой и локальными
DECLARE @ServerName nvarchar(max)
DECLARE @SQL nvarchar(max)
DECLARE @TableName nvarchar(200)
DECLARE @MsgOUT nvarchar(200)
DECLARE @EFilterExp nvarchar(max)
DECLARE @result int

DECLARE @pos INT = 0, @DateShow DATETIME  = GETDATE(), @DateStart DATETIME = GETDATE(), @p INT = 0,@ToEnd INT = 0, @t INT = 0, @Msg varchar(200) = null, @p100 INT = 0

DECLARE CURSOR1 CURSOR STATIC
FOR 
SELECT [ServerName] FROM #TmpName GROUP BY [ServerName] 

OPEN CURSOR1
	FETCH NEXT FROM CURSOR1 INTO @ServerName
WHILE @@FETCH_STATUS = 0
BEGIN
	--Script
	SELECT @pos = 0, @DateShow = GETDATE(), @DateStart = GETDATE(), @p = 0, @ToEnd = 0, @t = 0, @Msg = null, @p100 = 0
	RAISERROR ('-------------ѕроверка сервера %s ', 10,1,@ServerName) WITH NOWAIT

	DECLARE CURSOR2 CURSOR STATIC
	FOR 
	SELECT TableName, EFilterExp FROM z_Tables,z_ReplicaTables WHERE z_Tables.TableCode = z_ReplicaTables.TableCode and ReplicaPubCode = 12 
	--and TableName in ('r_Codes1','t_PInP')
	ORDER BY 1

	OPEN CURSOR2
		FETCH NEXT FROM CURSOR2 INTO @TableName,@EFilterExp
	WHILE @@FETCH_STATUS = 0
	BEGIN
		--Script
		SET @SQL = 'SELECT  @out = ''' + @TableName + ''' + char(9) + ''' + @ServerName + @TableName + ''' + char(9) + ''='' + char(9) +   CAST(COUNT(*) as varchar(20))' +
					' FROM (
					  SELECT * FROM ' + @TableName + ' WITH (NOLOCK) ' + isnull(' WHERE ' + @EFilterExp , '') + char(10) + char(13) +
					' EXCEPT
					  SELECT * FROM ' + @ServerName + @TableName + '  WITH (NOLOCK) '  + isnull(' WHERE ' + @EFilterExp , '') +
					' ) m'

		--PRINT @SQL

		EXEC sp_executesql @SQL, N'@out VARCHAR(200) OUT', @MsgOUT OUT

		--PRINT @MsgOUT

		INSERT #TmpResult ([Result]) values (@MsgOUT)

		--CURSOR STATIC
------------------------------------------------------------------------------		
	IF @pos = 0 SET @p100 = @@CURSOR_ROWS	
	SET @pos = @pos + 1
	IF  DATEDIFF ( second , @DateShow , Cast (GETDATE() as DATETIME) ) >= 5 
	BEGIN
		SET @DateShow =  GETDATE()
		SET @p = (@pos*100)/@p100
		IF @p = 0 SET @p = 1
		SET @t = DATEDIFF ( second , @DateStart , Cast (GETDATE() as DATETIME) )
		SET @ToEnd = (100 - @p) * @t / @p  
		SET @Msg = CONVERT( varchar, GETDATE(), 121)  
		RAISERROR ('¬ыполнено %u процентов за  %u сек. ќсталось = %u сек.', 10,1,@p,@t,@ToEnd) WITH NOWAIT
	END	
------------------------------------------------------------------------------



		FETCH NEXT FROM CURSOR2 INTO @TableName,@EFilterExp
	END
	CLOSE CURSOR2
	DEALLOCATE CURSOR2
		
	FETCH NEXT FROM CURSOR1 INTO @ServerName
END
CLOSE CURSOR1
DEALLOCATE CURSOR1

SELECT cast(ID as varchar) + char(9) +  Result FROM #TmpResult where  Result not like '%=	0'

SELECT Result FROM #TmpResult where  Result not like '%=	0'

/*
IF 1=0
BEGIN
	--изменение объектов в локальных базах
	DECLARE @ServerName nvarchar(max)
	DECLARE @SQL nvarchar(max)
	DECLARE @result int
	DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD
	FOR 
	SELECT  STUFF (definition,CHARINDEX ('create',definition),6,'alter')  script FROM  sys.sql_modules m
	INNER JOIN sys.objects o
	ON m.object_id = o.object_id
	WHERE o.type != 'D'
	and o.name in ('tf_GetDCardInfo')
	--and o.name in ('ap_test')
	
	OPEN CURSOR1
		FETCH NEXT FROM CURSOR1 INTO @SQL
	WHILE @@FETCH_STATUS = 0
	BEGIN
		--Script
		--SELECT @SQL
		print @SQL

	IF 1=1
	BEGIN
		--insert #TmpName (notes)
		EXEC @result = [192.168.70.137].ElitRTS502.dbo.sp_executesql @SQL; SELECT @result '[192.168.70.137].ElitRTS502';
		
		EXEC @result = [S-MARKETA].[ElitV_DP].[dbo].sp_executesql @SQL; SELECT @result '[S-MARKETA].[ElitV_DP]'; 
		EXEC @result = [192.168.157.22].[ElitRTS302].[dbo].sp_executesql @SQL; SELECT @result '[192.168.157.22].[ElitRTS302]';
		EXEC @result = [S-MARKETA3].[ElitRTS301].[dbo].sp_executesql @SQL; SELECT @result '[S-MARKETA3].[ElitRTS301]';
		EXEC @result = [192.168.174.38].[ElitRTS220].[dbo].sp_executesql @SQL; SELECT @result '[192.168.174.38].[ElitRTS220]';
		EXEC @result = [192.168.174.30].[ElitRTS201].[dbo].sp_executesql @SQL; SELECT @result '[192.168.174.30].[ElitRTS201]';
		EXEC @result = [S-MARKETA4].[ElitRTS181].[dbo].sp_executesql @SQL; SELECT @result '[S-MARKETA4].[ElitRTS181]';
		EXEC @result = [192.168.42.6].FFood601.dbo.sp_executesql @SQL; SELECT @result '[192.168.42.6].FFood601';
	END
	
		FETCH NEXT FROM CURSOR1 INTO @SQL
	END
	CLOSE CURSOR1
	DEALLOCATE CURSOR1
	
END
*/




--SELECT * FROM #TmpName

--DECLARE @SQL2 nvarchar(max) = 'select 1;select 2'
--set @sql2 = (	SELECT  STUFF (definition,CHARINDEX ('create',definition),6,'alter') + '; select ''[192.168.70.137].ElitRTS502'''  script FROM  sys.sql_modules m
--	INNER JOIN sys.objects o
--	ON m.object_id = o.object_id
--	WHERE o.type != 'D'
--	--and o.name in ('tf_GetDCardInfo')
--	and o.name in ('ap_test')
--)
--insert INTO #TmpName (notes)
----exec [192.168.70.137].ElitRTS502.dbo.sp_executesql @SQL2
--exec sp_executesql @SQL2

--SELECT * FROM #TmpName

/*
--изменение размера округлени€ в локальных базах
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
--добавление отчетов в “  на локальных серверах
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

--INSERT [192.168.157.22].[ElitRTS302].[dbo].z_AppPrints 
--SELECT * FROM ElitR_test.dbo.z_AppPrints
--WHERE  AppCode =  11010