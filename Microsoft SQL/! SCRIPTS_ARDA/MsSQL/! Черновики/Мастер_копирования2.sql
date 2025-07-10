--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

use Elit_test
go
SELECT DocID FROM t_IORec WHERE DocID = 1125360334

begin tran
SELECT * FROM t_IORec WHERE DocID = 1125360334
DECLARE @docid varchar(100) = (SELECT DocID FROM t_IORec WHERE DocID = 1125360334)
UPDATE at_t_IORes SET InDocID = @docid WHERE DocID = (SELECT max(docid) FROM at_t_IORes) 
SELECT OrderID, * FROM at_t_IORes WHERE DocID = (SELECT max(docid) FROM at_t_IORes) 
rollback tran

SELECT max(docid) FROM at_t_IORes
SELECT InDocID, * FROM at_t_IORes WHERE DocID = (SELECT max(docid) FROM at_t_IORes) 
SELECT InDocID, OrderID, * FROM at_t_IORes WHERE DocID = 6132

begin tran
--SELECT * FROM t_IORec WHERE DocID = 1125360334
--DECLARE @docid varchar(100) = (SELECT DocID FROM t_IORec WHERE DocID = 1125360334)
UPDATE at_t_IORes SET InDocID = Orderid WHERE DocID = (SELECT max(docid) FROM at_t_IORes) 
SELECT Indocid, OrderID, * FROM at_t_IORes WHERE DocID = (SELECT max(docid) FROM at_t_IORes) 
rollback tran

SELECT InDocID, OrderID, * FROM at_t_IORes WHERE DocID = 6132
SELECT InDocID, OrderID, * FROM elit..at_t_IORes WHERE DocID = 6126
SELECT * FROM r_Stocks
(SELECT CodeName2 FROM r_Codes2 WITH(NOLOCK) WHERE CodeID2=#Параметр_Признак 2# AND CodeID2!=0)

update at_t_IORes set ReserveProds = 1 WHERE DocID = 1125351665
SELECT * FROM at_t_IORes WHERE DocID = 1125351665
