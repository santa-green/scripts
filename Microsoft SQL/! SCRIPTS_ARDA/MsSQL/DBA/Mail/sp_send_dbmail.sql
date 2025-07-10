EXEC msdb.dbo.sp_send_dbmail @profile_name = 'main', @recipients = 'pashkovv@const.dp.ua',@subject = 'Экспорт заказа на терминал ElitR.fr3',@body = 'Отчаянный юзер зашел слишком далеко. ' ; 
    
--Mail queued.