--3-Переоценка цен в прайслистах Elit

--копи
BEGIN TRAN

DECLARE  @PLID_Baze int = 106 -- рабочий прайс-лист (25,106)
/*архивные прайс-листы 
SELECT * FROM r_PLs where StateCode != 561 ORDER BY 2
*/
DECLARE  @PLID_arhiv int = 180 --архивный прайс-лист 
--удалить архивный прайс
DELETE r_ProdMP WHERE plid = @PLID_arhiv

INSERT r_ProdMP
	SELECT ProdID, @PLID_arhiv PLID, PriceMC, Notes, CurrID FROM r_ProdMP where plid = @PLID_Baze

ROLLBACK TRAN



SELECT * FROM r_PLs where StateCode = 561 and plid not in (10)




BEGIN TRAN

DECLARE @Old_KursMC numeric(21,9) = 29.000000000 -- новый курс доллара
DECLARE @New_KursMC numeric(21,9) = 28.000000000 -- новый курс доллара

SELECT *, cast(PriceMC*cast(@Old_KursMC/@New_KursMC as numeric(21,15)) as numeric(21,9)) PriceMC_new 
FROM r_ProdMP where plid in (SELECT PLID FROM r_PLs where StateCode = 561 and plid not in (10))

update r_ProdMP
set PriceMC = cast(PriceMC*cast(@Old_KursMC/@New_KursMC as numeric(21,15)) as numeric(21,9)) 
where plid in (SELECT PLID FROM r_PLs where StateCode = 561 and plid not in (10))

SELECT *
FROM r_ProdMP where plid in (SELECT PLID FROM r_PLs where StateCode = 561 and plid not in (10))

--SELECT 11.037931034*29.000000000/28.000000000
--SELECT @Old_KursMC/@New_KursMC
ROLLBACK TRAN


BEGIN TRAN

SELECT * FROM r_PLs where StateCode = 561 and plid not in (10,130)

update r_PLs 
set Notes = 'с 13.03.19 рабочий (Курс 28)'
,BDate = '20190313'
where StateCode = 561 and plid not in (10,130)

SELECT * FROM r_PLs where StateCode = 561 and plid not in (10,130)


ROLLBACK TRAN


SELECT Extra5,* FROM r_prods where prodid = 52
SELECT Extra5 FROM r_prods where Extra5 != 0
update r_prods set Extra5 = 0 where Extra5 != 0


