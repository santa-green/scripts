-- сравнить объекты в базах
--set nocount on
--set nocount off

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
ServerName [nvarchar](max) NULL, name_ElitR [nvarchar](max) NULL, definition_ElitR [nvarchar](max) NULL,len_definition_ElitR int NULL, name [nvarchar](max) NULL, definition [nvarchar](max) NULL,len_definition int NULL
)


INSERT #TmpName ([CRID],[ServerName])
          select 501, '[S-MARKETA].[ElitV_DP].' 
union all select 302, '[192.168.157.22].[ElitRTS302].'
union all select 301, '[S-MARKETA3].[ElitRTS301].'
union all select 220, '[192.168.174.38].[ElitRTS220].'
union all select 201, '[192.168.174.30].[ElitRTS201].'
union all select 181, '[S-MARKETA4].[ElitRTS181].'
union all select 601, '[192.168.42.6].FFood601.'

--SELECT * FROM #TmpName


--проверка разницы в объектах между главной базой и локальными
DECLARE @ServerName nvarchar(max)
DECLARE @SQL nvarchar(max)
DECLARE @TableName nvarchar(200)
DECLARE @MsgOUT nvarchar(200)
DECLARE @EFilterExp nvarchar(max)
DECLARE @result int

DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD
FOR 
SELECT [ServerName] FROM #TmpName GROUP BY [ServerName] 

OPEN CURSOR1
	FETCH NEXT FROM CURSOR1 INTO @ServerName
WHILE @@FETCH_STATUS = 0
BEGIN
	--Script
	--DECLARE CURSOR2 CURSOR LOCAL FAST_FORWARD
	--FOR 
	--SELECT name, definition FROM  sys.sql_modules m INNER JOIN sys.objects o ON m.object_id = o.object_id	ORDER BY 1

	--OPEN CURSOR2
	--	FETCH NEXT FROM CURSOR2 INTO @TableName,@EFilterExp
	--WHILE @@FETCH_STATUS = 0
	--BEGIN
		--Script
		--SET @SQL = 'SELECT  @out = ''' + @TableName + ''' + char(9) + ''' + @ServerName + @TableName + ''' + char(9) + ''='' + char(9) +   CAST(COUNT(*) as varchar(20))' +
		--			' FROM (
		--			  SELECT * FROM ' + @TableName + ' WITH (NOLOCK) ' + isnull(' WHERE ' + @EFilterExp , '') + char(10) + char(13) +
		--			' EXCEPT
		--			  SELECT * FROM ' + @ServerName + @TableName + '  WITH (NOLOCK) '  + isnull(' WHERE ' + @EFilterExp , '') +
		--			' ) m'
		
	SET @SQL = 'SELECT '''+@ServerName+''' ServerName,o.name name_ElitR, m.definition definition_ElitR, len(m.definition) len_definition_ElitR,j.name, j.definition, len(j.definition) len_definition FROM  sys.sql_modules m INNER JOIN sys.objects o ON m.object_id = o.object_id
				full join (
				SELECT o.name, m.definition FROM  '+@ServerName+'sys.sql_modules m INNER JOIN '+@ServerName+'sys.objects o ON m.object_id = o.object_id	
				) j on j.name = o.name
				where isnull(m.definition, '''') <> isnull(j.definition, '''')
				/*and (j.definition is null or m.definition is null)*/'

		PRINT @SQL

		insert #TmpResult
		EXEC sp_executesql @SQL--, N'@out VARCHAR(200) OUT', @MsgOUT OUT

		--PRINT @MsgOUT

		--INSERT #TmpResult ([Result]) values (@MsgOUT)

	--	FETCH NEXT FROM CURSOR2 INTO @TableName,@EFilterExp
	--END
	--CLOSE CURSOR2
	--DEALLOCATE CURSOR2
		
	FETCH NEXT FROM CURSOR1 INTO @ServerName
END
CLOSE CURSOR1
DEALLOCATE CURSOR1

--SELECT cast(ID as varchar) + char(9) +  Result FROM #TmpResult where  Result not like '%=	0'

SELECT * FROM #TmpResult 
--where  
ORDER BY ServerName, name_ElitR, name



SELECT * FROM #TmpResult 
where not (
isnull(name_ElitR,'') in (SELECT 'TReplica_ins_'+TableName FROM z_Tables where TableCode in (SELECT TableCode FROM z_ReplicaTables where ReplicaPubCode = 12)) 
or isnull(name_ElitR,'') in (SELECT 'TReplica_upd_'+TableName FROM z_Tables where TableCode in (SELECT TableCode FROM z_ReplicaTables where ReplicaPubCode = 12)) 
or isnull(name_ElitR,'') in (SELECT 'TReplica_Del_'+TableName FROM z_Tables where TableCode in (SELECT TableCode FROM z_ReplicaTables where ReplicaPubCode = 12)) 
or isnull(name,'') in (SELECT 'TReplica_ins_'+TableName FROM z_Tables where TableCode in (SELECT TableCode FROM z_ReplicaTables where ReplicaPubCode = 1200000000)) 
or isnull(name,'') in (SELECT 'TReplica_upd_'+TableName FROM z_Tables where TableCode in (SELECT TableCode FROM z_ReplicaTables where ReplicaPubCode = 1200000000)) 
or isnull(name,'') in (SELECT 'TReplica_Del_'+TableName FROM z_Tables where TableCode in (SELECT TableCode FROM z_ReplicaTables where ReplicaPubCode = 1200000000)) 
)
ORDER BY ServerName, name_ElitR, name


	--SELECT name, definition FROM  sys.sql_modules m INNER JOIN sys.objects o ON m.object_id = o.object_id
	--except
	--SELECT name, definition FROM  [S-MARKETA].[ElitV_DP].sys.sql_modules m INNER JOIN [S-MARKETA].[ElitV_DP].sys.objects o ON m.object_id = o.object_id	
	--ORDER BY 1
/*
[192.168.157.22].[ElitRTS302].a_tCRRet_SetValues_IU

	SELECT '[S-MARKETA].[ElitV_DP].' ServerName,o.name, m.definition definition_ElitR,j.name, j.definition FROM  sys.sql_modules m INNER JOIN sys.objects o ON m.object_id = o.object_id
	full join (
	SELECT o.name, m.definition FROM  [S-MARKETA].[ElitV_DP].sys.sql_modules m INNER JOIN [S-MARKETA].[ElitV_DP].sys.objects o ON m.object_id = o.object_id	
	) j on j.name = o.name
	where isnull(m.definition, '') <> isnull(j.definition, '')
	and (j.definition is null or m.definition is null) 
	ORDER BY o.name,j.name
t_SaleEmptyTempTable
a_rProds_SetValues_I
*/	
