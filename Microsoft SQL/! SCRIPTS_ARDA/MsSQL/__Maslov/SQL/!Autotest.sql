USE Elit_TEST_IM
EXECUTE AS LOGIN = 'pvm0' -- для запуска OPENROWSET('Microsoft.ACE.OLEDB.12.0'
	GO
	--REVERT
DECLARE @TestID INT = 2
DECLARE @ForTop INT = 100

IF OBJECT_ID (N'tempdb..#Excel', N'U') IS NOT NULL DROP TABLE #Excel -- выгрузка данных из Excel

SELECT * 
 INTO #Excel
FROM (
SELECT 0 RecChID , 0 Qty, 0 TestID 
) s1	
SELECT * FROM #Excel


WHILE @TestID >= 1
BEGIN

select @TestID TestID

BEGIN TRAN;

UPDATE t_IORec
SET StateCode = 110
WHERE ChID  IN (SELECT TOP (@ForTop) ChID FROM t_IORec ORDER BY ChID DESC)

IF @TestID = 1
BEGIN 
	EXEC dbo.ap_OP_OrderProcessingOld -- TestID 1
END;
ELSE
BEGIN
	EXEC dbo.ap_OP_OrderProcessing  -- TestID 2
END;


DECLARE @res TABLE (RecChID INT, Qty NUMERIC(21,9), TestID INT)
DECLARE @ChID INT

DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD 
FOR 
SELECT TOP (@ForTop) ChID FROM t_IORec ORDER BY ChID DESC

OPEN CURSOR1
	FETCH NEXT FROM CURSOR1 INTO @ChID
WHILE @@FETCH_STATUS = 0	 
BEGIN
		
		INSERT INTO @res
		SELECT @ChID
		      ,(SELECT SUM(Qty) FROM at_t_IOResD WHERE ChID = (SELECT TOP 1 ChildChID FROM z_DocLinks WHERE ChildDocCode = 666004 AND ParentChID = @ChID ORDER BY LinkID DESC) )
			  ,@TestID

	FETCH NEXT FROM CURSOR1 INTO @ChID
END
CLOSE CURSOR1
DEALLOCATE CURSOR1

ROLLBACK TRAN;

--INSERT INTO OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;IMEX=0;Database=E:\OT38ElitServer\Import\test\!ResultAutotest.xlsx;', 'SELECT * FROM [Лист1$]')
--SELECT RecChID, Qty, TestID FROM @res

INSERT INTO #Excel
SELECT RecChID, Qty, TestID
 --INTO #Excel	
FROM @res


set @TestID = @TestID - 1
END

SELECT * FROM #Excel ORDER BY 3

/*
IF OBJECT_ID (N'tempdb..#Excel', N'U') IS NOT NULL DROP TABLE #Excel -- выгрузка данных из Excel
SELECT *--CAST(CAST(ex.card AS BIGINT) as VARCHAR) card, CAST(CAST(ex.tel AS BIGINT) as VARCHAR) tel 
 INTO #Excel	
FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=E:\OT38ElitServer\Import\test\!ResultAutotest.xlsx;' , 'select * from [Лист1$]') as ex

SELECT *
FROM #Excel ex1
JOIN #Excel ex2 ON ex2.RecChID = ex1.RecChID AND ex2.TestID = 2
WHERE ex1.TestID = 1 AND ex1.Qty != ex2.Qty

SELECT * FROM z_Tables ORDER BY 3;

SELECT TOP 2 * FROM t_IORec
ORDER BY ChID DESC


SELECT * FROM z_DocLinks
WHERE ChildDocCode = 666004 AND ParentChID = 102159888

SELECT * FROM t_IORec WHERE StateCode = 110 ORDER BY ChID DESC
*/
