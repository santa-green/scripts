USE [Elit]
GO
/****** Object:  StoredProcedure [dbo].[ap_OP_SendXML_Velike_Puzo]    Script Date: 19.05.2021 10:23:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[ap_OP_SendXML_Velike_Puzo] (@Testing int = 0)
AS
--EXEC [dbo].[ap_OP_SendXML_Velike_Puzo] @Testing = 1
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[FIXED] rkv0 '2021-01-18 12:30' изменил профиль с main на arda, т.к. с профиля main не уходят письма во внешнюю сеть.
--[ADDED] rkv0 '2021-01-28 17:49' убрал ограничение.
--[ADDED] rkv0 '2021-05-19 10:24' добавил адрес muharenko_sv@sheree.dp.ua по заявке №7544.



DECLARE @ID int, @ChID int, @recipients varchar(250), @copy_recipients varchar(max) 
IF @Testing = 0 
    BEGIN
        SET @recipients = 'Novom_obmen@sheree.dp.ua';
        --[ADDED] rkv0 '2021-05-19 10:24' добавил адрес muharenko_sv@sheree.dp.ua по заявке №7544.
        SET @copy_recipients = 'pashkovv@const.dp.ua;rumyantsev@const.dp.ua;reznichenko@const.dp.ua;heavy@heavy.dp.ua;muharenko_sv@sheree.dp.ua'; 
    END;
IF @Testing = 1 
    BEGIN
        SET @recipients = 'rumyantsev@const.dp.ua';
        SET @copy_recipients = 'rumyantsev.kv@gmail.com';
    END;

DECLARE Cursor_PUZO_email CURSOR LOCAL FAST_FORWARD FOR 
    SELECT ID, ChID FROM dbo.at_SendXML WITH(NOLOCK)
    WHERE 
        [Status] = 0 
        OR [Status] IS NULL 
        OR [Status] != 50;

OPEN Cursor_PUZO_email; 
FETCH NEXT FROM Cursor_PUZO_email INTO @ID, @ChID;
WHILE @@FETCH_STATUS = 0
BEGIN

	UPDATE dbo.at_SendXML SET [Status] = 10 WHERE ID = @ID --файл взят в работу на отправку.

	IF OBJECT_ID('Elit..temp_puzo') IS NOT NULL DROP TABLE temp_puzo

	SELECT TOP(1) xml val INTO temp_puzo FROM dbo.at_SendXML WHERE ID = @ID

	--определение CompID
    DECLARE @Str_CompID varchar(20) = (SELECT CompID FROM t_inv WHERE ChID = @ChID)
    DECLARE @attachment_filename varchar(50)
    DECLARE @subject varchar(250)

	SET @attachment_filename = @Str_CompID + '_' + cast(isnull(@ChID,0) as varchar) + '.xml'
	SET @subject = 'Автоматическая отправка расходной накладной: ' + @Str_CompID + '_' + cast(isnull(@ChID,0) as varchar)

    --Отправка email.
	BEGIN TRY  
        DECLARE @xml varchar(max) = 'SELECT N''<?xml version="1.0" encoding="UTF-8"?>'' + cast(val as nvarchar(max)) FROM Elit.dbo.temp_puzo'
        --DECLARE @xml varchar(max) = 'SELECT val FROM Elit.dbo.temp_puzo'
        --DECLARE @xml varchar(max) = 'SELECT CAST(REPLACE(cast(val as nvarchar(max)), ''><'', ''>'' + char(13) + char(10) + ''<'') AS xml) FROM Elit.dbo.temp_puzo'
		DECLARE @SQL_query nvarchar(max) = 'SET NOCOUNT ON; ' + @xml + '; SET NOCOUNT OFF;'
		
		EXEC msdb.dbo.sp_send_dbmail  
		 -- [FIXED] rkv0 '2021-01-18 12:30' изменил профиль с main на arda, т.к. с профиля main не уходят письма во внешнюю сеть.
         --@profile_name = 'main'
		 @profile_name = 'arda'
		,@recipients = @recipients
		--,@blind_copy_recipients= @blind_copy_recipients
		,@copy_recipients= @copy_recipients
		,@subject = @subject
		,@query = @SQL_query
		,@query_result_header=0
		,@query_no_truncate= 1 -- не усекать запрос
		,@query_attachment_filename= @attachment_filename
		,@attach_query_result_as_file= 1 -- 1 возвращается результирующий набор запроса как прикрепленный файл
        -- [ADDED] rkv0 '2021-01-28 17:49' убрал ограничение.
        ,@query_result_width = 32767; --line width; default of 256. The value provided must be between 10 and 32767.
		
		UPDATE dbo.at_SendXML SET 
             [Status] = 50 --Успешно отправлен
            ,Notes = 'Файл отправлен. ' + @recipients --отчет в примечание
            ,DateSend = GETDATE() --отчет в примечание
            WHERE ID = @ID 
	END TRY
	BEGIN CATCH 
		UPDATE dbo.at_SendXML SET [Status] = 20 WHERE ID = @ID --ошибка при отправке
		UPDATE dbo.at_SendXML SET Notes = CAST(ERROR_MESSAGE() as varchar(230)) + CAST(ERROR_NUMBER() as varchar(20)) WHERE ID = @ID --ошибку в примечание
		
		SELECT  
			 ERROR_NUMBER() AS ErrorNumber  
			,ERROR_SEVERITY() AS ErrorSeverity  
			,ERROR_STATE() AS ErrorState  
			,ERROR_PROCEDURE() AS ErrorProcedure  
			,ERROR_LINE() AS ErrorLine  
			,ERROR_MESSAGE() AS ErrorMessage; 
	END CATCH;
		
	IF OBJECT_ID('tempdb..temp_puzo') IS NOT NULL DROP TABLE temp_puzo
		
	FETCH NEXT FROM Cursor_PUZO_email INTO @ID, @ChID
END;

CLOSE Cursor_PUZO_email
DEALLOCATE Cursor_PUZO_email







GO
