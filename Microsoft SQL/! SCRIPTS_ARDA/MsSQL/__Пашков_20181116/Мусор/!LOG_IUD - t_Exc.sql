DECLARE @s varchar(250) = '200002373' -- допускаются только буквы и цифры

SELECT top 100 EmpName, *  FROM z_LogCreate l
join r_users u on l.UserCode = u.Userid
join r_Emps e on u.EmpID=e.EmpID
where tablecode = (select TableCode from z_Tables where TableName = 't_Exc')
--and DocDate between  '2016-09-15' and '2016-12-31'
and PKValue like '%' + @s + '%'
order by DocDate desc

SELECT top 100 EmpName, *  FROM z_LogDelete l
join r_users u on l.UserCode = u.Userid
join r_Emps e on u.EmpID=e.EmpID
where tablecode = (select TableCode from z_Tables where TableName = 't_Exc')
--and DocDate between  '2016-09-15' and '2016-12-31'
and PKValue like '%' + @s + '%'
order by DocDate desc


SELECT top 100 EmpName, *  FROM z_LogUpdate l
join r_users u on l.UserCode = u.Userid
join r_Emps e on u.EmpID=e.EmpID
where tablecode = (select TableCode from z_Tables where TableName = 't_Exc')
--and DocDate between  '2016-09-15' and '2016-12-31'
and PKValue like '%' + @s + '%'
order by DocDate desc