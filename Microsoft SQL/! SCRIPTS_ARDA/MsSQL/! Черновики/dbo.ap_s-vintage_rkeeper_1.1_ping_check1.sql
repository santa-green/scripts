alter PROCEDURE [dbo].[ap_s-vintage_rkeeper_1_1_ping_check]
as
BEGIN
SET NOCOUNT ON;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[FIXED] добавил выход из процедуры, т.к. при сообщении "Заданный узел недоступен" остается сообщение "...(0% потерь)" (ответ не того хоста).


    IF OBJECT_ID('tempdb..#temp', 'U') IS NOT NULL DROP TABLE #temp
    CREATE TABLE #temp (output varchar(max))
    INSERT INTO #temp EXEC xp_cmdshell 'ping 192.168.70.35'
    SELECT * FROM #temp
    DECLARE @subject_1 nvarchar(max) = 'Потеряна связь с кассовой станцией Rkeeper 1.1 (hub)!';
    DECLARE @subject_2 nvarchar(max) = 'Восстановлена связь с кассовой станцией Rkeeper 1.1 (hub)!';
    DECLARE @recipients nvarchar(max) = 'support_arda@const.dp.ua;rumyantsev.kv@gmail.com;mi703148@gmail.com;maslovolegw@gmail.com;alexandr.kotsurenko@gmail.com';
    --DECLARE @recipients nvarchar(max) = 'rumyantsev@const.dp.ua;rumyantsev.kv@gmail.com'; --для теста

    --создаем лог.
    /*
    IF OBJECT_ID('Elit..svintage_rkeeper_1_1_ping_log', 'U') IS NOT NULL DROP TABLE svintage_rkeeper_1_1_ping_log
    CREATE TABLE svintage_rkeeper_1_1_ping_log (ID int IDENTITY(1,1), Net_Status varchar(max), Log_time datetime DEFAULT CURRENT_TIMESTAMP)
    */

    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    /*Если НЕ пингуется: */
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    IF EXISTS(SELECT * FROM #temp WHERE [output] like '%Заданный узел недоступен%' OR [output] like '%Превышен интервал ожидания для запроса%')
        BEGIN
            --делаем запись об отправленном уведомлении в лог.
            --IF OBJECT_ID('Elit..svintage_rkeeper_1_1_ping_log', 'U') IS NOT NULL DROP TABLE svintage_rkeeper_1_1_ping_log
            --CREATE TABLE svintage_rkeeper_1_1_ping_log (ID int IDENTITY(1,1), Net_Status varchar(max), Log_time datetime DEFAULT CURRENT_TIMESTAMP)
            INSERT INTO svintage_rkeeper_1_1_ping_log (Net_Status) VALUES ('False')

            IF (SELECT Net_Status FROM svintage_rkeeper_1_1_ping_log WHERE ID = (SELECT MAX(ID) FROM svintage_rkeeper_1_1_ping_log)) = 'False' 
                AND (SELECT Net_Status FROM svintage_rkeeper_1_1_ping_log WHERE ID = (SELECT MAX(ID)-1 FROM svintage_rkeeper_1_1_ping_log)) = 'True'
                BEGIN
                    SELECT 'Станция Rkeeper 1.1 (hub) НЕ пингуется..'
                    --отправляем уведомление (FAILURE).
                    EXEC msdb.dbo.sp_send_dbmail  
		             @profile_name = 'arda'
		            ,@from_address = '<support_arda@const.dp.ua>'
		            --,@recipients = 'rumyantsev@const.dp.ua'
                    --[CHANGED] '2020-04-06 11:03' rkv0 меняю свой адрес на все адреса отдела.
                    --[ADDED] '2020-10-08 14:06' rkv0 добавил в рассылку tancyura@const.dp.ua;klimenkoan@const.dp.ua.
                    --[CHANGED] '2020-10-13 15:34' rkv0 расширил список адресатов, перевел всех на скрытую копию.
		            --,@recipients = 'support_arda@const.dp.ua;dirin@const.dp.ua;tumaliieva@const.dp.ua;bibik@const.dp.ua;shevchenkoao@const.dp.ua;martynyuk@const.dp.ua;yevtischenko@const.dp.ua;tancyura@const.dp.ua;klimenkoan@const.dp.ua'
		            ,@recipients = @recipients
		            ,@body = '<font size="5" color="red" face="Arial">Потеряна связь с кассовой станцией Rkeeper 1.1 (hub)!!'
		            ,@subject = @subject_1
		            ,@body_format = 'HTML'--'HTML'
                    ,@importance = 'HIGH'
                END;
            --[FIXED] добавил выход из процедуры, т.к. при сообщении "Заданный узел недоступен" остается сообщение "...(0% потерь)" (ответ не того хоста).
            RETURN;
        END;

    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   /*Если пингуется: */
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    IF EXISTS(SELECT * FROM #temp WHERE [output] like '%(0[%] потерь)%')
        BEGIN
            --делаем запись об отправленном уведомлении в лог.
            INSERT INTO svintage_rkeeper_1_1_ping_log (Net_Status) VALUES ('True')
            --проверка на изменение события.
            IF (SELECT Net_Status FROM svintage_rkeeper_1_1_ping_log WHERE ID = (SELECT MAX(ID) FROM svintage_rkeeper_1_1_ping_log)) = 'True' 
                AND (SELECT Net_Status FROM svintage_rkeeper_1_1_ping_log WHERE ID = (SELECT MAX(ID)-1 FROM svintage_rkeeper_1_1_ping_log)) = 'False'
                BEGIN
                    SELECT 'Станция Rkeeper 1.1 (hub) пингуется..'
                    --отправляем уведомление (SUCCESS).
                    EXEC msdb.dbo.sp_send_dbmail  
		             @profile_name = 'arda'
		            ,@from_address = '<support_arda@const.dp.ua>'
		            --,@recipients = 'rumyantsev@const.dp.ua'
                    --[CHANGED] '2020-04-06 11:03' rkv0 меняю свой адрес на все адреса отдела.
		            --[ADDED] '2020-10-08 14:06' rkv0 добавил в рассылку tancyura@const.dp.ua;klimenkoan@const.dp.ua.
                    --[CHANGED] '2020-10-13 15:34'rkv0 расширил список адресатов, перевел всех на скрытую копию.
                    --,@recipients = 'support_arda@const.dp.ua;dirin@const.dp.ua;tumaliieva@const.dp.ua;bibik@const.dp.ua;shevchenkoao@const.dp.ua;martynyuk@const.dp.ua;yevtischenko@const.dp.ua;tancyura@const.dp.ua;klimenkoan@const.dp.ua'
		            ,@recipients = @recipients
		            ,@body = '<font size="5" color="green" face="Arial"> Восстановлена связь с кассовой станцией Rkeeper 1.1 (hub)'
		            ,@subject = @subject_2
		            ,@body_format = 'HTML'--'HTML'
                    ,@importance = 'LOW'
                END;
        END;

    --Вывод лога (для теста).
    SELECT top 1000 * FROM svintage_rkeeper_1_1_ping_log WITH(NOLOCK) ORDER BY Log_time DESC
    SELECT top 1000 * FROM svintage_rkeeper_1_1_ping_log WITH(NOLOCK) ORDER BY 1 DESC

/*  
    SELECT top 1000 * FROM svintage_rkeeper_1_1_ping_log WITH(NOLOCK) ORDER BY Log_time DESC
    SELECT top 1000 * FROM svintage_rkeeper_1_1_ping_log WITH(NOLOCK) WHERE Net_Status = 'False' ORDER BY Log_time DESC
    SELECT top 1000 * FROM svintage_rkeeper_1_1_ping_log WITH(NOLOCK) WHERE id between 2000 and 2010 ORDER BY log_time DESC
    SELECT top 1000 * FROM svintage_rkeeper_1_1_ping_log WITH(NOLOCK) WHERE id between 4335 and 4345 ORDER BY log_time DESC
*/

END;











GO
