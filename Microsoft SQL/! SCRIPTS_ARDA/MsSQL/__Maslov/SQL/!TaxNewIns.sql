SELECT * FROM z_Tables ORDER BY TableDesc;
SELECT top 10 * FROM b_TExp
WHERE docdate < '20190228' AND OurID = 11
ORDER BY 4 desc

SELECT * FROM t_Inv WHERE DocDate = '2019-02-15' AND 5302 = TaxDocID

IF OBJECT_ID (N'tempdb..#_TaxDocs',N'U') IS NOT NULL DROP TABLE #_TaxDocs
CREATE TABLE #_TaxDocs
(
TJ_Prompt varchar(250), 
TJ_RepToolCode int, 
TJ_ToolCode int, 
TJ_ShowDialog bit, 
ParentDocCode int, 
ParentChID int, 
ParentDocID int, 
ParentDocDate smalldatetime, 
TaxDocType int,  
TaxCorrType int,  
ChID int,  
DocID int, 
DocDate smalldatetime, 
KursMC numeric(21,9), 
OurID int, 
CompID int, 
Notes varchar(200), 
CodeID1 int, 
CodeID2 int, 
CodeID3 int, 
CodeID4 int, 
CodeID5 int, 
IntDocID varchar(50), 
StateCode int, 
SrcChID int, 
SrcDocID varchar(250), 
SrcDocDate smalldatetime, 
SrcTaxDocID varchar(250), 
SrcTaxDocDate smalldatetime, 
GOperID int, 
GTranID int, 
GTSum_wt numeric(21, 9), 
GTTaxSum numeric(21, 9), 
GTAccID int, 
GPosID int, 
GTCorrSum_wt numeric(21, 9), 
GTCorrTaxSum numeric(21, 9), 

PosType int, 
RealPosType int, 
TaxCredit bit, 

PayDate smalldatetime, 
PayForm varchar(200), 
TakeTotalCosts bit, 

IsCorrection bit, 

SumCC_nt numeric(21, 9), 
TaxSum numeric(21, 9), 
SumCC_wt numeric(21, 9), 

SumCC_nt_20 numeric(21, 9), 
TaxSum_20 numeric(21, 9), 
SumCC_nt_0 numeric(21, 9), 
TaxSum_0 numeric(21, 9), 
SumCC_nt_Free numeric(21, 9), 
TaxSum_Free numeric(21, 9), 
SumCC_nt_No numeric(21, 9), 
TaxSum_No numeric(21, 9), 

DocLinkTypeID int, 
LinkSumCC numeric(21, 9)
)

DECLARE @p6 VARCHAR(256), @p5 bit
exec z_TaxDocs_Prepare 11012,200231185,11901,0,@p5 output,@p6 output

SELECT @p5, @p6

    SELECT m.IntDocID, *--ISNULL(MAX(CAST(m.IntDocID AS INT)), 0) + 1
    FROM b_TExp m
    WHERE /*EXISTS(SELECT * FROM #_TaxDocs t WHERE m.OurID = t.OurID)
      AND */m.DocDate BETWEEN dbo.zf_GetMonthFirstDay('2019-12-15 00:00:00') AND dbo.zf_GetMonthLastDay('2019-12-15 00:00:00')
      AND m.IntDocID IS NOT NULL
      AND m.IntDocID <> ''
      AND m.IntDocID NOT LIKE '%[^0-9]%'
	  AND m.OurID = 11

BEGIN TRAN;
	  

--INSERT INTO b_TExp
SELECT TOP 1 (SELECT MAX(ChID)+1 FROM b_TExp)
,(SELECT MAX(DocID)+1 FROM b_TExp WHERE m.OurID = OurID), IntDocID+1, DocDate, KursMC, OurID, 0, 0, 0, 0, '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
FROM b_TExp m
WHERE m.DocDate BETWEEN dbo.zf_GetMonthFirstDay('2019-01-15 00:00:00') AND dbo.zf_GetMonthLastDay('2019-01-15 00:00:00')
      AND m.IntDocID IS NOT NULL
      AND m.IntDocID <> ''
      AND m.IntDocID NOT LIKE '%[^0-9]%'
	  AND m.OurID = 1
ORDER BY IntDocID DESC

ROLLBACK TRAN;


SELECT *
FROM b_TExp
WHERE DocDate BETWEEN '20190101' AND '20191231'
  AND OurID IN (1,4)
ORDER BY IntDocID, DocID

--z_TaxDocs_Prepare
--z_TaxDocs_Save

--apz_TaxDocs_IntDocID

--mein
--ap_GetBunchOfTaxID
--ap_CalculateTaxDiff

/*

SELECT GetDate()
SELECT GetDate()
SELECT COUNT(1) FROM z_DocLinks WITH (NOLOCK) WHERE DocLinkTypeID = 31 and ParentDocCode= 11012 and ParentChID = 200231185	
SELECT COUNT(1) FROM z_DocLinks WITH (NOLOCK) WHERE DocLinkTypeID = 31 and ParentDocCode= 11012 and ParentChID = 200231185
SELECT TOP 1 1 FROM sysobjects WHERE xtype = 'p' AND name = 'z_TaxDocs_Prepare'
SELECT TOP 1 1 FROM sysobjects WHERE xtype = 'p' AND name = 'z_TaxDocs_Prepare'

declare @p5 bit
set @p5=1
declare @p6 varchar(255)
set @p6=''
exec "z_TaxDocs_Prepare" 11012,200231185,11901,0,@p5 output,@p6 output
select @p5, @p6	z_TaxDocs_Prepare

SELECT 1
SELECT 1
SELECT "TJ_Prompt" ,"TJ_RepToolCode" ,"TJ_ToolCode" ,"TJ_ShowDialog" ,"ParentDocCode" ,"ParentChID" ,"ParentDocID" ,"ParentDocDate" ,"TaxDocType" ,"TaxCorrType" ,"ChID" ,"DocID" ,"DocDate" ,"KursMC" ,"OurID" ,"CompID" ,"Notes" ,"CodeID1" ,"CodeID2" ,"CodeID3" ,"CodeID4" ,"CodeID5" ,"IntDocID" ,"StateCode" ,"SrcChID" ,"SrcDocID" ,"SrcDocDate" ,"SrcTaxDocID" ,"SrcTaxDocDate" ,"GOperID" ,"GTranID" ,"GTSum_wt" ,"GTTaxSum" ,"GTAccID" ,"GPosID" ,"GTCorrSum_wt" ,"GTCorrTaxSum" ,"PosType" ,"RealPosType" ,"TaxCredit" ,"PayDate" ,"PayForm" ,"TakeTotalCosts" ,"IsCorrection" ,"SumCC_nt" ,"TaxSum" ,"SumCC_wt" ,"SumCC_nt_20" ,"TaxSum_20" ,"SumCC_nt_0" ,"TaxSum_0" ,"SumCC_nt_Free" ,"TaxSum_Free" ,"SumCC_nt_No" ,"TaxSum_No" ,"DocLinkTypeID" ,"LinkSumCC"  FROM "#_TaxDocs"
SELECT "TJ_Prompt" ,"TJ_RepToolCode" ,"TJ_ToolCode" ,"TJ_ShowDialog" ,"ParentDocCode" ,"ParentChID" ,"ParentDocID" ,"ParentDocDate" ,"TaxDocType" ,"TaxCorrType" ,"ChID" ,"DocID" ,"DocDate" ,"KursMC" ,"OurID" ,"CompID" ,"Notes" ,"CodeID1" ,"CodeID2" ,"CodeID3" ,"CodeID4" ,"CodeID5" ,"IntDocID" ,"StateCode" ,"SrcChID" ,"SrcDocID" ,"SrcDocDate" ,"SrcTaxDocID" ,"SrcTaxDocDate" ,"GOperID" ,"GTranID" ,"GTSum_wt" ,"GTTaxSum" ,"GTAccID" ,"GPosID" ,"GTCorrSum_wt" ,"GTCorrTaxSum" ,"PosType" ,"RealPosType" ,"TaxCredit" ,"PayDate" ,"PayForm" ,"TakeTotalCosts" ,"IsCorrection" ,"SumCC_nt" ,"TaxSum" ,"SumCC_wt" ,"SumCC_nt_20" ,"TaxSum_20" ,"SumCC_nt_0" ,"TaxSum_0" ,"SumCC_nt_Free" ,"TaxSum_Free" ,"SumCC_nt_No" ,"TaxSum_No" ,"DocLinkTypeID" ,"LinkSumCC"  FROM "#_TaxDocs"
SELECT TOP 1 1 FROM sysobjects WHERE xtype = 'p' AND name = 'z_TaxDocs_Save'
SELECT TOP 1 1 FROM sysobjects WHERE xtype = 'p' AND name = 'z_TaxDocs_Save'

exec Elit_TEST_IM..sp_sproc_columns N'z_TaxDocs_Save',NULL,N'Elit_TEST_IM',NULL	sp_sproc_columns	GMS Ѕизнес	maslov	CONST\maslov	32	214	0	23	240	613	2019-12-18 14:44:29.170	2019-12-18 14:44:29.193	

declare @p1 bit
set @p1=1
declare @p2 varchar(255)
set @p2=''
exec "z_TaxDocs_Save" @p1 output,@p2 output
select @p1, @p2	z_TaxDocs_Save

SELECT * FROM #_TaxDocs
SELECT * FROM #_TaxDocs
SELECT COUNT(1) FROM z_DocLinks WITH (NOLOCK) WHERE DocLinkTypeID = 31 and ParentDocCode= 11012 and ParentChID = 200231185
SELECT COUNT(1) FROM z_DocLinks WITH (NOLOCK) WHERE DocLinkTypeID = 31 and ParentDocCode= 11012 and ParentChID = 200231185

*/

/*

SELECT * FROM r_TaxID_TEST
ORDER BY 1
*/
WAITFOR TIME '17:19:30'

DECLARE @i INT = 10
DECLARE @currdate DATETIME2

while(@i != 0)
BEGIN

--set @currdate = SYSDATETIME()

INSERT INTO r_TaxID_TEST(DocDate, OurID, CurrentDate)
values('2019-12-20', 3, SYSDATETIME())
--SELECT GETDATE(), 3, SYSDATETIME()--@currdate
SELECT CONVERT(VARBINARY(256),SYSDATETIME())
set @i = @i - 1
END;

/*
CREATE TRIGGER [dbo].[a_atN_NewDiff_I] ON [dbo].[at_N]
FOR INSERT
AS
/* “риггер вычеслени€ нового смещени€, если новый мес€ц. */
BEGIN
	--≈сли текущий первый день мес€ца больше первого дн€ мес€ца максимальной даты в таблице смещений, то нова€ запись в таблице смещений.
	--IF (SELECT CAST(dbo.zf_GetMonthFirstDay(GETDATE() ) AS DATE) ) > (SELECT TOP 1 CAST(dbo.zf_GetMonthFirstDay(InsertDate) AS DATE) FROM at_TaxDiff ORDER BY InsertDate DESC)
	IF (SELECT CAST(dbo.zf_GetMonthFirstDay('20200101') AS DATE) ) > (SELECT TOP 1 CAST(dbo.zf_GetMonthFirstDay(InsertDate) AS DATE) FROM at_TaxDiff ORDER BY InsertDate DESC)
	BEGIN
		INSERT INTO at_TaxDiff (InsertDate, TaxDiffCoef, ID)
		SELECT SYSDATETIME()
		      ,ISNULL((SELECT TOP 1 ChID FROM at_N ORDER BY ChID DESC),2) - 1
			  ,(SELECT TOP 1 ID + 1 FROM at_TaxDiff ORDER BY InsertDate DESC)
	END;
END;



ALTER PROCEDURE [dbo].[ap_GetBunchOfTaxID] (@DocDate DATE = NULL, @num INT = 0)
AS
/* ¬озвращает заданное в @num количество налоговых номеров,
либо за текущуюю дату (@DocDate = NULL),
либо за указанную дату (@DocDate != NULL).
 */
BEGIN
	DECLARE @b bigint, @VB VARBINARY(8)

	DECLARE @TaxIDs TABLE (TaxID BIGINT)

	WHILE(@num != 0)
	BEGIN

		EXEC [dbo].[af_GetNewBigNum] @ID = @b OUTPUT, @VB = @VB OUTPUT
		
		INSERT INTO @TaxIDs
		SELECT @b

		--«десь нужно вставить данные в b_TExp.

		SET @num = @num - 1;
	END;

	SELECT TaxID FROM @TaxIDs
END

*/