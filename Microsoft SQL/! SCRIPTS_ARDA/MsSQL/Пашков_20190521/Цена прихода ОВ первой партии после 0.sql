SELECT p.ProdID, p.PPID, PriceMC_In, (SELECT ProdName FROM r_Prods where ProdID = p.ProdID) UAProdName FROM t_PInP p
join (
SELECT ProdID, min(PPID) PPID FROM t_PInP
where  PPID <> 0
group by ProdID
) gr 
on gr.PPID = p.PPID and gr.ProdID = p.ProdID

--where p.ProdID in
--(
--600114,600091
--)

ORDER BY 1