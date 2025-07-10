SELECT @@SERVERNAME AS Server
       ,Server_Id AS LinkedServerID
       ,name AS LinkedServer
	   ,product
	   ,provider
	   ,data_source
	   ,location
	   ,catalog
	   ,connect_timeout
	   ,query_timeout
	   ,modify_date
FROM    sys.servers
ORDER BY name;