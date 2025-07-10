SELECT * FROM [S-VINTAGE].[SQL_RK7].dbo.PrintChecks WHERE CLOSEDATETIME = '20201115'
SELECT CLOSEDATETIME, * FROM [S-VINTAGE].[SQL_RK7].dbo.PrintChecks m WHERE m.CLOSEDATETIME > datediff(day, '20201124', '20201224') ORDER BY m.CLOSEDATETIME DESC
SELECT CLOSEDATETIME, * FROM [S-VINTAGE].[SQL_RK7].dbo.PrintChecks m WHERE datepart(day, CLOSEDATETIME) = 11 ORDER BY m.CLOSEDATETIME DESC
SELECT cast(CLOSEDATETIME as date), CLOSEDATETIME, * FROM [S-VINTAGE].[SQL_RK7].dbo.PrintChecks m WHERE cast(CLOSEDATETIME as date) = '2020-11-14' ORDER BY m.CLOSEDATETIME DESC
SELECT cast(CLOSEDATETIME as date), CLOSEDATETIME, * FROM [S-VINTAGE].[SQL_RK7].dbo.PrintChecks m ORDER BY m.CLOSEDATETIME DESC

SELECT CLOSEDATETIME, * FROM [S-VINTAGE].[SQL_RK7].dbo.PrintChecks WHERE  CONVERT(date, CLOSEDATETIME) = '20201110'

--Перенести желтые.
SELECT convert(date, Docdate), DeskCode, [ Код Стола], Стол, * FROM t_Sale_R WHERE convert(date, Docdate) = '20201112'
SELECT cast(Docdate as date), DeskCode, [ Код Стола], Стол, * FROM t_Sale_R WHERE cast(Docdate as date) = '20201112'

SELECT DeskCode, StockID, TSumCC_wt, * FROM t_Sale WHERE convert(date, Docdate) = '20201110' and StockID = 1202
SELECT TPurSumCC_wt, DeskCode, [ Код Стола], Стол, * FROM t_Sale_R WHERE ChID in (1800024886, 1800024887) and convert(date, Docdate) = '20201110'

SELECT DeskCode, StockID, TSumCC_wt, * FROM t_Sale WHERE convert(date, Docdate) = '20201112' and StockID = 1202 and TSumCC_wt = 125
SELECT DeskCode, [ Код Стола], Стол, * FROM t_Sale_R WHERE ChID = 1800024911


SELECT DeskCode, [ Код Стола], Стол, TPurSumCC_wt, * FROM t_Sale_R WHERE convert(date, Docdate) = '20201110'


SELECT DeskCode, [ Код Стола], Стол, * FROM t_Sale_R WHERE convert(date, Docdate) = '20201113'
SELECT * FROM r_Stocks WHERE StockID = 1202
SELECT DeskCode, [ Код Стола], Стол, * FROM t_Sale_R WHERE DeskCode = 459 ORDER BY Docdate DESC --Glovo
SELECT DeskCode, [ Код Стола], Стол, * FROM t_Sale_R WHERE DeskCode = 118 ORDER BY Docdate DESC--Raketa
SELECT DeskCode, * FROM t_Sale WHERE DeskCode = 118 and docdate > '20201109' ORDER BY Docdate DESC--Raketa
SELECT DeskCode, * FROM t_Sale WHERE DeskCode in (12, 472) ORDER BY Docdate DESC--Raketa
SELECT DeskCode, [ Код Стола], Стол, * FROM t_Sale_R WHERE DeskCode = 12 ORDER BY Docdate DESC--Glovo

SELECT * FROM r_DeskG WHERE DeskGCode = 118
SELECT * FROM r_Desks WHERE DeskCode = 459
SELECT * FROM r_Desks WHERE DeskCode = 118
SELECT * FROM r_Desks WHERE DeskGCode = 118

SELECT DeskCode, * FROM t_Sale_R

SELECT DeskCode, * FROM t_Sale WHERE DeskCode = 472 and convert(date, DocDate) = '20201114'
SELECT * FROM t_SaleD WHERE ChID = 76003815 -- DeskCode in (472,459) and convert(date, DocDate) = '20201114'
SELECT * FROM t_SalePays WHERE ChID = 76003815
SELECT distinct(PayFormCode) FROM t_SalePays --всего здесь 4 вида оплаты: 1, 4, 5, 2.

SELECT DeskCode, * FROM t_Sale WHERE DeskCode = 459 and convert(date, DocDate) = '20201114'
SELECT DeskCode, * FROM t_Sale WHERE convert(date, DocDate) = '20210507'
SELECT * FROM t_SaleD WHERE ChID = 76003814 -- DeskCode in (472,459) and convert(date, DocDate) = '20201114'
SELECT * FROM t_SalePays WHERE ChID = 76003814

SELECT DeskCode, * FROM t_Sale_R WHERE DeskCode in (472,459) and convert(date, DocDate) = '20201114'

SELECT CRID, CodeID3, * FROM t_Sale_R WHERE Docid = 823591
SELECT * FROM t_SalePays WHERE ChID = 1800025964
SELECT * FROM t_Sale WHERE ChID = 1800025964
SELECT * FROM t_SaleD WHERE ChID = 1800025964
--EXEC ap_Rkiper_Import_Sale
