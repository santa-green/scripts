--SELECT p.ProdID as gr_ProdID, Max(p.PPID) as gr_ppid  FROM t_PInP p
--JOIN r_Prods r on p.ProdID = r.ProdID
--join r_Comps c on p.CompID = c.CompID
--where r.PGrID2 = 40014 and c.CompID not in (260,261) 
--group by p.ProdID
--order by 1

--SELECT * FROM r_Comps
----SELECT * FROM t_PInP p
----JOIN r_Prods r on p.ProdID = r.ProdID


--список предприятий
SELECT distinct c.CompName,c.CompID FROM t_PInP p
join r_Comps c on p.CompID = c.CompID
join (SELECT p.ProdID as gr_ProdID, Max(p.PPID) as gr_ppid  FROM t_PInP p
JOIN r_Prods r on p.ProdID = r.ProdID
join r_Comps c on p.CompID = c.CompID
where r.PGrID2 = 40014 and c.CompID not in (0,260,261,108) 
group by p.ProdID
) gr on gr.gr_ProdID = p.ProdID and gr.gr_ppid = p.PPID
order by 1

--последний поставщик алкоголя
SELECT p.ProdID, c.CompName,c.CompID FROM t_PInP p
join r_Comps c on p.CompID = c.CompID
join (SELECT p.ProdID as gr_ProdID, Max(p.PPID) as gr_ppid  FROM t_PInP p
JOIN r_Prods r on p.ProdID = r.ProdID
join r_Comps c on p.CompID = c.CompID
where r.PGrID2 = 40014 and c.CompID not in (0,260,261,108) 
group by p.ProdID
) gr on gr.gr_ProdID = p.ProdID and gr.gr_ppid = p.PPID
order by 1