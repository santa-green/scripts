
EXEC dbo.[ap_SendEmailEDI] @DocType = 70121

SELECT * FROM [at_EDI_reg_files] WHERE doctype = 70121 and [Status] = 10
SELECT * FROM [at_EDI_reg_files] WHERE doctype = 70121 and ChID = 68017
SELECT * FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.[at_EDI_reg_files] WHERE doctype = 70121 and ChID in (68017, 71744); /*[Status] = 10*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF OBJECT_ID('tempdb..#html', 'U') IS NOT NULL DROP TABLE #html
SELECT ID 'Номер возвратной накладной', CONVERT(varchar, InsertData, 104) 'Дата', DocSum 'Итого сумма с НДС, грн', 'https://edo-v2.edi-n.com/app/#/service/edi/chain/list/inbox/0' 'Сайт EDIN', 'Сеть: Велика Кишеня, #Накладная на возврат, Номер: ' + ID + ',' 'Поиск через фильтр в EDIN' INTO #html FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.[at_EDI_reg_files] WHERE doctype = 70121 and ChID in (68017)
SELECT * FROM #html WITH(NOLOCK) 

DECLARE @head_html varchar(max)
DECLARE @table varchar(max) = '#html'
SELECT @head_html = ISNULL(@head_html, '') + '<th>' + COLUMN_NAME + '</th>' FROM tempdb.INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = (SELECT [name] FROM tempdb.sys.tables WHERE object_id = OBJECT_ID('tempdb..' + @table)) ORDER BY ORDINAL_POSITION
SELECT @head_html 

DECLARE @fields_html varchar(max)
SELECT @fields_html = ISNULL(@fields_html, '') + CASE WHEN @fields_html IS NULL THEN '' ELSE ',' END + QUOTENAME(COLUMN_NAME) + ' as td' FROM tempdb.INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = (SELECT [name] FROM tempdb.sys.tables WHERE object_id = OBJECT_ID('tempdb..' + @table)) ORDER BY ORDINAL_POSITION
SELECT @fields_html 

DECLARE @SQL NVARCHAR(4000);
DECLARE @result NVARCHAR(MAX)
SET @SQL = 'SELECT @result = (
SELECT '+ @fields_html +' FROM #html t FOR XML RAW(''tr''), ELEMENTS
)';
SELECT @SQL
EXEC sp_executesql @SQL, N'@result NVARCHAR(MAX) output', @result = @result OUTPUT
SELECT @result

DECLARE @body_html NVARCHAR(MAX)
SET @body_html = N'<table  border="1" ><tr>' + @Head_html + '</tr>' + @result + N'</table>'
select @body_html


SELECT * FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.[at_EDI_reg_files] WHERE doctype = 70121 and InsertData > '20210301' /*and [Status] = 10*/ ORDER BY InsertData DESC
SELECT * FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.[at_EDI_reg_files] WHERE id = '7062134'
SELECT * FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.[at_EDI_reg_files] WHERE doctype = 70121 and [Status] = 10 and InsertData >= '20210101' ORDER BY InsertData DESC
SELECT * FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.[at_EDI_reg_files] WHERE doctype = 70121 and ChID IN (86521, 86522, 86523, 86703)
SELECT 'Новая возвратная накладная в EDI по Фудком № ' + CAST(86522 AS varchar) + ' от ' + CONVERT(varchar, '2021-03-31 12:00:02.587', 104);
SELECT * FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.[at_EDI_reg_files] WHERE doctype = 70121 and InsertData >= '20210101' AND ChID in (75882, 79042);
SELECT * FROM [at_EDI_reg_files] WHERE [FileName] LIKE 'comdoc[_]%[_]012.p7s' AND [Status] = 0

select CHARINDEX('_7163402', @filename)
SELECT SUBSTRING(@filename, 23, CHARINDEX('_7163402', @filename))


SELECT LEN('comdoc_20210310115620_c3f2c97d-4b45-483f-86cd-266d4dce7907_7163402_012.p7s')
SELECT LEN('c3f2c97d-4b45-483f-86cd-266d4dce7907_7163402_012.p7s')
select charindex('_', 'fff_fff')


DECLARE @hyperlink varchar(max);
DECLARE @filename varchar(255) = 'comdoc_20210310115620_c3f2c97d-4b45-483f-86cd-266d4dce7907_7163402_012.p7s'
SELECT @hyperlink = [PString] FROM dbo.[af_SplitString] (@filename, '_') WHERE PString like '%-%'
SELECT @hyperlink
