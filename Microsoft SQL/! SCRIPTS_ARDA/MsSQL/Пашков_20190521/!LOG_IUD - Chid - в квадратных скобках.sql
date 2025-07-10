DECLARE @s varchar(250) = '30689' -- PKValue ����������� ������ ����� � �����
--DECLARE @ChID varchar(250) = '100002699' -- ChID ����������� ������ ����� � �����
DECLARE @TableName varchar(50) = 'r_ProdEC' -- ��� �������


--����� �� �������� ������
select * from z_Tables WHERE TableName = @TableName

SELECT top 100 EmpName, *  FROM z_LogCreate l
join r_users u on l.UserCode = u.Userid
join r_Emps e on u.EmpID=e.EmpID
where tablecode = (select TableCode from z_Tables where TableName = @TableName)
--and DocDate between  '2016-09-15' and '2016-12-31'
--and l.ChID = @ChID 
and PKValue like '%|[' + @s + '|]%' ESCAPE '|'
order by DocDate desc

SELECT top 100 EmpName, *  FROM z_LogDelete l
join r_users u on l.UserCode = u.Userid
join r_Emps e on u.EmpID=e.EmpID
where tablecode = (select TableCode from z_Tables where TableName = @TableName)
--and DocDate between  '2016-09-15' and '2016-12-31'
--and l.ChID = @ChID 
and PKValue like '%|[' + @s + '|]%' ESCAPE '|'
order by DocDate desc


SELECT top 100 EmpName, *  FROM z_LogUpdate l
join r_users u on l.UserCode = u.Userid
join r_Emps e on u.EmpID=e.EmpID
where tablecode = (select TableCode from z_Tables where TableName = @TableName)
--and DocDate between  '2016-09-15' and '2016-12-31'
--and l.ChID = @ChID 
and PKValue like '%|[' + @s + '|]%' ESCAPE '|'
order by DocDate desc