SELECT * FROM r_CRs

-- �������� ������� ������ ����� �����
begin tran

update r_CRs
  set CRName = cast(CRID AS varchar(3)) + '-' + CRName

SELECT * FROM r_CRs

rollback tran


--���������� ������ ���� � [s-sql-d4].elitr.dbo.r_CRs
begin tran

update r_CRs
set CRName = d4.CRName
from [s-sql-d4].elitr.dbo.r_CRs d4 where r_CRs.CRID = d4.CRID

SELECT * FROM r_CRs

rollback tran