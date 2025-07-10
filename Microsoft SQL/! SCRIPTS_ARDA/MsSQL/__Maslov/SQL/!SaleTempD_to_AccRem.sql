BEGIN TRAN;
DECLARE @err INT = 0			

--запускать процедуру в интервале времени
IF (CONVERT (TIME, GETDATE()) > '22:00:00' 
    AND CONVERT (TIME, GETDATE()) < '10:00:00') 
    --AND DATEPART(weekday, GETDATE()) in (2,3,4,5,6) -- с ѕн по ѕт
BEGIN
	SET @err = 666
END;
ELSE
BEGIN
	BEGIN TRY 			

		EXEC sp_testlinkedserver [S-MARKETA]

	END TRY  
	BEGIN CATCH

		SELECT @err = ERROR_NUMBER()

	END CATCH
END;

IF @err = 0
BEGIN
		UPDATE t_Rem SET AccQty = 0 WHERE OurID = 6 AND StockID = 1201 AND PPID = 0

		DECLARE @SaleTemp TABLE (ProdID INT, Qty NUMERIC(21,9))
		INSERT INTO @SaleTemp
		SELECT ProdID, SUM(Qty) FROM [S-MARKETA].ElitV_DP.dbo.t_SaleTempD GROUP BY ProdID

		--SELECT * FROM @SaleTemp

		--ƒл€ отладки.
		--SELECT * FROM t_Rem
		--WHERE OurID = 6 AND StockID = 1201 AND PPID = 0 AND ProdID IN (SELECT DISTINCT ProdID FROM @SaleTemp)

		DECLARE @ProdID INT
		DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD 
		FOR 
		SELECT DISTINCT ProdID FROM @SaleTemp

		OPEN CURSOR1
			FETCH NEXT FROM CURSOR1 INTO @ProdID
		WHILE @@FETCH_STATUS = 0	 
		BEGIN
	
			IF EXISTS(SELECT 1 FROM t_Rem WHERE OurID = 6 AND StockID = 1201 AND PPID = 0 AND ProdID = @ProdID)
			BEGIN
				UPDATE m SET m.AccQty = d.Qty
				FROM t_Rem m
				JOIN @SaleTemp d ON d.ProdID = @ProdID
				WHERE m.OurID = 6 AND m.StockID = 1201 AND m.PPID = 0 AND m.ProdID = @ProdID
			END;
			ELSE
			BEGIN
				INSERT INTO t_Rem (OurID, StockID, SecID, ProdID, PPID, Qty, AccQty)
				SELECT 6, 1201, 1, ProdID, 0, 0, Qty FROM @SaleTemp WHERE ProdID = @ProdID
			END;
		
			FETCH NEXT FROM CURSOR1 INTO @ProdID
		END
		CLOSE CURSOR1
		DEALLOCATE CURSOR1

		--ƒл€ отладки.
		--SELECT * FROM t_Rem
		--WHERE OurID = 6 AND StockID = 1201 AND PPID = 0 AND ProdID IN (SELECT DISTINCT ProdID FROM @SaleTemp)

END;
ROLLBACK TRAN;

--ƒл€ отладки.
SELECT * FROM t_Rem
WHERE OurID = 6 AND StockID = 1201 AND PPID = 0

--SELECT ProdID, SUM(Qty) FROM [S-MARKETA].ElitV_DP.dbo.t_SaleTempD GROUP BY ProdID
--SELECT DISTINCT ProdID FROM [S-MARKETA].ElitV_DP.dbo.t_SaleTempD GROUP BY ProdID

--SELECT * FROM t_Rem
--WHERE OurID = 6 AND StockID = 1201 AND PPID = 0
/*
601116
BEGIN TRAN;

UPDATE t_Rem SET AccQty = 0 WHERE OurID = 6 AND StockID = 1201 AND PPID = 0

SELECT * FROM t_Rem
WHERE OurID = 6 AND StockID = 1201 AND PPID = 0

SELECT * FROM [av_VC_ExportRemsR_Dnepr]
WHERE ProdID IN (SELECT DISTINCT ProdID FROM [S-MARKETA].ElitV_DP.dbo.t_SaleTempD GROUP BY ProdID)

UPDATE m SET m.AccQty = d.Qty
FROM t_Rem m
JOIN (SELECT ProdID, SUM(Qty) Qty FROM [S-MARKETA].ElitV_DP.dbo.t_SaleTempD GROUP BY ProdID) d ON d.prodid = m.ProdID
WHERE OurID = 6 AND StockID = 1201 AND PPID = 0

SELECT * FROM t_Rem
WHERE OurID = 6 AND StockID = 1201 AND PPID = 0

SELECT * FROM [av_VC_ExportRemsR_Dnepr]
WHERE ProdID IN (SELECT DISTINCT ProdID FROM [S-MARKETA].ElitV_DP.dbo.t_SaleTempD GROUP BY ProdID)

ROLLBACK TRAN;



*/

