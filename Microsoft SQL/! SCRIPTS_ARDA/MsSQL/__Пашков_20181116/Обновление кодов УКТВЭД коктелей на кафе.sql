--Список товаров коктелей
IF  EXISTS(SELECT * FROM tempdb.dbo.sysobjects WHERE id = OBJECT_ID('tempdb..#ProdID') and xtype in (N'U')) DROP TABLE #ProdID

CREATE TABLE #ProdID (ProdID int, SProdID int, Norma1 int, IndRetPriceCC numeric(21,9), CstProdCode varchar(250))  
 
DECLARE @ProdID int
DECLARE LastSpec CURSOR FOR
	SELECT DISTINCT ProdID FROM r_prods where ProdID in (605535,605536,605552,605553,605555,605558,605560,605562,605563,605564,606332,606774,606789,606793,606794,606967,606968,606969,607101,607102,607103)
	order by ProdID
Open LastSpec
FETCH NEXT FROM LastSpec INTO @ProdID
WHILE @@FETCH_STATUS = 0
BEGIN
	INSERT into #ProdID 
		SELECT top 1 s.ProdID , s.SProdID, pr.Norma1, pr.IndRetPriceCC, pr.CstProdCode FROM (
			SELECT @ProdID as ProdID , ms.SProdID as SProdID FROM it_SpecD sd 
			join r_Prods p on p.ProdID = sd.ProdID
			join r_ProdMS ms on ms.ProdID = p.ProdID
			where sd.ChID = (SELECT top 1 ChID  FROM it_Spec where ProdID = @ProdID and StockID = 1202 and OurID = 9 order by DocDate desc)
			and PGrID2 = 40014) s
		join r_Prods pr on pr.ProdID = s.SProdID
		--Where pr.Norma1 = 0
		order by pr.Norma1 desc, pr.IndRetPriceCC desc	
			
	FETCH NEXT FROM LastSpec INTO @ProdID
END

CLOSE LastSpec
DEALLOCATE LastSpec

SELECT * FROM #ProdID
---------------------------------------------------------

SELECT t.*, r.CstProdCode FROM #ProdID t
join r_Prods r on r.ProdID = t.ProdID 

--обновление кодов УКТВЭД 
update r_Prods 
set CstProdCode = t.CstProdCode
FROM #ProdID t
join r_Prods r on r.ProdID = t.ProdID
---------------------------------------------------------