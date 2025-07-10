	SELECT *
	FROM [S-PPC.CONST.ALEF.UA].[Alef_Elit].[dbo].[at_EDI_reg_files]
	WHERE DocType = 8000
    --and id = 171611
    and [Status]  = 4
    --and id = '60022'
ORDER BY InsertData DESC
	  --AND [Status] IN (1)				    --Новый статус


BEGIN TRAN
	SELECT * FROM [at_EDI_reg_files] WHERE chid = 107945 
	UPDATE [at_EDI_reg_files] SET [status] = 0 WHERE chid = 107945
	SELECT * FROM [at_EDI_reg_files] WHERE chid = 107945 
ROLLBACK TRAN


SELECT * FROM ALEF_EDI_RPL WHERE AER_TAX_ID = 29143
SELECT * FROM [at_EDI_reg_files] WHERE [status] = -2
SELECT * FROM [at_EDI_reg_files] WHERE id = '291434'

