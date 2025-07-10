--добавить в Приёма наличных денег на склад чеки
USE ElitV_DP2

--insert t_MonRec
SELECT (select max(ChID)+1 from t_MonRec) ChID , OurID, AccountAC, DocDate, 
300032895   DocID, StockID, CompID, CompAccountAC, CurrID, KursMC, KursCC, 
320.000000000 SumAC, Subject, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, EmpID, StateCode, DepID
FROM t_MonRec where DocDate = '2017-03-22 00:00:00' and DocID= 300032896  

SELECT * FROM t_MonRec where DocDate = '2017-03-22 00:00:00' and DocID = 300032895