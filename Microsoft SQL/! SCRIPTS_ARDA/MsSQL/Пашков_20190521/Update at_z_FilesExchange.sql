--select Chid, FileName, N'<?xml version=`"1.0`" encoding=`"WINDOWS-1251`"?>' + cast(FileData as narchar(max)), cast(isnull(x.XmlCol.exist('true()'),0) as int) xml_check 
--from dbo.at_z_FilesExchange as h 
--OUTER APPLY h.FileData.nodes('/DECLAR/DECLARBODY') x(XmlCol) 
--where StateCode = 402 and FileName like '%J1201008%.xml';


SELECT top 100 *,cast(FileData as varchar(max))  
FROM at_z_FilesExchange 
where (FileName like '%J1201008%' or FileName like '%J1201010%')
and DocDate > '2019-01-03'
ORDER BY 6 desc

-- обновить StateCode = 402
BEGIN TRAN
SELECT *,FileData.value('(/DECLAR/DECLARHEAD/C_STI_ORIG)[1]', 'int' ) FROM  at_z_FilesExchange where ChID = 66031

update at_z_FilesExchange 
set StateCode = 402
where ChID in (66033,66032,66031,66030,66017,66016,66015,66008,66007,66006,66005,66002,66001,65982,65981,65980,65979,65978,65970,65920,65919,65918,65915,65914,65913,65912,65909,65908,65906,65911,65910,65907,65899,65898,65897,65896,65895,65892,65878)

SELECT *,FileData.value('(/DECLAR/DECLARHEAD/C_STI_ORIG)[1]', 'int' ) FROM  at_z_FilesExchange where ChID = 66031
ROLLBACK TRAN


-- обновить Filename 28100037029549J1201010100001547210120192810.xml
BEGIN TRAN
SELECT * FROM  at_z_FilesExchange where ChID in (SELECT chid FROM at_z_FilesExchange where (FileName like '%J1201008%' or FileName like '%J1201010%')and DocDate > '2019-01-03')

update at_z_FilesExchange 
set Filename = replace (Filename, '2801','2810')
where ChID in (SELECT chid FROM at_z_FilesExchange where (FileName like '%J1201008%' or FileName like '%J1201010%')and DocDate > '2019-01-03')

update at_z_FilesExchange 
set Filename = replace (Filename, 'J1201008','J1201010')
where ChID in (SELECT chid FROM at_z_FilesExchange where (FileName like '%J1201008%' or FileName like '%J1201010%')and DocDate > '2019-01-03')

SELECT * FROM  at_z_FilesExchange where ChID in (SELECT chid FROM at_z_FilesExchange where (FileName like '%J1201008%' or FileName like '%J1201010%')and DocDate > '2019-01-03')
ROLLBACK TRAN





BEGIN TRAN
/*
DECLARE @myDoc xml

set @myDoc = (SELECT FileData FROM   at_z_FilesExchange where ChID = 65776)

--set @myDoc =  '<DECLAR>
--  <DECLARHEAD C_STI_ORIG = "555">
--    <TIN>37029549</TIN>
--    <C_DOC>J12</C_DOC>
--    <C_DOC_SUB>010</C_DOC_SUB>
--    <C_DOC_VER>10</C_DOC_VER>
--    <C_DOC_TYPE>0</C_DOC_TYPE>
--    <C_DOC_CNT>0001092</C_DOC_CNT>
--    <C_REG>28</C_REG>
--    <C_RAJ>1</C_RAJ>
--    <PERIOD_MONTH>1</PERIOD_MONTH>
--    <PERIOD_TYPE>1</PERIOD_TYPE>
--    <PERIOD_YEAR>2019</PERIOD_YEAR>
--    <C_STI_ORIG>2801</C_STI_ORIG>
--    <C_DOC_STAN>1</C_DOC_STAN>
--    <D_FILL>02012019</D_FILL>
--    <SOFTWARE>COMDOC:5114175328;DATE:2019-01-02;BY:9863577638028;SU:4823052500009</SOFTWARE>
--  </DECLARHEAD>
--  <DECLARBODY>
--    <HFILL>02012019</HFILL>
--    <HNUM>109</HNUM>
--    <HNAMESEL>ТОВАРИСТВО З ОБМЕЖЕНОЮ ВІДПОВІДАЛЬНІСТЮ  "АРДА-ТРЕЙДИНГ"</HNAMESEL>
--    <HNAMEBUY>Товариство з обмеженою відповідальністю "Новус Україна"</HNAMEBUY>
--    <HKSEL>370295404124</HKSEL>
--    <HTINSEL>37029549</HTINSEL>
--    <HKBUY>360036026593</HKBUY>
--    <HTINBUY>36003603</HTINBUY>
--    <R04G11>3577.92</R04G11>
--    <R03G11>596.32</R03G11>
--    <R03G7>596.32</R03G7>
--    <R01G7>2981.60</R01G7>
--    <RXXXXG3S ROWNUM="1">Лікер Де Кайпер Адвокат (яєчний) 14,8 % 0,7*6; GTIN:8710625500305; IDBY:10487</RXXXXG3S>
--    <RXXXXG3S ROWNUM="2">Лікер Шаріс New Design 0,7*6; GTIN:5390683100629; IDBY:173418</RXXXXG3S>
--    <RXXXXG4 ROWNUM="1">2208701000</RXXXXG4>
--    <RXXXXG4 ROWNUM="2">2208701000</RXXXXG4>
--    <RXXXXG4S ROWNUM="1">пляш</RXXXXG4S>
--    <RXXXXG4S ROWNUM="2">пляш</RXXXXG4S>
--    <RXXXXG105_2S ROWNUM="1">2061</RXXXXG105_2S>
--    <RXXXXG105_2S ROWNUM="2">2061</RXXXXG105_2S>
--    <RXXXXG5 ROWNUM="1">4.00</RXXXXG5>
--    <RXXXXG5 ROWNUM="2">6.00</RXXXXG5>
--    <RXXXXG6 ROWNUM="1">275.9000</RXXXXG6>
--    <RXXXXG6 ROWNUM="2">313.0000</RXXXXG6>
--    <RXXXXG008 ROWNUM="1">20</RXXXXG008>
--    <RXXXXG008 ROWNUM="2">20</RXXXXG008>
--    <RXXXXG010 ROWNUM="1">1103.60</RXXXXG010>
--    <RXXXXG010 ROWNUM="2">1878.00</RXXXXG010>
--    <RXXXXG11_10 ROWNUM="1">220.72</RXXXXG11_10>
--    <RXXXXG11_10 ROWNUM="2">375.60</RXXXXG11_10>
--    <HBOS>М.А. Маймур</HBOS>
--    <HKBOS>2994101113</HKBOS>
--  </DECLARBODY>
--</DECLAR>'
SELECT @myDoc

SELECT @myDoc.value('(/DECLAR/DECLARHEAD/C_STI_ORIG)[1]', 'int' ) 

SET @myDoc.modify('
replace value of ( /DECLAR/DECLARHEAD/C_STI_ORIG/text() )[1] with 2810');

SET @myDoc.modify('
replace value of ( /DECLAR/DECLARHEAD/C_RAJ/text() )[1] with 10');

SELECT @myDoc
*/


update at_z_FilesExchange 
set FileData.modify('replace value of ( /DECLAR/DECLARHEAD/C_STI_ORIG/text() )[1] with 2810')
where ChID in (SELECT chid FROM at_z_FilesExchange where (FileName like '%J1201008%' or FileName like '%J1201010%')and DocDate > '2019-01-03')

update at_z_FilesExchange 
set FileData.modify('replace value of ( /DECLAR/DECLARHEAD/C_RAJ/text() )[1] with 10')
where ChID in (SELECT chid FROM at_z_FilesExchange where (FileName like '%J1201008%' or FileName like '%J1201010%')and DocDate > '2019-01-03')

SELECT * FROM  at_z_FilesExchange where ChID in (SELECT chid FROM at_z_FilesExchange where (FileName like '%J1201008%' or FileName like '%J1201010%')and DocDate > '2019-01-03')

ROLLBACK TRAN


