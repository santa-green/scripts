SELECT * FROM r_DCards order by  DCardID

SELECT * FROM z_LogDiscRec where DCardID = '2220000196949' 

SELECT * FROM z_LogDiscExp where DCardID = '2220000196949' 

SELECT * FROM z_LogDiscRec where DCardID = '2220000186353' 

SELECT * FROM z_LogDiscExp where DCardID = '2220000186353' 

SELECT * FROM r_DCards where DCardID = '2220000186353' 



SELECT DCardID, SUM(SumBonus) FROM z_LogDiscRec where DCardID = '2220000196949' and DiscCode = 48

SELECT DCardID, SUM(SumBonus) SumBonus FROM z_LogDiscRec
group by DCardID
order by 1


SELECT dc.Discount, dc.DCardID, ldr.SumBonus, dc.SumBonus SumBonusDC, ldr.SumBonus- dc.SumBonus ,* FROM r_DCards dc
join 
(SELECT DCardID, SUM(SumBonus) SumBonus FROM z_LogDiscRec
group by DCardID) ldr on ldr.DCardID = dc.DCardID
where ldr.SumBonus != dc.SumBonus  
and dc.DCTypeCode = 2 --накопительная
--and dc.DCardID = '2220000196949'
order by 3


SELECT * FROM z_Tables order by TableDesc


SELECT * FROM r_Uni

SELECT * FROM r_UniTypes