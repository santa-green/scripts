 SELECT SCHEMA_NAME(schema_id) + '.' + name, type_desc, create_date, modify_date
 FROM sys.objects
 WHERE type IN (
 'V'
 ,'IF'
 ,'TF'
 ,'U'
 ,'P'
 ,'FN'
 )
 order by modify_date DESC;