SELECT top(1000) *
FROM at_EDI_reg_files
WHERE 1 = 1
    --and RetailersID = 17
	--and DocType = 2000
	and ID = '80042'
    --and Notes = '45360521'
ORDER BY LastUpdateData DESC
--ORDER BY InsertData DESC

SELECT * FROM ALEF_EDI_RPL WHERE aer_tax_id = 8004

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHECKPOINT*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT top(1000) *
FROM at_EDI_reg_files
WHERE 1 = 1
    --and RetailersID = 17
	--and DocType = 2000
	and ID = '130042'
    --and Notes = '45360521'
ORDER BY LastUpdateData DESC
--ORDER BY InsertData DESC

SELECT * FROM ALEF_EDI_RPL WHERE aer_tax_id = 8004 ORDER BY AER_RPL_DATE DESC
SELECT * FROM at_EDI_reg_files WHERE FileName like '%rpl%' ORDER BY InsertData DESC