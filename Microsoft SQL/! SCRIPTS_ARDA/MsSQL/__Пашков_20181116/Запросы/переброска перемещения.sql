select * from [s-sql-d4].elitr.dbo.t_Exc
where docid = 200000819 

select * from [s-sql-d4].elitr.dbo.dbo.t_ExcD
where chid =  100008811

select * from t_ExcD
where chid =  100008646


insert into t_PInP
select t.* from [s-sql-d4].elitr.dbo.dbo.t_excd d
				inner join [s-sql-d4].elitr.dbo.dbo.t_pinp t on d.prodid = t.prodid and d.ppid = t. ppid 
where d.chid = 100008646 

select * from [s-sql-d4].elitr.dbo.dbo.t_pinp 
where prodid in (610175 , 601285)


select * from t_pinp 
where prodid in (610175 , 601285)


select * from t_Exc where DocID = 200000819


/*

insert into t_Exc
select * from [s-sql-d4].elitr.dbo.t_Exc
where docid = 200000819 


insert t_PInP
select *
from [s-sql-d4].elitr.dbo.t_PInP tp
where exists (select * from [s-sql-d4].elitr.dbo.t_ExcD where ChID = 200000818  and ProdID = tp.ProdID and PPID = tp.PPID)
  and not exists (select * from t_PInP where ProdID = tp.ProdID and PPID = tp.PPID)

insert into t_ExcD
select * from [s-sql-d4].elitr.dbo.t_ExcD
where chid =  200000818

*/