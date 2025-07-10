USE Elit
--USE Elit_TEST

DECLARE @n VARCHAR(max) = (SELECT LTRIM(RTRIM(REPLACE('	    	 	 	45337055          ', CHAR(9), '')))) --№ заказа покупателя EDI --4514429001
BEGIN
    SELECT ''    'ЗАГОЛОВОК'
    ,      ChID       'ChID'
    ,      DocID      'Номер документа'
    ,      DocDate    'Дата документа'
    ,      TaxDocID   '№ налоговой накладной'
    ,      TaxDocDate 'Дата налоговой накладной'
    ,      TSumCC_nt  'Всего без НДС'
    ,      TTaxSum    'НДС по документу'
    ,      TSumCC     'Всего с НДС'
    ,      OrderID   
    ,      OurID     
    ,      (SELECT SUM(qty) FROM t_InvD WHERE ChID = (SELECT MAX(ChID) FROM t_inv WHERE OrderID = @n)) '|| Всего бутылок отгружено ||'
    ,      i.CompID  
    ,      (
            SELECT TOP 1 CompShort
            FROM dbo.r_Comps c WITH(NOLOCK)
            WHERE c.CompID = i.CompID
            )      'CompShort'
    ,      [Address]   
    ,      *         
    FROM dbo.t_Inv i WITH(NOLOCK)
    WHERE OrderID LIKE cast((@n + '%') as varchar) --cast(@n AS VARCHAR) --t_Inv
	    AND EXISTS (
	    SELECT *
	    FROM dbo.t_InvD d
	    WHERE d.ChID = i.ChID
	    )
    SELECT ''    'ДЕТАЛИ'
    ,      pp.CstProdCode 
    ,      ps.ProdName    
    ,      pc.ExtProdID   
    ,      i.ChID         
    ,      i.SrcPosID     
    ,      i.ProdID       
    ,      i.PPID         
    ,      i.UM           
    ,      i.Qty          
    ,      i.PriceCC_nt   
    ,      i.SumCC_nt     
    ,      i.Tax          
    ,      i.TaxSum       
    ,      i.PriceCC_wt   
    ,      i.SumCC_wt     
    ,      i.BarCode      
    ,      i.SecID        
    ,      i.PurPriceCC_wt
    FROM dbo.t_InvD i WITH(NOLOCK) 
    JOIN dbo.t_PInP      pp WITH(NOLOCK) ON pp.ProdID = i.ProdID
		    AND pp.PPID = i.PPID
    JOIN dbo.r_Prods     ps WITH(NOLOCK) ON ps.ProdID = i.ProdID
    JOIN dbo.t_Inv       d WITH(NOLOCK)  ON d.chid = i.chid
    LEFT JOIN dbo.r_ProdEC    pc WITH(NOLOCK) ON pc.ProdID = i.ProdID AND pc.CompID = d.CompID
    WHERE i.ChID IN (
	    SELECT ChID
	    FROM dbo.t_Inv i
	    WHERE OrderID LIKE cast((@n + '%') as varchar) --LIKE cast(@n AS VARCHAR)
	    )
    --ORDER BY 1, 2
    ORDER BY i.SumCC_nt DESC
    SELECT ''    'ЕЩЕ БОЛЬШЕ ДЕТАЛЕЙ'
    , *   
    FROM dbo.at_t_InvLoad il WITH(NOLOCK)
    WHERE il.ChID IN (
	    SELECT ChID
	    FROM dbo.t_Inv i
	    WHERE OrderID LIKE cast((@n + '%') as varchar) --LIKE cast(@n AS VARCHAR)
	    )
END;
/*
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*EXTRA*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Инструмент F11: \\s-sql-d4.corp.local\OT38ElitServer\ReportsUni\Elit\Бизнес\Инструменты\Экспорт EXITE.fr3*/
/*Поиск по номеру НН*/            SELECT OrderID, * FROM t_Inv WHERE TaxDocID in (21059) AND COMPID in (7136, 7138) ORDER BY 1 DESC
/*УСКОРИТЬ ЗАЛИВКУ ЗАКАЗОВ*/      EXEC [S-PPC.CONST.ALEF.UA].[Alef_Elit].dbo.ap_pushOrdersEDI 
/*ПЕРЕОТПРАВКА РОЗЕТКИ*/          EXEC [S-PPC.CONST.ALEF.UA].[alef_elit].[dbo].[ap_EDI_Resend_COMDOC_Rozetka] 'РОЗ01184808';
/*ПЕРЕОТПРАВКА METRO*/            EXEC [S-PPC.CONST.ALEF.UA].[alef_elit].[dbo].[ap_EDI_Resend_COMDOC_Metro] '45334114' --@orderid - № заказа в EDI.
/*ПРОВЕРИТЬ РЕГ-ЦИЮ НАЛОГОВЫХ*/   SELECT * FROM [dbo].[af_tax_rpl_check_all] (DEFAULT, 2021, 3, '11199,11198,10327,9018')
                                  SELECT * FROM [dbo].[af_tax_rpl_check_all] (7138, 2021, 3, '')
                                  EXEC [dbo].[ap_tax_rpl_check_unregistered] 7031, '20210315'

/*ГЕНЕРАЦИЯ XML ФАЙЛОВ*/          EXEC [Elit].[ap_EXITE_ExportDoc]
                                  EXEC [Elit].[ap_EXITE_TaxDoc]
                                  EXEC [Elit].[ap_EXITE_CreateMessage]

/*ФОРМИРОВАНИЕ DECLAR*/           EXEC [Alef_Elit].[ap_Workflow_Create_DECLAR] /*Формирует налоговую накладную DECLAR через процедуру Elit.dbo.ap_EXITE_CreateMessage @MsgType = ''DECLAR'... (курсор собираем исходя из того, на основании чего формируется налоговая по каждой сети). Обновляет статусы в реестре at_EDI_reg_files.*/
/*email уведомления (статусы +)*/ EXEC [Elit].[ap_SendEmailEDI] @DocType = 24000
/*Реестр ВХОДЯЩИХ документов*/    SELECT top(100) * FROM [S-PPC.CONST.ALEF.UA].[alef_elit].[dbo].[at_EDI_reg_files] ORDER BY lastupdatedata DESC
/*Реестр ИСХОДЯЩИХ файлов*/       SELECT top(100) * FROM [s-sql-d4].[elit].[dbo].[at_z_FilesExchange] WHERE 1 = 1 /*AND filename like '%rozetka%' AND statecode = 403*/ ORDER BY Chid DESC
                                  SELECT top(100) * FROM [s-sql-d4].[elit].[dbo].[at_z_FilesExchange] WHERE 1 = 1 AND filename like '%contrl%' ORDER BY Chid DESC

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*ЗАПУСК ДЖОБОВ*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Остановка для тестов EXITE_SYNC_EDI*/   EXEC [S-PPC.CONST.ALEF.UA].[msdb].dbo.sp_update_job @job_name = 'EXITE_SYNC_EDI', @enabled = 1 --0/1.

/*Информация по джобам*/    EXEC msdb.dbo.sp_help_job @job_name = 'ELIT Servers_ping_check'
                            EXEC msdb.dbo.sp_help_job @execution_status = 1
                            EXEC msdb.dbo.sp_help_job @execution_status = 0
                            EXEC master..xp_sqlagent_enum_jobs 1, 'corp\cluster' --running (have a status of 1, 2, 3, or 7).
/*Запуск ELIT ExiteSync*/   EXEC [S-SQL-D4].[msdb].dbo.sp_start_job 'ELIT ExiteSync'; EXEC [S-SQL-D4].[msdb].dbo.sp_help_jobactivity @job_name = 'ELIT ExiteSync'; USE Elit
                            EXEC dbo.ap_EXITE_Sync --без отправки.
/*Запуск EDI*/              EXEC [S-PPC.CONST.ALEF.UA].[msdb].dbo.sp_start_job 'EDI';
/*Запуск EXITE_SYNC_EDI*/   EXEC [S-PPC.CONST.ALEF.UA].[msdb].dbo.sp_start_job 'EXITE_SYNC_EDI';

/*Запуск WORKFLOW*/         EXEC [S-PPC.CONST.ALEF.UA].[msdb].dbo.sp_start_job 'Workflow';
/*Запуск WORKFLOW*/         EXEC [S-SQL-D4].[msdb].dbo.sp_start_job 'ELIT Servers_ping_check';
                            EXEC [S-PPC.CONST.ALEF.UA].[msdb].dbo.sp_start_job 'Workflow'; WAITFOR DELAY '00:01:00'; EXEC [S-PPC.CONST.ALEF.UA].[msdb].dbo.sp_start_job 'EXITE_SYNC_EDI', @step_name = 'Send_2_FTP_autosend';
                            EXEC [S-PPC.CONST.ALEF.UA].[msdb].dbo.sp_start_job 'Workflow', @step_name = 'Export_Comdoc_006'; WAITFOR DELAY '00:01:00'; EXEC [S-PPC.CONST.ALEF.UA].[msdb].dbo.sp_start_job 'EXITE_SYNC_EDI', @step_name = 'Send_2_FTP_autosend';
                            EXEC [S-PPC.CONST.ALEF.UA].[msdb].dbo.sp_start_job 'Workflow', @step_name = 'Create_Comdoc_006_Rozetka'; WAITFOR DELAY '00:01:00'; EXEC [S-PPC.CONST.ALEF.UA].[msdb].dbo.sp_start_job 'EXITE_SYNC_EDI', @step_name = 'Send_2_FTP_autosend';
                            EXEC [S-PPC.CONST.ALEF.UA].[msdb].dbo.sp_start_job 'Workflow', @step_name = 'Create_Comdoc_006_Metro'; WAITFOR DELAY '00:01:00'; EXEC [S-PPC.CONST.ALEF.UA].[msdb].dbo.sp_start_job 'EXITE_SYNC_EDI', @step_name = 'Send_2_FTP_autosend';
                            EXEC [S-PPC.CONST.ALEF.UA].[msdb].dbo.sp_start_job 'Workflow', @step_name = 'Create_Declar'; WAITFOR DELAY '00:00:30'; EXEC [S-PPC.CONST.ALEF.UA].[msdb].dbo.sp_start_job 'EXITE_SYNC_EDI', @step_name = 'Send_2_FTP_autosend';
                            EXEC [S-PPC.CONST.ALEF.UA].[msdb].dbo.sp_start_job 'Workflow', @step_name = 'Export_Declar'; WAITFOR DELAY '00:00:30'; EXEC [S-PPC.CONST.ALEF.UA].[msdb].dbo.sp_start_job 'EXITE_SYNC_EDI', @step_name = 'Send_2_FTP_autosend';
/*WORKFLOW с отправкой*/
    /*
    WAITFOR DELAY '00:00:30'; EXEC [S-PPC.CONST.ALEF.UA].[msdb].dbo.sp_help_jobactivity @job_name = 'workflow'
    GO
    WAITFOR DELAY '00:00:05'; EXEC [S-PPC.CONST.ALEF.UA].[msdb].dbo.sp_start_job 'EXITE_SYNC_EDI', @step_name = 'Send_2_FTP_autosend'
    GO
    */

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*ДЛЯ СЕТИ METRO: ЕСЛИ УВЕДОМЛЕНИЕ О ПРИЕМЕ ПРИШЛО БЕЗ ЗАКАЗА (РУЧНИКИ)*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--МЕТРО: GLN 4820086630009 (вода/алкоголь)
SELECT orderid, * FROM t_inv where compid in (7001, 7003) and docid = 3354737 order by 1 desc --Номер уведомления об отгрузке = DocID
SELECT top 10 TaxDocDate, OrderID, * FROM t_inv m where compid in (7001,7003) and Notes like '%вне маршрута%' ORDER BY m.TaxDocDate DESC
SELECT OrderID, * FROM t_inv m where docid = 3326057 and compid in (7001,7003) and Notes like '%вне маршрута%' ORDER BY m.TaxDocDate DESC
SELECT OrderID, TaxDocID, TaxDocDate, TSumCC_nt, TTaxSum, TSumCC_wt, * FROM t_inv where Notes like '%вне маршрута%' and TSumCC = 16590 and compid in (7001, 7003) order by 1 desc 

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*ВЕЛИКА КИШЕНЯ (ОТПРАВКА НАЛОГОВОЙ)*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--взять номер заказа из xml файла (приходная накладная). 
SELECT AEI_XML.value('(/ЕлектроннийДокумент/Заголовок/НомерЗамовлення)[1]', 'varchar(100)') 'Номер заказа' FROM az_EDI_Invoices_ WHERE AEI_DOC_ID = '61923632'
SELECT * FROM az_EDI_Invoices_ 
WHERE 1 = 1
    --AND AEI_XML.value('(/ЕлектроннийДокумент/Сторони/Контрагент/КодКонтрагента)[1]', 'varchar(100)') = 36003603
    --AND AEI_AUDIT_DATE >= convert(date, '20201201', 102) and AEI_AUDIT_DATE < CONVERT(date, '20210217', 102)
    AND AEI_DOC_ID = '61923632'
    AND AEI_INV_ID = 17276
ORDER BY AEI_AUDIT_DATE DESC

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*НАЙТИ XML ДОКУМЕНТ В РЕЕСТРЕ ПО № ЗАКАЗА*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT * FROM at_z_FilesExchange ORDER BY CHID DESC

SELECT * FROM at_z_FilesExchange
WHERE 1 = 1
    AND [FileName] like '%desadv%' 
    AND FileData.value('(./DESADV/ORDERNUMBER)[1]','nvarchar(100)') = 'РОЗ00941232' 
    --AND FileData.value('(./DECLAR/DECLARBODY/HNUM)[1]','nvarchar(100)') = '25041' 
    --AND FileData.value('(./DECLAR/DECLARHEAD/D_FILL)[1]','nvarchar(100)') like '%062020%'
    --AND DATEPART(month,docdate) = 6 
ORDER BY DocTime DESC
*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*OPTIONAL*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
sp_helplogins @LoginNamePattern = 'kgv5'
SELECT * FROM sys.databases --все бд на сервере.
EXEC sp_helprolemember 'db_datareader'; --кто в роли db_datareader в текущей БД.
SELECT top 10 *, m.send_request_date FROM msdb.dbo.sysmail_mailitems m ORDER BY m.send_request_date DESC
--Найти расходные по дате и compid:
SELECT OrderID, TaxDocID, * FROM t_inv WHERE CompID in (7138) and (DocDate = '20210309' or DocDate = '20210310' or DocDate = '20210311')
sp_helpdb --информация о базах данных.
*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*СЕТИ (коды предприятий)*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Сильпо - 7142
МЕТРО - 7001, 7003
РОЗЕТКА.УА - 7138
Медиатрейдинг - 7136 (* Медиатрейдинг техимпорт - 7158)
Новус - 7031
Эпицентр - 72226 Львов, 71746 Киев, 75137 Мелитополь, Запорожье, 56005 Первомайск (Николаевская обл.), 58103 Кировоград.
АТБ - 7004
Фудком - 7144
*/

