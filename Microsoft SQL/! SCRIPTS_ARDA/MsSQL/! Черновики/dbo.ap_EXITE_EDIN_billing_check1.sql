USE [Elit]
GO
/****** Object:  StoredProcedure [dbo].[ap_EXITE_EDIN_billing_check]    Script Date: 16.08.2021 16:33:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[ap_EXITE_EDIN_billing_check] @test bit = 0
as
begin
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*DESCRIPTION 2021-08-16 16:23:40*/
--Контроль биллинга провайдера EDIN: считаем документы и отправляем уведомление для контроля.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DECLARE @recipients varchar(max) = CASE WHEN @test = 1 THEN 'rumyantsev@const.dp.ua' ELSE 'support_arda@const.dp.ua' END

/*
--TEST--
UPDATE EDI_docs_control_status SET email_edi_status = 0, email_uzd_status = 0, edi_docs_used = 0, uzd_docs_used = 0, edi_TIME_checkpoint = '19000101'
SELECT * FROM EDI_docs_control_status
EXEC [dbo].[ap_EXITE_EDIN_billing_check] @test = 1
*/

--#region Подсчет использованных документов.
--Считаем количество отправленных документов в реестре at_z_filesExchange за текущий месяц.
DECLARE @edi_docs_used int = (SELECT COUNT(*)
FROM dbo.at_z_filesExchange
WHERE month(DocDate) = month(getdate())
	and year(DocDate) = year(getdate())
	--and docdate = convert(date,  getdate(),  102)
	and (
		[filename] like '%desadv%'
		or [filename] like '%ordrsp%'
		or [filename] like '%[_]invoice%'
		or [filename] like '%contrl%'
		or [filename] like '%iftmin%')
        )
SELECT @edi_docs_used 'edi_docs_used'

--Считаем количество отправленных/полученных ЮЗД документов в реестре at_z_filesExchange (DECLAR, COMDOC_ROZETKA, DocumentInvoice) 
--и реестре az_EDI_Invoices_ (COMDOC) за текущий месяц.
DECLARE @uzd_docs_used int = (SELECT SUM(m.total) FROM (
SELECT COUNT(*) 'total'
FROM dbo.at_z_filesExchange
WHERE month(DocDate) = month(getdate())
	and year(DocDate) = year(getdate())
	--and docdate = convert(date,  getdate(),  102)
	and (
		[filename] like '%J12%'
		or [filename] like '%COMDOC_ROZETKA%'
		or [filename] like '%documentinvoice%')
UNION ALL
SELECT COUNT(*) FROM az_EDI_Invoices_ --в эту таблицу мы заносим только те приходные, которые были нами подписаны и отправлены.
WHERE month(AEI_AUDIT_DATE) = month(getdate())
	and year(AEI_AUDIT_DATE) = year(getdate())
UNION ALL
SELECT COUNT(*)
FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.at_EDI_reg_files
WHERE ([filename] like '%comdoc%' OR [filename] like '%documentinvoice%' OR [filename] like '%docinvoiceact%')
and month(InsertData) = month(getdate())
	and year(InsertData) = year(getdate())
) m
)
SELECT @uzd_docs_used 'uzd_docs_used'
--#endregion Подсчет использованных документов.

--#region Уровни использования пакетов.
--Определяем 1 из 4 уровней использованных документов из пакета (ежемесячно в пакете 2000 документов).
--Пакет edi.
DECLARE @doc_status_edi smallint
IF @edi_docs_used BETWEEN 500 AND 999 SET @doc_status_edi = 500
IF @edi_docs_used BETWEEN 1000 AND 1499 SET @doc_status_edi = 1000
IF @edi_docs_used BETWEEN 1500 AND 1749 SET @doc_status_edi = 1500
IF @edi_docs_used BETWEEN 1750 AND 1999 SET @doc_status_edi = 1750
SELECT @doc_status_edi 'doc_status_edi'
--Пакет юзд.
DECLARE @doc_status_uzd smallint
IF @uzd_docs_used BETWEEN 500 AND 999 SET @doc_status_uzd = 500
IF @uzd_docs_used BETWEEN 1000 AND 1499 SET @doc_status_uzd = 1000
IF @uzd_docs_used BETWEEN 1500 AND 1749 SET @doc_status_uzd = 1500
IF @uzd_docs_used BETWEEN 1750 AND 1999 SET @doc_status_uzd = 1750
SELECT @doc_status_edi 'doc_status_uzd'
--#endregion Уровни использования пакетов.

--#region Обновляем email_status
--Обновляем email_status по уровню "использования" для пакета edi.
DECLARE @update_count tinyint = 0
IF EXISTS (SELECT TOP 1 1
	FROM EDI_docs_control_status
	WHERE edi_COUNT_checkpoint = @doc_status_edi
		and edi_docs_used = 0
		--AND edi_TIME_checkpoint = '19000101'
		and email_edi_status = 0)
	BEGIN
        UPDATE EDI_docs_control_status
	    SET edi_docs_used =  @edi_docs_used
	    ,   edi_TIME_checkpoint = CURRENT_TIMESTAMP
	    ,   email_edi_status =   1
	    WHERE edi_COUNT_checkpoint = @doc_status_edi;
        SET @update_count += 1
    END

--Обновляем email_status по уровню "использования" для пакета юзд.
IF EXISTS (SELECT TOP 1 1
	FROM EDI_docs_control_status
	WHERE edi_COUNT_checkpoint = @doc_status_uzd
		and uzd_docs_used = 0
		--AND edi_TIME_checkpoint = '19000101'
		and email_uzd_status = 0)
	BEGIN
        UPDATE EDI_docs_control_status
	    SET uzd_docs_used =  @uzd_docs_used
	    ,   edi_TIME_checkpoint = CURRENT_TIMESTAMP
	    ,   email_uzd_status =   1
	    WHERE edi_COUNT_checkpoint = @doc_status_uzd;
        SET @update_count += 1
    END
--#endregion Обновляем email_status

--#region Отправка email.
IF @update_count > 0
BEGIN
    DECLARE @message varchar(max) = '<p style="font-size: 14; color: gray"><i>[для администратора БД] Джоб ELIT EDIN_billing_check <br> 
    EDI Поставка - цепь документов 
    без использования КЭП,  который необходим для выполнения поставки товара от поставщика к покупателю (сети,  дистрибьютора,  
    конечного покупателя). В цепи все документы,  создаваемые в ответ,  
    не тарифицируются.<br>
    ЮЗД операция - это операция (действие) с использованием КЭП. К ЮЗД-операций входят:
    - Отправка документа с КЭП
    - получение документа с КЭП
    - Подписание документа в ответ
    - отказ от подписания
    - Аннулирование подписания
    <p> https://edo-v2.edi-n.com/app/#/service/personal/account/tariffs/purchases <br>
    https://edo-v2.edi-n.com/app/#/service/personal/account/billing</p>
    </i></p>'
    DECLARE @table varchar(max) = 'EDI_docs_control_status'

    --table header.
    DECLARE @header varchar(max) = NULL
    SELECT @header = ISNULL(@header, '') + '<th>' + COLUMN_NAME + '</th>'
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = @table
    ORDER BY ORDINAL_POSITION
    select @header '@header'

    --table data.
    DECLARE @fields varchar(max) = NULL
    SELECT @fields = ISNULL(@fields, '') + CASE WHEN @fields IS NULL THEN ''
                                                                     ELSE ', ' END + COLUMN_NAME + ' as td'
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = @table
    ORDER BY ORDINAL_POSITION
    select @fields '@fields'

    DECLARE @sql_resultset nvarchar(max)
    DECLARE @sql nvarchar(max) = 'SELECT @sql_resultset = (SELECT ' + @fields + ' FROM ' + @table + ' FOR XML RAW(''tr''), ELEMENTS)'
    select @sql '@sql'
    EXEC sp_executesql @sql, N'@sql_resultset nvarchar(max) OUTPUT', @sql_resultset = @sql_resultset OUTPUT
    SELECT @sql_resultset '@sql_resultset'

    DECLARE @body varchar(max)
    SET @body = N'<table bgcolor=#8fe8bc bordercolor= #3db97b border="5"><tr>' + @header + '</tr>' + @sql_resultset + '</table>'
    SELECT @body '@body'
    SELECT @body = @body + @message

    EXEC msdb.dbo.sp_send_dbmail  
        @profile_name = 'arda', 
        @from_address = '<support_arda@const.dp.ua>', 
        @recipients = @recipients, 
        @subject = 'Контроль биллинга провайдера EDIN', 
        @body = @body, 
        @body_format = 'HTML', 
        @append_query_error = 1
END;
--#endregion Отправка email.

--#region Каждый 1-й день месяца обнуляем статусы
IF (SELECT DAY(GETDATE())) = 1
	UPDATE EDI_docs_control_status
	SET email_edi_status =    0
	,   email_uzd_status =    0
	,   edi_docs_used =       0
	,   uzd_docs_used =       0
	,   edi_TIME_checkpoint = '19000101'
--#endregion Каждый 1-й день месяца обнуляем статусы

--#region архив
--CREATE TABLE EDI_docs_control_status (
--    edi_count smallint, 
--    email_status bit, 
--)
--INSERT INTO EDI_docs_control_status (EDI_COUNT) VALUES (500),  (1000),  (1500),  (1750)
--UPDATE EDI_docs_control_status SET EMAIL_STATUS = 0
--alter table EDI_docs_control_status drop DF__EDI_docs___edi_c__352CF701
--UPDATE EDI_docs_control_status SET edi_package_paid = 2000
--alter table EDI_docs_control_status add edi_docs_used smallint
--alter table EDI_docs_control_status DROP COLUMN [edi_checkpoint] --date default current_timestamp
--alter table EDI_docs_control_status add [edi_TIME_checkpoint] date
--alter table EDI_docs_control_status add [Used,  %] numeric(4,  2)
--alter table EDI_docs_control_status drop COLUMN edi_COUNT_checkpoint --smallint NOT NULL
--alter table EDI_docs_control_status add edi_COUNT_checkpoint smallint NOT NULL
--alter table EDI_docs_control_status drop constraint PK_edi_count primary key (edi_count)
--alter table EDI_docs_control_status ALTER COLUMN edi_COUNT_checkpoint smallint NOT NULL
--alter table EDI_docs_control_status WITH NOCHECK add constraint PK_edi_count primary key (edi_COUNT_checkpoint)
--alter table EDI_docs_control_status DROP COLUMN email_status
--alter table EDI_docs_control_status add email_edi_status bit
--alter table EDI_docs_control_status add email_uzd_status bit
--update EDI_docs_control_status set email_uzd_status = 0, email_edi_status = 0
--alter table EDI_docs_control_status DROP COLUMN [Ratio,  %]
--alter table EDI_docs_control_status drop column [Ratio, %] --as (FLOOR(CAST(edi_docs_used AS float) / edi_package_paid * 100))
--alter table EDI_docs_control_status drop column [Used,  %]
--alter table EDI_docs_control_status drop column Ratio
--alter table EDI_docs_control_status drop column ratio
--alter table EDI_docs_control_status add Ratio_edi as CAST(CAST(edi_docs_used AS float) / edi_package_paid AS numeric(4, 2))
--alter table EDI_docs_control_status add uzd_docs_used smallint
--alter table EDI_docs_control_status drop column uzd_docs_used
--alter table EDI_docs_control_status alter column uzd_docs_used smallint not null
--update EDI_docs_control_status set uzd_docs_used = 0
--alter table EDI_docs_control_status add Ratio_uzd as CAST(CAST(uzd_docs_used AS float) / edi_package_paid AS numeric(4, 2))
--alter table EDI_docs_control_status drop column Ratio_uzd --as CAST(CAST(uzd_docs_used AS float) / edi_package_paid AS numeric(4, 2))
--alter table EDI_docs_control_status add ratio_edi smallint NOT NULL
--#endregion архив

end;


GO
