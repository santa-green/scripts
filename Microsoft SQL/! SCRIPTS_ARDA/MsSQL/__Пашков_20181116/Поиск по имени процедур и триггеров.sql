SELECT o.name AS Object_Name
,o.type_desc
,m.definition
,LEN(m.definition) dlina
,*
FROM sys.sql_modules m
INNER JOIN sys.objects o
ON m.object_id = o.object_id
WHERE o.name Like '%z_LogDiscExp%'
order by o.name
 
 
--поиск по описанию таблиц
select * from z_Tables WHERE TableDesc Like '%z_LogDiscExp%'

 
--поиск по названию таблиц
select * from z_Tables WHERE TableName Like '%z_LogDisc%'
 
--поиск по описанию ‘ункции пользовател€ FR 
select OperName, OperDesc, * from z_FRUDFs WHERE OperDesc Like '%курс%'


/* 
v_UParams
z_AzRoleReps
*/


select * from z_Tables WHERE PKFields Like '%RepID%'
select * from z_Tables WHERE TableName Like 'v_%'
