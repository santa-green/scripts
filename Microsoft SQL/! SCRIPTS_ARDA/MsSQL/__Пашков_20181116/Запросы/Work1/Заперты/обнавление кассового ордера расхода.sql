--select *
--from b_cExp

update b_cExp 
	set b_cExp.notes = '��������� ��������� �� ��������'
from b_cExp b
where b.notes is null