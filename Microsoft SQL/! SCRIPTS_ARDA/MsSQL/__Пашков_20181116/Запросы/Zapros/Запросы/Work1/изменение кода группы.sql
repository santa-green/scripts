use otdata
select *
from r_prods r
where r.pgrid = 98--  ��� ������
	and r.pgrid1 = 3-- ������ ��� ������ 
--	and  r.prodname like '������%' -- ������������� ������ ���� ����
--��� ���� ������� - ���������� ��� ��������� �� ������ � ������� ���� �������� ��� ������ �� ����� 


update r_prods  -- ���������� ����������
set r_prods.pgrid1 = --����� ��� ������
from r_prods r
where r.pgrid = -- ��� ������
	and r.pgrid1 = --������ ��� ������ 
--	and  r.prodname like '������%' -- ������������� ������ ���� ����
 
