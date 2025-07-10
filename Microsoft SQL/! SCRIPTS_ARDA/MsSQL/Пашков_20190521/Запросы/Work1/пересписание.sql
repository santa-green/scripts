USE OTData
SELECT p.ProdID AS 'Код', LEFT (t.ProdDate,11) AS 'Дата прихода', r.ProdName AS 'Наименование', p.QTy AS 'Количество', t.PPID AS 'КЦП', p.StockID AS 'Склад'
FROM t_Rem p
INNER JOIN r_Prods r ON p.ProdID=r.ProdID
INNER JOIN t_PinP t ON p.ProdID=t.ProdID
WHERE p.QTy<0 AND p.ProdID IN
(SELECT t.ProdID FROM t_Rem t WHERE t.QTy>0)
AND p.PPID=t.PPID
GROUP BY r.ProdName , p.ProdID ,t.PPID ,p.QTy, t.ProdDate, p.StockID
ORDER BY t.ProdDate, p.StockID