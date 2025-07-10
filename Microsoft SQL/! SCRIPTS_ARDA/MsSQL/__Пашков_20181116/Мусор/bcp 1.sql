--Допустим есть процедура в которой мы объявили переменную

DECLARE @myquery VARCHAR(2000)
DECLARE @result int
declare @cmd  VARCHAR(2000);
declare @query VARCHAR(2000);
declare @FileName VARCHAR(2000);
SET @FileName = 'E:\OT38ElitServer\Import\test\test3.txt';
SELECT @query = SQLText FROM OPENROWSET(BULK N'E:\OT38ElitServer\Import\test\bh__rec.txt', SINGLE_CLOB) AS Document(SQLText)
set @cmd = 'bcp.exe "' + @query + '" queryout "' + @FileName + '" -c  -r "\n"  -T -S s-sql-d4';
SELECT @cmd
EXEC @result = master..xp_cmdshell @cmd;

SELECT @result

IF (@result = 0)
   SELECT 'Успешно'
ELSE
   SELECT N'Ошибка' 




/*
INSERT #temp
SELECT * FROM  OPENROWSET('SQLNCLI', 'Server=s-sql-d4; Trusted_Connection=yes;',
'EXEC ElitR.dbo.t_SaleSrvGetScalesProds 2') AS a
*/