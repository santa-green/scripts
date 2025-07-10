/*
declare @ppid int
select @ppid = max (ppid)
from t_pinp 
where prodid = 401




if qty > 0 then 
	begin */
		declare @ppid int --, @priceMC_In float
							
		select @ppid = max (ppid)--, @priceMC_In= priceMC_In
		from t_pinp 
		where prodid = 401
--		group by priceMC_In

--		print @priceMC_In
	--	print @ppid

	insert into t_pinp 
select ProdID, PPID + 1 , PPDesc, PriceMC_In, PriceMC, Priority + 1, ProdDate, CurrID,
	 CompID, Article, CostAC, PPWeight, File1, File2, File3, PriceCC_In, CostCC, PPDelay, ProdPPDate 
from t_pinp 
where prodid = 401 and ppid = @ppid

select *
from t_pinp
where prodid = 401
  