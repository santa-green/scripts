--EXECUTE ip_SRecSpecCalc #Параметр_Код регистрации#

--EXECUTE ip_SRecSpecCalc 100015449

DECLARE 
	@OurID int, @StockID int, @SubStockID int, 
	@DocDate smalldatetime, @KursMC numeric(21,9), 
	@AChID int, @ProdID int, @PPID int, @Qty numeric(21,9)
SELECT 
	@OurID = OurID, @StockID = StockID, @SubStockID = SubStockID, 
	@DocDate = DocDate, @KursMC = KursMC
FROM t_SRec WITH (NOLOCK)
WHERE
	ChID = 100015449
	
SELECT	 @OurID,@StockID,@SubStockID,@DocDate,@KursMC

SELECT m.OurID,m.StockID,m.SubStockID,m.DocDate,a.ProdID
			FROM t_SRec m WITH(NOLOCK)
			JOIN t_SRecA a WITH(NOLOCK) ON a.ChID = m.ChID
			JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = a.ProdID AND rp.InRems = 1
			WHERE m.ChID = 100015449 AND EXISTS(SELECT * FROM [dbo].[af_GetMissSpecs](@OurID,m.StockID,m.SubStockID,m.DocDate,a.ProdID))

OurID	StockID	SubStockID	DocDate	ProdID
12	1202	1207	2016-12-01 00:00:00	605833  12361
12	1202	1207	2016-12-01 00:00:00	606474  12669

SELECT * FROM [dbo].[af_GetMissSpecs](12,1202,1207,'2016-12-01',605833)
SELECT * FROM [dbo].[af_GetMissSpecs](12,1314,1207,'2016-12-01',606474)
select * from r_Prods where ProdID = 605833	

select * from it_Spec where ChID = 12361
select * from it_Specd where ChID = 12361

select * from it_Spec where ChID = 12362
select * from it_Specd where ChID = 12362


SELECT   ChID, *
	FROM dbo.it_Spec m WITH(NOLOCK)
	WHERE StockID = 1202 AND DocDate <= '2016-12-01' AND ProdID = 605833
	AND EXISTS(SELECT * FROM dbo.it_SpecD d WITH(NOLOCK) WHERE d.ChID = m.ChID)
	ORDER BY DocDate DESC, DocID DESC
	
	
	 	SELECT DISTINCT ProdID 
		FROM it_SpecD d WITH(NOLOCK)
		WHERE ChID = 12669
		AND UseSubItems = 1

	
---------------------------------
 /* Проверка наличия калькуляционных карт */
  IF EXISTS(SELECT a.*
			FROM t_SRec m WITH(NOLOCK)
			JOIN t_SRecA a WITH(NOLOCK) ON a.ChID = m.ChID
			JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = a.ProdID AND rp.InRems = 1
			WHERE m.ChID = 100015363 AND EXISTS(SELECT * FROM [dbo].[af_GetMissSpecs](m.OurID,m.StockID,m.SubStockID,m.DocDate,a.ProdID)))
  
  BEGIN
    DECLARE @Msg VARCHAR(MAX) = ''

    SELECT @Msg = @Msg + ',' + CAST(ProdID AS VARCHAR(10))
    FROM (SELECT DISTINCT f.ProdID
			FROM t_SRec m WITH(NOLOCK)
			JOIN t_SRecA a WITH(NOLOCK) ON a.ChID = m.ChID
			JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = a.ProdID AND rp.InRems = 1
          CROSS APPLY [dbo].[af_GetMissSpecs](m.OurID,m.StockID,m.SubStockID,m.DocDate,a.ProdID) f
          WHERE m.DocDate = @DocDate AND m.OurID = @OurID AND m.StockID = @StockID AND m.ChID  = @ChID) q
    DECLARE @STR VARCHAR(MAX) = SUBSTRING(@Msg,2,65535)
    DECLARE @PSTR VARCHAR(255) = ''
    SET @Msg = ''
    WHILE LEN(@STR) > 0
    BEGIN
      SET @PSTR = LEFT(@STR, 100)
      SET @STR = SUBSTRING(@STR,101,16000000)
      SET @Msg = @Msg + @PSTR + CHAR(13) + CHAR(10)
    END

    RAISERROR ('ВНИМАНИЕ!!! Для товаров %s не созданы калькуляционные карты! Действие отменено.', 18, 1, @Msg)   
	RETURN
  END
------------------------------

	--EXECUTE ip_SRecASpecCalc
		@OurID = 12, @StockID = 1202, @SubStockID = 1207, 
		@DocDate = '2016-12-09', @KursMC = 27, @AChID = 100336667, 
		@ProdID = 607152, @PPID = 16, @Qty = 3
		
		

DECLARE SRecA CURSOR LOCAL FAST_FORWARD
FOR

SELECT
	AChID, ProdID, PPID, Qty
FROM t_SRecA WITH (NOLOCK)
WHERE 
	ChID = 100015449

OPEN SRecA
	FETCH NEXT FROM SRecA
	INTO
		@AChID, @ProdID, @PPID, @Qty
WHILE @@FETCH_STATUS = 0 
BEGIN 
	EXECUTE ip_SRecASpecCalc
		@OurID = @OurID, @StockID = @StockID, @SubStockID = @SubStockID, 
		@DocDate = @DocDate, @KursMC = @KursMC, @AChID = @AChID, 
		@ProdID = @ProdID, @PPID = @PPID, @Qty = @Qty

	FETCH NEXT FROM SRecA
	INTO
		@AChID, @ProdID, @PPID, @Qty
END
CLOSE SRecA
DEALLOCATE SRecA