/*
IN WORK ap_OP_OrderProcessingRes

EXEC ap_OP_OrderProcessing

SELECT * FROM z_Tables ORDER BY 3;

SELECT * FROM t_Acc
WHERE CompID = 7142 AND OurID =1 

SELECT * FROM t_AccD
WHERE 100171286 = ChID

SELECT * FROM t_Rem
WHERE ProdID = 30690 AND StockID = 220 AND OurID = 1

SELECT d.* FROM t_IORec m 
JOIN t_IORecD d WITH(NOLOCK) ON d.ChID = m.ChID
WHERE m.ChID = 102159624 AND d.ProdID = 26135
--WHERE m.CompID = 7142 AND d.ProdID = 26135
ORDER BY m.DocDate DESC

SELECT * FROM at_t_IORes

DECLARE @ContractChID int
EXEC dbo.ap_GetContract 11221, 102159624, @ContractChID OUTPUT
SELECT @ContractChID
SELECT CASE WHEN UseContrConditions = 1 AND @ContractChID > 0 AND EXISTS(SELECT * FROM dbo.at_z_ContractTerms WHERE ChID=@ContractChID) THEN 1 ELSE 0 END
FROM dbo.t_IORec WITH(NOLOCK) WHERE ChID = 102159624

SELECT * FROM dbo.af_GetPPIDsByContract(8, 74374, 1, '2019-10-03', 1, 220, 26135, 288)
*/


DECLARE @AChID INT = 102159889
DECLARE @ContractChID int
DECLARE @AOurID int
DECLARE @ACompID int
DECLARE @AStockID int
DECLARE @ADocDate smalldatetime
DECLARE @AUseCond bit=0
DECLARE @ResChID int
DECLARE @ResDocID int
DECLARE @t_PP tinyint=dbo.zf_Var('t_PP')
DECLARE @StateCode int
DECLARE @ACodeID4 int
DECLARE @CurrID smallint=dbo.zf_GetCurrCC()
DECLARE @KursMC numeric(21,9)=dbo.zf_GetRateMC(@CurrID)

-- Временная таблица для данных ЗФ
DECLARE @ARec TABLE (ProdID int PRIMARY KEY, Qty numeric(21, 9))
-- Временная таблица для данных ЗР
DECLARE @ARes TABLE (ProdID int, PPID int, Qty numeric(21, 9))
-- Временная таблица для поиска в счетах на оплату товара
DECLARE @TempAcc TABLE (ChID INT, SrcPosID INT, PPID INT, ProdID INT, QtyOrder NUMERIC(21, 9), QtyAcc NUMERIC(21, 9))

SELECT TOP 1 
  @ACompID=CompID, @AOurID=OurID, @AStockID=StockID, @ADocDate=DocDate,
  @AUseCond=CASE WHEN UseContrConditions = 1 AND @ContractChID > 0 AND EXISTS(SELECT * FROM dbo.at_z_ContractTerms WHERE ChID=@ContractChID) THEN 1 ELSE 0 END
FROM dbo.t_IORec WITH(NOLOCK) WHERE ChID = @AChID

-- Заполняем таблицу ЗФ из заказа, и убираем то, что уже перенесено в ЗР  
INSERT INTO @ARec SELECT ProdID, SUM(Qty) FROM t_IOrecD WHERE ChID=@AChID GROUP BY ProdID

--UPDATE @ARec SET Qty = 8000 WHERE ProdID = 26136
--UPDATE @ARec SET Qty = 481 WHERE ProdID = 26136


		SELECT m.ChID, d.PPID, d.ProdID, d.Qty--,*
		FROM t_Acc m 
		JOIN t_AccD d WITH(NOLOCK) ON d.ChID = m.ChID
		WHERE m.CompID = @ACompID
		  AND m.OurID  = @AOurID
		  AND m.StockID  = @AStockID
		  AND d.ProdID IN (SELECT DISTINCT ProdID FROM @ARec--t_IOrecD WHERE ChID=@AChID
						  )
		  AND d.Qty > 0
		ORDER BY 1 DESC

DECLARE @counter INT = 2
WHILE @counter > 0 
BEGIN
	  IF EXISTS(SELECT 1
				FROM t_Acc m 
				JOIN t_AccD d WITH(NOLOCK) ON d.ChID = m.ChID
				WHERE m.StateCode = 105
				  AND m.CompID = @ACompID
				  AND m.OurID  = @AOurID
				  AND m.StockID  = @AStockID
				  AND d.ProdID IN (SELECT DISTINCT ProdID FROM @ARec--t_IOrecD WHERE ChID=@AChID
								  )
				  AND d.Qty > 0
			   )
	  BEGIN
		
		DECLARE @AccChID INT
		DECLARE @AccSrcPosID INT
		DECLARE @AccPPID INT
		DECLARE @AccProdID INT
		DECLARE @AccQty NUMERIC(21,9)

		DECLARE Acc CURSOR LOCAL FAST_FORWARD 
		FOR 
		SELECT m.ChID, d.SrcPosID, d.PPID, d.ProdID, d.Qty
		FROM t_Acc m 
		JOIN t_AccD d WITH(NOLOCK) ON d.ChID = m.ChID
		WHERE m.StateCode = 105
		  AND m.CompID = @ACompID
		  AND m.OurID  = @AOurID
		  AND m.StockID  = @AStockID
		  AND d.ProdID IN (SELECT DISTINCT ProdID FROM @ARec--t_IOrecD WHERE ChID=@AChID
						  )
		  AND d.Qty > 0
		ORDER BY d.Qty DESC
		--ORDER BY 1 DESC
		
		OPEN Acc
			FETCH NEXT FROM Acc INTO @AccChID, @AccSrcPosID, @AccPPID, @AccProdID, @AccQty
		WHILE @@FETCH_STATUS = 0	 
		BEGIN
				--SELECT @AccChID, @AccPPID, @AccProdID, @AccQty

				INSERT INTO @TempAcc
				SELECT @AccChID, @AccSrcPosID, @AccPPID, @AccProdID
				      ,CASE
							--Кратный проход. Если количество в заказе больше, чем есть в счете.
							WHEN @AccQty < Qty AND @counter = 2
								THEN 
									--Если количество кратное, то просто вставляем все, что есть из счета.
									--Если количество в счете не кратное, то вытягиваем из него сколько можно.
									CASE WHEN @AccQty%dbo.af_GetQtyInUM(@AccProdID, 'ящ.') = 0
											 THEN @AccQty
											 ELSE @AccQty - (@AccQty%dbo.af_GetQtyInUM(@AccProdID, 'ящ.')) END
							--Кратный проход. Если количество в заказе меньше или равно, чем есть в счете.
							WHEN @AccQty >= Qty AND @counter = 2
								THEN	
									--Если количество кратное, то просто вставляем все, что есть из счета.
									--Если количество в счете не кратное, то вытягиваем из него сколько можно.
									CASE WHEN Qty%dbo.af_GetQtyInUM(@AccProdID, 'ящ.') = 0
											 THEN Qty
											 ELSE Qty - (Qty%dbo.af_GetQtyInUM(@AccProdID, 'ящ.')) END
							WHEN @AccQty < Qty AND @counter = 1
								THEN @AccQty
							WHEN @AccQty >= Qty AND @counter = 1
								THEN Qty
								END
					  ,@AccQty
				FROM @ARec
				WHERE ProdID = @AccProdID

				--Дальше точечный апдейт @ARec по ProdID
				UPDATE @ARec SET Qty = Qty - (SELECT QtyOrder FROM @TempAcc WHERE ChID = @AccChID AND SrcPosID = @AccSrcPosID AND PPID = @AccPPID AND ProdID = @AccProdID)
				WHERE ProdID = @AccProdID
					
			FETCH NEXT FROM Acc INTO @AccChID, @AccSrcPosID, @AccPPID, @AccProdID, @AccQty
		END
		CLOSE Acc
		DEALLOCATE Acc
		/*
		INSERT INTO @TempAcc
		SELECT m.ChID, d.ProdID, d.PPID
			  ,CASE WHEN d.Qty < ARec.Qty
						THEN ARec.Qty - d.Qty
						ELSE ARec.Qty END
			  ,d.Qty
		FROM t_Acc m 
		JOIN t_AccD d WITH(NOLOCK) ON d.ChID = m.ChID
		JOIN @ARec ARec ON ARec.ProdID = d.ProdID
		WHERE m.CompID = @ACompID
		  AND m.OurID  = @AOurID
		  AND m.StockID  = @AStockID
		  AND d.ProdID IN (SELECT DISTINCT ProdID FROM t_IOrecD WHERE ChID=@AChID)

		UPDATE ARec SET Qty = ARec.Qty - TempAcc.QtyOrder
		FROM @ARec ARec
		JOIN @TempAcc TempAcc ON TempAcc.ProdID = ARec.ProdID
		*/
		DELETE @ARec WHERE Qty = 0
		DELETE @TempAcc WHERE QtyOrder = 0

		INSERT INTO @ARes
		SELECT ProdID, PPID, SUM(QtyOrder) AS 'TQtyOrder' FROM @TempAcc GROUP BY ProdID, PPID
	  END;

	  -- Пересписываем по партиям на остатках
	  INSERT INTO @ARes(ProdID, PPID, Qty)
		SELECT c.ProdID, pp.PPID, pp.Qty
		FROM 
		  @ARec c 
			CROSS APPLY 
		  dbo.af_GetPPIDsByContract(@t_PP, @ContractChID, @AUseCond, @ADocDate, @AOurID, @AStockID, c.ProdID, c.Qty) pp

		
	  SELECT * FROM @TempAcc
	  SELECT * FROM @ARec
	  SELECT * FROM @ARes
SET @counter = @counter - 1
END;

--BEGIN TRAN;

--	  SELECT * FROM t_AccD
--	  WHERE ChID IN (SELECT ChID FROM @TempAcc)
	  
--	  UPDATE d SET Qty = Qty - TempAcc.QtyOrder
--	  FROM t_AccD d
--	  JOIN @TempAcc TempAcc ON TempAcc.ChID = d.ChID AND TempAcc.SrcPosID = d.SrcPosID AND TempAcc.PPID = d.PPID AND TempAcc.ProdID = d.ProdID 
	  
--	  SELECT * FROM t_AccD
--	  WHERE ChID IN (SELECT ChID FROM @TempAcc)

--	  SELECT * FROM t_Rem
--	  WHERE ProdID = 26135 AND StockID = 220 AND OurID = 1

--ROLLBACK TRAN;

	  --SELECT * FROM @TempAcc
	  --SELECT * FROM @ARec
	  --SELECT * FROM @ARes
/*
	  --SELECT * FROM r_ProdMQ
	  --WHERE UM = 'ящ.'
	  --ORDER BY 2
DECLARE @c INT = 2
DECLARE @i INT = 1
WHILE @i <= @c 
BEGIN
SELECT @i

SET @i = @i + 1
END;


BEGIN TRAN;
EXEC ap_OP_OrderProcessing
--EXEC dbo.ap_OP_OrderProcessingRes 102159889
ROLLBACK TRAN;


SELECT 481%dbo.af_GetQtyInUM(26136, 'ящ.')

ap_OP_OrderProcessing
SELECT * FROM t_IOrec
--WHERE ChID = 102159889
WHERE ChID = 102159888


		SELECT * 
        FROM t_IORec m INNER JOIN
             z_DocLinks dl ON dl.ParentChID=m.ChID AND dl.ParentDocCode=11221 AND dl.ChildDocCode=666004
        WHERE m.ChID=102159889 AND m.StateCode=110

		SELECT * FROM z_DocLinks
		WHERE ParentChID = 102159889



SELECT *
FROM dbo.af_GetPPIDsByContract(101, 74374, 1, '2019-10-09', 1, 220, 30690, 1000000000) pp

SELECT * FROM t_Rem
WHERE ProdID = 30690 AND StockID = 220 AND OurID = 1


SELECT TOP 1 * FROM at_t_IORes
ORDER BY 1 DESC

SELECT * FROM at_t_IOResD
WHERE ChID = 101511197

/*
DELETE at_t_IORes WHERE ChID = 101511197
*/

*/