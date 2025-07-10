USE [msdb]
GO

/****** Object:  Job [Workflow]    Script Date: 25.02.2021 17:40:14 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [EDI]    Script Date: 25.02.2021 17:40:14 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'EDI' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'EDI'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Workflow', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'EDI подписание документов
[CHANGED] rkv0 ''2020-12-03 1233'' изменил расписание: с 08:00 (по просьбе Танцюры, чтобы уведомление по Розетке приходили раньше).', 
		@category_name=N'EDI', 
		@owner_login_name=N'sa', 
		@notify_email_operator_name=N'Support_arda', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[*OFF*] Пустышка..]    Script Date: 25.02.2021 17:40:14 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[*OFF*] Пустышка..', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--Пустой шаг для мгновенного появленя шага в журнале джобов.', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Import_Status]    Script Date: 25.02.2021 17:40:14 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Import_Status', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'powershell -command E:\Exite\powershell\Import_Status_reg_use.ps1', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Import_Recadv]    Script Date: 25.02.2021 17:40:14 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Import_Recadv', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'powershell -command E:\Exite\powershell\Import_Recadv_reg_use.ps1', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Import_RPL]    Script Date: 25.02.2021 17:40:14 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Import_RPL', 
		@step_id=4, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'powershell -command E:\Exite\powershell\Import_Rpl_Email_reg_use.ps1', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Import_Comdoc_006]    Script Date: 25.02.2021 17:40:14 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Import_Comdoc_006', 
		@step_id=5, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'powershell -command E:\Exite\powershell\Import_Comdoc_006_reg_use.ps1', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Import_Export_Comdoc_007]    Script Date: 25.02.2021 17:40:14 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Import_Export_Comdoc_007', 
		@step_id=6, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'powershell -command E:\Exite\powershell\Import_Comdoc_007.ps1', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[*OFF*] Import_Comdoc_012]    Script Date: 25.02.2021 17:40:14 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[*OFF*] Import_Comdoc_012', 
		@step_id=7, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'REM Убираем комментарии и воскрешаем..
REM [CHANGED] rkv0 ''2020-10-20 12:09'' мы не обрабатываем эти документы сейчас.
REM powershell -command E:\Exite\powershell\Import_Comdoc_012_Email_reg_use.ps1', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Check_Recadv]    Script Date: 25.02.2021 17:40:14 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Check_Recadv', 
		@step_id=8, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*DESCRIPTION*/
--Скрипт Import_Recadv_reg_use.ps1 добавляет записи в таблицы уведомлений о приеме: [s-ppc]ALEF_EDI_RECADV, [s-ppc]ALEF_EDI_RECADV_POS.
--А этот кусок кода обновляет статусы с 1 на 2,3 (статус 4 устаревший).
--rkv0 ''2020-11-30 14:50'' мне пока непонятно зачем нужно менять эти статусы (где эти статусы далее использутся??). К тому же, по сети METRO у них нет тегов DELIVEREDQUANTITY, по Розетке не учитываются розетко-единицы.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- [ADDED] rkv0 ''2020-12-07 13:26'' добавил блок отправки уведомления по новому RECADV для сети Сильпо. После получения RECADV нужно отправлять документ CONTRL (схема Invoice-Matching).


declare @in_id int
declare @in_date date
declare @ord_id varchar(100)
declare @invCnt int
declare @invCntOT int

declare cur cursor for
select REC_INV_ID ''in_id'', REC_INV_DATE ''in_date'', REC_ORD_ID ''ord_id'',
(select SUM(REP_DELIVER_QTY) from dbo.ALEF_EDI_RECADV_POS where REC_INV_ID = REP_INV_ID and REC_INV_DATE = REP_INV_DATE) ''invCnt''
from dbo.ALEF_EDI_RECADV
where REC_STATUS = 1

open cur 
fetch next from cur into @in_id, @in_date, @ord_id, @invCnt

while @@FETCH_STATUS = 0
    begin
	    execute(''select ? = (select SUM(Qty) from Elit.dbo.t_InvD d where i.ChID = d.ChID) from Elit.dbo.t_Inv i where TaxDocID = ? and OrderID = ? ;''
        , @invCntOT OUTPUT
        , @in_id
        , @ord_id)
        at [s-sql-d4]
	
	    update dbo.ALEF_EDI_RECADV
	    set
	    REC_STATUS = case when @invCnt = @invCntOT then 2 else 3 end --статус = 1, если кол-во ДОСТАВЛЕННЫХ бутылок в RECADV совпадает с нашей расходной; 3 - если не совпадает.
	    where 1 = 1
        and @invCntOT is not null
	    and REC_INV_ID = @in_id
	    and REC_INV_DATE = @in_date;
	
	    fetch next from cur into @in_id, @in_date, @ord_id, @invCnt
    end;

close cur
deallocate cur

-- [ADDED] rkv0 ''2020-12-07 13:26'' добавил блок отправки уведомления по новому RECADV для сети Сильпо. После получения RECADV нужно отправлять документ CONTRL (схема Invoice-Matching).
exec [s-sql-d4].[elit].[dbo].[ap_SendEmailEDI] @doctype = 5001
', 
		@database_name=N'Alef_Elit', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[*OFF*] Check_Comdoc_012]    Script Date: 25.02.2021 17:40:14 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[*OFF*] Check_Comdoc_012', 
		@step_id=9, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[CHANGED] rkv0 ''2020-10-20 12:09'' мы не обрабатываем эти документы сейчас.

/*old
--[s-sql-d4].Elit.dbo.sp_executesql N''update dbo.az_EDI_Invoices set AEI_STATUS = 3 from (select AEI_INV_ID INV_ID, AEI_INV_DATE INV_DATE, cast(AEI_DOC_ID as varchar(20)) DOC_ID, AEI_XML.value(''''(/ЕлектроннийДокумент/Заголовок/ДатаДокументу)[1]'''',''''smalldatetime'''') DOC_DATE, AEI_XML.value(''''(/ЕлектроннийДокумент/ВсьогоПоДокументу/СумаБезПДВ)[1]'''',''''numeric(21,9)'''') SumOnly, AEI_XML.value(''''(/ЕлектроннийДокумент/ВсьогоПоДокументу/ПДВ)[1]'''',''''numeric(21,9)'''') Wat, AEI_XML.value(''''(/ЕлектроннийДокумент/ВсьогоПоДокументу/Сума)[1]'''',''''numeric(21,9)'''') SumWat from dbo.az_EDI_Invoices where AEI_DOC_TYPE = 12 and AEI_STATUS = 2) as T1 inner join dbo.t_Ret on SrcDocID = DOC_ID and SrcTaxDocID = INV_ID and SrcTaxDocDate = INV_DATE and SrcDocDate = TaxDocDate and SrcDocDate = DOC_DATE and TaxDocID > 0 and TSumCC_nt = SumOnly and TTaxSum = Wat and TSumCC_wt = SumWat where AEI_INV_ID = INV_ID and AEI_INV_DATE = INV_DATE and AEI_DOC_TYPE = 12;''
*/

-- new
/*
--[CHANGED] rkv0 ''2020-10-20 12:09'' мы не обрабатываем эти документы сейчас.
[s-sql-d4].Elit.dbo.sp_executesql N''update dbo.az_EDI_Invoices set AEI_STATUS = 3 from (select AEI_INV_ID INV_ID, AEI_INV_DATE INV_DATE, cast(AEI_DOC_ID as varchar(20)) DOC_ID, AEI_XML.value(''''(/ЕлектроннийДокумент/Заголовок/ДатаДокументу)[1]'''',''''smalldatetime'''') DOC_DATE, AEI_XML.value(''''(/ЕлектроннийДокумент/ВсьогоПоДокументу/СумаБезПДВ)[1]'''',''''numeric(21,9)'''') SumOnly, AEI_XML.value(''''(/ЕлектроннийДокумент/ВсьогоПоДокументу/ПДВ)[1]'''',''''numeric(21,9)'''') Wat, AEI_XML.value(''''(/ЕлектроннийДокумент/ВсьогоПоДокументу/Сума)[1]'''',''''numeric(21,9)'''') SumWat from dbo.az_EDI_Invoices where AEI_DOC_TYPE = 12 and AEI_STATUS = 2) as T1 inner join dbo.t_Ret on SrcTaxDocID = INV_ID and SrcTaxDocDate = INV_DATE and TaxDocID > 0 and TSumCC_nt = SumOnly and TTaxSum = Wat and TSumCC_wt = SumWat where AEI_INV_ID = INV_ID and AEI_INV_DATE = INV_DATE and AEI_DOC_TYPE = 12;''
*/', 
		@database_name=N'Alef_Elit', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Create_Comdoc_006_Rozetka]    Script Date: 25.02.2021 17:40:15 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Create_Comdoc_006_Rozetka', 
		@step_id=10, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--moa0 ''2019-10-22 09:45'' Переходим на создание Comdoc 006 для Розетки.
EXEC [dbo].[ap_Workflow_Create_Comdoc006_Rozetka]

', 
		@database_name=N'Alef_Elit', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Update_Recadv_status_Metro]    Script Date: 25.02.2021 17:40:15 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Update_Recadv_status_Metro', 
		@step_id=11, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--Берем в таблице [s-sql-d4].dbo.at_z_FilesExchange отправленные счета INVOICE со статусом 403, парсим из xml №заказа, 
--по этому №заказа ищем RECADV в [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.at_EDI_reg_files
--Обновляем статус RECADV на [Status] = 9.
EXEC [dbo].[ap_EDI_METRO_Recadv_Status_Update]', 
		@database_name=N'Alef_Elit', 
		@flags=20
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Create_Comdoc_006_Metro]    Script Date: 25.02.2021 17:40:15 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Create_Comdoc_006_Metro', 
		@step_id=12, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--rkv0 ''2019-11-11 10:30'' Добавляем создание DocumentInvoice (Comdoc 006) для Metro.
EXEC [dbo].[ap_Workflow_Create_Comdoc006_Metro]', 
		@database_name=N'Alef_Elit', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Export_Comdoc_006]    Script Date: 25.02.2021 17:40:15 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Export_Comdoc_006', 
		@step_id=13, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'powershell -command e:\Exite\powershell\Export_Comdoc_006.ps1', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[*OFF*] Export_Comdoc_012]    Script Date: 25.02.2021 17:40:15 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[*OFF*] Export_Comdoc_012', 
		@step_id=14, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'REM Убираем комментарии и воскрешаем..
REM отключен moa0 22.04.2019 17:14
REM powershell -command E:\Exite\powershell\Export_Comdoc_012.ps1', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Create_Declar]    Script Date: 25.02.2021 17:40:15 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Create_Declar', 
		@step_id=15, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--Создать Налоговую накладную
EXEC [dbo].[ap_Workflow_Create_Declar]', 
		@database_name=N'Alef_Elit', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Export_Declar]    Script Date: 25.02.2021 17:40:15 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Export_Declar', 
		@step_id=16, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'powershell -command E:\Exite\powershell\Export_Declar_new_logs.ps1', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Export_Declar_Metro]    Script Date: 25.02.2021 17:40:15 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Export_Declar_Metro', 
		@step_id=17, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'powershell -command e:\Exite\powershell\Export_Declar_new_logs_METRO.ps1', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Create_METRO_package]    Script Date: 25.02.2021 17:40:15 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Create_METRO_package', 
		@step_id=18, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--rkv0 ''2019-11-18 14:18''
--Создает packageDescription.xml для архива documentpacket(...).zip (только для Metro).
EXEC [dbo].[ap_Workflow_Create_PACKAGE_METRO]', 
		@database_name=N'Alef_Elit', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Export_METRO_package]    Script Date: 25.02.2021 17:40:15 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Export_METRO_package', 
		@step_id=19, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'powershell -command e:\Exite\powershell\Export_PACKAGE_METRO.ps1', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Export_document_packet_ZIP_METRO]    Script Date: 25.02.2021 17:40:15 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Export_document_packet_ZIP_METRO', 
		@step_id=20, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'powershell -command e:\Exite\powershell\Export_document_packet_ZIP_METRO.ps1
', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Send_email_METRO_new RECADV (*ruchnik KPK)]    Script Date: 25.02.2021 17:40:15 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Send_email_METRO_new RECADV (*ruchnik KPK)', 
		@step_id=21, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC [dbo].[ap_EDI_METRO_KPK_Recadv]', 
		@database_name=N'Alef_Elit', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[*OFF*] SendToFtp]    Script Date: 25.02.2021 17:40:15 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[*OFF*] SendToFtp', 
		@step_id=22, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'REM 20201208 Этот шаг не нужен, т.к. для отправки файлов в папку Черновики на сайте EDIN используется другой джоб на d4 - Elit ExiteSync.
REM powershell -command E:\Exite\powershell\Send_2_FTP_modify_logs.ps1', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [[*OFF*] SendToFTP_autosend]    Script Date: 25.02.2021 17:40:15 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'[*OFF*] SendToFTP_autosend', 
		@step_id=23, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=1, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'REM убираем комментарии и воскрешаем.
REM [CHANGED] Maslov Oleg ''2020-10-12 12:46:28.769'' Недавно был сделан новый джоб [EXITE_SYNC_EDI] который денлает этот шаг каждые 5 минут. В итоге сегодня случилась ошибка, что джобы не поделили файлы на отправку. Выключаю этот шаг.
REM powershell -command E:\Exite\powershell\Send_2_FTP_autosend_modify_logs.ps1', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'EDI-time-1hour-8-18', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=126, 
		@freq_subday_type=8, 
		@freq_subday_interval=1, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20150212, 
		@active_end_date=99991231, 
		@active_start_time=80500, 
		@active_end_time=181000, 
		@schedule_uid=N'8f490039-6a22-4b0b-ba26-a8b1b6d9ebbb'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO


