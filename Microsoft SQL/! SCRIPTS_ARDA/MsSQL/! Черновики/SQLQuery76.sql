SELECT * FROM EDI_docs_control_status

SELECT *
	FROM EDI_docs_control_status
	WHERE edi_COUNT_checkpoint = 500
		and uzd_docs_used = 0
		--AND edi_TIME_checkpoint = '19000101'
		and email_uzd_status = 0



        SELECT *
	FROM EDI_docs_control_status
	WHERE edi_COUNT_checkpoint = 500
		and edi_docs_used = 0
		--AND edi_TIME_checkpoint = '19000101'
		and email_edi_status = 0

        SELECT *
	FROM EDI_docs_control_status
	WHERE edi_COUNT_checkpoint = 500
		and uzd_docs_used = 0
		--AND edi_TIME_checkpoint = '19000101'
		and email_uzd_status = 0


        SELECT *
	FROM EDI_docs_control_status
	WHERE edi_COUNT_checkpoint = 500
		and uzd_docs_used = 0
		--AND edi_TIME_checkpoint = '19000101'
		and email_uzd_status = 0

                UPDATE EDI_docs_control_status
	    SET uzd_docs_used =  675
	    ,   edi_TIME_checkpoint = CURRENT_TIMESTAMP
	    ,   email_uzd_status =   1
	    WHERE edi_COUNT_checkpoint = @uzd_docs_used;

SELECT * FROM at_z_filesExchange WHERE FileName like '%DocumentInvoice%'
20201029190343-20042396400-1-OUT-713600001_COMDOC_ROZETKA.xml
documentinvoice_202001081724_200347162.xml

SELECT COUNT(*) FROM az_EDI_Invoices_
WHERE month(AEI_AUDIT_DATE) = month(getdate())
	and year(AEI_AUDIT_DATE) = year(getdate())

SELECT * FROM az_EDI_Invoices_ WHERE AEI_AUDIT_DATE >= '20210801'

SELECT * FROM at_z_filesExchange 
WHERE FileName like '%[_]invoice%'
and month(DocDate) = month(getdate())
	and year(DocDate) = year(getdate())

SELECT *
FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.at_EDI_reg_files
WHERE [filename] like '%docinvoiceact%'
and month(InsertData) = month(getdate())
	and year(InsertData) = year(getdate())
    ORDER BY lastupdatedata DESC
