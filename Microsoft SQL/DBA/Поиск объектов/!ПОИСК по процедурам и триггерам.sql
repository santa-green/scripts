SELECT o.name AS Object_Name
,o.type_desc
--,CHARINDEX('AS',m.definition)
--,SUBSTRING(m.definition, CHARINDEX('AS',m.definition), 32000)
,m.definition
,LEN(m.definition) dlina
,*
FROM sys.sql_modules m
INNER JOIN sys.objects o
ON m.object_id = o.object_id
WHERE m.definition Like '%Elit]%'
--and o.type in ('P ','TF','FN')
--and o.name not in (SELECT ObjName FROM z_Objects where ObjType in ('p'))
--order by LEN(m.definition)
ORDER BY 1

--RAISERROR ('»зменение документа ''ѕродажа товара оператором'' в данном статусе запрещено.', 18, 1)
/*

ip_KPICalc
ip_KPICalcDate
ip_KPICalcNew
iT_InsUpd_ir_KPICalc_Fields
iT_InsUpd_ir_KPIFields_Fields
iT_InsUpd_ir_KPIFilters_fields
iT_InsUpd_ir_KPIs_RepID


iv_TM
iv_TMD


*/