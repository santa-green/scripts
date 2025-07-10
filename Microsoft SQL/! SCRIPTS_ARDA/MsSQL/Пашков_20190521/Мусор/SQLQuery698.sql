     SELECT
     m.BarCode, 
     m.ProdID, p.UAProdName ProdName, p.Country,
     CAST(FLOOR(m.PriceMC) as numeric(21,0)) AS PriceMoney,             
     REVERSE(LEFT(REVERSE(CAST((m.PriceMC) AS NUMERIC(21,2))),2)) AS PricePenny 
     FROM iv_PrintPriceList  m WITH(NOLOCK)         
     JOIN r_Prods p WITH(NOLOCK) ON  p.ProdID = m.ProdID 
     WHERE  m.PLID = 70  
     ORDER BY m.SrcPosID
     
     SELECT ProdID, PriceMC FROM r_ProdMP where PLID = 85
     except
     SELECT ProdID, PriceMC FROM r_ProdMP where PLID = 72
     
     SELECT * FROM r_ProdMP where ProdID= 802739