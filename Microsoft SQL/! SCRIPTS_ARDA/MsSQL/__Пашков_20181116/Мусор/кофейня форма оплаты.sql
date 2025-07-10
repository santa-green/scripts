SELECT * FROM t_sale
join t_SalePays on t_SalePays.ChID = t_sale.ChID
where DocDate = '2017-04-08'
order by TRealSum desc