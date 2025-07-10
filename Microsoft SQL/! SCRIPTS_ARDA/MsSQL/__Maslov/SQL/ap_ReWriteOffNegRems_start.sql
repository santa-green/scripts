SELECT * FROM t_SaleD where PPID != 0 and ProdID = 8000 ORDER BY CreateTime desc
SELECT * FROM t_SaleD where PPID != 0 and ProdID = 603101 ORDER BY CreateTime desc
SELECT * FROM t_SaleD where ProdID = 603101 ORDER BY CreateTime desc
SELECT * FROM t_SaleD where PPID = 0 ORDER BY CreateTime desc
SELECT * FROM r_Prods where ProdID in (603101,8000)
SELECT * FROM t_PInP where ProdID = 603101
SELECT * FROM t_Sale where chid = 900043480
SELECT * FROM t_SaleD where chid = 900043480
SELECT * FROM t_SaleD ORDER BY CreateTime desc
--[ap_ReWriteOffNegRems]