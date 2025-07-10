--Возвращение всех объектов, измененных в течение последних N дней
SELECT name AS object_name 
  ,SCHEMA_NAME(schema_id) AS schema_name
  ,type_desc
  ,create_date
  ,modify_date
FROM sys.objects
WHERE modify_date > GETDATE() - 20
ORDER BY modify_date;