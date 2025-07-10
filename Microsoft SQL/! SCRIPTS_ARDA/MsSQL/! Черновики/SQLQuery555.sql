select Chid, FileName, N'<?xml version="1.0" encoding="UTF-8"?>' + 
    cast(FileData as nvarchar(max)) 
    from dbo.at_z_FilesExchange WITH(NOLOCK) 
    WHERE Statecode = 402 
    AND FileTypeID = 4 
    AND (SELECT TOP(1) Compid FROM t_inv WHERE REPLACE(REPLACE(Orderid,'_non-alc',''), '_alc','') IN (
    --AND (SELECT TOP(1) Compid FROM t_inv WHERE CASE WHEN Orderid LIKE '%[_]alc' THEN REPLACE(REPLACE(Orderid,'_non-alc',''), '_alc','')ELSE OrderID END IN (
                    FileData.value('(DESADV/ORDERNUMBER)[1]', 'varchar(30)'),
                    FileData.value('(ORDRSP/ORDERNUMBER)[1]', 'varchar(30)'),
                    FileData.value('(INVOICE/ORDERNUMBER)[1]', 'varchar(30)')
                    )
                    ) IN (SELECT RefID FROM r_uni WHERE RefTypeID = 6680134)
    OR (Statecode = 402 AND [FileName] like '%IFTMIN%')


SELECT top(1000) *
FROM dbo.at_z_filesExchange
WHERE 1 = 1
    --and docdate = convert(date, getdate(), 102)
	--and [filename] like '%desadv%'
    and StateCode = 402
ORDER BY doctime DESC

SELECT * FROM r_Uni WHERE RefTypeID = 6680134 and RefID = 7016
SELECT 
    CASE WHEN OrderID LIKE '%[_]alc' THEN REPLACE(REPLACE(OrderID, '_non-alc', ''), '_alc', '') ELSE OrderID END
        FROM t_Inv WHERE OrderID like '%Ord-APR0117939%'
             


dbo.ap_EXITE_Sync
ap_EXITE_ExportDoc

SELECT OrderID, * FROM t_Inv WHERE CompID != 7016 AND (OrderID LIKE '%[_]alc' OR OrderID LIKE '%[_]non-alc')
SELECT DISTINCT(CompID) FROM t_Inv WHERE OrderID LIKE '%[_]alc' OR OrderID LIKE '%[_]non-alc'
SELECT OrderID, * FROM t_Inv WHERE CompID = 7016 AND OrderID NOT LIKE '%[_]non-alc'