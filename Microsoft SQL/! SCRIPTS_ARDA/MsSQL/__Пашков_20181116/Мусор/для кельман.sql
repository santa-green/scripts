SELECT r.ProdName, r.Article3, r.PGrID1,p.PriceMC_In, p.*  FROM t_PInP p
join r_Prods r on r.ProdID = p.ProdID --and r.PGrID = 16017
where r.PGrID1 in (600,601,602,603,604,605,606,607,608,609,610,611,612,613,614,615,616,617,618,619,620,621,622,623,624,625 )-- and CurrID = 840
ORDER BY ProdID, PPID



SELECT r.ProdName, r.Article3, r.PGrID1,pp.PriceMC_In, pp.*  FROM t_PInP pp
join (
SELECT p.ProdID , Max(p.PriceMC_In) PriceMC_In FROM t_PInP p
join r_Prods r on r.ProdID = p.ProdID --and r.PGrID = 16017
where r.PGrID1 in (600,601,602,603,604,605,606,607,608,609,610,611,612,613,614,615,616,617,618,619,620,621,622,623,624,625) --and CurrID = 840
group  BY p.ProdID) gr on gr.ProdID = pp.ProdID and gr.PriceMC_In = pp.PriceMC_In
join r_Prods r on r.ProdID = pp.ProdID
ORDER BY pp.ProdID