--ap_VC_ExportProds
--ap_VC_ExportProds_O

----ap_VC_ImportOrders
----ap_VC_ImportOrders_O

--select * from t_SaleTempD where ProdID = 600915

--select * from test_TOrders_X

--select * from test_TOrdersD_X

--select * from t_sale where DocID = 115459
--select ChildChID, * from z_DocLinks 

--SELECT MAX(SrcPosID) + 1 FROM dbo.t_SaleTempD WHERE ChID = 1
--SELECT  * FROM t_SaleTempD


--Выполняется от имени пользователя: 
--CONST\Cluster.Cannot insert the value NULL into column 'SrcPosID', table 'ElitV_KIEV.dbo.t_SaleTempD'; 
--column does not allow nulls. INSERT fails. [SQLSTATE 23000] (Ошибка 515).  Шаг завершился с ошибкой.
      
--      OPEN OrderW
--      FETCH NEXT FROM OrderW INTO @OrdID, @ExpDate, @InvStockID, @RecStockID, @RangeID, @DCardID

--      SELECT DISTINCT
--        m.DocID, m.ExpDate, dbo.af_VC_GetDocStockID('Опт',m.RegionID,11012) InvStockID, dbo.af_VC_GetDocStockID('Опт',m.RegionID,11002) RecStockID,
--        (CASE WHEN rp.PGrID4 IN (2,3,4) THEN 1 WHEN rp.PGrID4 = 0 THEN 2 END) RangeID, DCardID
--      FROM test_TOrders_X m
--      JOIN test_TOrdersD_X d ON d.DocID = m.DocID
--      JOIN dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
--      WHERE d.RemSchID = 1
--      ORDER BY m.DocID, RangeID
      
--IF NOT EXISTS (SELECT * FROM dbo.at_t_IORes WITH(NOLOCK) WHERE DocID = 115459 AND OurID = 9 AND RemSchID = 1)
--print 'ok'

--          /* ОПТ - Импорт заголовков документов РН и ПТ согласно принадлежности товара фирмам */
--          DECLARE OrderW_1 CURSOR FOR
--          /* ОПТ - Определение принадлежности товара фирмам: Арда-Трейдинг, МаркетА */
--          SELECT DISTINCT CASE p.PGrID4 WHEN 3 THEN 2 ELSE p.PGrID4 END PGrID4
--          FROM test_TOrdersD_X d
--          JOIN dbo.r_Prods p WITH(NOLOCK) ON p.ProdID = d.ProdID
--          WHERE RemSchID = 1 AND DocID = 115459 AND p.PGrID4 IN (2,3,4)
--          ORDER BY PGrID4
--          PGrID4=2
          
--          select * from t_Inv where DocID = 115459
          
--    /* ОПТ - Подготовка товаров в детали документов РН, ПТ, ЗВР для документов согласно фирм */
--   --DECLARE OrderWD_1 CURSOR FOR
   
--   DECLARE
--   @OrdID INT = 115459, 
--   @PGrID4 INT = 2, 
--   @VC_OurID INT = 9,
--   @ElitPLID INT = 66,
--   @RegionID INT = 2,
--   @OurID INT = 1 
 
--    SELECT
--     d.ProdID, d.Qty, d.Qty OrdQty, rp.UM, mq.BarCode, 
--     d.PurPrice PurPrice, dbo.af_VC_GetPriceCC(@RegionID,d.ProdID,d.Discount) OrdPrice,
--     (CASE WHEN dbo.af_VC_GetOrderPLID(m.RegionID,d.ProdID) IN (31,34,38,39,43,45) THEN 0 
--           ELSE d.Discount END) Discount,
--     COALESCE((SELECT PriceMC FROM dbo.r_ProdMP WITH(NOLOCK) WHERE ProdID = d.ProdID AND PLID = 32), 0) VIPPriceCC,
--     COALESCE((SELECT PriceMC FROM dbo.r_ProdMP WITH(NOLOCK) WHERE ProdID = d.ProdID AND PLID = 25), 0) VIP2PriceCC,         
--     (CASE d.IsVIP WHEN 0 THEN dbo.af_VC_GetPLID(m.RegionID) WHEN 1 THEN 32 WHEN 2 THEN 25 END) PLID ,rp.TaxTypeID
--    FROM test_TOrdersD_X d
--    JOIN test_TOrders_X m ON m.DocID = d.DocID
--    JOIN dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID 
--    JOIN dbo.r_ProdMQ mq WITH(NOLOCK) ON mq.ProdID = d.ProdID AND mq.UM = rp.UM
--    JOIN dbo.r_ProdEC ec WITH(NOLOCK) ON ec.ProdID = rp.ProdID 
--                                 AND ((rp.PGrID4 = 2 AND ec.CompID IN (71,80,81))
--                                      OR (rp.PGrID4 = 3 AND ec.CompID = 72)
--                                      OR (rp.PGrID4 = 4 AND ec.CompID = 82))               
--    WHERE d.RemSchID = 1 AND d.DocID = @OrdID AND CASE rp.PGrID4 WHEN 3 THEN 2 ELSE rp.PGrID4 END = @PGrID4
--      AND EXISTS (SELECT * FROM [S-SQL-D4].Elit.dbo.r_ProdMP WITH(NOLOCK) WHERE PLID = @ElitPLID AND ProdID = ec.ExtProdID AND PriceMC > 0)
--    GROUP BY d.ProdID, d.Qty, rp.UM, mq.BarCode, d.PurPrice, d.Discount, m.RegionID, d.IsVIP, d.PosID ,rp.TaxTypeID           
--    ORDER BY d.PosID
----ProdID	Qty	OrdQty	UM	BarCode	PurPrice	OrdPrice	Discount	VIPPriceCC	VIP2PriceCC	PLID	TaxTypeID
----600915	1	1	пляш	3249992012319	356.700000000	172.20	51.724137931	96.200000000	101.200000000	48	0
   
   DECLARE
   @OrdID INT = 115459, 
   @PGrID4 INT = 2, 
   @VC_OurID INT = 9,
   @ElitPLID INT = 66,
   @RegionID INT = 2,
   @OurID INT = 1, 
   @CurrID INT = 980, 
   @KursMC NUMERIC(21,9) = 27.000000000,
   @t_PP TINYINT = 8,
   @ProdID int = 600915,
   @InvStockID SMALLINT = 220,
   @ExtProdID  INT = 26889
   
  SELECT @CurrID = dbo.zf_GetCurrCC()
print  @CurrID
  SELECT @KursMC = dbo.zf_GetRateMC(@CurrID), @t_PP = dbo.zf_Var('t_PP')
print  @t_PP
print  @KursMC

SELECT CAST(ec.ExtProdID AS INT) ExtProdID, (mp.PriceMC * @KursMC) Price,*
FROM dbo.r_ProdEC ec WITH(NOLOCK)
JOIN [S-SQL-D4].Elit.dbo.r_ProdMP mp WITH(NOLOCK) ON mp.PLID = @ElitPLID AND mp.ProdID = ec.ExtProdID AND mp.PriceMC > 0
WHERE ec.ProdID in (@ProdID) 
AND ((@PGrID4 = 2 AND ec.CompID IN (71,80,81,72))
                            OR (@PGrID4 = 4 AND ec.CompID = 82)) 
ORDER BY mp.PriceMC

--SELECT @SumQty = @TQty

/* ОПТ - Импорт товарной части документов РН, ПТ, ЗВР согласно фирм */
--DECLARE OrderWD_1_PPs CURSOR FOR
SELECT r.PPID, (r.Qty - r.AccQty) RemQty
FROM [S-SQL-D4].Elit.dbo.t_Rem r WITH(NOLOCK)
JOIN [S-SQL-D4].Elit.dbo.t_PInP tp WITH(NOLOCK) ON tp.ProdID = r.ProdID AND tp.PPID = r.PPID
WHERE OurID = @OurID AND r.StockID = @InvStockID AND r.SecID = 1 AND r.ProdID = @ExtProdID AND (r.Qty - r.AccQty) > 0          
ORDER BY COALESCE(tp.DLSDate,'20790606') ASC, COALESCE(tp.ProdPPDate,'20790606') ASC, tp.PPID ASC

--use ElitV_KIEV
--DECLARE
--    @ChID INT, 
--   @RecChID INT, 
--   @InvChID INT, 
--   @ExcChID INT, 
--   @SaleChID INT, 
--   @DocID INT, 
--   @ExpDate SMALLDATETIME, 
--   @RangeID TINYINT,
--   @SrcPosID INT, 
--   @InvStockID SMALLINT = 220, 
--   @RecStockID SMALLINT,
--   @SrcDocID VARCHAR(6), 
--   @Qty INT = 1, 
--   @OrdQty INT, 
--   @SumQty INT, 
--   @UM VARCHAR(10), 
--   @BarCode VARCHAR(42), 
--   @ElitBarCode VARCHAR(42),
--   @Price NUMERIC(21,9) = 140.1000000030000, 
--   @OrdPrice NUMERIC(21,2), 
--   @PurPrice NUMERIC(21,2), 
--   @Disc NUMERIC(21,9), 
--   @PLID TINYINT, 
--   @PPID INT, 
--   @RecPPID INT,
--   @ProdPPDate SMALLDATETIME, 
--   @DLSDate SMALLDATETIME, 
--   @InvSrcPosID INT, 
--   @RecSrcPosID INT, 
--   @ExcSrcPosID INT, 
--   @SaleSrcPosID INT, 
--   @ExtProdID INT = 26889,
--   @VIPPrice NUMERIC(21,9), 
--   @VIP2Price NUMERIC(21,9),
--   @CompID INT, 
--   @TQty NUMERIC(21,9), 
--   @RemSchID VARCHAR(10), 
--   @DCardID VARCHAR(250), 
--   @LogID INT, 
--   @DiscCode INT, 
--   @StorageID INT,
--   @DBiID INT = dbo.zf_Var('OT_DBiID'),  
--   @TaxTypeID INT,

--   @OrdID INT = 115459, 
--   @PGrID4 INT = 2, 
--   @VC_OurID INT = 9,
--   @ElitPLID INT = 66,
--   @RegionID INT = 2,
--   @OurID INT = 1, 
--   @CurrID INT = 980, 
--   @KursMC NUMERIC(21,9) = 27.000000000,
--   @t_PP TINYINT = 8,
--   @ProdID int = 600915  
              
--              SET @TQty = @Qty             
--print @TQty
--              --OPEN ProdEC
--              --FETCH NEXT FROM ProdEC INTO @ExtProdID, @Price
--              --WHILE (@@FETCH_STATUS = 0 AND @TQty > 0)
--              --BEGIN
--               SELECT @SumQty = @TQty
--print @SumQty
--                /* ОПТ - Импорт товарной части документов РН, ПТ, ЗВР согласно фирм */
--                --DECLARE OrderWD_1_PPs CURSOR FOR
--                SELECT r.PPID, (r.Qty - r.AccQty) RemQty,*
--                FROM [S-SQL-D4].Elit.dbo.t_Rem r WITH(NOLOCK)
--                JOIN [S-SQL-D4].Elit.dbo.t_PInP tp WITH(NOLOCK) ON tp.ProdID = r.ProdID AND tp.PPID = r.PPID
--                WHERE OurID = @OurID 
--                AND r.StockID = @InvStockID 
--                AND r.SecID = 1 
--                AND r.ProdID = @ExtProdID 
--                --AND (r.Qty - r.AccQty) > 0          
--                --ORDER BY COALESCE(tp.DLSDate,'20790606') ASC, COALESCE(tp.ProdPPDate,'20790606') ASC, tp.PPID ASC

--select * FROM [S-SQL-D4].Elit.dbo.t_Rem  WHERE ProdID = 26889

--  /* Подготовка остатков по ассортименту опта - (Арда-Трейдинг, Аквавит) */
--  SELECT p.ProdID, CASE WHEN SUM(r.Qty - r.AccQty) > 500 THEN 500 ELSE SUM(r.Qty - r.AccQty) END Qty
--  FROM r_Prods p WITH(NOLOCK) 
--  JOIN r_ProdEC ec WITH(NOLOCK) ON ec.ProdID = p.ProdID 
--                               AND ((p.PGrID4 IN (2,8)AND ec.CompID IN (71,81))
--                                    OR (p.PGrID4 = 3 AND ec.CompID = 72)
--                                    OR (p.PGrID4 = 4 AND ec.CompID = 82))  
--  JOIN [S-SQL-D4].Elit.dbo.t_Rem r WITH(NOLOCK) ON r.ProdID = ec.ExtProdID AND r.OurID = CASE WHEN p.PGrID4 IN (2,3,8) THEN 1 WHEN p.PGrID4 = 4 THEN 11 END 
--  AND r.StockID = CASE WHEN p.PGrID4 IN (2) THEN 220 WHEN p.PGrID4 = 8 THEN 1130 END
--   AND GETDATE() NOT BETWEEN '20150313 13:20:00' AND '20150313 16:00:00' /*остатки не будут выгружаться на момент переоценки в базе Elit      */
-- --  AND GETDATE() NOT BETWEEN '20160105 12:00:00' AND '20160108 12:00:00' /*остатки не будут выгружаться на момент переоценки в базе Elit      */
--  WHERE p.PGrID4 IN (2,3,4,8) AND (p.PGrID1 NOT BETWEEN 600 AND 710 OR p.PGrID1 = 709) AND ISNUMERIC(ExtProdID) = 1
--  and p.ProdID = 600915
--  GROUP BY p.ProdID 
--  HAVING SUM(r.Qty - r.AccQty) > 0 