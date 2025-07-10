USE ElitV_KIEV
--поиск chid по номеру документа 
select * from [s-sql-d4].elitr.dbo.t_exc where DocID = 100016199  
select * from t_exc where DocID = 100029640  

begin tran

DECLARE @chid int = 100029640

select * from [s-sql-d4].elitr.dbo.t_exc where chid = @chid 

select * from [s-sql-d4].elitr.dbo.t_excd where chid = @chid

select * from t_exc where chid = @chid 

select * from t_excd where chid = @chid

insert t_PInP
	SELECT p.* FROM [s-sql-d4].elitr.dbo.t_excd d 
	JOIN [s-sql-d4].elitr.dbo.t_PInP p ON d.ProdID = p.ProdID and d.PPID = p.PPID
	where d.ChID = @ChID
	Except -- дубликаты партий не добавлять
	SELECT p.* FROM [s-sql-d4].elitr.dbo.t_excd d 
	JOIN [s-sql-d4].elitr.dbo.t_PInP p ON d.ProdID = p.ProdID and d.PPID = p.PPID
	JOIN  t_PInP ON t_PInP.ProdID = p.ProdID and t_PInP.PPID = p.PPID
	where d.ChID = @ChID

insert t_exc
select * from [s-sql-d4].elitr.dbo.t_exc where chid = @chid 

insert t_excd
 select ChID, SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode, SecID, NewSecID
   from [s-sql-d4].elitr.dbo.t_excd where chid = @chid 
   --and SrcPosID not in (select SrcPosID from t_excd where chid = 100028236  )


select * from t_exc where chid = @chid 

select * from t_excd where chid = @chid

rollback tran




