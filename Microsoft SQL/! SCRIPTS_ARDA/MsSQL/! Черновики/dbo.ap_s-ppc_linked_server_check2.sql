USE [Elit]
GO
/****** Object:  StoredProcedure [dbo].[ap_s-ppc_linked_server_check]    Script Date: 23.03.2021 14:43:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[ap_s-ppc_linked_server_check]

as
BEGIN
SET NOCOUNT ON;
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    /*CHANGELOG*/
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --...

    DECLARE @retval int
    EXEC @retval = sys.sp_testlinkedserver [s-ppc.const.alef.ua]
    SELECT @retval

    DECLARE @subject_1 nvarchar(max) = 's-ppc sql linked server отвалился!';
    DECLARE @subject_2 nvarchar(max) = 's-ppc sql linked server ожил!';
    DECLARE @recipients nvarchar(max) = 'support_arda@const.dp.ua;rumyantsev.kv@gmail.com;mi703148@gmail.com;maslovolegw@gmail.com;alexandr.kotsurenko@gmail.com';
    --DECLARE @recipients nvarchar(max) = 'rumyantsev@const.dp.ua'; --для теста

    --создаем лог (1 раз в начале).
    /*
    IF OBJECT_ID('Elit..sppc_linked_server_log', 'U') IS NOT NULL DROP TABLE sppc_linked_server_log
    CREATE TABLE sppc_linked_server_log (ID int IDENTITY(1,1), Net_Status varchar(max), Log_time datetime DEFAULT CURRENT_TIMESTAMP)
    */

    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    /*Если s-ppc sql linked server НЕ коннектится: */
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    IF @retval <> 0
        BEGIN
            --делаем запись об отправленном уведомлении в лог.
            --IF OBJECT_ID('Elit..sppc_linked_server_log', 'U') IS NOT NULL DROP TABLE sppc_linked_server_log
            --CREATE TABLE sppc_linked_server_log (ID int IDENTITY(1,1), Net_Status varchar(max), Log_time datetime DEFAULT CURRENT_TIMESTAMP)
            INSERT INTO sppc_linked_server_log (Net_Status) VALUES ('False')

            IF (SELECT Net_Status FROM sppc_linked_server_log WHERE ID = (SELECT MAX(ID) FROM sppc_linked_server_log)) = 'False' 
                AND (SELECT Net_Status FROM sppc_linked_server_log WHERE ID = (SELECT MAX(ID)-1 FROM sppc_linked_server_log)) = 'True'
                BEGIN
                    SELECT 's-ppc sql linked server НЕ коннектится..'
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
		            ,@body = '<font size="5" color="red" face="Arial">s-ppc sql linked server отвалился!'
		            ,@subject = @subject_1
		            ,@body_format = 'HTML'--'HTML'
                    ,@importance = 'HIGH'
                END;

        END;

    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   /*Если s-ppc sql linked server коннектится: */
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    IF @retval = 0
        BEGIN
            --делаем запись об отправленном уведомлении в лог.
            INSERT INTO sppc_linked_server_log (Net_Status) VALUES ('True')
            --проверка на изменение события.
            IF (SELECT Net_Status FROM sppc_linked_server_log WHERE ID = (SELECT MAX(ID) FROM sppc_linked_server_log)) = 'True' 
                AND (SELECT Net_Status FROM sppc_linked_server_log WHERE ID = (SELECT MAX(ID)-1 FROM sppc_linked_server_log)) = 'False'
                BEGIN
                    SELECT 's-ppc sql linked server ожил.'
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
		            ,@body = '<font size="5" color="green" face="Arial"> s-ppc sql linked server <b>ожил</b>'
		            ,@subject = @subject_2
		            ,@body_format = 'HTML'--'HTML'
                    ,@importance = 'LOW'
                END;
        END;

    --Вывод лога (для теста).
    SELECT top 1000 * FROM sppc_linked_server_log WITH(NOLOCK) ORDER BY Log_time DESC

END;

/*-- CHECK LINKED SERVER CONNECTION
DECLARE @ServerName sysname
DECLARE @a int
SET @ServerName = 's-ppc.const.alef.ua'
IF EXISTS(SELECT 1 FROM master.dbo.sysservers WHERE srvname LIKE @ServerName)
BEGIN
    EXEC @a = sys.sp_testlinkedserver @servername = @ServerName
    IF @a = 0
    print 'LINKED SERVER ''' + ISNULL(@ServerName,'') + ''' IS CONNECTED.'
    ELSE
    print 'LINKED SERVER ''' + ISNULL(@ServerName,'') + ''' IS NOT CONNECTED!'
END;
ELSE
BEGIN
    PRINT 'LINKED SERVER '''+ ISNULL(@ServerName,'') + ''' DOES NOT EXIST!'
END;*/










GO
