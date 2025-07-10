DECLARE @CheckoutIDs VARCHAR(8000) = '12930504851569,12932244602993,12932121034865,12930439217265,12930900328561,12930824274033,12934174146673,12931595174001' --Перечень Order ID
DECLARE @Subject VARCHAR(200) = 'ТОВ "ФК "ЕЛАЄНС" Сплата по прийнятим платежам 2020-04-21 Сум 6529.00 Ком 176.29' --Формулировка
DECLARE @f INT = 2	--@f = 1 - это «Приход денег по предприятиям»
					--@f = 2 - это «Расход денег по предприятиям»
DECLARE @per NUMERIC(21,9) = 2.7	--Комиссия банка.
DECLARE @EmpID INT = 26				--Код служащего.

SELECT CASE WHEN @f = 1
			 THEN 6
			ELSE 8 END AS 'Фирма'
	  ,CONVERT(VARCHAR, GETDATE(), 104) AS 'Дата'
	  ,m.StockID AS 'Склад'
	  ,CASE WHEN @f = 1
			 THEN 63
			ELSE 2040 END AS 'Признак 1'
	  ,CASE WHEN @f = 1
			 THEN 18
			ELSE 2241 END AS 'Признак 2'
	  ,19 AS 'Признак 3'
	  ,CASE WHEN @f != 1 AND (m.StockID = 1200 OR m.StockID = 1201)
			 THEN 2531
			WHEN @f != 1 AND (m.StockID = 731)
			 THEN 2530
			WHEN @f != 1 AND (m.StockID = 1252)
			 THEN 2536
			ELSE 0 END AS 'Признак 4'
	  ,CASE WHEN @f != 1
			 THEN 2018
			ELSE 0 END AS 'Признак 5'
	  ,CASE WHEN @f = 1
			 THEN 1
			ELSE 10450 END AS 'Предприятие'
	  ,dbo.zf_GetCurrCC() AS 'Валюта'
	  ,CASE WHEN @f = 1
			 THEN REPLACE( CAST( ROUND(SUM(d.SumCC_wt), 2) AS VARCHAR), '.', ',' )
			 ELSE REPLACE( CAST( ROUND(SUM(d.SumCC_wt)*(@per/100), 2) AS VARCHAR), '.', ',' ) END AS 'Сумма ЛВ'
	  ,@EmpID AS 'Служащий'
	  ,@Subject AS 'Формулировка'
	  ,CASE WHEN @f = 1
			 THEN m.DocID
			 ELSE CAST(YEAR(GETDATE()) AS VARCHAR) + RIGHT('00' + CAST(MONTH(GETDATE()) AS VARCHAR), 2) END AS 'Номер'
	  ,CAST(dbo.zf_GetRateMC(dbo.zf_GetCurrCC()) AS INT) AS 'Курс ОВ'
	  ,1 AS 'Курс ВС'
FROM at_t_IORes m
JOIN at_t_IOResD d ON d.ChID = m.ChID
WHERE m.DocID IN
(
SELECT DocID FROM t_IMOrders WHERE ShopifyCheckoutID IN (SELECT AValue FROM zf_FilterToTableBIGINT(@CheckoutIDs))
)
GROUP BY m.StockID, m.DocID
ORDER BY m.DocID
/*
12932244602993
ТОВ "ФК "ЕЛАЄНС" Сплата по прийнятим платежам 2020-04-21 Сум 6529.00 Ком 176.29
ТОВ "ФК "ЕЛАЄНС" Сплата по прийнятим платежам 2020-04-21 Сум 6529.00 Ком 176.29

*/