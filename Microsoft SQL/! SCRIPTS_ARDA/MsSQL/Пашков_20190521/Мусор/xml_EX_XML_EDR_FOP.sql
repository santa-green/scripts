DECLARE @xml XML
SET @xml = (
  SELECT * FROM OPENROWSET (
    BULK 'd:\Tmp\xml\15.2-EX_XML_EDR_FOP.xml', SINGLE_CLOB
  ) AS xml
)
 
SELECT 
T.c.value('FIO[1]', 'varchar(max)') AS FIO  
,T.c.value('ADDRESS[1]', 'varchar(max)') AS ADDRESS  
,T.c.value('KVED[1]', 'varchar(max)') AS KVED  
,T.c.value('STAN[1]', 'varchar(max)') AS STAN  

 INTO EX_XML_EDR_FOP
FROM   @xml.nodes('/DATA/RECORD') T(c)  
 
 --<RECORD><FIO>СОПІНА ВІРА БОРИСІВНА</FIO><ADDRESS>94415, Луганська обл., місто Сорокине, місто Молодогвардійськ, КВАРТАЛ КОШОВОГО, будинок 48, квартира 85</ADDRESS><KVED>47.89 Роздрібна торгівля з лотків і на ринках іншими товарами</KVED><STAN>зареєстровано</STAN></RECORD>
