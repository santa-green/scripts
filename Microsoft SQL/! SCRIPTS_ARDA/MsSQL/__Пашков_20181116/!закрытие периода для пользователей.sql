--�������� �������� ��� �������������

begin tran

USE ElitR

--������ ���� �������� ������
DECLARE @BDate SMALLDATETIME = DATEADD(month,DATEDIFF(month,0,GETDATE()),0)
SELECT @BDate

DECLARE @UserNameTable table(UserName varchar(250) NULL) 
insert into @UserNameTable select UserName from r_Users
	where UserName in (
--��������� ��������� �������������

'rnu', -- ��������� ������� �������
'bos', -- �������� ����� �������������
'const\pashkovv', -- ������ �������� ����������
'gdn1', -- ������ ����� ����������
'giv3', -- ������� (���������) ����� ����������
'GMSSync', -- System Administrator ��� �������������
'ioa', -- ������ ����� �������������
'kkm0', -- ���������� ������ ���������� 
'kvn1', -- �������� �������� ����������
'pvm0', -- ������ �������� ����������
'sa', -- System Administrator ����� �������
'sao' -- �������� ���� ��������

)

SELECT * FROM r_Users where UserName not in ( SELECT * FROM @UserNameTable) ORDER BY UseOpenAge

update r_Users 
set BDate = @BDate, UseOpenAge = 1
where UserName  not in ( SELECT * FROM @UserNameTable)

SELECT * FROM r_Users where UserName  not in ( SELECT * FROM @UserNameTable) ORDER BY UserName


rollback tran



