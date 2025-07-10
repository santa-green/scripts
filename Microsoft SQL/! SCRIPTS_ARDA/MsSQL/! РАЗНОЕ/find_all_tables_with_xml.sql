select schema_name(t.schema_id) + '.' + t.name as [table],
       c.column_id,
       c.name as column_name,
       type_name(user_type_id) as data_type,
       is_xml_document
from sys.columns c
join sys.tables t
     on t.object_id = c.object_id
where type_name(user_type_id) in ('xml')
order by [table],
         c.column_id;

dbo._az_EDI_Invoices
dbo.at_SendXML
dbo.at_t_IORecX
dbo.az_EDI_Invoices
dbo.az_EDI_Invoices_
dbo.temp_puzo

sp_helpindex at_z_FilesExchange
SET STATISTICS TIME ON
SELECT * FROM at_z_FilesExchange WHERE ChID in (82728)

SELECT * FROM [s-sql-d4].[elit].dbo.at_z_FilesExchange WITH(NOLOCK)  --ORDER BY DocTime DESC
WHERE 1 = 1
    --and DocTime >= convert(date, GETDATE(), 102)
    --and [FileName] like '%J12%'
    --and [FileName] like '%comdoc%'
    --AND FileData.value('(./ЕлектроннийДокумент/Заголовок/НомерДокументу)[1]', 'varchar(100)') = '29139'
    AND FileData.value('(./DECLAR/DECLARBODY/HTINBUY)[1]', 'varchar(100)') = '36003603' 
ORDER BY 1 DESC
--SELECT * FROM [elit].dbo.at_z_FilesExchange WITH(NOLOCK) ORDER BY DocTime DESC
/*SELECT * FROM az_EDI_Invoices_ WITH(NOLOCK) WHERE 1 = 1 AND AEI_AUDIT_DATE >= CONVERT(date, '20210101', 102) AND AEI_AUDIT_DATE <= CONVERT(date, '20210131', 102) AND AEI_XML.value('(./ЕлектроннийДокумент/Сторони/Контрагент/КодКонтрагента)[1]', 'varchar(100)') = '36003603' ORDER BY AEI_AUDIT_DATE DESC*/
----36003603 Новус; --37568896 --7136 Медиатрейдинг Торговый дом Общество с ограниченной ответственностью; 37193071--Розетка.УА Общество с ограниченной ответственностью
alter index [PrimaryXmlIndex-20210318-102119] ON at_z_FilesExchange REBUILD
