USE Elit

--отчет по созданым Расходным накладным
SELECT  'Созданные Расходные накладные АРДА' 'Действие',l.UserCode, max( EmpName) ФИО,count(distinct l.ChID) 'кол РН' FROM z_LogCreate l
join r_users u on l.UserCode = u.Userid
join r_Emps e on u.EmpID=e.EmpID
join t_Inv i on i.ChID=l.ChID
where tablecode = (select TableCode from z_Tables where TableName = 't_Inv')
and dbo.zf_GetDate(i.DocDate) between '20180901' and '20181130'
and e.EmpID in (10401,7104,7119)
group by l.UserCode
union
--заказы по маркетвин 824 (обрабатывает Понизовная Наталья Васильевна)
SELECT 'Созданные Расходные накладные МАРКЕТВИН' 'Действие',2019 UserCode, 'Понизовная Наталья Васильевна' 'ФИО', count(*) [кол РН] FROM t_Inv m where docdate between '20180901' and '20181130' and m.EmpID = 7039
ORDER BY 2


SELECT * FROM t_Inv m where docdate between '20180901' and '20181130' 
and m.StockID in (4,104,304,1104) 
--and m.OurID in (1)


--отчет по измененным заказам
SELECT  l.UserCode,count(distinct l.ChID) 'кол заказов', max( EmpName) ФИО FROM z_LogUpdate l
join r_users u on l.UserCode = u.Userid
join r_Emps e on u.EmpID=e.EmpID
join t_Inv i on i.ChID=l.ChID
where tablecode = (select TableCode from z_Tables where TableName = 'at_t_IORes')
and dbo.zf_GetDate(l.DocDate) between '20180901' and '20181130'
and e.EmpID in (10401,7104,7119)
group by l.UserCode







/*
SELECT (SELECT e.UAEmpName FROM r_Emps e where e.EmpID = m.EmpID),m.EmpID,* FROM t_Inv m where docdate between '20180901' and '20181130'
and m.EmpID in (10401)
ORDER BY 1

SELECT * FROM r_Emps e --where e.EmpID = 


SELECT * FROM z_Tables

--11012001
--t_Inv



--666004001
SELECT * FROM at_t_IORes  m where docdate between '20180901' and '20181130'


SELECT top 1000 EmpName z_LogCreate, *  FROM z_LogCreate l
join r_users u on l.UserCode = u.Userid
join r_Emps e on u.EmpID=e.EmpID
where tablecode = (select TableCode from z_Tables where TableName = 't_Inv')
and DocDate between  '20180901' and '20181130'
and e.EmpID in (10401,7104,7119)
--and l.ChID = @ChID 
and PKValue like '%' + @s + '%' 
order by DocDate desc





SELECT  EmpName z_LogCreate, *  FROM z_LogCreate l
join r_users u on l.UserCode = u.Userid
join r_Emps e on u.EmpID=e.EmpID
join t_Inv i on i.ChID=l.ChID
where tablecode = (select TableCode from z_Tables where TableName = 't_Inv')
and dbo.zf_GetDate(l.DocDate) between  '20180901' and '20181130'
and e.EmpID in (10401,7104,7119)
ORDER BY 1,l.DocDate

*/