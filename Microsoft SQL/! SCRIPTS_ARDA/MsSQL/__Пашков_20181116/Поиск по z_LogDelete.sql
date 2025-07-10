SELECT top 100 EmpName, *  FROM z_LogDelete l
join r_users u on l.UserCode = u.Userid
join r_Emps e on u.EmpID=e.EmpID
where tablecode = (select TableCode from z_Tables where TableName = 't_PInP')
and PKValue like '%705993%'
order by DocDate desc