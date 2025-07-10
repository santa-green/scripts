SELECT * FROM alef_edi_rpl WHERE AER_TAX_ID = 16017
SELECT * from dbo.af_GetCompInfo('шага')

SELECT GLNCode, * FROM [s-sql-d4].[elit].dbo.r_compsadd WHERE compid = 59318
select EVENTDATA()

--e:\Exite\inbox\comdoc_20210825161840_a7137f4d-c72e-4f06-9237-d47052f8f5de_68698237_007.p7s
select TOP 100 * from dbo.[az_EDI_Invoices_] ORDER BY AEI_AUDIT_DATE DESC
SELECT * FROM ALEF_EDI_RPL WHERE AER_RPL_STATUS = 1
SELECT * FROM af_GetUserInfo('piv11')
SELECT * FROM r_CompsAdd WHERE CompAdd like '%Соборна,17%'
SELECT * from dbo.af_GetCompInfo('72220')
SELECT * FROM r_CompValues WHERE CompID = 49273
SELECT * FROM r_ProdEC where CompID = 72220

SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'az_EDI_Invoices_' ORDER BY ORDINAL_POSITION
SELECT TOP(1) ZEC_KOD_KLN_OT FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.[ALEF_EDI_GLN_OT] p1 WHERE p1.zec_kod_base = '9864066987535'
sp_helptext 'ap_block_notify'
sp_helptext 'ap_block_notify'
sp_helptext 'ap_EDI_Resend_COMDOC_Metro'
select QUOTENAME('hello')
sp_helptext '[ap_EDI_METRO_KPK_Recadv]'
SELECT * FROM af_GetUserInfo('piv11')

SELECT * FROM r_prodec WHERE compid = 70460 
SELECT * FROM t_inv WHERE docid = 3438142
SELECT * FROM t_InvD WHERE ChID = 200545346
SELECT * FROM r_CompsAdd WHERE CompAdd like '%Личаківська%55%'
SELECT * from dbo.af_GetCompInfo('72292')
SELECT * FROM r_ProdEC where CompID = 72292 and ExtProdID = '15916'
SELECT * FROM r_CompValues WHERE CompID = 72292


select SUBSTRING('0000000015916', PATINDEX('%[1-9]%', '0000000015916'), 100)
SELECT CHARINDEX(PATINDEX('[0]', '00000015916'), '00000015916', 1)
SELECT PATINDEX('%[1-9]%', '00000015916')


BEGIN TRAN
	--SELECT * FROM Alef_Elit_TEST.[dbo].[_test1] WHERE id_num = 20 
	UPDATE m
    SET m.Notes = 1111 
    FROM Alef_Elit_TEST.[dbo].[_test1] m
    WHERE m.id_num = 20 
	--SELECT * FROM Alef_Elit_TEST.[dbo].[_test1] WHERE id_num = 20 
ROLLBACK TRAN

SELECT * FROM Alef_Elit_TEST.[dbo].[_test1] WHERE id_num = 20

SELECT top(1000) *
FROM at_EDI_reg_files
WHERE 1 = 1
    --and RetailersID = 17
	--and DocType = 2000
    and id = 'РОЗ10875708'
ORDER BY LastUpdateData DESC
--ORDER BY InsertData DESC

SELECT * FROM ALEF_EDI_RPL WHERE AER_TAX_ID = 3205 ORDER BY AER_AUDIT_DATE DESC
SELECT * FROM ALEF_EDI_RPL WHERE AER_FILENAME like '%3205%' ORDER BY AER_AUDIT_DATE DESC
SELECT * FROM ALEF_EDI_RPL ORDER BY AER_AUDIT_DATE DESC
SELECT * FROM at_EDI_reg_files WHERE [FileName] LIKE '%.rpl' AND [Status] != 0 AND InsertData > '20201112 19:00' ORDER BY InsertData DESC
SELECT * FROM at_EDI_reg_files WHERE [FileName] LIKE '%32000037029549J1201012100003205410920213200.RPL' AND [Status] != 0 AND InsertData > '20201112 19:00' ORDER BY InsertData DESC

BEGIN TRAN
	SELECT * FROM at_EDI_reg_files WHERE [FileName] = '32000037029549J1201012100003205410920213200.RPL' 
	update at_EDI_reg_files set [Status] = 0 WHERE [FileName] = '32000037029549J1201012100003205410920213200.RPL' 
	SELECT * FROM at_EDI_reg_files WHERE [FileName] = '32000037029549J1201012100003205410920213200.RPL' 
ROLLBACK TRAN

