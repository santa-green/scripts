    USE [Elit]
GO
/****** Object:  StoredProcedure [dbo].[ap_GMS_License_Server_check]    Script Date: 12.03.2021 20:40:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[ap_s-vintage_ping_check]
as
BEGIN
SET NOCOUNT ON;

    IF OBJECT_ID('tempdb..#temp', 'U') IS NOT NULL DROP TABLE #temp
    CREATE TABLE #temp (output varchar(max))
    INSERT INTO #temp EXEC xp_cmdshell 'ping s-vintage'
    SELECT * FROM #temp
    DECLARE @subject_1 nvarchar(max) = 's-vintage отвалился!';
    DECLARE @subject_2 nvarchar(max) = 's-vintage ожил! He''s alive!';
    DECLARE @blind_copy_recipients nvarchar(max) = 'support_arda@const.dp.ua;rumyantsev.kv@gmail.com;mi703148@gmail.com;maslovolegw@gmail.com;alexandr.kotsurenko@gmail.com';
    --DECLARE @blind_copy_recipients nvarchar(max) = 'Румянцев Кирилл Валериевич <rumyantsev@const.dp.ua>'; --для теста

    --создаем лог.
    /*
    IF OBJECT_ID('Elit..svintage_ping_log', 'U') IS NOT NULL DROP TABLE svintage_ping_log
    CREATE TABLE svintage_ping_log (ID int IDENTITY(1,1), Net_Status varchar(max), Log_time datetime DEFAULT CURRENT_TIMESTAMP)
    */

    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    /*Если s-vintage НЕ пингуется: */
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    IF EXISTS(SELECT * FROM #temp WHERE output like '%Заданный узел недоступен%')
        BEGIN
            --делаем запись об отправленном уведомлении в лог.
            --IF OBJECT_ID('Elit..svintage_ping_log', 'U') IS NOT NULL DROP TABLE svintage_ping_log
            --CREATE TABLE svintage_ping_log (ID int IDENTITY(1,1), Net_Status varchar(max), Log_time datetime DEFAULT CURRENT_TIMESTAMP)
            INSERT INTO svintage_ping_log (Net_Status) VALUES ('False')

            IF (SELECT Net_Status FROM svintage_ping_log WHERE ID = (SELECT MAX(ID) FROM svintage_ping_log)) = 'False' 
                AND (SELECT Net_Status FROM svintage_ping_log WHERE ID = (SELECT MAX(ID)-1 FROM svintage_ping_log)) = 'True'
                BEGIN
                    SELECT 's-vintage НЕ пингуется..'
                    --отправляем уведомление (FAILURE).
                    EXEC msdb.dbo.sp_send_dbmail  
		             @profile_name = 'arda'
		            ,@from_address = '<support_arda@const.dp.ua>'
		            --,@recipients = 'rumyantsev@const.dp.ua'
                    --[CHANGED] '2020-04-06 11:03' rkv0 меняю свой адрес на все адреса отдела.
                    --[ADDED] '2020-10-08 14:06' rkv0 добавил в рассылку tancyura@const.dp.ua;klimenkoan@const.dp.ua.
                    --[CHANGED] '2020-10-13 15:34' rkv0 расширил список адресатов, перевел всех на скрытую копию.
		            --,@recipients = 'support_arda@const.dp.ua;dirin@const.dp.ua;tumaliieva@const.dp.ua;bibik@const.dp.ua;shevchenkoao@const.dp.ua;martynyuk@const.dp.ua;yevtischenko@const.dp.ua;tancyura@const.dp.ua;klimenkoan@const.dp.ua'
		            ,@blind_copy_recipients = @blind_copy_recipients
		            ,@body = '<font size="5" color="red" face="Arial">s-vintage отвалился!'
		            ,@subject = @subject_1
		            ,@body_format = 'HTML'--'HTML'
                    ,@importance = 'HIGH'
                END;

        END;

    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   /*Если s-vintage пингуется: */
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    IF EXISTS(SELECT * FROM #temp WHERE output like '%Ответ от%')
        BEGIN
            --делаем запись об отправленном уведомлении в лог.
            INSERT INTO svintage_ping_log (Net_Status) VALUES ('True')
            --проверка на изменение события.
            IF (SELECT Net_Status FROM svintage_ping_log WHERE ID = (SELECT MAX(ID) FROM svintage_ping_log)) = 'True' 
                AND (SELECT Net_Status FROM svintage_ping_log WHERE ID = (SELECT MAX(ID)-1 FROM svintage_ping_log)) = 'False'
                BEGIN
                    SELECT 's-vintage ожил.'
                    --отправляем уведомление (SUCCESS).
                    EXEC msdb.dbo.sp_send_dbmail  
		             @profile_name = 'arda'
		            ,@from_address = '<support_arda@const.dp.ua>'
		            --,@recipients = 'rumyantsev@const.dp.ua'
                    --[CHANGED] '2020-04-06 11:03' rkv0 меняю свой адрес на все адреса отдела.
		            --[ADDED] '2020-10-08 14:06' rkv0 добавил в рассылку tancyura@const.dp.ua;klimenkoan@const.dp.ua.
                    --[CHANGED] '2020-10-13 15:34'rkv0 расширил список адресатов, перевел всех на скрытую копию.
                    --,@recipients = 'support_arda@const.dp.ua;dirin@const.dp.ua;tumaliieva@const.dp.ua;bibik@const.dp.ua;shevchenkoao@const.dp.ua;martynyuk@const.dp.ua;yevtischenko@const.dp.ua;tancyura@const.dp.ua;klimenkoan@const.dp.ua'
		            ,@blind_copy_recipients = @blind_copy_recipients
		            ,@body = '<font size="5" color="green" face="Arial"> s-vintage <b>ожил</b>'
		            ,@subject = @subject_2
		            ,@body_format = 'HTML'--'HTML'
                    ,@importance = 'LOW'
                END;
        END;

    --Вывод лога (для теста).
    SELECT * FROM svintage_ping_log

END;




GO

