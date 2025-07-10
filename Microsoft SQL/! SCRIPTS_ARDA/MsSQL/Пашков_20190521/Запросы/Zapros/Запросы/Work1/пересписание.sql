USE OTData
SELECT p.ProdID AS '���', LEFT (t.ProdDate,11) AS '���� �������', r.ProdName AS '������������', p.QTy AS '����������', t.PPID AS '���', p.StockID AS '�����'
FROM t_Rem p
INNER JOIN r_Prods r ON p.ProdID=r.ProdID
INNER JOIN t_PinP t ON p.ProdID=t.ProdID
WHERE p.QTy<0 AND p.ProdID IN
(SELECT t.ProdID FROM t_Rem t WHERE t.QTy>0)
AND p.PPID=t.PPID
GROUP BY r.ProdName , p.ProdID ,t.PPID ,p.QTy, t.ProdDate, p.StockID
ORDER BY t.ProdDate, p.StockID