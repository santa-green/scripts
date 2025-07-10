SELECT o.name AS Object_Name
,o.type_desc
,m.definition
,LEN(m.definition) dlina
,*
FROM sys.sql_modules m
INNER JOIN sys.objects o
ON m.object_id = o.object_id
WHERE m.definition Like '%at_r_DiscComps%'
--and o.type in ('P ','TF','FN')
order by LEN(m.definition)
--ORDER BY o.type
