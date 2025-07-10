BEGIN TRAN

--ALTER PROCEDURE [dbo].[ap_CalcSRec_B_date_E_date]  

DECLARE
@BDate SMALLDATETIME = '2018-01-16',
@EDate SMALLDATETIME = '2018-01-16', 
@OurID INT = 6, 
@StockID INT = 1257, 
@DocCode INT = 11035

  /* Процедура автоматической сборки (комплектации) комплектов из комплектующих */
  
  -- Pvm0 23.05.2017 для этих складов выбирать только готовые блюда r_Prods.pgrid1 = 208
  
  /*setuser 'hvv5'*/
  /* EXEC ap_CalcSRec '20150507', 9, 1202, 11035 */
  
  SET NOCOUNT ON

  SET XACT_ABORT ON
  
  IF OBJECT_ID (N'tempdb..#TSale', N'U') IS NOT NULL DROP TABLE #TSale
  IF OBJECT_ID (N'tempdb..#TRemD', N'U') IS NOT NULL DROP TABLE #TRemD
  

  /* Объявление переменных */
  DECLARE 
   @CurrID SMALLINT, 
   @KursMC NUMERIC(21,9), 
   @ChID INT, 
   @DocID INT, 
   @AChID INT, 
   @SubSrcPosID INT,
   @DQty NUMERIC(21,9), 
   @SQty NUMERIC(21,9), 
   @SubPPID INT, 
   @SubQty NUMERIC(21,9), 
   @SubProdID INT,
   @SubPriceCC NUMERIC(21,9), 
   @SubUM VARCHAR(10), 
   @SubBarCode VARCHAR(42), 
   @SumQty NUMERIC(21,9),
   @SrcPosID INT, 
   @ProdID INT, 
   @UM VARCHAR(10), 
   @BarCode VARCHAR(42), 
   @Qty NUMERIC(21,9), 
   @RemQty NUMERIC(21,9),
   @PriceCC NUMERIC(21,9), 
   @PPID INT, 
   @SubStockID INT,
   @PPID_START INT, 
   @PPID_END INT, 
   @IsBlackSale TINYINT,
   @Msg VARCHAR(MAX) = '', 
   @STR VARCHAR(MAX), 
   @PSTR VARCHAR(255) = '',
   @Notes varchar (150),
   @ChIDStart INT,
   @ChIDEnd INT

  SELECT @ChIDStart = ChStart, @ChIDEnd = ChEnd FROM dbo.zf_ChIDRange()
   
  
  /* Проверка корректности Фирмы */
  IF ISNULL(@OurID, -1) NOT IN (6,9,12)
  BEGIN
    RAISERROR ('ВНИМАНИЕ!!! Указана неверная Фирма! Действие отменено. (PROCEDURE [dbo].[ap_CalcSRec_B_date_E_date])', 18, 1)
    RETURN
  END

  /* Проверка корректности Склада */  
  IF ISNULL(@StockID, -1) NOT IN (1001,1202,1222,1310,1314,1315,1225,1252,1257,1260)
  BEGIN
    RAISERROR ('ВНИМАНИЕ!!! Указан неверный Склад! Действие отменено. (PROCEDURE [dbo].[ap_CalcSRec_B_date_E_date])', 18, 1)
    RETURN
  END
  
  /* Проверка корректности Документа */  
  IF ISNULL(@DocCode, -1) NOT IN (11035,11012)
  BEGIN
    RAISERROR ('ВНИМАНИЕ!!! Выбран неверный документ! Действие отменено. (PROCEDURE [dbo].[ap_CalcSRec_B_date_E_date])', 18, 1)
    RETURN
  END
  
  /* Проверка наличия товара в рабочих прайс-листах */
  IF @DocCode = 11035 /* Продажа товара оператором */
  BEGIN
    IF (SELECT COUNT(*) 
        FROM t_Sale m WITH(NOLOCK)
        JOIN t_SaleD d WITH(NOLOCK) ON d.ChID = m.ChID
        JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID AND rp.InRems = 1
        JOIN r_Stocks rs WITH(NOLOCK) ON rs.StockID = m.StockID
        WHERE m.DocDate = @EDate  AND m.OurID = @OurID AND m.StockID = @StockID AND m.StateCode = 22)
    <> (SELECT COUNT(*) 
        FROM t_Sale m WITH(NOLOCK)
        JOIN t_SaleD d WITH(NOLOCK) ON d.ChID = m.ChID
        JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID AND rp.InRems = 1
        JOIN r_Stocks rs WITH(NOLOCK) ON rs.StockID = m.StockID
        JOIN r_ProdMP mp WITH(NOLOCK) ON mp.ProdID = d.ProdID AND mp.PLID = rs.PLID
        JOIN ir_StockSubs rss WITH(NOLOCK) ON rss.DepID = mp.DepID AND rss.StockID = rs.StockID
        WHERE m.DocDate = @EDate  AND m.OurID = @OurID AND m.StockID = @StockID AND m.StateCode = 22)
    BEGIN
      SELECT @ProdID = (
      SELECT TOP 1 d.ProdID 
      FROM t_Sale m WITH(NOLOCK)
      JOIN t_SaleD d WITH(NOLOCK) ON d.ChID = m.ChID
      JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID AND rp.InRems = 1
      JOIN r_Stocks rs WITH(NOLOCK) ON rs.StockID = m.StockID
      WHERE m.DocDate = @EDate  AND m.OurID = @OurID AND m.StockID = @StockID AND m.StateCode = 22
        AND NOT EXISTS (SELECT * 
                        FROM r_ProdMP mp WITH(NOLOCK)
                        JOIN ir_StockSubs rss WITH(NOLOCK) ON rss.DepID = mp.DepID AND rss.StockID = rs.StockID
                        WHERE mp.ProdID = d.ProdID AND mp.PLID = rs.PLID   ))
      RAISERROR ('ВНИМАНИЕ!!! Проблема с наличием товара [%u] в рабочих прайс-листах! Действие отменено. (PROCEDURE [dbo].[ap_CalcSRec_B_date_E_date])', 18, 1, @ProdID)
      RETURN
    END 
  END  
  
  IF @DocCode = 11012 /* Расходная накладная */
  BEGIN
    IF (SELECT COUNT(*) 
        FROM t_Inv m WITH(NOLOCK)
        JOIN t_InvD d WITH(NOLOCK) ON d.ChID = m.ChID
        JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID AND rp.InRems = 1
        JOIN r_Stocks rs WITH(NOLOCK) ON rs.StockID = m.StockID
        WHERE m.DocDate = @EDate  AND m.OurID = @OurID AND m.StockID = @StockID AND m.StateCode = 0)
    <> (SELECT COUNT(*) 
        FROM t_Inv m WITH(NOLOCK)
        JOIN t_InvD d WITH(NOLOCK) ON d.ChID = m.ChID
        JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID AND rp.InRems = 1
        JOIN r_Stocks rs WITH(NOLOCK) ON rs.StockID = m.StockID
        JOIN r_ProdMP mp WITH(NOLOCK) ON mp.ProdID = d.ProdID AND mp.PLID = rs.PLID 
        JOIN ir_StockSubs rss WITH(NOLOCK) ON rss.DepID = mp.DepID AND rss.StockID = rs.StockID
        WHERE m.DocDate = @EDate  AND m.OurID = @OurID AND m.StockID = @StockID AND m.StateCode = 0)
    BEGIN
      SELECT @ProdID = (
      SELECT TOP 1 d.ProdID 
      FROM t_Inv m WITH(NOLOCK)
      JOIN t_InvD d WITH(NOLOCK) ON d.ChID = m.ChID
      JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID AND rp.InRems = 1
      JOIN r_Stocks rs WITH(NOLOCK) ON rs.StockID = m.StockID
      WHERE m.DocDate = @EDate  AND m.OurID = @OurID AND m.StockID = @StockID AND m.StateCode = 0
        AND NOT EXISTS (SELECT * 
                        FROM r_ProdMP mp WITH(NOLOCK)
                        JOIN ir_StockSubs rss WITH(NOLOCK) ON rss.DepID = mp.DepID AND rss.StockID = rs.StockID
                        WHERE mp.ProdID = d.ProdID AND mp.PLID = rs.PLID))
      RAISERROR ('ВНИМАНИЕ!!! Проблема с наличием товара [%u] в рабочих прайс-листах! Действие отменено. (PROCEDURE [dbo].[ap_CalcSRec_B_date_E_date])', 18, 1, @ProdID)
      RETURN
    END 
  END  
  
  /* Проверка наличия калькуляционных карт */
  IF @DocCode = 11035 /* Продажа товара оператором */
  BEGIN
    IF EXISTS(SELECT *
              FROM t_Sale m WITH(NOLOCK)
              JOIN t_SaleD d WITH(NOLOCK) ON d.ChID = m.ChID
              JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID AND rp.InRems = 1 AND d.ProdID NOT IN (605845,605846,606392,605548,800894,605847,800892,800895,800896)
              JOIN r_Stocks rs WITH(NOLOCK) ON rs.StockID = m.StockID
              JOIN r_ProdMP mp WITH(NOLOCK) ON mp.ProdID = d.ProdID AND mp.PLID = rs.PLID AND mp.DepID <>0
              JOIN ir_StockSubs rss WITH(NOLOCK) ON rss.DepID = mp.DepID AND rss.StockID = rs.StockID
              WHERE m.DocDate = @EDate  AND m.OurID = @OurID AND m.StockID = @StockID AND m.StateCode = 22 
              AND EXISTS(SELECT * FROM [dbo].[af_GetMissSpecs](m.OurID,m.StockID,rss.SubStockID,m.DocDate,d.ProdID)))
    BEGIN
      SELECT @Msg = @Msg + ',' + CAST(ProdID AS VARCHAR(10))
      FROM (SELECT DISTINCT f.ProdID
            FROM t_Sale m WITH(NOLOCK)
            JOIN t_SaleD d WITH(NOLOCK) ON d.ChID = m.ChID
            JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID AND rp.InRems = 1 AND d.ProdID NOT IN (605845,605846,606392,605548,800894,605847,800892)
            JOIN r_Stocks rs WITH(NOLOCK) ON rs.StockID = m.StockID
            JOIN r_ProdMP mp WITH(NOLOCK) ON mp.ProdID = d.ProdID AND mp.PLID = rs.PLID
            JOIN ir_StockSubs rss WITH(NOLOCK) ON rss.DepID = mp.DepID AND rss.StockID = rs.StockID
            CROSS APPLY [dbo].[af_GetMissSpecs](m.OurID,m.StockID,rss.SubStockID,m.DocDate,d.ProdID) f
            WHERE m.DocDate = @EDate  AND m.OurID = @OurID AND m.StockID = @StockID AND m.StateCode = 22) q
      SELECT @STR = SUBSTRING(@Msg,2,65535)
      SET @Msg = ''
      WHILE LEN(@STR) > 0
      BEGIN
        SET @PSTR = LEFT(@STR, 100)
        SET @STR = SUBSTRING(@STR,101,16000000)
        SET @Msg = @Msg + @PSTR + CHAR(13) + CHAR(10)
      END

      RAISERROR ('ВНИМАНИЕ!!! Для товаров [%s] не созданы калькуляционные карты! Действие отменено. (PROCEDURE [dbo].[ap_CalcSRec_B_date_E_date])', 18, 1, @Msg)   
	  RETURN
    END
  END
  
  IF @DocCode = 11012 /* Расходная накладная */
  BEGIN
    IF EXISTS(SELECT *
              FROM t_Inv m WITH(NOLOCK)
              JOIN t_InvD d WITH(NOLOCK) ON d.ChID = m.ChID
              JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID AND rp.InRems = 1
              JOIN r_Stocks rs WITH(NOLOCK) ON rs.StockID = m.StockID
              JOIN r_ProdMP mp WITH(NOLOCK) ON mp.ProdID = d.ProdID AND mp.PLID = rs.PLID AND mp.DepID <>0
              JOIN ir_StockSubs rss WITH(NOLOCK) ON rss.DepID = mp.DepID AND rss.StockID = rs.StockID
              WHERE m.DocDate = @EDate  AND m.OurID = @OurID AND m.StockID = @StockID AND m.StateCode = 22 AND d.ProdID NOT IN (605845,605846,606392)
              AND EXISTS(SELECT * FROM [dbo].[af_GetMissSpecs](m.OurID,m.StockID,rss.SubStockID,m.DocDate,d.ProdID)))
    BEGIN
      SELECT @Msg = @Msg + ',' + CAST(ProdID AS VARCHAR(10))
      FROM (SELECT DISTINCT f.ProdID
            FROM t_Inv m WITH(NOLOCK)
            JOIN t_InvD d WITH(NOLOCK) ON d.ChID = m.ChID
            JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID AND rp.InRems = 1
            JOIN r_Stocks rs WITH(NOLOCK) ON rs.StockID = m.StockID
            JOIN r_ProdMP mp WITH(NOLOCK) ON mp.ProdID = d.ProdID AND mp.PLID = rs.PLID
            JOIN ir_StockSubs rss WITH(NOLOCK) ON rss.DepID = mp.DepID AND rss.StockID = rs.StockID
            CROSS APPLY [dbo].[af_GetMissSpecs](m.OurID,m.StockID,rss.SubStockID,m.DocDate,d.ProdID) f
            WHERE m.DocDate = @EDate  AND m.OurID = @OurID AND m.StockID = @StockID AND m.StateCode = 22) q
      SELECT @STR = SUBSTRING(@Msg,2,65535)
      SET @Msg = ''
      WHILE LEN(@STR) > 0
      BEGIN
        SET @PSTR = LEFT(@STR, 100)
        SET @STR = SUBSTRING(@STR,101,16000000)
        SET @Msg = @Msg + @PSTR + CHAR(13) + CHAR(10)
      END

      RAISERROR ('ВНИМАНИЕ!!! Для товаров [%s] не созданы калькуляционные карты! Действие отменено. (PROCEDURE [dbo].[ap_CalcSRec_B_date_E_date])', 18, 1, @Msg)   
	  RETURN
    END
  END     
  
  /* Присвоение значений переменным: Валюта, Курс ОВ */
  SELECT @CurrID = dbo.zf_GetCurrCC(), @KursMC = dbo.zf_GetRateMC(dbo.zf_GetCurrCC())

SELECT @CurrID CurrID, @KursMC KursMC 

  --BEGIN TRAN
  
  /* Создание временной таблицы остатков на дату */
  CREATE TABLE #TRemD (
    ProdID INT,
    PPID INT,
    Qty NUMERIC (21, 9))    
  
  IF @DocCode = 11035 /* Продажа товара оператором */
  BEGIN   
    /* Создание временной таблицы, в которой будут храниться все коды регистрации "Продажа товара оператором",
       которые нужно обработать */ 
        
    CREATE TABLE #TSale (ChID INT)

    /* Импорт данных о кодах регистрации во временную таблицу. Условие: Статус = 22, Фирма и Склад из параметров */
    INSERT #TSale
    SELECT ChID FROM t_Sale WITH(NOLOCK) WHERE DocDate BETWEEN @BDate  AND @EDate   AND OurID = @OurID AND StockID = @StockID AND StateCode = 22
    --SELECT m.ChID FROM t_Sale m where ChID = 100529352
--join t_SaleD d on d.ChID = m.ChID
--where DocDate = '2017-06-01' and OurID = 12 and StockID = 1314
--and ProdID = 605403

SELECT '#TSale'
SELECT * FROM #TSale

    /* Создание индекса по полю "Код регистрации" для ускорения последующей выборки из таблицы */
    CREATE NONCLUSTERED INDEX ChID ON #TSale (ChID ASC)
    
    DECLARE SRec CURSOR LOCAL FOR
    SELECT DISTINCT rss.SubStockID
    FROM t_Sale m WITH(NOLOCK)
    JOIN t_SaleD d WITH(NOLOCK) ON d.ChID = m.ChID
    JOIN r_Stocks rs WITH(NOLOCK) ON rs.StockID = m.StockID
    JOIN r_ProdMP mp WITH(NOLOCK) ON mp.ProdID = d.ProdID AND mp.PLID = d.PLID
    JOIN ir_StockSubs rss WITH(NOLOCK) ON rss.DepID = mp.DepID AND rss.StockID = rs.StockID
    WHERE EXISTS (SELECT * FROM #TSale WHERE ChID = m.ChID)
    ORDER BY rss.SubStockID

select 'DECLARE SRec CURSOR LOCAL FOR'
SELECT DISTINCT rss.SubStockID
FROM t_Sale m WITH(NOLOCK)
JOIN t_SaleD d WITH(NOLOCK) ON d.ChID = m.ChID
JOIN r_Stocks rs WITH(NOLOCK) ON rs.StockID = m.StockID
JOIN r_ProdMP mp WITH(NOLOCK) ON mp.ProdID = d.ProdID AND mp.PLID = d.PLID
JOIN ir_StockSubs rss WITH(NOLOCK) ON rss.DepID = mp.DepID AND rss.StockID = rs.StockID
WHERE EXISTS (SELECT * FROM #TSale WHERE ChID = m.ChID)
ORDER BY rss.SubStockID
    
    OPEN SRec
    FETCH NEXT FROM SRec INTO @SubStockID
    WHILE @@FETCH_STATUS = 0
    BEGIN
      /* Подготовка остатков на дату */   
      INSERT #TRemD
      (ProdID, PPID, Qty)
      SELECT ProdID, PPID, SUM(Qty - AccQty) Qty
      FROM dbo.af_CalcRemD_F(@EDate , @OurID, @SubStockID, 1, NULL)
      GROUP BY ProdID, PPID
      HAVING ISNULL(SUM(Qty - AccQty),0) >= 0

SELECT '#TRemD'
SELECT * FROM #TRemD
      
      /* Определение типа продажи: черная или белая? Или черный безнал ?? */ 
      DECLARE SRecBW CURSOR LOCAL FOR
      SELECT DISTINCT CASE m.CodeID3 WHEN 89 THEN 1  WHEN 19	 THEN 2  WHEN 23 THEN 3 ELSE 0 END IsBlackSale
      FROM t_Sale m WITH(NOLOCK)
      JOIN t_SaleD d WITH(NOLOCK) ON d.ChID = m.ChID
      JOIN r_Stocks rs WITH(NOLOCK) ON rs.StockID = m.StockID
      JOIN r_ProdMP mp WITH(NOLOCK) ON mp.ProdID = d.ProdID AND mp.PLID = d.PLID
      JOIN ir_StockSubs rss WITH(NOLOCK) ON rss.DepID = mp.DepID AND rss.StockID = rs.StockID
      WHERE EXISTS (SELECT * FROM #TSale WHERE ChID = m.ChID) AND rss.SubStockID = @SubStockID
      ORDER BY IsBlackSale
      
select 'DECLARE SRecBW CURSOR LOCAL FOR'      
SELECT DISTINCT CASE m.CodeID3 WHEN 89 THEN 1  WHEN 19	 THEN 2  WHEN 23 THEN 3 ELSE 0 END IsBlackSale
FROM t_Sale m WITH(NOLOCK)
JOIN t_SaleD d WITH(NOLOCK) ON d.ChID = m.ChID
JOIN r_Stocks rs WITH(NOLOCK) ON rs.StockID = m.StockID
JOIN r_ProdMP mp WITH(NOLOCK) ON mp.ProdID = d.ProdID AND mp.PLID = d.PLID
JOIN ir_StockSubs rss WITH(NOLOCK) ON rss.DepID = mp.DepID AND rss.StockID = rs.StockID
WHERE EXISTS (SELECT * FROM #TSale WHERE ChID = m.ChID) AND rss.SubStockID = @SubStockID
ORDER BY IsBlackSale      

      
      OPEN SRecBW
      FETCH NEXT FROM SRecBW INTO @IsBlackSale
      WHILE @@FETCH_STATUS = 0
      BEGIN      
        /* Получение новых кода регистрации и номера для последующего импорта "Комплектация товара: Заголовок" */
        EXEC dbo.z_NewChID 't_SRec', @ChID OUTPUT
        EXEC dbo.z_NewDocID 11321, 't_SRec', @OurID, @DocID OUTPUT 
		SELECT @Notes = 'Склад ' + CAST (@StockID as varchar)+ ', фирма '+ CAST (@OurID as varchar)+' Обработан c '+ dbo.zf_DateToStr (@BDate)+ ' по ' + dbo.zf_DateToStr (@EDate)
		
SELECT @ChID ChID ,	@OurID OurID,  @DocID DocID, @Notes Notes
 	
        /* Импорт в "Комплектация товара: Заголовок" */ 
        INSERT t_SRec
        (ChID, DocID, IntDocID, DocDate, KursMC, OurID, StockID, 
         CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, EmpID,Notes ,SubDocDate, SubStockID, CurrID)
        VALUES
        (@ChID, @DocID, @DocID, @BDate , @KursMC, @OurID, @StockID, 
         100, 99, CASE @IsBlackSale WHEN 1 THEN 89  WHEN 2 THEN 19 WHEN 3 THEN 23 ELSE 107 END, 0, 0, 0,@Notes, @BDate , @SubStockID, @CurrID)
         
 select 'INSERT t_SRec'        
 SELECT @ChID, @DocID, @DocID, @BDate , @KursMC, @OurID, @StockID, 
         100, 99, CASE @IsBlackSale WHEN 1 THEN 89  WHEN 2 THEN 19 WHEN 3 THEN 23 ELSE 107 END, 0, 0, 0,@Notes, @BDate , @SubStockID, @CurrID  
          
        /* Курсор импорта проданных в "Продажа товара оператором" комплектов в "Комплектация товара: Комплекты" */
      IF @StockID in (1001,1257,1260)-- Pvm0 23.05.2017 для этих складов выбирать только готовые блюда r_Prods.pgrid1 = 208
        DECLARE SRecA CURSOR LOCAL FOR
        SELECT ROW_NUMBER() OVER (ORDER BY d.ProdID) SrcPosID, d.ProdID, rp.UM, mq.BarCode, SUM(d.Qty) Qty
        FROM t_Sale m WITH(NOLOCK)
        JOIN t_SaleD d WITH(NOLOCK) ON d.ChID = m.ChID    
        JOIN r_Stocks rs WITH(NOLOCK) ON rs.StockID = m.StockID
        JOIN r_ProdMP mp WITH(NOLOCK) ON mp.ProdID = d.ProdID AND mp.PLID = d.PLID/*AND mp.PLID = rs.PLID*/
        JOIN ir_StockSubs rss WITH(NOLOCK) ON rss.DepID = mp.DepID AND rss.StockID = rs.StockID
        JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID AND rp.InRems = 1 AND rp.pgrid1 = 208 /* допил только готовые блюда */
        LEFT JOIN r_ProdMQ mq WITH(NOLOCK) ON mq.ProdID = rp.ProdID AND mq.UM = rp.UM
        WHERE EXISTS (SELECT * FROM #TSale WHERE ChID = m.ChID) AND rss.SubStockID = @SubStockID 
          AND ((@IsBlackSale = 0 AND m.CodeID3 not in (19,23,89)) OR (@IsBlackSale = 1 AND m.CodeID3 = 89)  OR (@IsBlackSale = 2 AND m.CodeID3 = 19) OR (@IsBlackSale = 3 AND m.CodeID3 = 23))
        GROUP BY d.ProdID, rp.UM, mq.BarCode  
      ELSE
        DECLARE SRecA CURSOR LOCAL FOR
        SELECT ROW_NUMBER() OVER (ORDER BY d.ProdID) SrcPosID, d.ProdID, rp.UM, mq.BarCode, SUM(d.Qty) Qty
        FROM t_Sale m WITH(NOLOCK)
        JOIN t_SaleD d WITH(NOLOCK) ON d.ChID = m.ChID    
        JOIN r_Stocks rs WITH(NOLOCK) ON rs.StockID = m.StockID
        JOIN r_ProdMP mp WITH(NOLOCK) ON mp.ProdID = d.ProdID AND mp.PLID = d.PLID/*AND mp.PLID = rs.PLID*/
        JOIN ir_StockSubs rss WITH(NOLOCK) ON rss.DepID = mp.DepID AND rss.StockID = rs.StockID
        JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID AND rp.InRems = 1
        LEFT JOIN r_ProdMQ mq WITH(NOLOCK) ON mq.ProdID = rp.ProdID AND mq.UM = rp.UM
        WHERE EXISTS (SELECT * FROM #TSale WHERE ChID = m.ChID) AND rss.SubStockID = @SubStockID 
          AND ((@IsBlackSale = 0 AND m.CodeID3 not in (19,23,89)) OR (@IsBlackSale = 1 AND m.CodeID3 = 89)  OR (@IsBlackSale = 2 AND m.CodeID3 = 19) OR (@IsBlackSale = 3 AND m.CodeID3 = 23))
        GROUP BY d.ProdID, rp.UM, mq.BarCode  

      
        OPEN SRecA
        FETCH NEXT FROM SRecA INTO @SrcPosID, @ProdID, @UM, @BarCode, @Qty
        WHILE @@FETCH_STATUS = 0
        BEGIN
          /* Получение нового дополнительного кода регистрации для конкретного комплекта */
          SELECT @AChID = ISNULL(MAX(AChID),0) + 1 FROM t_SRecA WITH(NOLOCK)  WHERE AChID BETWEEN  @ChIDStart AND @ChIDEnd 
          
SELECT @AChID AChID     


          /* Импорт данных о проданных комплектах в "Комплектация товара: Комплекты" */
          INSERT t_SRecA
          (ChID, SrcPosID, ProdID, PPID, UM, Qty, SetCostCC, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt,
           Extra, PriceCC, NewPriceCC_nt, NewSumCC_nt, NewTax, NewTaxSum, NewPriceCC_wt, NewSumCC_wt, AChID, BarCode, SecID)
          VALUES
          (@ChID, @SrcPosID, @ProdID, 0, @UM, @Qty, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, @AChID, @BarCode, 1) 

SELECT  'INSERT t_SRecA'               
SELECT @ChID, @SrcPosID, @ProdID, 0, @UM, @Qty, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, @AChID, @BarCode, 1     
SELECT * FROM t_SRecA WHERE AChID = @AChID ORDER BY 1   

   
          SET @SubSrcPosID = 1             
       
          /* Курсор импорта данных в "Комплектация товара: Комплектующие" на основании составных товаров комплектов */
          DECLARE SRecD CURSOR FOR
          SELECT ss.ProdID SubProdID, rp.UM SubUM, mq.BarCode SubBarCode, ss.Qty SubQty
          FROM t_SRecA a WITH(NOLOCK)
          CROSS APPLY dbo.af_GetSpecSubs(@OurID, @StockID, @SubStockID, @EDate , @ProdID, @Qty) ss
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = ss.ProdID
          LEFT JOIN r_ProdMQ mq WITH(NOLOCK) ON mq.ProdID = rp.ProdID AND mq.UM = rp.UM
          WHERE a.AChID = @AChID
          ORDER BY a.SrcPosID, ss.ProdID

SELECT @OurID OurID, @StockID StockID, @SubStockID SubStockID, @EDate EDate, @ProdID ProdID, @Qty Qty
SELECT  '1 - DECLARE SRecD CURSOR FOR'   
SELECT ss.ProdID SubProdID, rp.UM SubUM, mq.BarCode SubBarCode, ss.Qty SubQty
FROM t_SRecA a WITH(NOLOCK)
OUTER  APPLY dbo.af_GetSpecSubs(@OurID, @StockID, @SubStockID, @EDate , @ProdID, @Qty) ss
JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = ss.ProdID
LEFT JOIN r_ProdMQ mq WITH(NOLOCK) ON mq.ProdID = rp.ProdID AND mq.UM = rp.UM
WHERE a.AChID = @AChID
ORDER BY a.SrcPosID, ss.ProdID
          
          OPEN SRecD
          FETCH NEXT FROM SRecD INTO @SubProdID, @SubUM, @SubBarCode, @SubQty
          WHILE @@FETCH_STATUS = 0
          BEGIN
		    /* Запрет производства товара из самого себя (происходит, когда товар ошибочно "завис" на складе комплектующих */
			IF EXISTS (SELECT * FROM r_Prods WITH(NOLOCK) WHERE ProdID = @ProdID AND PGrID2 = 40014)
			BEGIN
		      IF @ProdID = @SubProdID
			  BEGIN
			    RAISERROR ('ВНИМАНИЕ!!! Товар [%u] не может быть произведен! Возможно, существуют некорректные остатки готового алкоголя на складе комплектующих. Действие отменено. (PROCEDURE [dbo].[ap_CalcSRec_B_date_E_date])', 18, 1, @ProdID)
				ROLLBACK
				
				CLOSE SRecD
				DEALLOCATE SRecD

				CLOSE SRecA
				DEALLOCATE SRecA

				CLOSE SRec
				DEALLOCATE SRec

			    RETURN
			  END
            END 

            SET @SumQty = @SubQty
        
            /* Курсор выбора партий для списания комплектующих на основании остатков */
            DECLARE SRecDPPIDs CURSOR FOR
            SELECT rd.PPID SubPPID, rd.Qty SubQty, (tp.CostMC * @KursMC) SubPriceCC
            FROM #TRemD rd WITH(NOLOCK)
            JOIN t_PInP tp WITH(NOLOCK) ON tp.PPID = rd.PPID AND tp.ProdID = rd.ProdID
            WHERE rd.ProdID = @SubProdID AND rd.Qty > 0   
            ORDER BY rd.PPID 

SELECT  'DECLARE SRecDPPIDs CURSOR FOR'
SELECT rd.PPID SubPPID, rd.Qty SubQty, (tp.CostMC * @KursMC) SubPriceCC
FROM #TRemD rd WITH(NOLOCK)
JOIN t_PInP tp WITH(NOLOCK) ON tp.PPID = rd.PPID AND tp.ProdID = rd.ProdID
WHERE rd.ProdID = @SubProdID AND rd.Qty > 0   
ORDER BY rd.PPID 
                
            OPEN SRecDPPIDs
            FETCH NEXT FROM SRecDPPIDs INTO @SubPPID, @RemQty, @SubPriceCC
            WHILE (@@FETCH_STATUS = 0 AND @SumQty > 0)
            BEGIN
              IF @RemQty > @SumQty
                SELECT @RemQty = @SumQty
            
              SELECT @SubSrcPosID = ISNULL(MAX(SubSrcPosID),0) + 1 FROM t_SRecD WITH(NOLOCK) WHERE AChID = @AChID           
      
              /* Импорт комплектующих в "Комплектация товара: Комплектующие" */
              INSERT t_SRecD
              (AChID, SubSrcPosID, SubProdID, SubPPID, SubUM, SubQty, 
               SubPriceCC_nt, SubSumCC_nt,
               SubTax, SubTaxSum, SubPriceCC_wt, SubSumCC_wt, 
               SubNewPriceCC_nt, SubNewSumCC_nt, 
               SubNewTax, SubNewTaxSum,
               SubNewPriceCC_wt, SubNewSumCC_wt, SubSecID, SubBarCode)
              VALUES
              (@AChID, @SubSrcPosID, @SubProdID, @SubPPID, @SubUM, @RemQty, 
               dbo.zf_GetProdPrice_nt(@SubPriceCC, @SubProdID, @EDate ), dbo.zf_GetProdPrice_nt(@SubPriceCC, @SubProdID, @EDate ) * @RemQty, 
               dbo.zf_GetProdPrice_wtTax(@SubPriceCC, @SubProdID, @EDate ), dbo.zf_GetProdPrice_wtTax(@SubPriceCC, @SubProdID, @EDate ) * @RemQty, @SubPriceCC, @SubPriceCC * @RemQty,
               dbo.zf_GetProdPrice_nt(@SubPriceCC, @SubProdID, @EDate ), dbo.zf_GetProdPrice_nt(@SubPriceCC, @SubProdID, @EDate ) * @RemQty, 
		       dbo.zf_GetProdPrice_wtTax(@SubPriceCC, @SubProdID, @EDate ), dbo.zf_GetProdPrice_wtTax(@SubPriceCC, @SubProdID, @EDate ) * @RemQty, 
		       @SubPriceCC, (@SubPriceCC * @RemQty), 1, @SubBarCode)

SELECT  'INSERT t_SRecD' 		       
select @AChID, @SubSrcPosID, @SubProdID, @SubPPID, @SubUM, @RemQty, 
               dbo.zf_GetProdPrice_nt(@SubPriceCC, @SubProdID, @EDate ), dbo.zf_GetProdPrice_nt(@SubPriceCC, @SubProdID, @EDate ) * @RemQty, 
               dbo.zf_GetProdPrice_wtTax(@SubPriceCC, @SubProdID, @EDate ), dbo.zf_GetProdPrice_wtTax(@SubPriceCC, @SubProdID, @EDate ) * @RemQty, @SubPriceCC, @SubPriceCC * @RemQty,
               dbo.zf_GetProdPrice_nt(@SubPriceCC, @SubProdID, @EDate ), dbo.zf_GetProdPrice_nt(@SubPriceCC, @SubProdID, @EDate ) * @RemQty, 
		       dbo.zf_GetProdPrice_wtTax(@SubPriceCC, @SubProdID, @EDate ), dbo.zf_GetProdPrice_wtTax(@SubPriceCC, @SubProdID, @EDate ) * @RemQty, 
		       @SubPriceCC, (@SubPriceCC * @RemQty), 1, @SubBarCode 
		               
              UPDATE #TRemD
              SET Qty = (Qty - @RemQty)
              WHERE ProdID = @SubProdID AND PPID = @SubPPID     
          
              SET @SumQty = @SumQty - @RemQty
      
              FETCH NEXT FROM SRecDPPIDs INTO @SubPPID, @RemQty, @SubPriceCC
            END
            CLOSE SRecDPPIDs 
            DEALLOCATE SRecDPPIDs
        
            /* Блок импорта недостающего количества комплектующих в случае их недостаточного количества на остатках */

            /* Если остаточное количество не равно 0, то: */
            IF @SumQty != 0
            BEGIN
              /* Если фактическое количество = остаточному, то получаем максимальную партию по данной комплектующей 
                 из "Справочник товаров: Цены прихода Торговли" */
              IF @SumQty = @SubQty
                SELECT @SubPPID = ISNULL(MAX(PPID), 0) FROM #TRemD WHERE ProdID = @SubProdID
          
              /* в противном случае получаем максимальную партию по данной комплектующей из
                 "Комплектация товара: Комплектующие" */  
              ELSE
                SELECT @SubPPID = MAX(SubPPID), @SubQty = @SumQty FROM t_SRecD WITH(NOLOCK) WHERE AChID = @AChID AND SubProdID = @SubProdID
          
              /* Присвоение значений стоимости комплектующей */  
              SELECT @SubPriceCC = (CostMC * @KursMC) FROM t_PInP WITH(NOLOCK) WHERE ProdID = @SubProdID AND PPID = @SubPPID
              SELECT @SubSrcPosID = ISNULL(MAX(SubSrcPosID), 0) + 1 FROM t_SRecD WITH(NOLOCK) WHERE AChID = @AChID

              /* Импорт недостающих данных по комплектующим конкретного комплекта */
              INSERT t_SRecD
              (AChID, SubSrcPosID, SubProdID, SubPPID, SubUM, SubQty, 
               SubPriceCC_nt, SubSumCC_nt,
               SubTax, SubTaxSum, SubPriceCC_wt, SubSumCC_wt, 
               SubNewPriceCC_nt, SubNewSumCC_nt, 
               SubNewTax, SubNewTaxSum,
               SubNewPriceCC_wt, SubNewSumCC_wt, SubSecID, SubBarCode)
              VALUES
              (@AChID, @SubSrcPosID, @SubProdID, @SubPPID, @SubUM, @SubQty, 
               dbo.zf_GetProdPrice_nt(@SubPriceCC, @SubProdID, @EDate ), dbo.zf_GetProdPrice_nt(@SubPriceCC, @SubProdID, @EDate ) * @SubQty, 
               dbo.zf_GetProdPrice_wtTax(@SubPriceCC, @SubProdID, @EDate ), dbo.zf_GetProdPrice_wtTax(@SubPriceCC, @SubProdID, @EDate ) * @SubQty, @SubPriceCC, @SubPriceCC * @SubQty,
               dbo.zf_GetProdPrice_nt(@SubPriceCC, @SubProdID, @EDate ), dbo.zf_GetProdPrice_nt(@SubPriceCC, @SubProdID, @EDate ) * @SubQty, 
		       dbo.zf_GetProdPrice_wtTax(@SubPriceCC, @SubProdID, @EDate ), dbo.zf_GetProdPrice_wtTax(@SubPriceCC, @SubProdID, @EDate ) * @SubQty, 
		       @SubPriceCC, @SubPriceCC * @SubQty, 1, @SubBarCode)                       
          
              UPDATE #TRemD
              SET Qty -= @SubQty
              WHERE ProdID = @SubProdID AND PPID = @SubPPID          
            END        
        
            FETCH NEXT FROM SRecD INTO @SubProdID, @SubUM, @SubBarCode, @SubQty
          END
          CLOSE SRecD
          DEALLOCATE SRecD
      
          /* Блок расчёта суммарной стоимости конкретного комплекта на основании его комплектующих -------------------------------------------------*/
      
          /* Присвоение значения суммарной стоимости комплекта на основании его комплектующих */
          SELECT @PriceCC = ISNULL(dbo.zf_RoundPriceRec(SUM(SubSumCC_wt / @Qty)), 0) FROM t_SRecD WITH(NOLOCK) WHERE AChID = @AChID

          SELECT @PPID = dbo.tf_NewPPID(@ProdID)
        
          /* создаём новую партию на основании ранее полученного значения с параметрами суммарной стоимости комплекта */
	      EXEC t_SavePP 
	        1, 11321, @AChID, 0, @CurrID, @KursMC, 0, @PriceCC, @PriceCC, @PriceCC, 0, NULL, @ProdID, @PPID, @PPID, 
	        10794, @BDate , NULL, 0, NULL, 0, NULL, NULL   
  
          /* Обновление суммарной стоимости конкретного комплекта в "Комплектация товара: Комплекты" */
          UPDATE t_SRecA
          SET 
           PPID = @PPID, 
           PriceCC_nt = dbo.zf_GetProdPrice_nt(@PriceCC, ProdID, @EDate ), 
           SumCC_nt = dbo.zf_GetProdPrice_nt(@PriceCC, ProdID, @EDate ) * Qty,
           Tax = dbo.zf_GetProdPrice_wtTax(@PriceCC, ProdID, @EDate ), 
           TaxSum = dbo.zf_GetProdPrice_wtTax(@PriceCC, ProdID, @EDate ) * Qty, 
           PriceCC_wt = @PriceCC, 
           SumCC_wt = @PriceCC * Qty,
           NewPriceCC_nt = dbo.zf_GetProdPrice_nt(@PriceCC, ProdID, @EDate ), 
           NewSumCC_nt = dbo.zf_GetProdPrice_nt(@PriceCC, ProdID, @EDate ) * Qty,
           NewTax = dbo.zf_GetProdPrice_wtTax(@PriceCC, ProdID, @EDate ), 
           NewTaxSum = dbo.zf_GetProdPrice_wtTax(@PriceCC, ProdID, @EDate ) * Qty, 
           NewPriceCC_wt = @PriceCC, NewSumCC_wt = @PriceCC * Qty
          WHERE AChID = @AChID                                 
      
          FETCH NEXT FROM SRecA INTO @SrcPosID, @ProdID, @UM, @BarCode, @Qty
        END
        CLOSE SRecA
        DEALLOCATE SRecA
        
        FETCH NEXT FROM SRecBW INTO @IsBlackSale
      END
      CLOSE SRecBW
      DEALLOCATE SRecBW  
      
      FETCH NEXT FROM SRec INTO @SubStockID
    END
    CLOSE SRec
    DEALLOCATE SRec        
    
      /* Обновление статуса в "Продажа товара оператором" после его обработки */
      UPDATE m
      SET m.StateCode = 140
      FROM t_Sale m
      JOIN #TSale t ON t.ChID = m.ChID   
  
      /* Удаление временных таблиц */
      DROP TABLE #TSale
    END 
  
  IF @DocCode = 11012 /* Расходная накладная */
  BEGIN   
    /* Создание временной таблицы, в которой будут храниться все коды регистрации "Расходная накладная",
       которые нужно обработать */ 
        
    CREATE TABLE #TInv (ChID INT)

    /* Импорт данных о кодах регистрации во временную таблицу. Условие: Статус = 0, Фирма и Склад из параметров */
    INSERT #TInv
    SELECT ChID FROM t_Inv WITH(NOLOCK) WHERE DocDate = @EDate  AND OurID = @OurID AND StockID = @StockID AND StateCode = 0

    /* Создание индекса по полю "Код регистрации" для ускорения последующей выборки из таблицы */
    CREATE NONCLUSTERED INDEX ChID ON #TInv (ChID ASC)
    
    DECLARE SRec CURSOR FOR
    SELECT DISTINCT rss.SubStockID
    FROM t_Inv m WITH(NOLOCK)
    JOIN t_InvD d WITH(NOLOCK) ON d.ChID = m.ChID
    JOIN r_Stocks rs WITH(NOLOCK) ON rs.StockID = m.StockID
    JOIN r_ProdMP mp WITH(NOLOCK) ON mp.ProdID = d.ProdID AND mp.PLID = rs.PLID
    JOIN ir_StockSubs rss WITH(NOLOCK) ON rss.DepID = mp.DepID AND rss.StockID = rs.StockID
    WHERE m.ChID IN (SELECT ChID FROM #TInv)
    ORDER BY rss.SubStockID

    OPEN SRec
    FETCH NEXT FROM SRec INTO @SubStockID
    WHILE @@FETCH_STATUS = 0
    BEGIN    
      /* Подготовка остатков на дату */  
      INSERT #TRemD
      (ProdID, PPID, Qty)
      SELECT ProdID, PPID, SUM(Qty - AccQty) Qty
      FROM dbo.af_CalcRemD_F(@EDate ,@OurID,@SubStockID,1,NULL)
      GROUP BY ProdID, PPID
      HAVING ISNULL(SUM(Qty - AccQty),0) >= 0
    
      /* Получение новых кода регистрации и номера для последующего импорта "Комплектация товара: Заголовок" */
      EXEC dbo.z_NewChID 't_SRec', @ChID OUTPUT
      EXEC dbo.z_NewDocID 11321, 't_SRec', @OurID, @DocID OUTPUT 

      /* Импорт в "Комплектация товара: Заголовок" */
      INSERT t_SRec
      (ChID, DocID, IntDocID, DocDate, KursMC, OurID, StockID, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, EmpID, SubDocDate, SubStockID, CurrID)
      VALUES
      (@ChID, @DocID, @DocID, @EDate , @KursMC, @OurID, @StockID, 100, 99, 5, 0, 0, 0, @EDate , @SubStockID, @CurrID)
      /*IF @@ERROR > 0 GOTO ERR1*/
    
      /* Курсор импорта проданных в "Расходная накладная" комплектов в "Комплектация товара: Комплекты" */
      DECLARE SRecA CURSOR FOR
      SELECT ROW_NUMBER() OVER (ORDER BY d.ProdID) SrcPosID, d.ProdID, rp.UM, mq.BarCode, SUM(d.Qty) Qty
      FROM t_Inv m WITH(NOLOCK)
      JOIN t_InvD d WITH(NOLOCK) ON d.ChID = m.ChID    
      JOIN r_Stocks rs WITH(NOLOCK) ON rs.StockID = m.StockID
      JOIN r_ProdMP mp WITH(NOLOCK) ON mp.ProdID = d.ProdID AND mp.PLID = rs.PLID
      JOIN ir_StockSubs rss WITH(NOLOCK) ON rss.DepID = mp.DepID AND rss.StockID = rs.StockID
      JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID AND rp.InRems = 1
      LEFT JOIN r_ProdMQ mq WITH(NOLOCK) ON mq.ProdID = rp.ProdID AND mq.UM = rp.UM
      WHERE m.ChID IN (SELECT ChID FROM #TInv) AND m.DocDate = @EDate  AND rss.SubStockID = @SubStockID
      GROUP BY d.ProdID, rp.UM, mq.BarCode  
      
      OPEN SRecA
      FETCH NEXT FROM SRecA INTO @SrcPosID, @ProdID, @UM, @BarCode, @Qty
      WHILE @@FETCH_STATUS = 0
      BEGIN
        /* Получение нового дополнительного кода регистрации для конкретного комплекта */
        SELECT @AChID = ISNULL(MAX(AChID),0) + 1 FROM t_SRecA WITH(NOLOCK)  
      
        /* Импорт данных о проданных комплектах в "Комплектация товара: Комплекты" */
        INSERT t_SRecA
        (ChID, SrcPosID, ProdID, PPID, UM, Qty, SetCostCC, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt,
         Extra, PriceCC, NewPriceCC_nt, NewSumCC_nt, NewTax, NewTaxSum, NewPriceCC_wt, NewSumCC_wt, AChID, BarCode, SecID)
        VALUES
        (@ChID, @SrcPosID, @ProdID, 0, @UM, @Qty, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, @AChID, @BarCode, 1)      
      
        SET @SubSrcPosID = 1             
      
        /* Курсор импорта данных в "Комплектация товара: Комплектующие" на основании составных товаров комплектов */
        DECLARE SRecD CURSOR FOR
        SELECT ss.ProdID SubProdID, rp.UM SubUM, mq.BarCode SubBarCode, ss.Qty SubQty
        FROM t_SRecA a WITH(NOLOCK)
        CROSS APPLY dbo.af_GetSpecSubs(@OurID, @StockID, @SubStockID, @EDate , @ProdID, @Qty) ss
        JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = ss.ProdID
        LEFT JOIN r_ProdMQ mq WITH(NOLOCK) ON mq.ProdID = rp.ProdID AND mq.UM = rp.UM
        WHERE a.AChID = @AChID
        ORDER BY a.SrcPosID, ss.ProdID

SELECT  '2 - DECLARE SRecD CURSOR FOR'
SELECT ss.ProdID SubProdID, rp.UM SubUM, mq.BarCode SubBarCode, ss.Qty SubQty
FROM t_SRecA a WITH(NOLOCK)
CROSS APPLY dbo.af_GetSpecSubs(@OurID, @StockID, @SubStockID, @EDate , @ProdID, @Qty) ss
JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = ss.ProdID
LEFT JOIN r_ProdMQ mq WITH(NOLOCK) ON mq.ProdID = rp.ProdID AND mq.UM = rp.UM
WHERE a.AChID = @AChID
ORDER BY a.SrcPosID, ss.ProdID
        
        OPEN SRecD
        FETCH NEXT FROM SRecD INTO @SubProdID, @SubUM, @SubBarCode, @SubQty
        WHILE @@FETCH_STATUS = 0
        BEGIN
          SET @SumQty = @SubQty
        
          /* Курсор выбора партий для списания комплектующих на основании остатков */
          DECLARE SRecDPPIDs CURSOR FOR
          SELECT rd.PPID SubPPID, rd.Qty SubQty, (tp.CostMC * @KursMC) SubPriceCC
          FROM #TRemD rd WITH(NOLOCK)
          JOIN t_PInP tp WITH(NOLOCK) ON tp.PPID = rd.PPID AND tp.ProdID = rd.ProdID
          WHERE rd.ProdID = @SubProdID AND rd.Qty > 0   
          ORDER BY rd.PPID 
    
          OPEN SRecDPPIDs
          FETCH NEXT FROM SRecDPPIDs INTO @SubPPID, @RemQty, @SubPriceCC
          WHILE (@@FETCH_STATUS = 0 AND @SumQty > 0)
          BEGIN
            IF @RemQty > @SumQty
              SELECT @RemQty = @SumQty
            
            SELECT @SubSrcPosID = ISNULL(MAX(SubSrcPosID),0) + 1 FROM t_SRecD WITH(NOLOCK) WHERE AChID = @AChID           
      
            /* Импорт комплектующих в "Комплектация товара: Комплектующие" */
            INSERT t_SRecD
            (AChID, SubSrcPosID, SubProdID, SubPPID, SubUM, SubQty, 
             SubPriceCC_nt, SubSumCC_nt,
             SubTax, SubTaxSum, SubPriceCC_wt, SubSumCC_wt, 
             SubNewPriceCC_nt, SubNewSumCC_nt, 
             SubNewTax, SubNewTaxSum,
             SubNewPriceCC_wt, SubNewSumCC_wt, SubSecID, SubBarCode)
            VALUES
            (@AChID, @SubSrcPosID, @SubProdID, @SubPPID, @SubUM, @RemQty, 
             dbo.zf_GetProdPrice_nt(@SubPriceCC, @SubProdID, @EDate ), dbo.zf_GetProdPrice_nt(@SubPriceCC, @SubProdID, @EDate ) * @RemQty, 
             dbo.zf_GetProdPrice_wtTax(@SubPriceCC, @SubProdID, @EDate ), dbo.zf_GetProdPrice_wtTax(@SubPriceCC, @SubProdID, @EDate ) * @RemQty, @SubPriceCC, @SubPriceCC * @RemQty,
             dbo.zf_GetProdPrice_nt(@SubPriceCC, @SubProdID, @EDate ), dbo.zf_GetProdPrice_nt(@SubPriceCC, @SubProdID, @EDate ) * @RemQty, 
		     dbo.zf_GetProdPrice_wtTax(@SubPriceCC, @SubProdID, @EDate ), dbo.zf_GetProdPrice_wtTax(@SubPriceCC, @SubProdID, @EDate ) * @RemQty, 
		     @SubPriceCC, (@SubPriceCC * @RemQty), 1, @SubBarCode)
          
            UPDATE #TRemD
            SET Qty = (Qty - @RemQty)
            WHERE ProdID = @SubProdID AND PPID = @SubPPID     
          
            SET @SumQty -= @RemQty
      
            FETCH NEXT FROM SRecDPPIDs INTO @SubPPID, @RemQty, @SubPriceCC
          END
          CLOSE SRecDPPIDs 
          DEALLOCATE SRecDPPIDs
        
          /* Блок импорта недостающего количества комплектующих в случае их недостаточного количества на остатках */

          /* Если остаточное количество не равно 0, то: */
          IF @SumQty != 0
          BEGIN
            /* Если фактическое количество = остаточному, то получаем максимальную партию по данной комплектующей 
               из "Справочник товаров: Цены прихода Торговли" */
            IF @SumQty = @SubQty
              SELECT @SubPPID = ISNULL(MAX(PPID), 0) FROM #TRemD WHERE ProdID = @SubProdID
          
            /* в противном случае получаем максимальную партию по данной комплектующей из
               "Комплектация товара: Комплектующие" */  
            ELSE
              SELECT @SubPPID = MAX(SubPPID), @SubQty = @SumQty FROM t_SRecD WITH(NOLOCK) WHERE AChID = @AChID AND SubProdID = @SubProdID
          
            /* Присвоение значений стоимости комплектующей */  
            SELECT @SubPriceCC = (CostMC * @KursMC) FROM t_PInP WITH(NOLOCK) WHERE ProdID = @SubProdID AND PPID = @SubPPID
            SELECT @SubSrcPosID = ISNULL(MAX(SubSrcPosID), 0) + 1 FROM t_SRecD WITH(NOLOCK) WHERE AChID = @AChID

            /* Импорт недостающих данных по комплектующим конкретного комплекта */
            INSERT t_SRecD
            (AChID, SubSrcPosID, SubProdID, SubPPID, SubUM, SubQty, 
             SubPriceCC_nt, SubSumCC_nt,
             SubTax, SubTaxSum, SubPriceCC_wt, SubSumCC_wt, 
             SubNewPriceCC_nt, SubNewSumCC_nt, SubNewTax, SubNewTaxSum,
             SubNewPriceCC_wt, SubNewSumCC_wt, SubSecID, SubBarCode)
            VALUES
            (@AChID, @SubSrcPosID, @SubProdID, @SubPPID, @SubUM, @SubQty, 
             dbo.zf_GetProdPrice_nt(@SubPriceCC, @SubProdID, @EDate ), dbo.zf_GetProdPrice_nt(@SubPriceCC, @SubProdID, @EDate ) * @SubQty, 
             dbo.zf_GetProdPrice_wtTax(@SubPriceCC, @SubProdID, @EDate ), dbo.zf_GetProdPrice_wtTax(@SubPriceCC, @SubProdID, @EDate ) * @SubQty, @SubPriceCC, @SubPriceCC * @SubQty,
             dbo.zf_GetProdPrice_nt(@SubPriceCC, @SubProdID, @EDate ), dbo.zf_GetProdPrice_nt(@SubPriceCC, @SubProdID, @EDate ) * @SubQty, 
		     dbo.zf_GetProdPrice_wtTax(@SubPriceCC, @SubProdID, @EDate ), dbo.zf_GetProdPrice_wtTax(@SubPriceCC, @SubProdID, @EDate ) * @SubQty, 
		     @SubPriceCC, @SubPriceCC * @SubQty, 1, @SubBarCode)              
          
            UPDATE #TRemD
            SET Qty -= @SubQty
            WHERE ProdID = @SubProdID AND PPID = @SubPPID              
          END        
      
          FETCH NEXT FROM SRecD INTO @SubProdID, @SubUM, @SubBarCode, @SubQty
        END
        CLOSE SRecD
        DEALLOCATE SRecD
      
        /* Блок расчёта суммарной стоимости конкретного комплекта на основании его комплектующих -------------------------------------------------*/
      
        /* Присвоение значения суммарной стоимости комплекта на основании его комплектующих */
        SELECT @PriceCC = ISNULL(dbo.zf_RoundPriceRec(SUM(SubSumCC_wt / @Qty)), 0) FROM t_SRecD WITH(NOLOCK) WHERE AChID = @AChID

        SELECT @PPID = dbo.tf_NewPPID(@ProdID)
        
        /* создаём новую партию на основании ранее полученного значения с параметрами суммарной стоимости комплекта */
	    EXEC t_SavePP 
	      1, 11321, @AChID, 0, @CurrID, @KursMC, 0, @PriceCC, @PriceCC, @PriceCC, 0, NULL, @ProdID, @PPID, @PPID, 
	      10794, @EDate , NULL, 0, NULL, 0, NULL, NULL   
      
        /* Обновление суммарной стоимости конкретного комплекта в "Комплектация товара: Комплекты" */
        UPDATE t_SRecA
        SET 
         PPID = @PPID, PriceCC_nt = dbo.zf_GetProdPrice_nt(@PriceCC, ProdID, @EDate ), SumCC_nt = dbo.zf_GetProdPrice_nt(@PriceCC, ProdID, @EDate ) * Qty,
         Tax = dbo.zf_GetProdPrice_wtTax(@PriceCC, ProdID, @EDate ), TaxSum = dbo.zf_GetProdPrice_wtTax(@PriceCC, ProdID, @EDate ) * Qty,
         PriceCC_wt = @PriceCC, SumCC_wt = @PriceCC * Qty,
         NewPriceCC_nt = dbo.zf_GetProdPrice_nt(@PriceCC, ProdID, @EDate ), NewSumCC_nt = dbo.zf_GetProdPrice_nt(@PriceCC, ProdID, @EDate ) * Qty,
         NewTax = dbo.zf_GetProdPrice_wtTax(@PriceCC, ProdID, @EDate ), NewTaxSum = dbo.zf_GetProdPrice_wtTax(@PriceCC, ProdID, @EDate ) * Qty,
         NewPriceCC_wt = @PriceCC, NewSumCC_wt = @PriceCC * Qty
        WHERE AChID = @AChID                                 
      
        FETCH NEXT FROM SRecA INTO @SrcPosID, @ProdID, @UM, @BarCode, @Qty
     END
      CLOSE SRecA
      DEALLOCATE SRecA
      
      FETCH NEXT FROM SRec INTO @SubStockID
    END
    CLOSE SRec
    DEALLOCATE SRec         
    
    /* Обновление статуса в "Расходная накладная" после его обработки */
    UPDATE m
    SET m.StateCode = 140
    FROM t_Inv m
    JOIN #TInv t ON t.ChID = m.ChID

    /* Удаление временных таблиц */
    DROP TABLE #TInv
  END
  
  DROP TABLE #TRemD
  
 --EXEC [dbo].[ap_ReWriteOffNegRems] @EDate , @OurID, @StockID, @DocCode  
  
  
  
 /* EXEC  dbo.ap_ReWriteOffNegRems_D_D @BDate ,@EDate , @OurID , @StockID , 11035*/
  
  --/* Проверка правильности выполнения процедуры, если без ошибок - закрепляем транзакцию */
  --IF @@TRANCOUNT > 0
  --  COMMIT


SELECT * FROM t_SRec where chid = @ChID 

SELECT * FROM t_SRecA where prodid = 605833

SELECT * FROM t_SRecD where AChID in (@AChID)
--SELECT * FROM t_SRecD where AChID in (SELECT AChID FROM t_SRecA where chid = @ChID) ORDER BY AChID

ROLLBACK TRAN



--        SELECT ROW_NUMBER() OVER (ORDER BY d.ProdID) SrcPosID, d.ProdID, rp.UM, mq.BarCode, SUM(d.Qty) Qty
--        FROM t_Sale m WITH(NOLOCK)
--        JOIN t_SaleD d WITH(NOLOCK) ON d.ChID = m.ChID    
--        JOIN r_Stocks rs WITH(NOLOCK) ON rs.StockID = m.StockID
--        JOIN r_ProdMP mp WITH(NOLOCK) ON mp.ProdID = d.ProdID AND mp.PLID = d.PLID/*AND mp.PLID = rs.PLID*/
--        JOIN ir_StockSubs rss WITH(NOLOCK) ON rss.DepID = mp.DepID AND rss.StockID = rs.StockID
--        JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID AND rp.InRems = 1
--        LEFT JOIN r_ProdMQ mq WITH(NOLOCK) ON mq.ProdID = rp.ProdID AND mq.UM = rp.UM
--        WHERE EXISTS (SELECT * FROM #TSale WHERE ChID = m.ChID) AND rss.SubStockID = 1207 
--          AND ((0 = 0 AND m.CodeID3 not in (19,23,89)) OR (0 = 1 AND m.CodeID3 = 89)  OR (0 = 2 AND m.CodeID3 = 19) OR (0 = 3 AND m.CodeID3 = 23))
--        GROUP BY d.ProdID, rp.UM, mq.BarCode  


--          SELECT ss.ProdID SubProdID, rp.UM SubUM, mq.BarCode SubBarCode, ss.Qty SubQty
--          FROM t_SRecA a WITH(NOLOCK)
--          CROSS APPLY dbo.af_GetSpecSubs(12, 1314, 1207, '2017-11-10' , 605833, 2) ss
--          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = ss.ProdID
--          LEFT JOIN r_ProdMQ mq WITH(NOLOCK) ON mq.ProdID = rp.ProdID AND mq.UM = rp.UM
--          WHERE a.AChID = 132123
--          ORDER BY a.SrcPosID, ss.ProdID
          
--          SELECT * FROM dbo.af_GetSpecSubs(12, 1314, 1207, '2017-11-10' , 605833, 2)
          
          
--          SELECT * FROM dbo.af_CalcRemD_F('2017-11-10',12,1207,1,610932) 
          
          
--SELECT ProdID, 2 * SUM(Qty) Qty, UseSubItems
--FROM it_SpecD d WITH(NOLOCK)
--WHERE ChID = 13558
--GROUP BY ProdID, UseSubItems           