use otdata 
select *
from r_prods 
where prodname like '% ���' or prodname like '% ��'
--- ������� ������� �������

-- ���� ���������� ����� ������ 
update r_prods 
	set r_prods.prodname =  r_prods.prodname + ' (�/���)'

from r_prods 
where prodname like '% ���' or prodname like '% ��'