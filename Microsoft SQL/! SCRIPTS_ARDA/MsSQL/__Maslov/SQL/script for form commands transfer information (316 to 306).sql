IF OBJECT_ID (N'tempdb..#temptable', N'U') IS NOT NULL DROP TABLE #temptable

select TABLE_CATALOG,TABLE_NAME,ORDINAL_POSITION, COLUMN_NAME, IS_NULLABLE, DATA_TYPE 
into #temptable
from ElitR_306.INFORMATION_SCHEMA.columns
where TABLE_NAME in (select TableName from ElitR_316.dbo.z_Tables m where m.TableCode in (select m1.TableCode from ElitR_316.dbo.z_ReplicaTables m1 where m1.ReplicaPubCode <> 1500000000))
ORDER BY ORDINAL_POSITION

insert #temptable
select TABLE_CATALOG,TABLE_NAME,ORDINAL_POSITION, COLUMN_NAME, IS_NULLABLE, DATA_TYPE 
from ElitR_316.INFORMATION_SCHEMA.columns
where TABLE_NAME in (select TableName from ElitR_316.dbo.z_Tables m where m.TableCode in (select m1.TableCode from ElitR_316.dbo.z_ReplicaTables m1 where m1.ReplicaPubCode <> 1500000000))
ORDER BY ORDINAL_POSITION

declare @in_this_data_base varchar(max), @from_this_data_base varchar(max), @null_expression varchar(max);
set @from_this_data_base = 'ElitR_316';
set @in_this_data_base = 'ElitR_306';
set @null_expression = 'null';

select
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
' from '+ @from_this_data_base+ '.dbo.' + tn.TABLE_NAME+';' + ' ENABLE TRIGGER ALL ON ' + @in_this_data_base + '.dbo.' + TABLE_NAME+';'

FROM (
SELECT distinct TABLE_NAME FROM #temptable  where TABLE_CATALOG = @in_this_data_base) tn