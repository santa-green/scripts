SELECT * FROM t_Rem where OurID = 6 and StockID = 1200 and Qty < 0

SELECT * FROM t_Exc where ChID = 2605


SELECT ppid, qty FROM t_rem WHERE stockid  = 1200 and qty > 0 and OurID = 6 and ProdID in (600754,602109,602113)

SELECT * FROM t_PInP where prodid in (600754,602109,602113) and PPID = 1
SELECT BarCode FROM r_prodmq inner join r_prods on r_prods.prodid = r_prodmq.prodid WHERE r_prodmq.prodid in (600754) and r_prodmq.um = r_prods.um

600754,602109,602113)

SELECT TOP 1 ProdID FROM r_ProdMQ WHERE BarCode =  '8410310606892'




BEGIN TRAN


if object_id('tempdb..#recImp') is not null  drop table #recImp create table #recImp(BarCode varchar(15), Qty numeric(21,9), pos int)
                                                                                                                                              
insert into #recImp (barcode, qty) 
select (SELECT ISNULL((SELECT BarCode FROM r_prodmq inner join r_prods on r_prods.prodid = r_prodmq.prodid WHERE r_prodmq.prodid = dd.id_good and r_prodmq.um = r_prods.um), (SELECT good_name FROM it_TSD_goods WHERE id_good = dd.id_good) )) as BarCode, 
dd.Count_real AS Qty 
FROM (SELECT * FROM it_TSD_doc_details where id_doc IN (SELECT id_doc FROM it_TSD_doc_head WHERE doc_type = 1)) dd
                       
                       
exec [ip_ImpToExcFromTerm] 2605

SELECT * FROM t_Exc where ChID = 2605
SELECT * FROM t_ExcD where ChID = 2605

SELECT * FROM t_Rem where OurID = 6 and StockID = 1200 and Qty < 0 and prodid in (600754,602109,602113)

ROLLBACK TRAN


SELECT * FROM it_TSD_doc_head where Doc_type <> 0
SELECT * FROM it_TSD_doc_details where Id_doc =21476

SELECT * FROM t_Rem where OurID = 6 and StockID = 1200 and Qty > 0
and ProdID in (600754,602109,602113)

/*
1 в каком порядке списывать партии по перемещению

2 если товара не хватает на положительных партиях что делать?


*/