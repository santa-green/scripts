USE [Alef_Elit]
GO
/****** Object:  StoredProcedure [dbo].[ap_EDI_METRO_KPK_Recadv]    Script Date: 30.12.2020 16:19:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<rkv0>
-- Create date: <'2020-10-15 19:31'>
-- Description:	<Проверка новых уведомлений RECADV по ручникам по сети METRO с отправкой email уведомлений>
-- =============================================
ALTER PROCEDURE [dbo].[ap_EDI_METRO_KPK_Recadv]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*DESCRIPTION*/
--Отправляет уведомления о ручных КПК заказов по сети METRO (иногда Василенко делает прямые поставки в магазины, а не на РЦ, как обычно).
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[CHANGED] rkv0 '2020-09-14 17:27' изменил тело email уведомления.
--[CHANGED] rkv0 '2020-09-14 17:35' изменил получателей, добавил "Копию" (отправка сразу в заявки).
--[CHANGED] rkv0 '2020-09-15 13:36' изменил TEXT на HTML.
--[ADDED] '2020-10-15 19:28' rkv0 добавил №уведомлений в тему письма.
--[CHANGED] '2020-12-30 16:21' rkv0 убрал Танцюру из рассылки (ей эта информация не нужна).


--определяем срок давности уведомлений RECADV.
DECLARE @period tinyint = 4

    --отбираем уведомления со статусом != 17, т.е. те, по которым еще уведомления не были отправлены.
    IF EXISTS (
    SELECT * FROM at_EDI_reg_files reg
    WHERE DocType = 5000 --RECADV
      AND InsertData >= GETDATE() - @period
      AND [Status] != 17
      AND RetailersID = 17
      AND Notes NOT LIKE '4%' --ручники (обычные заказы начинаются с цифры 4).
      )    

    /* отправляем письмо-уведомление о новом RECADV по ручнику. */
	    BEGIN

            --[ADDED] '2020-10-15 19:28' rkv0 добавил №уведомлений в тему письма.
            IF OBJECT_ID('tempdb..#val') IS NOT NULL DROP TABLE #val
            
            SELECT ID INTO #val FROM at_EDI_reg_files reg
                WHERE DocType = 5000 --RECADV
                AND InsertData >= GETDATE() - @period
                AND [Status] != 17 
                AND RetailersID = 17 
                AND Notes NOT LIKE '4%'

            --SELECT * FROM #val

            DECLARE @id_recadv nvarchar(max);
            SELECT @id_recadv = COALESCE(@id_recadv + ', ' + ID, ID) FROM #val
            SELECT @id_recadv

		    DECLARE @body nvarchar(max)
		    DECLARE @subject nvarchar(max)
			DECLARE @msg VARCHAR(max)
			DECLARE @xml VARCHAR(max)
            
            SET @subject = 'Новые уведомления от сети METRO по ручным заказам КПК: ' + @id_recadv;
            --[CHANGED] rkv0 '2020-09-14 17:27' изменил тело email уведомления.
            --SET @body = 'Номера и дату/время новых уведомлений см. во вложении. Что с этим делать? - "Специально обученный сотрудник" отдела автоматизации дальше вручную создаст и отправит документы по системе EDI (товарную накладную и налоговую). [[В перспективе мы это полностью автоматизируем]]';
            --SET @body = 'Номера и дату/время новых уведомлений см. во вложении.' + char(10) + char(13) + ' (!) Товарная и налоговая накладная будут сформированы отделом автоматизации, подписаны и отправлены через сайт EDI. Вы получите об этом соответствующее уведомление.';
            --[CHANGED] rkv0 '2020-09-15 13:36' изменил TEXT на HTML.

			SET @msg = '
            <p style="color: #ffffff; background-color: #ff0000"> <b> (!) Товарная и налоговая накладная будут сформированы отделом автоматизации, подписаны и отправлены через сайт EDI. Вы получите об этом соответствующее уведомление. </font> </b> </p>
            <p style="font-size: 12;color:gray"><i>Отправлено [S-PPC] JOB Workflow шаг 21 (Send_email_METRO_new RECADV (*ruchnik KPK) / EXEC [dbo].[ap_EDI_METRO_KPK_Recadv])</i></p>'

             SET @xml = CAST((
               
                  SELECT
                  ID 'td', ' ',
                  CONVERT(varchar, InsertData, 104) + ' ' + LEFT(CONVERT(varchar, InsertData, 108),5) 'td', ' '
                  FROM [Alef_Elit].[dbo].[at_EDI_reg_files] 
                  WHERE DocType = 5000 
                    AND InsertData >= GETDATE() - @period
                    AND [Status] != 17 AND RetailersID = 17 AND Notes NOT LIKE '4%'
                
                  FOR XML PATH('tr'), ELEMENTS)
                  as nvarchar(max)
              ) 

            --https://htmlcolorcodes.com/
            SET @body = '<html> 
                <head>
                <style>
                    table{border: 2px solid blue, border-collapse: collapse; background-color:    #FF5733   } th,td{text-align: center}
                </style>
                </head>
                <body>
                <table border = "3" bordercolor=" #900C3F "> 
                    <tr>
                        <th> № уведомления о приеме </th> 
                        <th> Дата и время </th>
                    </tr>'

            SET @body = @body + @xml + '</table>' + @msg + '</body> </html>'

		    EXEC msdb.dbo.sp_send_dbmail  
		     @profile_name = 'arda'
             --[CHANGED] rkv0 '2020-09-14 17:35' изменил получателей, добавил "Копию" (отправка сразу в заявки).
--[CHANGED] '2020-12-30 16:21' rkv0 убрал Танцюру из рассылки (ей эта информация не нужна).
		    --,@recipients = 'tancyura@const.dp.ua; vasilenkov@const.dp.ua; arda_servicedesk@const.dp.ua'
		    ,@recipients = 'vasilenkov@const.dp.ua; arda_servicedesk@const.dp.ua'
		    --,@recipients = 'rumyantsev@const.dp.ua' --для теста
		    ,@copy_recipients = 'support_arda@const.dp.ua'
		    ,@subject = @subject
		    ,@body = @body
            --[CHANGED] rkv0 '2020-09-15 13:36' изменил TEXT на HTML.
		    --,@body_format = 'TEXT'
		    ,@body_format = 'HTML'
		    ,@importance = 'high'
            --,@query = @query --The query is of type nvarchar(max), and can contain any valid Transact-SQL statements. Note that the query is executed in a separate session, so local variables in the script calling sp_send_dbmail are not available to the query.
            --,@attach_query_result_as_file = 1
            --,@query_attachment_filename = 'Список уведомлений.txt'
            ,@append_query_error = 1 --When this parameter is 0, Database Mail does not send the e-mail message, and sp_send_dbmail ends with return code 1, indicating failure.
            /*On success, returns the message "Mail queued."*/

	    END;

    --обновляем статус на 17 (после отправки email-уведомления).
    UPDATE at_EDI_reg_files SET [Status] = 17
    output deleted.*, inserted.[Status] 
    WHERE DocType = 5000 --RECADV
    AND InsertData >= GETDATE() - @period
    AND [Status] != 17
    AND RetailersID = 17
    AND Notes NOT LIKE '4%'
END




GO
