--скопировать РДЦП из тестовой базы
use ElitR_test

BEGIN TRAN


insert elitr.dbo.t_Epp
	SELECT * FROM  t_Epp where DocDate = '2018-08-01'
	
insert elitr.dbo.t_EppD
	SELECT * FROM  t_EppD where chid in (SELECT chid FROM t_Epp where DocDate = '2018-08-01')



ROLLBACK TRAN




--SELECT * FROM t_Epp m
--JOIN t_EppD d ON d.ChID = m.ChID
--WHERE m.DocDate = '2018-08-01'
--ORDER BY 1
