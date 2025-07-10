--[dbo].[af_tax_rpl_check] 

DECLARE @list varchar(max) = '18220,18007,18224,18005,18225,18099,18006,19999'

IF OBJECT_ID('tempdb..#taxid_check', 'U') is not null drop table  #taxid_check
CREATE TABLE #taxid_check (taxid int)
INSERT INTO #taxid_check SELECT * FROM dbo.[af_SplitString] (@list, ',')

SELECT * /*AER_TAX_ID, CONVERT(varchar(16), InsertData, 20) 'RPL InsertData', Notes, [Status], LastUpdateData, RetailersID, DocType, CompID,
    AER_RPL_DATE, AER_RPL_STATUS, AER_AUDIT_DATE, AER_FILENAME*/
FROM #taxid_check tic
LEFT JOIN [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.[av_EDI_ALEF_EDI_RPL] rpl ON rpl.aer_tax_id = tic.taxid
left JOIN [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files reg ON reg.id = CAST(rpl.AER_RPL_ID as varchar)
ORDER BY AER_AUDIT_DATE DESC
