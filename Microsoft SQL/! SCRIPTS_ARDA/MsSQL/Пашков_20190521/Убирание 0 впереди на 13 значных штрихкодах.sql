

SELECT SUBSTRING(BarCode,2,12), * FROM r_ProdMQ where BarCode like '0%' and LEN(BarCode) = 13
 and BarCode not like  '%[^0-9]%' 
and (ProdID BETWEEN 600001 and 604999 or ProdID BETWEEN 800000 and 900000)


and  SUBSTRING(BarCode,2,12) not in (SELECT BarCode FROM r_ProdMQ)  
order by 1

/*--Убирание 0 впереди на 13 значных штрихкодах

update r_ProdMQ
set BarCode = SUBSTRING(BarCode,2,12)
 FROM r_ProdMQ where BarCode like '0%' and LEN(BarCode) = 13
 and BarCode not like  '%[^0-9]%' 
and (ProdID BETWEEN 600001 and 604999 or ProdID BETWEEN 800000 and 900000)   
and  SUBSTRING(BarCode,2,12) not in (SELECT BarCode FROM r_ProdMQ)

*/

--проверка на 14 значные коды
SELECT SUBSTRING(BarCode,2,12), * FROM r_ProdMQ where BarCode like '0%' and LEN(BarCode) > 13
 and BarCode not like  '%[^0-9]%' 
and (ProdID BETWEEN 600001 and 604999 or ProdID BETWEEN 800000 and 900000)

