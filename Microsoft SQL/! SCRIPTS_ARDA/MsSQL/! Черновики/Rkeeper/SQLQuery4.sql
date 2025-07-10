SELECT CLOSEDATETIME, * FROM [S-VINTAGE].[SQL_RK7].dbo.PrintChecks WHERE  CONVERT(date, CLOSEDATETIME) = '20210204' ORDER BY 1 DESC

SELECT * FROM CASHES
SELECT * FROM EMPLOYEES
SELECT * FROM EMPLOYEEROLES
SELECT * FROM FORMS
SELECT * FROM FUNCTIONKEYS
SELECT * FROM GLOBALSHIFTS
SELECT * FROM MODIFIERS
SELECT * FROM ORDERS ORDER BY LASTSERVICE DESC
SELECT * FROM PAYMENTS 

SELECT top(10) DocID docid..ff., * FROM t_Sale
SELECT * FROM [S-VINTAGE].[SQL_RK7].dbo.PAYBINDINGS

select  '' [Oper ...asdf], * from [S-VINTAGE].ElitRTS501.dbo.r_Opers ORDER BY ChID DESC
   select EmpID from [S-VINTAGE].ElitRTS501.dbo.r_Emps 

   SELECT * FROM [s-sql-d4].[elit].dbo.z_tables WHERE tableName LIKE '%r_Emps%' OR tableDesc LIKE '%r_Emps%';
   SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME like '%r_Emps%'

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Заливка из кипера PrintChecks -> t_sale_r -> t_sale/t_saleD*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT top(100) GUESTCNT, PRLISTSUM, checknum, CLOSEDATETIME, * FROM [S-VINTAGE].[SQL_RK7].dbo.PrintChecks WHERE CONVERT(date, CLOSEDATETIME) = '20210204' ORDER BY 1 DESC
SELECT top(100) GUESTCNT, PRLISTSUM, checknum, CLOSEDATETIME, * FROM [S-VINTAGE].[SQL_RK7].dbo.PrintChecks WHERE checknum = 823292 and CONVERT(date, CLOSEDATETIME) = '20210204' ORDER BY 1 DESC
SELECT top(100) * FROM t_sale_r WHERE convert(date, docdate) = '20210204' ORDER BY docdate DESC 
SELECT top(100) Prodid, [Наименование товара], qty, SumCC_wt, PURSumCC_wt, * FROM t_sale_r WHERE docid = 823292 and convert(date, docdate) = '20210204' ORDER BY docdate DESC 
--SELECT top(100) * FROM t_sale_r WHERE TRealSum = 2600 and convert(date, docdate) = '20210204' ORDER BY docdate DESC 
SELECT top(100) * FROM t_sale WHERE docid = 823292 and convert(date, docdate) = '20210204' ORDER BY docdate DESC 
SELECT top(100) * FROM t_saleD WHERE chid = 1800025683--WHERE convert(date, docdate) = '20210204' ORDER BY docdate DESC 

SELECT * FROM t_Acc
SELECT * FROM [s-sql-d4].[elit].dbo.z_tables WHERE tableName LIKE '%t_Acc%' OR tableDesc LIKE '%t_Acc%';
SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME like '%t_Acc%'

SELECT * FROM [S-VINTAGE].[SQL_RK7].dbo.PrintChecks WHERE visit = 504977796
SELECT * FROM [S-VINTAGE].[SQL_RK7].dbo.PAYBINDINGS WHERE visit = 504977796