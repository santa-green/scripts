SELECT * FROM at_z_FilesExchange 
WHERE [FileName] like '%documentINVOICE%' 
    --AND FileData.value('(./INVOICE/NUMBER)[1]','nvarchar(100)') IN ('31084')
    AND FileData.value('(./Document-Invoice/Invoice-Header/InvoiceNumber)[1]','nvarchar(100)') IN ('3399206')
    --AND FileData.value('(./DECLAR/DECLARBODY/HNUM)[1]','nvarchar(100)') = '28020' 
    --AND FileData.value('(./DECLAR/DECLARHEAD/D_FILL)[1]','nvarchar(100)') like '%062020%'
    and DATEPART(month,docdate) IN (5, 6)
ORDER BY DocTime DESC


SELECT * FROM at_z_FilesExchange 
--WHERE [FileName] like '%j12%' 
WHERE 1 = 1
    --AND FileData.value('(./INVOICE/NUMBER)[1]','nvarchar(100)') IN ('31084')
    AND FileData.value('(./Document-Invoice/Invoice-Header/InvoiceNumber)[1]','nvarchar(100)') IN ('3399206')
    AND FileData.exist('true()') = 1
    --AND FileData.value('(./DECLAR/DECLARBODY/HNUM)[1]','nvarchar(100)') = '28020' 
    --AND FileData.value('(./DECLAR/DECLARHEAD/D_FILL)[1]','nvarchar(100)') like '%062020%'
    --and DATEPART(month,docdate) IN (5, 6)
    and StateCode = 503
ORDER BY DocTime DESC

DECLARE @x XML;  
SET @x='';  
SELECT @x.exist('true()');
SELECT FileData.value('(/DECLAR/DECLARHEAD/SOFTWARE)[1]', 'nvarchar(100)'), * FROM at_z_FilesExchange WHERE ChID = 82721
SELECT FileData.query('DECLAR/DECLARHEAD/SOFTWARE'), * FROM at_z_FilesExchange WHERE ChID = 82721
SELECT FileData.query('.'), * FROM at_z_FilesExchange WHERE ChID = 82721


