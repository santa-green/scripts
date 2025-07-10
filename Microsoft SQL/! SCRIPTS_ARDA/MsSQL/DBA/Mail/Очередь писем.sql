--Очередь писем
SELECT * FROM msdb.dbo.ExternalMailQueue

/*

EXEC msdb.dbo.sp_send_dbmail  
	@profile_name = 'main',  
	@recipients = 'pashkovv@const.dp.ua; vintagednepr2@const.dp.ua',  
	@subject = 'test2',
	@body = '',  
	@body_format = 'HTML';
	
*/
