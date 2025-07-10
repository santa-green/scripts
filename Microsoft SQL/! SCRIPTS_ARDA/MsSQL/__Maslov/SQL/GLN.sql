BEGIN TRAN;
DECLARE @code INT = 0,
		@codes VARCHAR(256) = '7,9,13,15,17,57,110,141,187,195,246,252,15978,16072,16091,16250,16344,16954,17154,17170,17244,17342,17366,17390'

DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD
FOR
SELECT AValue from zf_FilterToTable(@codes)

OPEN CURSOR1
	FETCH NEXT FROM CURSOR1 INTO @code
WHILE @@FETCH_STATUS = 0		 
BEGIN	
		IF OBJECT_ID (N'tempdb..#temp',N'U') IS NOT NULL DROP TABLE #temp
		CREATE TABLE #temp (GLN NVARCHAR(MAX) null, Adress NVARCHAR(MAX) NULL)
		DECLARE @comand NVARCHAR(500) = 'BULK INSERT #temp FROM ''G:\Instal\EDI\answer\deliveryplaces' + CONVERT(NVARCHAR(100),@code) + '.csv'' WITH (CODEPAGE = 1251, FIELDTERMINATOR = '';'')'
		--DECLARE @comand NVARCHAR(500) = 'BULK INSERT #temp FROM ''E:\OT38ElitServer\Import\GLN\deliveryplaces' + CONVERT(NVARCHAR(100),@code) + '.csv'' WITH (CODEPAGE = 1251, FIELDTERMINATOR = '';'')'
		--BULK INSERT #temp FROM 'G:\Instal\EDI\answer\deliveryplaces9.csv' WITH (CODEPAGE = 1251, FIELDTERMINATOR = ';') 
		EXEC sp_executesql @comand
		--SELECT * FROM #temp

		INSERT INTO at_GLN
		SELECT @code, m.GLN,SUBSTRING(m.Adress, PATINDEX('%[à-ÿ]%',m.Adress), LEN(m.Adress)),GETDATE(),''
		FROM #temp m

	FETCH NEXT FROM CURSOR1 INTO @code
END
CLOSE CURSOR1
DEALLOCATE CURSOR1


SELECT * FROM at_GLN
ROLLBACK TRAN;

/*

EXEC master..xp_cmdshell  'runas /savecred /user:sa G:\Instal\EDI\get_delivery_places.bat'
EXEC master..xp_cmdshell  'G:\Instal\EDI\get_delivery_places.bat'
EXEC master..xp_cmdshell 'ECHO %username%'

EXEC sp_xp_cmdshell_proxy_account 'CONST\vintagednepr1', 'dnepr20191';
GO
RECONFIGURE


execute as login = 'CONST\maslov';
EXEC master..xp_cmdshell 'ECHO %username%'
revert;


SELECT RefID,RefName FROM r_Uni
WHERE RefTypeID = 6680116 AND Notes LIKE '1'


BEGIN TRAN;
UPDATE at_GLN
SET Adress = SUBSTRING(Adress, PATINDEX('%[à-ÿ]%',Adress), LEN(Adress))

SELECT * FROM at_GLN
ROLLBACK TRAN;
*/