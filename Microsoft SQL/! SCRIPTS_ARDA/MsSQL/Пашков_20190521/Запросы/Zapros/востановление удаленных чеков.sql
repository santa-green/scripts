
--востановление удаленных чеков 
/*Выбрали нужный чек */
select e.* , e.ChID *(-1) ,r.UserID , r.UserName,  re.EmpName
from [s-marketa].elitv_dp.dbo.z_LogDelete  e
join r_Users r on e.usercode = r.UserID
join r_Emps re on r.empid = re.EmpID 
where tablecode = 11035001 and DocDate >= dbo.zf_GetDate (GETDATE ()-1)


select * from [s-marketa].elitv_dp.dbo.t_Sale where chid  = 100053908
select * from [s-sql-d4].ElitR.dbo.z_ReplicaIn where  replicaeventid between 11606813 and 11606826

/*нашли по CHID на тестовой D4 и выполнили все что не DEL */
select * from [s-sql-d4].ElitR.dbo.z_ReplicaIn where ExecStr like '%100053908%' order by replicaeventid
/*в базе магазина вставляем данные по нужному chid*/

select * from [s-sql-d4].ElitR_TEST.dbo t_Sale where chid = 
select * from [s-sql-d4].ElitR_TEST.dbo t_SaleD where chid = 
select * from [s-sql-d4].ElitR_TEST.dbo t_SaleC where chid = 

select * from [s-sql-d4].ElitR_TEST.t_SalePays where chid = 


select * from t_Sale where chid  = 100053908