DECLARE @s varchar(250) = '' -- PKValue допускаются только буквы и цифры
--DECLARE @ChID varchar(250) = '100002699' -- ChID допускаются только буквы и цифры
DECLARE @TableName varchar(50) = 'r_uni' -- Имя таблицы

--поиск по названию таблиц
select * from z_Tables WHERE TableName = @TableName

SELECT top 100 EmpName z_LogCreate, *  FROM z_LogCreate l
join r_users u on l.UserCode = u.Userid
join r_Emps e on u.EmpID=e.EmpID
where tablecode = (select TableCode from z_Tables where TableName = @TableName)
--and DocDate between  '2016-09-15' and '2016-12-31'
--and l.ChID = @ChID 
and PKValue like '%' + @s + '%' 
order by DocDate desc

SELECT top 100 EmpName z_LogDelete, *  FROM z_LogDelete l
join r_users u on l.UserCode = u.Userid
join r_Emps e on u.EmpID=e.EmpID
where tablecode = (select TableCode from z_Tables where TableName = @TableName)
--and DocDate between  '2016-09-15' and '2016-12-31'
--and l.ChID = @ChID * -1 
and PKValue like '%' + @s + '%' order by DocDate desc


SELECT top 100 EmpName z_LogUpdate, *  FROM z_LogUpdate l
join r_users u on l.UserCode = u.Userid
join r_Emps e on u.EmpID=e.EmpID
where tablecode = (select TableCode from z_Tables where TableName = @TableName)
--and DocDate between  '2016-09-15' and '2016-12-31'
--and l.ChID = @ChID 
and PKValue like '%' + @s + '%' order by DocDate DESC

[6680116] \ [16508]