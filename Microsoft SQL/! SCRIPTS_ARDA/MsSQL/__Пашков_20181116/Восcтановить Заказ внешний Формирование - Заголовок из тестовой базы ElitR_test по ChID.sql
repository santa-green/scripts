--Восcтановить Заказ внешний: Формирование: Заголовок из тестовой базы ElitR_test по ChID
BEGIN TRAN


USE ElitR
DECLARE @ChID int = 24252 --ChID Заказ внешний: Формирование: Заголовок

select 'Востановление в ElitR'
SELECT * FROM t_EOExp where ChID = @ChID
SELECT * FROM t_EOExpD where ChID = @ChID

--ElitR_test
SELECT * FROM ElitR_test.dbo.t_EOExp where ChID = @ChID
SELECT * FROM ElitR_test.dbo.t_EOExpD where ChID = @ChID


INSERT t_EOExp
	SELECT ChID, DocID, IntDocID, DocDate, KursMC, KursCC, OurID, StockID, CompID, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, Discount, PayDelay, EmpID, Notes, CurrID, ExpDate, ExpSN, NotDate, NotSN, TranAC, MoreAC, SupplyDayCount, OrdBDate, OrdEDate, OrdDayCount, 
	0 TSumAC, 0 TNewSumAC, 0 TSpendSumCC, 0 TRouteSumCC, StateCode
	FROM ElitR_test.dbo.t_EOExp where ChID = @ChID

INSERT t_EOExpD
	SELECT * FROM ElitR_test.dbo.t_EOExpD where ChID = @ChID


SELECT * FROM t_EOExp where ChID = @ChID
SELECT * FROM t_EOExpD where ChID = @ChID


ROLLBACK TRAN 
IF @@TRANCOUNT > 0 COMMIT TRAN