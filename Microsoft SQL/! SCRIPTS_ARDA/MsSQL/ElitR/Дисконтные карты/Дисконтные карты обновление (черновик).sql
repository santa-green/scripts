USE ElitR
GO

SELECT * FROM z_LogDiscRec WHERE DCardChID = '2220000068963' 
SELECT top(10) * FROM z_LogDiscRec 
SELECT LogID, DBiID FROM z_LogDiscRec WHERE DCardChID = '2220000456906' 
SELECT * FROM z_LogDiscRec WHERE LogID = '20094429'
SELECT * FROM z_LogDiscRec WHERE LogID = '20094631'
SELECT * FROM z_LogDiscRec WHERE DBiID = 2 ORDER BY LogID DESC
SELECT top(10)* FROM z_LogDiscRec ORDER BY LogID DESC
SELECT * FROM z_LogDiscRec WHERE DCardChID = '100014998' ORDER BY LogID DESC
SELECT * FROM z_LogDiscRec WHERE DCardChID = '200023993' ORDER BY LogID DESC

SELECT * FROM r_DBIs
/*2*/  100000001 - 199999999
/*14*/ 1400000000 - 1499999999
select len(900000000)
select len(1100000000)

--������ �� 2220000068963
--����� �� 2220000456906

SELECT * FROM r_DCards WHERE DCardID = '2220000068963'; --r_DCards	���������� ���������� ����; --ChID 200008778
SELECT * FROM z_DocDC WHERE DCardChID = '100014998'; --z_DocDC	��������� - ���������� �����; --11035-������� ������ ����������, 10400-���������� ���������� ����
SELECT * FROM r_PersonDC WHERE DCardChID = '100014998'; --r_PersonDC	���������� ������ - ���������� �����; --WHERE ChID = '100003647' --WHERE Phone like '%0676339619%'--PersonName like '%����������%'
SELECT * FROM r_Persons WHERE PersonID = '25015'; --r_Persons	���������� ������; --WHERE ChID = '100003647' --WHERE Phone like '%0676339619%'--PersonName like '%����������%'


SELECT * FROM r_DCards WHERE DCardID = '2220000456906'; --r_DCards	���������� ���������� ����; --ChID 200008778
SELECT * FROM z_DocDC WHERE DCardChID = '200023993'; --z_DocDC	��������� - ���������� �����; --11035-������� ������ ����������, 10400-���������� ���������� ����
SELECT * FROM r_PersonDC WHERE DCardChID = '200023993'; --r_PersonDC	���������� ������ - ���������� �����; --WHERE ChID = '100003647' --WHERE Phone like '%0676339619%'--PersonName like '%����������%'
SELECT * FROM r_Persons WHERE PersonID = '50429'; --r_Persons	���������� ������; --WHERE ChID = '100003647' --WHERE Phone like '%0676339619%'--PersonName like '%����������%'

SELECT * FROM r_DCardKin --Invalid object name 'r_DCardKin'.
SELECT * FROM r_PersonKin --������� ������.
SELECT * FROM r_PersonKinLog --������� ������.
SELECT * FROM ir_DCardsOld ORDER BY Notes DESC
SELECT * FROM ir_DCardsOld WHERE DCardID = '2220000456906'

SELECT zd.dcardchid, rs.PersonID, rs.PersonName, rs.Phone, * FROM r_DCards rd --r_DCards	���������� ���������� ����
JOIN z_DocDC zd ON rd.ChID = zd.ChID --z_DocDC	��������� - ���������� �����
JOIN r_PersonDC rp ON rp.DCardChID = zd.ChID --r_PersonDC	���������� ������ - ���������� �����
JOIN r_Persons rs ON rs.PersonID = rp.PersonID --r_Persons	���������� ������
WHERE rd.DCardID = '2220000456906'

z_RelationError