--43163929	300000000	z_Replica_Ins_z_LogDiscRec_300000000 14380151,'<Нет дисконтной карты>',0,11035,300026465,1,47,30.000000000,'2016-12-19T18:02:00',0,NULL,4	2	Violation of PRIMARY KEY constraint 'pk_z_LogDiscRec'. Cannot insert duplicate key in object 'dbo.z_LogDiscRec'. The duplicate key value is (4, 14380151).	2016-12-19 18:05:00.000


select * from [s-marketa3].elitv_dp2.dbo.z_LogDiscRec 
where  logid in (14380151) and chid = 100189360

select * from z_LogDiscRec 
where logid in (14380152) 

select * from z_LogDiscRec 
where  chid = 100189361

select * from z_LogDiscRec 
where DBiID <> 2 --and LogID >= 14380151
order by LogDate desc 

select * from t_sale where DCardID = '2220000188371' --ChID in ( 100189361,100189360)

select * from [s-marketa3].elitv_dp2.dbo.t_sale where ChID in ( 100189361,100189360)

--select * from t_sale where DocTime between '2016-12-19 17:40:00' and '2016-12-19 17:50:00'


--select * from [s-marketa3].elitv_dp2.dbo.t_sale where DocTime between '2016-12-19 17:40:00' and '2016-12-19 17:50:00'
 
select * from at_t_IORes where Docdate  = '2016-12-19' and DCardID = '2220000188371' 

ChID	DocID	IntDocID	InDocID	DocDate	ExpDate	KursMC	OurID	StockID	CompID	CurrID	ClientID	ReserveProds	CodeID1	CodeID2	CodeID3	CodeID4	CodeID5	StateCode	EmpID	Discount	Notes	PayDelay	Address	Recipient	Phone	DCardID	TSumCC_nt	TTaxSum	TSumCC_wt	TPurSumCC_nt	TPurTaxSum	TPurSumCC_wt	RemSchID	ExpTime
100017130	121661	121661	0	2016-12-19 00:00:00	2016-12-22 00:00:00	27.000000000	9	1252	117	980	1558782	1	63	18	78	123	5004	110	0	0.000000000		0	Харьков 	Владислав	0955437343	2220000188371	2500.833333360	500.166666640	3001.000000000	3438.166666710	687.633333290	4125.800000000	1	10:00 - 12:00
100017131	121661	121661	0	2016-12-19 00:00:00	2016-12-22 00:00:00	27.000000000	9	1252	117	980	1558782	1	63	18	78	123	5004	110	0	0.000000000		0	Харьков 	Владислав	0955437343	2220000188371	1279.249999980	255.850000020	1535.100000000	1279.249999980	255.850000020	1867.400000000	2	10:00 - 12:00