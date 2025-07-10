--�������� ��� �� ������
BEGIN TRAN

SELECT * FROM t_Sale m
JOIN t_SaleD d ON d.ChID = m.ChID
JOIN r_Prods p ON p.ProdID = d.ProdID
left JOIN t_SalePays sp ON sp.ChID = m.ChID
left JOIN t_MonRec mr ON mr.DocID = m.DocID and mr.OurID = m.OurID
WHERE m.DocID = 178166  
ORDER BY 1

DECLARE @chid int = 100625897

SELECT * FROM t_Sale WHERE ChiD = @chid
update t_Sale set CodeID3 = 27 WHERE ChiD = @chid
SELECT * FROM t_Sale WHERE ChiD = @chid

SELECT * FROM t_SalePays WHERE ChiD = @chid
update t_SalePays set PayFormCode = 2 WHERE ChiD = @chid
SELECT * FROM t_SalePays WHERE ChiD = @chid

SELECT * FROM t_MonRec WHERE DocID = (SELECT DocID FROM t_Sale WHERE ChiD = @chid) and OurID = (SELECT OurID FROM t_Sale WHERE ChiD = @chid)
update t_MonRec set CodeID3 = 27 WHERE DocID = (SELECT DocID FROM t_Sale WHERE ChiD = @chid) and OurID = (SELECT OurID FROM t_Sale WHERE ChiD = @chid)
SELECT * FROM t_MonRec WHERE DocID = (SELECT DocID FROM t_Sale WHERE ChiD = @chid) and OurID = (SELECT OurID FROM t_Sale WHERE ChiD = @chid)


ROLLBACK TRAN



/*
���.1315
14.07.18 ������� � 172727,172728 �������� �� ��.3 - 89
���.1314
25.07.18 ������� �489334 �������� �� ��.3 � 89
07.08.18 ������� � 491511 �������� �� ��.3 � 89

176376--,176452
*/

--�������� ������ �� ���
BEGIN TRAN

SELECT * FROM t_Sale m
JOIN t_SaleD d ON d.ChID = m.ChID
JOIN r_Prods p ON p.ProdID = d.ProdID
left JOIN t_SalePays sp ON sp.ChID = m.ChID
left JOIN t_MonRec mr ON mr.DocID = m.DocID and mr.OurID = m.OurID
WHERE m.DocID = 167763 --176376--,176452 
ORDER BY 1

DECLARE @chid int = 100593624

SELECT * FROM t_Sale WHERE ChiD = @chid
update t_Sale set CodeID3 = 89 WHERE ChiD = @chid
SELECT * FROM t_Sale WHERE ChiD = @chid

--SELECT * FROM t_Sale WHERE ChiD = @chid
--update t_Sale set CRID = 109 WHERE ChiD = @chid
--SELECT * FROM t_Sale WHERE ChiD = @chid

SELECT * FROM t_SalePays WHERE ChiD = @chid
update t_SalePays set PayFormCode = 1 WHERE ChiD = @chid
SELECT * FROM t_SalePays WHERE ChiD = @chid

--SELECT * FROM t_MonRec WHERE DocID = 812324
--update t_MonRec set CodeID3 = 89 WHERE DocID = 812324
--SELECT * FROM t_MonRec WHERE DocID = 812324

ROLLBACK TRAN
