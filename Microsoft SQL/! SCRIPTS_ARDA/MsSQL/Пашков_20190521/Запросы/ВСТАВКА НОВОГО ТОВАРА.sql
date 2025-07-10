declare @prodid int
set @prodid = 606111
select * from  r_prods where ProdID = @prodid 

select * from  ElitR.dbo.r_prods where ProdID = @prodid 

insert r_prods
select * from  ElitR.dbo.r_prods where ProdID = @prodid 
insert t_PInP
select * from  ElitR.dbo.t_PInP where ProdID = @prodid 
insert r_ProdMP
select * from  ElitR.dbo.r_ProdMP where ProdID = @prodid 
insert r_ProdMQ
select * from  ElitR.dbo.r_ProdMQ where ProdID = @prodid 

select * from  r_prods where ProdID = @prodid 

/*
insert r_ProdG
select * from ElitR.dbo.r_ProdG where PGrID =  50071


 select * from  ElitR.dbo.r_prods where ProdName  like '%варшт%разлив%'
*/