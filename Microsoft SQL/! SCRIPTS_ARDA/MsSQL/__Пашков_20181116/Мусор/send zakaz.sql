  --Отправка почтового сообщения

setuser
setuser 'tbn2'


DECLARE @tableHTML  NVARCHAR(MAX), @subject NVARCHAR(MAX)
SET @tableHTML =  
	N'<H1></H1><table border="1">' +
	N'<tr><th>Код_Товара</th><th>Название</th><th>Ед_изм</th><th>Количество</th></tr>' +   
	CAST ( ( SELECT  td= d.Id_good  , '', td= p.ProdName , '', td= p.UM , '', td= cast(d.Count_real as int)            
	FROM ElitR.dbo.it_TSD_doc_details d join r_Prods p on p.ProdID = d.Id_good where d.Id_doc = 30 FOR XML PATH('tr'), TYPE ) AS NVARCHAR(MAX) )  

--SELECT @tableHTML

SET @subject = 'Заявка ' + (SELECT h.Doc_number FROM ElitR.dbo.it_TSD_doc_head h where h.Id_doc = 30)
	
	EXEC msdb.dbo.sp_send_dbmail  
	@profile_name = 'main',  
	@recipients = 'pashkovv@const.dp.ua',  
	@subject = @subject,
	@body = @tableHTML,  
	@body_format = 'HTML'
	--,@query = 'SELECT * FROM ElitR.dbo._CheckReplica';
	--,@query = 'SELECT Id_good Код_Товара, Count_real Количество FROM ElitR.dbo.it_TSD_doc_details d where d.Id_doc = 30';













SELECT d.Id_good Код_Товара, p.ProdName Название, p.UM Ед_изм, d.Count_real Количество 
FROM ElitR.dbo.it_TSD_doc_details d join r_Prods p on p.ProdID = d.Id_good where d.Id_doc = 30


DECLARE @PLID INT, @recipients NVARCHAR(MAX), @tableHTML  NVARCHAR(MAX), @subject varchar(250), @body varchar(max)
--короткий формат для магазинов
SET @tableHTML =  
	N'<H1></H1><table border="1">' +
	N'<tr><th>Код_Товара</th><th>Название</th><th>Ед_изм</th><th>Количество</th></tr>' +   
	CAST ( ( SELECT  td= d.Id_good  , '', td= p.ProdName , '', td= p.UM , '', td= cast(d.Count_real as int)         
	FROM ElitR.dbo.it_TSD_doc_details d join r_Prods p on p.ProdID = d.Id_good where d.Id_doc = 30 FOR XML PATH('tr'), TYPE ) AS NVARCHAR(MAX) )  

SELECT @tableHTML

	--Отправка почтового сообщения

set @subject = 'Внимание!!! Изменились цены по прайсу ' + cast(@PLID as varchar) + ' на дату ' + (select CONVERT( varchar(30),  getdate(), 21)) 

EXEC msdb.dbo.sp_send_dbmail  
@profile_name = 'main',  
@recipients = @recipients,  
@body = @tableHTML,  
@subject = @subject,
@body_format = 'HTML' ;