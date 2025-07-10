DECLARE @s varchar(250) = '100432786' -- PKValue допускаются только буквы и цифры
--DECLARE @ChID varchar(250) = '100002699' -- ChID допускаются только буквы и цифры
DECLARE @TableName varchar(50) = 't_MonRec' -- Имя таблицы
DECLARE @u_name VARCHAR(256) = 'kkm0'

--поиск по названию таблиц
select * from z_Tables WHERE TableName = @TableName

SELECT top 100 EmpName z_LogCreate, *  FROM z_LogCreate l
join r_users u on l.UserCode = u.Userid
join r_Emps e on u.EmpID=e.EmpID
where --tablecode = (select TableCode from z_Tables where TableName = @TableName)
DocTime between  '2019-03-16' and '2019-03-29'
--and DocTime between  '2019-03-16' and '2019-03-29'
and u.UserName = @u_name
--and l.ChID = @ChID 
--and PKValue like '%' + @s + '%' 
order by DocTime desc

SELECT top 100 EmpName z_LogDelete, *  FROM z_LogDelete l
join r_users u on l.UserCode = u.Userid
join r_Emps e on u.EmpID=e.EmpID
where --tablecode = (select TableCode from z_Tables where TableName = @TableName)
DocTime between  '2019-03-16' and '2019-03-29'
--and DocTime between  '2019-03-16' and '2019-03-29'
and u.UserName = @u_name
--and l.ChID = @ChID * -1 
--and PKValue like '%' + @s + '%' order by DocTime desc


SELECT top 100 EmpName z_LogUpdate, *  FROM z_LogUpdate l
join r_users u on l.UserCode = u.Userid
join r_Emps e on u.EmpID=e.EmpID
where --tablecode = (select TableCode from z_Tables where TableName = @TableName)
DocTime between  '2019-03-16' and '2019-03-29'
--and DocTime between  '2019-03-16' and '2019-03-29'
and u.UserName = @u_name
--and l.ChID = @ChID 
--and PKValue like '%' + @s + '%' order by DocTime desc