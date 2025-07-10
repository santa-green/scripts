BEGIN TRAN;
--INSERT INTO at_z_Contracts (ChID, OurID, DocID, DocDate, ContrTypeID, OffTypeID, ContrID, CompID, BDate, EDate, AddContrID, AddBDate, Status, PackingTermType, VerbalAgreements, IDDirectum)
--SELECT 80000, 3, 102340, GETDATE(), 3, 7, '173-ДНЕ', 73038, GETDATE(), GETDATE(), '173-ДНЕ/150319', GETDATE(), 1, 0, 0, NULL

--UPDATE r_OursCC SET AccountCC = 'UA473071230000026000009000021' WHERE ChID = 43
UPDATE r_OursAC SET AccountAC = 'UA473071230000026000009000020' WHERE ChID = 43
--UPDATE r_OursCC SET Notes = 'ТД Арда-Дистриб.Львов' WHERE ChID = 43
--INSERT INTO [dbo].[b_BankExpCC]
--           ([ChID]
--		   ,[OurID]
--           ,[AccountCC]
--           ,[DocDate]
--           ,[DocID]
--           ,[StockID]
--           ,[CompID]
--           ,[CompAccountCC]
--           ,[SumCC_nt]
--           ,[TaxSum]
--           ,[SumCC_wt]
--           ,[KursMC]
--           ,[Subject]
--           ,[CodeID1]
--           ,[CodeID2]
--           ,[CodeID3]
--           ,[CodeID4]
--           ,[CodeID5]
--           ,[EmpID]
--           ,[TaxDocDate]
--           ,[TaxDocID]
--           ,[GOperID]
--           ,[GTAccID]
--           ,[GTranID]
--           ,[GTSum_wt]
--           ,[GTTaxSum]
--           ,[StateCode]
--           ,[GPosID]
--           ,[GTCorrSum_wt]
--           ,[GTCorrTaxSum]
--           ,[SrcDocID]
--           ,[GTAdvAccID]
--           ,[GTAdvSum_wt]
--           ,[GTCorrAdvSum_wt]
--           ,[GTAdvTaxSum]
--           ,[GTCorrAdvTaxSum])
--     VALUES
--           (1
--		   ,1
--           ,'UA473071230000026000009000021'
--           ,GETDATE()
--           ,11
--           ,4
--           ,70969
--           ,'UA193077700000026004010017681'--'UA193077700000026004010017686'
--           ,2
--           ,1
--           ,1
--           ,27
--           ,'sub'
--           ,1
--           ,2
--           ,3
--           ,4
--           ,5
--           ,0
--           ,GETDATE()
--           ,1
--           ,2
--           ,3
--           ,1
--           ,1
--           ,6
--           ,7
--           ,7
--           ,8
--           ,9
--           ,2
--           ,3
--           ,1
--           ,1
--           ,1
--           ,1)
ROLLBACK TRAN;
--select *
--from INFORMATION_SCHEMA.COLUMNS AS m
--WHERE m.COLUMN_NAME
--SELECT * FROM r_OursAC
/*
SELECT CHARINDEX('UA','53510050000026004327169306')


IF OBJECT_ID (N'tempdb..#temp_table_name',N'U') IS NOT NULL DROP TABLE #temp_table_name
CREATE TABLE #temp_table_name
(row1 INT
 ,row2 VARCHAR(MAX))
 
 INSERT INTO #temp_table_name
 SELECT 1, '2'

SELECT OBJECT_ID('tempdb..#temp_table_name'), OBJECT_NAME(2064990861)

declare @tablename nvarchar(max)
select @tablename = name from tempdb.sys.tables
where object_id = (select object_id('tempdb..#temp_table_name'))

declare @sql nvarchar(max) =
'select * from ' + @tablename
exec (@sql)

SELECT dbo.af_IBAN_validation('UA473071230000026000009000020')

SELECT * FROM at_z_Contracts

SELECT * FROM z_Tables ORDER BY TableDesc;

SELECT * FROM t_Inv
WHERE DocID IN (3154471,3158656,3161284,3162916,3163782,3177521,3179681,3182153,3187601,3191185,3191214)
AND CompID = 7153
ORDER BY 2


BEGIN TRAN;

--UPDATE t_Inv SET address = 'Магазин; Київська обл., Києво-Святошинський р-н., с. Ходосівка, вул. Обухівське шосе, 1,16' WHERE DocID = 3154471
--UPDATE t_Inv SET CompAddID = 3 WHERE DocID IN (3154471,3158656,3161284,3162916,3163782,3177521,3179681,3182153,3187601,3191185,3191214)
--AND CompID = 7153

UPDATE t_Inv SET DriverID = 19 WHERE DocID = 3154471 AND CompID = 7153
UPDATE t_Inv SET DriverID = 1434 WHERE DocID = 3158656 AND CompID = 7153
UPDATE t_Inv SET DriverID = 1560 WHERE DocID = 3161284 AND CompID = 7153
UPDATE t_Inv SET DriverID = 19 WHERE DocID = 3162916 AND CompID = 7153
UPDATE t_Inv SET DriverID = 19 WHERE DocID = 3163782 AND CompID = 7153
UPDATE t_Inv SET DriverID = 1560 WHERE DocID = 3177521 AND CompID = 7153
UPDATE t_Inv SET DriverID = 1587 WHERE DocID = 3179681 AND CompID = 7153
UPDATE t_Inv SET DriverID = 1560 WHERE DocID = 3182153 AND CompID = 7153
UPDATE t_Inv SET DriverID = 1560 WHERE DocID = 3187601 AND CompID = 7153
UPDATE t_Inv SET DriverID = 1560 WHERE DocID = 3191185 AND CompID = 7153
UPDATE t_Inv SET DriverID = 1560 WHERE DocID = 3191214 AND CompID = 7153

SELECT * FROM t_Inv
WHERE DocID IN (3154471,3158656,3161284,3162916,3163782,3177521,3179681,3182153,3187601,3191185,3191214)
AND CompID = 7153
ORDER BY 2
ROLLBACK TRAN;

'Магазин; Київська обл., с. Ходосівка, вул. Обухівське шосе, 1/16'
 Магазин; Київська обл., с. Ходосівка, вул. Обухівське шосе, 1/16
 SELECT * FROM r_Comps
 SELECT * FROM r_CompsAdd
 WHERE CompID = 7153


 SELECT * FROM at_z_Contracts
 WHERE CompID = 70490
 --WHERE CompID = 71588

 SELECT * FROM at_z_ContractsAdd
 WHERE chid IN ( SELECT ChID FROM at_z_Contracts
 WHERE CompID = 70490)

 SELECT * FROM at_z_ContractTerms
 WHERE chid = 77490


SELECT * FROM t_Inv
WHERE DocID IN (3154471,3158656,3161284,3162916,3163782,3177521,3179681,3182153,3187601,3191185,3191214)
AND CompID = 7153
ORDER BY 2


SELECT * FROM Elit.dbo.t_Inv
WHERE DocID IN (3154471,3158656,3161284,3162916,3163782,3177521,3179681,3182153,3187601,3191185,3191214)
AND CompID = 7153
ORDER BY 2
*/
