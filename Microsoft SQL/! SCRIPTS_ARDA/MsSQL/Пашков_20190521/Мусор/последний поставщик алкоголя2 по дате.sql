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
join (SELECT p.ProdID as gr_ProdID, Max(p.ProdDate) as gr_ppid  FROM t_PInP p
JOIN r_Prods r on p.ProdID = r.ProdID
join r_Comps c on p.CompID = c.CompID
where r.PGrID2 = 40014 and c.CompID not in (0,260,261,108) 
group by p.ProdID
) gr on gr.gr_ProdID = p.ProdID and gr.gr_ppid = p.PPID
order by 1

SELECT * FROM t_PInP where ProdID = 600012
order by ProdDate


SELECT  p.ProdID, max(p.PPID) FROM t_PInP p
join r_Comps c on p.CompID = c.CompID
JOIN r_Prods r on p.ProdID = r.ProdID
join (
SELECT p.ProdID as gr_ProdID, Max(p.ProdDate) as gr_ProdDate FROM t_PInP p
JOIN r_Prods r on p.ProdID = r.ProdID
join r_Comps c on p.CompID = c.CompID
where r.PGrID2 = 40014 and c.CompID not in (0,260,261,108,82,10801,10793,10790,10796) 
group by p.ProdID
) gr on gr.gr_ProdID = p.ProdID and gr.gr_ProdDate= p.ProdDate
where c.CompID not in (0,260,261,108,82,10801,10793,10790,10796) and p.ProdID = 600012
group by p.ProdID


--последний поставщик алкоголя по дате
SELECT  p.ProdID, r.ProdName, c.CompID, c.CompName FROM t_PInP p
join r_Comps c on p.CompID = c.CompID
JOIN r_Prods r on p.ProdID = r.ProdID
join (
	SELECT  p.ProdID as gr2_ProdID, max(p.PPID)as gr2_PPID FROM t_PInP p
	join r_Comps c on p.CompID = c.CompID
	JOIN r_Prods r on p.ProdID = r.ProdID
	join (
		SELECT p.ProdID as gr_ProdID, Max(p.ProdDate) as gr_ProdDate FROM t_PInP p
		JOIN r_Prods r on p.ProdID = r.ProdID
		join r_Comps c on p.CompID = c.CompID
		where r.PGrID2 = 40014 and c.CompID not in (0,260,261,108,82,10801,10793,10790,10796) 
		group by p.ProdID
	) as gr on gr.gr_ProdID = p.ProdID and gr.gr_ProdDate= p.ProdDate
	where c.CompID not in (0,260,261,108,82,10801,10793,10790,10796) --and p.ProdID = 600012
	group by p.ProdID
) as gr2 on gr2.gr2_ProdID = p.ProdID and gr2.gr2_PPID = p.PPID
order by 1
