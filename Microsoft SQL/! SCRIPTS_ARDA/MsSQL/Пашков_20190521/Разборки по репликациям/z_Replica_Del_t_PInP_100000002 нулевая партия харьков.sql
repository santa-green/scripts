7450152	7	
z_Replica_Del_t_PInP_8 600226,0	2	The transaction ended in the trigger. The batch has been aborted.  ���������� �������� ������ � ������� '���������� ������� - ���� ������� �������� (t_PInP)'. ���������� ������ � ����������� ������� '������� ������ (�������) (t_Rem)'.	2016-10-17 11:00:00.000

--������ ������� ������� ������ � ���� � ElitR ������� �� ����� ����������� � ����������� �� ���� �����
select * from [s-marketa3].elitv_dp2.dbo.z_replicain where status != 1 --Harkov 192.168.126.21
order by replicaeventid

--�������. �������� ��� �������
update [s-marketa3].elitv_dp2.dbo.z_replicain
set status = 1
where status != 1 and ReplicaEventID = 7450152