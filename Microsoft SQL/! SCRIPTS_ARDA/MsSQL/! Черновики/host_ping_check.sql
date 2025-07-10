ALTER PROCEDURE [dbo].[ap_hosts_ping_check]
as
BEGIN
SET NOCOUNT ON;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --создаем лог (1 раз изначально).
    /*
    IF OBJECT_ID('Elit..hosts_ping_log', 'U') IS NOT NULL DROP TABLE hosts_ping_log
    CREATE TABLE hosts_ping_log (ID int IDENTITY(1,1), Hostname varchar(30), IP_address char(15), Net_Status char(5), Log_time datetime DEFAULT CURRENT_TIMESTAMP)
    */

    --создаем таблицу (1 раз изначально). Далее добавляем хост и IP по необходимости.
    /*
    CREATE TABLE at_ping_hosts_list (Hostname varchar(30), IP_address char(15))
    insert into at_ping_hosts_list VALUES ('rkeeper_hub_1.1', '192.168.70.35')
    insert into at_ping_hosts_list VALUES ('s-vintage', '192.168.70.3')
    insert into at_ping_hosts_list VALUES ('s-back1.corp.local', '10.1.0.50') 
    insert into at_ping_hosts_list VALUES ('s-vterm1', '10.1.0.7') 
    insert into at_ping_hosts_list VALUES ('s-vterm3', '10.1.0.9') 
    insert into at_ping_hosts_list VALUES ('s-vterm11', '10.1.0.27')
    */
    DECLARE @Hostname varchar(30)
    DECLARE @IP_address char(15)

    DECLARE cursor_ping CURSOR LOCAL FAST_FORWARD FOR
    SELECT Hostname, IP_address FROM at_ping_hosts_list
    
    OPEN cursor_ping
    FETCH NEXT FROM cursor_ping INTO @Hostname, @IP_address
    
    WHILE @@FETCH_STATUS = 0
        BEGIN
    IF OBJECT_ID('tempdb..#temp', 'U') IS NOT NULL DROP TABLE #temp
    CREATE TABLE #temp (output varchar(max))

    DECLARE @ping varchar(30) = 'ping ' + @IP_address
    EXEC xp_cmdshell @ping
    INSERT INTO #temp EXEC xp_cmdshell @ping
    DECLARE @subject_1 nvarchar(max) = 'Потеряна связь с ' + @Hostname
    DECLARE @subject_2 nvarchar(max) = 'Восстановлена связь с ' + @Hostname
    --DECLARE @recipients nvarchar(max) = 'support_arda@const.dp.ua;rumyantsev.kv@gmail.com;mi703148@gmail.com;maslovolegw@gmail.com;alexandr.kotsurenko@gmail.com';
    DECLARE @recipients nvarchar(max) = 'rumyantsev@const.dp.ua;rumyantsev.kv@gmail.com'; --для теста
    DECLARE @body_1 varchar(max) = '<font size="5" color="red" face="Arial">Потеряна связь с ' + @Hostname
    DECLARE @body_2 varchar(max) = '<font size="5" color="green" face="Arial">Восстановлена связь с ' + @Hostname
    
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    /*Если НЕ пингуется: */
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    IF EXISTS (SELECT * FROM #temp WHERE [output] like '%Заданный узел недоступен%' OR [output] like '%Превышен интервал ожидания для запроса%')
        BEGIN
            --делаем запись об отправленном уведомлении в лог.
            --IF OBJECT_ID('Elit..hosts_ping_log', 'U') IS NOT NULL DROP TABLE hosts_ping_log
            --CREATE TABLE hosts_ping_log (ID int IDENTITY(1,1), Net_Status varchar(max), Log_time datetime DEFAULT CURRENT_TIMESTAMP)
            INSERT INTO hosts_ping_log (Net_Status, Hostname, IP_address) VALUES ('False', @Hostname, @IP_address)

            IF (SELECT Net_Status FROM hosts_ping_log WHERE Hostname = @Hostname and ID = 
                    (SELECT MAX(ID) FROM hosts_ping_log WHERE Hostname = @Hostname)) = 'False' 
                AND (SELECT Net_Status FROM hosts_ping_log WHERE Hostname = @Hostname and ID = 
                        (SELECT MAX(ID) FROM hosts_ping_log WHERE Hostname = @Hostname and ID <> 
                            (SELECT MAX(ID) FROM hosts_ping_log WHERE Hostname = @Hostname))) = 'True'
                BEGIN
                    --отправляем уведомление (FAILURE).
                    EXEC msdb.dbo.sp_send_dbmail  
		             @profile_name = 'arda'
		            ,@from_address = '<support_arda@const.dp.ua>'
		            ,@recipients = @recipients
		            ,@body = @body_1
		            ,@subject = @subject_1
		            ,@body_format = 'HTML'--'HTML'
                    ,@importance = 'HIGH'
                END;

                FETCH NEXT FROM cursor_ping INTO @Hostname, @IP_address
                CONTINUE
        END;

    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   /*Если пингуется: */
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    IF EXISTS (SELECT * FROM #temp WHERE [output] like '%(0[%] потерь)%')
        BEGIN
            --делаем запись об отправленном уведомлении в лог.
            INSERT INTO hosts_ping_log (Net_Status, Hostname, IP_address) VALUES ('True', @Hostname, @IP_address)
            --проверка на изменение события.
            IF (SELECT Net_Status FROM hosts_ping_log WHERE Hostname = @Hostname and ID = 
                    (SELECT MAX(ID) FROM hosts_ping_log WHERE Hostname = @Hostname)) = 'True' 
                AND (SELECT Net_Status FROM hosts_ping_log WHERE Hostname = @Hostname and ID = 
                        (SELECT MAX(ID) FROM hosts_ping_log WHERE Hostname = @Hostname and ID <> 
                            (SELECT MAX(ID) FROM hosts_ping_log WHERE Hostname = @Hostname))) = 'False'
                BEGIN
                    --отправляем уведомление (SUCCESS).
                    EXEC msdb.dbo.sp_send_dbmail  
		             @profile_name = 'arda'
		            ,@from_address = '<support_arda@const.dp.ua>'
		            ,@recipients = @recipients
		            ,@body = @body_2
		            ,@subject = @subject_2
		            ,@body_format = 'HTML'--'HTML'
                    ,@importance = 'LOW'
                END;
        END;

FETCH NEXT FROM cursor_ping INTO @Hostname, @IP_address

    END;
CLOSE cursor_ping
DEALLOCATE cursor_ping

    --Вывод лога (для теста).
    SELECT top 1000 * FROM hosts_ping_log WITH(NOLOCK) ORDER BY Log_time DESC
    --SELECT top 1000 * FROM hosts_ping_log WHERE hostname = 's-vintage' ORDER BY Log_time DESC
    --delete from hosts_ping_log
    --[ap_hosts_ping_check]

/*
--EXTRA
-- потеря связи со станцией 1
SELECT * FROM hosts_ping_log t1 
WHERE t1.Net_Status = 'False' and EXISTS (SELECT * FROM hosts_ping_log t2 WHERE t2.Net_Status = 'True' and t2.ID = (t1.ID-1))
ORDER BY ID DESC
*/

/*
--Старые процедуры.
EXEC dbo.[ap_s-vintage_ping_check]
EXEC dbo.[ap_s-back1_ping_check]
EXEC dbo.[ap_s-vterm1_ping_check]
EXEC dbo.[ap_s-vterm3_ping_check]
EXEC dbo.[ap_s-vterm11_ping_check]
EXEC dbo.[ap_s-vintage_rkeeper_1_1_ping_check]
*/

END;







GO
