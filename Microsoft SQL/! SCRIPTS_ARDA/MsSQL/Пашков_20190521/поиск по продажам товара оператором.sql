declare @DocDate date = '20160902'
				,@StockID int = 1257 --нагорка 1257
--select chid from t_sale where DocDate = @DocDate and StockID = @StockID and CodeID1 = 0

select  * from t_sale
where DocDate = @DocDate
and StockID = @StockID
--and CodeID1 = 0

select t_sale.DocID, t_sale.DocDate, t_sale.StockID, * from t_saleD
join t_sale on t_sale.ChID = t_saleD.ChID 
where t_sale.ChID in (select chid from t_sale where DocDate = @DocDate and StockID = @StockID and CodeID1 = 0)
order by t_sale.DocDate desc

select * from t_SaleC where ChID in (select chid from t_sale where DocDate = @DocDate and StockID = @StockID and CodeID1 = 0)

/*
select t_sale.DocID, t_sale.DocDate, t_sale.StockID, * from t_saleD
join t_sale on t_sale.ChID = t_saleD.ChID 
where t_sale.ChID in (select chid from t_sale where  StockID = @StockID)
and ProdID in (600080,600159,602505)
order by t_sale.DocDate desc
*/