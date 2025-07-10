--Генерация новых 13 значных номеров карт по диапазону от @BChID до @EChID
--если карта существует она пропускается
--в поле Notes добавляется 5 значный код (эмбоссер)(последние 5 цифер от 12 значного номера карты) 
--в поле InUse ставится 1 (карта готова к использованию)

select top 100 * from r_DCards where DCardID like '22%' ORDER BY DCardID desc
SELECT * FROM r_DCTypes

BEGIN TRAN

DECLARE 
 @BChID bigint = 223000000201,	/* Начальный 12 значный номер карты */
 @EChID bigint = 223000000290,	/* Конечный 12 значный номер карты */
 @CardType int = 3, /* Тип карты из Справочника типов дисконтных карт(2 - Накопительный) */
 @Disc int = 0,	/* Начальный процент скидки */
 @BonusSum int = 0  /* Начальная сумма бонусов */
 
 EXEC ip_CreateDCards13 @BChID,@EChID,@CardType,@Disc,@BonusSum
 
 select * from r_DCards where DCardID between cast(@BChID AS varchar) + '%' and cast(@EChID AS varchar) + '%'
  
ROLLBACK TRAN


SELECT * FROM r_DCards where DCTypeCode in (4)
ORDER BY DCTypeCode,3


--############################################################################################### 
--############################################################################################### 

--генерировать сертификаты
BEGIN TRAN

DECLARE 
 @BChID bigint = 223000000201,	/* Начальный 12 значный номер карты */
 @EChID bigint = 223000000290,	/* Конечный 12 значный номер карты */
 @CardType int = 6, /* Тип карты из Справочника типов дисконтных карт(2 - Накопительный) */
 @Disc int = 0,	/* Начальный процент скидки */
 @BonusSum int = 0  /* Начальная сумма бонусов */
 
 EXEC ip_CreateDCards13 @BChID,@EChID,@CardType,@Disc,@BonusSum
 
 --сделать сертификаты доступным для продажи
 update r_DCards 
 set InUse = 0
 where DCardID between cast(@BChID AS varchar) + '0' and cast(@EChID AS varchar) + '9'

 select * from r_DCards where DCardID between cast(@BChID AS varchar) + '0' and cast(@EChID AS varchar) + '9'
 
ROLLBACK TRAN


--генерировать новые штрихкоды для сертификатов
BEGIN TRAN
 
	DECLARE @s varchar(40) = '223000000%'
	DECLARE @n int
	--SELECT UM, cast(ISNULL(SUBSTRING(UM,5,5),0) as int) FROM r_ProdMQ where ProdID in ((SELECT top 1 ProdID FROM r_ProdMQ where BarCode like @s)) ORDER BY cast(ISNULL(SUBSTRING(UM,5,5),0) as int) desc
	SELECT @n = max(cast(ISNULL(SUBSTRING(UM,5,5),0) as int)) FROM r_ProdMQ where ProdID in ((SELECT top 1 ProdID FROM r_ProdMQ where BarCode like @s)) 

	INSERT r_ProdMQ
	SELECT (SELECT top 1 ProdID FROM r_ProdMQ where BarCode like @s) ProdID, 
		'шт_' + cast((ROW_NUMBER()OVER(ORDER BY DCardID) + @n ) as varchar) UM, 
		1 Qty, 0 Weight, Notes Notes, DCardID BarCode, DCardID ProdBarCode, 0 PLID
	FROM r_DCards where DCardID like @s and  DCardID not in (SELECT BarCode FROM r_ProdMQ where BarCode like @s)

	SELECT * FROM r_ProdMQ where BarCode like @s ORDER BY BarCode

	--IF EXISTS (SELECT 1 FROM r_ProdMQ i WHERE 
	--NOT EXISTS (SELECT * FROM r_Uni WHERE RefTypeID = 80021 AND (i.UM = RefName OR i.UM LIKE RefName + '[_][0-9]' OR i.UM LIKE RefName + '[_][0-9][0-9]' OR i.UM LIKE RefName + '[_][0-9][0-9][0-9]')))

ROLLBACK TRAN
 