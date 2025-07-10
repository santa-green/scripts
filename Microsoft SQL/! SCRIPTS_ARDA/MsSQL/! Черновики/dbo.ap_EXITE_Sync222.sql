USE [Elit]
GO
/****** Object:  StoredProcedure [dbo].[ap_EXITE_Sync]    Script Date: 09.06.2021 17:14:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[ap_EXITE_Sync]
AS
/* Процедура синхронизации с папкой клиента синхронизации для заказов EXITE */
--20190110 pvm0 изменил параметры фильтра J1201008 на J1201010
BEGIN
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ADDED] rkv0 '2020-10-06 14:31' исключаю список предприятий по заявке Танцюры #127 для автоматической отправки DESADV, ORDRSP, миную папку Черновики на сайте EDIN.
--[FIXED] rkv0 '2020-10-07 18:54' счета не отправлялись, добавил в фильтр.
--[REMOVED] rkv0 '2020-11-12 12:28' этот блок "Получение списка файлов в папке импорта" не нужен (его изначальное назначение мне неизвестно).
--[ADDED] rkv0 '2020-12-04 17:49' добавил новый документ IFTMIN (Инструкция по транспортировке) для сети Сильпо.
--[ADDED] '2021-03-12 13:33' rkv0 добавил новый документ CONTRL (Отчет об отгрузке) для сети Сильпо.
--[CHANGED] '2021-03-19 16:09' rkv0 из-за смены версий налоговых каждый раз чтобы не менять версию; достаточно будет %j12%.
--[REMOVED] '2021-03-23 14:58' rkv0 убрал документ CONTRL (Отчет об отгрузке) для сети Сильпо, т.к. он не работает через Черновики (надо отправлять напрямую).


  SET NOCOUNT ON
  SET XACT_ABORT ON
  
  /* Объявление глобальных переменных */
--[REMOVED] rkv0 '2020-11-12 12:28' этот блок "Получение списка файлов в папке импорта" не нужен (его изначальное назначение мне неизвестно).
  /*
  DECLARE @Files TABLE([FileName] VARCHAR(256))
  DECLARE @SQL NVARCHAR(4000)
  DECLARE @OurID INT = 0
  DECLARE @DID INT
  */

  DECLARE @Path VARCHAR(512) = 'E:\ExiteSync\'
  DECLARE @tmp VARCHAR(1024), @FName VARCHAR(256)
  DECLARE @Res INT
  DECLARE @CH INT

  DECLARE @xmlDocument XML

  --[REMOVED] rkv0 '2020-11-12 12:28' этот блок "Получение списка файлов в папке импорта" не нужен (его изначальное назначение мне неизвестно).
  /*
  /* Получение списка файлов в папке импорта */
  SET @tmp = 'DIR /b ' + @Path + 'inbox\*.xml'
  INSERT @Files
  EXEC xp_cmdshell @tmp

  /* Получение данных из входящих файлов и занесение их в таблицу синхронизации */
  DECLARE CurRead CURSOR FAST_FORWARD LOCAL FOR
    SELECT [FileName]
    FROM @Files
    WHERE [FileName] LIKE 'order[_]%'
      AND [FileName] IS NOT NULL
      AND [FileName] != 'Файл не найден'
    ORDER BY 1
  OPEN CurRead
  FETCH NEXT FROM CurRead INTO @FName
  WHILE (@@FETCH_STATUS = 0)
  BEGIN
    /* Получение полного имени файла (путь + имя) */
    SET @tmp = @Path + 'inbox\' + @FName
    
    /* Выгрузка xml файла с диска */
    SET @SQL = N'SELECT @out = (SELECT CONVERT(XML, BulkColumn, 2) FROM 
      OPENROWSET(BULK ''' + @tmp + N''', SINGLE_BLOB) [rowsetresults])'
   
    EXEC sp_executesql @SQL, N'@out XML OUT', @xmlDocument OUT
    
    EXEC dbo.z_NewChID 'at_z_FilesExchange', @CH OUT
    EXEC dbo.z_NewDocID 666029, 'at_z_FilesExchange', @OurID, @DID OUT
  
    INSERT dbo.at_z_FilesExchange (ChID,FileTypeID,[FileName],DocID,DocDate,DocTime,OurID,StateCode,FileData)
    SELECT @CH, 1 FileTypeID, @FName, @DID, dbo.zf_GetDate(GETDATE()), GETDATE(), @OurID, 400 StateCode, @xmlDocument
    WHERE @FName NOT IN (SELECT [FileName] FROM dbo.at_z_FilesExchange)
    
    IF @@ERROR <> 0 GOTO Error1
    SET @tmp = 'MOVE /Y "' + @Path + 'inbox\' + @FName + '" "' + @Path + '\OK"'

    EXEC xp_cmdshell @tmp, NO_OUTPUT
    FETCH NEXT FROM CurRead INTO @FName
  END
  CLOSE CurRead
  DEALLOCATE CurRead
  --1
  */

 --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 /*Выгрузка xml из таблицы at_z_filesExchange в папку обмена \\S-SQL-D4\ExiteSync\inbox\ для дальнейшей отправки на ftp сервер (папка Черновики)*/
 --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  DECLARE CurWrite CURSOR FAST_FORWARD LOCAL FOR
     
    SELECT ChID, [FileName]
    FROM  dbo.at_z_FilesExchange
    WHERE Statecode = 402 AND FileTypeID = 4
    AND [FileName] NOT LIKE '%COMDOC.xml' --pashkovv '2019-05-30 17:06:41.978' отключил для отправки COMDOC
									    --moa0 '2019-10-17 17:52:58.218' Включил обратно, так как rkv0 утверждает, что это нужно было для ручного подписания по Розетке.
                                        --rvk0 '2019-10-18 11:21' возвращаю обработку COMDOC (временно для теста, после запуска полного документооборота 
									    --moa0 '2019-10-21 18:00:47.286' Включил обратно, так как rkv0 утверждает, что это нужно было для ручного подписания по Розетке.
    --AND [FileName] NOT LIKE '%J1201010%' --20190110 pvm0 изменил параметры фильтра J1201008 на J12010
    --[CHANGED] '2021-03-19 16:09' rkv0 из-за смены версий налоговых каждый раз чтобы не менять версию; достаточно будет %j12%.
    AND [FileName] NOT LIKE '%J12%'
    --[ADDED] rkv0 '2020-10-06 14:31' исключаю список предприятий по заявке Танцюры #127 для автоматической отправки DESADV, ORDRSP, миную папку Черновики на сайте EDIN.
    AND (
        --[CHANGED] rkv0 '2021-06-09 19:00' убираю вьюху av_at_desadv_autosend и делаю проверку по Compid на наличие предприятия в справочнике RefTypeID = 6680134.
        --FileData.value('(DESADV/HEAD/BUYER)[1]', 'varchar(30)') NOT IN (SELECT * FROM av_at_desadv_autosend) 
        --OR FileData.value('(ORDRSP/HEAD/BUYER)[1]', 'varchar(30)') NOT IN (SELECT * FROM av_at_desadv_autosend)
        (SELECT TOP(1) Compid 
            FROM t_inv 
            WHERE Orderid IN (
                FileData.value('(DESADV/ORDERNUMBER)[1]', 'varchar(30)'),
                FileData.value('(ORDRSP/ORDERNUMBER)[1]', 'varchar(30)')
                )
                ) NOT IN (SELECT RefID FROM r_uni WHERE RefTypeID = 6680134) --Справочник предприятий для отправки отчетов «Уведомление об отгрузке» и «Подтверждение заказа» на платформу EDI напрямую, минуя Черновики
        --[FIXED] rkv0 '2020-10-07 18:54' счета не отправлялись, добавил в фильтр.
        OR [FileName] like '%INVOICE%'
        --[ADDED] rkv0 '2020-12-04 17:49' добавил новый документ IFTMIN (Инструкция по транспортировке) для сети Сильпо.
        OR [FileName] like '%IFTMIN%'
        --[ADDED] '2021-03-12 13:33' rkv0 добавил новый документ CONTRL (Отчет об отгрузке) для сети Сильпо.
        --[REMOVED] '2021-03-23 14:58' rkv0 убрал документ CONTRL (Отчет об отгрузке) для сети Сильпо, т.к. он не работает через Черновики (надо отправлять напрямую).
        --OR [FileName] like '%CONTRL%'
        )
    ORDER BY 1


  OPEN CurWrite
  FETCH NEXT FROM CurWrite INTO @CH, @FName
  WHILE (@@FETCH_STATUS = 0)
  BEGIN
    /* Получение полного имени файла (путь + имя) */
    SET @tmp = @Path + 'outbox\' + @FName
    
    SET @tmp = 'bcp "SELECT ''<?xml version=\"1.0\" encoding=\"utf-8\"?>'' + CAST(FileData AS VARCHAR(MAX)) FROM ' + QUOTENAME(DB_NAME()) + '.dbo.at_z_FilesExchange WITH(NOLOCK) WHERE ChID=' + CAST(@CH AS VARCHAR(10)) + '" queryout "' + @tmp + '" -c -C RAW -T -Slocalhost&&"' + @Path + 'bin\iconv.exe" -c -f CP1251 -t UTF-8 "' + @tmp + '" > "' + @tmp + 'tmp" && move /Y "' + @tmp + 'tmp" "' + @tmp + '"'
    PRINT @tmp
    /* Выгрузка xml файла на диск */
    EXEC @Res = xp_cmdshell @tmp, NO_OUTPUT
    
    IF @Res = 0
      BEGIN
        BEGIN TRY
          UPDATE dbo.at_z_FilesExchange SET StateCode = StateCode + 1 WHERE ChID = @CH AND Statecode = 402
        END TRY
        BEGIN CATCH
        SET @tmp = 'DEL /Q "' + @Path + 'outbox\' + @FName + '"'
        EXEC @Res = xp_cmdshell @tmp, NO_OUTPUT
          DECLARE @ErrMsg VARCHAR(300) = ERROR_MESSAGE()
          DECLARE @ErrSvr INT = ERROR_SEVERITY()
          DECLARE @ErrStt INT = ERROR_STATE()
          IF @@TRANCOUNT > 0 ROLLBACK
          RAISERROR(@ErrMsg, @ErrSvr, @ErrStt)
        END CATCH
      END
      ELSE RAISERROR('%s - %u',18,1, @tmp, @Res)
    FETCH NEXT FROM CurWrite INTO @CH, @FName
  END
  CLOSE CurWrite
  DEALLOCATE CurWrite  

  RETURN

--[REMOVED] rkv0 '2020-11-12 12:28' этот блок "Получение списка файлов в папке импорта" не нужен (его изначальное назначение мне неизвестно).
/*
Error1:
  CLOSE CurRead
  DEALLOCATE CurRead
  IF @@TRANCOUNT > 0 ROLLBACK
  RAISERROR('Ошибка импорта заказов',18,1)
*/

Error2:
  CLOSE CurWrite
  DEALLOCATE CurWrite
  IF @@TRANCOUNT > 0 ROLLBACK
  RAISERROR('Ошибка экспорта заказов',18,1)
END

















GO
