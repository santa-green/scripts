     SELECT
     m.BarCode, 
     m.ProdID, p.UAProdName ProdName, p.Country,
     CAST(FLOOR(m.PriceMC) as numeric(21,0)) AS PriceMoney,             
     REVERSE(LEFT(REVERSE(CAST((m.PriceMC) AS NUMERIC(21,2))),2)) AS PricePenny 
     FROM iv_PrintPriceList  m WITH(NOLOCK)         
     JOIN r_Prods p WITH(NOLOCK) ON  p.ProdID = m.ProdID 
     WHERE  m.PLID = 72   
     ORDER BY m.SrcPosID