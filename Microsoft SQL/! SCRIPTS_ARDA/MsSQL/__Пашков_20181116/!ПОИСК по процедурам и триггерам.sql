SELECT o.name AS Object_Name
,o.type_desc
,m.definition
,LEN(m.definition) dlina
,*
FROM sys.sql_modules m
INNER JOIN sys.objects o
ON m.object_id = o.object_id
WHERE m.definition Like '%saa%'
--and o.type in ('P ','TF','FN')
order by LEN(m.definition)
 --ORDER BY o.type
 
--RAISERROR ('»зменение документа ''ѕродажа товара оператором'' в данном статусе запрещено.', 18, 1)
/*


a_rComps_CheckCompDiapason_I
a_tInv_CheckFieldValues_IU

*/