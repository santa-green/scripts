--���������� ������������� � ������ � ����������
DECLARE @RepID_new int = 680, --id ������ � ������� ����� �������� �������������
				@RepID_old int = 531  --id ������ �� �������� ����� �������� �������������
				
select * from v_Reps
where RepID = @RepID_new

select * from v_Reps
where RepID = @RepID_old

select * from v_RepUsers
where RepID = @RepID_new

select * from v_RepUsers 
where RepID = @RepID_old

				
INSERT INTO v_RepUsers (RepID, UserID, APOpen, APEdit, APDelete, APExportTemplate, APExportReport)
select @RepID_new, UserID, APOpen, APEdit, APDelete, APExportTemplate, APExportReport
from v_RepUsers
where RepID = @RepID_old
