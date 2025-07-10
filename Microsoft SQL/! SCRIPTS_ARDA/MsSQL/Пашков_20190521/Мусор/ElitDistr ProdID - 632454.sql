BEGIN TRAN
--setuser 'som'

SELECT * FROM r_ProdMQ_ where ProdID = 632454;
SELECT * FROM r_Prods_ where ProdID = 632454;

DISABLE TRIGGER ALL ON r_ProdMQ_; delete r_ProdMQ_ where ProdID = 632454; ENABLE  TRIGGER ALL ON r_ProdMQ_;
DISABLE TRIGGER ALL ON r_Prods_; delete r_Prods_ where ProdID = 632454; ENABLE  TRIGGER ALL ON r_Prods_;


ROLLBACK TRAN


SELECT * FROM r_Users where UserName = 'pvm0'