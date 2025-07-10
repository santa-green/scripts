-- обновить адрес в возвратах
use ElitDistr

BEGIN TRAN

DECLARE @docid int = 3630


SELECT Address, DelivID, * FROM t_ret where DelivID = 0 and docid = @docid

(SELECT * FROM Elit.dbo.t_Inv
where TaxDocID = (SELECT SrcDocID FROM t_ret where DelivID = 0 and docid = @docid) 
and CompID = 10797)

update t_ret
set Address = (SELECT top 1  Address FROM Elit.dbo.t_Inv
where TaxDocID = (SELECT SrcDocID FROM t_ret where DelivID = 0 and docid = @docid) 
and CompID = 10797),
DelivID = (SELECT top 1 DelivID FROM Elit.dbo.t_Inv
where TaxDocID = (SELECT SrcDocID FROM t_ret where DelivID = 0 and docid = @docid) 
and CompID = 10797)
where DelivID = 0 and docid = @docid

SELECT Address,DelivID,* FROM t_ret where  docid = @docid

ROLLBACK TRAN
