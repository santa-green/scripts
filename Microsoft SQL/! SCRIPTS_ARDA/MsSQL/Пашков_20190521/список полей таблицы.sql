SELECT * FROM z_Tables where TableDesc like '%приход%'
SELECT * FROM z_Tables where TableName like '%t_Ret%'

SELECT f.*,FieldDesc FROM z_Fields f
join z_FieldsRep fr on fr.FieldName = f.FieldName 
where f.TableCode = 11011001
ORDER BY 2

SELECT f.FieldName,FieldDesc, '' значение FROM z_Fields f
join z_FieldsRep fr on fr.FieldName = f.FieldName 
where f.TableCode = 11003001
ORDER BY FieldPosID



SELECT * FROM z_Tables where TableDesc like '%приход%'
SELECT * FROM z_Objects where ObjName like '%rem%'

FieldName
CodeID4