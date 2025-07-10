SELECT len(PGrName) FROM r_ProdG where PGrID = 1403
SELECT ASCII(SUBSTRING(PGrName,37,1)) FROM r_ProdG where PGrID = 1403
SELECT ASCII(SUBSTRING(PGrName,8,1)) FROM r_ProdG where PGrID = 1403
SELECT ASCII(SUBSTRING(PGrName,38,1)) FROM r_ProdG where PGrID = 1403
SELECT ASCII(SUBSTRING(PGrName,39,1)) FROM r_ProdG where PGrID = 1403
SELECT SUBSTRING(PGrName,38,1) FROM r_ProdG where PGrID = 1403
SELECT SUBSTRING(PGrName,39,1) FROM r_ProdG where PGrID = 1403
SELECT SUBSTRING(PGrName,8,1) FROM r_ProdG where PGrID = 1403


SELECT * FROM r_ProdG where PGrName like '%' + CHAR(10) + '%' or PGrName like '%' + CHAR(13) + '%'
SELECT * FROM r_ProdA where PGrAName like '%' + CHAR(10) + '%' or PGrAName like '%' + CHAR(13) + '%'
SELECT * FROM r_ProdBG where PBGrName like '%' + CHAR(10) + '%' or PBGrName like '%' + CHAR(13) + '%'

SELECT * FROM r_ProdG where PGrName like '%' + CHAR(10) + '%' or PGrName like '%' + CHAR(13) + '%'
SELECT * FROM dtproperties where uvalue like '%' + CHAR(10) + '%' or uvalue like '%' + CHAR(13) + '%'


select * from INFORMATION_SCHEMA.columns
where TABLE_NAME=N'r_ProdA'


select distinct DATA_TYPE from INFORMATION_SCHEMA.columns ORDER BY 1
select * from INFORMATION_SCHEMA.columns where DATA_TYPE = 'text'
select * from INFORMATION_SCHEMA.columns where DATA_TYPE = 'varchar'
select * from INFORMATION_SCHEMA.columns where DATA_TYPE = 'nvarchar'

SELECT * FROM z_Vars


SELECT PhoneMob,
isnull((
  SELECT SUBSTRING(TT.PhoneMob,V.number,1)
  FROM r_DCards TT JOIN master.dbo.spt_values V ON V.type='P' AND V.number BETWEEN 1 AND LEN(TT.PhoneMob)
  WHERE TT.ChID=T.ChID AND SUBSTRING(TT.PhoneMob,V.number,1) LIKE '[0-9]'
  ORDER BY V.number
  FOR XML PATH('')
),'') as PhoneMobNormal
FROM r_DCards T where PhoneMob  IS NOT NULL and len(PhoneMob) > 0
--and PhoneMob in ('050 310 77 62','050 310 85 96','050-311-04-75')
order by 2


SELECT PhoneMob,
isnull((
  SELECT SUBSTRING(TT.PhoneMob,V.number,1)
  FROM r_DCards TT JOIN master.dbo.spt_values V ON V.type='P' AND V.number BETWEEN 1 AND LEN(TT.PhoneMob)
  WHERE TT.ChID=T.ChID AND SUBSTRING(TT.PhoneMob,V.number,1) LIKE '[0-9]'
  ORDER BY V.number
  FOR XML PATH('')
),'') as PhoneMobNormal
FROM r_DCards T where PhoneMob  IS NOT NULL and len(PhoneMob) > 0
--and PhoneMob in ('050 310 77 62','050 310 85 96','050-311-04-75')
order by 2


SELECT V.number,CHAR(V.number),nCHAR(V.number) FROM master.dbo.spt_values V where V.type='P'
SELECT ROW_NUMBER() over( order by 1/0) FROM master.dbo.spt_values V, master.dbo.spt_values V2 where type='P'



SET NOCOUNT ON
DECLARE @TABLE_NAME varchar(250),@COLUMN_NAME varchar(250), @SQL NVARCHAR(MAX)
DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD
FOR 
select top 10000 t.TABLE_NAME,COLUMN_NAME from INFORMATION_SCHEMA.columns c
join INFORMATION_SCHEMA.TABLES t on t.TABLE_NAME = c.TABLE_NAME
where DATA_TYPE = 'varchar'and t.TABLE_TYPE = 'BASE TABLE'
and CHARACTER_MAXIMUM_LENGTH between 1 and 512
--and t.TABLE_NAME not in ('v_Formulas','MapSG','z_DataSets','z_FieldsRep','z_Lookups','z_ToolPages','z_Tools','')

 ORDER BY 1,2

OPEN CURSOR1
	FETCH NEXT FROM CURSOR1 INTO @TABLE_NAME,@COLUMN_NAME
WHILE @@FETCH_STATUS = 0
BEGIN
	--Script
	--print @TABLE_NAME + '   ' + @COLUMN_NAME
	--select 'TABLE_NAME=' + @TABLE_NAME + ', COLUMN_NAME=' + @COLUMN_NAME
	set @SQL = 'if exists (SELECT top 1 1 FROM '+@TABLE_NAME+' where '+@COLUMN_NAME+' like ''%'' + CHAR(10) + ''%'' or '+@COLUMN_NAME+' like ''%'' + CHAR(13) + ''%'') ' + 
			+' begin ' +
			--+' select ''TABLE_NAME=' + @TABLE_NAME + ', COLUMN_NAME=' + (SELECT top 1 AUFieldDesc FROM z_AUFields where AUFieldName = @COLUMN_NAME) +''''+
			--+' print ''' + @TABLE_NAME + '   ' + @COLUMN_NAME + ''''+
			+' select ''TABLE_NAME=' + @TABLE_NAME + '-' + isnull((SELECT  top(1) TableDesc FROM z_Tables where TableName = @TABLE_NAME),'') + ', COLUMN_NAME=' +  @COLUMN_NAME +''''+ ' as ''o------------------------------------------'''+
			+' SELECT ' + @COLUMN_NAME + ' FROM '+@TABLE_NAME+' where '+@COLUMN_NAME+' like ''%'' + CHAR(10) + ''%'' or '+@COLUMN_NAME+' like ''%'' + CHAR(13) + ''%''' +
			+' end '
	--select null
	--print @SQL
	execute (@SQL)
	
	FETCH NEXT FROM CURSOR1 INTO @TABLE_NAME,@COLUMN_NAME
END
CLOSE CURSOR1
DEALLOCATE CURSOR1






select 'TABLE_NAME=' + @TABLE_NAME + ', COLUMN_NAME=' + (SELECT top 1 AUFieldDesc FROM z_AUFields where AUFieldName = @COLUMN_NAME)



SELECT  * FROM z_AUFields where AUFieldName = 'CarName'
SELECT  * FROM z_Field where AUFieldName = 'CarName'
SELECT  top(1) TableDesc FROM z_Tables where TableName = @TABLE_NAME