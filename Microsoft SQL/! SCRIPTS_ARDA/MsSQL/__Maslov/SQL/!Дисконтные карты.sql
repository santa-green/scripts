USE ElitR;

--������ ��� ������ ��������� ��������� � ���������� � ���������� �����, ���� ����� ����� ����
--� ����� �������� � ��� �� ��������

/*
IF OBJECT_ID (N'tempdb..#DCards', N'U') IS NOT NULL DROP TABLE #DCards -- �������� ������ �� Excel
SELECT CAST(CAST(ex.card AS BIGINT) as VARCHAR) card, CAST(CAST(ex.tel AS BIGINT) as VARCHAR) tel 
 INTO #DCards	
FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', N'Excel 12.0; IMEX=1; Database=\\s-sql-d4\OT38ElitServer\Import\test\DisCards.xlsx' , 'select * from [����1$]') as ex
*/

IF OBJECT_ID (N'tempdb..#DCards', N'U') IS NOT NULL DROP TABLE #DCards -- �������� ������ �� Excel

CREATE TABLE #DCards (ID INT IDENTITY(1,1) NOT NULL, card varchar(50) NULL, tel varchar(50) NULL, FullName VARCHAR(200))
		
INSERT INTO #DCards

--EXCEL: ="union all select "&"'"&A2&"', "&"'"&B2&"', '"&C2&"'"
		
		  select '2220000007559', '380675634280', '�������� ����� ����������'
union all select '2220000403696', '380979221721', '������� ������ ��������'
union all select '2220000227780', '380973793304', '����� ����������'
union all select '2220000017572', '380985739890', '��������  ���������� ����������'
union all select '2220000006989', '380985022981', '������������� �����'
union all select '2220000171069', '380503401937', '��������� ����� ����������'
union all select '2220000095082', '380677644658', '������� ������� ���������'
union all select '2220000009188', '380954130413', '����� �������� ����������'
union all select '2220000174824', '380672168050', '�������� ������ ���������'
union all select '2220000154567', '380676317876', '�������� ������'
union all select '2220000403139', '380507591719', '������������ ����'
union all select '2220000376662', '380987894013', '����� �������'
union all select '2220000377881', '380504805380', '�������� ���� �����������'
union all select '2220000053143', '380675672668', '����� ���� ��������'
union all select '2220000378307', '380973871443', '��������� ����� �����������'
union all select '2220000111227', '380504708473', '����� �����'
union all select '2220000378802', '380509902238', '�����'
union all select '2220000378796', '380970825314', '������ ��������'
union all select '250000006432', '380505987555', '������������ �������'
union all select '2220000071666', '380676333611', '�����'

SELECT tdc.card AS 'DCardID', rps.ChID, rps.PersonID, rps.PersonName, rps.Phone AS 'CurrentPhone', tdc.tel AS 'NewPhone', tdc.FullName
FROM r_DCards rd
JOIN r_PersonDC rpdc WITH(NOLOCK) ON rpdc.DCardChID = rd.ChID
JOIN r_Persons rps WITH(NOLOCK) ON rps.PersonID = rpdc.PersonID
JOIN #DCards tdc ON tdc.card = rd.DCardID
WHERE rd.DCardID IN (SELECT card FROM #DCards)

/*
SELECT * FROM at_r_Clients

SELECT ChID, PersonID, PersonName, Phone
FROM r_Persons
WHERE PersonID IN (
	SELECT PersonID FROM r_PersonDC
	WHERE DCardChID IN ( 
		SELECT ChID FROM r_DCards
		WHERE DCardID IN (SELECT card FROM #DCards)
					   )
				   )
*/