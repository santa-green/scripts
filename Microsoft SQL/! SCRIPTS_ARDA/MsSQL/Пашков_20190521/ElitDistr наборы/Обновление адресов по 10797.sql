SELECT * FROM at_z_Contracts where CompID = 10797 and ContrTypeID = 1
SELECT * FROM Elit.dbo.at_z_Contracts where CompID = 10797 and ContrTypeID = 1
/*
ChID	OurID	DocID	DocDate	ContrTypeID	OffTypeID	ContrID	CompID	BDate	EDate	AddContrID	AddBDate	Status	PackingTermType
66338	1	95767	2017-10-04 00:00:00	1	2	140317-А	10797	2017-03-14 00:00:00	2020-02-28 00:00:00	NULL	NULL	1	0
*/
SELECT * FROM at_z_ContractsAdd where ChID = 66338 ORDER BY CompAddID
SELECT * FROM Elit.dbo.at_z_ContractsAdd where ChID = 69338  ORDER BY CompAddID

BEGIN TRAN
SELECT * FROM ElitDistr.dbo.at_z_ContractsAdd where ChID = 66338 ORDER BY CompAddID

delete ElitDistr.dbo.at_z_ContractsAdd where ChID = (SELECT ChID FROM ElitDistr.dbo.at_z_Contracts where CompID = 10797 and ContrTypeID = 1)

insert ElitDistr.dbo.at_z_ContractsAdd
	SELECT (SELECT ChID FROM ElitDistr.dbo.at_z_Contracts where CompID = 10797 and ContrTypeID = 1) ChID, 
	CompID, CompAddID, LicTypeID, LicSer, LicNo, LicBDate, LicEDate, LicPayDate, AttorID, AttorDate, AttorEDate, SingleAttor, HaveSeal, HaveStamp, StateCode, LicDocTypeID FROM Elit.dbo.at_z_ContractsAdd where ChID = 69338  ORDER BY CompAddID

SELECT * FROM ElitDistr.dbo.at_z_ContractsAdd where ChID = 66338 ORDER BY CompAddID

ROLLBACK TRAN


--delete r_CompsAdd where CompID = 10797 and CompAdd = 'Магазин "Vintage";м. Дніпропетровськ, вул. Д.Донського, 24'
SELECT * FROM  t_Ret where CompID = 10797 and Address = 'Магазин "Vintage";м. Дніпропетровськ, вул. Д.Донського, 24'
SELECT * FROM  t_Ret where CompID = 10797 and Address not in (SELECT CompAdd FROM r_CompsAdd where CompID = 10797)
SELECT * FROM  t_Ret where Address not in (SELECT CompAdd FROM r_CompsAdd where CompID = 10797)
 
--update t_Ret
--set Address = 'Магазин "Vintage";м. Дніпропетровськ, вул. Д.Донського, 2А'
--where CompID = 10797 and Address = 'Магазин "Vintage";м. Дніпропетровськ, вул. Д.Донського, 24' 

SELECT * FROM r_CompsAdd where CompID = 10797 ORDER BY CompAddID
SELECT * FROM Elit.dbo.r_CompsAdd where CompID = 10797 ORDER BY CompAddID

SELECT * FROM at_z_ContractTerms 


