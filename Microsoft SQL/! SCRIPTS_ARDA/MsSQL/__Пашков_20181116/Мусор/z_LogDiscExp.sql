--43163931	300000000	z_Replica_Ins_z_LogDiscExp_300000000 1444549,'<Нет дисконтной карты>',0,11035,300026465,1,27,0.000000000,46.236559140,'2016-12-19T18:02:00',0,NULL,NULL,4	2	Violation of PRIMARY KEY constraint 'pk_z_LogDiscExp'. Cannot insert duplicate key in object 'dbo.z_LogDiscExp'. The duplicate key value is (4, 1444549).	2016-12-19 18:05:00.000
--43163964	300000000	z_Replica_Ins_z_LogDiscExp_300000000 1444551,'<Нет дисконтной карты>',0,11035,300026467,1,27,0.000000000,14.249790444,'2016-12-19T18:15:00',0,NULL,NULL,4	2	Violation of PRIMARY KEY constraint 'pk_z_LogDiscExp'. Cannot insert duplicate key in object 'dbo.z_LogDiscExp'. The duplicate key value is (4, 1444551).	2016-12-19 18:20:00.000
--43163999	300000000	z_Replica_Ins_z_LogDiscExp_300000000 1444553,'<Нет дисконтной карты>',0,11035,300026468,1,27,0.000000000,14.993917275,'2016-12-19T18:21:00',0,NULL,NULL,4	2	Violation of PRIMARY KEY constraint 'pk_z_LogDiscExp'. Cannot insert duplicate key in object 'dbo.z_LogDiscExp'. The duplicate key value is (4, 1444553).	2016-12-19 18:25:00.000
--43164013	300000000	z_Replica_Ins_z_LogDiscExp_300000000 1444556,'<Нет дисконтной карты>',0,11035,300026469,1,27,0.000000000,10.280373832,'2016-12-19T18:27:00',0,NULL,NULL,4	2	Violation of PRIMARY KEY constraint 'pk_z_LogDiscExp'. Cannot insert duplicate key in object 'dbo.z_LogDiscExp'. The duplicate key value is (4, 1444556).	2016-12-19 18:30:00.000
--43164024	300000000	z_Replica_Ins_z_LogDiscExp_300000000 1444557,'<Нет дисконтной карты>',0,11035,300026469,2,27,0.000000000,46.236559140,'2016-12-19T18:27:00',0,NULL,NULL,4	2	Violation of PRIMARY KEY constraint 'pk_z_LogDiscExp'. Cannot insert duplicate key in object 'dbo.z_LogDiscExp'. The duplicate key value is (4, 1444557).	2016-12-19 18:30:00.000

--z_LogDiscExp

select * from [s-marketa3].elitv_dp2.dbo.z_LogDiscExp 
where  logid in (1444557) and chid = 100189360

select * from z_LogDiscExp 
where logid in (1444561) 

select * from z_LogDiscExp 
where  chid = 100189361

select LogID - 300000 as LogID, * from z_LogDiscExp 
where DBiID <> 2 and TempBonus = 1 and DocCode = 1011 and LogID >= 1444444
order by LogDate desc 

select * from t_sale where DCardID = '2220000188371' --ChID in ( 100189361,100189360)

select * from [s-marketa3].elitv_dp2.dbo.t_sale where ChID in ( 100189361,100189360)

--select * from t_sale where DocTime between '2016-12-19 17:40:00' and '2016-12-19 17:50:00'


--select * from [s-marketa3].elitv_dp2.dbo.t_sale where DocTime between '2016-12-19 17:40:00' and '2016-12-19 17:50:00'
 
select * from at_t_IORes where Docdate  = '2016-12-19' and DCardID = '2220000188371' 

ChID	DocID	IntDocID	InDocID	DocDate	ExpDate	KursMC	OurID	StockID	CompID	CurrID	ClientID	ReserveProds	CodeID1	CodeID2	CodeID3	CodeID4	CodeID5	StateCode	EmpID	Discount	Notes	PayDelay	Address	Recipient	Phone	DCardID	TSumCC_nt	TTaxSum	TSumCC_wt	TPurSumCC_nt	TPurTaxSum	TPurSumCC_wt	RemSchID	ExpTime
100017130	121661	121661	0	2016-12-19 00:00:00	2016-12-22 00:00:00	27.000000000	9	1252	117	980	1558782	1	63	18	78	123	5004	110	0	0.000000000		0	Харьков 	Владислав	0955437343	2220000188371	2500.833333360	500.166666640	3001.000000000	3438.166666710	687.633333290	4125.800000000	1	10:00 - 12:00
100017131	121661	121661	0	2016-12-19 00:00:00	2016-12-22 00:00:00	27.000000000	9	1252	117	980	1558782	1	63	18	78	123	5004	110	0	0.000000000		0	Харьков 	Владислав	0955437343	2220000188371	1279.249999980	255.850000020	1535.100000000	1279.249999980	255.850000020	1867.400000000	2	10:00 - 12:00


select * from [s-marketa3].elitv_dp2.dbo.z_LogDiscExp order by LogDate desc 

where  logid in (1144560) and chid = 100189360

select * from z_LogDiscExp 
where DBiID <> 2
--and logid in (1144560) 
order by LogDate desc 

select * from [s-marketa3].elitv_dp2.dbo.z_LogDiscExp order by LogDate desc 

