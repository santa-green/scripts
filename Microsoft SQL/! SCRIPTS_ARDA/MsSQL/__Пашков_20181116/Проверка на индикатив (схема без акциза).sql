SELECT 
      --m.SrcPosID,    
      --m.BarCode,    
      p.ProdID, p.UM, p.UAProdName as ProdName, p.Country,                   
      mp.PriceMC*v.KursCC AS PriceCC, 
      mp.PromoPriceCC AS PromoPriceCC, 

      p.IndRetPriceCC            
      ,mp.PLID
      ,*
      FROM r_Prods p  
      INNER JOIN r_ProdMP mp ON mp.ProdID = p.ProdID --AND mp.PLID in (28,40,83,84,86)         
      INNER JOIN r_ProdMQ mq ON mq.ProdID = p.ProdID AND mq.Um = p.Um 
      INNER JOIN r_Currs v ON v.CurrID=mp.CurrID
      WHERE mp.PromoPriceCC > 0 AND mp.PromoPriceCC < mp.PriceMC 
      AND dbo.zf_GetDate(GETDATE()) BETWEEN (mp.BDate) AND mp.EDate 
      AND mp.InUse = 1  
      --AND p.ProdID = 600077  
      --AND p.ProdID in (600080,600159,602505) 
      AND mp.PromoPriceCC < p.IndRetPriceCC
      --ORDER BY   mp.PLID, p.ProdID
      
 UNION
 
 SELECT 
      --m.SrcPosID,    
      --m.BarCode,    
      p.ProdID, p.UM, p.UAProdName as ProdName, p.Country,                   
      mp.PriceMC*v.KursCC AS PriceCC, 
      mp.PromoPriceCC AS PromoPriceCC, 

      p.IndRetPriceCC            
      ,mp.PLID
      ,*
      FROM r_Prods p  
      INNER JOIN r_ProdMP mp ON mp.ProdID = p.ProdID --AND mp.PLID in (28,40,83,84,86)         
      INNER JOIN r_ProdMQ mq ON mq.ProdID = p.ProdID AND mq.Um = p.Um 
      INNER JOIN r_Currs v ON v.CurrID=mp.CurrID
      WHERE mp.PriceMC > 0 --AND mp.PromoPriceCC < mp.PriceMC 
       AND dbo.zf_GetDate(GETDATE()) BETWEEN (mp.BDate) AND mp.EDate 
       AND mp.InUse = 1  
      --AND p.ProdID = 603303 --603734 
      AND mp.PriceMC*v.KursCC < p.IndRetPriceCC
      ORDER BY   p.ProdID , mp.PLID     
/*
--select * from  iv_PrintPriceList
152.600000000
select plid from r_ProdMP group by plid
					72 48 71
*/