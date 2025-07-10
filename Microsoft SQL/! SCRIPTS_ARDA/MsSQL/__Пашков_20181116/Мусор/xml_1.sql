DECLARE @xml XML
SET @xml = (
  SELECT * FROM OPENROWSET (
    BULK 'd:\Tmp\xml\18-ex_xml_wern.xml', SINGLE_CLOB
  ) AS xml
)
 
SELECT 
T.c.value('REGION[1]', 'varchar(max)') AS REGION  
,T.c.value('NAME_OBJ[1]', 'varchar(max)') AS NAME_OBJ  
,T.c.value('CONTACTS[1]', 'varchar(max)') AS CONTACTS  
,T.c.value('FIO[1]', 'varchar(max)') AS FIO  
,T.c.value('LICENSE[1]', 'varchar(max)') AS LICENSE  
FROM   @xml.nodes('/DATA/RECORD') T(c)  
 
 
 
--<DATA FORMAT_VERSION="1.0">
--<RECORD><REGION>Донецька обл.</REGION><NAME_OBJ>Авдіївська державна нотаріальна контора</NAME_OBJ><CONTACTS>Донецька обл., м. Авдіївка, вул. Комунальна, 4, (06236) 7-19-52</CONTACTS><FIO>Шевера Олена Степанівна</FIO><LICENSE>2559</LICENSE></RECORD>

--SELECT  @xml.value('(/DATA/RECORD/REGION)[2000]', 'varchar(max)' )
--SELECT  @xml.query('(/DATA/RECORD/REGION)' )

--SELECT 
--T.c.query('REGION') AS result  
--,T.c.query('NAME_OBJ') AS result  
--,T.c.query('CONTACTS') AS result  
--,T.c.query('FIO') AS result  
--,T.c.query('LICENSE') AS result  
--FROM   @xml.nodes('/DATA/RECORD') T(c)  
