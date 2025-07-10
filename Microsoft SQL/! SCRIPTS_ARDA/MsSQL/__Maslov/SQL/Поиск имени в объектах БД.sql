-- Поиск @search во всех объектах базы
DECLARE @search VARCHAR(256) = 'moa0' -- записать искомую строку

SET @search = '%' + @search + '%'
SELECT o.name AS Object_Name
,o.type_desc
,m.definition
,LEN(m.definition) dlina
,*
FROM sys.sql_modules m
INNER JOIN sys.objects o
ON m.object_id = o.object_id
WHERE m.definition LIKE @search
--and o.type in ('P ','TF','FN')
order by LEN(m.definition)
--ORDER BY o.type