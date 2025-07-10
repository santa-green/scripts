SELECT StateCode, * FROM t_Sale s
join t_SaleD d on d.ChID = s.ChID
where s.DocDate = '2017-05-04' 
and StockID = 1315
and OurID = 6
and d.ProdID = 605075

--SELECT * FROM r_Prods  where ProdID = 605075

SELECT ChID,* FROM t_Sale WITH(NOLOCK) WHERE DocDate BETWEEN '20170504'  AND '20170504'   AND OurID = 6 AND StockID = 1315 AND StateCode = 22 ORDER BY 1

    SELECT DISTINCT rss.SubStockID
    FROM t_Sale m WITH(NOLOCK)
    JOIN t_SaleD d WITH(NOLOCK) ON d.ChID = m.ChID
    JOIN r_Stocks rs WITH(NOLOCK) ON rs.StockID = m.StockID
    JOIN r_ProdMP mp WITH(NOLOCK) ON mp.ProdID = d.ProdID AND mp.PLID = d.PLID
    JOIN ir_StockSubs rss WITH(NOLOCK) ON rss.DepID = mp.DepID AND rss.StockID = rs.StockID
    WHERE  m.ChID in (100436462,100436463)
    ORDER BY rss.SubStockID
 
 IF  EXISTS(SELECT * FROM tempdb.dbo.sysobjects WHERE id = OBJECT_ID('tempdb..#TRemD') and xtype in (N'U')) DROP TABLE #TRemD
 
    CREATE TABLE #TRemD (
    ProdID INT,
    PPID INT,
    Qty NUMERIC (21, 9))      
         
      INSERT #TRemD
      (ProdID, PPID, Qty)
      SELECT ProdID, PPID, SUM(Qty - AccQty) Qty
      FROM dbo.af_CalcRemD_F('20170504'  , 6, 1327, 1, NULL)
      GROUP BY ProdID, PPID
      HAVING ISNULL(SUM(Qty - AccQty),0) >= 0
      
SELECT * FROM #TRemD where ProdID in (605075,605086,605111,605137,605510,605511,605382,605382,607490,607491,607492,607493,607495,607496,607497,605569,607477,607478,607479,603026,605505)


SELECT * FROM t_Rem where StockID = 1327 and OurID = 6 and ProdID in (605075,605086,605111,605137,605510,605511,605382,605382,607490,607491,607492,607493,607495,607496,607497,605569,607477,607478,607479,603026,605505)

and ProdID = 605075

begin tran

exec [ap_CalcSRec_B_date_E_date] '20170504','20170504', 6, 1315, 11035 

SELECT * FROM t_SRec where DocDate = '20170504' and OurID = 6 and  StockID = 1315
SELECT * FROM  t_SRecA where ChID in (SELECT ChID FROM t_SRec where DocDate = '20170504' and OurID = 6 and  StockID = 1315)
SELECT * FROM  t_SRecD where AChID in (SELECT AChID FROM  t_SRecA where ChID in (SELECT ChID FROM t_SRec where DocDate = '20170504' and OurID = 6 and  StockID = 1315))

rollback tran


SELECT * FROM t_SRec where DocDate = '20170504' and OurID = 6 and  StockID = 1315
SELECT * FROM  t_SRecA where ChID in (3815)
SELECT * FROM  t_SRecD where AChID in (52890,52891)