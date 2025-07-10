SELECT o.name AS Object_Name
,o.type_desc
,m.definition
,LEN(m.definition) dlina
,*
FROM sys.sql_modules m
INNER JOIN sys.objects o
ON m.object_id = o.object_id
WHERE m.definition like '%|[' + '192.168.70.2' + '|]%' ESCAPE '|'    
order by o.name
 

--RAISERROR ('»зменение документа ''ѕродажа товара оператором'' в данном статусе запрещено.', 18, 1)
/*
z_Replica_Ins_ir_StockSubs_8
a_atrDiscComps_CheckValues_IU
a_atrDiscPls_CheckValues_IU
a_atrDiscs_CheckValues_IU
a_atrProdMDP_CheckValues_IU
ap_DISC_CheckOverlays

t_SaleAfterClose
*/

