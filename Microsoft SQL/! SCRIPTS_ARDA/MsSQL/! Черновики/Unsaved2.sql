USE [Elit]
GO
/****** Object:  StoredProcedure [dbo].[ap_GMS_License_Server_check]    Script Date: 17.08.2021 9:46:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[ap_GMS_License_Server_check]
as
BEGIN
SET NOCOUNT ON;
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    /*CHANGELOG*/
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    --[CHANGED] '2020-04-06 11:03' rkv0 меняю свой адрес на все адреса отдела.
    --[ADDED] '2020-10-08 14:06' rkv0 добавил в рассылку tancyura@const.dp.ua;klimenkoan@const.dp.ua.
    --[CHANGED] '2020-10-13 15:34' rkv0 расширил список адресатов, перевел всех на скрытую копию.
    --[REMOVED] '2021-03-23 12:55' rkv0 убрал Колышкин Павел Игоревич <kolishkin@const.dp.ua> из рассылки (заявка №5964).
    --[REMOVED] '2021-08-17 09:47' rkv0 убрал Тумалиева Лейла Рамизовна <tumaliieva@const.dp.ua> из рассылки.


    --Проверяем доступность порта и заносим данные в #temp.
    IF OBJECT_ID('tempdb..#temp', 'U') IS NOT NULL DROP TABLE #temp
    CREATE TABLE #temp (output varchar(max))
    INSERT INTO #temp EXEC xp_cmdshell 'powershell.exe "Test-NetConnection -ComputerName 10.1.0.36 -Port 10502 -InformationLevel Quiet"'
    SELECT * FROM #temp

    --Определяем переменные.
    DECLARE @subject_1 nvarchar(max) = 'Проблема с GMS Office Tools - "В ПРОЦЕССЕ РЕШЕНИЯ" [Проверка сервера лицензий GMS: s-gms-lics.const.alef.ua]';
    DECLARE @subject_2 nvarchar(max) = 'Проблема с GMS Office Tools - "РЕШЕНО" [Проверка сервера лицензий GMS: s-gms-lics.const.alef.ua]';
    --[REMOVED] '2021-03-23 12:55' rkv0 убрал Колышкин Павел Игоревич <kolishkin@const.dp.ua> из рассылки (заявка №5964).
    --[REMOVED] '2021-08-17 09:47' rkv0 убрал Тумалиева Лейла Рамизовна <tumaliieva@const.dp.ua> из рассылки.
    DECLARE @blind_copy_recipients nvarchar(max) = 'Отдел автоматизации Арда-Трейдинг – служба поддержки <support_arda@const.dp.ua>; Дирин Максим Викторович <dirin@const.dp.ua>; Бибик Анжелика Григорьевна <bibik@const.dp.ua>; Шевченко Анна Олеговна <shevchenkoao@const.dp.ua>; Мартынюк Виктория Валериевна <martynyuk@const.dp.ua>; Евтищенко Анастасия Сергеевна <yevtischenko@const.dp.ua>; Клименко Алена Николаевна <klimenkoan@const.dp.ua>; Микитюк Владимир Васильевич <mikityuk@const.dp.ua>; Герасимова(Годейчук) Екатерина Ильинична <godeychuk@const.dp.ua>; Синильщикова Виктория Олеговна <sinelshchykova@const.dp.ua>; Слаутина Марина Сергеевна <slautina@const.dp.ua>; Борищук Лариса Александровна <boryshuk@const.dp.ua>; Понизовная Наталья Васильевна <ponyzovnaya@const.dp.ua>; Хилюк Ирина Анатольевна <khiluk@const.dp.ua>; Задорожний Вадим Юрьевич <zadorozhniy@const.dp.ua>; Петрова Виктория Ильинична <petrovav@const.dp.ua>; Петренко Татьяна Викторовна <petrenkot@const.dp.ua>; Андриенко Алла Викторовна <andrienko@const.dp.ua>; Столярчук Анна Сергеевна <stolyarchuk@const.dp.ua>; Гунько Наталья Валентиновна <gunko@const.dp.ua>; Журавлева Александра Анатольевна <zhuravleva@const.dp.ua>; Сорока Татьяна Георгиевна <sorokat@const.dp.ua>; Линский Павел Сергеевич <linskiy@const.dp.ua>; Трофимов Петр Вадимович <trofimov@const.dp.ua>;rumyantsev.kv@gmail.com;mi703148@gmail.com;maslovolegw@gmail.com;alexandr.kotsurenko@gmail.com;Танцюра Галина Владимировна <tancyura@const.dp.ua>';
    --DECLARE @blind_copy_recipients nvarchar(max) = 'Румянцев Кирилл Валериевич <rumyantsev@const.dp.ua>'; --для теста

    --создаем лог (единоразово).
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
		            --,@recipients = 'rumyantsev@const.dp.ua'
                    --[CHANGED] '2020-04-06 11:03' rkv0 меняю свой адрес на все адреса отдела.
                    --[ADDED] '2020-10-08 14:06' rkv0 добавил в рассылку tancyura@const.dp.ua;klimenkoan@const.dp.ua.
                    --[CHANGED] '2020-10-13 15:34' rkv0 расширил список адресатов, перевел всех на скрытую копию.
		            --,@recipients = 'support_arda@const.dp.ua;dirin@const.dp.ua;tumaliieva@const.dp.ua;bibik@const.dp.ua;shevchenkoao@const.dp.ua;martynyuk@const.dp.ua;yevtischenko@const.dp.ua;tancyura@const.dp.ua;klimenkoan@const.dp.ua'
		            ,@blind_copy_recipients = @blind_copy_recipients
		            ,@body = '<font size="5" color="red" face="Arial">Сервер лицензий в данный момент может быть <b>НЕДОСТУПЕН</b>. Работа в GMS Office Tools может быть временно нестабильной ("демонстрационная версия")! При возобновлении стабильной работы будет отправлено уведомление. Ждите email...'
		            ,@subject = @subject_1
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
		            --,@recipients = 'rumyantsev@const.dp.ua'
                    --[CHANGED] '2020-04-06 11:03' rkv0 меняю свой адрес на все адреса отдела.
		            --[ADDED] '2020-10-08 14:06' rkv0 добавил в рассылку tancyura@const.dp.ua;klimenkoan@const.dp.ua.
                    --[CHANGED] '2020-10-13 15:34'rkv0 расширил список адресатов, перевел всех на скрытую копию.
                    --,@recipients = 'support_arda@const.dp.ua;dirin@const.dp.ua;tumaliieva@const.dp.ua;bibik@const.dp.ua;shevchenkoao@const.dp.ua;martynyuk@const.dp.ua;yevtischenko@const.dp.ua;tancyura@const.dp.ua;klimenkoan@const.dp.ua'
		            ,@blind_copy_recipients = @blind_copy_recipients
		            ,@body = '<font size="5" color="green" face="Arial"> Сервер лицензий <b>доступен</b>. Можно работать в GMS Office Tools!'
		            ,@subject = @subject_2
		            ,@body_format = 'HTML'--'HTML'
                    ,@importance = 'LOW'
                END;
        END;

    --Вывод лога (для теста).
    --SELECT top 100 * FROM GMS_License_Server_Log WITH(NOLOCK) ORDER BY Log_time DESC;
END;








GO
