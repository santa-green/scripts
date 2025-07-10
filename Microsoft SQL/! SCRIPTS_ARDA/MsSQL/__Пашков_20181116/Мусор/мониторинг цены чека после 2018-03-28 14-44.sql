--мониторинг цены чека после 2018-03-28 14:44

SELECT top 1000 TRealSum, LEFT(RIGHT (cast(TRealSum as varchar),8),1) kop,* FROM t_Sale
where DocTime > '2018-04-29 09:00:00.000'
and LEFT(RIGHT (cast(round(TRealSum,2) as varchar),8),1) <> '0'  
ORDER BY DocTime desc


/*
SELECT * FROM t_SaleD where ChID = 70330112
SELECT * FROM r_Prods where ProdID in (603840,603850)


--select RIGHT('264.900000000',9)

SELECT LEFT(RIGHT (cast(PriceMC as varchar),8),1) kop, * FROM r_ProdMP
 where PriceMC > 0 
 and LEFT(RIGHT (cast(PriceMC as varchar),8),1) <> '0'
 and InUse = 1
 
 
 SELECT top 1000 TRealSum, LEFT(RIGHT (cast(TRealSum as varchar),8),1) kop,* FROM t_Sale
--where LEFT(RIGHT (cast(TRealSum as varchar),8),1) <> '0'
ORDER BY DocDate desc


  SELECT 
  --LEFT(RIGHT (cast(PriceMC as varchar),8),1) kop, 
  --(SELECT top 1 BarCode FROM r_ProdMQ mq where mq.ProdID = mp.ProdID and Qty = 1 ),
  ProdID, PLID, PriceMC, 
  dbo.zf_Round(PriceMC, CAST(dbo.zf_Var('z_RoundPriceSale') AS numeric(19,9))) PriceMC_okrug,
  Notes, CurrID, DepID, InUse, 
  PromoPriceCC, 
  dbo.zf_Round(PromoPriceCC, CAST(dbo.zf_Var('z_RoundPriceSale') AS numeric(19,9))) PromoPriceCC_okrug,
  BDate, EDate, StockID 
  FROM dbo.r_ProdMP mp
  WHERE PLID IN (34)  
  --and ProdID in (802792)
  --WHERE PLID IN (70,83,84,85,86) 
and PriceMC > 0 
--and PriceMC < 0.1 
 and ( LEFT(RIGHT (cast(PriceMC as varchar),8),1) <> '0' or LEFT(RIGHT (cast(PromoPriceCC as varchar),8),1) <> '0' )
 and InUse = 1
 and  ( SELECT SUM(Qty) FROM t_Rem r where r.ProdID = mp.ProdID) > 1 
 ORDER BY 2,1
 
 --1705
 --22208
 
 
 SELECT d.* FROM t_Sale m
 JOIN t_SaleD d ON d.ChID = m.ChID
 JOIN r_Prods p ON p.ProdID = d.ProdID
 WHERE DocTime > '2018-04-11 09:00:00.000'
--and LEFT(RIGHT (cast(TRealSum as varchar),8),1) <> '0'  
ORDER BY DocTime desc


 SELECT d.Qty,p.ProdName, * FROM t_Sale m
 JOIN t_SaleD d ON d.ChID = m.ChID
 JOIN r_Prods p ON p.ProdID = d.ProdID
 WHERE d.Qty % 1 <> 0
 and StockID = 1001 and OurID = 12
ORDER BY m.DocTime desc

select 20.00 % 0.1


*/