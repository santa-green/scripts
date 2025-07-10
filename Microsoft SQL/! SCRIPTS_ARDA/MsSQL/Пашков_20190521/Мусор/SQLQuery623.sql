--Чистка продаж

SELECT * FROM t_MonRec
SELECT * FROM t_Rem
SELECT * FROM t_Sale
SELECT * FROM t_SaleD
SELECT * FROM t_SaleDLV
SELECT * FROM t_SalePays
SELECT * FROM t_SaleTemp



--TRUNCATE TABLE t_MonRec
--TRUNCATE TABLE t_Rem
--TRUNCATE TABLE t_Sale
--TRUNCATE TABLE t_SaleD
--TRUNCATE TABLE t_SaleDLV
--TRUNCATE TABLE t_SalePays
--TRUNCATE TABLE t_SaleTemp

SELECT * FROM [s-sql-d4].elitr.dbo.r_Prods

except

SELECT * FROM r_Prods

SELECT * FROM z_ReplicaSubs

SELECT * FROM [s-sql-d4].elitr.dbo.z_ReplicaSubs

SELECT * FROM r_PCs