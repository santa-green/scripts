 /* EXEC ap_CalcSRec_B_date_E_date '20161223', '20161223', 9, 1202, 11035 */
 
 --#TSale
 SELECT ChID,*  FROM t_Sale WITH(NOLOCK) WHERE DocDate BETWEEN '20161223'  AND '20161223'   AND OurID = 9 AND StockID = 1202 AND StateCode = 22
 ChID
100402179
100402258
100402259
100402260
100402289
100402358
100402359
100402360
100402466
100402087
100402371
100402373
100402401
100402402
100402406
100402417
100402418
100402424
100402425
100402440
100402456

--DECLARE SRec CURSOR LOCAL FOR
     SELECT DISTINCT rss.SubStockID
    FROM t_Sale m WITH(NOLOCK)
    JOIN t_SaleD d WITH(NOLOCK) ON d.ChID = m.ChID
    JOIN r_Stocks rs WITH(NOLOCK) ON rs.StockID = m.StockID
    JOIN r_ProdMP mp WITH(NOLOCK) ON mp.ProdID = d.ProdID AND mp.PLID = d.PLID
    JOIN ir_StockSubs rss WITH(NOLOCK) ON rss.DepID = mp.DepID AND rss.StockID = rs.StockID
    WHERE m.ChID in ( SELECT ChID  FROM t_Sale WITH(NOLOCK) WHERE DocDate BETWEEN '20161223'  AND '20161223'   AND OurID = 9 AND StockID = 1202 AND StateCode = 22)
    ORDER BY rss.SubStockID
SubStockID
1203

-- #TRemD
      SELECT ProdID, PPID, SUM(Qty - AccQty) Qty
      FROM dbo.af_CalcRemD_F('20161223' , 9, 1203, 1, NULL)
      GROUP BY ProdID, PPID
      HAVING ISNULL(SUM(Qty - AccQty),0) >= 0
ProdID,  PPID, Qty
800780	560	 12.000000000
--...

--DECLARE SRecBW CURSOR LOCAL FOR
     SELECT DISTINCT CASE m.CodeID3 WHEN 89 THEN 1  WHEN 19	 THEN 2  WHEN 23 THEN 3 ELSE 0 END IsBlackSale
      FROM t_Sale m WITH(NOLOCK)
      JOIN t_SaleD d WITH(NOLOCK) ON d.ChID = m.ChID
      JOIN r_Stocks rs WITH(NOLOCK) ON rs.StockID = m.StockID
      JOIN r_ProdMP mp WITH(NOLOCK) ON mp.ProdID = d.ProdID AND mp.PLID = d.PLID
      JOIN ir_StockSubs rss WITH(NOLOCK) ON rss.DepID = mp.DepID AND rss.StockID = rs.StockID
      WHERE m.ChID in ( SELECT ChID  FROM t_Sale WITH(NOLOCK) WHERE DocDate BETWEEN '20161223'  AND '20161223'   AND OurID = 9 AND StockID = 1202 AND StateCode = 22) AND rss.SubStockID = 1203
      ORDER BY IsBlackSale
IsBlackSale
0
1

IsBlackSale = 0
        /* Курсор импорта проданных в "Продажа товара оператором" комплектов в "Комплектация товара: Комплекты" */
       -- DECLARE SRecA CURSOR LOCAL FOR
        SELECT ROW_NUMBER() OVER (ORDER BY d.ProdID) SrcPosID, d.ProdID, rp.UM, mq.BarCode, SUM(d.Qty) Qty
        FROM t_Sale m WITH(NOLOCK)
        JOIN t_SaleD d WITH(NOLOCK) ON d.ChID = m.ChID    
        JOIN r_Stocks rs WITH(NOLOCK) ON rs.StockID = m.StockID
        JOIN r_ProdMP mp WITH(NOLOCK) ON mp.ProdID = d.ProdID AND mp.PLID = d.PLID--AND mp.PLID = rs.PLID
        JOIN ir_StockSubs rss WITH(NOLOCK) ON rss.DepID = mp.DepID AND rss.StockID = rs.StockID
        JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID AND rp.InRems = 1
        LEFT JOIN r_ProdMQ mq WITH(NOLOCK) ON mq.ProdID = rp.ProdID AND mq.UM = rp.UM
        WHERE  m.ChID in ( SELECT ChID  FROM t_Sale WITH(NOLOCK) WHERE DocDate BETWEEN '20161223'  AND '20161223'   AND OurID = 9 AND StockID = 1202 AND StateCode = 22) AND rss.SubStockID = 1203 
          AND ((0 = 0 AND m.CodeID3 not in (19,23,89)) OR (0 = 1 AND m.CodeID3 = 89)  OR (0 = 2 AND m.CodeID3 = 19) OR (0 = 3 AND m.CodeID3 = 23))
        GROUP BY d.ProdID, rp.UM, mq.BarCode  
        
SrcPosID	ProdID	UM	BarCode	Qty
1	605143	пляш	5000210014168	3.000000000
2	605424	пляш	605424	1.000000000
3	605425	пляш	605425	1.000000000
4	606759	порц	606759	2.000000000
5	607233	порц	607233	5.000000000
6	607334	порц	607334	16.000000000
7	607425	порц	607425	3.000000000

IsBlackSale = 1
        /* Курсор импорта проданных в "Продажа товара оператором" комплектов в "Комплектация товара: Комплекты" */
       -- DECLARE SRecA CURSOR LOCAL FOR
        SELECT ROW_NUMBER() OVER (ORDER BY d.ProdID) SrcPosID, d.ProdID, rp.UM, mq.BarCode, SUM(d.Qty) Qty
        FROM t_Sale m WITH(NOLOCK)
        JOIN t_SaleD d WITH(NOLOCK) ON d.ChID = m.ChID    
        JOIN r_Stocks rs WITH(NOLOCK) ON rs.StockID = m.StockID
        JOIN r_ProdMP mp WITH(NOLOCK) ON mp.ProdID = d.ProdID AND mp.PLID = d.PLID--AND mp.PLID = rs.PLID
        JOIN ir_StockSubs rss WITH(NOLOCK) ON rss.DepID = mp.DepID AND rss.StockID = rs.StockID
        JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID AND rp.InRems = 1
        LEFT JOIN r_ProdMQ mq WITH(NOLOCK) ON mq.ProdID = rp.ProdID AND mq.UM = rp.UM
        WHERE  m.ChID in ( SELECT ChID  FROM t_Sale WITH(NOLOCK) WHERE DocDate BETWEEN '20161223'  AND '20161223'   AND OurID = 9 AND StockID = 1202 AND StateCode = 22) AND rss.SubStockID = 1203 
          AND ((1 = 0 AND m.CodeID3 not in (19,23,89)) OR (1 = 1 AND m.CodeID3 = 89)  OR (1 = 2 AND m.CodeID3 = 19) OR (1 = 3 AND m.CodeID3 = 23))
        GROUP BY d.ProdID, rp.UM, mq.BarCode  
SrcPosID	ProdID	UM	BarCode	Qty
1	605086	порц	605086	3.000000000
2	605110	порц	605110	2.000000000
3	605113	порц	605113	3.000000000
4	605207	порц	605207	2.000000000
5	606618	порц	606618	1.000000000
6	606967	порц	606967	1.000000000
7	607335	порц	607335	12.000000000
8	607355	порц	607355	10.000000000
9	607356	порц	607356	3.000000000
10	607425	порц	607425	2.000000000
11	800780	пляш	8019153801053	2.000000000

          /* Курсор импорта данных в "Комплектация товара: Комплектующие" на основании составных товаров комплектов */
          --DECLARE SRecD CURSOR FOR
          SELECT ss.ProdID SubProdID, rp.UM SubUM, mq.BarCode SubBarCode, ss.Qty SubQty, *
          FROM t_SRecA a WITH(NOLOCK)
          CROSS APPLY dbo.af_GetSpecSubs(9, 1202, 1203, '20161223', 800780, 2) ss
          JOIN r_Prods rp WITH(NOLOCK) ON rp.ProdID = ss.ProdID
          LEFT JOIN r_ProdMQ mq WITH(NOLOCK) ON mq.ProdID = rp.ProdID AND mq.UM = rp.UM
          WHERE ss.ProdID = a.ProdID --a.AChID = @AChID
          ORDER BY a.SrcPosID, ss.ProdID
          
select * from t_SRecA where chid = 100339892

select * from dbo.af_GetSpecSubs(9, 1202, 1203, '20161223', 800780, 2)

select * from dbo.af_GetSpecSubs(9, 1202, 1203, '20161223', 607425, 2)
