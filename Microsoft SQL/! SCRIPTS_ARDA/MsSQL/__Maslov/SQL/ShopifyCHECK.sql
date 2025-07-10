USE [ElitR]

DECLARE @Region INT = 1 --(1 - Днепр; 2 - Киев; 5 - Харьков.)

SELECT 'Количество товаров' AS 'Описание'
SELECT CASE WHEN RefID = 1 THEN 'Днепр'
			WHEN RefID = 2 THEN 'Киев'
			WHEN RefID = 5 THEN 'Харьков'
										END AS 'Город'
	  ,SUBSTRING(RefName,1,CHARINDEX('_IM',RefName)-1) AS 'ИМ'
	  ,CASE WHEN RefID = 1 THEN (SELECT COUNT(*) FROM r_ShopifyProdsDp)
			--WHEN RefID = 2 THEN (SELECT COUNT(*) FROM r_ShopifyProdsKv)
			WHEN RefID = 2 THEN (SELECT COUNT(*) FROM r_ShopifyProds)
			WHEN RefID = 5 THEN (SELECT COUNT(*) FROM r_ShopifyProdsKh)
										END AS 'База'
	  ,Notes AS 'Дата последнего изменения'
FROM r_Uni WHERE RefTypeID = 1000000014

SELECT 'Последние 5 заказов' AS 'Описание'
SELECT TOP 5 * FROM t_IMOrders
WHERE DocID BETWEEN (@Region * 10000000) AND (@Region * 10000000) + 9999999
ORDER BY ChID DESC

BEGIN
/*
Ссылка вытягивает количество товаров с интернет-магазина.
https://4a31bd883165bfd2bb8932c6287e7b9c:6bab3199775c589f2922cd5bdb48a10b@vintagemarket-dev.myshopify.com/admin/api/2020-01/products/count.xml
*/
	SELECT 'Обновления за последнее время' AS 'Описание'
	SELECT TOP 10 * FROM r_ShopifyProds
	ORDER BY UpdateDate DESC

	IF EXISTS(SELECT TOP 1 1 FROM r_ShopifyProds WHERE UpdateState NOT IN (-1, 0, 6) )
	BEGIN
		SELECT 'Не нулевой статус (и не удаление)' AS 'Описание'
			  ,(SELECT COUNT(*) FROM r_ShopifyProds WHERE UpdateState NOT IN (-1, 0, 6) ) AS 'Количество'
	
		SELECT * FROM r_ShopifyProds
		WHERE UpdateState NOT IN (-1, 0, 6) 
	END;

	IF EXISTS(SELECT TOP 1 1 FROM r_ShopifyProds WHERE UpdateState = 6)
	BEGIN
		SELECT 'Товары на удаление' AS 'Описание'
			  ,(SELECT COUNT(*) FROM r_ShopifyProds WHERE UpdateState = 6) AS 'Количество'

		SELECT * FROM r_ShopifyProds
		WHERE UpdateState = 6
	END;
END;

/*
IF @Region = 1
BEGIN
/*
Ссылка вытягивает количество товаров с интернет-магазина Днепра.
https://ae2cd8b5024636640b29d6c8a7c5e1b7:f61cd35b8e1ab1a377abd1c9f5a0e28d@vintagemarket-dp.myshopify.com/admin/api/2020-01/products/count.xml
*/

	SELECT 'Обновления за последнее время' AS 'Описание'
	SELECT TOP 10 * FROM r_ShopifyProdsDp
	ORDER BY UpdateDate DESC

	IF EXISTS(SELECT TOP 1 1 FROM r_ShopifyProdsDp WHERE UpdateState NOT IN (-1, 0, 6) )
	BEGIN
		SELECT 'Не нулевой статус (и не удаление)' AS 'Описание'
			  ,(SELECT COUNT(*) FROM r_ShopifyProdsDp WHERE UpdateState NOT IN (-1, 0, 6) ) AS 'Количество'
	
		SELECT * FROM r_ShopifyProdsDp
		WHERE UpdateState NOT IN (-1, 0, 6)
	END;

	IF EXISTS(SELECT TOP 1 1 FROM r_ShopifyProdsDp WHERE UpdateState = 6)
	BEGIN
		SELECT 'Товары на удаление' AS 'Описание'
			  ,(SELECT COUNT(*) FROM r_ShopifyProdsDp WHERE UpdateState = 6) AS 'Количество'

		SELECT * FROM r_ShopifyProdsDp
		WHERE UpdateState = 6
	END;
END;

IF @Region = 2
BEGIN
/*
Ссылка вытягивает количество товаров с интернет-магазина Киева.
https://4a31bd883165bfd2bb8932c6287e7b9c:6bab3199775c589f2922cd5bdb48a10b@vintagemarket-dev.myshopify.com/admin/api/2020-01/products/count.xml
*/
	SELECT 'Обновления за последнее время' AS 'Описание'
	SELECT TOP 10 * FROM r_ShopifyProdsKv
	ORDER BY UpdateDate DESC

	IF EXISTS(SELECT TOP 1 1 FROM r_ShopifyProdsKv WHERE UpdateState NOT IN (-1, 0, 6) )
	BEGIN
		SELECT 'Не нулевой статус (и не удаление)' AS 'Описание'
			  ,(SELECT COUNT(*) FROM r_ShopifyProdsKv WHERE UpdateState NOT IN (-1, 0, 6) ) AS 'Количество'
	
		SELECT * FROM r_ShopifyProdsKv
		WHERE UpdateState NOT IN (-1, 0, 6) 
	END;

	IF EXISTS(SELECT TOP 1 1 FROM r_ShopifyProdsKv WHERE UpdateState = 6)
	BEGIN
		SELECT 'Товары на удаление' AS 'Описание'
			  ,(SELECT COUNT(*) FROM r_ShopifyProdsKv WHERE UpdateState = 6) AS 'Количество'

		SELECT * FROM r_ShopifyProdsKv
		WHERE UpdateState = 6
	END;
END;

IF @Region = 5
BEGIN
/*
Ссылка вытягивает количество товаров с интернет-магазина Харькова.
https://822ee75ea06b63718ec6422bd0b77748:c2bb7455131d0c407d241170acd20e58@vintagemarket-kh.myshopify.com/admin/api/2020-01/products/count.xml
*/
	SELECT 'Обновления за последнее время' AS 'Описание'
	SELECT TOP 10 * FROM r_ShopifyProdsKh
	ORDER BY UpdateDate DESC

	IF EXISTS(SELECT TOP 1 1 FROM r_ShopifyProdsKh WHERE UpdateState NOT IN (-1, 0, 6) )
	BEGIN
		SELECT 'Не нулевой статус (и не удаление)' AS 'Описание'
			  ,(SELECT COUNT(*) FROM r_ShopifyProdsKh WHERE UpdateState NOT IN (-1, 0, 6) ) AS 'Количество'
	
		SELECT * FROM r_ShopifyProdsKh
		WHERE UpdateState NOT IN (-1, 0, 6)
	END;

	IF EXISTS(SELECT TOP 1 1 FROM r_ShopifyProdsKh WHERE UpdateState = 6)
	BEGIN
		SELECT 'Товары на удаление' AS 'Описание'
			  ,(SELECT COUNT(*) FROM r_ShopifyProdsKh WHERE UpdateState = 6) AS 'Количество'

		SELECT * FROM r_ShopifyProdsKh
		WHERE UpdateState = 6
	END;
END;
*/

/*

--Удаление ненужных товаров.
DELETE r_ShopifyProdsDp WHERE UpdateState = 6
DELETE r_ShopifyProdsKv WHERE UpdateState = 6
DELETE r_ShopifyProdsKh WHERE UpdateState = 6

DELETE r_ShopifyProdsDp WHERE ProdID = 6

--Иногда в товары на удаление случайно попадают 250 позиций.
--Скорей всего это просто не прогрузилась одна из страниц.
UPDATE r_ShopifyProdsDp SET UpdateState = 0 WHERE UpdateState = 6
UPDATE r_ShopifyProdsKv SET UpdateState = 0 WHERE UpdateState = 666

UPDATE r_ShopifyProdsDp SET UpdateState = 0, ProdID = 804002 WHERE UpdateState = 6

UPDATE r_ShopifyProdsDp SET UpdateState = 1 WHERE DiscountActive = 1

--Обновить таймер акции.
UPDATE r_ShopifyProdsDp SET UpdateState = 5 WHERE ProdID IN (600135)
UPDATE r_ShopifyProdsKv SET UpdateState = 5 WHERE ProdID IN (600135)
UPDATE r_ShopifyProdsKh SET UpdateState = 5 WHERE ProdID IN (600135)

UPDATE r_ShopifyProdsDp SET UpdateState = -1 WHERE ShopifyID = '3987188645985'

---------------На случай, если коды товара не совпадают.------------------------
UPDATE r_ShopifyProds SET ProdID = 600780, Price = 0, DiscountPrice = 0, DiscountActive = 0, QtyDp = 0, QtyKv = 0, QtyKh = 0, UpdateState = 0 WHERE UpdateState = 10

UPDATE r_ShopifyProdsDp SET ProdID = 802988, Price = 0, DiscountPrice = 0, DiscountActive = 0, Qty = 0, UpdateState = 0 WHERE UpdateState = 7

UPDATE r_ShopifyProdsKh SET ProdID = 802988, Price = 0, DiscountPrice = 0, DiscountActive = 0, Qty = 0, UpdateState = 0 WHERE UpdateState = 7

UPDATE r_ShopifyProdsKv SET ProdID = 802988, Price = 0, DiscountPrice = 0, DiscountActive = 0, Qty = 0, UpdateState = 0 WHERE UpdateState = 7
--------------------------------------------------------------------------------

---------------Возвращаем к жизни товары, которые считались дублями.------------
UPDATE r_ShopifyProds SET UpdateState = 0 WHERE UpdateState = 8

UPDATE r_ShopifyProdsDp SET UpdateState = 0 WHERE UpdateState = 8

UPDATE r_ShopifyProdsKh SET UpdateState = 0 WHERE UpdateState = 8

UPDATE r_ShopifyProdsKv SET UpdateState = 0 WHERE UpdateState = 8
--------------------------------------------------------------------------------

SELECT * FROM r_ShopifyProdsDp
--WHERE ProdID = 802186
ORDER BY 2

SELECT COUNT(*) FROM r_ShopifyProdsDp
WHERE DiscountActive = 1 AND qty != 0

SELECT DATEADD(MONTH, ((YEAR(GETDATE()) - 1900) * 12) + MONTH(GETDATE()), -1)
*/