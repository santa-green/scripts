DECLARE @RefID INT
	   ,@RefName VARCHAR(256)
	   ,@Notes VARCHAR(256)
	   ,@Flag BIT

SET @Flag = 0

IF OBJECT_ID (N'tempdb..#temp', N'U') IS NOT NULL DROP TABLE #temp
CREATE TABLE #temp (Disc varchar(5), Free_space int)

INSERT INTO #temp
EXEC master..xp_fixeddrives

DECLARE CURSORE CURSOR LOCAL FAST_FORWARD
FOR 
SELECT RefID, RefName, Notes FROM [ElitR].[dbo].[r_Uni] WHERE RefTypeID = 1000000010 ORDER BY RefID DESC

OPEN CURSORE
	FETCH NEXT FROM CURSORE INTO @RefID, @RefName, @Notes
WHILE @@FETCH_STATUS = 0		 
BEGIN
	IF (SELECT Free_space FROM #temp WHERE Disc = 'E') > @RefID*1000 AND @Notes = '1'
	BEGIN
	   
	  UPDATE r_Uni SET Notes = '0' WHERE RefID = @RefID AND RefTypeID = 1000000010

	END;
	
	FETCH NEXT FROM CURSORE INTO @RefID, @RefName, @Notes
END
CLOSE CURSORE
DEALLOCATE CURSORE

DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD
FOR 
SELECT RefID, RefName, Notes FROM [ElitR].[dbo].[r_Uni] WHERE RefTypeID = 1000000010 ORDER BY RefID DESC

OPEN CURSOR1
	FETCH NEXT FROM CURSOR1 INTO @RefID, @RefName, @Notes
WHILE @@FETCH_STATUS = 0 AND @Flag = 0		 
BEGIN
	IF (SELECT Free_space FROM #temp WHERE Disc = 'E') < @RefID*1000 AND @Notes = '0'
	BEGIN
	  	  
		BEGIN
		  --Отправка почтового сообщения
		  BEGIN TRY 
			DECLARE @subject VARCHAR(250), @body VARCHAR(max), @rec VARCHAR(250)
			SET @subject = 'Заканчивается место на диске E (S-SQL-D4)'
			SET @body = (SELECT SUBSTRING(REPLACE(@RefName,'#',@RefID), CHARINDEX('/',@RefName)+1, LEN(@RefName)))
			SET @rec = (SELECT SUBSTRING(@RefName, 0, CHARINDEX('/',@RefName)))

			EXEC msdb.dbo.sp_send_dbmail  
			@profile_name = 'main',
			--@recipients = 'maslov@const.dp.ua', 
			@recipients = @rec,
			@subject = @subject,
			@body = @body,  
			@body_format = 'HTML'
			 
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

		END
	  
	  UPDATE r_Uni SET Notes = '1' WHERE RefID = @RefID AND RefTypeID = 1000000010

	  SET @Flag = 1
	END;
	
	FETCH NEXT FROM CURSOR1 INTO @RefID, @RefName, @Notes
END
CLOSE CURSOR1
DEALLOCATE CURSOR1

DROP TABLE #temp
/*
IF (SELECT Free_space FROM #temp WHERE Disc = 'E') < 50000
BEGIN
SELECT 'All bad'
END;

DROP TABLE #temp

SELECT RefName FROM [ElitR].[dbo].[r_Uni] WHERE RefTypeID = 1000000010 AND RefID = 30

SELECT * FROM [r_Uni] WHERE RefTypeID = 1000000010
SELECT REPLACE('ebola','a',10)

SELECT CHARINDEX('/',(SELECT RefName FROM [ElitR].[dbo].[r_Uni] WHERE RefTypeID = 1000000010 AND RefID = 30))
*/