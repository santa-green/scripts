--Шаблон для загрузки справочника товара в EDI для розетки
USE Elit

IF  EXISTS(SELECT * FROM tempdb.dbo.sysobjects WHERE id = OBJECT_ID('tempdb..#Temp') and xtype in (N'U')) DROP TABLE #Temp

CREATE TABLE #Temp
(
ProdName varchar(100),
Prodbarcode varchar(50),
ProdId int,
Price numeric (21,3),
CscProd varchar(50)
)

DECLARE @PLID int = 55 -- прайс лист

DECLARE @CurrID SMALLINT, @KursMC NUMERIC(21,9), @prodbarcode varchar(120), @Price numeric (21,3) ,@CscProd Varchar (50) ,@UM Varchar (50)
SET @CurrID = dbo.zf_GetCurrCC();
SET @KursMC = dbo.zf_GetRateMC(@CurrID);

DECLARE @ProdID int
DECLARE Metro CURSOR FOR
  SELECT ProdID from r_ProdMP where PLID=@PLID
  --SELECT * from r_ProdMP where PLID=55
  
  Open Metro
FETCH NEXT FROM Metro INTO @ProdID
WHILE @@FETCH_STATUS = 0
BEGIN

	SELECT @prodbarcode = ISNULL(MAX(ProdBarCode),0) from t_PInP where ProdID= @ProdID
	SELECT @CscProd = ISNULL(MAX(CstProdCode),0) from t_PInP where ProdID= @ProdID
	SELECT @Price = CASE WHEN pl.ProdBarCode IN (3068320113265,3068320055022)   THEN  (max(mp.PriceMC) * @KursMC *6)/1.2 ELSE max(mp.PriceMC) * @KursMC/1.2 END 
	from r_ProdMP mp JOIN t_PInP pl on mp.ProdID=pl.ProdID where PLID=@PLID and pl.ProdBarCode=@prodbarcode group by ProdBarCode

	INSERT #Temp
		 SELECT pr.Notes, @prodbarcode, @ProdID,  @Price ,@CscProd FROM r_ProdMP mp JOIN r_Prods pr on mp.ProdID=pr.ProdID where PLID=@PLID and mp.ProdID=@ProdID

FETCH NEXT FROM Metro INTO @ProdID
END

CLOSE Metro
DEALLOCATE Metro


	--проверка на разные цены при одинаковых штрихкодах
	IF EXISTS (
				SELECT ProdName 'ВНИМАНИЕ! у этих товаров разные цены но одинаковые штрихкоды', Prodbarcode 'Штрихкод', ProdId 'Вн. № продукта', '' 'Артикул покупателя',
					   Price 'Цена',5 'Ставка НДС', '' 'Цена с НДС', 8 'Ед. измерения', CscProd 'Код УКТВЭД' 
				FROM #Temp t WHERE Prodbarcode IN (
				SELECT Prodbarcode FROM #Temp GROUP BY Prodbarcode HAVING count(Prodbarcode)>1
				) 
				AND Prodbarcode IN (SELECT Prodbarcode FROM #Temp GROUP BY Prodbarcode,Price HAVING count(Prodbarcode) = 1)
	)
	SELECT ProdName 'ВНИМАНИЕ! у этих товаров разные цены но одинаковые штрихкоды', Prodbarcode 'Штрихкод', ProdId 'Вн. № продукта', '' 'Артикул покупателя',
		   Price 'Цена',5 'Ставка НДС', '' 'Цена с НДС', 8 'Ед. измерения', CscProd 'Код УКТВЭД' 
	FROM #Temp t WHERE Prodbarcode IN (
	SELECT Prodbarcode FROM #Temp GROUP BY Prodbarcode HAVING count(Prodbarcode)>1
	) 
	AND Prodbarcode IN (SELECT Prodbarcode FROM #Temp GROUP BY Prodbarcode,Price HAVING count(Prodbarcode) = 1)
	ORDER BY 2



SELECT ProdName 'Название', Prodbarcode 'Штрихкод', ProdId 'Вн. № продукта', '' 'Артикул покупателя',
	   Price 'Цена',5 'Ставка НДС', '' 'Цена с НДС', 8 'Ед. измерения', CscProd 'Код УКТВЭД' 
FROM #Temp ORDER BY 2

--select * from r_PLs where PLName like '%метро%'