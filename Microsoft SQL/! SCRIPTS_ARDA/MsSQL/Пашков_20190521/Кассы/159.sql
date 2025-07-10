exec [t_ShowCRBalance] 159

SELECT * FROM t_sale 
where DocDate = CAST(GETDATE() as DATE)
and CRID in (159)


SELECT * FROM t_SaleD d
join r_Prods p on p.ProdID = d.ProdID 
where d.ChID = 100415412

