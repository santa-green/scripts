ALTER PROCEDURE [dbo].[ap_EDI_SendToEmail_New_GLN]    
AS    
BEGIN
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*DESCRIPTION*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Проверка новых GLN адресов

IF EXISTS 
(
	select * 
	from dbo.ALEF_EDI_ORDERS_2 m
	where --zeo_zec_add NOT IN (SELECT EGS_GLN_ID FROM ALEF_EDI_GLN_SETI) 
	NOT EXISTS (SELECT TOP 1 1 FROM ALEF_EDI_GLN_OT s1 WHERE s1.ZEC_KOD_BASE = m.ZEO_ZEC_BASE and s1.ZEC_KOD_ADD = m.ZEO_ZEC_ADD) --все заказы, где gln базовый и адресный отсутствуют в реестре ALEF_EDI_GLN_OT.
	AND ZEO_ORDER_STATUS NOT IN (33, 4, 5) --33 Неизвестный внешний код товара; 4 Задублированный; 5 Заказ залит в ОТ.
	AND EXISTS (SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT p1 where p1.zec_kod_base = m.ZEO_ZEC_BASE) --есть в реестре хотя бы базовый gln, т.е. ловим новый адрес просто.
	and (SELECT top 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT p1 where p1.zec_kod_base = m.ZEO_ZEC_BASE) not in (23501) --исключить предприятие Салют Частное предприятие Торговый Дом.
	and m.ZEO_AUDIT_DATE > DATEADD(day, -10, getdate()) -- только заказы не старше 10 дней.
	and m.ZEO_ORDER_ID NOT IN (SELECT ZEO_ORDER_ID FROM [S-SQL-D4].Elit.dbo.at_EDI_Orders_Not_GLN with(nolock) where SendMailStatus > 0) -- если email по заказу еще не отправлялся.
)

BEGIN
  --Отправка почтового сообщения
  BEGIN TRY 
	--DELETE [S-SQL-D4].Elit.dbo.at_EDI_Orders_Not_GLN
	
    --добавляем запись в реестр отправленных писем.
    INSERT [S-SQL-D4].Elit.dbo.at_EDI_Orders_Not_GLN
		select TOP(10)
		 m.ZEO_ORDER_ID 
		,ZEO_ORDER_NUMBER 'Номер заказа'
		,m.ZEO_AUDIT_DATE 'Дата заказа'
		,m.ZEO_ORDER_DATE 'Дата доставки'
		,m.ZEO_ZEC_ADD 'GLN'
		,(SELECT TOP(1) ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT p1 where p1.zec_kod_base = m.ZEO_ZEC_BASE) 'compid'
		,(select TOP(1) compshort from [S-SQL-D4].Elit.dbo.r_Comps p2 where compid = (SELECT TOP(1) ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT p1 where p1.zec_kod_base = m.ZEO_ZEC_BASE)) 'compshort'
		,(SELECT TOP(1) (SELECT  (SELECT isnull(EMail,'') mail FROM [S-SQL-D4].Elit.dbo.r_emps re where re.EmpID = rc3.EmpID) FROM [S-SQL-D4].Elit.dbo.r_Codes3 rc3 where rc3.CodeID3 = p2.CodeID3) 'info'
		  FROM [S-SQL-D4].Elit.dbo.r_Comps p2 where compid = (SELECT TOP 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT p1 where p1.zec_kod_base = m.ZEO_ZEC_BASE)) 'Заказы без GLN адреса в Alef_Elit.dbo.ALEF_EDI_GLN_SETI'
		,(SELECT TOP(1) (SELECT  (SELECT isnull(EmpName,'') EmpName FROM [S-SQL-D4].Elit.dbo.r_emps re where re.EmpID = rc3.EmpID) FROM [S-SQL-D4].Elit.dbo.r_Codes3 rc3 where rc3.CodeID3 = p2.CodeID3) 'info'
		  FROM [S-SQL-D4].Elit.dbo.r_Comps p2 where compid = (SELECT TOP 1 ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT p1 where p1.zec_kod_base = m.ZEO_ZEC_BASE)) 'EmpName'
		,0 'SendMailStatus' --статус 0 - не отправленный.
		FROM dbo.ALEF_EDI_ORDERS_2 m
		WHERE --zeo_zec_add NOT IN (SELECT EGS_GLN_ID FROM ALEF_EDI_GLN_SETI) 
		NOT EXISTS (SELECT TOP(1) 1 FROM ALEF_EDI_GLN_OT s1 WHERE s1.ZEC_KOD_BASE = m.ZEO_ZEC_BASE and s1.ZEC_KOD_ADD = m.ZEO_ZEC_ADD)
		AND ZEO_ORDER_STATUS NOT IN (33, 4, 5)
		AND EXISTS (SELECT TOP(1) ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT p1 where p1.zec_kod_base = m.ZEO_ZEC_BASE) 
		AND (SELECT TOP(1) ZEC_KOD_KLN_OT FROM ALEF_EDI_GLN_OT p1 where p1.zec_kod_base = m.ZEO_ZEC_BASE) not in (23501) --исключить предприятия
		AND m.ZEO_AUDIT_DATE >  DATEADD(day, -10, getdate()) -- только заказы не старше 10 дней
		AND m.ZEO_ORDER_ID NOT IN (SELECT ZEO_ORDER_ID FROM [S-SQL-D4].Elit.dbo.at_EDI_Orders_Not_GLN WITH(NOLOCK) where SendMailStatus > 0) -- если заказ еще не отправился
		ORDER BY ZEO_ORDER_DATE DESC

	SELECT * FROM [S-SQL-D4].Elit.dbo.at_EDI_Orders_Not_GLN

    /*Отправка 1-го письма (служебное)*/
    BEGIN
        DECLARE @SQL_query nvarchar(max) = 'SELECT * FROM Elit.dbo.at_EDI_Orders_Not_GLN where SendMailStatus = 0 order by 4'
		DECLARE @body_str nvarchar(max) = 'Проверьте в Справочнике предприятий на вкладке Адреса доставки в строчке с адресом должен быть указан Номер GLN ' + char(13) 
										+ '(его можно посмотреть  в заказе на сайте edo.edi-n.com) '
										+ char(13) + char(13) + 'Отправленно [S-PPC] JOB EDI шаг 4 "Проверка на новые адреса GLN" (PROCEDURE [Alef_Elit].[dbo].[ap_EDI_SendToEmail_New_GLN])'
		SELECT @body_str
		SELECT @SQL_query

		EXEC [s-sql-d4].msdb.dbo.sp_send_dbmail  
		    @profile_name = 'arda',  
		    @recipients = 'support_arda@const.dp.ua', 
		    --@recipients = 'pashkovv@const.dp.ua;rumyantsev@const.dp.ua;kotsurenko@const.dp.ua',  
		    @body = @body_str,  
		    @subject = 'Проверка на новые адреса GLN. Все с SendMailStatus = 0',
		    @body_format = 'TEXT'--'HTML'
		    ,@query = @SQL_query
		    ,@query_result_header = 1
		    --,@exclude_query_output=1
		    ,@query_no_truncate = 0 -- не усекать запрос
		    --,@query_attachment_filename= @attachment_filename
		    --,@file_attachments='\\s-sql-d4.corp.local\OT38ElitServer\Import\XML\test.xml',
		    ,@attach_query_result_as_file = 1 -- 1 возвращается результирующий набор запроса как прикрепленный файл
    END;		    

    /*Отправка 2-го письма (менеджерам)*/
    BEGIN	
		DECLARE @mail nvarchar(200)
        DECLARE CUR CURSOR STATIC FOR
		--SELECT DISTINCT mail FROM [S-SQL-D4].Elit.dbo.at_EDI_Orders_Not_GLN where mail <> '' and mail like '%@%' and SendMailStatus = 0  ORDER BY 1
		SELECT DISTINCT CASE WHEN mail = '' THEN 'support_arda@const.dp.ua' ELSE mail END  
        FROM [S-SQL-D4].Elit.dbo.at_EDI_Orders_Not_GLN where SendMailStatus = 0 ORDER BY 1
		
        OPEN CUR
		FETCH NEXT FROM CUR INTO @mail
		
        WHILE @@FETCH_STATUS = 0    		 
		BEGIN
			set @SQL_query  = 'SELECT * FROM Elit.dbo.at_EDI_Orders_Not_GLN where mail = ''' + isnull(@mail, 'null') + ''' and  SendMailStatus = 0 order by 4'
			set @body_str = 'Пришлите лицензию для добавления нового адреса 
			или проверьте в Справочнике предприятий на вкладке Адреса доставки в строчке с адресом должен быть указан Номер GLN ' + char(13) 
							+ '(его можно посмотреть  в заказе на сайте edo.edi-n.com) '
							+ char(13) + char(13) + 'Отправленно [S-PPC] JOB EDI шаг 3 (Проверка на новые адреса GLN) (PROCEDURE [Alef_Elit].[dbo].[ap_EDI_SendToEmail_New_GLN])'
			select @body_str

			SELECT @SQL_query

			EXEC [s-sql-d4].msdb.dbo.sp_send_dbmail  
			@profile_name = 'arda',  
			@recipients = @mail, 
			--@recipients = 'pashkovv@const.dp.ua', 
			@copy_recipients = 'support_arda@const.dp.ua',  
			@body = @body_str,  
			@subject = 'Проверка на новые адреса GLN. Появился заказ с новым адресом',
			@body_format = 'TEXT'--'HTML'
			,@query = @SQL_query
			,@query_result_header = 1
			--,@exclude_query_output=1
			,@query_no_truncate = 0 -- не усекать запрос
			,@query_attachment_filename = 'Cписок новых адресов.txt'
			--,@file_attachments='\\s-sql-d4.corp.local\OT38ElitServer\Import\XML\test.xml',
			,@attach_query_result_as_file= 1 -- 1 возвращается результирующий набор запроса как прикрепленный файл

			--обновить статус SendMailStatus = 1, чтобы больше не приходили письма о новых адресах GLN.
			UPDATE [S-SQL-D4].Elit.dbo.at_EDI_Orders_Not_GLN SET SendMailStatus = 1 where (mail = @mail and SendMailStatus = 0) OR mail = ''

			FETCH NEXT FROM CUR INTO @mail
		END;

		CLOSE CUR
		DEALLOCATE CUR
    END;

  END TRY
  
  BEGIN CATCH
    SELECT  
    ERROR_NUMBER() AS ErrorNumber  
    ,ERROR_SEVERITY() AS ErrorSeverity  
    ,ERROR_STATE() AS ErrorState  
    ,ERROR_PROCEDURE() AS ErrorProcedure  
    ,ERROR_LINE() AS ErrorLine  
    ,ERROR_MESSAGE() AS ErrorMessage; 
  END CATCH  
END;



END;








GO
