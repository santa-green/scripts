ALTER PROCEDURE [dbo].[ap_SendEmailUniContracts]
AS
/*��������� ��� ���������� ������ ����������� �� ��������� �� ��������� "������� �������������",
������� ���������� � ��������� �����, � �������� ��������� �� ������������.*/
BEGIN
	/*
	EXEC dbo.ap_SendEmailUniContracts
	*/

--moa0 '2019-10-15 09:10:25.170' ������ ��������, �������������� �� ��������.
--moa0 '2019-11-01 15:36:31.089' ������� ��������, �������������� �� �������.
--Maslov Oleg '2019-12-13 10:40:17.958' ���������� ���������, �������������� �� ��������.
--Maslov Oleg '2020-02-17 10:52:05.497' �������������� ������ �� �������� ������ ����������.
--[ADDED] Maslov Oleg '2020-02-28 15:35:52.675' ������� � �������� ����������� �� ���������� � �������� ����� ��������.

SET NOCOUNT ON --Variable block near.
DECLARE @subject VARCHAR(100)
	   ,@email VARCHAR(1000)
	   ,@dist VARCHAR(1000)
	   ,@send_flag BIT
	   ,@file_name VARCHAR(1000)

IF OBJECT_ID (N'tempdb..#data',N'U') IS NOT NULL DROP TABLE #data
CREATE TABLE #data --� ���� ������� ����� ��������� ������ �� ������.
(OurID INT
 ,CompID INT
 ,CompName VARCHAR(300)
 ,ContrTypeID INT
 ,RefName VARCHAR(300)
 ,BDate SMALLDATETIME
 ,EDate SMALLDATETIME
 ,CompGrID2 INT)

IF OBJECT_ID (N'tempdb..#emails',N'U') IS NOT NULL DROP TABLE #emails
CREATE TABLE #emails --� ���� ������� ����� ��������� ������ email.
(Distr VARCHAR(100)
 ,Email VARCHAR(200)
 ,OurID INT
 ,SendFlag BIT)	--��� ���� ����� ��� ����������� ��������. ���� ���������� ������, �� ���� ��������� ������ 0,
				--���� ������ ����, �� ��� ����� ����������� � 1.

INSERT INTO #emails
SELECT 'DneprUniContr1', 'linskiy@const.dp.ua', 1, 0 UNION ALL
--moa0 '2019-11-01 15:36:31.089' ������� ��������, �������������� �� �������.
--SELECT 'KievUniContr1', 'simonov@const.dp.ua', 1, 0 UNION ALL
SELECT 'KievUniContr1', 'savchukp@const.dp.ua', 1, 0 UNION ALL
SELECT 'LvivUniContr1', 'melnychuk@const.dp.ua', 1, 0 UNION ALL
--Maslov Oleg '2019-12-13 10:40:17.958' ���������� ���������, �������������� �� ��������.
--SELECT 'OdessaUniContr1', 'martynenkon@const.dp.ua', 1, 0 UNION ALL
SELECT 'OdessaUniContr1', 'dragnev@const.dp.ua', 1, 0 UNION ALL
SELECT 'CherkassyUniContr1', 'tarasenko@const.dp.ua', 1, 0 UNION ALL
SELECT 'KharkovUniContr1', 'trofimov@const.dp.ua', 1, 0 UNION ALL
--moa0 '2019-10-15 09:10:25.170' ������ ��������, �������������� �� ��������.
--SELECT 'ZaporizhiaUniContr1', 'dupliy@const.dp.ua', 1, 0 UNION ALL
SELECT 'ZaporizhiaUniContr1', 'belmega@const.dp.ua', 1, 0 UNION ALL
SELECT 'KryvyiRihUniContr1', 'filed@const.dp.ua', 1, 0 UNION ALL
SELECT 'MariupolUniContr1', 'medvedevm@const.dp.ua', 1, 0 UNION ALL
------------------------------------------------------------------------------
SELECT 'DneprUniContr3', 'avramenkoap@const.dp.ua', 3, 0 UNION ALL
SELECT 'KievUniContr3', 'kuznecova@const.dp.ua', 3, 0 UNION ALL
SELECT 'LvivUniContr3', 'bredy@const.dp.ua', 3, 0 UNION ALL
SELECT 'OdessaUniContr3', 'poroshenkova@const.dp.ua', 3, 0 UNION ALL
--Maslov Oleg '2020-02-17 10:52:05.497' �������������� ������ �� �������� ������ ����������.
--SELECT 'KharkovUniContr3', 'dudniksk@const.dp.ua; uzyq3ster@gmail.com', 3, 0
SELECT 'KharkovUniContr3', 'bocharov@const.dp.ua; uzyq3ster@gmail.com', 3, 0 UNION ALL
--[ADDED] Maslov Oleg '2020-02-28 15:35:52.675' ������� � �������� ����������� �� ���������� � �������� ����� ��������.
SELECT 'DneprMarketVUniContr3', 'kolishkin@const.dp.ua', 3, 0

INSERT INTO #data
SELECT m.OurID, m.CompID, rc.CompName, m.ContrTypeID, ru.RefName, m.BDate, m.EDate, rc.CompGrID2
FROM at_z_Contracts m
JOIN r_Comps rc WITH(NOLOCK) ON rc.CompID = m.CompID
JOIN r_Uni ru WITH(NOLOCK) ON ru.RefID = m.ContrTypeID AND ru.RefTypeID = 6660110
WHERE ( m.Status = 1 AND (MONTH(m.EDate) = MONTH(GETDATE()) OR MONTH(m.EDate) = MONTH(GETDATE()) + 1 ) )
	  AND YEAR(m.EDate) = YEAR(GETDATE())
	  AND m.OurID IN (1,3)
ORDER BY 7

------------------------------------------------------------------------------
----------------------���� �������� ������ �� #data � Excel-------------------

------------------------------------------------------------------------------
-----------------------------------����� 1------------------------------------
IF (SELECT COUNT(*) FROM #data WHERE CompGrID2 IN (2031, 2075) AND OurID = 1) >= 1
BEGIN

INSERT INTO OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;IMEX=0;Database=E:\OT38ElitServer\Import\Discounts\DneprUniContr1.xlsx;', 'SELECT * FROM [������$]')
SELECT OurID, CompID, CompName, ContrTypeID, RefName
	  ,CONVERT(VARCHAR(20),BDate,23), CONVERT(VARCHAR(20), EDate,23)
FROM #data
WHERE CompGrID2 IN (2031, 2075) AND OurID = 1 --�����
ORDER BY 4

UPDATE #emails SET SendFlag = 1 WHERE Distr = 'DneprUniContr1'
END;
-----------------------------------����� 1------------------------------------
------------------------------------------------------------------------------

------------------------------------------------------------------------------
------------------------------------���� 1------------------------------------
IF (SELECT COUNT(*) FROM #data WHERE CompGrID2 IN (2030, 2077) AND OurID = 1) >= 1
BEGIN

INSERT INTO OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;IMEX=0;Database=E:\OT38ElitServer\Import\Discounts\KievUniContr1.xlsx;', 'SELECT * FROM [������$]')
SELECT OurID, CompID, CompName, ContrTypeID, RefName
	  ,CONVERT(VARCHAR(20),BDate,23), CONVERT(VARCHAR(20), EDate,23)
FROM #data
WHERE CompGrID2 IN (2030, 2077) AND OurID = 1 --����
ORDER BY 4

UPDATE #emails SET SendFlag = 1 WHERE Distr = 'KievUniContr1'
END;
------------------------------------���� 1------------------------------------
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-----------------------------------����� 1------------------------------------
IF (SELECT COUNT(*) FROM #data WHERE CompGrID2 IN (2035, 2079) AND OurID = 1) >= 1
BEGIN

INSERT INTO OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;IMEX=0;Database=E:\OT38ElitServer\Import\Discounts\LvivUniContr1.xlsx;', 'SELECT * FROM [������$]')
SELECT OurID, CompID, CompName, ContrTypeID, RefName
	  ,CONVERT(VARCHAR(20),BDate,23), CONVERT(VARCHAR(20), EDate,23)
FROM #data
WHERE CompGrID2 IN (2035, 2079) AND OurID = 1 --�����
ORDER BY 4

UPDATE #emails SET SendFlag = 1 WHERE Distr = 'LvivUniContr1'
END;
-----------------------------------����� 1------------------------------------
------------------------------------------------------------------------------

------------------------------------------------------------------------------
----------------------------------������ 1------------------------------------
IF (SELECT COUNT(*) FROM #data WHERE CompGrID2 IN (2034, 2082) AND OurID = 1) >= 1
BEGIN

INSERT INTO OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;IMEX=0;Database=E:\OT38ElitServer\Import\Discounts\OdessaUniContr1.xlsx;', 'SELECT * FROM [������$]')
SELECT OurID, CompID, CompName, ContrTypeID, RefName
	  ,CONVERT(VARCHAR(20),BDate,23), CONVERT(VARCHAR(20), EDate,23)
FROM #data
WHERE CompGrID2 IN (2034, 2082) AND OurID = 1 --������
ORDER BY 4

UPDATE #emails SET SendFlag = 1 WHERE Distr = 'OdessaUniContr1'
END;
----------------------------------������ 1------------------------------------
------------------------------------------------------------------------------

------------------------------------------------------------------------------
--------------------------------�������� 1------------------------------------
IF (SELECT COUNT(*) FROM #data WHERE CompGrID2 IN (2048, 2097) AND OurID = 1) >= 1
BEGIN

INSERT INTO OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;IMEX=0;Database=E:\OT38ElitServer\Import\Discounts\CherkassyUniContr1.xlsx;', 'SELECT * FROM [������$]')
SELECT OurID, CompID, CompName, ContrTypeID, RefName
	  ,CONVERT(VARCHAR(20),BDate,23), CONVERT(VARCHAR(20), EDate,23)
FROM #data
WHERE CompGrID2 IN (2048, 2097) AND OurID = 1 --��������
ORDER BY 4

UPDATE #emails SET SendFlag = 1 WHERE Distr = 'CherkassyUniContr1'
END;
--------------------------------�������� 1------------------------------------
------------------------------------------------------------------------------

------------------------------------------------------------------------------
---------------------------------������� 1------------------------------------
IF (SELECT COUNT(*) FROM #data WHERE CompGrID2 IN (2036, 2090) AND OurID = 1) >= 1
BEGIN

INSERT INTO OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;IMEX=0;Database=E:\OT38ElitServer\Import\Discounts\KharkovUniContr1.xlsx;', 'SELECT * FROM [������$]')
SELECT OurID, CompID, CompName, ContrTypeID, RefName
	  ,CONVERT(VARCHAR(20),BDate,23), CONVERT(VARCHAR(20), EDate,23)
FROM #data
WHERE CompGrID2 IN (2036, 2090) AND OurID = 1 --�������
ORDER BY 4

UPDATE #emails SET SendFlag = 1 WHERE Distr = 'KharkovUniContr1'
END;
---------------------------------������� 1------------------------------------
------------------------------------------------------------------------------

------------------------------------------------------------------------------
--------------------------------��������� 1-----------------------------------
IF (SELECT COUNT(*) FROM #data WHERE CompGrID2 IN (2032, 2076) AND OurID = 1) >= 1
BEGIN

INSERT INTO OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;IMEX=0;Database=E:\OT38ElitServer\Import\Discounts\ZaporizhiaUniContr1.xlsx;', 'SELECT * FROM [������$]')
SELECT OurID, CompID, CompName, ContrTypeID, RefName
	  ,CONVERT(VARCHAR(20),BDate,23), CONVERT(VARCHAR(20), EDate,23)
FROM #data
WHERE CompGrID2 IN (2032, 2076) AND OurID = 1 --���������
ORDER BY 4

UPDATE #emails SET SendFlag = 1 WHERE Distr = 'ZaporizhiaUniContr1'
END;
--------------------------------��������� 1-----------------------------------
------------------------------------------------------------------------------

------------------------------------------------------------------------------
--------------------------------������ ��� 1----------------------------------
IF (SELECT COUNT(*) FROM #data WHERE CompGrID2 IN (2039, 2078) AND OurID = 1) >= 1
BEGIN

INSERT INTO OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;IMEX=0;Database=E:\OT38ElitServer\Import\Discounts\KryvyiRihUniContr1.xlsx;', 'SELECT * FROM [������$]')
SELECT OurID, CompID, CompName, ContrTypeID, RefName
	  ,CONVERT(VARCHAR(20),BDate,23), CONVERT(VARCHAR(20), EDate,23)
FROM #data
WHERE CompGrID2 IN (2039, 2078) AND OurID = 1 --������ ���
ORDER BY 4

UPDATE #emails SET SendFlag = 1 WHERE Distr = 'KryvyiRihUniContr1'
END;
--------------------------------������ ��� 1----------------------------------
------------------------------------------------------------------------------

------------------------------------------------------------------------------
--------------------------------��������� 1-----------------------------------
IF (SELECT COUNT(*) FROM #data WHERE CompGrID2 IN (2052, 2074) AND OurID = 1) >= 1
BEGIN

INSERT INTO OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;IMEX=0;Database=E:\OT38ElitServer\Import\Discounts\MariupolUniContr1.xlsx;', 'SELECT * FROM [������$]')
SELECT OurID, CompID, CompName, ContrTypeID, RefName
	  ,CONVERT(VARCHAR(20),BDate,23), CONVERT(VARCHAR(20), EDate,23)
FROM #data
WHERE CompGrID2 IN (2052, 2074) AND OurID = 1 --���������
ORDER BY 4

UPDATE #emails SET SendFlag = 1 WHERE Distr = 'MariupolUniContr1'
END;
--------------------------------��������� 1-----------------------------------
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-----------------------------------����� 3------------------------------------
IF (SELECT COUNT(*) FROM #data WHERE CompGrID2 IN (2031, 2075) AND OurID = 3) >= 1
BEGIN

INSERT INTO OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;IMEX=0;Database=E:\OT38ElitServer\Import\Discounts\DneprUniContr3.xlsx;', 'SELECT * FROM [������$]')
SELECT OurID, CompID, CompName, ContrTypeID, RefName
	  ,CONVERT(VARCHAR(20),BDate,23), CONVERT(VARCHAR(20), EDate,23)
FROM #data
WHERE CompGrID2 IN (2031, 2075) AND OurID = 3 --�����
ORDER BY 4

UPDATE #emails SET SendFlag = 1 WHERE Distr = 'DneprUniContr3'
END;
-----------------------------------����� 3------------------------------------
------------------------------------------------------------------------------

------------------------------------------------------------------------------
------------------------------------���� 3------------------------------------
IF (SELECT COUNT(*) FROM #data WHERE CompGrID2 IN (2030, 2077) AND OurID = 3) >= 1
BEGIN

INSERT INTO OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;IMEX=0;Database=E:\OT38ElitServer\Import\Discounts\KievUniContr3.xlsx;', 'SELECT * FROM [������$]')
SELECT OurID, CompID, CompName, ContrTypeID, RefName
	  ,CONVERT(VARCHAR(20),BDate,23), CONVERT(VARCHAR(20), EDate,23)
FROM #data
WHERE CompGrID2 IN (2030, 2077) AND OurID = 3 --����
ORDER BY 4

UPDATE #emails SET SendFlag = 1 WHERE Distr = 'KievUniContr3'
END;
------------------------------------���� 3------------------------------------
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-----------------------------------����� 3------------------------------------
IF (SELECT COUNT(*) FROM #data WHERE CompGrID2 IN (2035, 2079) AND OurID = 3) >= 1
BEGIN

INSERT INTO OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;IMEX=0;Database=E:\OT38ElitServer\Import\Discounts\LvivUniContr3.xlsx;', 'SELECT * FROM [������$]')
SELECT OurID, CompID, CompName, ContrTypeID, RefName
	  ,CONVERT(VARCHAR(20),BDate,23), CONVERT(VARCHAR(20), EDate,23)
FROM #data
WHERE CompGrID2 IN (2035, 2079) AND OurID = 3 --�����
ORDER BY 4

UPDATE #emails SET SendFlag = 1 WHERE Distr = 'LvivUniContr3'
END;
-----------------------------------����� 3------------------------------------
------------------------------------------------------------------------------

------------------------------------------------------------------------------
----------------------------------������ 3------------------------------------
IF (SELECT COUNT(*) FROM #data WHERE CompGrID2 IN (2034, 2082) AND OurID = 3) >= 1
BEGIN

INSERT INTO OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;IMEX=0;Database=E:\OT38ElitServer\Import\Discounts\OdessaUniContr3.xlsx;', 'SELECT * FROM [������$]')
SELECT OurID, CompID, CompName, ContrTypeID, RefName
	  ,CONVERT(VARCHAR(20),BDate,23), CONVERT(VARCHAR(20), EDate,23)
FROM #data
WHERE CompGrID2 IN (2034, 2082) AND OurID = 3 --������
ORDER BY 4

UPDATE #emails SET SendFlag = 1 WHERE Distr = 'OdessaUniContr3'
END;
----------------------------------������ 3------------------------------------
------------------------------------------------------------------------------

------------------------------------------------------------------------------
---------------------------------������� 3------------------------------------
IF (SELECT COUNT(*) FROM #data WHERE CompGrID2 IN (2036, 2090) AND OurID = 3) >= 1
BEGIN

INSERT INTO OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;IMEX=0;Database=E:\OT38ElitServer\Import\Discounts\KharkovUniContr3.xlsx;', 'SELECT * FROM [������$]')
SELECT OurID, CompID, CompName, ContrTypeID, RefName
	  ,CONVERT(VARCHAR(20),BDate,23), CONVERT(VARCHAR(20), EDate,23)
FROM #data
WHERE CompGrID2 IN (2036, 2090) AND OurID = 3 --�������
ORDER BY 4

UPDATE #emails SET SendFlag = 1 WHERE Distr = 'KharkovUniContr3'
END;
---------------------------------������� 3------------------------------------
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-----------------------------����� ��������� 3--------------------------------
IF (SELECT COUNT(*) FROM #data WHERE CompID IN (79,80,81,10797,10798) ) >= 1
BEGIN

INSERT INTO OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;IMEX=0;Database=E:\OT38ElitServer\Import\Discounts\DneprMarketVUniContr3.xlsx;', 'SELECT * FROM [������$]')
SELECT OurID, CompID, CompName, ContrTypeID, RefName
	  ,CONVERT(VARCHAR(20),BDate,23), CONVERT(VARCHAR(20), EDate,23)
FROM #data
WHERE CompID IN (79,80,81,10797,10798) --����� ��������� 3
ORDER BY 4

UPDATE #emails SET SendFlag = 1 WHERE Distr = 'DneprMarketVUniContr3'
END;
-----------------------------����� ��������� 3--------------------------------
------------------------------------------------------------------------------

----------------------���� �������� ������ �� #data � Excel-------------------
------------------------------------------------------------------------------

--����� � ����� ���������� �������� email � ����������� �������.
DECLARE Email CURSOR LOCAL FAST_FORWARD 
FOR
SELECT Distr, Email, SendFlag FROM #emails

OPEN Email
	FETCH NEXT FROM Email INTO @dist, @email, @send_flag
WHILE @@FETCH_STATUS = 0	 
BEGIN
SELECT @file_name = 'E:\OT38ElitServer\Import\Discounts\' + @dist + '.xlsx'
	  --,@email = 'maslov@const.dp.ua'--��� ������. ��������� ����� ������������ ������ �� ���� email.

	  --Send message.
	  IF @send_flag = 1
	  BEGIN  
	  
			  BEGIN TRY 

				SET @subject = '�������� �� �����������.'

				EXEC msdb.dbo.sp_send_dbmail  
				@profile_name = 'arda',
				@from_address = '<support_arda@const.dp.ua>',
				@recipients = @email,
				@copy_recipients = 'support_arda@const.dp.ua; tumaliieva@const.dp.ua;',
				--@copy_recipients = 'tumaliieva@const.dp.ua;',
				@subject = @subject,
				@body = '<p>� ����� ������� �������� �����������, ������� ���������� � ��������� �����.</p><p>���������� [S-SQL-D4] JOB ELIT Email for traders ��� 3 (Send email with contracts)</p>',  
				@body_format = 'HTML',
				@file_attachments = @file_name
			 
			  END TRY  
			  BEGIN CATCH
				SELECT  
				ERROR_NUMBER() AS ErrorNumber  
				,ERROR_SEVERITY() AS ErrorSeverity  
				,ERROR_STATE() AS ErrorState  
				,ERROR_PROCEDURE() AS ErrorProcedure  
				,ERROR_LINE() AS ErrorLine  
				,ERROR_MESSAGE() AS ErrorMessage; 
			  END CATCH

		END;

	FETCH NEXT FROM Email INTO @dist, @email, @send_flag
END
CLOSE Email
DEALLOCATE Email

IF OBJECT_ID (N'tempdb..#data',N'U') IS NOT NULL DROP TABLE #data --����������� ������.
IF OBJECT_ID (N'tempdb..#emails',N'U') IS NOT NULL DROP TABLE #emails

END