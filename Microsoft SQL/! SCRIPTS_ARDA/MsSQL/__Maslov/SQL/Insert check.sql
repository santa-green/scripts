DECLARE @ChID INT
	   ,@DocID INT = 800025003

SELECT @ChID = ChID FROM t_Sale WHERE DocID = @DocID

INSERT INTO [192.168.174.30].[ElitRTS201].[dbo].t_Sale (ChID, DocID, DocDate, KursMC, OurID, StockID, CompID, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, Discount, Notes, CRID, OperID, CreditID, DocTime, TaxDocID, TaxDocDate, DCardID, EmpID, IntDocID, CashSumCC, ChangeSumCC, CurrID, TSumCC_nt, TTaxSum, TSumCC_wt, StateCode, DeskCode, Visitors, TPurSumCC_nt, TPurTaxSum, TPurSumCC_wt, DocCreateTime, DepID, ClientID, InDocID, ExpTime, DeclNum, DeclDate, BLineID, TRealSum, TLevySum, RemSChId, WPID, DCardChID)
SELECT ChID, DocID, DocDate, KursMC, OurID, StockID, CompID, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, Discount, Notes, CRID, OperID, CreditID, DocTime, TaxDocID, TaxDocDate, DCardID, EmpID, IntDocID, CashSumCC, ChangeSumCC, CurrID, TSumCC_nt, TTaxSum, TSumCC_wt, StateCode, DeskCode, Visitors, TPurSumCC_nt, TPurTaxSum, TPurSumCC_wt, DocCreateTime, DepID, ClientID, InDocID, ExpTime, DeclNum, DeclDate, BLineID, TRealSum, TLevySum, RemSChId, WPID, DCardChID
FROM t_Sale WHERE ChID = @ChID

INSERT INTO [192.168.174.30].[ElitRTS201].[dbo].t_SaleD (ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, SecID, PurPriceCC_nt, PurTax, PurPriceCC_wt, PLID, Discount, DepID, IsFiscal, SubStockID, OutQty, EmpID, CreateTime, ModifyTime, TaxTypeID, RealPrice, RealSum)
SELECT ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, SecID, PurPriceCC_nt, PurTax, PurPriceCC_wt, PLID, Discount, DepID, IsFiscal, SubStockID, OutQty, EmpID, CreateTime, ModifyTime, TaxTypeID, RealPrice, RealSum
FROM t_SaleD WHERE ChID = @ChID

INSERT INTO [192.168.174.30].[ElitRTS201].[dbo].t_SaleC (ChID, SrcPosID, ProdID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, CReasonID, EmpID, CreateTime, ModifyTime)
SELECT ChID, SrcPosID, ProdID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, CReasonID, EmpID, CreateTime, ModifyTime
FROM t_SaleC WHERE ChID = @ChID

INSERT INTO [192.168.174.30].[ElitRTS201].[dbo].t_SaleDLV (ChID, SrcPosID, LevyID, LevySum)
SELECT ChID, SrcPosID, LevyID, LevySum
FROM t_SaleDLV WHERE ChID = @ChID

INSERT INTO [192.168.174.30].[ElitRTS201].[dbo].t_SalePays (ChID, SrcPosID, PayFormCode, SumCC_wt, Notes, POSPayID, POSPayDocID, POSPayRRN, IsFiscal, ChequeText, BServID, PayPartsQty, ContractNo, POSPayText)
SELECT ChID, SrcPosID, PayFormCode, SumCC_wt, Notes, POSPayID, POSPayDocID, POSPayRRN, IsFiscal, ChequeText, BServID, PayPartsQty, ContractNo, POSPayText
FROM t_SalePays WHERE ChID = @ChID

SELECT * FROM [192.168.174.30].[ElitRTS201].[dbo].t_Sale WHERE DocID = 800025003
UNION ALL
SELECT * FROM t_Sale WHERE DocID = 800025003

SELECT * FROM [192.168.174.30].[ElitRTS201].[dbo].t_SaleD WHERE ChID = 800025003
UNION ALL
SELECT * FROM t_SaleD WHERE ChID = 800025003

SELECT * FROM [192.168.174.30].[ElitRTS201].[dbo].t_SaleC WHERE ChID = 800025003
UNION ALL
SELECT * FROM t_SaleC WHERE ChID = 800025003

SELECT * FROM [192.168.174.30].[ElitRTS201].[dbo].t_SaleDLV WHERE ChID = 800025003
UNION ALL
SELECT * FROM t_SaleDLV WHERE ChID = 800025003

SELECT * FROM [192.168.174.30].[ElitRTS201].[dbo].t_SalePays WHERE ChID = 800025003
UNION ALL
SELECT * FROM t_SalePays WHERE ChID = 800025003


--SELECT * FROM t_MonIntRec WHERE ChID = 800025003
/*
--Список локальных серверов

set nocount on

IF OBJECT_ID (N'tempdb..#TmpName', N'U') IS NOT NULL DROP TABLE #TmpName
Create table #TmpName 
(	
[ID] [int] IDENTITY(1,1) NOT NULL,
[CRID] [int] NULL,
[ServerName] [nvarchar](max) NULL,
[Notes] [nvarchar](200) NULL,
)

IF OBJECT_ID (N'tempdb..#TmpResult', N'U') IS NOT NULL DROP TABLE #TmpResult
Create table #TmpResult 
(	
[ID] [int] IDENTITY(1,1) NOT NULL,
[Result] [nvarchar](max) NULL,
[EXCEPT] [int] NULL,
)


INSERT #TmpName ([CRID],[ServerName])
          select 501, '[S-MARKETA].[ElitV_DP].[dbo].' 
union all select 302, '[192.168.157.22].[ElitRTS302].[dbo].'
union all select 301, '[S-MARKETA3].[ElitRTS301].[dbo].'
union all select 220, '[192.168.174.38].[ElitRTS220].[dbo].'
union all select 201, '[192.168.174.30].[ElitRTS201].[dbo].'
union all select 181, '[S-MARKETA4].[ElitRTS181].[dbo].'
union all select 601, '[192.168.42.6].FFood601.dbo.'

--SELECT * FROM #TmpName


--проверка разницы в строках между главной базой и локальными
DECLARE @ServerName nvarchar(max)
DECLARE @SQL nvarchar(max)
DECLARE @TableName nvarchar(200)
DECLARE @MsgOUT nvarchar(200)
DECLARE @EFilterExp nvarchar(max)
DECLARE @result int

DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD
FOR 
SELECT [ServerName] FROM #TmpName GROUP BY [ServerName] 

OPEN CURSOR1
	FETCH NEXT FROM CURSOR1 INTO @ServerName
WHILE @@FETCH_STATUS = 0
BEGIN
	--Script
	DECLARE CURSOR2 CURSOR LOCAL FAST_FORWARD
	FOR 
	SELECT TableName, EFilterExp FROM z_Tables,z_ReplicaTables WHERE z_Tables.TableCode = z_ReplicaTables.TableCode and ReplicaPubCode = 12 
	--and TableName in ('r_Codes1','t_PInP')
	ORDER BY 1

	OPEN CURSOR2
		FETCH NEXT FROM CURSOR2 INTO @TableName,@EFilterExp
	WHILE @@FETCH_STATUS = 0
	BEGIN
		--Script
		SET @SQL = 'SELECT  @out = ''' + @TableName + ''' + char(9) + ''' + @ServerName + @TableName + ''' + char(9) + ''='' + char(9) +   CAST(COUNT(*) as varchar(20))' +
					' FROM (
					  SELECT * FROM ' + @TableName + ' WITH (NOLOCK) ' + isnull(' WHERE ' + @EFilterExp , '') + char(10) + char(13) +
					' EXCEPT
					  SELECT * FROM ' + @ServerName + @TableName + '  WITH (NOLOCK) '  + isnull(' WHERE ' + @EFilterExp , '') +
					' ) m'

		--PRINT @SQL

		EXEC sp_executesql @SQL, N'@out VARCHAR(200) OUT', @MsgOUT OUT

		--PRINT @MsgOUT

		INSERT #TmpResult ([Result]) values (@MsgOUT)

		FETCH NEXT FROM CURSOR2 INTO @TableName,@EFilterExp
	END
	CLOSE CURSOR2
	DEALLOCATE CURSOR2
		
	FETCH NEXT FROM CURSOR1 INTO @ServerName
END
CLOSE CURSOR1
DEALLOCATE CURSOR1

SELECT cast(ID as varchar) + char(9) +  Result FROM #TmpResult where  Result not like '%=	0'

SELECT Result FROM #TmpResult where  Result not like '%=	0'
*/