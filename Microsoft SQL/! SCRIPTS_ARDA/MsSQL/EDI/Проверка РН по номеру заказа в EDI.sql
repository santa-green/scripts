USE Elit
--USE Elit_TEST
GO

EXEC dbo.ap_Get_tInv_by_EDI_Order '  4517108031  '

IF 1=0
BEGIN
--#region EXTRA
/*Ïåðåçàëèâêà çàêàçà ïî 7158 Òåõèìïîðò*/ EXEC [ap_EDI_Rozetka_Techimport] 'ÐÎÇ10713694'
/*Èíñòðóìåíò F11: \\s-sql-d4.corp.local\OT38ElitServer\ReportsUni\Elit\Áèçíåñ\Èíñòðóìåíòû\Ýêñïîðò EXITE.fr3*/
/*Ïîèñê ïî íîìåðó ÍÍ*/            SELECT OrderID, * FROM t_Inv WHERE TaxDocID in (21059) AND COMPID in (7136, 7138) ORDER BY 1 DESC
/*ÓÑÊÎÐÈÒÜ ÇÀËÈÂÊÓ ÇÀÊÀÇÎÂ*/      EXEC [S-PPC.CONST.ALEF.UA].[Alef_Elit].dbo.ap_pushOrdersEDI 
/*ÏÅÐÅÎÒÏÐÀÂÊÀ ÐÎÇÅÒÊÈ*/          EXEC [S-PPC.CONST.ALEF.UA].[alef_elit].[dbo].[ap_EDI_Resend_COMDOC_Rozetka] 'ÐÎÇ10777330';
/*ÏÅÐÅÎÒÏÐÀÂÊÀ METRO*/            EXEC [S-PPC.CONST.ALEF.UA].[alef_elit].[dbo].[ap_EDI_Resend_COMDOC_Metro] '45359437' --@orderid - ¹ çàêàçà â EDI.
/*ÏÐÎÂÅÐÈÒÜ ÐÅÃ-ÖÈÞ ÍÀËÎÃÎÂÛÕ*/   SELECT * FROM [dbo].[af_tax_rpl_check_all] (DEFAULT, 2021, 9, '8004')
                                  EXEC [dbo].[ap_tax_rpl_check_unregistered] 7031, '20210315'
                                  SELECT * FROM alef_edi_rpl WHERE AER_TAX_ID = 16017

/*ÃÅÍÅÐÀÖÈß XML ÔÀÉËÎÂ*/          EXEC [Elit].[ap_EXITE_ExportDoc]
                                  EXEC [Elit].[ap_EXITE_TaxDoc]
                                  EXEC [Elit].[ap_EXITE_CreateMessage]
/*Îòïðàâêà DECLAR ïî Íîâóñ*/      EXEC [Elit].[ap_EDI_send_DECLAR_Novus_bydate] 

/*ÔÎÐÌÈÐÎÂÀÍÈÅ DECLAR*/           EXEC [Alef_Elit].[ap_Workflow_Create_DECLAR] /*Ôîðìèðóåò íàëîãîâóþ íàêëàäíóþ DECLAR ÷åðåç ïðîöåäóðó Elit.dbo.ap_EXITE_CreateMessage @MsgType = ''DECLAR'... (êóðñîð ñîáèðàåì èñõîäÿ èç òîãî, íà îñíîâàíèè ÷åãî ôîðìèðóåòñÿ íàëîãîâàÿ ïî êàæäîé ñåòè). Îáíîâëÿåò ñòàòóñû â ðååñòðå at_EDI_reg_files.*/
/*email óâåäîìëåíèÿ (ñòàòóñû +)*/ EXEC [Elit].[ap_SendEmailEDI] @DocType = 24000
/*Ðååñòð ÂÕÎÄßÙÈÕ äîêóìåíòîâ*/    SELECT top(100) * FROM [S-PPC.CONST.ALEF.UA].[alef_elit].[dbo].[at_EDI_reg_files] ORDER BY lastupdatedata DESC
/*Ðååñòð ÈÑÕÎÄßÙÈÕ ôàéëîâ*/       SELECT * FROM [s-sql-d4].[elit].[dbo].[at_z_FilesExchange] WHERE 1 = 1 /*AND filename like '%32000037029549J1201012100001023210920213200.xml%'*/  ORDER BY Chid DESC
/*Ðååñòð ÈÑÕÎÄßÙÈÕ ôàéëîâ*/       SELECT * FROM [s-sql-d4].[elit].[dbo].[at_z_FilesExchange] WHERE 1 = 1 AND filename like '%32000037029549J1201012100001023210920213200.xml%'  ORDER BY Chid DESC
/*Ðååñòð ÈÑÕÎÄßÙÈÕ ôàéëîâ*/       SELECT * FROM [s-sql-d4].[elit].[dbo].[at_z_FilesExchange] WHERE 1 = 1 AND ChID between 117630 and 117638  ORDER BY Chid DESC
                                  SELECT top(100) * FROM [s-sql-d4].[elit].[dbo].[at_z_FilesExchange] WHERE 1 = 1 AND filename like '%contrl%' ORDER BY Chid DESC
                                  --Ýêñïîðò äàííûõ â ðååñòð ïðèõîäíûõ [d4]az_EDI_Invoices_ óæå ïîäïèñàííûõ *007.p7s (ÍÅ ïîäïèñàííûå ñþäà íå ïîïàäàþò!). 
                                  SELECT TOP(100) m.AEI_AUDIT_DATE, * FROM [s-sql-d4].[elit].dbo.az_EDI_Invoices_ m ORDER BY m.AEI_AUDIT_DATE DESC
--#endregion EXTRA

--#region ÇÀÏÓÑÊ ÄÆÎÁÎÂ
/*Îñòàíîâêà äëÿ òåñòîâ EXITE_SYNC_EDI*/   EXEC [S-PPC.CONST.ALEF.UA].[msdb].dbo.sp_update_job @job_name = 'EXITE_SYNC_EDI', @enabled = 1 --0/1.

/*Èíôîðìàöèÿ ïî äæîáàì*/    EXEC msdb.dbo.sp_help_job @job_name = 'ELIT Servers_ping_check'
/*Èíôîðìàöèÿ ïî äæîáàì*/    EXEC msdb.dbo.sp_help_job @job_name = 'ELIT Servers_ping_check'
                            EXEC msdb.dbo.sp_help_job @execution_status = 1
                            EXEC msdb.dbo.sp_help_job @execution_status = 0
                            EXEC master..xp_sqlagent_enum_jobs 1, 'corp\cluster' --running (have a status of 1, 2, 3, or 7).
/*Çàïóñê ELIT ExiteSync*/   EXEC [S-SQL-D4].[msdb].dbo.sp_start_job 'ELIT ExiteSync'; EXEC [S-SQL-D4].[msdb].dbo.sp_help_jobactivity @job_name = 'ELIT ExiteSync'; USE Elit
                            EXEC dbo.ap_EXITE_Sync --áåç îòïðàâêè.
                            EXEC msdb.dbo.sp_update_job @job_name = N'ELIT ExiteSync', @enabled = 0 /*1*/ --äëÿ òåñòà îñòàíîâèòü/çàïóñòèòü äæîá.

/*Çàïóñê EDI*/              EXEC [S-PPC.CONST.ALEF.UA].[msdb].dbo.sp_start_job 'EDI';
/*Çàïóñê EXITE_SYNC_EDI*/   EXEC [S-PPC.CONST.ALEF.UA].[msdb].dbo.sp_start_job 'EXITE_SYNC_EDI';

/*Çàïóñê WORKFLOW*/         EXEC [S-PPC.CONST.ALEF.UA].[msdb].dbo.sp_start_job 'Workflow';
/*Çàïóñê WORKFLOW*/         EXEC [S-SQL-D4].[msdb].dbo.sp_start_job 'ELIT Servers_ping_check';
                            EXEC [S-PPC.CONST.ALEF.UA].[msdb].dbo.sp_start_job 'Workflow', @step_name = 'Export_Comdoc_006'; WAITFOR DELAY '00:01:00'; EXEC [S-PPC.CONST.ALEF.UA].[msdb].dbo.sp_start_job 'EXITE_SYNC_EDI', @step_name = 'Send_2_FTP_autosend';
                            EXEC [S-PPC.CONST.ALEF.UA].[msdb].dbo.sp_start_job 'Workflow', @step_name = 'Create_Comdoc_006_Rozetka'; WAITFOR DELAY '00:01:00'; EXEC [S-PPC.CONST.ALEF.UA].[msdb].dbo.sp_start_job 'EXITE_SYNC_EDI', @step_name = 'Send_2_FTP_autosend';
                            EXEC [S-PPC.CONST.ALEF.UA].[msdb].dbo.sp_start_job 'Workflow', @step_name = 'Create_Comdoc_006_Metro'; WAITFOR DELAY '00:01:00'; EXEC [S-PPC.CONST.ALEF.UA].[msdb].dbo.sp_start_job 'EXITE_SYNC_EDI', @step_name = 'Send_2_FTP_autosend';
                            EXEC [S-PPC.CONST.ALEF.UA].[msdb].dbo.sp_start_job 'Workflow', @step_name = 'Create_Declar'; WAITFOR DELAY '00:00:30'; EXEC [S-PPC.CONST.ALEF.UA].[msdb].dbo.sp_start_job 'EXITE_SYNC_EDI', @step_name = 'Send_2_FTP_autosend';
                            EXEC [S-PPC.CONST.ALEF.UA].[msdb].dbo.sp_start_job 'Workflow', @step_name = 'Export_Declar'; WAITFOR DELAY '00:00:30'; EXEC [S-PPC.CONST.ALEF.UA].[msdb].dbo.sp_start_job 'EXITE_SYNC_EDI', @step_name = 'Send_2_FTP_autosend';
                            EXEC [S-PPC.CONST.ALEF.UA].[msdb].dbo.sp_stop_job 'Workflow'
/*WORKFLOW ñ îòïðàâêîé*/
    EXEC [S-PPC.CONST.ALEF.UA].[msdb].dbo.sp_help_jobactivity @job_name = 'workflow'
    WAITFOR DELAY '00:01:00'; 
    EXEC [S-PPC.CONST.ALEF.UA].[msdb].dbo.sp_start_job 'EXITE_SYNC_EDI', @step_name = 'Send_2_FTP_autosend'
--#endregion ÇÀÏÓÑÊ ÄÆÎÁÎÂ

--#region ÄËß ÑÅÒÈ METRO: ÅÑËÈ ÓÂÅÄÎÌËÅÍÈÅ Î ÏÐÈÅÌÅ ÏÐÈØËÎ ÁÅÇ ÇÀÊÀÇÀ (ÐÓ×ÍÈÊÈ)
--ÌÅÒÐÎ: GLN 4820086630009 (âîäà/àëêîãîëü)
--Ñâåðèòüñÿ ìîæíî òàêæå áûñòðî ïî àäðåñó äîñòàâêè!
SELECT top 10 address, TaxDocDate, TSumCC_wt, OrderID, * FROM t_inv m where compid in (7001,7003) and Notes like '%âíå ìàðøðóòà%' ORDER BY m.TaxDocDate DESC
SELECT OrderID, TaxDocID, TaxDocDate, TSumCC_nt, TTaxSum, TSumCC_wt, * FROM t_inv where Notes like '%âíå ìàðøðóòà%' and TSumCC = 22455.36 and compid in (7001, 7003) order by 1 desc 
SELECT orderid, * FROM t_inv where compid in (7001, 7003) and docid = 3354737 order by 1 desc --Íîìåð óâåäîìëåíèÿ îá îòãðóçêå = DocID
SELECT OrderID, * FROM t_inv m where docid = 3326057 and compid in (7001,7003) and Notes like '%âíå ìàðøðóòà%' ORDER BY m.TaxDocDate DESC
--#endregion ÄËß ÑÅÒÈ METRO: ÅÑËÈ ÓÂÅÄÎÌËÅÍÈÅ Î ÏÐÈÅÌÅ ÏÐÈØËÎ ÁÅÇ ÇÀÊÀÇÀ (ÐÓ×ÍÈÊÈ)

--#region ÂÅËÈÊÀ ÊÈØÅÍß (ÎÒÏÐÀÂÊÀ ÍÀËÎÃÎÂÎÉ)
--âçÿòü íîìåð çàêàçà èç xml ôàéëà (ïðèõîäíàÿ íàêëàäíàÿ). 
SELECT AEI_XML.value('(/ÅëåêòðîííèéÄîêóìåíò/Çàãîëîâîê/ÍîìåðÇàìîâëåííÿ)[1]', 'varchar(100)') 'Íîìåð çàêàçà' FROM az_EDI_Invoices_ WHERE AEI_DOC_ID = '61923632'
SELECT * FROM az_EDI_Invoices_ 
WHERE 1 = 1
    --AND AEI_XML.value('(/ÅëåêòðîííèéÄîêóìåíò/Ñòîðîíè/Êîíòðàãåíò/ÊîäÊîíòðàãåíòà)[1]', 'varchar(100)') = 36003603
    --AND AEI_AUDIT_DATE >= convert(date, '20201201', 102) and AEI_AUDIT_DATE < CONVERT(date, '20210217', 102)
    AND AEI_DOC_ID = '61923632'
    AND AEI_INV_ID = 17276
ORDER BY AEI_AUDIT_DATE DESC
--#endregion ÂÅËÈÊÀ ÊÈØÅÍß (ÎÒÏÐÀÂÊÀ ÍÀËÎÃÎÂÎÉ)

--#region ÍÀÉÒÈ XML ÄÎÊÓÌÅÍÒ Â ÐÅÅÑÒÐÅ ÏÎ ¹ ÇÀÊÀÇÀ
SELECT * FROM at_z_FilesExchange ORDER BY CHID DESC

SELECT * FROM at_z_FilesExchange
WHERE 1 = 1
    AND [FileName] like '%desadv%' 
    AND FileData.value('(./DESADV/ORDERNUMBER)[1]','nvarchar(100)') = 'ÐÎÇ00941232' 
    --AND FileData.value('(./DECLAR/DECLARBODY/HNUM)[1]','nvarchar(100)') = '25041' 
    --AND FileData.value('(./DECLAR/DECLARHEAD/D_FILL)[1]','nvarchar(100)') like '%062020%'
    --AND DATEPART(month,docdate) = 6 
ORDER BY DocTime DESC

--#endregion ÍÀÉÒÈ XML ÄÎÊÓÌÅÍÒ Â ÐÅÅÑÒÐÅ ÏÎ ¹ ÇÀÊÀÇÀ

--#region OPTIONAL

EXEC sp_helplogins @LoginNamePattern = 'kgv5'
SELECT * FROM sys.databases --âñå áä íà ñåðâåðå.
EXEC sp_helprolemember 'db_datareader'; --êòî â ðîëè db_datareader â òåêóùåé ÁÄ.
SELECT top 10 *, m.send_request_date FROM msdb.dbo.sysmail_mailitems m ORDER BY m.send_request_date DESC
--Íàéòè ðàñõîäíûå ïî äàòå è compid:
SELECT OrderID, TaxDocID, * FROM t_inv WHERE CompID in (7001, 7003) and (DocDate = '20210511')
EXEC sp_helpdb --èíôîðìàöèÿ î áàçàõ äàííûõ.
--Ñïèñîê ïðåäïðèÿòèé, êîòîðûå äîëæíû óëåòàòü ÷åðåç ftp àâòîìàòîì (áåç ïàïêè ×åðíîâèêè)
SELECT * FROM r_uni WHERE RefTypeID = 6680134 

--#endregion OPTIONAL

--#region ÑÅÒÈ (êîäû ïðåäïðèÿòèé)
/* 
    Ñèëüïî - 7142
    ÌÅÒÐÎ - 7001 (âîäà), 7003 (àëê)
    ÐÎÇÅÒÊÀ.ÓÀ - 7138
    Ìåäèàòðåéäèíã - 7136 (* Ìåäèàòðåéäèíã òåõèìïîðò - 7158)
    Íîâóñ - 7031 (Ñîþç Ðèòåéë - 7134)
    Ýïèöåíòð - 72226 Ëüâîâ, 71746 Êèåâ, 75137 Ìåëèòîïîëü, Çàïîðîæüå, 56005 Ïåðâîìàéñê (Íèêîëàåâñêàÿ îáë.), 58103 Êèðîâîãðàä.
    ÀÒÁ - 7004
    Ôóäêîì - 7144
    Âàðóñ (Îìåãà) - 7011
    Òàâðèÿ Â - 7016 (Òàâðèÿ-Ïëþñ ×Ï), 7018 (Òàâðèÿ-È  ×Ï), 7013 (Òàâðèÿ-Â ÎÎÎ)
*/
--#endregion ÑÅÒÈ (êîäû ïðåäïðèÿòèé)

END;

