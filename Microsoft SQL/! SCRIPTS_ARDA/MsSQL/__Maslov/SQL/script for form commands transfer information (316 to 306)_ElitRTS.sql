

IF OBJECT_ID (N'tempdb..#temptable', N'U') IS NOT NULL DROP TABLE #temptable
IF OBJECT_ID (N'tempdb..#result', N'U') IS NOT NULL DROP TABLE #result

select TABLE_CATALOG,TABLE_NAME,ORDINAL_POSITION, COLUMN_NAME, IS_NULLABLE, DATA_TYPE 
 into #temptable
from ElitR_test1.INFORMATION_SCHEMA.columns
where TABLE_NAME in (select TableName from ElitR_316_test2.dbo.z_Tables m where m.TableCode in (select m1.TableCode from ElitR_316_test2.dbo.z_ReplicaTables m1 where m1.ReplicaPubCode = 1200000000))
ORDER BY ORDINAL_POSITION

insert #temptable
select TABLE_CATALOG,TABLE_NAME,ORDINAL_POSITION, COLUMN_NAME, IS_NULLABLE, DATA_TYPE 
from ElitR_316_test2.INFORMATION_SCHEMA.columns
where TABLE_NAME in (select TableName from ElitR_316_test2.dbo.z_Tables m where m.TableCode in (select m1.TableCode from ElitR_316_test2.dbo.z_ReplicaTables m1 where m1.ReplicaPubCode = 1200000000))
ORDER BY ORDINAL_POSITION

--SELECT * FROM #temptable

declare @in_this_data_base varchar(max), @from_this_data_base varchar(max), @null_expression varchar(max);
set @from_this_data_base = 'ElitR_316_test2';
set @in_this_data_base = 'ElitR_test1';
set @null_expression = 'null';

select 
tn.TABLE_NAME [TABLE_NAME],
'DISABLE TRIGGER ALL ON ' + @in_this_data_base + '.dbo.' + tn.TABLE_NAME + '; insert ' + @in_this_data_base + '.dbo.'+ tn.TABLE_NAME + ' ('+ --начало формирования строки
(SELECT SUBSTRING((SELECT   ',' +COLUMN_NAME as [text()] FROM #temptable where TABLE_CATALOG = @in_this_data_base and TABLE_NAME = tn.TABLE_NAME 
for XML PATH('')),2,65535) -- имена строк таблицы из базы "in_this_data_base" 
) /*pol306, */ + 
') select '+
(SUBSTRING((SELECT   ',' +pl.[имя поля] as [text()] FROM --имен строк таблицы из базы "from_this_data_base"
(SELECT p316.[имя поля] FROM (
	(SELECT 
	case when s1.COLUMN_NAME <> s2.COLUMN_NAME then 'неравны поля' else 'равны' end 'равенство полей',
	case when s1.COLUMN_NAME <> s2.COLUMN_NAME then 
	(SELECT ORDINAL_POSITION FROM #temptable t16 where t16.TABLE_CATALOG = @from_this_data_base and t16.COLUMN_NAME = s1.COLUMN_NAME and t16.TABLE_NAME = s1.TABLE_NAME)
	 else s1.ORDINAL_POSITION end 'номер позиции',
	 case when s1.COLUMN_NAME <> s2.COLUMN_NAME then 
		case when (SELECT COLUMN_NAME FROM #temptable t16 where t16.TABLE_CATALOG = @from_this_data_base and t16.COLUMN_NAME = s1.COLUMN_NAME and t16.TABLE_NAME = s1.TABLE_NAME) is not null then
			(SELECT COLUMN_NAME FROM #temptable t16 where t16.TABLE_CATALOG = @from_this_data_base and t16.COLUMN_NAME = s1.COLUMN_NAME and t16.TABLE_NAME = s1.TABLE_NAME) 
			else '''не найдено поле''' + ' ' + s1.COLUMN_NAME end
	 else s1.COLUMN_NAME end 'имя поля'
	 ,s1.TABLE_CATALOG,s1.TABLE_NAME,s1.ORDINAL_POSITION,s1.COLUMN_NAME
	  
	 FROM 
	(SELECT * FROM #temptable where TABLE_CATALOG = @in_this_data_base) as s1
	join 
	(SELECT * FROM #temptable where TABLE_CATALOG = @from_this_data_base) as s2
	on s1.TABLE_NAME = s2.TABLE_NAME and s1.ORDINAL_POSITION = s2.ORDINAL_POSITION
	where s1.TABLE_NAME = tn.TABLE_NAME)) p316 ) pl 
	  
for XML PATH('')),2,65535) /*pol316*,*/ )+
' from '+ @from_this_data_base+ '.dbo.' + tn.TABLE_NAME+
case 
when tn.TABLE_NAME in ('t_Sale','t_CRRet') then
' WITH (NOLOCK) where ChID not in (SELECT ChID FROM  '+ @in_this_data_base+ '.dbo.' + tn.TABLE_NAME+' WITH (NOLOCK))'
+';SELECT '''+@in_this_data_base+ '.dbo.' + tn.TABLE_NAME+''',sum(TRealSum) [TRealSum],count(ChID) [count] FROM  '+ @in_this_data_base+ '.dbo.' + tn.TABLE_NAME+' WITH (NOLOCK)'+ 
+';SELECT '''+@from_this_data_base+ '.dbo.' + tn.TABLE_NAME+''',sum(TRealSum) [TRealSum],count(ChID) [count] FROM  '+ @from_this_data_base+ '.dbo.' + tn.TABLE_NAME+' WITH (NOLOCK)'
when tn.TABLE_NAME in ('t_SaleD','t_CRRetD') then
' s1 WITH (NOLOCK)  where not exists (SELECT top 1 1 FROM   '+ @in_this_data_base+ '.dbo.' + tn.TABLE_NAME+' s2 WITH (NOLOCK) where s2.ChID = s1.ChID and s2.SrcPosID = s1.SrcPosID)'
+';SELECT '''+@in_this_data_base+ '.dbo.' + tn.TABLE_NAME+''',sum(RealSum) [RealSum],count(ChID) [count] FROM  '+ @in_this_data_base+ '.dbo.' + tn.TABLE_NAME+' WITH (NOLOCK)'+ 
+';SELECT '''+@from_this_data_base+ '.dbo.' + tn.TABLE_NAME+''',sum(RealSum) [RealSum],count(ChID) [count] FROM  '+ @from_this_data_base+ '.dbo.' + tn.TABLE_NAME+' WITH (NOLOCK)'
when tn.TABLE_NAME in ('t_SaleC') then
' s1 WITH (NOLOCK)  where not exists (SELECT top 1 1 FROM   '+ @in_this_data_base+ '.dbo.' + tn.TABLE_NAME+' s2 WITH (NOLOCK) where s2.ChID = s1.ChID and s2.SrcPosID = s1.SrcPosID)'
+';SELECT '''+@in_this_data_base+ '.dbo.' + tn.TABLE_NAME+''',sum(SumCC_wt) [SumCC_wt],count(ChID) [count] FROM  '+ @in_this_data_base+ '.dbo.' + tn.TABLE_NAME+' WITH (NOLOCK)'+ 
+';SELECT '''+@from_this_data_base+ '.dbo.' + tn.TABLE_NAME+''',sum(SumCC_wt) [SumCC_wt],count(ChID) [count] FROM  '+ @from_this_data_base+ '.dbo.' + tn.TABLE_NAME+' WITH (NOLOCK)'
when tn.TABLE_NAME in ('t_SaleDLV','t_CRRetDLV') then
' s1 WITH (NOLOCK)  where not exists (SELECT top 1 1 FROM   '+ @in_this_data_base+ '.dbo.' + tn.TABLE_NAME+' s2 WITH (NOLOCK) where s2.ChID = s1.ChID and s2.SrcPosID = s1.SrcPosID)'
+';SELECT '''+@in_this_data_base+ '.dbo.' + tn.TABLE_NAME+''',sum(LevySum) [LevySum],count(ChID) [count] FROM  '+ @in_this_data_base+ '.dbo.' + tn.TABLE_NAME+' WITH (NOLOCK)'+ 
+';SELECT '''+@from_this_data_base+ '.dbo.' + tn.TABLE_NAME+''',sum(LevySum) [LevySum],count(ChID) [count] FROM  '+ @from_this_data_base+ '.dbo.' + tn.TABLE_NAME+' WITH (NOLOCK)'
when tn.TABLE_NAME in ('t_SalePays','t_CRRetPays') then
' s1 WITH (NOLOCK)  where not exists (SELECT top 1 1 FROM   '+ @in_this_data_base+ '.dbo.' + tn.TABLE_NAME+' s2 WITH (NOLOCK) where s2.ChID = s1.ChID and s2.SrcPosID = s1.SrcPosID)'
+';SELECT '''+@in_this_data_base+ '.dbo.' + tn.TABLE_NAME+''',sum(SumCC_wt) [SumCC_wt],count(ChID) [count] FROM  '+ @in_this_data_base+ '.dbo.' + tn.TABLE_NAME+' WITH (NOLOCK)'+ 
+';SELECT '''+@from_this_data_base+ '.dbo.' + tn.TABLE_NAME+''',sum(SumCC_wt) [SumCC_wt],count(ChID) [count] FROM  '+ @from_this_data_base+ '.dbo.' + tn.TABLE_NAME+' WITH (NOLOCK)'
when tn.TABLE_NAME in ('t_MonIntExp','t_MonIntRec') then
' s1 WITH (NOLOCK)  where not exists (SELECT top 1 1 FROM   '+ @in_this_data_base+ '.dbo.' + tn.TABLE_NAME+' s2 WITH (NOLOCK) where s2.ChID = s1.ChID)'
+';SELECT '''+@in_this_data_base+ '.dbo.' + tn.TABLE_NAME+''',sum(SumCC) [SumCC],count(ChID) [count] FROM  '+ @in_this_data_base+ '.dbo.' + tn.TABLE_NAME+' WITH (NOLOCK)'+ 
+';SELECT '''+@from_this_data_base+ '.dbo.' + tn.TABLE_NAME+''',sum(SumCC) [SumCC],count(ChID) [count] FROM  '+ @from_this_data_base+ '.dbo.' + tn.TABLE_NAME+' WITH (NOLOCK)'
when tn.TABLE_NAME in ('t_MonRec') then
' s1 WITH (NOLOCK)  where not exists (SELECT top 1 1 FROM   '+ @in_this_data_base+ '.dbo.' + tn.TABLE_NAME+' s2 WITH (NOLOCK) where s2.ChID = s1.ChID)'
+';SELECT '''+@in_this_data_base+ '.dbo.' + tn.TABLE_NAME+''',sum(SumAC) [SumAC],count(ChID) [count] FROM  '+ @in_this_data_base+ '.dbo.' + tn.TABLE_NAME+' WITH (NOLOCK)'+ 
+';SELECT '''+@from_this_data_base+ '.dbo.' + tn.TABLE_NAME+''',sum(SumAC) [SumAC],count(ChID) [count] FROM  '+ @from_this_data_base+ '.dbo.' + tn.TABLE_NAME+' WITH (NOLOCK)'
when tn.TABLE_NAME in ('t_zRep') then
' s1 WITH (NOLOCK)  where not exists (SELECT top 1 1 FROM   '+ @in_this_data_base+ '.dbo.' + tn.TABLE_NAME+' s2 WITH (NOLOCK) where s2.ChID = s1.ChID)'
+';SELECT '''+@in_this_data_base+ '.dbo.' + tn.TABLE_NAME+''',sum(SumCC_wt) [SumCC_wt],count(ChID) [count] FROM  '+ @in_this_data_base+ '.dbo.' + tn.TABLE_NAME+' WITH (NOLOCK)'+ 
+';SELECT '''+@from_this_data_base+ '.dbo.' + tn.TABLE_NAME+''',sum(SumCC_wt) [SumCC_wt],count(ChID) [count] FROM  '+ @from_this_data_base+ '.dbo.' + tn.TABLE_NAME+' WITH (NOLOCK)'
when tn.TABLE_NAME in ('z_DocDC') then
' s1 WITH (NOLOCK)  where not exists (SELECT top 1 1 FROM   '+ @in_this_data_base+ '.dbo.' + tn.TABLE_NAME+' s2 WITH (NOLOCK) where s2.ChID = s1.ChID and s2.DocCode = s1.DocCode and s2.DCardID = s1.DCardID)' --DocCode, ChID, DCardID
+';SELECT '''+@in_this_data_base+ '.dbo.' + tn.TABLE_NAME+''',sum(ChID) [ChID],count(ChID) [count] FROM  '+ @in_this_data_base+ '.dbo.' + tn.TABLE_NAME+' WITH (NOLOCK)'+ 
+';SELECT '''+@from_this_data_base+ '.dbo.' + tn.TABLE_NAME+''',sum(ChID) [ChID],count(ChID) [count] FROM  '+ @from_this_data_base+ '.dbo.' + tn.TABLE_NAME+' WITH (NOLOCK)'

else
' WITH (NOLOCK) where ChID not in (SELECT ChID FROM  '+ @in_this_data_base+ '.dbo.' + tn.TABLE_NAME+' WITH (NOLOCK))'
+';SELECT '''+@in_this_data_base+ '.dbo.' + tn.TABLE_NAME+''',sum(TRealSum) [TRealSum],count(ChID) [count] FROM  '+ @in_this_data_base+ '.dbo.' + tn.TABLE_NAME+' WITH (NOLOCK)'+ 
+';SELECT '''+@from_this_data_base+ '.dbo.' + tn.TABLE_NAME+''',sum(TRealSum) [TRealSum],count(ChID) [count] FROM  '+ @from_this_data_base+ '.dbo.' + tn.TABLE_NAME+' WITH (NOLOCK)'
end
 + '; ENABLE TRIGGER ALL ON ' + @in_this_data_base + '.dbo.' + TABLE_NAME+';' [script]
 
 into #result
FROM (
SELECT distinct TABLE_NAME FROM #temptable  where TABLE_CATALOG = @in_this_data_base) tn


update #result set  TABLE_NAME = '01-' + TABLE_NAME,script =  SUBSTRING (script,0,PATINDEX('%select%',script)) + SUBSTRING (replace(script,',DCardID,',',isnull(DCardID,''<Нет дисконтной карты>'') DCardID,'),PATINDEX('%select%',script)+41,60000)
 where TABLE_NAME in('t_Sale','t_CRRet')

update #result set  TABLE_NAME = '02-' + TABLE_NAME where TABLE_NAME in ('t_SaleD','t_CRRetD','t_SaleDLV','t_CRRetDLV','t_SalePays','t_CRRetPays','t_SaleC')
update #result set  TABLE_NAME = '03-' + TABLE_NAME where TABLE_NAME in ('t_MonIntExp','t_MonIntRec','t_MonRec','t_zRep')
update #result set  TABLE_NAME = '03-' + TABLE_NAME,script = replace (script,'''не найдено поле''','(SELECT DCardID FROM ElitR_316_test2.dbo.r_DCards dc where dc.ChID = ChID )') where TABLE_NAME in ('z_DocDC')


SELECT * FROM #result ORDER BY 1
 
--SELECT  PATINDEX('%select%',script),STUFF (  STUFF(script,PATINDEX('%,DCardID,%',script),9,',isnull(DCardID,''<Нет дисконтной карты>'') DCardID,')   ,PATINDEX('%,DCardID,%',script),9,', DCardID ,') FROM #result where TABLE_NAME in('t_CRRet')
--SELECT  PATINDEX('%select%,DCardID,%',script),STUFF (  PATINDEX('%select%,DCardID,%',script),9,',isnull(DCardID,''<Нет дисконтной карты>'') DCardID,') FROM #result where TABLE_NAME in('t_CRRet')
--SELECT  PATINDEX('%select%',script),  SUBSTRING (script,0,PATINDEX('%select%',script)),   SUBSTRING (replace(SUBSTRING(script,PATINDEX('%select%',script),50000),',DCardID,',',isnull(DCardID,''<Нет дисконтной карты>'') DCardID,'),PATINDEX('%select%',script),60000) FROM #result where TABLE_NAME in('t_CRRet')
--SELECT  PATINDEX('%select%',script),  SUBSTRING (script,0,PATINDEX('%select%',script)) + SUBSTRING (replace(script,',DCardID,',',isnull(DCardID,''<Нет дисконтной карты>'') DCardID,'),PATINDEX('%select%',script)+41,60000) FROM #result where TABLE_NAME in('t_CRRet')


BEGIN TRAN
;

DISABLE TRIGGER ALL ON ElitR_test1.dbo.z_DocDC; insert ElitR_test1.dbo.z_DocDC (DocCode,ChID,DCardID) select DocCode,ChID,(SELECT DCardID FROM ElitR_316_test2.dbo.r_DCards dc where dc.ChID = ChID ) DCardID from ElitR_316_test2.dbo.z_DocDC s1 WITH (NOLOCK)  where not exists (SELECT top 1 1 FROM   ElitR_test1.dbo.z_DocDC s2 WITH (NOLOCK) where s2.ChID = s1.ChID and s2.DocCode = s1.DocCode and s2.DCardID = s1.DCardID);SELECT 'ElitR_test1.dbo.z_DocDC',sum(ChID) [ChID],count(ChID) [count] FROM  ElitR_test1.dbo.z_DocDC WITH (NOLOCK);SELECT 'ElitR_316_test2.dbo.z_DocDC',sum(ChID) [ChID],count(ChID) [count] FROM  ElitR_316_test2.dbo.z_DocDC WITH (NOLOCK); ENABLE TRIGGER ALL ON ElitR_test1.dbo.z_DocDC;

SELECT top 10 * FROM ElitR_test1.dbo.z_DocDC
SELECT top 10 * FROM ElitR_316_test2.dbo.z_DocDC

ROLLBACK TRAN
