--Workflow
EDI подписание документов
[CHANGED] rkv0 '2020-12-03 1233' изменил расписание: с 08:00 (по просьбе Танцюры, чтобы уведомление по Розетке приходили раньше).

Выполняется раз в неделю в понедельник, вторник, среда, четверг, пятница, суббота, каждые 1 ч между 8:05:00 и 18:10:00. Расписание будет использоваться с 12.02.2015.

BEGIN TRAN
1. Import_Status
powershell -command E:\Exite\powershell\Import_Status_reg_use.ps1

2. Import_Recadv
powershell -command E:\Exite\powershell\Import_Recadv_reg_use.ps1

3. Import_RPL
powershell -command E:\Exite\powershell\Import_Rpl_Email_reg_use.ps1

4. Import_Comdoc_006
powershell -command E:\Exite\powershell\Import_Comdoc_006_reg_use.ps1

5. Import_Export_Comdoc_007
powershell -command E:\Exite\powershell\Import_Comdoc_007.ps1

6. [*OFF*] Import_Comdoc_012
REM Убираем комментарии и воскрешаем..
REM [CHANGED] rkv0 '2020-10-20 12:09' мы не обрабатываем эти документы сейчас.
REM powershell -command E:\Exite\powershell\Import_Comdoc_012_Email_reg_use.ps1

7. Check_Recadv
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*DESCRIPTION*/
--Скрипт Import_Recadv_reg_use.ps1 добавляет записи в таблицы уведомлений о приеме: [s-ppc]ALEF_EDI_RECADV, [s-ppc]ALEF_EDI_RECADV_POS.
--А этот кусок кода обновляет статусы с 1 на 2,3 (статус 4 устаревший).
--rkv0 '2020-11-30 14:50' мне пока непонятно зачем нужно менять эти статусы (где эти статусы далее использутся??). К тому же, по сети METRO у них нет тегов DELIVEREDQUANTITY, по Розетке не учитываются розетко-единицы.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- [ADDED] rkv0 '2020-12-07 13:26' добавил блок отправки уведомления по новому RECADV для сети Сильпо. После получения RECADV нужно отправлять документ CONTRL (схема Invoice-Matching).


declare @in_id int
declare @in_date date
declare @ord_id varchar(100)
declare @invCnt int
declare @invCntOT int

declare cur cursor for
select REC_INV_ID 'in_id', REC_INV_DATE 'in_date', REC_ORD_ID 'ord_id',
(select SUM(REP_DELIVER_QTY) from dbo.ALEF_EDI_RECADV_POS where REC_INV_ID = REP_INV_ID and REC_INV_DATE = REP_INV_DATE) 'invCnt'
from dbo.ALEF_EDI_RECADV
where REC_STATUS = 1

open cur 
fetch next from cur into @in_id, @in_date, @ord_id, @invCnt

while @@FETCH_STATUS = 0
    begin
	    execute('select ? = (select SUM(Qty) from Elit.dbo.t_InvD d where i.ChID = d.ChID) from Elit.dbo.t_Inv i where TaxDocID = ? and OrderID = ? ;'
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

-- [ADDED] rkv0 '2020-12-07 13:26' добавил блок отправки уведомления по новому RECADV для сети Сильпо. После получения RECADV нужно отправлять документ CONTRL (схема Invoice-Matching).
exec [s-sql-d4].[elit].[dbo].[ap_SendEmailEDI] @doctype = 5001

8. [*OFF*] Check_Comdoc_012
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[CHANGED] rkv0 '2020-10-20 12:09' мы не обрабатываем эти документы сейчас.

/*old
--[s-sql-d4].Elit.dbo.sp_executesql N'update dbo.az_EDI_Invoices set AEI_STATUS = 3 from (select AEI_INV_ID INV_ID, AEI_INV_DATE INV_DATE, cast(AEI_DOC_ID as varchar(20)) DOC_ID, AEI_XML.value(''(/ЕлектроннийДокумент/Заголовок/ДатаДокументу)[1]'',''smalldatetime'') DOC_DATE, AEI_XML.value(''(/ЕлектроннийДокумент/ВсьогоПоДокументу/СумаБезПДВ)[1]'',''numeric(21,9)'') SumOnly, AEI_XML.value(''(/ЕлектроннийДокумент/ВсьогоПоДокументу/ПДВ)[1]'',''numeric(21,9)'') Wat, AEI_XML.value(''(/ЕлектроннийДокумент/ВсьогоПоДокументу/Сума)[1]'',''numeric(21,9)'') SumWat from dbo.az_EDI_Invoices where AEI_DOC_TYPE = 12 and AEI_STATUS = 2) as T1 inner join dbo.t_Ret on SrcDocID = DOC_ID and SrcTaxDocID = INV_ID and SrcTaxDocDate = INV_DATE and SrcDocDate = TaxDocDate and SrcDocDate = DOC_DATE and TaxDocID > 0 and TSumCC_nt = SumOnly and TTaxSum = Wat and TSumCC_wt = SumWat where AEI_INV_ID = INV_ID and AEI_INV_DATE = INV_DATE and AEI_DOC_TYPE = 12;'
*/

-- new
/*
--[CHANGED] rkv0 '2020-10-20 12:09' мы не обрабатываем эти документы сейчас.
[s-sql-d4].Elit.dbo.sp_executesql N'update dbo.az_EDI_Invoices set AEI_STATUS = 3 from (select AEI_INV_ID INV_ID, AEI_INV_DATE INV_DATE, cast(AEI_DOC_ID as varchar(20)) DOC_ID, AEI_XML.value(''(/ЕлектроннийДокумент/Заголовок/ДатаДокументу)[1]'',''smalldatetime'') DOC_DATE, AEI_XML.value(''(/ЕлектроннийДокумент/ВсьогоПоДокументу/СумаБезПДВ)[1]'',''numeric(21,9)'') SumOnly, AEI_XML.value(''(/ЕлектроннийДокумент/ВсьогоПоДокументу/ПДВ)[1]'',''numeric(21,9)'') Wat, AEI_XML.value(''(/ЕлектроннийДокумент/ВсьогоПоДокументу/Сума)[1]'',''numeric(21,9)'') SumWat from dbo.az_EDI_Invoices where AEI_DOC_TYPE = 12 and AEI_STATUS = 2) as T1 inner join dbo.t_Ret on SrcTaxDocID = INV_ID and SrcTaxDocDate = INV_DATE and TaxDocID > 0 and TSumCC_nt = SumOnly and TTaxSum = Wat and TSumCC_wt = SumWat where AEI_INV_ID = INV_ID and AEI_INV_DATE = INV_DATE and AEI_DOC_TYPE = 12;'
*/

9. Create_Comdoc_006_Rozetka
--moa0 '2019-10-22 09:45' Переходим на создание Comdoc 006 для Розетки.
EXEC [dbo].[ap_Workflow_Create_Comdoc006_Rozetka]

10. Update_Recadv_status_Metro
--Берем в таблице [s-sql-d4].dbo.at_z_FilesExchange отправленные счета INVOICE со статусом 403, парсим из xml №заказа, 
--по этому №заказа ищем RECADV в [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.at_EDI_reg_files
--Обновляем статус RECADV на [Status] = 9.
EXEC [dbo].[ap_EDI_METRO_Recadv_Status_Update]

11. Create_Comdoc_006_Metro
--rkv0 '2019-11-11 10:30' Добавляем создание DocumentInvoice (Comdoc 006) для Metro.
EXEC [dbo].[ap_Workflow_Create_Comdoc006_Metro]

12. Export_Comdoc_006
powershell -command e:\Exite\powershell\Export_Comdoc_006.ps1

13. Export_Comdoc_006_Metro
powershell -command e:\Exite\powershell\Export_Comdoc_006_METRO.ps1

14. [*OFF*] Export_Comdoc_012
REM Убираем комментарии и воскрешаем..
REM отключен moa0 22.04.2019 17:14
REM powershell -command E:\Exite\powershell\Export_Comdoc_012.ps1

15. Create_Declar
--Создать Налоговую накладную
EXEC [dbo].[ap_Workflow_Create_Declar]

16. Export_Declar
powershell -command E:\Exite\powershell\Export_Declar_new_logs.ps1

17. Export_Declar_Metro
powershell -command e:\Exite\powershell\Export_Declar_new_logs_METRO.ps1

18. Create_METRO_package
--rkv0 '2019-11-18 14:18'
--Создает packageDescription.xml для архива documentpacket(...).zip (только для Metro).
EXEC [dbo].[ap_Workflow_Create_PACKAGE_METRO]

19. Export_METRO_package
powershell -command e:\Exite\powershell\Export_PACKAGE_METRO.ps1

20. Export_document_packet_ZIP_METRO
powershell -command e:\Exite\powershell\Export_document_packet_ZIP_METRO.ps1

21. Send_email_METRO_new RECADV (*ruchnik KPK)
EXEC [dbo].[ap_EDI_METRO_KPK_Recadv]

22. [*OFF*] SendToFtp
REM 20201208 Этот шаг не нужен, т.к. для отправки файлов в папку Черновики на сайте EDIN используется другой джоб на d4 - Elit ExiteSync.
REM powershell -command E:\Exite\powershell\Send_2_FTP_modify_logs.ps1

23. [*OFF*] SendToFTP_autosend
REM убираем комментарии и воскрешаем.
REM [CHANGED] Maslov Oleg '2020-10-12 12:46:28.769' Недавно был сделан новый джоб [EXITE_SYNC_EDI] который денлает этот шаг каждые 5 минут. В итоге сегодня случилась ошибка, что джобы не поделили файлы на отправку. Выключаю этот шаг.
REM powershell -command E:\Exite\powershell\Send_2_FTP_autosend_modify_logs.ps1


ROLLBACK TRAN