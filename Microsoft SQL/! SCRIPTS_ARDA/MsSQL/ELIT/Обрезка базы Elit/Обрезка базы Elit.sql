--Îáðåçêà áàçû Elit


--ÄÓÁËÈ ÅÑËÈ ÎÑÒÀÂÈÒÜ 7 ÑÈÌÂÎËÎÂ ÄËß ÊÎÄÎÂ Ó ÊÎÒÎÐÛÕ 8 ÑÈÌÂÎËÎÂ
SELECT Code7,count(*) FROM (
	SELECT Code,left(Code,7) Code7 FROM r_comps where len(Code) = 8 
	and chid in (SELECT max(chid) chid FROM r_comps where len(Code) = 8 group by Code)
) gr1 group by Code7
having count(*) > 1


SELECT Code,* FROM r_comps where len(Code) = 8 
and left(Code,7) in (SELECT Code7 FROM (
	SELECT Code,left(Code,7) Code7 FROM r_comps where len(Code) = 8 
	and chid in (SELECT max(chid) chid FROM r_comps where len(Code) = 8 group by Code)
) gr1 group by Code7
having count(*) > 1)
ORDER BY 1

SELECT Code,max(chid) chid FROM r_comps 
where len(Code) = 8 
group by Code
ORDER BY 1

SELECT max(chid) chid FROM r_comps 
where len(Code) = 8 
group by Code
