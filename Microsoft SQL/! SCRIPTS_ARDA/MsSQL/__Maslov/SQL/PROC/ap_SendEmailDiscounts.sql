ALTER PROCEDURE [dbo].[ap_SendEmailDiscounts]
AS
/*Процедура для наполнения файлов информацией про акции, которые закончатся в ближайшее время,
и отправки сообщений по дистрибуциям.*/
BEGIN
	/*
	EXEC dbo.ap_SendEmailDiscounts
	*/

--moa0 '2019-10-15 09:10:25.170' Дуплий уволился, перенаправляем на Бельмегу.
--moa0 '2019-11-01 15:36:31.089' Симонов уволился, перенаправляем на Савчука.
--Maslov Oleg '2019-12-13 10:40:17.958' Мартыненко уволилась, перенаправляем на Драгнева.

SET NOCOUNT ON --Variable block near.
DECLARE @subject VARCHAR(100)
	   ,@email VARCHAR(1000)
	   ,@dist VARCHAR(1000)
	   ,@send_flag BIT
	   ,@file_name VARCHAR(1000)

IF OBJECT_ID (N'tempdb..#data',N'U') IS NOT NULL DROP TABLE #data
CREATE TABLE #data --В этой таблице будут храниться данные по акциям.
(DiscCode INT
 ,DiscName VARCHAR(300)
 ,BDate SMALLDATETIME
 ,EDate SMALLDATETIME
 ,CompID INT
 ,CompName VARCHAR(300)
 ,CompGrID2 INT)

IF OBJECT_ID (N'tempdb..#emails',N'U') IS NOT NULL DROP TABLE #emails
CREATE TABLE #emails --В этой таблице будут храниться адреса email начальников отдела продаж по дистрибуциям.
(Distr VARCHAR(100)
 ,Email VARCHAR(200)
 ,SendFlag BIT)	--Это поле нужно для обозначения отправки. Если отправлять нечего, то поле останется равным 0,
				--если данные есть, то оно будет установлено в 1.

INSERT INTO #emails
SELECT 'Dnepr', 'linskiy@const.dp.ua', 0 UNION ALL
--moa0 '2019-11-01 15:36:31.089' Симонов уволился, перенаправляем на Савчука.
--SELECT 'Kiev', 'simonov@const.dp.ua', 0 UNION ALL
SELECT 'Kiev', 'savchukp@const.dp.ua', 0 UNION ALL
SELECT 'Lviv', 'melnychuk@const.dp.ua', 0 UNION ALL
--Maslov Oleg '2019-12-13 10:40:17.958' Мартыненко уволилась, перенаправляем на Драгнева.
--SELECT 'Odessa', 'martynenkon@const.dp.ua', 0 UNION ALL
SELECT 'Odessa', 'dragnev@const.dp.ua', 0 UNION ALL
SELECT 'Cherkassy', 'tarasenko@const.dp.ua', 0 UNION ALL
SELECT 'Kharkov', 'trofimov@const.dp.ua', 0 UNION ALL
--moa0 '2019-10-15 09:10:25.170' Дуплий уволился, перенаправляем на Бельмегу.
--SELECT 'Zaporizhia', 'dupliy@const.dp.ua', 0 UNION ALL
SELECT 'Zaporizhia', 'belmega@const.dp.ua', 0 UNION ALL
SELECT 'KryvyiRih', 'filed@const.dp.ua', 0 UNION ALL
SELECT 'Mariupol', 'medvedevm@const.dp.ua', 0

INSERT INTO #data
SELECT DISTINCT
	   m.DiscCode, m.DiscName
	  ,m.BDate, m.EDate
	  ,rc.CompID, rc.CompName, rc.CompGrID2
FROM at_r_Discs m
LEFT JOIN at_r_DiscComps ardc WITH(NOLOCK) ON ardc.DiscCode = m.DiscCode
LEFT JOIN r_Comps rc WITH(NOLOCK) ON rc.CompID = ardc.CompID
WHERE ardc.Active = 1	--Фильтр активной акции.
  AND m.StateCode = 181	--181 - акция активна; 182 - акция завершена;
  AND GETDATE() BETWEEN m.BDate AND m.EDate	--Если акция работает прямо сейчас.
  AND (MONTH(GETDATE()) = MONTH(m.EDate) OR MONTH(GETDATE()) + 1 = MONTH(m.EDate) ) --Если акция закончится в этом или следующем месяце.
  AND YEAR(GETDATE()) = YEAR(m.EDate) --Текущи год.
  ORDER BY 4

------------------------------------------------------------------------------
----------------------Блок выгрузки данных из #data в Excel-------------------

------------------------------------------------------------------------------
-----------------------------------Днепр--------------------------------------
IF (SELECT COUNT(*) FROM #data WHERE CompGrID2 IN (2031, 2075) ) >= 1
BEGIN

INSERT INTO OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;IMEX=0;Database=E:\OT38ElitServer\Import\Discounts\Dnepr.xlsx;', 'SELECT * FROM [Данные$]')
SELECT DiscCode, DiscName
	  ,CONVERT(VARCHAR(20),BDate,23), CONVERT(VARCHAR(20), EDate,23)
	  ,CompID, CompName
FROM #data
WHERE CompGrID2 IN (2031, 2075) --Днепр
ORDER BY 4

UPDATE #emails SET SendFlag = 1 WHERE Distr = 'Dnepr'
END;
-----------------------------------Днепр--------------------------------------
------------------------------------------------------------------------------

------------------------------------------------------------------------------
------------------------------------Киев--------------------------------------
IF (SELECT COUNT(*) FROM #data WHERE CompGrID2 IN (2030, 2077) ) >= 1
BEGIN

INSERT INTO OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;IMEX=0;Database=E:\OT38ElitServer\Import\Discounts\Kiev.xlsx;', 'SELECT * FROM [Данные$]')
SELECT DiscCode, DiscName
	  ,CONVERT(VARCHAR(20),BDate,23), CONVERT(VARCHAR(20), EDate,23)
	  ,CompID, CompName
FROM #data
WHERE CompGrID2 IN (2030, 2077) --Киев
ORDER BY 4

UPDATE #emails SET SendFlag = 1 WHERE Distr = 'Kiev'
END;
------------------------------------Киев--------------------------------------
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-----------------------------------Львов--------------------------------------
IF (SELECT COUNT(*) FROM #data WHERE CompGrID2 IN (2035, 2079) ) >= 1
BEGIN

INSERT INTO OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;IMEX=0;Database=E:\OT38ElitServer\Import\Discounts\Lviv.xlsx;', 'SELECT * FROM [Данные$]')
SELECT DiscCode, DiscName
	  ,CONVERT(VARCHAR(20),BDate,23), CONVERT(VARCHAR(20), EDate,23)
	  ,CompID, CompName
FROM #data
WHERE CompGrID2 IN (2035, 2079) --Львов
ORDER BY 4

UPDATE #emails SET SendFlag = 1 WHERE Distr = 'Lviv'
END;
-----------------------------------Львов--------------------------------------
------------------------------------------------------------------------------

------------------------------------------------------------------------------
----------------------------------Одесса--------------------------------------
IF (SELECT COUNT(*) FROM #data WHERE CompGrID2 IN (2034, 2082) ) >= 1
BEGIN

INSERT INTO OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;IMEX=0;Database=E:\OT38ElitServer\Import\Discounts\Odessa.xlsx;', 'SELECT * FROM [Данные$]')
SELECT DiscCode, DiscName
	  ,CONVERT(VARCHAR(20),BDate,23), CONVERT(VARCHAR(20), EDate,23)
	  ,CompID, CompName
FROM #data
WHERE CompGrID2 IN (2034, 2082) --Одесса
ORDER BY 4

UPDATE #emails SET SendFlag = 1 WHERE Distr = 'Odessa'
END;
----------------------------------Одесса--------------------------------------
------------------------------------------------------------------------------

------------------------------------------------------------------------------
--------------------------------Черкассы--------------------------------------
IF (SELECT COUNT(*) FROM #data WHERE CompGrID2 IN (2048, 2097) ) >= 1
BEGIN

INSERT INTO OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;IMEX=0;Database=E:\OT38ElitServer\Import\Discounts\Cherkassy.xlsx;', 'SELECT * FROM [Данные$]')
SELECT DiscCode, DiscName
	  ,CONVERT(VARCHAR(20),BDate,23), CONVERT(VARCHAR(20), EDate,23)
	  ,CompID, CompName
FROM #data
WHERE CompGrID2 IN (2048, 2097) --Черкассы
ORDER BY 4

UPDATE #emails SET SendFlag = 1 WHERE Distr = 'Cherkassy'
END;
--------------------------------Черкассы--------------------------------------
------------------------------------------------------------------------------

------------------------------------------------------------------------------
---------------------------------Харьков--------------------------------------
IF (SELECT COUNT(*) FROM #data WHERE CompGrID2 IN (2036, 2090) ) >= 1
BEGIN

INSERT INTO OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;IMEX=0;Database=E:\OT38ElitServer\Import\Discounts\Kharkov.xlsx;', 'SELECT * FROM [Данные$]')
SELECT DiscCode, DiscName
	  ,CONVERT(VARCHAR(20),BDate,23), CONVERT(VARCHAR(20), EDate,23)
	  ,CompID, CompName
FROM #data
WHERE CompGrID2 IN (2036, 2090) --Харьков
ORDER BY 4

UPDATE #emails SET SendFlag = 1 WHERE Distr = 'Kharkov'
END;
---------------------------------Харьков--------------------------------------
------------------------------------------------------------------------------

------------------------------------------------------------------------------
--------------------------------Запорожье-------------------------------------
IF (SELECT COUNT(*) FROM #data WHERE CompGrID2 IN (2032, 2076) ) >= 1
BEGIN

INSERT INTO OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;IMEX=0;Database=E:\OT38ElitServer\Import\Discounts\Zaporizhia.xlsx;', 'SELECT * FROM [Данные$]')
SELECT DiscCode, DiscName
	  ,CONVERT(VARCHAR(20),BDate,23), CONVERT(VARCHAR(20), EDate,23)
	  ,CompID, CompName
FROM #data
WHERE CompGrID2 IN (2032, 2076) --Запорожье
ORDER BY 4

UPDATE #emails SET SendFlag = 1 WHERE Distr = 'Zaporizhia'
END;
--------------------------------Запорожье-------------------------------------
------------------------------------------------------------------------------

------------------------------------------------------------------------------
--------------------------------Кривой Рог------------------------------------
IF (SELECT COUNT(*) FROM #data WHERE CompGrID2 IN (2039, 2078) ) >= 1
BEGIN

INSERT INTO OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;IMEX=0;Database=E:\OT38ElitServer\Import\Discounts\KryvyiRih.xlsx;', 'SELECT * FROM [Данные$]')
SELECT DiscCode, DiscName
	  ,CONVERT(VARCHAR(20),BDate,23), CONVERT(VARCHAR(20), EDate,23)
	  ,CompID, CompName
FROM #data
WHERE CompGrID2 IN (2039, 2078) --Кривой Рог
ORDER BY 4

UPDATE #emails SET SendFlag = 1 WHERE Distr = 'KryvyiRih'
END;
--------------------------------Кривой Рог------------------------------------
------------------------------------------------------------------------------

------------------------------------------------------------------------------
---------------------------------Мариуполь------------------------------------
IF (SELECT COUNT(*) FROM #data WHERE CompGrID2 IN (2052, 2074) ) >= 1
BEGIN

INSERT INTO OPENROWSET('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;IMEX=0;Database=E:\OT38ElitServer\Import\Discounts\Mariupol.xlsx;', 'SELECT * FROM [Данные$]')
SELECT DiscCode, DiscName
	  ,CONVERT(VARCHAR(20),BDate,23), CONVERT(VARCHAR(20), EDate,23)
	  ,CompID, CompName
FROM #data
WHERE CompGrID2 IN (2052, 2074) --Мариуполь
ORDER BY 4

UPDATE #emails SET SendFlag = 1 WHERE Distr = 'Mariupol'
END;
---------------------------------Мариуполь------------------------------------
------------------------------------------------------------------------------

----------------------Блок выгрузки данных из #data в Excel-------------------
------------------------------------------------------------------------------

--Далее в цикле происходит отправка email с подвязаными файлами.
DECLARE Email CURSOR LOCAL FAST_FORWARD 
FOR
SELECT Distr, Email, SendFlag FROM #emails

OPEN Email
	FETCH NEXT FROM Email INTO @dist, @email, @send_flag
WHILE @@FETCH_STATUS = 0	 
BEGIN
SELECT @file_name = 'E:\OT38ElitServer\Import\Discounts\' + @dist + '.xlsx'
	  --,@email = 'maslov@const.dp.ua'--Для тестов. Сообщения будут отправляться только на этот email.
	  --Send message.
	  IF @send_flag = 1
	  BEGIN  
	  
			  BEGIN TRY 

				SET @subject = 'Акции по дистрибуции.'

				EXEC msdb.dbo.sp_send_dbmail  
				@profile_name = 'arda',
				@from_address = '<support_arda@const.dp.ua>',
				@recipients = @email,
				@copy_recipients = 'support_arda@const.dp.ua; tumaliieva@const.dp.ua;',
				@subject = @subject,
				@body = '<p>В файле указаны акции предприятий, которые закончатся в ближайшее время.</p><p>Отправлено [S-SQL-D4] JOB ELIT Email for traders шаг 2 (Send email with discounts)</p>',  
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

IF OBJECT_ID (N'tempdb..#data',N'U') IS NOT NULL DROP TABLE #data --Освобождаем память.
IF OBJECT_ID (N'tempdb..#emails',N'U') IS NOT NULL DROP TABLE #emails

END