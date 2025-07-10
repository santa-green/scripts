IF OBJECT_ID('tempdb..#temp', 'U') IS NOT NULL DROP TABLE #temp
CREATE TABLE #temp (output varchar(max))
INSERT INTO #temp EXEC xp_cmdshell 'powershell.exe "Test-NetConnection -ComputerName 10.1.0.36 -Port 10502 -InformationLevel Quiet"'
SELECT * FROM #temp
DECLARE @subject nvarchar(max) = 'Проверка сервера лицензий GMS: s-gms-lics.const.alef.ua';

--создаем лог.
/*
IF OBJECT_ID('Elit..GMS_License_Server_Log', 'U') IS NOT NULL DROP TABLE GMS_License_Server_Log
CREATE TABLE GMS_License_Server_Log (ID int IDENTITY(1,1), Net_Status varchar(max), Log_time datetime DEFAULT CURRENT_TIMESTAMP)
*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Если порт закрыт: */
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
IF EXISTS(SELECT * FROM #temp WHERE output = 'False')
    BEGIN
        --делаем запись об отправленном уведомлении в лог.
        --IF OBJECT_ID('Elit..GMS_License_Server_Log', 'U') IS NOT NULL DROP TABLE GMS_License_Server_Log
        --CREATE TABLE GMS_License_Server_Log (ID int IDENTITY(1,1), Net_Status varchar(max), Log_time datetime DEFAULT CURRENT_TIMESTAMP)
        INSERT INTO GMS_License_Server_Log (Net_Status) VALUES ('False')

        IF (SELECT Net_Status FROM GMS_License_Server_Log WHERE ID = (SELECT MAX(ID) FROM GMS_License_Server_Log)) = 'False' 
            AND (SELECT Net_Status FROM GMS_License_Server_Log WHERE ID = (SELECT MAX(ID)-1 FROM GMS_License_Server_Log)) = 'True'
            BEGIN
                SELECT 'порт недоступен..'
                --отправляем уведомление (FAILURE).
                EXEC msdb.dbo.sp_send_dbmail  
		         @profile_name = 'arda'
		        ,@from_address = '<support_arda@const.dp.ua>'
		        ,@recipients = 'rumyantsev@const.dp.ua'
		        --,@copy_recipients  = 'rumyantsev.kv@gmail.com;mi703148@gmail.com;maslovolegw@gmail.com;alexandr.kotsurenko@gmail.com'   
		        ,@body = '<font size="15" color="red" face="Arial">Сервер лицензий <b>НЕДОСТУПЕН</b>. Работа в GMS Office Tools временно прекращена! При возобновлении возможности работы будет отправлено уведомление.'
		        ,@subject = @subject
		        ,@body_format = 'HTML'--'HTML'
                ,@importance = 'HIGH'
            END;

    END;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Если порт доступен: */
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
IF EXISTS(SELECT * FROM #temp WHERE output = 'True')
    BEGIN
        --делаем запись об отправленном уведомлении в лог.
        INSERT INTO GMS_License_Server_Log (Net_Status) VALUES ('True')
        --проверка на изменение события.
        IF (SELECT Net_Status FROM GMS_License_Server_Log WHERE ID = (SELECT MAX(ID) FROM GMS_License_Server_Log)) = 'True' 
            AND (SELECT Net_Status FROM GMS_License_Server_Log WHERE ID = (SELECT MAX(ID)-1 FROM GMS_License_Server_Log)) = 'False'
            BEGIN
                SELECT 'заработал.'
                --отправляем уведомление (SUCCESS).
                EXEC msdb.dbo.sp_send_dbmail  
		         @profile_name = 'arda'
		        ,@from_address = '<support_arda@const.dp.ua>'
		        ,@recipients = 'rumyantsev@const.dp.ua'
		        --,@copy_recipients  = 'rumyantsev.kv@gmail.com;mi703148@gmail.com;maslovolegw@gmail.com;alexandr.kotsurenko@gmail.com'   
		        ,@body = '<font size="15" color="green" face="Arial"> Сервер лицензий <b>доступен</b>. Можно работать в GMS Office Tools!'
		        ,@subject = @subject
		        ,@body_format = 'HTML'--'HTML'
                ,@importance = 'LOW'
            END;
    END;

--Вывод лога (для теста).
SELECT * FROM GMS_License_Server_Log