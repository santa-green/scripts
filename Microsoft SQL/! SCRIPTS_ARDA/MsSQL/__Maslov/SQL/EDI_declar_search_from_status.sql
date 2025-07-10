/*
Запустить на S-SQL-D4, база данных - Elit.

*/

DECLARE @comdoc_id VARCHAR(256) = '5114900817'
	
SELECT * FROM at_z_FilesExchange
WHERE ChID IN
(
	SELECT ChildChID FROM z_DocLinks
	WHERE ParentChID IN
	(
		SELECT ChID_Inv FROM
		(
			select AES_FileName,
			(select chid from t_Inv where 
			TaxDocID in  (select AEI_INV_ID from avz_EDI_Invoices where AEI_DOC_ID = AES_DocNumber) and
			TaxDocDate in  (select AEI_INV_DATE from avz_EDI_Invoices where AEI_DOC_ID = AES_DocNumber)
			AND OurID = 1) AS ChID_Inv--2018-10-31 15.51 pvm0 Добавил для ограничивания только по фирме 1
			from [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.ALEF_EDI_STATUS
			where AES_MessageClass = 'COMDOC'
			and (AES_Description like 'Накладна%' or AES_Description like '%обновлен успешно%')
			and AES_Date >='2018-05-05'
			and exists (select * from [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.ALEF_EDI_GLN_SETI where EGS_GLN_ID = AES_FromGLN and EGS_GLN_SETI_ID in (502,505,506,621,610,503,501,982))
			AND AES_FileName IN (SELECT FileName FROM [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files WHERE Notes LIKE '%'+ @comdoc_id +'%')
		)q
	)
	AND ChildDocCode = 666029 -- Номер таблицы at_z_FilesExchange, но это не точно.
)
AND FileName NOT LIKE '%DESADV%'

/*
UPDATE at_z_FilesExchange SET StateCode = 402 WHERE ChID = 74343

*/


/*
SELECT * FROM at_EDI_reg_files
--WHERE id = '5114901264'--'5114901306'
WHERE FileName LIKE '%5114902095%'--'5114901306'
--WHERE notes LIKE '%5114901306%'
--5114900817
--5114900819
ORDER BY 1 DESC


5012432762

[ap_Workflow_Create_Declar] 


*/