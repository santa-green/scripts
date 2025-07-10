--Справочник товаров по прайсу для Штрихкод комбайна

SELECT DISTINCT  cast(p.ProdID as varchar(6)) +'-'+ cast(p.ProdName as varchar(250)) Наименование, mq.BarCode Штрихкод, mp.PriceMC Цена
FROM r_ProdMQ as mq WITH(NOLOCK)   
INNER JOIN r_Prods as p WITH(NOLOCK) ON mq.ProdID=p.ProdID
LEFT JOIN r_ProdMP as mp WITH(NOLOCK) ON mq.ProdID=mp.ProdID 
INNER JOIN t_Pinp np WITH(NOLOCK) ON np.ProdID = p.ProdID 
--//v1.03 [26.06.2017 11:46] - изменена выгрузка штрихкодов в it_TSD_barcode (убрал лишние штрихкоды в которых встречались не цифровые символы                   
WHERE  ((p.ProdID BETWEEN 600001 AND 605000) OR (p.ProdID BETWEEN 800000 AND 900000)) AND LEN (barcode) > 6 AND mq.qty  = 1 
AND p.ProdID NOT IN (601280,601281,601282,601283,803028,803029,803030) and mq.BarCode not like  '%[^0-9]%' 

AND mp.PLID = 83
ORDER BY 1




--SELECT * FROM r_PLs