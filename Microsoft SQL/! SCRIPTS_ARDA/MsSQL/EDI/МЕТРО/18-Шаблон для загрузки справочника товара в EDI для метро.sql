--Шаблон для загрузки справочника товара в EDI для метро
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

DECLARE @PLID int = 18 -- прайс лист

DECLARE @CurrID SMALLINT, @KursMC NUMERIC(21,9), @prodbarcode varchar(120), @Price numeric (21,3) ,@CscProd Varchar (50) ,@UM Varchar (50)
SET @CurrID = dbo.zf_GetCurrCC();
SET @KursMC = dbo.zf_GetRateMC(@CurrID);

DECLARE @ProdID int
DECLARE Metro CURSOR FOR
  SELECT ProdID from r_ProdMP where PLID=@PLID
  --SELECT * from r_ProdMP where PLID=18
  
  Open Metro
FETCH NEXT FROM Metro INTO @ProdID
WHILE @@FETCH_STATUS = 0
BEGIN
	--SELECT @prodbarcode = ISNULL(MAX(ProdBarCode),0) from t_PInP where ProdID= @ProdID
	SELECT top 1 @prodbarcode = ISNULL(ProdBarCode,0) from t_PInP where ProdID= @ProdID ORDER BY dbo.t_PInP.PPID desc
	--SELECT @CscProd = ISNULL(MAX(CstProdCode),0) from t_PInP where ProdID= @ProdID
	SELECT top 1 @CscProd = ISNULL(CstProdCode,0) from t_PInP where ProdID= @ProdID AND CstProdCode <> '' ORDER BY dbo.t_PInP.PPID desc
	SELECT @Price = CASE WHEN pl.ProdBarCode IN (3068320113265,3068320055022)   THEN  (max(mp.PriceMC) * @KursMC *6)/1.2 ELSE max(mp.PriceMC) * @KursMC/1.2 END 
	from r_ProdMP mp JOIN t_PInP pl on mp.ProdID=pl.ProdID where PLID=@PLID and pl.ProdBarCode=@prodbarcode group by ProdBarCode

	INSERT #Temp
		 SELECT pr.Notes
		 , rpm.BarCode --@prodbarcode
		 , @ProdID,  @Price ,@CscProd 
		 FROM r_ProdMP mp 
		 JOIN r_Prods pr on mp.ProdID=pr.ProdID 
		 JOIN r_ProdMQ rpm on rpm.ProdID=pr.ProdID 
		 where mp.PLID=@PLID and mp.ProdID=@ProdID AND rpm.BarCode NOT LIKE '%|_%'  ESCAPE '|'

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
	   ,(SELECT Qty	FROM r_prodmq WHERE	r_prodmq.ProdID = #Temp.ProdID AND UM = 'метро/един.') metro_count 
FROM #Temp
ORDER BY 10
/*
SELECT ProdName 'Название', Prodbarcode 'Штрихкод', ProdId 'Вн. № продукта', '' 'Артикул покупателя',
	   Price 'Цена',5 'Ставка НДС', '' 'Цена с НДС', 8 'Ед. измерения', CscProd 'Код УКТВЭД'
	   ,(SELECT 
			CASE WHEN UM = 'метро/един.' THEN Qty
			ELSE '-'
			END 
		FROM r_prodmq WHERE	r_prodmq.ProdID = #Temp.ProdID AND UM = 'метро/един.') metro_count 
FROM #Temp
WHERE #Temp.ProdID IN (26213,31815,31874,29151,28585,28586,29152,31878,26168,31880,3127,31879,30843) 
ORDER BY 10

SELECT d.prodid, d.qty, * FROM dbo.t_Inv m 
JOIN t_InvD d ON m.ChID =  d.ChID
WHERE d.prodid IN (31880,3127) AND m.DocDate > '20190101' AND m.compid IN (7001, 7002, 7003)

SELECT d.prodid, d.qty, * FROM dbo.t_Inv m 
JOIN t_InvD d ON m.ChID =  d.ChID
WHERE d.prodid IN (31880,3127) AND m.DocDate > '20190101' AND m.compid IN (7138)

					WHEN  @CompID=7138 AND ird.ProdID in (26213,31815,31874) THEN dd.PriceCC_nt *20
					WHEN  @CompID=7138 AND ird.ProdID in (29151) THEN dd.PriceCC_nt *24
					WHEN  @CompID=7138 AND ird.ProdID in (28585) THEN dd.PriceCC_nt *30
					WHEN  @CompID=7138 AND ird.ProdID in (28586,29152) THEN dd.PriceCC_nt *6
					WHEN  @CompID=7138 AND ird.ProdID= 31878 THEN  dd.PriceCC_nt* 6 
					WHEN  @CompID=7138 AND ird.ProdID= 26168 THEN dd.PriceCC_nt*12 
					WHEN  @CompID=7138 AND ird.ProdID= 31880 THEN  dd.PriceCC_nt* 6 
					WHEN  @CompID=7138 AND ird.ProdID= 3127 THEN  dd.PriceCC_nt* 6 
					WHEN  @CompID=7138 AND ird.ProdID= 31879 THEN  dd.PriceCC_nt*6
					WHEN  @CompID=7138 AND ird.ProdID= 30843 THEN  dd.PriceCC_nt*6 */

--select * from r_PLs where PLName like '%метро%'


/*
SELECT Prodbarcode,count(Prodbarcode) FROM #Temp WHERE Prodbarcode = '7791728017366' GROUP BY Prodbarcode --HAVING count(Prodbarcode) > 1
SELECT Prodbarcode,Price,count(Prodbarcode) FROM #Temp WHERE Prodbarcode = '7791728017366'  GROUP BY Prodbarcode,Price --HAVING count(Prodbarcode) > 1

SELECT Prodbarcode,count(Prodbarcode) FROM #Temp WHERE Prodbarcode = '7791728019681' GROUP BY Prodbarcode --HAVING count(Prodbarcode) > 1
SELECT Prodbarcode,Price,count(Prodbarcode) FROM #Temp WHERE Prodbarcode = '7791728019681'  GROUP BY Prodbarcode,Price --HAVING count(Prodbarcode) > 1
SELECT Prodbarcode,Price,count(Prodbarcode) FROM #Temp GROUP BY Prodbarcode,Price HAVING count(Prodbarcode) = 1


UPDATE #Temp SET Price = 100 WHERE ProdId = 31602
*/
--SELECT ISNULL(MAX(ProdBarCode),0) from t_PInP where ProdID IN (33071,33919)
--SELECT * from t_PInP where ProdID IN (33071,33919)
--SELECT * from t_PInP where ProdID IN (30551,31134,32060)
--SELECT * from r_ProdMQ rpm where ProdID IN (33071,33919)
--SELECT * from r_ProdMQ rpm where ProdID IN (30551,31134,32060)

/*
Название	Штрихкод	Вн. № продукта	Артикул покупателя	Цена	Ставка НДС	Цена с НДС	Ед. измерения	Код УКТВЭД
Віскі Шотл Ханкі Банністер бленд 40% New Design Original 0,7*12 з коробкою в наборі	5010509001229	26137		233.900	5		8	2208307100

заказ
7	HANKEY BANNIS ВІСКІ 0,7 	5010509001243	132	шт			1	313517001001	268629

ув об отгрузке	
Віскі Шотл Ханкі Банністер бленд 40% New Design Original 0,7*12 з короИнформация об этом товаре на Listex.info	5010509001229	132.0	132		268629	26137	233.9

ув о приеме
7	Віскі Шотл Ханкі Банністер бленд 40% New Design Original 0,7*12	5010509001243	132	шт	313517001001
*/