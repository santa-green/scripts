--������ �� xml �����
DECLARE @xml XML
--SET @xml = ( SELECT * FROM OPENROWSET (BULK '\\s-sql-d4.corp.local\OT38ElitServer\Import\XML\test3.xml', SINGLE_CLOB) AS xml )

--INSERT at_SendXML (xml)
--select @xml xml

SET @xml = ( select AEI_XML from dbo.az_EDI_Invoices_ where  AEI_DOC_TYPE = 12 and AEI_P7S_NAME like '%5113283314%' )

SELECT 
T.c.query('.') AS VALUE  
,T.c.query('.').value('ʳ������[1]', 'numeric(21,9)') AS ʳ������
 --INTO NOTARIUS 
FROM   @xml.nodes('/�������������������/�������/�����/������������/ʳ������') T(c)


select sum(T.c.query('.').value('ʳ������[1]', 'numeric(21,9)')) AS sum_ʳ������ from dbo.az_EDI_Invoices_ s1
CROSS APPLY s1.AEI_XML.nodes('/�������������������/�������/�����/������������/ʳ������') T(c)
where  AEI_DOC_TYPE = 12 and AEI_P7S_NAME like '%5113283314%'

--�������>
--    <����� ��="1">
--      <������>1</������>
--      <�������� ��="1">8427894007038</��������>
--      <��������������>174004</��������������>
--      <������������>���� Lozano. ������, ��� 0,75*12</������������>
--      <������������>��</������������>
--      <������ֳ��>84.00 </������ֳ��>
--      <���>16.80 </���>
--      <ֳ��>100.80 </ֳ��>
--      <�������������>
--        <����������>1008.00 </����������>
--        <�������>201.60 </�������>
--        <����>1209.60 </����>
--      </�������������>
--      <������������>
--        <ʳ������>12.000 </ʳ������>
--      </������������>
--    </�����>
--  </�������>


--SELECT ChID, COUNT(ChID) FROM t_Invd
--group by ChID
--ORDER BY 2 desc


--SELECT * FROM t_Inv
--WHERE ChiD in (200003990,101543765,200020531,200022784,200007003,200008356,101401335,101315360,101321735,200004020,200100352)
--ORDER BY 1

