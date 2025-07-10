	/*Создаем временную таблицу остатков на дату по партиям*/
	IF OBJECT_ID (N'tempdb..#TRemD') IS NOT NULL DROP TABLE #TRemD
	CREATE TABLE #TRemD (OurID INT,StockID INT,ProdID INT,PPID INT,Qty NUMERIC (21, 9))                         
DECLARE @OurID int = 6,@Sklad_In int = 1201 , @DocDate date = '2017-12-04'

	--INSERT #TRemD
	--	SELECT OurID, StockID, ProdID, PPID, SUM(Qty-AccQty) TQty
	--	FROM t_Rem 
	--	WHERE OurID = @OurID AND StockID = @Sklad_In
	--	GROUP BY OurID, StockID, ProdID, PPID 
	--	HAVING SUM(Qty-AccQty) > 0
	
	INSERT #TRemD
		SELECT OurID, StockID, ProdID, PPID, SUM(Qty-AccQty) Qty
		FROM zf_t_CalcRemByDateDate ('19000101', @DocDate) 
		WHERE OurID = @OurID AND StockID = @Sklad_In
		GROUP BY OurID, StockID, ProdID, PPID 
		
		SELECT * FROM #TRemD where ProdID = 600895



BEGIN TRAN


EXEC [ap_Perebrosvnal] 6,6,1201,1203,'20171204', 'Переброс в нал', 81


ROLLBACK TRAN


SELECT  [dbo].[af_CalcRemTotalD_F] ('12.04.2017' ,6, 1201 ,1,600895)