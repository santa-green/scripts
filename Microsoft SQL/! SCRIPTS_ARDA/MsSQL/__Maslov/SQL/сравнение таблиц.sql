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

SELECT * FROM #temptable ORDER BY 1,2,4

SELECT * FROM #temptable where TABLE_CATALOG = 'ElitR_306' ORDER BY 1,2,3

SELECT * FROM #temptable where TABLE_CATALOG = 'ElitR_316' ORDER BY 1,2,3


SELECT TABLE_NAME,ORDINAL_POSITION, COLUMN_NAME, IS_NULLABLE, DATA_TYPE  FROM #temptable where TABLE_CATALOG = 'ElitR_316' and TABLE_NAME = 'z_LogDiscRec' ORDER BY 2,3
--except
SELECT TABLE_NAME,ORDINAL_POSITION, COLUMN_NAME, IS_NULLABLE, DATA_TYPE  FROM #temptable where TABLE_CATALOG = 'ElitR_306' and TABLE_NAME = 'z_LogDiscRec' ORDER BY 2,3


SELECT TABLE_NAME,ORDINAL_POSITION, COLUMN_NAME, IS_NULLABLE, DATA_TYPE  FROM #temptable where TABLE_CATALOG = 'ElitR_316'
except
SELECT TABLE_NAME,ORDINAL_POSITION, COLUMN_NAME, IS_NULLABLE, DATA_TYPE  FROM #temptable where TABLE_CATALOG = 'ElitR_306'


SELECT 
case when s1.COLUMN_NAME <> s2.COLUMN_NAME then 'неравны поля' else 'равны' end 'равенство полей',
case when s1.COLUMN_NAME <> s2.COLUMN_NAME then 
(SELECT ORDINAL_POSITION FROM #temptable t16 where t16.TABLE_CATALOG = 'ElitR_316' and t16.COLUMN_NAME = s1.COLUMN_NAME and t16.TABLE_NAME = s1.TABLE_NAME)
 else s1.ORDINAL_POSITION end 'номер позиции',
 case when s1.COLUMN_NAME <> s2.COLUMN_NAME then 
	case when (SELECT COLUMN_NAME FROM #temptable t16 where t16.TABLE_CATALOG = 'ElitR_316' and t16.COLUMN_NAME = s1.COLUMN_NAME and t16.TABLE_NAME = s1.TABLE_NAME) is not null then
		(SELECT COLUMN_NAME FROM #temptable t16 where t16.TABLE_CATALOG = 'ElitR_316' and t16.COLUMN_NAME = s1.COLUMN_NAME and t16.TABLE_NAME = s1.TABLE_NAME) 
		else '''не найдено поле''' + ' ' + s1.COLUMN_NAME end
 else s1.COLUMN_NAME end 'имя поля',
* FROM 
(SELECT * FROM #temptable where TABLE_CATALOG = 'ElitR_306') as s1
join 
(SELECT * FROM #temptable where TABLE_CATALOG = 'ElitR_316') as s2
on s1.TABLE_NAME = s2.TABLE_NAME and s1.ORDINAL_POSITION = s2.ORDINAL_POSITION
where s1.TABLE_NAME = 'r_CRs'
--where s1.COLUMN_NAME <> s2.COLUMN_NAME

SELECT ORDINAL_POSITION FROM #temptable where TABLE_CATALOG = 'ElitR_316' and COLUMN_NAME = 'TempBonus' and TABLE_NAME = 'z_LogDiscExp'

SELECT
SUBSTRING((SELECT   ',' +COLUMN_NAME as [text()] FROM #temptable where TABLE_CATALOG = 'ElitR_306' and TABLE_NAME = 'r_CRs'
for XML PATH('')),2,65535) -- get names of rows in table

SELECT 
SUBSTRING((SELECT   ',' + TableName as [text()] FROM ElitR_316.dbo.z_Tables
for XML PATH('')),2,65535) -- get names of tabels in server


SELECT COLUMN_NAME + ',' as [text()] FROM #temptable where TABLE_CATALOG = 'ElitR_316' and TABLE_NAME = 't_CRRet'
for XML PATH('')


declare @Msg varchar(max)
 SELECT @Msg = isnull(@Msg,'') + case when @Msg IS null then '' else ',' end + COLUMN_NAME FROM #temptable where TABLE_CATALOG = 'ElitR_316' and TABLE_NAME = 'z_LogDiscExp'
 SELECT @Msg
 
 -- code for copy some quel tabels from 316 data base to 306 data base
BEGIN TRAN;
declare @s1 varchar(max), @name_of_table varchar(max);
set @name_of_table = 't_CRRetDLV';

set @s1 = 'DISABLE TRIGGER ALL ON ElitR_306.dbo.' + @name_of_table + ';'; 

set @s1 += 'insert ElitR_306.dbo.' + @name_of_table + ' (' + (SUBSTRING((SELECT   ',[' + COLUMN_NAME  + ']' as [text()] FROM #temptable where TABLE_CATALOG = 'ElitR_316' and TABLE_NAME = @name_of_table
for XML PATH('')),2,65535)) + ') select ' + (SUBSTRING((SELECT   ',[' + COLUMN_NAME  + ']' as [text()] FROM #temptable where TABLE_CATALOG = 'ElitR_306' and TABLE_NAME = @name_of_table
for XML PATH('')),2,65535)) + ' from ElitR_316.dbo.'+@name_of_table + ';';


set @s1 += 'select * from ElitR_306.dbo.' + @name_of_table + ';';

set @s1 += 'ENABLE  TRIGGER ALL ON ElitR_306.dbo.' + @name_of_table + ';';

print @s1;
exec(@s1);
ROLLBACK TRAN;
-- end of this method



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
/*+ (select distinct (case when (select COUNT (*) from ElitR_316.INFORMATION_SCHEMA.columns where TABLE_NAME = tn.TABLE_NAME) > (select COUNT (*) from ElitR_306.INFORMATION_SCHEMA.columns where TABLE_NAME = tn.TABLE_NAME)
 then
 (SELECT
SUBSTRING((SELECT   ',' + @null_expression as [text()] FROM ElitR_316.INFORMATION_SCHEMA.columns where TABLE_NAME = tn.TABLE_NAME and ORDINAL_POSITION > (select COUNT (*) from ElitR_306.INFORMATION_SCHEMA.columns where TABLE_NAME = tn.TABLE_NAME)
for XML PATH('')),2,65535))
  else ' ' end) 
from ElitR_316.INFORMATION_SCHEMA.columns where TABLE_NAME = tn.TABLE_NAME)*/
' from '+ @from_this_data_base+ '.dbo.' + tn.TABLE_NAME+';' + ' ENABLE TRIGGER ALL ON ' + @in_this_data_base + '.dbo.' + TABLE_NAME+';'

FROM (
SELECT distinct TABLE_NAME FROM #temptable  where TABLE_CATALOG = @in_this_data_base) tn


IF OBJECT_ID (N'tempdb..#temp', N'U') IS NOT NULL DROP TABLE #temp
select * into #temp from (
select 'DCardID'BD306,'DCardChID' BD316, 'z_DocDC' p3
union all select 'DCardID' BD306,'DCardChID' BD316, 'z_LogDiscRec' p3
union all select 'DCardID' BD306,'DCardChID' BD316, 'z_LogDiscExp' p3
union all select ' ' BD306,' ' BD316, ' ' p3
union all select '90' BD306,'tabels' BD316, ' ' p3
union all select 'CRID' BD306,'WPID' BD316, 'r_CRDeskG' p3
union all select 'CRID' BD306,'WPRoleID' BD316, 'r_CRMM' p3
union all select 'CRID' BD306,'WPID' BD316, 'r_CRPOSPays' p3
union all select ' ' BD306,' ' BD316, 'r_CRs' p3
) s1
select * from #temp


select * from ElitR_306.dbo.r_CRs

select COLUMN_NAME from ElitR_306.INFORMATION_SCHEMA.columns
where TABLE_NAME = 'r_Banks';

select COLUMN_NAME from ElitR_316.INFORMATION_SCHEMA.columns
where TABLE_NAME = 'r_Banks';

(select COUNT (*) from ElitR_316.INFORMATION_SCHEMA.columns where TABLE_NAME = 'r_Banks') --количество колонок в базе


if (select COUNT (*) from ElitR_316.INFORMATION_SCHEMA.columns where TABLE_NAME = 'r_Banks') <> (select COUNT (*) from ElitR_306.INFORMATION_SCHEMA.columns where TABLE_NAME = 'r_Banks')
select COLUMN_NAME from ElitR_316.INFORMATION_SCHEMA.columns where TABLE_NAME = 'r_Banks' and ORDINAL_POSITION > (select COUNT (*) from ElitR_306.INFORMATION_SCHEMA.columns where TABLE_NAME = 'r_Banks');

select distinct (case when (select COUNT (*) from ElitR_316.INFORMATION_SCHEMA.columns where TABLE_NAME = 'r_Banks') <> (select COUNT (*) from ElitR_306.INFORMATION_SCHEMA.columns where TABLE_NAME = 'r_Banks')
 then
 (SELECT
SUBSTRING((SELECT   ',' + '0' as [text()] FROM ElitR_316.INFORMATION_SCHEMA.columns where TABLE_NAME = 'r_Banks' and ORDINAL_POSITION > (select COUNT (*) from ElitR_306.INFORMATION_SCHEMA.columns where TABLE_NAME = 'r_Banks')
for XML PATH('')),2,65535))
  end) 
from ElitR_316.INFORMATION_SCHEMA.columns where TABLE_NAME = 'r_Banks';

(SELECT
SUBSTRING((SELECT   ',' + COLUMN_NAME as [text()] FROM ElitR_316.INFORMATION_SCHEMA.columns where TABLE_NAME = 'r_Banks' and ORDINAL_POSITION > (select COUNT (*) from ElitR_306.INFORMATION_SCHEMA.columns where TABLE_NAME = 'r_Banks')
for XML PATH('')),2,65535))

