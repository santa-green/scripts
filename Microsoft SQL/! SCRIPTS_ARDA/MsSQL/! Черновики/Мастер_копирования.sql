SELECT (t_IORec_1.ChID)           AS ChID_t_IORec_1_3
,      (t_IORec_1.DocDate)        AS DocDate_t_IORec_1_2
,      (t_IORec_1.CurrID)         AS CurrID_t_IORec_1_1
,      (t_IORec_1.KursMC)         AS KursMC_t_IORec_1_4
,      (t_IORec_1.CompID)         AS CompID_t_IORec_1_5
,      (t_IORec_1.CodeID1)        AS CodeID1_t_IORec_1_6
,      (t_IORec_1.CodeID2)        AS CodeID2_t_IORec_1_7
,      (t_IORec_1.CodeID3)        AS CodeID3_t_IORec_1_8
,      (t_IORec_1.CodeID4)        AS CodeID4_t_IORec_1_9
,      (t_IORec_1.CodeID5)        AS CodeID5_t_IORec_1_10
,      (t_IORec_1.StockID)        AS StockID_t_IORec_1_11
,      (t_IORec_1.OurID)          AS OurID_t_IORec_1_12
,      (t_IORec_1.Address)        AS Address_t_IORec_1_13
,      (t_IORec_1.InDocID)        AS InDocID_t_IORec_1_14
,      (t_IORec_1.OrderID)        AS OrderID_t_IORec_1_15
,      (t_IORec_1.DelivID)        AS DelivID_t_IORec_1_16
,      (t_IORec_1.SupplyDayCount) AS SupplyDayCount_t_IORec_1_17
,      (t_IORec_1.TSumCC_wt)      AS TSumCC_wt_t_IORec_1_18
,      (t_IORec_1.PayDelay)       AS PayDelay_t_IORec_1_19
,      (t_IORec_1.Notes)          AS Notes_t_IORec_1_20
,      (t_IORec_1.Discount)       AS Discount_t_IORec_1_21
,      (t_IORec_1.StateCode)      AS StateCode_t_IORec_1_22
,      (t_IORec_1.PayConditionID) AS PayConditionID_t_IORec_1_23
,      (t_IORecD_7.ChID)          AS ChID_t_IORecD_7_1
,      (t_IORecD_7.Qty)           AS Qty_t_IORecD_7_2
,      (t_IORecD_7.NewQty)        AS NewQty_t_IORecD_7_3
,      (t_IORecD_7.NewSumCC_nt)   AS NewSumCC_nt_t_IORecD_7_4
,      (t_IORecD_7.NewTaxSum)     AS NewTaxSum_t_IORecD_7_5
,      (t_IORecD_7.NewSumCC_wt)   AS NewSumCC_wt_t_IORecD_7_6
,      (t_IORecD_7.RemQty)        AS RemQty_t_IORecD_7_7
,      (t_IORecD_7.SumCC_wt)      AS SumCC_wt_t_IORecD_7_8
,      (t_IORecD_7.ProdID)        AS ProdID_t_IORecD_7_9
,      (t_IORecD_7.PriceCC_wt)    AS PriceCC_wt_t_IORecD_7_10
FROM       t_IORec  AS t_IORec_1 
INNER JOIN t_IORecD AS t_IORecD_7 ON (t_IORecD_7.ChID =t_IORec_1. ChID)
WHERE ((t_IORec_1.ChID)=102383855)
ORDER BY (t_IORec_1.DocDate)
,        (t_IORec_1.CurrID)
,        (t_IORec_1.KursMC)
,        (t_IORec_1.CompID)
,        (t_IORec_1.CodeID1)
,        (t_IORec_1.CodeID2)
,        (t_IORec_1.CodeID3)
,        (t_IORec_1.CodeID4)
,        (t_IORec_1.CodeID5)
,        (t_IORec_1.StockID)
,        (t_IORec_1.OurID)
,        (t_IORec_1.Address)
,        (t_IORec_1.InDocID)
,        (t_IORec_1.OrderID)
,        (t_IORec_1.DelivID)
,        (t_IORec_1.SupplyDayCount)
,        (t_IORec_1.PayDelay)
,        (t_IORec_1.Notes)
,        (t_IORec_1.Discount)
,        (t_IORec_1.StateCode)
,        (t_IORec_1.PayConditionID)
----------------------------------------


SELECT * FROM at_t_IORes WHERE chid = 102383855
SELECT * FROM at_t_IOResD WHERE chid = 102383855
SELECT * FROM at_t_IORes WHERE docid = 6143 --102383855

SELECT InDocID, * FROM at_t_IORes WHERE DocID = 6143
UPDATE at_t_IORes SET InDocID = DocID WHERE InDocID = 102383855 
SELECT InDocID, * FROM at_t_IORes WHERE DocID = 6143

SELECT * FROM at_t_IOResD WHERE ChID = 101733131

SELECT * FROM  z_WCopy
SELECT * FROM  z_WCopyF
SELECT * FROM  z_WCopyT WHERE AChID=394
SELECT * FROM  z_WCopyFF
SELECT * FROM  z_WCopyUV
SET SHOWPLAN_XML Off
SELECT @@SPID;
SELECT SYSTEM_USER
select [name] from sys.schemas where lower([name]) = 'z_getintdocid'
select SERVERPROPERTY(N'servername')
SELECT MAX(DocID) FROM at_t_IORes WHERE DocID BETWEEN 1 AND 2147483647 AND OurID = 11
SELECT FieldPosID, FieldName, FieldDesc, UserField, AskFilter, FieldSortPosID, SortType FROM z_WCopyF WHERE AChID=394 ORDER BY FieldSortPosID

SELECT m.AChID, m.VariantPosID, m.AskFilter, m.UVarPosID, m.VarDesc, d.FieldFilterUser  FROM z_WCopyFV m INNER JOIN z_WCopyFVUF d ON (d.AChID=m.AChID AND d.FieldPosID=m.FieldPosID AND d.VariantPosID=m.VariantPosID) WHERE m.AChID=400 AND m.FieldPosID=10 AND m.UseDefault<>0 AND d.UserID=2106

SELECT * FROM r_Comps WHERE CompID=10797
z_GetIntDocID

EXEC z_GetIntDocID 666004001, '(SELECT NULL AS ChID, 6137 AS DocID, ''6137'' AS IntDocID, ''2021-07-06T00:00:00'' AS DocDate, 28.00 AS KursMC, 11 AS OurID, ''"МАРКЕТ-ВИН" Общество с ограниченной ответственностью'' AS OurName, 4 AS StockID, ''Склад №11  м.Дніпро, вул. Березинська, 80'' AS StockName, 0 AS CompID, ''Нет Предприятия'' AS CompName, 0 AS CodeID1, ''Нет признака 1'' AS CodeName1, 0 AS CodeID2, ''Нет признака 2'' AS CodeName2, 0 AS CodeID3, ''Нет признака 3'' AS CodeName3, 0 AS CodeID4, ''Нет признака 4'' AS CodeName4, 0 AS CodeID5, ''Нет признака 5'' AS CodeName5, 7131 AS EmpID, ''Румянцев Кирилл Валериевич'' AS EmpName, 0.00 AS Discount, '''' AS Notes, 2 AS CurrID, ''UAH'' AS CurrName, 0 AS PayDelay, 0 AS StateCode, ''Нет статуса'' AS StateName, 1 AS InDocID, 1 AS ReserveProds, NULL AS Separator1, NULL AS Separator2, 0 AS PayConditionID, '''' AS OrderID, '''' AS Address, 0 AS DelivID, 0 AS SupplyDayCount, ''Нет условий оплаты'' AS PayConditionName) AS at_t_IORes'

exec sp_executesql N'SELECT
  TTaxSum,
  TSumCC_nt,
  TSumCC_wt
FROM
at_t_IORes WHERE ChID=@P1',N'@P1 bigint', @P1 = 101733134

SELECT
  TTaxSum,
  TSumCC_nt,
  TSumCC_wt
FROM
at_t_IORes WHERE ChID=101733134

SELECT m.AChID, m.VariantPosID, m.AskFilter, m.UVarPosID, m.VarDesc, d.FieldFilterUser  FROM z_WCopyFV m INNER JOIN z_WCopyFVUF d ON (d.AChID=m.AChID AND d.FieldPosID=m.FieldPosID AND d.VariantPosID=m.VariantPosID) WHERE m.AChID=400 AND m.FieldPosID=10 AND m.UseDefault<>0 AND d.UserID=2106

SELECT * FROM z_WCopyFVUF WHERE AChID=400
SELECT * FROM z_WCopyFV WHERE AChID=400

SELECT (t_IORec_1.ChID)           AS ChID_t_IORec_1_3
,      (t_IORec_1.DocDate)        AS DocDate_t_IORec_1_2
,      (t_IORec_1.CurrID)         AS CurrID_t_IORec_1_1
,      (t_IORec_1.KursMC)         AS KursMC_t_IORec_1_4
,      (t_IORec_1.CompID)         AS CompID_t_IORec_1_5
,      (t_IORec_1.CodeID1)        AS CodeID1_t_IORec_1_6
,      (t_IORec_1.CodeID2)        AS CodeID2_t_IORec_1_7
,      (t_IORec_1.CodeID3)        AS CodeID3_t_IORec_1_8
,      (t_IORec_1.CodeID4)        AS CodeID4_t_IORec_1_9
,      (t_IORec_1.CodeID5)        AS CodeID5_t_IORec_1_10
,      (t_IORec_1.StockID)        AS StockID_t_IORec_1_11
,      (t_IORec_1.OurID)          AS OurID_t_IORec_1_12
,      (t_IORec_1.Address)        AS Address_t_IORec_1_13
,      (t_IORec_1.InDocID)        AS InDocID_t_IORec_1_14
,      (t_IORec_1.DelivID)        AS DelivID_t_IORec_1_16
,      (t_IORec_1.SupplyDayCount) AS SupplyDayCount_t_IORec_1_17
,      (t_IORec_1.PayDelay)       AS PayDelay_t_IORec_1_19
,      (t_IORec_1.Notes)          AS Notes_t_IORec_1_20
,      (t_IORec_1.Discount)       AS Discount_t_IORec_1_21
,      (t_IORec_1.StateCode)      AS StateCode_t_IORec_1_22
,      (t_IORec_1.PayConditionID) AS PayConditionID_t_IORec_1_23
,      (t_IORecD_7.Qty)           AS Qty_t_IORecD_7_2
,      (t_IORecD_7.NewQty)        AS NewQty_t_IORecD_7_3
,      (t_IORecD_7.NewSumCC_nt)   AS NewSumCC_nt_t_IORecD_7_4
,      (t_IORecD_7.NewTaxSum)     AS NewTaxSum_t_IORecD_7_5
,      (t_IORecD_7.NewSumCC_wt)   AS NewSumCC_wt_t_IORecD_7_6
,      (t_IORecD_7.RemQty)        AS RemQty_t_IORecD_7_7
,      (t_IORecD_7.SumCC_wt)      AS SumCC_wt_t_IORecD_7_8
,      (t_IORecD_7.ProdID)        AS ProdID_t_IORecD_7_9
,      (t_IORecD_7.PriceCC_wt)    AS PriceCC_wt_t_IORecD_7_10
FROM       t_IORec  AS t_IORec_1 
INNER JOIN t_IORecD AS t_IORecD_7 ON (t_IORecD_7.ChID =t_IORec_1. ChID)
WHERE ((t_IORec_1.ChID)=102383855)
	AND ((t_IORec_1.ChID)=102383855)
ORDER BY (t_IORec_1.ChID)
,        (t_IORec_1.DocDate)
,        (t_IORec_1.CurrID)
,        (t_IORec_1.KursMC)
,        (t_IORec_1.CompID)
,        (t_IORec_1.CodeID1)
,        (t_IORec_1.CodeID2)
,        (t_IORec_1.CodeID3)
,        (t_IORec_1.CodeID4)
,        (t_IORec_1.CodeID5)
,        (t_IORec_1.StockID)
,        (t_IORec_1.OurID)
,        (t_IORec_1.Address)
,        (t_IORec_1.InDocID)
,        (t_IORec_1.DelivID)
,        (t_IORec_1.SupplyDayCount)
,        (t_IORec_1.PayDelay)
,        (t_IORec_1.Notes)
,        (t_IORec_1.Discount)
,        (t_IORec_1.StateCode)
,        (t_IORec_1.PayConditionID)
----------------------------------------

z_WCopyU,z_WCopyT,z_WCopyP,z_WCopyFVUF,z_WCopyFV,z_WCopyFUF,z_WCopyFF,z_WCopyF,z_WCopyDV,z_WCopyDF,z_WCopyD,z_WCopy,z_WCopyUV
SELECT * FROM [s-sql-d4].Elit_test.dbo.z_tables WHERE tableName LIKE '%t_Exc%' OR tableDesc LIKE '%t_Exc%'
exec sp_pkeys 't_ExcSpends'

SELECT ScBeforeRun, ScAfterRun, * FROM z_WCopy WHERE cast(ScBeforeRun as varchar(max)) <> ('') or cast(ScAfterRun as varchar(max)) <> ('')

SELECT ScBeforeRun, ScAfterRun, * FROM z_WCopy WHERE cast(ScBeforeRun as varchar(max)) not in ('') --or ScAfterRun not in ('')
SELECT ScBeforeRun, ScAfterRun, * FROM z_WCopy WHERE '' not in (cast(ScBeforeRun as varchar(max)), cast(ScAfterRun as varchar(max)))

SELECT * FROM t_exc WHERE DocID = 397879
SELECT * FROM at_t_IORes WHERE DocID = 1125351666
