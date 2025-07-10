IF OBJECT_ID (N'tempdb..#Excel', N'U') IS NOT NULL DROP TABLE #Excel -- выгрузка данных из Excel
SELECT *--CAST(CAST(ex.card AS BIGINT) as VARCHAR) card, CAST(CAST(ex.tel AS BIGINT) as VARCHAR) tel 
 INTO #Excel	
FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=G:\Excels\!DANCE.xlsx' , 'select * from [Лист1$]') as ex

SELECT * FROM #Excel
