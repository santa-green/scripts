DECLARE @SubStr VARCHAR(8000)
SET @SubStr = '' -- нужная фраза в кавычках
SELECT 
object_id,
o.name,
type_desc,
c.text,*
FROM 
[sys].[objects] AS o
INNER JOIN syscomments AS c
ON o.object_id = c.id
WHERE c.text LIKE '%' + @SubStr + '%'
--AND o.[TYPE]='P'
ORDER BY o.name
