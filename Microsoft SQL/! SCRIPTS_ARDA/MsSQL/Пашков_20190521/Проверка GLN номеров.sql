
	EXECUTE AS LOGIN = 'pvm0' -- ��� ������� OPENROWSET('Microsoft.ACE.OLEDB.12.0'
	GO
	--REVERT


USE Elit

IF OBJECT_ID (N'tempdb..#tmp', N'U') IS NOT NULL DROP TABLE #tmp


SELECT *
 INTO
#tmp FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\EDI\GLN\������.xlsx' , 'select * from [������$]')

SELECT * FROM #tmp


SELECT * FROM ALEF_EDI_GLN_OT