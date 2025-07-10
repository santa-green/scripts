--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*ВХОДЯЩИЕ*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT * FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.at_EDI_reg_files WITH(NOLOCK)
WHERE 1 = 1
      --AND DocType = 24000 --status
      --AND DocType = 2000 --order
      AND DocType = 5000 --recadv
	  --AND [Status] IN (3,4)				--Новый статус
	  --AND FILENAME LIKE '%recadv%'			--Только по COMDOC
	  --AND RetailersID = 9	
      AND month(InsertData) = 3 and year(InsertData) = 2021
ORDER BY InsertData DESC

--Recadv.
SELECT * FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.alef_edi_recadv WITH(NOLOCK) WHERE month(REC_AUDIT_DATE) = 3 and year(REC_AUDIT_DATE) = 2021
SELECT * FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.alef_edi_recadv WITH(NOLOCK) WHERE month(REC_AUDIT_DATE) = 3 and year(REC_AUDIT_DATE) = 2021 and rec_sender = '9863577638028' --9863577638028 Новус.

--Orders.
SELECT count(*) FROM alef_edi_orders_2 WITH(NOLOCK) 
WHERE /*zeo_zec_base in ('4820128010004', '4829900017774', '9864066811144') and*/ month(zeo_order_date) = 3 and year(zeo_order_date) = 2021
ORDER BY zeo_order_date DESC

SELECT * FROM AT_GLN WITH(NOLOCK) WHERE RetailersName like '%АТБ%'
SELECT * FROM AT_GLN WITH(NOLOCK) WHERE GLNNAME like '%АТБ%'
SELECT RETAILERSName, COUNT(*) FROM AT_GLN WITH(NOLOCK) GROUP BY RETAILERSName ORDER BY 1
SELECT ZEC_KOD_BASE FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.alef_edi_gln_ot WITH(NOLOCK) WHERE zec_kod_kln_ot = 7031 group by ZEC_KOD_BASE


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Исходящие*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT * FROM [s-sql-d4].[elit].dbo.at_z_FilesExchange WITH(NOLOCK)  --ORDER BY DocTime DESC
WHERE 1 = 1
    and DocTime >= convert(date, '20210301', 102) and DocTime < convert(date, '20210401', 102)
    --and [FileName] like '%[_]invoice%' --счета
    --and [FileName] like '%documentinvoice%' --счета
    --and [FileName] like '%desadv%' --счета
    --and [FileName] like '%ordrsp%' --счета
    and [FileName] like '%comdoc_rozetka%'
    --and [FileName] like '%J12%'
    --AND FileData.value('(./ЕлектроннийДокумент/Заголовок/НомерДокументу)[1]', 'varchar(100)') = '29139'
    --AND FileData.value('(./DECLAR/DECLARBODY/HTINBUY)[1]', 'varchar(100)') = '36003603' --36003603 Новус
    --AND FileData.value('(./DESADV/HEAD/BUYER)[1]', 'varchar(100)') = '9863577638028' --9863577638028 Новус
ORDER BY 1 DESC
--SELECT * FROM [elit].dbo.at_z_FilesExchange WITH(NOLOCK) ORDER BY DocTime DESC
/*SELECT * FROM az_EDI_Invoices_ WITH(NOLOCK) WHERE 1 = 1 AND AEI_AUDIT_DATE >= CONVERT(date, '20210101', 102) AND AEI_AUDIT_DATE <= CONVERT(date, '20210131', 102) AND AEI_XML.value('(./ЕлектроннийДокумент/Сторони/Контрагент/КодКонтрагента)[1]', 'varchar(100)') = '36003603' ORDER BY AEI_AUDIT_DATE DESC*/
----36003603 Новус; --37568896 --7136 Медиатрейдинг Торговый дом Общество с ограниченной ответственностью; 37193071--Розетка.УА Общество с ограниченной ответственностью



--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*COMDOC*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT m.AEI_AUDIT_DATE, * FROM az_EDI_Invoices_ m 
WHERE month(m.AEI_AUDIT_DATE) = 3 and year(m.AEI_AUDIT_DATE) = 2021 
AND AEI_XML.value('(/ЕлектроннийДокумент/Сторони/Контрагент/КодКонтрагента)[1]', 'varchar(100)') = '36003603'
ORDER BY m.AEI_AUDIT_DATE DESC


