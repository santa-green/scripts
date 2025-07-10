/*Вова Пашков, [26.05.21 09:56]
пример работы с отчетом марии на летке*/

--импорт из xml файла кассы мария
DECLARE @xml XML
SET @xml = ( SELECT * FROM OPENROWSET (BULK '\\s-sql-d4.corp.local\OT38ElitServer\Import\XML\mar.xml', SINGLE_BLOB  ) AS xml )

select @xml xml

SELECT 
T.c.query('.') AS VALUE  
--<DAT DI="7428" DT="0" FN="3000723535" TN="ПН 410869004616" V="1" ZN="ТС4001036019">
,T.c.value('@DI','varchar(100)') AS DI
,T.c.value('@DT','varchar(100)') AS DT
,T.c.value('@FN','varchar(100)') AS FN
,T.c.value('@TN','varchar(100)') AS TN
,T.c.value('@V','varchar(100)') AS V
,T.c.value('@ZN','varchar(100)') AS ZN
,T.c.value('./TS[1]','varchar(100)') AS TS

,T2.p.value('@C','varchar(100)') AS C
,T2.p.value('@CD','varchar(100)') AS CD
,T2.p.value('@N','varchar(100)') AS N
,T2.p.value('@NM','varchar(250)') AS NM
,T2.p.value('@PRC','varchar(250)') AS PRC
,T2.p.value('@Q','varchar(250)') AS Q

,T2.p.value('@SM','varchar(100)') AS SM
,T2.p.value('@TX','varchar(100)') AS TX
,T2.p.value('@TX1','varchar(100)') AS TX1
 --INTO NOTARIUS 
FROM @xml.nodes('/DAT') T(c)
CROSS APPLY T.c.nodes('./C/P') t2(p)