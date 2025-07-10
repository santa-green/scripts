DECLARE @s varchar(250) = '' -- PKValue допускаются только буквы и цифры
DECLARE @ChID varchar(250) = '0' -- ChID допускаются только буквы и цифры
DECLARE @TableName varchar(50) = 'z_vars' -- Имя таблицы


--поиск по названию таблиц
select * from z_Tables WHERE TableName = @TableName

--SELECT top 100 EmpName, *  FROM z_LogCreate l
--join r_users u on l.UserCode = u.Userid
--join r_Emps e on u.EmpID=e.EmpID
--where tablecode = (select TableCode from z_Tables where TableName = @TableName)
----and DocDate between  '2016-09-15' and '2016-12-31'
--and (l.ChID = @ChID OR @s = '')
--and (PKValue like '%|[' + @s + '|]%' ESCAPE '|' OR @s = '')
--order by DocDate desc

--SELECT top 100 EmpName, *  FROM z_LogDelete l
--join r_users u on l.UserCode = u.Userid
--join r_Emps e on u.EmpID=e.EmpID
--where tablecode = (select TableCode from z_Tables where TableName = @TableName)
----and DocDate between  '2016-09-15' and '2016-12-31'
--and (l.ChID = @ChID OR @s = '')
--and (PKValue like '%|[' + @s + '|]%' ESCAPE '|' OR @s = '')
--order by DocDate desc


SELECT top 100 EmpName, *  FROM z_LogUpdate l
join r_users u on l.UserCode = u.Userid
join r_Emps e on u.EmpID=e.EmpID
where tablecode = (select TableCode from z_Tables where TableName = @TableName)
--and DocDate between  '2016-09-15' and '2016-12-31'
and (l.ChID = @ChID OR @s = '')
and (PKValue like '%|[' + @s + '|]%' ESCAPE '|' OR @s = '')
order by DocDate desc