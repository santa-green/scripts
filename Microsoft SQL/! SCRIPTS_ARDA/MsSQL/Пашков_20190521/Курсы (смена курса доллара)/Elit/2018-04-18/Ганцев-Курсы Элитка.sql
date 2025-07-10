--------------------
DISABLE TRIGGER TRel2_Upd_t_Epp on t_Epp;
DISABLE TRIGGER TRel2_Upd_t_Rec on t_Rec;
DISABLE TRIGGER [TRel2_Upd_t_Ret] on [dbo].[t_Ret];
DISABLE Trigger ALL ON  [dbo].[t_Inv];
DISABLE Trigger [TRel2_Upd_at_t_IORes]  ON  [dbo].[at_t_IORes];
DISABLE Trigger [a_cCompRec_CheckCompExpDebt_IUD]  ON  [dbo].[c_CompRec];
DISABLE Trigger TRel2_Upd_c_CompRec on c_CompRec;

Enable TRIGGER [TRel2_Upd_t_Ret] on [dbo].[t_Ret];
ENABLE Trigger ALL ON  [dbo].[t_Inv];
ENABLE Trigger [TRel2_Upd_at_t_IORes]  ON  [dbo].[at_t_IORes];
ENABLE Trigger [a_cCompRec_CheckCompExpDebt_IUD]  ON  [dbo].[c_CompRec];
ENABLE Trigger TRel2_Upd_c_CompRec on c_CompRec;
ENABLE TRIGGER TRel2_Upd_t_Rec on t_Rec;
ENABLE TRIGGER TRel2_Upd_t_Epp on t_Epp;

---------------------------------------------

Enable TRIGGER a_tRem_ChangeDenied_IUD on t_Rem;
Enable TRIGGER a_tInv_ChangeDenied_IUD on t_Inv;
Enable TRIGGER a_tRet_ChangeDenied_IUD on t_Ret;
Enable TRIGGER a_tRec_ChangeDenied_IUD on t_Rec;

DISABLE TRIGGER a_tRem_ChangeDenied_IUD on t_Rem;
DISABLE TRIGGER a_tInv_ChangeDenied_IUD on t_Inv;
DISABLE TRIGGER a_tRet_ChangeDenied_IUD on t_Ret;
DISABLE TRIGGER a_tRec_ChangeDenied_IUD on t_Rec;




--Приход товара
--t_Rec

Begin Tran
Update d
set d.KursMC =27.00
From t_Rec d 
where DocDate >='2018-04-01' and d.KursMC=28.00
and d.OurID in (1,2,3,4,5,10,11) and d.CodeID1 in (40,41,64,42,81,82,87,95,100,2004,90)
Rollback

--Возврат товара от получателя
--t_Ret

Begin Tran
Update d
set d.KursMC =27.00
From t_Ret d 
where DocDate >='2018-04-01' and d.KursMC=28.00
and d.OurID in (1,2,3,4,5,10,11) and d.CodeID1 in (63,79,2004)
Rollback

--Расходная накладная
--t_Inv

Begin Tran
Update d
set d.KursMC =27.00
From t_Inv d 
where  DocDate >='2018-04-01' and d.KursMC=28.00
and d.OurID in (1,2,3,4,5,10,11) and d.CodeID1 in (63,71,73,79,64,42)
Rollback

--Расходный документ
--t_Exp

Begin Tran
Update d
set d.KursMC =27.00
From t_Exp d 
where  DocDate >='2018-04-01'  and d.KursMC=28.00
and d.OurID in (1,2,3,4,5,10,11) and d.CodeID1 in (2004,2011,2012,2016,2022,2030,2031,2032,2038,2020,24,30,36,50,26)
Rollback

--Расходный документ в ценах прихода
--t_Epp

Begin Tran
Update d
set d.KursMC =27.00
From t_Epp d 
where DocDate >='2018-04-01'  and d.KursMC=28.00
and d.OurID in (1,2,3,4,5,10,11) and d.CodeID1 in (24,40,41,42,63,64,100,2004,2011,2026,2031)
Rollback

--Перемещение товара
--t_Exc

Begin Tran
Update d
set d.KursMC =27.00
From t_Exc d 
where DocDate >='2018-04-01'  and d.KursMC=28.00
and d.OurID in (1,2,3,4,5,10,11) and d.CodeID1 in (40,41,80)
Rollback

--Заказ внутренний: Формирование: Заголовок
t_IORec

Begin Tran
Update d
set d.KursMC =27.00
From t_IORec d 
where DocDate >='2018-04-01' and d.KursMC=28.00
and d.OurID in (1,2,3,4,5,10,11) and d.CodeID1 in (50,51,52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79,2032,2012)
Rollback


----Заказ внутренний: Резерв: Заголовок
--at_t_IORes

Begin Tran
Update d
set d.KursMC =27.00
From at_t_IORes d 
where DocDate >='2018-04-01' and d.KursMC=28.00
and d.OurID in (1,2,3,4,5,10,11) and d.CodeID1 in (50,51,52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79,2032,2012)
Rollback



--Разукомплектация товара: Заголовок
--t_SExp

Begin Tran
Update d
set d.KursMC =27.00
From t_SExp d 
where DocDate >='2018-04-01' and d.KursMC=28.00
and d.OurID in (1,2,3,4,5,10,11) and d.CodeID1 in(100)
Rollback

--Комплектация товара: Заголовок
--t_SRec

Begin Tran
Update d
set d.KursMC =27.00
From t_SRec d 
where DocDate >='2018-04-01' and d.KursMC=28.00
and d.OurID in (1,2,3,4,5,10,11) and d.CodeID1 in(100)
Rollback

--Приход денег по предприятиям
c_CompRec

Begin Tran
Update d
set d.KursMC =27.00
From c_CompRec d 
where DocDate >='2018-04-01' and d.KursMC=28.00
and d.OurID in (1,2,3,4,5,10,11)
Rollback

--Расход денег по предприятиям
c_CompExp

Begin Tran
Update d
set d.KursMC =27.00
From c_CompExp d 
where DocDate >='2018-04-01' and d.KursMC=28.00
and d.OurID in (1,2,3,4,5,10,11)
Rollback



--Изменение Цены ОВ и Себестоимости ОВ в Приходах

Begin Tran 
Update p
Set p.PriceMC_IN = p.PriceAC_In/c.KursMC,
 	p.CostMC = p.CostAC/c.KursMC
From t_Rec r 
join t_recD rd on r.ChID = rd.Chid
join t_Pinp p on rd.ProdID = p.ProdID and rd.PPID = p.PPID
join r_Currs c on p.CurrID=c.CurrID
where DocDate >='2018-04-01' and c.CurrID=2 and r.Ourid in (1,2,3,4,5,10,11) and r.CodeID1 in (81,82,87,95,100,2004,90)

Select p.*
From t_Rec r 
join t_recD rd on r.ChID = rd.Chid
join t_Pinp p on rd.ProdID = p.ProdID and rd.PPID = p.PPID
join r_Currs c on p.CurrID=c.CurrID

where DocDate >='2018-04-01' and c.CurrID=2 and r.Ourid in (1,2,3,4,5,10,11) and r.CodeID1 in (81,82,87,95,100,2004,90)
Order By ProdID

Rollback Tran


----Пересчет Цен
--Расходный документ
--t_Exp


Begin Tran
Update ed
Set PriceCC_nt = Round((PriceCC_nt/28)*27,2), SumCC_nt=Round((SumCC_nt/28)*27,2), Tax=Round((Tax/28)*27,2), TaxSum=Round((TaxSum/28)*27,2), PriceCC_wt=Round((PriceCC_wt/28)*27,2), SumCC_wt=Round((SumCC_wt/28)*27,2)
From t_Exp d join t_ExpD ed on d.ChiD=ed.ChID
where d.DocDate >='2018-04-01' and d.KursMC=28.00
and d.OurID in (1,2,3,4,5,10,11) and d.CodeID1 in (2004,2011,2012,2016,2022,2030,2031,2032,2038,2020)

Select ed.*
From t_Exp d join t_ExpD ed on d.ChiD=ed.ChID
where d.DocDate >='2018-04-01' and d.KursMC=28.00
and d.OurID in (1,2,3,4,5,10,11) and d.CodeID1 in (2004,2011,2012,2016,2022,2030,2031,2032,2038,2020)
Rollback Tran
Select ed.*
From t_Exp d join t_ExpD ed on d.ChiD=ed.ChID
where d.DocDate >='2018-04-01' and d.KursMC=28.00
and d.OurID in (1,2,3,4,5,10,11) and d.CodeID1 in (2004,2011,2012,2016,2022,2030,2031,2032,2038,2020)


--Расходный документ в ценах прихода
--t_Epp

Begin Tran
Update ed
Set PriceCC_nt = Round((PriceCC_nt/28)*27,2), SumCC_nt=Round((SumCC_nt/28)*27,2), Tax=Round((Tax/28)*27,2), TaxSum=Round((TaxSum/28)*27,2), PriceCC_wt=Round((PriceCC_wt/28)*27,2), SumCC_wt=Round((SumCC_wt/28)*27,2)
From t_Epp d Join t_EppD ed on d.Chid=ed.Chid
where DocDate >='2018-04-01' and d.KursMC=28.00
and d.OurID in (1,2,3,4,5,10,11) and d.CodeID1 in (2004,2011,2026,2031)
Rollback
