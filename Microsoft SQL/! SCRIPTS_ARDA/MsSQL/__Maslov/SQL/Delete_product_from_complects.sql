--Удаление определенного товара из комплектов.

--SELECT *
-- 	From t_SRec sr 
--	join t_SRecA sra on sra.ChID = sr.Chid
--	join t_SRecD srd on srd.AChID = sra.AChid
--	where sr.DocDate between '20180814' and '20180904'
--and sra.ProdID in (607598,608083,608082,608081,608080,608079)
--and srd.SubProdID =  611813     
--and sr.StockID = 1314 and sr.SubStockID = 1328
--setuser
--setuser 'pvm0'

BEGIN TRAN

SELECT distinct sr.ChID
 	From t_SRec sr 
	join t_SRecA sra on sra.ChID = sr.Chid
	join t_SRecD srd on srd.AChID = sra.AChid
	where sr.DocDate between '20180814' and '20180904'
and sra.ProdID in (607598,608083,608082,608081,608080,608079)
and srd.SubProdID =  611813  
and sr.StockID = 1314 and sr.SubStockID = 1328

SELECT *
 	From t_SRec sr 
	join t_SRecA sra on sra.ChID = sr.Chid
	join t_SRecD srd on srd.AChID = sra.AChid
	where sr.DocDate between '20180814' and '20180904'
and sra.ProdID in (607598,608083,608082,608081,608080,608079)
and srd.SubProdID =  611813  
and sr.StockID = 1314 and sr.SubStockID = 1328


delete srd
 	From t_SRec sr 
	join t_SRecA sra on sra.ChID = sr.Chid
	join t_SRecD srd on srd.AChID = sra.AChid
	where sr.DocDate between '20180814' and '20180904'
and sra.ProdID in (607598,608083,608082,608081,608080,608079)
and srd.SubProdID =  611813  
and sr.StockID = 1314 and sr.SubStockID = 1328


SELECT *
 	From t_SRec sr 
	join t_SRecA sra on sra.ChID = sr.Chid
	join t_SRecD srd on srd.AChID = sra.AChid
	where sr.DocDate between '20180814' and '20180904'
and sra.ProdID in (607598,608083,608082,608081,608080,608079)
and srd.SubProdID =  611813  
and sr.StockID = 1314 and sr.SubStockID = 1328




--SELECT ChID FROM t_SRec where ChID in (16565,16566,16579,16580,16589,16590,16604,16605,16614,16626,16627,16641,16642,16654,16655,16667,16668,16678,16679,16701,16702,16713,16714,16723,16724,16733,16734,16744,16757,16758,16778,16792,16793,16802,16803,16818,16819,16829,16842,16843,16854,16867,16868,16877,16887,16888)

--EXECUTE ip_SRecSpecCalc #Параметр_Код регистрации#


DECLARE @ChID int;
DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD
FOR 
SELECT ChID FROM t_SRec where ChID in (16654,16803,16829,16580,16723,16843,16734,16757,16614,16714,16792,16566,16778,16758,16678,16887,16655,16589,16867,16818,16626,16744,16604,16590,16733,16713,16627,16819,16701,16641,16793,16667,16724,16579,16888,16702,16642,16842,16854,16868,16668,16605,16565,16802,16877,16679)

OPEN CURSOR1
	FETCH NEXT FROM CURSOR1 INTO @ChID
WHILE @@FETCH_STATUS = 0		 
BEGIN
SELECT 'EXEC dbo.ap_UpdateSRecA @ChID ='+cast(@ChID as varchar(10))
	EXEC dbo.ap_UpdateSRecA @ChID = @ChID
	
	
	FETCH NEXT FROM CURSOR1 INTO @ChID
END
CLOSE CURSOR1
DEALLOCATE CURSOR1

ROLLBACK TRAN

--BEGIN TRAN
--EXEC dbo.ap_UpdateSRecA @ChID = 16565
--ROLLBACK TRAN
----a_tPInP_IUD