/*
SELECT rd.DCardID AS '����� �����', rps.PersonName AS '���', ISNULL(rps.Phone, '��� ��������') AS '�������', ISNULL( CONVERT(VARCHAR, rps.Birthday, 104), '��� ���� ��������') AS '���� ��������', ISNULL(rps.EMail, '��� Email') AS 'Email', ISNULL(rps.FactCity, '��� ������') AS '�����'
FROM r_DCards rd
JOIN r_PersonDC rpdc WITH(NOLOCK) ON rpdc.DCardChID = rd.ChID
JOIN r_Persons rps WITH(NOLOCK) ON rps.PersonID = rpdc.PersonID
*/

SELECT * FROM (
SELECT DISTINCT rps.PersonName AS '���', ISNULL(rps.Phone, '��� ��������') AS '�������', ISNULL( CONVERT(VARCHAR, rps.Birthday, 104), '��� ���� ��������') AS '���� ��������', ISNULL(rps.EMail, '��� Email') AS 'Email', ISNULL(rps.FactCity, '��� ������') AS '�����'
FROM r_DCards rd
JOIN r_PersonDC rpdc WITH(NOLOCK) ON rpdc.DCardChID = rd.ChID
JOIN r_Persons rps WITH(NOLOCK) ON rps.PersonID = rpdc.PersonID
) q
ORDER BY 5

