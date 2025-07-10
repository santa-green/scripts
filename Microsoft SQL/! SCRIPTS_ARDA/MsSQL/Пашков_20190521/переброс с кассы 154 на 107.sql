begin tran; 


--переброс с кассы 154(фискальная) на кассу 107 (Виртуальная Винтаж ЧП - Бар)
disable TRIGGER [dbo].[a_zDocLinks_CheckValues_D] ON [dbo].[z_DocLinks] ;

declare @chid int = 100396996
print @chid
select * from dbo.t_Sale where dbo.t_sale.chid = @chid

		UPDATE dbo.t_Sale   
		SET 
		--dbo.t_Sale.ChID =       dbo.test_T_sale.ChID ,           
		--dbo.t_Sale.DocID =		dbo.test_T_sale.DocID ,
		--dbo.t_Sale.DocDate =	dbo.test_T_sale.DocDate ,
		--dbo.t_Sale.KursMC =		dbo.test_T_sale.KursMC ,
		--dbo.t_Sale.OurID =		dbo.test_T_sale.OurID ,
		--dbo.t_Sale.StockID =	dbo.test_T_sale.StockID ,
		--dbo.t_Sale.CompID =		dbo.test_T_sale.CompID ,
		--dbo.t_Sale.CodeID1 =	dbo.test_T_sale.CodeID1 ,
		--dbo.t_Sale.CodeID2 =	dbo.test_T_sale.CodeID2 ,
		dbo.t_Sale.CodeID3 =	89 ,
		--dbo.t_Sale.CodeID4 =	dbo.test_T_sale.CodeID4 ,
		--dbo.t_Sale.CodeID5 =	dbo.test_T_sale.CodeID5 ,
		--dbo.t_Sale.Discount =	dbo.test_T_sale.Discount ,
		dbo.t_Sale.Notes =		'Ручной переброс с кассы 154 на 107 (pvm0)', 
		dbo.t_Sale.CRID =		107 
		--dbo.t_Sale.OperID =		dbo.test_T_sale.OperID ,
		--dbo.t_Sale.CreditID =	dbo.test_T_sale.CreditID ,
		--dbo.t_Sale.DocTime =	dbo.test_T_sale.DocTime ,
		----dbo.t_Sale.TaxDocID =	dbo.test_T_sale.TaxDocID ,
		----dbo.t_Sale.TaxDocDate =	dbo.test_T_sale.TaxDocDate ,
		--dbo.t_Sale.DCardID =	dbo.test_T_sale.DCardID ,
		--dbo.t_Sale.EmpID =		dbo.test_T_sale.EmpID ,
		--dbo.t_Sale.IntDocID =	dbo.test_T_sale.IntDocID ,
		--dbo.t_Sale.CashSumCC =	dbo.test_T_sale.CashSumCC ,
		--dbo.t_Sale.ChangeSumCC =	dbo.test_T_sale.ChangeSumCC ,
		--dbo.t_Sale.CurrID =		dbo.test_T_sale.CurrID ,
		--dbo.t_Sale.TSumCC_nt =	dbo.test_T_sale.TSumCC_nt ,
		--dbo.t_Sale.TTaxSum =	dbo.test_T_sale.TTaxSum ,
		--dbo.t_Sale.TSumCC_wt =	dbo.test_T_sale.TSumCC_wt ,
		--dbo.t_Sale.StateCode =	dbo.test_T_sale.StateCode ,
		--dbo.t_Sale.DeskCode =	dbo.test_T_sale.DeskCode ,
		--dbo.t_Sale.Visitors =	dbo.test_T_sale.Visitors ,
		--dbo.t_Sale.TPurSumCC_nt =	dbo.test_T_sale.TPurSumCC_nt ,
		--dbo.t_Sale.TPurTaxSum =	dbo.test_T_sale.TPurTaxSum ,
		--dbo.t_Sale.TPurSumCC_wt =	dbo.test_T_sale.TPurSumCC_wt ,
		--dbo.t_Sale.DocCreateTime =	dbo.test_T_sale.DocCreateTime ,
		--dbo.t_Sale.DepID =		dbo.test_T_sale.DepID ,
		--dbo.t_Sale.ClientID =	dbo.test_T_sale.ClientID ,
		--dbo.t_Sale.InDocID =	dbo.test_T_sale.InDocID ,
		--dbo.t_Sale.ExpTime =	dbo.test_T_sale.ExpTime ,
		--dbo.t_Sale.DeclNum =	dbo.test_T_sale.DeclNum ,
		--dbo.t_Sale.DeclDate =	dbo.test_T_sale.DeclDate ,
		--dbo.t_Sale.BLineID =	dbo.test_T_sale.BLineID ,
		--dbo.t_Sale.TRealSum =	dbo.test_T_sale.TRealSum ,
		--dbo.t_Sale.TLevySum =	dbo.test_T_sale.TLevySum ,
		--dbo.t_Sale.RemSchID =	dbo.test_T_sale.RemSchID 
from dbo.t_Sale  where dbo.t_sale.chid = @chid


;Enable TRIGGER [dbo].[a_zDocLinks_CheckValues_D] ON [dbo].[z_DocLinks];


rollback tran;
