select sum (d.SumCC_wt), t.StockID , r.StockName , COUNT (t.DocID) , rc.CRName
from t_Sale  t inner join t_SaleD d on t.ChID = d.ChID 
			   inner join r_Stocks r on t.StockID = r.StockID
			   inner join r_CRs rc on t.CRID = rc.CRID
where DocDate <= '2012-12-12' 
group by t.StockID ,  r.StockName , rc.CRName

union 
select sum (d.SumCC_wt), ' ', ' ', ' ', ' '
from t_Sale  t inner join t_SaleD d on t.ChID = d.ChID 
			   inner join r_Stocks r on t.StockID = r.StockID
			   inner join r_CRs rc on t.CRID = rc.CRID
where DocDate <= '2012-12-12' 


