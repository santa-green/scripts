
SELECT *, LEN(BarCode) FROM r_ProdMQ where LEN(BarCode) > 6 and BarCode not like  '%[^0-9]%' 
and (ProdID BETWEEN 600001 and 604999 or ProdID BETWEEN 800000 and 900000)   
--and BarCode like '0%' and LEN(BarCode) > 12
order by 1


SELECT *, LEN(BarCode) FROM r_ProdMQ mq
INNER JOIN r_Prods as p WITH(NOLOCK) ON mq.ProdID=p.ProdID
WHERE  ((p.ProdID BETWEEN 600001 AND 605000) OR (p.ProdID BETWEEN 800000 AND 900000))  AND p.ProdID NOT IN (601280,601281,601282,601283,803028,803029,803030)
AND LEN (barcode) > 6 AND mq.qty  = 1 AND LEN(BarCode) > 6 and BarCode not like  '%[^0-9]%'
--AND mq.barcode not in (select barcode from it_TSD_barcode)

ORDER BY BarCode

'WHERE  ((p.ProdID BETWEEN 600001 AND 605000) OR (p.ProdID BETWEEN 800000 AND 900000)) AND LEN (barcode) > 6 AND mq.qty  = 1 AND mq.barcode not in (select barcode from it_TSD_barcode) ' + 
' AND p.ProdID NOT IN (601280,601281,601282,601283,803028,803029,803030) AND LEN(BarCode) > 6 and BarCode not like  ''%[^0-9]%'' ' + filter + Chr(13)+  



SELECT *, LEN(BarCode) FROM r_ProdMQ mq
INNER JOIN r_Prods as p WITH(NOLOCK) ON mq.ProdID=p.ProdID
WHERE  ((p.ProdID BETWEEN 600001 AND 605000) OR (p.ProdID BETWEEN 800000 AND 900000)) AND p.ProdID NOT IN (601280,601281,601282,601283,803028,803029,803030)
AND LEN (barcode) > 6 AND mq.qty  = 1 AND LEN(BarCode) > 6 and BarCode not like  '%[^0-9]%'
--AND mq.barcode not in (select barcode from it_TSD_barcode)
AND mq.UM not in  ('רע','ןכÿר','ןאק','ךד')
ORDER BY ProdName
