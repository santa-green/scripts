   DECLARE @query nvarchar(1000)
   DECLARE @user nvarchar(1000) = 'moa0'
   DECLARE @password nvarchar(1000) = '123qwe'
   DECLARE @linkedserver nvarchar(1000) = 's-marketa'
    SET @query = 'EXEC (''CREATE LOGIN [' + @user + '] WITH PASSWORD=N''''' +
        @password + ''''', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF,
        CHECK_POLICY=OFF'') AT [' + @linkedserver + ']'
    select @query
    EXEC sp_Executesql @query
    
        
   SET @query = 'EXEC (''sys.sp_addsrvrolemember @loginame = ''''' + @user + ''''', @rolename = N''''sysadmin'''''') AT [' + @linkedserver + ']'
    select @query 
    EXEC sp_Executesql @query