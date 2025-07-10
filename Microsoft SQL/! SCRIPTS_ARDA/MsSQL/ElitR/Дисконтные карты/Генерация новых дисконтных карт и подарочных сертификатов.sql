--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*INFO*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Генерация новых 13 значных номеров карт по диапазону от @BChID до @EChID. Если карта существует, она пропускается.
В поле Notes добавляется 5 значный код (эмбоссер)(последние 5 цифр от 12 значного номера карты). 
В поле InUse ставится 1 (карта готова к использованию).*/
--r_DCTypes	Справочник дисконтных карт: типы
--r_DCards	Справочник дисконтных карт
--r_ProdMQ	Справочник товаров - Виды упаковок
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[CHANGED] Maslov Oleg '2021-01-14 09:40:26.893' Обычные дисконтные карты (тип 1 или 2) не нужно выключать, так как они должны работать сразу после получения. Раньше этот UPDATE был сразу после процедуры ip_CreateDCards13.

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Генерирация дисконтных карт и подарочных сертификатов (условные диапазоны: 222 - ДК; 223,224,225,226... - подарочные сертификаты)*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
USE ElitR
GO

BEGIN TRAN 
BEGIN

    --Изменить необходимо только эти 4 параметра (скидка и бонусы, по умолчанию, нулевые).
    DECLARE @qty smallint = 20 --количество новых сертификатов согласно заявки пользователя.
    DECLARE @CardType int = 6 --Тип карты из "Справочника дисконтных карт: типы" r_DCTypes (1-Дисконтная карта; 2-Подарочный сертификат)
    /*
     3-Подарунковий сертифікат 200 
     4-Подарунковий сертифікат 400 
     5-Подарунковий сертифікат 600 
     6-Подарунковий сертифікат 800
	 35-Подарунковий сертифікат 1000
     36-Подарунковий сертифікат 3000
     37-Подарунковий сертифікат 5000 
     */
    DECLARE @Disc int = 0	--Начальный процент скидки.
    DECLARE @BonusSum int = 0  --Начальная сумма бонусов.

    DECLARE @BChID bigint = (select top 1 cast((left(DCardID,12)) as bigint) + 1 from r_DCards where DCTypeCode = @CardType and DCardID not like '25%' ORDER BY DCardID desc)	--Начальный 12 значный номер карты.
    DECLARE @EChID bigint = @BChID + @qty - 1	--Конечный 12 значный номер карты.
    
    select 'Во всех окнах вывода не учитываем карты, начинающиеся с 25...' 'INFO!'
    select COUNT(*) 'Всего карт', (SELECT DCTypeName FROM r_DCTypes WHERE DCTypeCode = @CardType) 'Тип карт' from r_DCards where DCTypeCode = @CardType and DCardID not like '25%'
    select * from r_DCards where DCTypeCode = @CardType and DCardID not like '25%' ORDER BY DCardID desc

    EXEC ip_CreateDCards13 @BChID, @EChID, @CardType, @Disc, @BonusSum --Заполняет Справочник дисконтных карт пустыми картами с Кодами регистрации в заданном диапазоне значений с начальными параметрами скидки и суммой бонусов.

	--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    --для подарочных сертификатов нужно добавить штрихкоды, чтобы они могли продаваться на кассе.
	if @CardType in (3, 4, 5, 6, 35, 36, 37) --Добавить коды сертификатов по необходимости или для новых типов
	BEGIN
	    
		--[CHANGED] Maslov Oleg '2021-01-14 09:40:26.893' Обычные дисконтные карты (тип 1 или 2) не нужно выключать, так как они должны работать сразу после получения. Раньше этот UPDATE был сразу после процедуры ip_CreateDCards13.
		--сделать сертификаты доступным для продажи
		update r_DCards 
		set InUse = 0
		where DCardID between cast(@BChID AS varchar) + '0' and cast(@EChID AS varchar) + '9'
		  and DCardID not like '25%'
		
		select 'добавляем штрихкоды для сертификатов' 

	    INSERT r_ProdMQ (ProdID, UM, Qty, Weight, Notes, BarCode, ProdBarCode, PLID, TareWeight)
			SELECT (SELECT top 1 ProdID FROM r_DCTypes dt where dt.DCTypeCode = d.DCTypeCode) ProdID
			,(SELECT UM FROM r_Prods p where p.ProdID = (SELECT top 1 ProdID FROM r_DCTypes dt where dt.DCTypeCode = d.DCTypeCode)) 
			+ '_' + cast(cast(substring(d.DCardID,8,5) as int) as varchar) UM
			, 1 Qty, 0 Weight, substring(d.DCardID,8,5)  Notes, d.DCardID BarCode, d.DCardID ProdBarCode, 0 PLID, 0 TareWeight 
			FROM r_dcards d
			left join r_ProdMQ mq on mq.BarCode = d.DCardID
			where d.DCTypeCode = @CardType
			and mq.BarCode  is null

			SELECT (SELECT top 1 ProdID FROM r_DCTypes dt where dt.DCTypeCode = d.DCTypeCode) ProdID
			,(SELECT UM FROM r_Prods p where p.ProdID = (SELECT top 1 ProdID FROM r_DCTypes dt where dt.DCTypeCode = d.DCTypeCode)) 
			+ '_' + cast(cast(substring(d.DCardID,8,5) as int) as varchar) UM
			, 1 Qty, 0 Weight, substring(d.DCardID,8,5)  Notes, d.DCardID BarCode, d.DCardID ProdBarCode, 0 PLID, 0 TareWeight 
			FROM r_dcards d
			left join r_ProdMQ mq on mq.BarCode = d.DCardID
			where d.DCTypeCode = @CardType
			--and mq.BarCode  is null
	END;

    --контрольная сверка.
    select COUNT(*) 'НОВЫХ КАРТ', (SELECT DCTypeName FROM r_DCTypes WHERE DCTypeCode = @CardType) 'Тип карт' from r_DCards where DCardID between cast(@BChID AS varchar) + '0' and cast(@EChID AS varchar) + '9' and DCardID not like '25%'
    select @BChID 'Range: begin', @EChID 'Range: end', @Disc 'Начальный процент скидки', @BonusSum 'Начальная сумма бонусов', '' 'СПРАВОЧНИК ДИСКОНТНЫХ КАРТ: ТИПЫ >>', DCTypeCode, DCTypeName, Notes from r_DCTypes WHERE DCTypeCode = @CardType
    select * from r_DCards where DCardID between cast(@BChID AS varchar) + '0' and cast(@EChID AS varchar) + '9' and DCardID not like '25%'
    select COUNT(*) 'Всего карт', (SELECT DCTypeName FROM r_DCTypes WHERE DCTypeCode = @CardType) 'Тип карт' from r_DCards where DCTypeCode = @CardType and DCardID not like '25%'
    select * from r_DCards where DCTypeCode = @CardType and DCardID not like '25%' ORDER BY DCardID DESC

END;
ROLLBACK TRAN 


 

 --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 /*АРХИВ*/
 --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
 --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*генерация дисконтных карт (222 - условный диапазон для ДК)*/
 --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*USE ElitR
GO

select top 1000 * from r_DCards where DCardID like '222%' ORDER BY DCardID desc

BEGIN TRAN disc_cards
BEGIN
    DECLARE 
     @BChID bigint = 222000043401,	--Начальный 12 значный номер карты.
     @EChID bigint = 222000044400,	--Конечный 12 значный номер карты.
     @CardType int = 2, --Тип карты из "Справочника дисконтных карт: типы" r_DCTypes (2 - Накопительный).
     @Disc int = 0,	--Начальный процент скидки.
     @BonusSum int = 0  --Начальная сумма бонусов.
 
     EXEC ip_CreateDCards13 @BChID,@EChID,@CardType,@Disc,@BonusSum
 
     SELECT * FROM (
	     select cast(LEFT(DCardID,12) as bigint) DCardID_bigint ,* from r_DCards 
	     where isnumeric(DCardID ) = 1
     ) s1
     where DCardID_bigint between @BChID and @EChID
END;
ROLLBACK TRAN disc_cards

SELECT * FROM r_DCTypes ORDER BY 2
SELECT * FROM r_DCTypeG ORDER BY 2
SELECT * FROM r_DCards where DCTypeCode in (4)
ORDER BY DCTypeCode,3
*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Генерация новых штрихкодов для сертификатов*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*USE ElitR
GO

BEGIN TRAN cert_barcodes
BEGIN 
	DECLARE @s varchar(40) = '224000000%'
	(SELECT top 1 ProdID FROM r_ProdMQ where BarCode like @s)
	SELECT cast(ISNULL(SUBSTRING(UM,4,5),0) as int) FROM r_ProdMQ where ProdID in ((SELECT top 1 ProdID FROM r_ProdMQ where BarCode like @s)) 
	DECLARE @n int
	--SELECT UM, cast(ISNULL(SUBSTRING(UM,5,5),0) as int) FROM r_ProdMQ where ProdID in ((SELECT top 1 ProdID FROM r_ProdMQ where BarCode like @s)) ORDER BY cast(ISNULL(SUBSTRING(UM,5,5),0) as int) desc
	SELECT @n = max(cast(ISNULL(SUBSTRING(UM,4,5),0) as int)) FROM r_ProdMQ where ProdID in ((SELECT top 1 ProdID FROM r_ProdMQ where BarCode like @s)) 

	SELECT @n 
	SELECT @n = 290  -- последняя еденица измерения

	SELECT (SELECT top 1 ProdID FROM r_ProdMQ where BarCode like @s) ProdID, 
		'шт_' + cast((ROW_NUMBER()OVER(ORDER BY DCardID) + @n ) as varchar) UM, 
		1 Qty, 0 Weight, Notes Notes, DCardID BarCode, DCardID ProdBarCode, 0 PLID, 0 TareWeight
	FROM r_DCards where DCardID like @s and  DCardID not in (SELECT BarCode FROM r_ProdMQ where BarCode like @s)

	INSERT r_ProdMQ (ProdID, UM, Qty, Weight, Notes, BarCode, ProdBarCode, PLID, TareWeight)
	SELECT (SELECT top 1 ProdID FROM r_ProdMQ where BarCode like @s) ProdID, 
		'шт_' + cast((ROW_NUMBER()OVER(ORDER BY DCardID) + @n ) as varchar) UM, 
		1 Qty, 0 Weight, Notes Notes, DCardID BarCode, DCardID ProdBarCode, 0 PLID, 0 TareWeight
	FROM r_DCards where DCardID like @s and  DCardID not in (SELECT BarCode FROM r_ProdMQ where BarCode like @s)


	SELECT * FROM r_ProdMQ where BarCode like @s  ORDER BY BarCode

	--IF EXISTS (SELECT 1 FROM r_ProdMQ i WHERE 
	--NOT EXISTS (SELECT * FROM r_Uni WHERE RefTypeID = 80021 AND (i.UM = RefName OR i.UM LIKE RefName + '[_][0-9]' OR i.UM LIKE RefName + '[_][0-9][0-9]' OR i.UM LIKE RefName + '[_][0-9][0-9][0-9]')))
END;
ROLLBACK TRAN cert_barcodes
*/

/*
--ручной режим добавления штрихкодов


BEGIN TRAN


    DECLARE @CardType int = 6 --Тип карты из "Справочника дисконтных карт: типы" r_DCTypes


			SELECT (SELECT top 1 ProdID FROM r_DCTypes dt where dt.DCTypeCode = d.DCTypeCode) ProdID
			,(SELECT UM FROM r_Prods p where p.ProdID = (SELECT top 1 ProdID FROM r_DCTypes dt where dt.DCTypeCode = d.DCTypeCode)) 
			+ '_' + cast(cast(substring(d.DCardID,8,5) as int) as varchar) UM
			, 1 Qty, 0 Weight, substring(d.DCardID,8,5)  Notes, d.DCardID BarCode, d.DCardID ProdBarCode, 0 PLID, 0 TareWeight 
			FROM r_dcards d
			left join r_ProdMQ mq on mq.BarCode = d.DCardID
			where d.DCTypeCode = @CardType
			and mq.BarCode  is null

	if @CardType in (3,4,5,6,35,36,37)
	BEGIN
	    select 'добавляем штрихкоды для сертификатов' 

	    INSERT r_ProdMQ (ProdID, UM, Qty, Weight, Notes, BarCode, ProdBarCode, PLID, TareWeight)
			SELECT (SELECT top 1 ProdID FROM r_DCTypes dt where dt.DCTypeCode = d.DCTypeCode) ProdID
			,(SELECT UM FROM r_Prods p where p.ProdID = (SELECT top 1 ProdID FROM r_DCTypes dt where dt.DCTypeCode = d.DCTypeCode)) 
			+ '_' + cast(cast(substring(d.DCardID,8,5) as int) as varchar) UM
			, 1 Qty, 0 Weight, substring(d.DCardID,8,5)  Notes, d.DCardID BarCode, d.DCardID ProdBarCode, 0 PLID, 0 TareWeight 
			FROM r_dcards d
			left join r_ProdMQ mq on mq.BarCode = d.DCardID
			where d.DCTypeCode = @CardType
			and mq.BarCode  is null

			SELECT (SELECT top 1 ProdID FROM r_DCTypes dt where dt.DCTypeCode = d.DCTypeCode) ProdID
			,(SELECT UM FROM r_Prods p where p.ProdID = (SELECT top 1 ProdID FROM r_DCTypes dt where dt.DCTypeCode = d.DCTypeCode)) 
			+ '_' + cast(cast(substring(d.DCardID,8,5) as int) as varchar) UM
			, 1 Qty, 0 Weight, substring(d.DCardID,8,5)  Notes, d.DCardID BarCode, d.DCardID ProdBarCode, 0 PLID, 0 TareWeight 
			FROM r_dcards d
			left join r_ProdMQ mq on mq.BarCode = d.DCardID
			where d.DCTypeCode = @CardType
			--and mq.BarCode  is null
	END

ROLLBACK TRAN


*/

