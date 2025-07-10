DECLARE @DatabaseName varchar(50), @id int

DECLARE cursor_name CURSOR FOR
	SELECT  name, database_id FROM sys.databases WHERE  database_id >4 ORDER BY name

OPEN cursor_name 

FETCH NEXT FROM cursor_name INTO @DatabaseName
WHILE @@FETCH_STATUS = 0
BEGIN
	print @DatabaseName
	----------------------------------------------
	select * from @DatabaseName.r_EmpAdd
	join @DatabaseName.r_Emps on @DatabaseName.r_Emps.EmpID=@DatabaseName.r_EmpAdd.EmpID
	where @DatabaseName.FactCity like '%новомо%'
	----------------------------------------------
	FETCH NEXT FROM cursor_name INTO @DatabaseName
END

CLOSE cursor_name
DEALLOCATE cursor_name