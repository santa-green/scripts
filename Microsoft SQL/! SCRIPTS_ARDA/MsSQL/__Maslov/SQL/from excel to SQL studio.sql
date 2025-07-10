	IF OBJECT_ID (N'tempdb..#Menu', N'U') IS NOT NULL DROP TABLE #Menu
	SELECT * 
	 INTO #Menu	
	FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\R_keeper\menu_R_keeper.xlsx' , 'select * from [Лист1$]') as ex
	WHERE  Статус = 'Активный'
	
	select * from #Menu