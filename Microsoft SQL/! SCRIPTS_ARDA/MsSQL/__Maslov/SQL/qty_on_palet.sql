/*	EXECUTE AS LOGIN = 'pvm0' -- для запуска OPENROWSET('Microsoft.ACE.OLEDB.12.0'

	IF OBJECT_ID (N'tempdb..#uCat', N'U') IS NOT NULL DROP TABLE #uCat
	SELECT *
	 INTO #uCat
	FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\EDI\uCat_шаблон.xls' , 'select * from [Выгрузка$]') as ex;
	*/
	--SELECT UnitDescriptor, id, GTIN, ChildGTIN, DescriptionTextRu, QuantityOfChild, QuantityOfLayersPerPallet, QuantityOfTradeItemsPerPalletLayer FROM #uCat
	--where UnitDescriptor = 'CASE'

IF OBJECT_ID (N'tempdb..#res', N'U') IS NOT NULL DROP TABLE #res
CREATE TABLE #res (barcode varchar(100), name varchar(250), qty_on_palet INT)

DECLARE @ID INT, @qty INT = 1

DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD
FOR 
SELECT id FROM #uCat WHERE UnitDescriptor = 'CASE'


OPEN CURSOR1
	FETCH NEXT FROM CURSOR1 INTO @ID
WHILE @@FETCH_STATUS = 0		 
BEGIN

	IF (SELECT ChildGTIN FROM #uCat WHERE id = @ID) != ''
	BEGIN
	    SET @qty = @qty * ((SELECT CASE WHEN CAST(QuantityOfChild AS INT) = 0 THEN 1 ELSE CAST(QuantityOfChild AS INT) END FROM #uCat WHERE id = @ID)*(SELECT CASE WHEN CAST(QuantityOfLayersPerPallet AS INT) = 0 THEN 1 ELSE CAST(QuantityOfLayersPerPallet AS INT) END FROM #uCat WHERE id = @ID)*(SELECT CASE WHEN CAST(QuantityOfTradeItemsPerPalletLayer AS INT) = 0 THEN 1 ELSE CAST(QuantityOfTradeItemsPerPalletLayer AS INT) END FROM #uCat WHERE id = @ID))
		SET @ID = (SELECT m.id FROM #uCat m WHERE m.GTIN = (SELECT ChildGTIN FROM #uCat WHERE id = @ID))
	END;

	ELSE
	BEGIN
		INSERT #res
		VALUES ((SELECT GTIN FROM #uCat WHERE id = @ID), (SELECT DescriptionTextRu FROM #uCat WHERE id = @ID),@qty)
		SET @qty = 1
		FETCH NEXT FROM CURSOR1 INTO @ID
	END;
	
END
CLOSE CURSOR1
DEALLOCATE CURSOR1
SELECT * FROM #res


