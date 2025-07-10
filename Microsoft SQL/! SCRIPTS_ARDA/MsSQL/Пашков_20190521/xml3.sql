--импорт из xml файла
DECLARE @xml XML
--SET @xml = ( SELECT * FROM OPENROWSET (BULK '\\s-sql-d4.corp.local\OT38ElitServer\Import\XML\test3.xml', SINGLE_CLOB) AS xml )

--INSERT at_SendXML (xml)
--select @xml xml

SET @xml = ( select AEI_XML from dbo.az_EDI_Invoices_ where  AEI_DOC_TYPE = 12 and AEI_P7S_NAME like '%5113283314%' )

SELECT 
T.c.query('.') AS VALUE  
,T.c.query('.').value('Кількість[1]', 'numeric(21,9)') AS Кількість
 --INTO NOTARIUS 
FROM   @xml.nodes('/ЕлектроннийДокумент/Таблиця/Рядок/ДоПовернення/Кількість') T(c)


select sum(T.c.query('.').value('Кількість[1]', 'numeric(21,9)')) AS sum_Кількість from dbo.az_EDI_Invoices_ s1
CROSS APPLY s1.AEI_XML.nodes('/ЕлектроннийДокумент/Таблиця/Рядок/ДоПовернення/Кількість') T(c)
where  AEI_DOC_TYPE = 12 and AEI_P7S_NAME like '%5113283314%'

--Таблиця>
--    <Рядок ІД="1">
--      <НомПоз>1</НомПоз>
--      <Штрихкод ІД="1">8427894007038</Штрихкод>
--      <АртикулПокупця>174004</АртикулПокупця>
--      <Найменування>Вино Lozano. Лозано, біле 0,75*12</Найменування>
--      <ОдиницяВиміру>шт</ОдиницяВиміру>
--      <БазоваЦіна>84.00 </БазоваЦіна>
--      <ПДВ>16.80 </ПДВ>
--      <Ціна>100.80 </Ціна>
--      <ВсьогоПоРядку>
--        <СумаБезПДВ>1008.00 </СумаБезПДВ>
--        <СумаПДВ>201.60 </СумаПДВ>
--        <Сума>1209.60 </Сума>
--      </ВсьогоПоРядку>
--      <ДоПовернення>
--        <Кількість>12.000 </Кількість>
--      </ДоПовернення>
--    </Рядок>
--  </Таблиця>


--SELECT ChID, COUNT(ChID) FROM t_Invd
--group by ChID
--ORDER BY 2 desc


--SELECT * FROM t_Inv
--WHERE ChiD in (200003990,101543765,200020531,200022784,200007003,200008356,101401335,101315360,101321735,200004020,200100352)
--ORDER BY 1

