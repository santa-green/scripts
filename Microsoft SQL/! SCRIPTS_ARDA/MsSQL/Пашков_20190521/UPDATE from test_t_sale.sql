select * from test_t_sale  --2577


select * from t_sale where ChID in (select ChID from test_t_sale) and chid in (100389702)
except
select * from test_t_sale 

100379446	127475	2016-10-01 00:00:00	26.000000000	12	1315	1	63	18	89	0	0	0.000000000		160	317		2016-09-30 21:34:00	0	1900-01-01 00:00:00	<Нет дисконтной карты>	10473	11111	0.000000000	0.000000000	980	70.000000000	0.000000000	49.000000000	140	260	5	70.000000000	0.000000000	70.000000000	2016-10-01 15:36:25.000	0	0	0			1900-01-01 00:00:00	0	49.000000000	0.000000000	0
100379447	127477	2016-10-01 00:00:00	26.000000000	12	1315	1	63	18	89	0	0	0.000000000		160	325		2016-10-01 10:22:00	0	1900-01-01 00:00:00	<Нет дисконтной карты>	10487	11111	0.000000000	0.000000000	980	68.000000000	0.000000000	61.200000000	140	401	5	68.000000000	0.000000000	68.000000000	2016-10-01 12:32:37.000	0	0	0			1900-01-01 00:00:00	0	61.200000000	0.000000000	0
    
    
    
select * from test_t_sale where ChID in (100389702)
select * from t_sale where ChID in (100389702) 
ChID	DocID	DocDate	KursMC	OurID	StockID	CompID	CodeID1	CodeID2	CodeID3	CodeID4	CodeID5	Discount	Notes	CRID	OperID	CreditID	DocTime	TaxDocID	TaxDocDate	DCardID	EmpID	IntDocID	CashSumCC	ChangeSumCC	CurrID	TSumCC_nt	TTaxSum	TSumCC_wt	StateCode	DeskCode	Visitors	TPurSumCC_nt	TPurTaxSum	TPurSumCC_wt	DocCreateTime	DepID	ClientID	InDocID	ExpTime	DeclNum	DeclDate	BLineID	TRealSum	TLevySum	RemSchID
100389702	129260	2016-11-07 00:00:00	27.000000000	9	1315	1	63	18	81	0	0	0.000000000		154	239		2016-11-07 18:56:00	79	2016-11-07 00:00:00	<Нет дисконтной карты>	10299	11111	0.000000000	0.000000000	980	96.000000000	0.000000000	96.000000000	140	288	5	80.000000000	15.230000000	96.000000000	2016-11-07 21:03:16.000	0	0	0			1900-01-01 00:00:00	0	96.000000000	0.000000000	0
100389702	129260	2016-11-07 00:00:00	26.000000000	9	1315	1	63	18	81	0	0	0.000000000		154	239		2016-11-07 18:56:00	0	1900-01-01 00:00:00	<Нет дисконтной карты>	10299	11111	0.000000000	0.000000000	980	96.000000000	0.000000000	96.000000000	140	288	5	80.000000000	15.230000000	96.000000000	2016-11-07 21:03:16.000	0	0	0			1900-01-01 00:00:00	0	96.000000000	4.570000000	0


--a_zDocLinks_CheckValues_D



  
begin tran; 

--Обновление t_sale
disable TRIGGER [dbo].[a_zDocLinks_CheckValues_D] ON [dbo].[z_DocLinks] 

declare @chid int 
declare sale_update cursor for 
	select distinct chid from test_T_sale --where chid in (100389702)
	ORDER BY chid 
	
OPEN sale_update 

FETCH NEXT FROM sale_update INTO @chid
WHILE @@FETCH_STATUS = 0
BEGIN

print @chid

		UPDATE dbo.t_Sale   
		SET 
		--dbo.t_Sale.ChID =       dbo.test_T_sale.ChID ,           
		--dbo.t_Sale.DocID =		dbo.test_T_sale.DocID ,
		dbo.t_Sale.DocDate =	dbo.test_T_sale.DocDate ,
		dbo.t_Sale.KursMC =		dbo.test_T_sale.KursMC ,
		dbo.t_Sale.OurID =		dbo.test_T_sale.OurID ,
		dbo.t_Sale.StockID =	dbo.test_T_sale.StockID ,
		dbo.t_Sale.CompID =		dbo.test_T_sale.CompID ,
		dbo.t_Sale.CodeID1 =	dbo.test_T_sale.CodeID1 ,
		dbo.t_Sale.CodeID2 =	dbo.test_T_sale.CodeID2 ,
		dbo.t_Sale.CodeID3 =	dbo.test_T_sale.CodeID3 ,
		dbo.t_Sale.CodeID4 =	dbo.test_T_sale.CodeID4 ,
		dbo.t_Sale.CodeID5 =	dbo.test_T_sale.CodeID5 ,
		dbo.t_Sale.Discount =	dbo.test_T_sale.Discount ,
		dbo.t_Sale.Notes =		dbo.test_T_sale.Notes ,
		dbo.t_Sale.CRID =		dbo.test_T_sale.CRID ,
		dbo.t_Sale.OperID =		dbo.test_T_sale.OperID ,
		dbo.t_Sale.CreditID =	dbo.test_T_sale.CreditID ,
		dbo.t_Sale.DocTime =	dbo.test_T_sale.DocTime ,
		--dbo.t_Sale.TaxDocID =	dbo.test_T_sale.TaxDocID ,
		--dbo.t_Sale.TaxDocDate =	dbo.test_T_sale.TaxDocDate ,
		dbo.t_Sale.DCardID =	dbo.test_T_sale.DCardID ,
		dbo.t_Sale.EmpID =		dbo.test_T_sale.EmpID ,
		dbo.t_Sale.IntDocID =	dbo.test_T_sale.IntDocID ,
		dbo.t_Sale.CashSumCC =	dbo.test_T_sale.CashSumCC ,
		dbo.t_Sale.ChangeSumCC =	dbo.test_T_sale.ChangeSumCC ,
		dbo.t_Sale.CurrID =		dbo.test_T_sale.CurrID ,
		dbo.t_Sale.TSumCC_nt =	dbo.test_T_sale.TSumCC_nt ,
		dbo.t_Sale.TTaxSum =	dbo.test_T_sale.TTaxSum ,
		dbo.t_Sale.TSumCC_wt =	dbo.test_T_sale.TSumCC_wt ,
		dbo.t_Sale.StateCode =	dbo.test_T_sale.StateCode ,
		dbo.t_Sale.DeskCode =	dbo.test_T_sale.DeskCode ,
		dbo.t_Sale.Visitors =	dbo.test_T_sale.Visitors ,
		dbo.t_Sale.TPurSumCC_nt =	dbo.test_T_sale.TPurSumCC_nt ,
		dbo.t_Sale.TPurTaxSum =	dbo.test_T_sale.TPurTaxSum ,
		dbo.t_Sale.TPurSumCC_wt =	dbo.test_T_sale.TPurSumCC_wt ,
		dbo.t_Sale.DocCreateTime =	dbo.test_T_sale.DocCreateTime ,
		dbo.t_Sale.DepID =		dbo.test_T_sale.DepID ,
		dbo.t_Sale.ClientID =	dbo.test_T_sale.ClientID ,
		dbo.t_Sale.InDocID =	dbo.test_T_sale.InDocID ,
		dbo.t_Sale.ExpTime =	dbo.test_T_sale.ExpTime ,
		dbo.t_Sale.DeclNum =	dbo.test_T_sale.DeclNum ,
		dbo.t_Sale.DeclDate =	dbo.test_T_sale.DeclDate ,
		dbo.t_Sale.BLineID =	dbo.test_T_sale.BLineID ,
		dbo.t_Sale.TRealSum =	dbo.test_T_sale.TRealSum ,
		dbo.t_Sale.TLevySum =	dbo.test_T_sale.TLevySum ,
		dbo.t_Sale.RemSchID =	dbo.test_T_sale.RemSchID 
FROM dbo.t_Sale   
	INNER JOIN dbo.test_T_sale  
	ON dbo.t_Sale.chid = dbo.test_T_sale.chid  and dbo.test_T_sale.chid = @chid
			
FETCH NEXT FROM sale_update INTO @chid 
END    
close sale_update
deallocate sale_update;

Enable TRIGGER [dbo].[a_zDocLinks_CheckValues_D] ON [dbo].[z_DocLinks]


rollback tran


