IF OBJECT_ID (N'tempdb..#ArrBarCode', N'U') IS NOT NULL DROP TABLE #ArrBarCode

CREATE TABLE #ArrBarCode(id int IDENTITY(1,1),Barcode varchar(40) null, Qty numeric(21,9) null)

INSERT #ArrBarCode(Barcode , Qty) VALUES ('600001',2)
INSERT #ArrBarCode(Barcode , Qty) VALUES ('500001',2)
INSERT #ArrBarCode(Barcode , Qty) VALUES ('6001108049681',48)
INSERT #ArrBarCode(Barcode , Qty) VALUES ('6001108049681',102)
INSERT #ArrBarCode(Barcode , Qty) VALUES ('8710625632709',7.8)
INSERT #ArrBarCode(Barcode , Qty) VALUES ('600123',1)
INSERT #ArrBarCode(Barcode , Qty) VALUES ('9418076000656',1)
INSERT #ArrBarCode(Barcode , Qty) VALUES ('080432400432',1)

SELECT * FROM #ArrBarCode


IF OBJECT_ID (N'tempdb..#ArrBarCodeGroup', N'U') IS NOT NULL DROP TABLE #ArrBarCodeGroup
--SELECT ROW_NUMBER()OVER(ORDER BY Barcode) id, Barcode, Sum(Qty) TQty  into #ArrBarCodeGroup FROM #ArrBarCode GROUP BY Barcode


SELECT ROW_NUMBER()OVER(ORDER BY Barcode) id, * 
INTO #ArrBarCodeGroup 
FROM (
SELECT Barcode, Sum(Qty) TQty
,(SELECT top 1 ProdID FROM r_ProdMQ mq where mq.BarCode = abc.Barcode) ProdID  
,(SELECT top 1 UM FROM r_ProdMQ mq where mq.BarCode = abc.Barcode) UM  
,(SELECT top 1 ProdName FROM r_Prods p where p.ProdID = (SELECT top 1 ProdID FROM r_ProdMQ mq where mq.BarCode = abc.Barcode) ) ProdName  
FROM #ArrBarCode abc GROUP BY Barcode
) gr

SELECT * FROM #ArrBarCodeGroup

SELECT id, Barcode, TQty, 
Barcode ProdID, 
(SELECT top 1 UM FROM r_Prods p WHERE p.ProdID = CAST(Barcode AS INT)) UM, 
(SELECT top 1 ProdName FROM r_Prods p WHERE p.ProdID = CAST(Barcode AS INT)) ProdName 
FROM #ArrBarCodeGroup WHERE LEN(Barcode) = 6 AND EXISTS(SELECT top 1 1 FROM r_Prods p WHERE p.ProdID = CAST(Barcode AS INT)) 

BEGIN TRAN


UPDATE up 
SET ProdID = CAST(up.Barcode AS INT), 
UM = (SELECT top 1 UM FROM r_Prods p WHERE p.ProdID = CAST(up.Barcode AS INT)) , 
ProdName = (SELECT top 1 ProdName FROM r_Prods p WHERE p.ProdID = CAST(up.Barcode AS INT))  
FROM #ArrBarCodeGroup up WHERE LEN(Barcode) = 6 AND EXISTS(SELECT top 1 1 FROM r_Prods p WHERE p.ProdID = CAST(Barcode AS INT)) 

UPDATE up 
SET Barcode = (SELECT top 1 mq.Barcode FROM r_ProdMQ mq WHERE mq.UM = up.UM and mq.ProdID = up.ProdID)
FROM #ArrBarCodeGroup up WHERE LEN(Barcode) = 6 AND EXISTS(SELECT top 1 1 FROM r_Prods p WHERE p.ProdID = CAST(Barcode AS INT)) 

SELECT * FROM #ArrBarCodeGroup

ROLLBACK TRAN





BEGIN TRAN

SELECT * FROM dbo.it_TSD_doc_details WHERE Id_doc = 5 and Id_good = 800594

IF EXISTS (SELECT top 1 1 FROM dbo.it_TSD_doc_details WHERE Id_doc = 5 and Id_good = 800594)
UPDATE dbo.it_TSD_doc_details SET Count_doc = Count_doc + 0 , Count_real = Count_real + 1 WHERE Id_doc = 5 and Id_good = 800594 ELSE
 INSERT dbo.it_TSD_doc_details(Id_doc, Id_good, Count_doc, Count_real) VALUES ( 5,800594,1,2)

SELECT * FROM dbo.it_TSD_doc_details WHERE Id_doc = 5 and Id_good = 800594

ROLLBACK TRAN

SELECT * FROM dbo.it_TSD_doc_head


----------------------------------------------------------
--SELECT gr.*, mq.ProdID, mq.UM FROM #ArrBarCodeGroup gr
--left join r_ProdMQ mq on mq.BarCode = gr.Barcode

SELECT * FROM [it_TSD_UnknBarCodes]


/*
SELECT * FROM t_VenA where ChID = 100001391 ORDER BY 1

DECLARE @ChID int = 100001391	
	
  DECLARE @ProdID int, 
          @TSrcPosID int
  DECLARE @UM varchar(255),
          @BarCode varchar(255)
  DECLARE @TQty float,
          @TNewQty float
  DECLARE @SrcPosID int,
          @NewQty float        

  --IF object_id('tempdb..#tmpImp') IS NOT NULL DROP TABLE #tmpImp
  
  --IF object_id('tempdb..#tmpUnknCodes') IS NOT NULL DROP TABLE #tmpUnknCodes
  --/*временна€ таблица дл€ неизвестных штрихкодов и товаров отсутствующих в текущ документе*/
  --CREATE TABLE #tmpUnknCodes
  --(
  -- BarCode varchar(255),
  -- NewQty float 
  --)

  --/*во временную таблицу занос€тс€ известные штрихкоды*/
  --SELECT t.ProdID as ProdID, 
  --       p.UM as UM, 
  --       min (t.Qty ) as TQty, 
  --       SUM (t.NewQty) as TNewQty, 
  --       mq.BarCode,
  --      identity(int,1,1) as TSrcPosID
  --INTO #tmpImp
  --FROM #VenImp as t 
  --INNER JOIN r_Prods as p on p.ProdID = t.ProdID 
  --INNER JOIN r_ProdMQ as mq on p.ProdId=mq.ProdID and p.UM=mq.UM
  --GROUP BY t.ProdID , p.UM , mq.BarCode
  --HAVING t.ProdID IS NOT NULL
  
  --/* во временную таблицу занос€тс€ неизвестные штрихкоды*/
  --INSERT INTO #tmpUnknCodes (BarCode, NewQty) 
  --SELECT t.BarCode, SUM (t.NewQty) 
  --FROM #VenImp t
  --WHERE t.ProdID IS NULL
  --GROUP BY BarCode
   
  /* курсор дл€ занесени€ в детальную часть (2 уровень) док. »нвентаризаци€*/  
  
  DECLARE InsVenA CURSOR FAST_FORWARD FOR
    SELECT mq.ProdID, mq.UM, gr.TQty ,gr.Barcode  FROM #ArrBarCodeGroup gr
	join r_ProdMQ mq on mq.BarCode = gr.Barcode

  OPEN InsVenA
  FETCH NEXT FROM InsVenA INTO @ProdID, @UM, @TNewQty, @BarCode
  WHILE @@FETCH_STATUS  = 0
    BEGIN
      IF NOT EXISTS(SELECT TOP 1 1 
                    FROM t_VenA 
                    WHERE ChID = @ChID AND ProdID = @ProdID)
        BEGIN
          SELECT @TSrcPosID = (SELECT ISNULL(MAX(TSrcPosID)+1,1) 
	                       FROM t_VenA 
	                       WHERE ChID = @ChID)
          INSERT INTO t_VenA 
	        SELECT @ChID, @ProdID, @UM, 0,@TNewQty,0,0,0,0,0,0,@BarCode,0,@TSrcPosID ,0
        END
       ELSE
        BEGIN
	  UPDATE t_VenA	  SET TNewQty = TNewQty + @TNewQty	  WHERE ChID = @ChID AND ProdID = @ProdID
        END
  FETCH NEXT FROM InsVenA INTO @ProdID, @UM,  @TNewQty, @BarCode
  END
  CLOSE InsVenA
  DEALLOCATE InsVenA


SELECT * FROM t_VenA where ChID = 100001391 ORDER BY 1

INSERT t_VenA(ChID, ProdID, UM, TQty, TNewQty, TSumCC_nt, TTaxSum, TSumCC_wt, TNewSumCC_nt, TNewTaxSum, TNewSumCC_wt, BarCode, Norma1, TSrcPosID, HandCorrected)
VALUES (ChID, ProdID, UM, 0, TNewQty, 0, 0, 0, 0, 0, 0, BarCode, 0, TSrcPosID, 0)
	        SELECT @ChID, @ProdID, @UM, 0,@TNewQty,0,0,0,0,0,0,@BarCode,0,@TSrcPosID ,0
	        
*/	        
/*
SELECT um FROM r_ProdMQ where ProdID = 1213
SELECT * FROM r_ProdMQ ORDER BY BarCode
SELECT top 1 ProdID FROM r_ProdMQ where BarCode = '8034141060212'
SELECT top 1 UM FROM r_ProdMQ where BarCode = '5012478896547'

SELECT ProdID, SUM(qty) tqty FROM t_Rem where StockID = 4 and OurID = 1
group by ProdID
having SUM(qty) <> 0
ORDER BY 2 desc
*/
/*
SELECT * FROM t_VenA where ChID = 100001391 ORDER BY 1

--UPDATE t_VenA SET TNewQty = TNewQty + 9.8 WHERE ChID = 100001391 AND ProdID = 1213
INSERT dbo.t_VenA(ChID, ProdID, UM, TQty, TNewQty, TSumCC_nt, TTaxSum, TSumCC_wt, TNewSumCC_nt, TNewTaxSum, TNewSumCC_wt, BarCode, Norma1, TSrcPosID, HandCorrected) VALUES (100001391,21644,'пл€ш',0,2, 0, 0, 0, 0, 0, 0,'9418076000656',0,3,0)

SELECT * FROM t_VenA where ChID = 100001391 ORDER BY 1

SELECT * FROM r_ProdMQ where BarCode like '%5010677160520%'
SELECT * FROM r_ProdMQ where ProdBarCode like '%5010677160520%'

*/
/*
5011007003227
5011007003227
5011007003227
742881000464
742881000464
080432400432
080432400432
080432400432
*/