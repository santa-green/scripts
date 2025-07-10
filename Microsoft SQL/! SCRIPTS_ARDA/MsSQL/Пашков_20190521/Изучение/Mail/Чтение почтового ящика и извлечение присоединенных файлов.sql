
--set ANSI_NULLS ON
--set QUOTED_IDENTIFIER ON
--go
---- =============================================
---- Author:	<А. Бровко>
---- Create date: <16.04.2007>
---- Description:	<Чтение почтового ящика и извлечение присоединенных файлов>
---- =============================================
--CREATE PROCEDURE [dbo].[readMailBoxExtractAttachments]
DECLARE 
@srv	nvarchar(50) = N'mail.const.dp.ua/owa/',
@mbox	nvarchar(50) = N'const\vintagednepr1',
@pwd	nvarchar(50) = N'dnepr20191',
@pathToSave	nvarchar(50) = N'd:\Tmp\mailfromsql',
@unreadOnly	smallint = 0,
@deleteMsg	smallint = 0,
@countMsg	smallint = null ,--output,
@cAttachments	smallint = null --output

--AS
declare @hr int
declare @str nvarchar(255)
declare @conn int,
@RS int,
@fields int,
@field int,
@msg int,
@DS int,
@attacments int,
@attacment int
declare @Source nvarchar(255), @Desc nvarchar(255)	
declare @idx int, @fileName nvarchar(255)
declare @url nvarchar(255)
declare @href nvarchar(4000), @state int, @count int
declare @path nvarchar(255)

begin
SET NOCOUNT ON;
-- Готовим Connection и Recordset	
exec @hr = master..sp_OACreate 'ADODB.Connection', @conn OUT 
IF @hr <> 0
BEGIN
	EXEC sp_OAGetErrorInfo @conn, @source OUT, @desc OUT 
	SELECT 	hResult = convert(varbinary(4), @hR), 
			source = @source, 
			description = @desc,
			FailPoint = 'sp_OACreate ADODB.Connection'
	return
END

exec @hr = master..sp_OACreate 'ADODB.Recordset', @RS OUT 
IF @hr <> 0
BEGIN
	EXEC sp_OAGetErrorInfo @conn, @source OUT, @desc OUT 
	SELECT 	hResult = convert(varbinary(4), @hR), 
			source = @source, 
			description = @desc,
			FailPoint = 'sp_OACreate ADODB.Recordset'
	return
END

exec @hr = sp_OASetProperty @conn, 'Provider', 'ExOLEDB.DataSource'
IF @hr <> 0
BEGIN
	EXEC sp_OAGetErrorInfo @conn, @source OUT, @desc OUT 
	SELECT 	hResult = convert(varbinary(4), @hR), 
			source = @source, 
			description = @desc,
			FailPoint = 'sp_OASetProperty @conn, Provider, ExOLEDB.DataSource'
	return
END

set @url = N'http://' + @srv + '/Exchange/' + @mbox + '/Входящие'
-- Открываем Connection 
exec @hr = sp_OAMethod @conn, 'Open', @returnval = null, 
@ConnectionString = @url,
@UserID = @mbox,
@Password = @pwd
IF @hr <> 0
BEGIN
	EXEC sp_OAGetErrorInfo @conn, @source OUT, @desc OUT 
	SELECT 	hResult = convert(varbinary(4), @hR), 
			source = @source, 
			description = @desc,
			FailPoint = 'sp_OAMethod @conn, Open, @returnval = null'
	return
END

-- SQL запрос к mailBox-у. В принципе здесь нужно только поле "DAV:href" - остальное для 
-- примера, как можно получить полезную 
-- информацию, но лучше фильтровать и получать только нужные сообщения

declare @sql nvarchar(4000)
set @sql = 
N'select 
"DAV:href" as href, 
"urn:schemas:httpmail:subject", 
"urn:schemas:mailheader:from", 
"urn:schemas:mailheader:date" as date, 
"DAV:displayname"
from scope(''DEEP TRAVERSAL OF "' + @url + '"'')
where "urn:schemas:httpmail:hasattachment" = true and "DAV:ishidden" = false'
-- Непрочитанные сообщения
if @unreadOnly = 1 
set @sql = @sql + ' and "urn:schemas:httpmail:read" = false'
set @sql = @sql + ' order by date'
-- Грузим Recordset	
exec @hr = sp_OAMethod @RS, 'Open', null, @sql, @conn, 2, 3, 1
exec @hr = sp_OAMethod @RS, 'MoveFirst', null
exec @hr = sp_OAGetProperty @RS, 'EOF', @state OUT

set @countMsg = 0
-- Перебор сообщений
while @state = 0 begin
set @countMsg = @countMsg + 1
-- получаем идентификатор сообщений
exec @hr = sp_OAGetProperty @RS, 'Fields', @fields OUT
exec @hr = sp_OAGetProperty @fields, 'Item', @field OUT, 'href'
exec @hr = sp_OAGetProperty @field, 'Value', @href OUT
if @hr <> 0 begin
exec sp_OAGetErrorInfo @field, @Source OUT, @Desc OUT
select hr=convert(varbinary(4),@hr), @Source, @Desc, 'Value'
end 
else begin
-- создаем объект Message
exec @hr = sp_OACreate 'CDO.Message', @msg OUT 
exec @hr = sp_OAGetProperty @msg, 'DataSource', @DS OUT
-- и загружаем текущее сообщение
exec @hr = sp_OAMethod @DS, 'Open', null, @href, @conn, 3, -1, 8192, @mbox, @pwd 
if @hr <> 0 begin
exec sp_OAGetErrorInfo @DS, @Source OUT, @Desc OUT
select hr=convert(varbinary(4),@hr), @Source, @Desc, 'Open'
end
-- получаем набор прикрепленных файлов (attacments)
exec @hr = sp_OAGetProperty @msg, 'Attachments', @attacments OUT
exec @hr = sp_OAGetProperty @attacments, 'Count', @count OUT
set @idx = 1
while @idx <= @count begin
-- каждый attacment сохраняем
exec @hr = sp_OAGetProperty @attacments, 'Item', @attacment OUT, @idx
exec @hr = sp_OAGetProperty @attacment, 'FileName', @fileName OUT
if @hr <> 0 begin
exec sp_OAGetErrorInfo @attacment, @Source OUT, @Desc OUT
select hr=convert(varbinary(4),@hr), @Source, @Desc, 'FileName'
end 
else begin
set @fileName = @path + @fileName
exec @hr = sp_OAMethod @attacment, 'SaveToFile', null, @fileName
end
set @idx = @idx + 1
end

if @deleteMsg = 1 begin
-- если необходимо то после прочтения "сжигаем" письмо
exec @hr = sp_OAMethod @RS, 'Delete', null, 1
if @hr <> 0 begin
exec sp_OAGetErrorInfo @RS, @Source OUT, @Desc OUT
select hr=convert(varbinary(4),@hr), @Source, @Desc, 'Del msg'
end 
end
else begin
-- а иначе помечаем, что данное сообщение прочитано
exec @hr = sp_OAGetProperty @msg, 'Fields', @fields OUT
exec @hr = sp_OAGetProperty @fields, 'Item', @field OUT, 'urn:schemas:httpmail:read'
exec @hr = sp_OASetProperty @field, 'Value', true
exec @hr = sp_OAMethod @fields, 'Update', null
exec @hr = sp_OAMethod @DS, 'Save', null
end

end
exec @hr = sp_OAMethod @RS, 'MoveNext', null
exec @hr = sp_OAGetProperty @RS, 'EOF', @state OUT
end
-- ну и закрываем соединение
exec @hr = sp_OAGetProperty @conn, 'State', @state OUT
if @state = 1
exec @hr = sp_OAMethod @conn, 'Close', @returnval = null
exec sp_OAStop 


select @countMsg,@cAttachments


end