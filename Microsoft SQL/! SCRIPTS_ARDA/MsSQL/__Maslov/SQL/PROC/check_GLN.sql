ALTER procedure [dbo].[check_GLN]
as
/*
EXEC check_GLN
*/

DECLARE @code INT = 0

--Подготовка курсора. Выгружаем из элитки актуальные нац сети.
DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD
FOR
SELECT RefID FROM [S-SQL-D4].[Elit].dbo.r_Uni WHERE RefTypeID = 6680116 AND Notes = '1'

OPEN CURSOR1
	FETCH NEXT FROM CURSOR1 INTO @code
WHILE @@FETCH_STATUS = 0		 
BEGIN
		-- Блок созданию временных таблиц.
		IF OBJECT_ID (N'tempdb..#GLNs',N'U') IS NOT NULL DROP TABLE #GLNs
		CREATE TABLE #GLNs (GLN NVARCHAR(MAX) null, Adress NVARCHAR(MAX) NULL)

		IF OBJECT_ID (N'tempdb..#ret',N'U') IS NOT NULL DROP TABLE #ret
		CREATE TABLE #ret (ID NVARCHAR(MAX) null, RetName NVARCHAR(MAX) NULL)

		IF OBJECT_ID (N'tempdb..#GLNsName',N'U') IS NOT NULL DROP TABLE #GLNsName
		CREATE TABLE #GLNsName (GLN NVARCHAR(MAX) null, GLNName NVARCHAR(MAX) NULL)

		IF OBJECT_ID (N'tempdb..#test_path',N'U') IS NOT NULL DROP TABLE #test_path
		CREATE TABLE #test_path
		(test_answer VARCHAR(MAX))

		DECLARE @comand NVARCHAR(500) = 'IF EXIST D:\EDI\GLN\answer\deliveryplaces_adress' + CONVERT(NVARCHAR(100),@code) + '.csv (echo 1) ELSE (echo 0)'
		insert into #test_path
		EXEC xp_cmdshell @comand

		SET @comand = 'IF EXIST D:\EDI\GLN\answer\deliveryplaces_names' + CONVERT(NVARCHAR(100),@code) + '.csv (echo 1) ELSE (echo 0)'
		insert into #test_path
		EXEC xp_cmdshell @comand

		insert into #test_path
		EXEC xp_cmdshell  'IF EXIST D:\EDI\GLN\answer\retailers.csv (echo 1) ELSE (echo 0)'
		
		IF NOT EXISTS(SELECT 1 from #test_path where test_answer is not null and test_answer = 0)
		BEGIN
			--Выгружаем все адреса GLN по нац сети.
			SET @comand = 'BULK INSERT #GLNs FROM ''D:\EDI\GLN\answer\deliveryplaces_adress' + CONVERT(NVARCHAR(100),@code) + '.csv'' WITH (CODEPAGE = 1251, FIELDTERMINATOR = '';'')'
			--DECLARE @comand NVARCHAR(500) = 'BULK INSERT #temp FROM ''E:\OT38ElitServer\Import\GLN\deliveryplaces' + CONVERT(NVARCHAR(100),@code) + '.csv'' WITH (CODEPAGE = 1251, FIELDTERMINATOR = '';'')'
			--BULK INSERT #temp FROM 'G:\Instal\EDI\answer\deliveryplaces9.csv' WITH (CODEPAGE = 1251, FIELDTERMINATOR = ';') 
			EXEC sp_executesql @comand
			--SELECT * FROM #GLNs

			--Выгружаем все названия GLN по нац сети.
			SET @comand = 'BULK INSERT #ret FROM ''D:\EDI\GLN\answer\retailers.csv'' WITH (CODEPAGE = 1251, FIELDTERMINATOR = '';'')'
			EXEC sp_executesql @comand
			--SELECT * FROM #ret

			SET @comand = 'BULK INSERT #GLNsName FROM ''D:\EDI\GLN\answer\deliveryplaces_names' + CONVERT(NVARCHAR(100),@code) + '.csv'' WITH (CODEPAGE = 1251, FIELDTERMINATOR = '';'')'
			EXEC sp_executesql @comand
			--SELECT * FROM #GLNsName

			INSERT INTO at_GLN
			SELECT @code, r.RetName, m.GLN, d.GLNName, SUBSTRING(m.Adress, PATINDEX('%[а-я]%',m.Adress), LEN(m.Adress)), GETDATE(), ''
			FROM #GLNs m
				 JOIN #ret r ON r.ID = @code
				 JOIN #GLNsName d ON d.GLN = m.GLN
			WHERE m.GLN NOT IN (SELECT GLN FROM at_GLN)

		END--IF NOT EXISTS(SELECT 1 from #test_path where test_answer is not null and test_answer = 0)

	FETCH NEXT FROM CURSOR1 INTO @code
END
CLOSE CURSOR1
DEALLOCATE CURSOR1

INSERT INTO [S-SQL-D4].[Elit].dbo.at_GLN (RetailersID, RetailersName, GLN, GLNName, Adress, ImportDate, Notes)
SELECT RetailersID, RetailersName, GLN, GLNName, Adress, ImportDate, Notes FROM at_GLN m
WHERE m.GLN NOT IN (SELECT GLN FROM [S-SQL-D4].[Elit].dbo.at_GLN)
GO
