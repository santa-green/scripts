SELECT d.ProdID, * FROM t_Sale m
join t_SaleD D on d.ChID = m.ChID
where DocDate > '2017-02-22'
and d.ProdID in( 606967,607333)
order by 1

SELECT * FROM t_MonRec where DocID = 132844

SELECT * FROM r_CRs


SELECT * FROM t_Sale where ChID in (100418625) 

SELECT * FROM t_SaleD where ChID in (100418625) 

SELECT * FROM r_Prods where ProdID in (606967,607334)

SELECT * FROM t_Sale where OurID = 9 and DocID < 200000000
order by DocID desc