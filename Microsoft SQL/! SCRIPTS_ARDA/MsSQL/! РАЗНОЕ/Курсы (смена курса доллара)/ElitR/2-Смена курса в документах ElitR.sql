--изменение курса в документах Базы ElitR

/*
Заявка на изменение курса						
						
1. Модуль "Бизнес"						
Документ	Параметры для фильтра					Действие
	дата	фирма	Валюта документа	Курс, ОВ	Признак 1	
--Приход товара	01.09.2018-31.09.2018	6,7,8,9,12	980	29	82, 87, 100, 2004	изменить курс, без пересчета цен документа с изменением текущего КЦП
--Перемещение товара	01.09.2018-31.09.2018	6,7,8,9,12	980	29	40, 41	изменить курс, без пересчета цен документа и БЕЗ изменения КЦП
--Инвентаризация	01.09.2018-31.09.2018	6,7,8,9,12	980	29	2004	изменить курс с пересчетом цен документа и БЕЗ изменения КЦП
--Возврат	01.09.2018-31.09.2018	6,7,8,9,12	980	29	2004	изменить курс, без пересчета цен документа и БЕЗ изменения КЦП
--Возврат поставщику	01.09.2018-31.09.2018	6,7,8,9,12	980	29	82	изменить курс, без пересчета цен документа и БЕЗ изменения КЦП
--Возврат по чеку	01.09.2018-31.09.2018	6,7,8,9,12	980	29	63	изменить курс, без пересчета цен документа и БЕЗ изменения КЦП
--Расходная накладная	01.09.2018-31.09.2018	6,7,8,9,12	980	29	63	изменить курс, без пересчета цен документа и БЕЗ изменения КЦП
--Расходный документ	01.09.2018-31.09.2018	6,7,8,9,12	980	29	2004, 2032, 2038	изменить курс с пересчетом цен документа и БЕЗ изменения КЦП
--Продажа товара оператором	01.09.2018-31.09.2018	6,7,8,9,12	980	29	63	изменить курс, без пересчета цен документа и БЕЗ изменения КЦП
--Расходный документ в ценах прихода	01.09.2018-31.09.2018	6,7,8,9,12	980	29	100	изменить курс с пересчетом цен документа и БЕЗ изменения КЦП
--Расходный документ в ценах прихода	01.09.2018-31.09.2018	6,7,8,9,12	980	29	2004	изменить курс c пересчетом цен документа и БЕЗ изменения КЦП
--Комплектация товара	01.09.2018-31.09.2018	6,7,8,9,12	980	29	100	изменить курс, с пересчетом цен документа и БЕЗ изменения КЦП
--Разукомплектация товара	01.09.2018-31.09.2018	6,7,8,9,12	980	29	100	изменить курс, с пересчетом цен документа и БЕЗ изменения КЦП
--Расходный документ в ценах прихода	01.09.2018-31.09.2018	6,7,8,9,12	980	29	42	изменить курс с пересчетом цен документа и БЕЗ изменения КЦП
--Приход товара	01.09.2018-31.09.2018	6,7,8,9,12	980	29	42	изменить курс с пересчетом цен документа и БЕЗ изменения КЦП
--Прием наличных денег на склад	01.09.2018-31.09.2018	6,7,8,9,12	980	29	63, 10	изменить курс, пересчитать сумму ОВ, не меняя сумму ЛВ,ВС
						
2. Модуль "Финансы"						
Документ	Параметры для фильтра					Действие
	дата	фирма	Валюта документа	Курс, ОВ	Признак 1	
--Приход денег по предприятиям	01.09.2018-31.09.2018	6,7,8,9,12	980	29	Все	Пересчитать сумму ОВ, не меняя сумму ЛВ,ВС
--Расход денег по предприятиям	01.09.2018-31.09.2018	6,7,8,9,12	980	29	Все	Пересчитать сумму ОВ, не меняя сумму ЛВ,ВС

*/

BEGIN TRAN


DECLARE @BDate SMALLDATETIME = '20190301' --дата начала смены курса
DECLARE @EDate SMALLDATETIME = '20190331' --дата конца смены курса
DECLARE @Old_KursMC numeric(21,9) = 29.00 -- старый курс доллара
DECLARE @New_KursMC numeric(21,9) = 28.00 -- новый курс доллара
DECLARE @CurrID_GRN INT = 980 --код украинской гривны

--проверка
	
	SELECT KursMC,* From t_Rec d where DocDate Between @BDate and @EDate and d.KursMC!=@New_KursMC and d.OurID in (6,7,8,9,12) and d.CurrID = @CurrID_GRN
	SELECT KursMC,* FROM t_Epp d where DocDate Between @BDate and @EDate and d.KursMC!=@New_KursMC and d.OurID in (6,7,8,9,12) and d.CurrID = @CurrID_GRN
	SELECT KursMC,* FROM t_Ret d where DocDate Between @BDate and @EDate and d.KursMC!=@New_KursMC and d.OurID in (6,7,8,9,12) and d.CurrID = @CurrID_GRN
	SELECT KursMC,* FROM t_Inv d where DocDate Between @BDate and @EDate and d.KursMC!=@New_KursMC and d.OurID in (6,7,8,9,12) and d.CurrID = @CurrID_GRN
	SELECT KursMC,* FROM t_Exp d where DocDate Between @BDate and @EDate and d.KursMC!=@New_KursMC and d.OurID in (6,7,8,9,12) and d.CurrID = @CurrID_GRN
	SELECT KursMC,* FROM t_Epp d where DocDate Between @BDate and @EDate and d.KursMC!=@New_KursMC and d.OurID in (6,7,8,9,12) and d.CurrID = @CurrID_GRN
	SELECT KursMC,* FROM t_SRec d where DocDate Between @BDate and @EDate and d.KursMC!=@New_KursMC and d.OurID in (6,7,8,9,12) and d.CurrID = @CurrID_GRN
	SELECT KursMC,* FROM t_SExp d where DocDate Between @BDate and @EDate and d.KursMC!=@New_KursMC and d.OurID in (6,7,8,9,12) and d.CurrID = @CurrID_GRN
	SELECT KursMC,* FROM t_Exc d where DocDate Between @BDate and @EDate and d.KursMC!=@New_KursMC and d.OurID in (6,7,8,9,12) and d.CurrID = @CurrID_GRN
	SELECT KursMC,* FROM t_IORec d where DocDate Between @BDate and @EDate and d.KursMC!=@New_KursMC and d.OurID in (6,7,8,9,12) and d.CurrID = @CurrID_GRN
	SELECT KursMC,* FROM at_t_IORes d where DocDate Between @BDate and @EDate and d.KursMC!=@New_KursMC and d.OurID in (6,7,8,9,12) and d.CurrID = @CurrID_GRN
	SELECT KursMC,* FROM c_CompRec d where DocDate Between @BDate and @EDate and d.KursMC!=@New_KursMC and d.OurID in (6,7,8,9,12) and d.CurrID = @CurrID_GRN
	SELECT KursMC,* FROM c_CompExp d where DocDate Between @BDate and @EDate and d.KursMC!=@New_KursMC and d.OurID in (6,7,8,9,12) and d.CurrID = @CurrID_GRN

/*
*/
--Приход товара	01.09.2018-31.09.2018	6,7,8,9,12	980	29	82, 87, 100, 2004	изменить курс, без пересчета цен документа с изменением текущего КЦП
--Приход товара	01.09.2018-31.09.2018	6,7,8,9,12	980	29	42	изменить курс с пересчетом цен документа и БЕЗ изменения КЦП
IF 1=0
BEGIN
--Rollback Tran
	--с изменением текущего КЦП
	--Изменение Цены прихода ОВ и Себестоимости ОВ в Приходах
	Update p
	Set p.PriceMC_IN = p.PriceAC_In/c.KursMC, --Цены прихода ОВ
 		p.CostMC = p.CostAC/c.KursMC -- Себестоимости ОВ 
	From t_Rec r 
	join t_recD rd on r.ChID = rd.Chid
	join t_Pinp p on rd.ProdID = p.ProdID and rd.PPID = p.PPID
	join r_Currs c on p.CurrID=c.CurrID
	where r.DocDate Between @BDate and @EDate  and r.KursMC=@Old_KursMC
		and c.CurrID=@CurrID_GRN and r.Ourid in (6,7,8,9,12) and r.CodeID1 in (82,87,100,2004)

	Select p.*
	From t_Rec r 
	join t_recD rd on r.ChID = rd.Chid
	join t_Pinp p on rd.ProdID = p.ProdID and rd.PPID = p.PPID
	join r_Currs c on p.CurrID=c.CurrID
	where r.DocDate Between @BDate and @EDate 
		and c.CurrID=@CurrID_GRN and r.Ourid in (6,7,8,9,12) and r.CodeID1 in (82,87,100,2004)
	Order By ProdID,PPID

	--изменить курс, без пересчета цен документа
	Update d
	set d.KursMC =@New_KursMC
	From t_Rec d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
		and d.OurID in (6,7,8,9,12) and d.CodeID1 in (82,87,100,2004)
		
	SELECT * From t_Rec d 
	where DocDate Between @BDate and @EDate 
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (82,87,100,2004)
	

--Rollback Tran
END




IF 1 = 1
BEGIN
--Перемещение товара	01.09.2018-31.09.2018	6,7,8,9,12	980	29	40, 41	изменить курс, без пересчета цен документа и БЕЗ изменения КЦП
--11021	t_Exc	Перемещение товара
--Rollback Tran
	SELECT KursMC,* FROM t_Exc d where DocDate Between @BDate and @EDate and d.KursMC!=@New_KursMC and d.OurID in (6,7,8,9,12) and d.CurrID = @CurrID_GRN
	ORDER BY ChID
		
	Update d
	set d.KursMC =@New_KursMC
	From t_Exc d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (40,41)
	
	SELECT * FROM t_Exc d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (40,41)
	ORDER BY ChID
	
	
--Rollback Tran
END


IF 1 = 1
BEGIN
--Инвентаризация	01.09.2018-31.09.2018	6,7,8,9,12	980	29	2004	изменить курс с пересчетом цен документа и БЕЗ изменения КЦП
--11022	t_Ven	Инвентаризация товара
--Rollback Tran

	--с пересчетом цен документа
	Update ed
	Set PriceCC_nt = Round((PriceCC_nt/@Old_KursMC)*@New_KursMC,2), SumCC_nt=Round((SumCC_nt/@Old_KursMC)*@New_KursMC,2), Tax=Round((Tax/@Old_KursMC)*@New_KursMC,2), TaxSum=Round((TaxSum/@Old_KursMC)*@New_KursMC,2), PriceCC_wt=Round((PriceCC_wt/@Old_KursMC)*@New_KursMC,2), SumCC_wt=Round((SumCC_wt/@Old_KursMC)*@New_KursMC,2)
	From t_Ven d join t_VenD ed on d.ChiD=ed.ChID
	where d.DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)

	Update d
	set d.KursMC =@New_KursMC
	From t_Ven d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)
	
	SELECT * FROM t_Ven d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)
--Rollback Tran
END

IF 1 = 1
BEGIN
--Возврат	01.09.2018-31.09.2018	6,7,8,9,12	980	29	2004	изменить курс, без пересчета цен документа и БЕЗ изменения КЦП
--11003	t_Ret	Возврат товара от получателя
--Rollback Tran
	Update d
	set d.KursMC =@New_KursMC
	From t_Ret d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)
	
	SELECT * FROM t_Ret d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)
--Rollback Tran
END

IF 1 = 1
BEGIN
--Возврат поставщику	01.09.2018-31.09.2018	6,7,8,9,12	980	29	82	изменить курс, без пересчета цен документа и БЕЗ изменения КЦП
--11011	t_CRet	Возврат товара поставщику
--Rollback Tran

SELECT KursMC,* From t_CRet d where DocDate Between @BDate and @EDate and d.KursMC!=@New_KursMC and d.OurID in (6,7,8,9,12) and d.CurrID = @CurrID_GRN

	Update d
	set d.KursMC =@New_KursMC
	From t_CRet d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (82)
	
	SELECT * FROM t_CRet d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (82)
--Rollback Tran

END

IF 1 = 1
BEGIN
--Возврат по чеку	01.09.2018-31.09.2018	6,7,8,9,12	980	29	63	изменить курс, без пересчета цен документа и БЕЗ изменения КЦП
--11004	t_CRRet	Возврат товара по чеку
--Rollback Tran
	Update d
	set d.KursMC =@New_KursMC
	From t_CRRet d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63)

	SELECT * FROM t_CRRet d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63)
--Rollback Tran

END

IF 1 = 1
BEGIN
--Расходная накладная	01.09.2018-31.09.2018	6,7,8,9,12	980	29	63	изменить курс, без пересчета цен документа и БЕЗ изменения КЦП
--11012	t_Inv	Расходная накладная
--Rollback Tran
	Update d
	set d.KursMC =@New_KursMC
	From t_Inv d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63)
	
	SELECT * FROM t_Inv d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63)
--Rollback Tran

END

IF 1 = 1
BEGIN
--Расходный документ	01.09.2018-31.09.2018	6,7,8,9,12	980	29	2004, 2032, 2038	изменить курс с пересчетом цен документа и БЕЗ изменения КЦП
--11015	t_Exp	Расходный документ
--Rollback Tran
	--с пересчетом цен документа
	Update ed
	Set PriceCC_nt = Round((PriceCC_nt/@Old_KursMC)*@New_KursMC,2), SumCC_nt=Round((SumCC_nt/@Old_KursMC)*@New_KursMC,2), Tax=Round((Tax/@Old_KursMC)*@New_KursMC,2), TaxSum=Round((TaxSum/@Old_KursMC)*@New_KursMC,2), PriceCC_wt=Round((PriceCC_wt/@Old_KursMC)*@New_KursMC,2), SumCC_wt=Round((SumCC_wt/@Old_KursMC)*@New_KursMC,2)
	From t_Exp d join t_ExpD ed on d.ChiD=ed.ChID
	where d.DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004, 2032, 2038)
	
	--изменить курс
	Update d
	set d.KursMC =@New_KursMC
	From t_Exp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004,2032,2038)
	

	Select ed.*
    From t_Exp d join t_ExpD ed on d.ChiD=ed.ChID
	where d.DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004, 2032, 2038)
--Rollback Tran
END

IF 1 = 1
BEGIN
--Продажа товара оператором	01.09.2018-31.09.2018	6,7,8,9,12	980	29	63	изменить курс, без пересчета цен документа и БЕЗ изменения КЦП
--11035	t_Sale	Продажа товара оператором
--Rollback Tran
	--изменить курс
	Update d
	set d.KursMC =@New_KursMC
	From t_Sale d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63)
	
	SELECT * FROM t_Sale d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63)
--Rollback Tran
END

IF 1 = 1
BEGIN
--Расходный документ в ценах прихода	01.09.2018-31.09.2018	6,7,8,9,12	980	29	100	изменить курс с пересчетом цен документа и БЕЗ изменения КЦП
--11016	t_Epp	Расходный документ в ценах прихода
--Rollback Tran
	--с пересчетом цен документа
	Update ed
	Set PriceCC_nt = Round((PriceCC_nt/@Old_KursMC)*@New_KursMC,2), SumCC_nt=Round((SumCC_nt/@Old_KursMC)*@New_KursMC,2), Tax=Round((Tax/@Old_KursMC)*@New_KursMC,2), TaxSum=Round((TaxSum/@Old_KursMC)*@New_KursMC,2), PriceCC_wt=Round((PriceCC_wt/@Old_KursMC)*@New_KursMC,2), SumCC_wt=Round((SumCC_wt/@Old_KursMC)*@New_KursMC,2)
	From t_Epp d join t_EppD ed on d.ChiD=ed.ChID
	where d.DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100)
	
	--изменить курс
	Update d
	set d.KursMC =@New_KursMC
	From t_Epp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100)
	
	SELECT * FROM t_Epp d
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100)
--Rollback Tran
END

IF 1 = 1
BEGIN
--Расходный документ в ценах прихода	01.09.2018-31.09.2018	6,7,8,9,12	980	29	2004	изменить курс c пересчетом цен документа и БЕЗ изменения КЦП
--11016	t_Epp	Расходный документ в ценах прихода
--Rollback Tran
	--с пересчетом цен документа
	Update ed
	Set PriceCC_nt = Round((PriceCC_nt/@Old_KursMC)*@New_KursMC,2), SumCC_nt=Round((SumCC_nt/@Old_KursMC)*@New_KursMC,2), Tax=Round((Tax/@Old_KursMC)*@New_KursMC,2), TaxSum=Round((TaxSum/@Old_KursMC)*@New_KursMC,2), PriceCC_wt=Round((PriceCC_wt/@Old_KursMC)*@New_KursMC,2), SumCC_wt=Round((SumCC_wt/@Old_KursMC)*@New_KursMC,2)
	From t_Epp d join t_EppD ed on d.ChiD=ed.ChID
	where d.DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)
	
	--изменить курс
	Update d
	set d.KursMC =@New_KursMC
	From t_Epp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)
	
	
	SELECT * FROM t_Epp d
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)
--Rollback Tran
END

IF 1 = 1
BEGIN
--Комплектация товара	01.09.2018-31.09.2018	6,7,8,9,12	980	29	100	изменить курс, с пересчетом цен документа и БЕЗ изменения КЦП
--11321	t_SRec	Комплектация товара
--Rollback Tran
	--с пересчетом цен документа
	Update ed
	Set SubPriceCC_nt = Round((SubPriceCC_nt/@Old_KursMC)*@New_KursMC,2), SubSumCC_nt=Round((SubSumCC_nt/@Old_KursMC)*@New_KursMC,2), SubTax=Round((SubTax/@Old_KursMC)*@New_KursMC,2), SubTaxSum=Round((SubTaxSum/@Old_KursMC)*@New_KursMC,2), SubPriceCC_wt=Round((SubPriceCC_wt/@Old_KursMC)*@New_KursMC,2), SubSumCC_wt=Round((SubSumCC_wt/@Old_KursMC)*@New_KursMC,2)
	From t_SRec d join t_SRecD ed on d.ChiD=ed.AChID
	where d.DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100)
	
	--изменить курс
	Update d
	set d.KursMC =@New_KursMC
	From t_SRec d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100)

	
	SELECT * FROM t_SRec d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100)
--Rollback Tran
END

IF 1 = 1
BEGIN
--Разукомплектация товара	01.09.2018-31.09.2018	6,7,8,9,12	980	29	100	изменить курс, с пересчетом цен документа и БЕЗ изменения КЦП
--11322	t_SExp	Разукомплектация товара
--Rollback Tran
	--с пересчетом цен документа
	Update ed
	Set SubPriceCC_nt = Round((SubPriceCC_nt/@Old_KursMC)*@New_KursMC,2), SubSumCC_nt=Round((SubSumCC_nt/@Old_KursMC)*@New_KursMC,2), SubTax=Round((SubTax/@Old_KursMC)*@New_KursMC,2), SubTaxSum=Round((SubTaxSum/@Old_KursMC)*@New_KursMC,2), SubPriceCC_wt=Round((SubPriceCC_wt/@Old_KursMC)*@New_KursMC,2), SubSumCC_wt=Round((SubSumCC_wt/@Old_KursMC)*@New_KursMC,2)
	From t_SExp d join t_SExpD ed on d.ChiD=ed.AChID
	where d.DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100)

	--изменить курс
	Update d
	set d.KursMC =@New_KursMC
	From t_SExp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100)
	
	SELECT * FROM t_SExp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100)
--Rollback Tran
END

IF 1 = 1
BEGIN
--Расходный документ в ценах прихода	01.09.2018-31.09.2018	6,7,8,9,12	980	29	42	изменить курс с пересчетом цен документа и БЕЗ изменения КЦП
--11016	t_Epp	Расходный документ в ценах прихода
--Rollback Tran
	--с пересчетом цен документа
	Update ed
	Set PriceCC_nt = Round((PriceCC_nt/@Old_KursMC)*@New_KursMC,2), SumCC_nt=Round((SumCC_nt/@Old_KursMC)*@New_KursMC,2), Tax=Round((Tax/@Old_KursMC)*@New_KursMC,2), TaxSum=Round((TaxSum/@Old_KursMC)*@New_KursMC,2), PriceCC_wt=Round((PriceCC_wt/@Old_KursMC)*@New_KursMC,2), SumCC_wt=Round((SumCC_wt/@Old_KursMC)*@New_KursMC,2)
	From t_Epp d join t_EppD ed on d.ChiD=ed.ChID
	where d.DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (42)

	--изменить курс
	Update d
	set d.KursMC =@New_KursMC
	From t_Epp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (42)

	
	SELECT * FROM t_Epp d
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (42)
--Rollback Tran
END

IF 1 = 0
BEGIN
--Приход товара	01.09.2018-31.09.2018	6,7,8,9,12	980	29	42	изменить курс с пересчетом цен документа и БЕЗ изменения КЦП
--Rollback Tran

	
	--с пересчетом цен документа
	Update ed
	Set PriceCC_nt = Round((PriceCC_nt/@Old_KursMC)*@New_KursMC,2), SumCC_nt=Round((SumCC_nt/@Old_KursMC)*@New_KursMC,2), Tax=Round((Tax/@Old_KursMC)*@New_KursMC,2), TaxSum=Round((TaxSum/@Old_KursMC)*@New_KursMC,2), PriceCC_wt=Round((PriceCC_wt/@Old_KursMC)*@New_KursMC,2), SumCC_wt=Round((SumCC_wt/@Old_KursMC)*@New_KursMC,2)
	From t_Rec d join t_RecD ed on d.ChiD=ed.ChID
	where d.DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (42)
	
	--изменить курс
	Update d
	set d.KursMC =@New_KursMC
	From t_Rec d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
		and d.OurID in (6,7,8,9,12) and d.CodeID1 in (42)
	
	
	SELECT * From t_Rec d 
	where DocDate Between @BDate and @EDate 
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (42)
--Rollback Tran
END

IF 1 = 1
BEGIN
--Прием наличных денег на склад	01.09.2018-31.09.2018	6,7,8,9,12	980	29	63, 10	изменить курс, пересчитать сумму ОВ, не меняя сумму ЛВ,ВС
--11018	t_MonRec	Прием наличных денег на склад
--Rollback Tran
	--изменить курс
	Update d
	set d.KursMC =@New_KursMC
	From t_MonRec d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63,10)
	
	SELECT * FROM t_MonRec d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63,10)
--Rollback Tran
END

IF 1 = 1
BEGIN
--Приход денег по предприятиям	01.09.2018-31.09.2018	6,7,8,9,12	980	29	Все	Пересчитать сумму ОВ, не меняя сумму ЛВ,ВС
--12001	c_CompRec	Приход денег по предприятиям
--Rollback Tran
	Update d
	set d.KursMC =@New_KursMC
	From c_CompRec d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12)
	
	SELECT * FROM c_CompRec d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12)
--Rollback Tran
END

IF 1 = 1
BEGIN
--Расход денег по предприятиям	01.09.2018-31.09.2018	6,7,8,9,12	980	29	Все	Пересчитать сумму ОВ, не меняя сумму ЛВ,ВС
--12002	c_CompExp	Расход денег по предприятиям
--Rollback Tran
	Update d
	set d.KursMC =@New_KursMC
	From c_CompExp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12)

	SELECT * FROM c_CompExp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12)
--Rollback Tran
END
/*

--2|Расходный документ в ценах прихода|01.01.2018-31.01.2018|6,7,8,9,12|980|28|42|изменить курс, без пересчета цен документа с изменением текущего КЦП|11016|t_Epp|Расходный документ в ценах прихода
--11016	t_Epp	Расходный документ в ценах прихода
--Begin Tran
	--изменить курс, без пересчета цен документа
	Update d
	set d.KursMC =@New_KursMC
	From t_Epp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (42)
	
	SELECT * FROM t_Epp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (42) 
	
	--с изменением текущего КЦП
	--Изменение Цены прихода ОВ и Себестоимости ОВ в Приходах
	Update p
	Set p.PriceMC_IN = p.PriceAC_In/c.KursMC, --Цены прихода ОВ
 		p.CostMC = p.CostAC/c.KursMC -- Себестоимости ОВ 
	From t_Epp r 
	join t_EppD rd on r.ChID = rd.Chid
	join t_Pinp p on rd.ProdID = p.ProdID and rd.PPID = p.PPID
	join r_Currs c on p.CurrID=c.CurrID
	where r.DocDate Between @BDate and @EDate 
		and c.CurrID=@CurrID_GRN and r.Ourid in (6,7,8,9,12) and r.CodeID1 in (42)

	Select p.*
	From t_Epp r 
	join t_EppD rd on r.ChID = rd.Chid
	join t_Pinp p on rd.ProdID = p.ProdID and rd.PPID = p.PPID
	join r_Currs c on p.CurrID=c.CurrID
	where r.DocDate Between @BDate and @EDate 
		and c.CurrID=@CurrID_GRN and r.Ourid in (6,7,8,9,12) and r.CodeID1 in (42)
	Order By ProdID,PPID

--Rollback



--4|Инвентаризация|01.01.2018-31.01.2018|6,7,8,9,12|980|28|2004|изменить курс, без пересчета цен документа и БЕЗ изменения КЦП|11022|t_Ven|Инвентаризация товара
--11022	t_Ven	Инвентаризация товара
--Begin Tran
	Update d
	set d.KursMC =@New_KursMC
	From t_Ven d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)
	
	SELECT * FROM t_Ven d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)
--Rollback

--5|Возврат|01.01.2018-31.01.2018|6,7,8,9,12|980|28|2004|изменить курс, без пересчета цен документа и БЕЗ изменения КЦП|11003|t_Ret|Возврат товара от получателя
--11003	t_Ret	Возврат товара от получателя
--Begin Tran
	Update d
	set d.KursMC =@New_KursMC
	From t_Ret d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)
	
	SELECT * FROM t_Ret d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)
--Rollback

--6|Возврат поставщику|01.01.2018-31.01.2018|6,7,8,9,12|980|28|82|изменить курс, без пересчета цен документа и БЕЗ изменения КЦП|11011|t_CRet|Возврат товара поставщику
--11011	t_CRet	Возврат товара поставщику
--Begin Tran
	Update d
	set d.KursMC =@New_KursMC
	From t_CRet d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (82)
	
	SELECT * FROM t_CRet d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (82)
--Rollback

--7|Возврат по чеку|01.01.2018-31.01.2018|6,7,8,9,12|980|28|63|изменить курс, без пересчета цен документа и БЕЗ изменения КЦП|11004|t_CRRet|Возврат товара по чеку
--11004	t_CRRet	Возврат товара по чеку
--Begin Tran
	Update d
	set d.KursMC =@New_KursMC
	From t_CRRet d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63)

	SELECT * FROM t_CRRet d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63)
--Rollback

--8|Расходная накладная|01.01.2018-31.01.2018|6,7,8,9,12|980|28|63|изменить курс, без пересчета цен документа и БЕЗ изменения КЦП|11012|t_Inv|Расходная накладная
--11012	t_Inv	Расходная накладная
--Begin Tran
	Update d
	set d.KursMC =@New_KursMC
	From t_Inv d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63)
	
	SELECT * FROM t_Inv d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63)
--Rollback

--9|Расходный документ|01.01.2018-31.01.2018|6,7,8,9,12|980|28|2004, 2032, 2038|изменить курс с пересчетом цен документа и БЕЗ изменения КЦП|11015|t_Exp|Расходный документ
--11015	t_Exp	Расходный документ
--Begin Tran
	--изменить курс
	Update d
	set d.KursMC =@New_KursMC
	From t_Exp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004,2032,2038)
	
	--с пересчетом цен документа
	Update ed
	Set PriceCC_nt = Round((PriceCC_nt/@Old_KursMC)*@New_KursMC,2), SumCC_nt=Round((SumCC_nt/@Old_KursMC)*@New_KursMC,2), Tax=Round((Tax/@Old_KursMC)*@New_KursMC,2), TaxSum=Round((TaxSum/@Old_KursMC)*@New_KursMC,2), PriceCC_wt=Round((PriceCC_wt/@Old_KursMC)*@New_KursMC,2), SumCC_wt=Round((SumCC_wt/@Old_KursMC)*@New_KursMC,2)
	From t_Exp d join t_ExpD ed on d.ChiD=ed.ChID
	where d.DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004, 2032, 2038)

	Select ed.*
	From t_Exp d join t_ExpD ed on d.ChiD=ed.ChID
	where d.DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004, 2032, 2038)
--Rollback

--10|Продажа товара оператором|01.01.2018-31.01.2018|6,7,8,9,12|980|28|63|изменить курс, без пересчета цен документа и БЕЗ изменения КЦП|11035|t_Sale|Продажа товара оператором
--11035	t_Sale	Продажа товара оператором
--Begin Tran
	Update d
	set d.KursMC =@New_KursMC
	From t_Sale d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63)
	
	SELECT * FROM t_Sale d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63)
--Rollback

--11|Расходный документ в ценах прихода|01.01.2018-31.01.2018|6,7,8,9,12|980|28|100|изменить курс, без пересчета цен документа и БЕЗ изменения КЦП|11016|t_Epp|Расходный документ в ценах прихода
	--изменить курс, без пересчета цен документа
--Begin Tran
	Update d
	set d.KursMC =@New_KursMC
	From t_Epp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100)
	
	SELECT * FROM t_Epp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100) 
--Rollback

--12|Расходный документ в ценах прихода|01.01.2018-31.01.2018|6,7,8,9,12|980|28|2004|изменить курс c пересчетом цен документа и БЕЗ изменения КЦП|11016|t_Epp|Расходный документ в ценах прихода
--Begin Tran
	Update d
	set d.KursMC =@New_KursMC
	From t_Epp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)
	
	SELECT * FROM t_Epp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004) 
	
	Select ed.*
	From t_Epp d join t_EppD ed on d.ChiD=ed.ChID
	where d.DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)
	
	--с пересчетом цен документа
	Update ed
	Set PriceCC_nt = Round((PriceCC_nt/@Old_KursMC)*@New_KursMC,2), SumCC_nt=Round((SumCC_nt/@Old_KursMC)*@New_KursMC,2), Tax=Round((Tax/@Old_KursMC)*@New_KursMC,2), TaxSum=Round((TaxSum/@Old_KursMC)*@New_KursMC,2), PriceCC_wt=Round((PriceCC_wt/@Old_KursMC)*@New_KursMC,2), SumCC_wt=Round((SumCC_wt/@Old_KursMC)*@New_KursMC,2)
	From t_Epp d join t_EppD ed on d.ChiD=ed.ChID
	where d.DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)

	Select ed.*
	From t_Epp d join t_EppD ed on d.ChiD=ed.ChID
	where d.DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)
	
	SELECT * FROM t_Epp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004) 
--Rollback

--13|Комплектация товара|01.01.2018-31.01.2018|6,7,8,9,12|980|28|100|изменить курс, без пересчета цен документа и БЕЗ изменения КЦП|11321|t_SRec|Комплектация товара
--11321	t_SRec	Комплектация товара
--Begin Tran
	Update d
	set d.KursMC =@New_KursMC
	From t_SRec d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100)
	
	SELECT * FROM t_SRec d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100)
--Rollback

--14|Разукомплектация товара|01.01.2018-31.01.2018|6,7,8,9,12|980|28|100|изменить курс, без пересчета цен документа и БЕЗ изменения КЦП|11322|t_SExp|Разукомплектация товара
--11322	t_SExp	Разукомплектация товара
--Begin Tran
	Update d
	set d.KursMC =@New_KursMC
	From t_SExp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100)
	
	SELECT * FROM t_SExp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100)
--Rollback

--15|Прием наличных денег на склад|01.01.2018-31.01.2018|6,7,8,9,12|980|28|63, 10|Пересчитать сумму ОВ, не меняя сумму ЛВ,ВС|11018|t_MonRec|Прием наличных денег на склад
--11018	t_MonRec	Прием наличных денег на склад
--Begin Tran
	Update d
	set d.KursMC =@New_KursMC
	From t_MonRec d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63,10)
	
	SELECT * FROM t_MonRec d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63,10)
--Rollback

--16|Приход денег по предприятиям|01.01.2018-31.01.2018|6,7,8,9,12|980|28|Все|Пересчитать сумму ОВ, не меняя сумму ЛВ,ВС|12001|c_CompRec|Приход денег по предприятиям
--12001	c_CompRec	Приход денег по предприятиям
--Begin Tran
	Update d
	set d.KursMC =@New_KursMC
	From c_CompRec d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12)
	
	SELECT * FROM c_CompRec d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12)
--Rollback


--17|Расход денег по предприятиям|01.01.2018-31.01.2018|6,7,8,9,12|980|28|Все|Пересчитать сумму ОВ, не меняя сумму ЛВ,ВС|12002|c_CompExp|Расход денег по предприятиям
--12002	c_CompExp	Расход денег по предприятиям
--Begin Tran
	Update d
	set d.KursMC =@New_KursMC
	From c_CompExp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12)

	SELECT * FROM c_CompExp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12)
--Rollback
*/
ROLLBACK TRAN