--Алгоритм смены курса доллара к гривне ElitR 

--1.Отключаем ИМ (джоб VC_Sync)17.01.2018 12:30

--2 бекап ElitR 17.01.2018 12:36

--3. проверяем синхронизацию на все локальные сервера

--4. меняем курс доллара к гривне в справочнике валют 17.01.2018 12:38
/*
USE ElitR

	--меняем курс доллара
	UPDATE r_Currs SET KursCC = 28 WHERE  CurrID = 840
	INSERT INTO r_CurrH (CurrID, DocDate, KursMC, KursCC) VALUES (840, '20180101', 1.00, 28.00)
	--меняем курс гривны
	UPDATE r_Currs SET KursMC = 28 WHERE  CurrID = 980
	INSERT INTO r_CurrH (CurrID, DocDate, KursMC, KursCC) VALUES (980, '20180101', 28.00, 1.00)
	
	SELECT * FROM r_Currs WHERE  CurrID = 980
	SELECT * FROM r_CurrH WHERE  CurrID = 980
	SELECT * FROM r_Currs WHERE  CurrID = 840
	SELECT * FROM r_CurrH WHERE  CurrID = 840

*/
/* отдельно меняем курс в кофепоинте [CP1_DP].ElitCP1.dbo

	--меняем курс доллара
	UPDATE [CP1_DP].ElitCP1.dbo.r_Currs SET KursCC = 28 WHERE  CurrID = 840
	INSERT INTO [CP1_DP].ElitCP1.dbo.r_CurrH (CurrID, DocDate, KursMC, KursCC) VALUES (840, '20180101', 1.00, 28.00)
	--меняем курс гривны
	UPDATE [CP1_DP].ElitCP1.dbo.r_Currs SET KursMC = 28 WHERE  CurrID = 980
	INSERT INTO [CP1_DP].ElitCP1.dbo.r_CurrH (CurrID, DocDate, KursMC, KursCC) VALUES (980, '20180101', 28.00, 1.00)

	SELECT * FROM [CP1_DP].ElitCP1.dbo.r_Currs WHERE  CurrID = 980
	SELECT * FROM [CP1_DP].ElitCP1.dbo.r_CurrH WHERE  CurrID = 980

	SELECT * FROM [CP1_DP].ElitCP1.dbo.r_Currs WHERE  CurrID = 840
	SELECT * FROM [CP1_DP].ElitCP1.dbo.r_CurrH WHERE  CurrID = 840

*/

--5. проверяем синхронизацию, все ли сервера обновились

--6. если все сервера обновились и сменили курс то ждем пока элитка разблокирует базу 
--	и включаем ИМ (джоб VC_Sync) 17.01.2018 

--7. запускаем 
--|Заявка на изменение курса|||||||||

--|1. Модуль "Бизнес"|||||||||
--|Документ|Параметры для фильтра|||||Действие|||
--Пункт||дата|фирма|Валюта документа|Курс, ОВ|Признак 1||||
--1|Приход товара|01.01.2018-31.01.2018|6,7,8,9,12|980|28|82, 87, 100, 2004,42|изменить курс, без пересчета цен документа с изменением текущего КЦП|11002|t_Rec|Приход товара
--2|Расходный документ в ценах прихода|01.01.2018-31.01.2018|6,7,8,9,12|980|28|42|изменить курс, без пересчета цен документа с изменением текущего КЦП|||
--3|Перемещение товара|01.01.2018-31.01.2018|6,7,8,9,12|980|28|40, 41,42|изменить курс, без пересчета цен документа и БЕЗ изменения КЦП|11021|t_Exc|Перемещение товара
--4|Инвентаризация|01.01.2018-31.01.2018|6,7,8,9,12|980|28|2004|изменить курс, без пересчета цен документа и БЕЗ изменения КЦП|11022|t_Ven|Инвентаризация товара
--5|Возврат|01.01.2018-31.01.2018|6,7,8,9,12|980|28|2004|изменить курс, без пересчета цен документа и БЕЗ изменения КЦП|11003|t_Ret|Возврат товара от получателя
--6|Возврат поставщику|01.01.2018-31.01.2018|6,7,8,9,12|980|28|82|изменить курс, без пересчета цен документа и БЕЗ изменения КЦП|11011|t_CRet|Возврат товара поставщику
--7|Возврат по чеку|01.01.2018-31.01.2018|6,7,8,9,12|980|28|63|изменить курс, без пересчета цен документа и БЕЗ изменения КЦП|11004|t_CRRet|Возврат товара по чеку
--8|Расходная накладная|01.01.2018-31.01.2018|6,7,8,9,12|980|28|63|изменить курс, без пересчета цен документа и БЕЗ изменения КЦП|11012|t_Inv|Расходная накладная
--9|Расходный документ|01.01.2018-31.01.2018|6,7,8,9,12|980|28|2004, 2032, 2038|изменить курс с пересчетом цен документа и БЕЗ изменения КЦП|11015|t_Exp|Расходный документ
--10|Продажа товара оператором|01.01.2018-31.01.2018|6,7,8,9,12|980|28|63|изменить курс, без пересчета цен документа и БЕЗ изменения КЦП|11035|t_Sale|Продажа товара оператором
--11|Расходный документ в ценах прихода|01.01.2018-31.01.2018|6,7,8,9,12|980|28|100|изменить курс, без пересчета цен документа и БЕЗ изменения КЦП|11016|t_Epp|Расходный документ в ценах прихода
--12|Расходный документ в ценах прихода|01.01.2018-31.01.2018|6,7,8,9,12|980|28|2004|изменить курс c пересчетом цен документа и БЕЗ изменения КЦП|||
--13|Комплектация товара|01.01.2018-31.01.2018|6,7,8,9,12|980|28|100|изменить курс, без пересчета цен документа и БЕЗ изменения КЦП|11321|t_SRec|Комплектация товара
--14|Разукомплектация товара|01.01.2018-31.01.2018|6,7,8,9,12|980|28|100|изменить курс, без пересчета цен документа и БЕЗ изменения КЦП|11322|t_SExp|Разукомплектация товара
--15|Прием наличных денег на склад|01.01.2018-31.01.2018|6,7,8,9,12|980|28|63, 10|Пересчитать сумму ОВ, не меняя сумму ЛВ,ВС|11018|t_MonRec|Прием наличных денег на склад

--|2. Модуль "Финансы"|||||||||
--|Документ|Параметры для фильтра|||||Действие|||
--||дата|фирма|Валюта документа|Курс, ОВ|Признак 1||||
--16|Приход денег по предприятиям|01.01.2018-31.01.2018|6,7,8,9,12|980|28|Все|Пересчитать сумму ОВ, не меняя сумму ЛВ,ВС|12001|c_CompRec|Приход денег по предприятиям
--17|Расход денег по предприятиям|01.01.2018-31.01.2018|6,7,8,9,12|980|28|Все|Пересчитать сумму ОВ, не меняя сумму ЛВ,ВС|12002|c_CompExp|Расход денег по предприятиям

BEGIN TRAN


DECLARE @NewKursMC numeric(21,9) = 28.00 -- новый курс
DECLARE @OldKursMC numeric(21,9) = 27.00 -- старый курс
DECLARE @BDate SMALLDATETIME = '20180101'
DECLARE @EDate SMALLDATETIME = '20180131'

SELECT @BDate,@EDate

--1|Приход товара|01.01.2018-31.01.2018|6,7,8,9,12|980|28|82, 87, 100, 2004,42|изменить курс, без пересчета цен документа с изменением текущего КЦП|11002|t_Rec|Приход товара
--11002|t_Rec|Приход товара
	--изменить курс, без пересчета цен документа
	Update d
	set d.KursMC =@NewKursMC
	From t_Rec d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@OldKursMC
		and d.OurID in (6,7,8,9,12) and d.CodeID1 in (82,87,100,2004,42)
		
	SELECT * From t_Rec d 
	where DocDate Between @BDate AND @EDate 
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (82,87,100,2004,42)
	
	--с изменением текущего КЦП
	--Изменение Цены прихода ОВ и Себестоимости ОВ в Приходах
	Update p
	Set p.PriceMC_IN = p.PriceAC_In/c.KursMC, --Цены прихода ОВ
 		p.CostMC = p.CostAC/c.KursMC -- Себестоимости ОВ 
	From t_Rec r 
	join t_recD rd on r.ChID = rd.Chid
	join t_Pinp p on rd.ProdID = p.ProdID and rd.PPID = p.PPID
	join r_Currs c on p.CurrID=c.CurrID
	where r.DocDate Between @BDate AND @EDate 
		and c.CurrID=980 and r.Ourid in (6,7,8,9,12) and r.CodeID1 in (82,87,100,2004,42)

	Select p.*
	From t_Rec r 
	join t_recD rd on r.ChID = rd.Chid
	join t_Pinp p on rd.ProdID = p.ProdID and rd.PPID = p.PPID
	join r_Currs c on p.CurrID=c.CurrID
	where r.DocDate Between @BDate AND @EDate 
		and c.CurrID=980 and r.Ourid in (6,7,8,9,12) and r.CodeID1 in (82,87,100,2004,42)
	Order By ProdID,PPID

--2|Расходный документ в ценах прихода|01.01.2018-31.01.2018|6,7,8,9,12|980|28|42|изменить курс, без пересчета цен документа с изменением текущего КЦП|11016|t_Epp|Расходный документ в ценах прихода
--11016	t_Epp	Расходный документ в ценах прихода
	--изменить курс, без пересчета цен документа
	Update d
	set d.KursMC =@NewKursMC
	From t_Epp d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@OldKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (42)
	
	SELECT * FROM t_Epp d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@NewKursMC
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
	where r.DocDate Between @BDate AND @EDate 
		and c.CurrID=980 and r.Ourid in (6,7,8,9,12) and r.CodeID1 in (42)

	Select p.*
	From t_Epp r 
	join t_EppD rd on r.ChID = rd.Chid
	join t_Pinp p on rd.ProdID = p.ProdID and rd.PPID = p.PPID
	join r_Currs c on p.CurrID=c.CurrID
	where r.DocDate Between @BDate AND @EDate 
		and c.CurrID=980 and r.Ourid in (6,7,8,9,12) and r.CodeID1 in (42)
	Order By ProdID,PPID

--3|Перемещение товара|01.01.2018-31.01.2018|6,7,8,9,12|980|28|40, 41,42|изменить курс, без пересчета цен документа и БЕЗ изменения КЦП|11021|t_Exc|Перемещение товара
--11021	t_Exc	Перемещение товара
	Update d
	set d.KursMC =@NewKursMC
	From t_Exc d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@OldKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (40,41,42)
	
	SELECT * FROM t_Exc d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@NewKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (40,41,42)

--4|Инвентаризация|01.01.2018-31.01.2018|6,7,8,9,12|980|28|2004|изменить курс, без пересчета цен документа и БЕЗ изменения КЦП|11022|t_Ven|Инвентаризация товара
--11022	t_Ven	Инвентаризация товара
	Update d
	set d.KursMC =@NewKursMC
	From t_Ven d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@OldKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)
	
	SELECT * FROM t_Ven d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@NewKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)

--5|Возврат|01.01.2018-31.01.2018|6,7,8,9,12|980|28|2004|изменить курс, без пересчета цен документа и БЕЗ изменения КЦП|11003|t_Ret|Возврат товара от получателя
--11003	t_Ret	Возврат товара от получателя
	Update d
	set d.KursMC =@NewKursMC
	From t_Ret d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@OldKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)
	
	SELECT * FROM t_Ret d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@NewKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)

--6|Возврат поставщику|01.01.2018-31.01.2018|6,7,8,9,12|980|28|82|изменить курс, без пересчета цен документа и БЕЗ изменения КЦП|11011|t_CRet|Возврат товара поставщику
--11011	t_CRet	Возврат товара поставщику
	Update d
	set d.KursMC =@NewKursMC
	From t_CRet d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@OldKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (82)
	
	SELECT * FROM t_CRet d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@NewKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (82)

--7|Возврат по чеку|01.01.2018-31.01.2018|6,7,8,9,12|980|28|63|изменить курс, без пересчета цен документа и БЕЗ изменения КЦП|11004|t_CRRet|Возврат товара по чеку
--11004	t_CRRet	Возврат товара по чеку
	Update d
	set d.KursMC =@NewKursMC
	From t_CRRet d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@OldKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63)

	SELECT * FROM t_CRRet d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@NewKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63)

--8|Расходная накладная|01.01.2018-31.01.2018|6,7,8,9,12|980|28|63|изменить курс, без пересчета цен документа и БЕЗ изменения КЦП|11012|t_Inv|Расходная накладная
--11012	t_Inv	Расходная накладная
	Update d
	set d.KursMC =@NewKursMC
	From t_Inv d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@OldKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63)
	
	SELECT * FROM t_Inv d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@NewKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63)

--9|Расходный документ|01.01.2018-31.01.2018|6,7,8,9,12|980|28|2004, 2032, 2038|изменить курс с пересчетом цен документа и БЕЗ изменения КЦП|11015|t_Exp|Расходный документ
--11015	t_Exp	Расходный документ
	--изменить курс
	Update d
	set d.KursMC =@NewKursMC
	From t_Exp d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@OldKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004,2032,2038)
	
	--с пересчетом цен документа
	Update ed
	Set PriceCC_nt = Round((PriceCC_nt/@OldKursMC)*@NewKursMC,2), SumCC_nt=Round((SumCC_nt/@OldKursMC)*@NewKursMC,2), Tax=Round((Tax/@OldKursMC)*@NewKursMC,2), TaxSum=Round((TaxSum/@OldKursMC)*@NewKursMC,2), PriceCC_wt=Round((PriceCC_wt/@OldKursMC)*@NewKursMC,2), SumCC_wt=Round((SumCC_wt/@OldKursMC)*@NewKursMC,2)
	From t_Exp d join t_ExpD ed on d.ChiD=ed.ChID
	where d.DocDate Between @BDate AND @EDate and d.KursMC=@NewKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004, 2032, 2038)

	Select ed.*
	From t_Exp d join t_ExpD ed on d.ChiD=ed.ChID
	where d.DocDate Between @BDate AND @EDate and d.KursMC=@NewKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004, 2032, 2038)

--10|Продажа товара оператором|01.01.2018-31.01.2018|6,7,8,9,12|980|28|63|изменить курс, без пересчета цен документа и БЕЗ изменения КЦП|11035|t_Sale|Продажа товара оператором
--11035	t_Sale	Продажа товара оператором
	Update d
	set d.KursMC =@NewKursMC
	From t_Sale d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@OldKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63)
	
	SELECT * FROM t_Sale d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@NewKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63)

--11|Расходный документ в ценах прихода|01.01.2018-31.01.2018|6,7,8,9,12|980|28|100|изменить курс, без пересчета цен документа и БЕЗ изменения КЦП|11016|t_Epp|Расходный документ в ценах прихода
	--изменить курс, без пересчета цен документа
	Update d
	set d.KursMC =@NewKursMC
	From t_Epp d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@OldKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100)
	
	SELECT * FROM t_Epp d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@NewKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100) 

--12|Расходный документ в ценах прихода|01.01.2018-31.01.2018|6,7,8,9,12|980|28|2004|изменить курс c пересчетом цен документа и БЕЗ изменения КЦП|11016|t_Epp|Расходный документ в ценах прихода
	Update d
	set d.KursMC =@NewKursMC
	From t_Epp d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@OldKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)
	
	SELECT * FROM t_Epp d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@NewKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004) 
	
	Select ed.*
	From t_Epp d join t_EppD ed on d.ChiD=ed.ChID
	where d.DocDate Between @BDate AND @EDate and d.KursMC=@NewKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)
	
	--с пересчетом цен документа
	Update ed
	Set PriceCC_nt = Round((PriceCC_nt/@OldKursMC)*@NewKursMC,2), SumCC_nt=Round((SumCC_nt/@OldKursMC)*@NewKursMC,2), Tax=Round((Tax/@OldKursMC)*@NewKursMC,2), TaxSum=Round((TaxSum/@OldKursMC)*@NewKursMC,2), PriceCC_wt=Round((PriceCC_wt/@OldKursMC)*@NewKursMC,2), SumCC_wt=Round((SumCC_wt/@OldKursMC)*@NewKursMC,2)
	From t_Epp d join t_EppD ed on d.ChiD=ed.ChID
	where d.DocDate Between @BDate AND @EDate and d.KursMC=@NewKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)

	Select ed.*
	From t_Epp d join t_EppD ed on d.ChiD=ed.ChID
	where d.DocDate Between @BDate AND @EDate and d.KursMC=@NewKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)
	
	SELECT * FROM t_Epp d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@NewKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004) 

--13|Комплектация товара|01.01.2018-31.01.2018|6,7,8,9,12|980|28|100|изменить курс, без пересчета цен документа и БЕЗ изменения КЦП|11321|t_SRec|Комплектация товара
--11321	t_SRec	Комплектация товара
	Update d
	set d.KursMC =@NewKursMC
	From t_SRec d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@OldKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100)
	
	SELECT * FROM t_SRec d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@NewKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100)

--14|Разукомплектация товара|01.01.2018-31.01.2018|6,7,8,9,12|980|28|100|изменить курс, без пересчета цен документа и БЕЗ изменения КЦП|11322|t_SExp|Разукомплектация товара
--11322	t_SExp	Разукомплектация товара
	Update d
	set d.KursMC =@NewKursMC
	From t_SExp d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@OldKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100)
	
	SELECT * FROM t_SExp d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@NewKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100)

--15|Прием наличных денег на склад|01.01.2018-31.01.2018|6,7,8,9,12|980|28|63, 10|Пересчитать сумму ОВ, не меняя сумму ЛВ,ВС|11018|t_MonRec|Прием наличных денег на склад
--11018	t_MonRec	Прием наличных денег на склад
	Update d
	set d.KursMC =@NewKursMC
	From t_MonRec d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@OldKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63,10)
	
	SELECT * FROM t_MonRec d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@NewKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63,10)

--16|Приход денег по предприятиям|01.01.2018-31.01.2018|6,7,8,9,12|980|28|Все|Пересчитать сумму ОВ, не меняя сумму ЛВ,ВС|12001|c_CompRec|Приход денег по предприятиям
--12001	c_CompRec	Приход денег по предприятиям
	Update d
	set d.KursMC =@NewKursMC
	From c_CompRec d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@OldKursMC
	and d.OurID in (6,7,8,9,12)
	
	SELECT * FROM c_CompRec d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@NewKursMC
	and d.OurID in (6,7,8,9,12)

--17|Расход денег по предприятиям|01.01.2018-31.01.2018|6,7,8,9,12|980|28|Все|Пересчитать сумму ОВ, не меняя сумму ЛВ,ВС|12002|c_CompExp|Расход денег по предприятиям
--12002	c_CompExp	Расход денег по предприятиям
	Update d
	set d.KursMC =@NewKursMC
	From c_CompExp d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@OldKursMC
	and d.OurID in (6,7,8,9,12)

	SELECT * FROM c_CompExp d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@NewKursMC
	and d.OurID in (6,7,8,9,12)


ROLLBACK TRAN