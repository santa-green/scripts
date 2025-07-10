
select * from sys.sql_expression_dependencies
where referencing_id = (select object_id from sys.objects 
												where name = 'ap_VC_ImportOrders_O_test')
order by referenced_entity_name


select * from sys.sql_expression_dependencies
where referencing_id = 248608920


SELECT referencing_id, OBJECT_NAME (referencing_id) as referencing_name1,referenced_database_name, 
    referenced_schema_name, referenced_entity_name
FROM sys.sql_expression_dependencies
WHERE referenced_database_name IS NOT NULL
and OBJECT_NAME (referencing_id) = 'ap_VC_ImportOrders_O_test'

select object_id, * from sys.objects where name = 'ap_VC_ImportOrders_O_test'