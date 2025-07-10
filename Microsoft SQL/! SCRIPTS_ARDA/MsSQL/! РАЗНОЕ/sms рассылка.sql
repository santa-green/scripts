EXECUTE AS LOGIN = 'rkv0' -- для запуска OPENROWSET('Microsoft.ACE.OLEDB.12.0'
	GO

USE ELIT_TEST_IM

BEGIN TRY

IF OBJECT_ID ('Elit_TEST_IM.dbo.PhoneNumbers', 'U') IS NOT NULL
DROP TABLE PhoneNumbers;

IF OBJECT_ID ('Elit_TEST_IM.dbo.BulkSMS', 'U') IS NOT NULL
DROP TABLE BulkSMS;

CREATE TABLE PhoneNumbers (SMSNUM bigint)

--select * from PhoneNumbers
	
INSERT INTO PhoneNumbers	
SELECT * FROM 
OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\Temp\total.xlsx', 'select * from [1$]') as part1

INSERT INTO PhoneNumbers
SELECT * FROM 
OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\Temp\total.xlsx', 'select * from [2$]') as part2

INSERT INTO PhoneNumbers
SELECT * FROM 
OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\Temp\total.xlsx', 'select * from [3$]') as part3

INSERT INTO PhoneNumbers
SELECT * FROM 
OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\Temp\total.xlsx', 'select * from [4$]') as part4


INSERT INTO PhoneNumbers
SELECT * FROM 
OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\Temp\total.xlsx', 'select * from [5$]') as part5
/*
INSERT INTO PhoneNumbers
SELECT * FROM 
OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\Temp\total.xlsx', 'select * from [6$]') as part6

INSERT INTO PhoneNumbers
SELECT * FROM 
OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\Temp\total.xlsx', 'select * from [7$]') as part7
*/

SELECT SMSNUM, COUNT(*) 'ДУБЛИКАТЫ:' FROM PHoneNumbers GROUP BY SMSNUM HAVING count(*) > 1

IF OBJECT_ID ('Elit_TEST_IM.dbo.Bulk_SMS', 'U') IS NOT NULL
DROP TABLE Bulk_SMS;
CREATE TABLE Bulk_SMS (SMSNUM bigint)
--SELECT * FROM Bulk_SMS

--убираем дубликаты
INSERT INTO Bulk_SMS (SMSNUM)
SELECT SMSNUM FROM PHoneNumbers GROUP BY SMSNUM;

/*--TEST
CREATE TABLE Bulk_SMS_test (SMSNUM1 bigint, SMSNUM2 bigint, SMSNUM3 bigint)
SELECT * FROM Bulk_SMS_test*/

--Part 1
WITH Ordered_1 AS 
(
SELECT ROW_NUMBER() OVER (ORDER BY SMSNUM) AS RowNumber, SMSNUM
FROM Bulk_SMS
)
--INSERT INTO Bulk_SMS_test (SMSNUM1)
SELECT SMSNUM 'SMSNUM1' FROM Ordered_1 WHERE RowNumber <= 1000000;

--Part 2
WITH Ordered_2 AS 
(
SELECT ROW_NUMBER() OVER (ORDER BY SMSNUM) AS RowNumber, SMSNUM
FROM Bulk_SMS
)
--INSERT INTO Bulk_SMS_test (SMSNUM2)
SELECT SMSNUM 'SMSNUM2' FROM Ordered_2 WHERE RowNumber BETWEEN 1000001 AND 2000000;

--Part 3
WITH Ordered_3 AS (
SELECT ROW_NUMBER() OVER (ORDER BY SMSNUM) AS RowNumber, SMSNUM
FROM Bulk_SMS
)
--INSERT INTO Bulk_SMS_test (SMSNUM3)
SELECT SMSNUM 'SMSNUM3' FROM Ordered_3 WHERE RowNumber BETWEEN 2000001 AND 3000000;

--Part 4
WITH Ordered_4 AS (
SELECT ROW_NUMBER() OVER (ORDER BY SMSNUM) AS RowNumber, SMSNUM
FROM Bulk_SMS
)
--INSERT INTO Bulk_SMS_test (SMSNUM3)
SELECT SMSNUM 'SMSNUM4' FROM Ordered_4 WHERE RowNumber BETWEEN 3000001 AND 4000000;

--Part 5
WITH Ordered_5 AS 
(
SELECT ROW_NUMBER() OVER (ORDER BY SMSNUM) AS RowNumber, SMSNUM
FROM Bulk_SMS
)
--INSERT INTO Bulk_SMS_test (SMSNUM2)
SELECT SMSNUM 'SMSNUM5' FROM Ordered_5 WHERE RowNumber BETWEEN 4000001 AND 5000000;

/*
--Part 6
WITH Ordered_6 AS (
SELECT ROW_NUMBER() OVER (ORDER BY SMSNUM) AS RowNumber, SMSNUM, NOTES
FROM Bulk_SMS
)
--INSERT INTO Bulk_SMS_test (SMSNUM3)
SELECT SMSNUM 'SMSNUM6' FROM Ordered_6 WHERE RowNumber BETWEEN 5000001 AND 6000000;

--Part 7
WITH Ordered_7 AS (
SELECT ROW_NUMBER() OVER (ORDER BY SMSNUM) AS RowNumber, SMSNUM, NOTES
FROM Bulk_SMS
)
--INSERT INTO Bulk_SMS_test (SMSNUM3)
SELECT SMSNUM 'SMSNUM7' FROM Ordered_7 WHERE RowNumber > 6000000;
*/



/*
CREATE TABLE Bulk_SMS_TEST2 (SMSNUM1 bigint, SMSNUM2 bigint, SMSNUM3 bigint)
SELECT * FROM Bulk_SMS_TEST2
--DROP TABLE Bulk_SMS_TEST2

INSERT INTO Bulk_SMS_TEST2
SELECT * FROM Bulk_SMS_test WHERE SMSNUM1 IS NOT NULL OR SMSNUM2 IS NOT NULL OR SMSNUM3 IS NOT NULL
SELECT * FROM Bulk_SMS_test WHERE dbo.Bulk_SMS_test.SMSNUM2	IS NOT null
*/
END TRY

BEGIN CATCH
	 SELECT
	 ERROR_NUMBER() AS ErrorNumber  
    ,ERROR_SEVERITY() AS ErrorSeverity  
    ,ERROR_STATE() AS ErrorState  
    ,ERROR_PROCEDURE() AS ErrorProcedure  
    ,ERROR_LINE() AS ErrorLine  
    ,ERROR_MESSAGE() AS ErrorMessage; 
END CATCH;

EXEC msdb.dbo.sp_send_dbmail  
    @profile_name = 'main',  
    @recipients = 'rumyantsev@const.dp.ua',  
    @body = 'sms task COMPLETE',  
    @subject = 'sms task COMPLETE' , 	
	@query = 'sp_who',
	@attach_query_result_as_file = 1