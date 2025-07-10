--Продление конечной даты открытого периода для текущей базы
-- UPDATE r_Users SET EDate = '2018-12-31'

SELECT u.UserID, CAST(u.UserName as varchar(10)), CAST(e.EmpName as varchar(60)), u.EmpID, u.Active,  u.BDate, u.EDate, u.UseOpenAge 
FROM r_Users u
JOIN r_Emps e ON e.EmpID = u.EmpID
ORDER BY BDate,e.EmpName



BEGIN TRAN


  DECLARE @DBName sysname, @Cmd varchar(8000)  

  DECLARE DBs CURSOR FAST_FORWARD LOCAL FOR
  
    SELECT name FROM master.sys.databases
    WHERE (name  LIKE 'Elit%') AND (name NOT IN ('master', 'tempdb', 'model', 'msdb', 'ElitExcise', 'ElitCS', 'ElitStock')) 
    AND (is_read_only=0)
    ORDER BY name
    
  OPEN DBs
  FETCH NEXT FROM DBs INTO @DBName
  WHILE @@FETCH_STATUS = 0 BEGIN
-------------------------------------------------------------------------------
      SET @Cmd='UPDATE ' + QUOTENAME(@DBName) + '.[dbo].r_Users ' + ' SET EDate = ''2018-12-31'''
      select @Cmd
      EXEC(@Cmd)
      
      SET @Cmd='SELECT * FROM ' + QUOTENAME(@DBName) + '.[dbo].r_Users'
      select @Cmd
      EXEC(@Cmd)
-------------------------------------------------------------------------------
  FETCH NEXT FROM DBs INTO @DBName
  END
  CLOSE DBs
  DEALLOCATE DBs    


ROLLBACK TRAN
