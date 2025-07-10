--штрихкоды только цифры из продаж
SELECT bc.BarCode, rp.ProdName, rpm.PriceMC 
FROM r_Prods  rp
join ( SELECT distinct BarCode,ProdID FROM t_SaleD 
where LEN(BarCode) > 7 and BarCode not like  '%[^0-9]%'  
 ) bc on bc.ProdID = rp.ProdID
 join r_ProdMP rpm on rpm.ProdID = rp.ProdID
 where rpm.PLID = 70 and rpm.PriceMC  > 0


SELECT *, LEN(BarCode) FROM r_ProdMQ where LEN(BarCode) > 6 and BarCode not like  '%[^0-9]%' 
and (ProdID BETWEEN 600001 and 604999 or ProdID BETWEEN 800000 and 900000)   
and BarCode like '0%' and LEN(BarCode) > 12
order by 1

SELECT distinct BarCode, LEN(BarCode) FROM t_SaleD 
where LEN(BarCode) > 7 and BarCode not like  '%[^0-9]%'  
ORDER BY LEN(BarCode),1 desc
 
 SELECT distinct BarCode,ProdID FROM t_SaleD 
where LEN(BarCode) > 7 and BarCode not like  '%[^0-9]%'  
ORDER BY 1 


SELECT * FROM r_ProdMQ
ORDER BY 1,2,3,4


SELECT * FROM r_ProdMQ where BarCode like '0%' and LEN(BarCode) = 13
 and BarCode not like  '%[^0-9]%' 
and (ProdID BETWEEN 600001 and 604999 or ProdID BETWEEN 800000 and 900000)   
order by 1

SELECT * FROM r_ProdMQ where LEN(BarCode) > 13 and BarCode not like '222%' and BarCode not like '%@%' order by BarCode

/*--Убирание 0 впереди на 13 значных штрихкодах
update r_ProdMQ
set BarCode = SUBSTRING(BarCode,2,12)
 FROM r_ProdMQ where BarCode like '0%' and LEN(BarCode) = 13
 and BarCode not like  '%[^0-9]%' 
and (ProdID BETWEEN 600001 and 604999 or ProdID BETWEEN 800000 and 900000)   
*/


SELECT SUBSTRING(BarCode,2,12), * FROM r_ProdMQ where BarCode like '0%' and LEN(BarCode) = 13
 and BarCode not like  '%[^0-9]%' 
and (ProdID BETWEEN 600001 and 604999 or ProdID BETWEEN 800000 and 900000)   
order by 1