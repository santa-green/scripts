--�������. �������� ������� �� �������

--����� ���������

select  * from z_ReplicaIn 
where status != 1 and replicaeventid between 4526 and 4997
order by replicaeventid 

--��������� ������� �� 1 ��� ������ ����������
update z_replicain 
set status = 1
where status != 1 and replicaeventid between 4526 and 4997


