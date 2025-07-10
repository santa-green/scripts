select top 5 c.PCatID , c.PCatName , g.PGrID , g.PGrName,r5.IsExcise ,r.Norma4  ,r.ProdID , prodname , um , p.PriceMC
from r_Prods r join r_ProdMP p on r.ProdID = p.ProdID
join r_ProdC c on r.PCatID = c.PCatID
join r_ProdG g on r.PGrID  = g.PGrID
join at_r_ProdG5 r5 on r.PGrID5 = r5.pgrid5
 where PLID  = 72 and PriceMC != 0 and C.pcatid = 212   and r.Norma4<>0 and  p.PriceMC<>0
 UNION all
 select top 5 c.PCatID , c.PCatName , g.PGrID , g.PGrName,r5.IsExcise ,r.Norma4  , r.ProdID , prodname , um, p.PriceMC 
from r_Prods r join r_ProdMP p on r.ProdID = p.ProdID
join r_ProdC c on r.PCatID = c.PCatID
join r_ProdG g on r.PGrID  = g.PGrID
join at_r_ProdG5 r5 on r.PGrID5 = r5.pgrid5
 where PLID  = 72 and PriceMC != 0 and C.pcatid Not in ( 212,0) and p.PriceMC<>0
 and r5.IsExcise =0
  and r.Norma4<>0
 
 
 select * from r_Prods where ProdID = 801565
 select * from dbo.at_r_ProdG5

 select * from z_tables  where TableDesc like '%סבמנ%'
 
 
 select * from