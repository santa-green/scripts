-- поиск причины отрицательных остатков на складе 1200

SELECT * FROM t_Rem WITH (NOLOCK) WHERE OurID = 6 and StockID = 1200 and Qty < 0
--6	1200	1	602894	100154	-12.000000000	0.000000000

SELECT * FROM t_RecD where ProdID = 602894 ORDER BY  PPID desc
SELECT * FROM t_PInP where ProdID = 602894 ORDER BY  PPID desc

SELECT * FROM t_Rec
WHERE ChiD = 13639
ORDER BY 1

SELECT * FROM t_Recd
WHERE ChiD = 13639 and ProdID = 602894
ORDER BY 1