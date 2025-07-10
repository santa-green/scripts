
IF OBJECT_ID (N'tempdb..#Vkod', N'U') IS NOT NULL DROP TABLE #Vkod;

SELECT * 
into #Vkod
FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0; IMEX=1; Database=e:\OT38ElitServer\Import\rkeeper_menu.xls' , 'select * from [Лист1$]');

select * from #Vkod