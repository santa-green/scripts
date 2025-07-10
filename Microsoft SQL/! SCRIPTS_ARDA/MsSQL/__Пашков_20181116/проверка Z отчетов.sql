--проверка Z отчетов
SELECT g.* , t.SumCC_wt, t.* FROM t_zRep t 
join 
(SELECT z.CRID ,max(z.DocTime) DocTime, MAX(c.CRName) CRName FROM t_zRep z
join r_CRs c on c.CRID = z.CRID
where c.CRID in (201,8,350,301,10,108,106,104,203,102,180)
group by z.CRID
) g on g.CRID = t.CRID and g.DocTime = t.DocTime
order by 2

/*
exec t_ShowCRBalance 201

SELECT * FROM r_CRs

SELECT * FROM [192.168.174.30].ElitRTS201.dbo.t_Sale where OurID = 6 and CRID = 201
and DocDate = '2017-03-24'
and TRealSum <>0
order by 3
*/