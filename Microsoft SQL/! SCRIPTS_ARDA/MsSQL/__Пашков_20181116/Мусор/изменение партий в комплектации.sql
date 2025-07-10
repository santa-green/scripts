BEGIN TRAN
/*
--SELECT top 1 * FROM t_SRecD

SELECT srd.AChID,srd.SubSrcPosID,sr.DocDate, p.CostMC , c.KursMC, p.CostMC * c.KursMC, srd.SubPriceCC_wt, sr.*
 	From t_SRec sr 
	join t_SRecA sra on sra.ChID = sr.Chid
	join t_SRecD srd on srd.AChID = sra.AChid
	join t_Pinp p on srd.SubProdID = p.ProdID and srd.SubPPID = p.PPID
	join r_Currs c on p.CurrID=c.CurrID
	where 
		(
		sr.DocDate Between Cast ('20180101' as SMALLDATETIME) and Cast ('20180131' as SMALLDATETIME) 
		and c.CurrID=980 and sr.Ourid in (12) and sr.CodeID1 in (100)
		--and sr.StockID in (1001,1202,1314)
		and  p.CostMC * c.KursMC <> srd.SubPriceCC_wt
		--and srd.SubProdID in (611577) 
		--and sr.DocID = 600005625
		)
		--or (srd.AChID = 143261 and srd.SubSrcPosID  = 9)
	ORDER BY 1,2
	
--пересчитать состовляющие комплектов по курсу партий		
update srd
set srd.SubPriceCC_wt = p.CostMC * c.KursMC
,srd.SubNewPriceCC_wt = p.CostMC * c.KursMC
,srd.SubTax  = isnull(dbo.zf_GetIncludedTax((p.CostMC * c.KursMC), dbo.zf_GetProdTaxPercent(srd.SubProdID, dbo.zf_GetDate(sr.DocDate))),0) /* НДС*/
,SubPriceCC_nt = p.CostMC * c.KursMC - isnull(dbo.zf_GetIncludedTax((p.CostMC * c.KursMC), dbo.zf_GetProdTaxPercent(srd.SubProdID, dbo.zf_GetDate(sr.DocDate))),0) /* Цена без НДС*/
,SubSumCC_wt= srd.SubQty *  p.CostMC * c.KursMC /* Сумма с НДС*/
,SubTaxSum  = srd.SubQty * isnull(dbo.zf_GetIncludedTax((p.CostMC * c.KursMC), dbo.zf_GetProdTaxPercent(srd.SubProdID, dbo.zf_GetDate(sr.DocDate))),0) /* Сумма НДС*/
,SubSumCC_nt = srd.SubQty * p.CostMC * c.KursMC - isnull(dbo.zf_GetIncludedTax((p.CostMC * c.KursMC), dbo.zf_GetProdTaxPercent(srd.SubProdID, dbo.zf_GetDate(sr.DocDate))),0) /* Сумма без НДС*/

,srd.SubNewTax  = isnull(dbo.zf_GetIncludedTax((p.CostMC * c.KursMC), dbo.zf_GetProdTaxPercent(srd.SubProdID, dbo.zf_GetDate(sr.DocDate))),0) /* НДС*/
,SubNewPriceCC_nt = p.CostMC * c.KursMC - isnull(dbo.zf_GetIncludedTax((p.CostMC * c.KursMC), dbo.zf_GetProdTaxPercent(srd.SubProdID, dbo.zf_GetDate(sr.DocDate))),0) /* Цена без НДС*/
,SubNewSumCC_wt= srd.SubQty *  p.CostMC * c.KursMC /* Сумма с НДС*/
,SubNewTaxSum  = srd.SubQty * isnull(dbo.zf_GetIncludedTax((p.CostMC * c.KursMC), dbo.zf_GetProdTaxPercent(srd.SubProdID, dbo.zf_GetDate(sr.DocDate))),0) /* Сумма НДС*/
,SubNewSumCC_nt = srd.SubQty * p.CostMC * c.KursMC - isnull(dbo.zf_GetIncludedTax((p.CostMC * c.KursMC), dbo.zf_GetProdTaxPercent(srd.SubProdID, dbo.zf_GetDate(sr.DocDate))),0) /* Сумма без НДС*/

 	From t_SRec sr 
	join t_SRecA sra on sra.ChID = sr.Chid
	join t_SRecD srd on srd.AChID = sra.AChid
	join t_Pinp p on srd.SubProdID = p.ProdID and srd.SubPPID = p.PPID
	join r_Currs c on p.CurrID=c.CurrID
	where sr.DocDate Between Cast ('20180101' as SMALLDATETIME) and Cast ('20180131' as SMALLDATETIME) 
		and c.CurrID=980 and sr.Ourid in (12) and sr.CodeID1 in (100)
		--and sr.StockID in (1001,1202,1314)
		--and  p.CostMC * c.KursMC <> srd.SubPriceCC_wt
		--and srd.SubProdID in (611577) 
		--and sr.DocID = 600005625
		
*/




BEGIN
  

SET NOCOUNT ON		
--set rowcount 0; 	
DECLARE @pos INT = 0, @DateShow DATETIME  = GETDATE(), @DateStart DATETIME = GETDATE(), @p INT,@ToEnd INT, @t INT, @Msg varchar(200), @p100 INT

DECLARE @ChID INT
DECLARE CURSOR1 CURSOR STATIC --LOCAL FAST_FORWARD
FOR
SELECT DISTINCT sr.ChID --,* 
 	From t_SRec sr 
	join t_SRecA sra on sra.ChID = sr.Chid
	join t_SRecD srd on srd.AChID = sra.AChid
	join t_Pinp p on srd.SubProdID = p.ProdID and srd.SubPPID = p.PPID
	join r_Currs c on p.CurrID=c.CurrID
	where sr.DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) 
		and c.CurrID=980 and sr.Ourid in (12) and sr.CodeID1 in (100)
		--and sr.StockID in (1001,1202,1314)
		--and  p.CostMC * c.KursMC <> srd.SubPriceCC_wt
	--ORDER BY sr.ChID
	
OPEN CURSOR1
	FETCH NEXT FROM CURSOR1 	INTO @ChID
WHILE @@FETCH_STATUS = 0
BEGIN
	--Script
------------------------------------------------------------------------------		
	IF @pos = 0 SET @p100 = @@CURSOR_ROWS	
	SET @pos = @pos + 1
	IF  DATEDIFF ( second , @DateShow , Cast (GETDATE() as DATETIME) ) >= 5 
	BEGIN
		SET @DateShow =  GETDATE()
		SET @p = (@pos*100)/@p100
		IF @p = 0 SET @p = 1
		SET @t = DATEDIFF ( second , @DateStart , Cast (GETDATE() as DATETIME) )
		SET @ToEnd = (100 - @p) * @t / @p  
		SET @Msg = CONVERT( varchar, GETDATE(), 121)  
		RAISERROR ('Выполнено %u процентов за  %u сек. Осталось = %u сек.', 10,1,@p,@t,@ToEnd) WITH NOWAIT
	END	
------------------------------------------------------------------------------
	
--/*
--пересчитать состовляющие комплектов по курсу партий		
update srd
set srd.SubPriceCC_wt = p.CostMC * c.KursMC
,srd.SubNewPriceCC_wt = p.CostMC * c.KursMC
,srd.SubTax  = isnull(dbo.zf_GetIncludedTax((p.CostMC * c.KursMC), dbo.zf_GetProdTaxPercent(srd.SubProdID, dbo.zf_GetDate(sr.DocDate))),0) /* НДС*/
,SubPriceCC_nt = p.CostMC * c.KursMC - isnull(dbo.zf_GetIncludedTax((p.CostMC * c.KursMC), dbo.zf_GetProdTaxPercent(srd.SubProdID, dbo.zf_GetDate(sr.DocDate))),0) /* Цена без НДС*/
,SubSumCC_wt= srd.SubQty *  p.CostMC * c.KursMC /* Сумма с НДС*/
,SubTaxSum  = srd.SubQty * isnull(dbo.zf_GetIncludedTax((p.CostMC * c.KursMC), dbo.zf_GetProdTaxPercent(srd.SubProdID, dbo.zf_GetDate(sr.DocDate))),0) /* Сумма НДС*/
,SubSumCC_nt = srd.SubQty * p.CostMC * c.KursMC - isnull(dbo.zf_GetIncludedTax((p.CostMC * c.KursMC), dbo.zf_GetProdTaxPercent(srd.SubProdID, dbo.zf_GetDate(sr.DocDate))),0) /* Сумма без НДС*/

,srd.SubNewTax  = isnull(dbo.zf_GetIncludedTax((p.CostMC * c.KursMC), dbo.zf_GetProdTaxPercent(srd.SubProdID, dbo.zf_GetDate(sr.DocDate))),0) /* НДС*/
,SubNewPriceCC_nt = p.CostMC * c.KursMC - isnull(dbo.zf_GetIncludedTax((p.CostMC * c.KursMC), dbo.zf_GetProdTaxPercent(srd.SubProdID, dbo.zf_GetDate(sr.DocDate))),0) /* Цена без НДС*/
,SubNewSumCC_wt= srd.SubQty *  p.CostMC * c.KursMC /* Сумма с НДС*/
,SubNewTaxSum  = srd.SubQty * isnull(dbo.zf_GetIncludedTax((p.CostMC * c.KursMC), dbo.zf_GetProdTaxPercent(srd.SubProdID, dbo.zf_GetDate(sr.DocDate))),0) /* Сумма НДС*/
,SubNewSumCC_nt = srd.SubQty * p.CostMC * c.KursMC - isnull(dbo.zf_GetIncludedTax((p.CostMC * c.KursMC), dbo.zf_GetProdTaxPercent(srd.SubProdID, dbo.zf_GetDate(sr.DocDate))),0) /* Сумма без НДС*/

 	From t_SRec sr 
	join t_SRecA sra on sra.ChID = sr.Chid
	join t_SRecD srd on srd.AChID = sra.AChid
	join t_Pinp p on srd.SubProdID = p.ProdID and srd.SubPPID = p.PPID
	join r_Currs c on p.CurrID=c.CurrID
	where sr.DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) 
		and c.CurrID=980 and sr.Ourid in (12) and sr.CodeID1 in (100)
		--and sr.StockID in (1001,1202,1314)
		--and  p.CostMC * c.KursMC <> srd.SubPriceCC_wt
		--and srd.SubProdID in (611577) 
		--and sr.DocID = 600005625	
		and sr.ChID = @ChID
	
	--обновить комплекты
	EXEC dbo.ap_UpdateSRecA @ChID 
	--EXEC dbo.ap_UpdateSRecA @ChID = 11267
--*/	
	FETCH NEXT FROM CURSOR1 INTO @ChID
END
CLOSE CURSOR1
DEALLOCATE CURSOR1
SET NOCOUNT OFF
          

END	


/*

SELECT srd.AChID,srd.SubSrcPosID,sr.DocDate, p.CostMC , c.KursMC, p.CostMC * c.KursMC, srd.SubPriceCC_wt, sr.*
 	From t_SRec sr 
	join t_SRecA sra on sra.ChID = sr.Chid
	join t_SRecD srd on srd.AChID = sra.AChid
	join t_Pinp p on srd.SubProdID = p.ProdID and srd.SubPPID = p.PPID
	join r_Currs c on p.CurrID=c.CurrID
	where 
		(
		sr.DocDate Between Cast ('20180101' as SMALLDATETIME) and Cast ('20180131' as SMALLDATETIME) 
		and c.CurrID=980 and sr.Ourid in (12) and sr.CodeID1 in (100)
		and sr.StockID in (1001,1202,1314)
		and  p.CostMC * c.KursMC <> srd.SubPriceCC_wt
		--and srd.SubProdID in (611577) 
		--and sr.DocID = 600005625
		)
		--or (srd.AChID = 143261 and srd.SubSrcPosID  = 9)
	ORDER BY 1,2
*/		

ROLLBACK TRAN 

IF @@TRANCOUNT > 0 
BEGIN
  COMMIT TRAN
print 'транзакция COMMIT. все ок'
END
