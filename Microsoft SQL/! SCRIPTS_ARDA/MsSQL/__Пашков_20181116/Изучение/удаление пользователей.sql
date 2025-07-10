select * 
from sys.sql_logins


select   * from  sys.database_principals
where  
  [type] <> 'r' and
  [name] not in (
    'dbo',
    'sys',
    'INFORMATION_SCHEMA'
    ,'pvm0'
    ,'GMSSync'
    ,'kasir202'
    ,'guest'
    )
order by  name
  
EXEC sp_dropuser '0000'