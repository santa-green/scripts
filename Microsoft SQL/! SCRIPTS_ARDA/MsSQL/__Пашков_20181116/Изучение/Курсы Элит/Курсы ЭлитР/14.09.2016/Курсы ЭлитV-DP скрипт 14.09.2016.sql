DISABLE TRIGGER [TRel2_Upd_t_Ret] on [dbo].[t_Ret];
DISABLE TRIGGER [TRel2_Upd_t_CRRet] on [dbo].[t_CRRet];
DISABLE TRIGGER [TRel2_Upd_t_CRet] on [dbo].[t_CRet];
DISABLE TRIGGER [TRel2_Upd_t_Ven] on [dbo].[t_Ven];
DISABLE TRIGGER [TRel2_Upd_t_SRec] on [dbo].[t_SRec];
DISABLE TRIGGER [TRel2_Upd_t_Exc] on [dbo].[t_Exc];
DISABLE TRIGGER [TRel2_Upd_t_MonRec] on [dbo].[t_MonRec];
DISABLE TRIGGER [TRel2_Upd_t_Rec] on [dbo].[t_Rec];
DISABLE TRIGGER [TRel2_Upd_t_Sale] on [dbo].[t_Sale];
DISABLE TRIGGER [TRel2_Upd_t_SExp] on [dbo].[t_SExp];
DISABLE TRIGGER [TRel2_Upd_t_Inv] on [dbo].[t_Inv];
DISABLE TRIGGER [TRel2_Upd_t_Exp] on [dbo].[t_Exp];
DISABLE TRIGGER [TRel2_Upd_t_Epp] on [dbo].[t_Epp];
--DISABLE TRIGGER [a_tExc_IU] on [dbo].[t_Exc];
--DISABLE TRIGGER [a_tRec_IU] on [dbo].[t_Rec];
DISABLE TRIGGER [a_tSale_CheckValues_U] on [dbo].[t_Sale];
DISABLE TRIGGER a_cCompRec_IUD on c_CompRec;
DISABLE TRIGGER a_cCompExp_IUD on c_CompExp;
--DISABLE TRIGGER a_tPInP_IUD on t_PInP;

Возврат товара от получателя
t_Ret

Begin Tran
Update d
set d.KursMC =27.00
From t_Ret d 
where DocDate Between Cast ('20160901' as SMALLDATETIME) and Cast ('20160930' as SMALLDATETIME) and d.KursMC=26.00
and d.OurID in (7,8,9,12) and d.CodeID1 in (2004)
Rollback

Возврат товара по чеку
t_CRRet

Begin Tran
Update d
set d.KursMC =27.00
From t_CRRet d 
where DocDate Between Cast ('20160901' as SMALLDATETIME) and Cast ('20160930' as SMALLDATETIME) and d.KursMC=26.00
and d.OurID in (7,8,9,12) and d.CodeID1 in (63)
Rollback

Возврат товара поставщику
t_CRet

Begin Tran
Update d
set d.KursMC =27.00
From t_CRet d 
where DocDate Between Cast ('20160901' as SMALLDATETIME) and Cast ('20160930' as SMALLDATETIME) and d.KursMC=26.00
and d.OurID in (7,8,9,12) and d.CodeID1 in (82)
Rollback

Инвентаризация товара
t_Ven

Begin Tran
Update d
set d.KursMC =27.00
From t_Ven d 
where DocDate Between Cast ('20160901' as SMALLDATETIME) and Cast ('20160930' as SMALLDATETIME) and d.KursMC=26.00
and d.OurID in (7,8,9,12) and d.CodeID1 in (2004)
Rollback

Комплектация товара
t_SRec

Begin Tran
Update d
set d.KursMC =27.00
From t_SRec d 
where DocDate Between Cast ('20160901' as SMALLDATETIME) and Cast ('20160930' as SMALLDATETIME) and d.KursMC=26.00
and d.OurID in (7,8,9,12) and d.CodeID1 in (100)
Rollback

Перемещение товара
t_Exc

Begin Tran
Update d
set d.KursMC =27.00
From t_Exc d 
where DocDate Between Cast ('20160901' as SMALLDATETIME) and Cast ('20160930' as SMALLDATETIME) and d.KursMC=26.00
and d.OurID in (7,8,9,12) and d.CodeID1 in (40,41)
Rollback

a_tExc_IU

Прием наличных денег на склад
t_MonRec

Begin Tran
Update d
set d.KursMC =27.00
From t_MonRec d 
where DocDate Between Cast ('20160901' as SMALLDATETIME) and Cast ('20160930' as SMALLDATETIME) and d.KursMC=26.00
and d.OurID in (7,8,9,12) and d.CodeID1 in (63,10)
Rollback

Приход товара
t_Rec

Begin Tran
Update d
set d.KursMC =27.00
From t_Rec d 
where DocDate Between Cast ('20160901' as SMALLDATETIME) and Cast ('20160930' as SMALLDATETIME) and d.KursMC=26.00
and d.OurID in (7,8,9,12) and d.CodeID1 in (82,87,100,2004)
Rollback

Продажа товара оператором
t_Sale

Begin Tran
Update d
set d.KursMC =27.00
From t_Sale d 
where DocDate Between Cast ('20160901' as SMALLDATETIME) and Cast ('20160930' as SMALLDATETIME) and d.KursMC=26.00
and d.OurID in (7,8,9,12) and d.CodeID1 in (63)
Rollback

Разукомплектация товара
t_SExp

Begin Tran
Update d
set d.KursMC =27.00
From t_SExp d 
where DocDate Between Cast ('20160901' as SMALLDATETIME) and Cast ('20160930' as SMALLDATETIME) and d.KursMC=26.00
and d.OurID in (7,8,9,12) and d.CodeID1 in (100)
Rollback

Расходная накладная
t_Inv

Begin Tran
Update d
set d.KursMC =27.00
From t_Inv d 
where DocDate Between Cast ('20160901' as SMALLDATETIME) and Cast ('20160930' as SMALLDATETIME) and d.KursMC=26.00
and d.OurID in (7,8,9,12) and d.CodeID1 in (63)
Rollback

Расходный документ
t_Exp

Begin Tran
Update d
set d.KursMC =27.00
From t_Exp d 
where DocDate Between Cast ('20160901' as SMALLDATETIME) and Cast ('20160930' as SMALLDATETIME) and d.KursMC=26.00
and d.OurID in (7,8,9,12) and d.CodeID1 in (2004,2032,2038)
Rollback

Расходный документ в ценах прихода
t_Epp

Begin Tran
Update d
set d.KursMC =27.00
From t_Epp d 
where DocDate Between Cast ('20160901' as SMALLDATETIME) and Cast ('20160930' as SMALLDATETIME) and d.KursMC=26.00
and d.OurID in (7,8,9,12) and d.CodeID1 in (100,2004)
Rollback

-- Изменение Цены ОВ и Себестоимости ОВ в Приходах
-- Обратить внимание на партию 0
Begin Tran 
Update p
Set p.PriceMC_IN = p.PriceAC_In/c.KursMC,
 	p.CostMC = p.CostAC/c.KursMC
From t_Rec r 
join t_recD rd on r.ChID = rd.Chid
join t_Pinp p on rd.ProdID = p.ProdID and rd.PPID = p.PPID
join r_Currs c on p.CurrID=c.CurrID
where r.DocDate Between Cast ('20160901' as SMALLDATETIME) and Cast ('20160930' as SMALLDATETIME) and c.CurrID=980 and r.Ourid in (7,8,9,12) and r.CodeID1 in (82,87,100,2004) and p.PPID != 0

Select p.*
From t_Rec r 
join t_recD rd on r.ChID = rd.Chid
join t_Pinp p on rd.ProdID = p.ProdID and rd.PPID = p.PPID
join r_Currs c on p.CurrID=c.CurrID

where r.DocDate Between Cast ('20160901' as SMALLDATETIME) and Cast ('20160930' as SMALLDATETIME) and c.CurrID=980 and r.Ourid in (7,8,9,12) and r.CodeID1 in (82,87,100,2004) and p.PPID != 0
Order By ProdID

Rollback Tran 


--Приход денег по предприятиям
c_CompRec

Begin Tran
Update d
set d.KursMC =27.00
From c_CompRec d 
where DocDate Between Cast ('20160901' as SMALLDATETIME) and Cast ('20160930' as SMALLDATETIME) and d.KursMC=26.00
and d.OurID in (7,8,9,12)
Rollback

--Расход денег по предприятиям
c_CompExp

Begin Tran
Update d
set d.KursMC =27.00
From c_CompExp d 
where DocDate Between Cast ('20160901' as SMALLDATETIME) and Cast ('20160930' as SMALLDATETIME) and d.KursMC=26.00
and d.OurID in (7,8,9,12)
Rollback

--Пересчет Цен
Расходный документ
t_Exp


Begin Tran
Update ed
Set PriceCC_nt = Round((PriceCC_nt/26)*27,2), SumCC_nt=Round((SumCC_nt/26)*27,2), Tax=Round((Tax/26)*27,2), TaxSum=Round((TaxSum/26)*27,2), PriceCC_wt=Round((PriceCC_wt/26)*27,2), SumCC_wt=Round((SumCC_wt/26)*27,2)
From t_Exp d join t_ExpD ed on d.ChiD=ed.ChID
where d.DocDate Between Cast ('20160901' as SMALLDATETIME) and Cast ('20160930' as SMALLDATETIME) and d.KursMC=26.00
and d.OurID in (7,8,9,12) and d.CodeID1 in (2004, 2032, 2038)

Select ed.*
From t_Exp d join t_ExpD ed on d.ChiD=ed.ChID
where d.DocDate Between Cast ('20160901' as SMALLDATETIME) and Cast ('20160930' as SMALLDATETIME) and d.KursMC=26.00
and d.OurID in (7,8,9,12) and d.CodeID1 in (2004, 2032, 2038)
Rollback Tran
Select ed.*
From t_Exp d join t_ExpD ed on d.ChiD=ed.ChID
where d.DocDate Between Cast ('20160901' as SMALLDATETIME) and Cast ('20160930' as SMALLDATETIME) and d.KursMC=26.00
and d.OurID in (7,8,9,12) and d.CodeID1 in (2004, 2032, 2038)


Расходный документ в ценах прихода
t_Epp

Begin Tran
Update ed
Set PriceCC_nt = Round((PriceCC_nt/26)*27,2), SumCC_nt=Round((SumCC_nt/26)*27,2), Tax=Round((Tax/26)*27,2), TaxSum=Round((TaxSum/26)*27,2), PriceCC_wt=Round((PriceCC_wt/26)*27,2), SumCC_wt=Round((SumCC_wt/26)*27,2)
From t_Epp d Join t_EppD ed on d.Chid=ed.Chid
where DocDate Between Cast ('20160901' as SMALLDATETIME) and Cast ('20160930' as SMALLDATETIME) and d.KursMC=26.00
and d.OurID in (7,8,9,12) and d.CodeID1 in (2004)
Rollback


Enable TRIGGER a_cCompRec_IUD on c_CompRec;
Enable TRIGGER a_cCompExp_IUD on c_CompExp;
Enable TRIGGER [TRel2_Upd_t_Ret] on [dbo].[t_Ret];
Enable TRIGGER [TRel2_Upd_t_CRRet] on [dbo].[t_CRRet];
Enable TRIGGER [TRel2_Upd_t_CRet] on [dbo].[t_CRet];
Enable TRIGGER [TRel2_Upd_t_Ven] on [dbo].[t_Ven];
Enable TRIGGER [TRel2_Upd_t_SRec] on [dbo].[t_SRec];
Enable TRIGGER [TRel2_Upd_t_Exc] on [dbo].[t_Exc];
Enable TRIGGER [TRel2_Upd_t_MonRec] on [dbo].[t_MonRec];
Enable TRIGGER [TRel2_Upd_t_Rec] on [dbo].[t_Rec];
Enable TRIGGER [TRel2_Upd_t_Sale] on [dbo].[t_Sale];
Enable TRIGGER [TRel2_Upd_t_SExp] on [dbo].[t_SExp];
Enable TRIGGER [TRel2_Upd_t_Inv] on [dbo].[t_Inv];
Enable TRIGGER [TRel2_Upd_t_Exp] on [dbo].[t_Exp];
Enable TRIGGER [TRel2_Upd_t_Epp] on [dbo].[t_Epp];
--Enable TRIGGER [a_tExc_IU] on [dbo].[t_Exc];
--Enable TRIGGER [a_tRec_IU] on [dbo].[t_Rec];
Enable TRIGGER [a_tSale_CheckValues_U] on [dbo].[t_Sale];
--Enable TRIGGER a_tPInP_IUD on t_PInP;