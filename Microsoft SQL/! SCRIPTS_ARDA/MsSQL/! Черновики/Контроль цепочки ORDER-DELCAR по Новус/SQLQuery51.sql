begin tran
SELECT * FROM at_EDI_reg_files WHERE ChID = 107476

UPDATE dbo.at_EDI_reg_files SET 
CompID = (SELECT MAX(CompID) FROM [s-sql-d4].[elit].dbo.t_Inv WHERE TaxDocID = SUBSTRING(ID, 1, LEN(ID) - 1))
WHERE ChID = 107476

SELECT * FROM at_EDI_reg_files WHERE ChID = 107476 
rollback tran

(SELECT MAX(CompID) FROM [s-sql-d4].[elit].dbo.t_Inv WHERE TaxDocID = SUBSTRING('300702', 1, LEN('300702') - 1))