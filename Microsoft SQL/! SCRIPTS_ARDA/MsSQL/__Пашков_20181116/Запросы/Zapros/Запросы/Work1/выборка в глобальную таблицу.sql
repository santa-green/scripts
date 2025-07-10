use otdata


select  chid =12, 
		
 identity(smallint,1,1) SrcPosID, td.ProdID ,td.PPID,td.UM,sum (td.Qty)QTY , td.PriceCC_nt,sum (td.SumCC_nt)SumCC_nt,td.Tax, sum (td.TaxSum)TaxSum,td.PriceCC_wt,
				sum (td.SumCC_wt)SumCC_wt ,td.BarCode , td.TaxID,td.SecID,td.PurPriceCC_nt, td.PurTax,td.PurPriceCC_wt,td.PLID

into  _tests3/*имя таблицы зависит от скалада*/
	from t_sale t inner join t_saled td on t.chid = td.chid 
		
	where t.docdate  = CONVERT(DATETIME, '2005-05-08 00:00:00', 102)and t.StockID = 3 /*склад*/
group by  td.ProdID ,td.PPID,td.UM, td.PriceCC_nt,td.Tax, td.PriceCC_wt,
			td.BarCode , td.TaxID,td.SecID,td.PurPriceCC_nt, td.PurTax,td.PurPriceCC_wt,td.PLID,
	t.StockID