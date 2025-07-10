--find the SQL Login that runs the SQL Agent Jobs.
Select login_name, original_login_name, * from sys.dm_exec_sessions where program_name like 'SQLAgent%'
Select * from sys.dm_server_services 
Select * from sys.dm_server_services where servicename like  'SQL Server Agent%' or servicename like  'Агент%'