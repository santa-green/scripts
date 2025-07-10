SELECT d.DCardID, max(d.SumBonus) DCSumBonus, max(d.Discount) DCDiscount, ISNULL(SUM(l.SumBonus),0) LogSumBonus, dbo.af_GetDiscountFromSumBonus(ISNULL(SUM(l.SumBonus),0)) Скидка 
FROM r_DCards d
left join z_LogDiscRec l on l.DCardID = d.DCardID
where d.InUse = 1 
and d.DCTypeCode = 2 -- Накопичувальна
group by d.DCardID
having max(d.Discount) <> dbo.af_GetDiscountFromSumBonus(ISNULL(SUM(l.SumBonus),0)) --and d.DCardID in ('2220000227513')
order by 1

SELECT d.DCardID, max(d.SumBonus) DCSumBonus, max(d.Discount) DCDiscount, ISNULL(SUM(l.SumBonus),0) LogSumBonus, dbo.af_GetDiscountFromSumBonus(ISNULL(SUM(l.SumBonus),0)) Скидка 
FROM r_DCards d
left join z_LogDiscRec l on l.DCardID = d.DCardID
where d.InUse = 1 
and d.DCTypeCode = 2 -- Накопичувальна
group by d.DCardID
having max(d.SumBonus) <> ISNULL(SUM(l.SumBonus),0) or max(d.Discount) <> dbo.af_GetDiscountFromSumBonus(ISNULL(SUM(l.SumBonus),0)) --and d.DCardID in ('2220000227513')
order by 1

/*
IF OBJECT_ID (N'dbo.fnTemp', N'FN') IS NOT NULL  
    DROP FUNCTION dbo.fnTemp;  
GO  
CREATE FUNCTION dbo.fnTemp(@B NUMERIC(21,9))
RETURNS NUMERIC(21,9)
AS
BEGIN

DECLARE @s numeric(21,9)

SET @s = 
CASE 
WHEN @B <  200   THEN  0
WHEN @B BETWEEN 200 AND 1999.99  THEN  3
WHEN @B BETWEEN 2000 AND 9999.99 THEN  5
WHEN @B BETWEEN 10000 AND 19999.99  THEN  7
WHEN @B >= 20000 THEN 10 END 
 	
RETURN @s
END

go

--SELECT SumBonus,dbo.fnTemp(SumBonus),DCTypeCode FROM r_DCards  where DCTypeCode = 2
--order by 1
go

SELECT d.DCardID, max(d.SumBonus) DCSumBonus, max(d.Discount) DCDiscount, ISNULL(SUM(l.SumBonus),0) LogSumBonus, dbo.fnTemp(ISNULL(SUM(l.SumBonus),0)) Скидка 
FROM r_DCards d
left join z_LogDiscRec l on l.DCardID = d.DCardID
where d.InUse = 1 
and d.DCTypeCode = 2 -- Накопичувальна
group by d.DCardID
having max(d.SumBonus) <> ISNULL(SUM(l.SumBonus),0) or max(d.Discount) <> dbo.fnTemp(ISNULL(SUM(l.SumBonus),0)) --and d.DCardID in ('2220000227513')
order by 1

go

UPDATE r_DCards
set
SumBonus = gr.LogSumBonus,
Discount = gr.Скидка
from (
SELECT d.DCardID, max(d.SumBonus) DCSumBonus, max(d.Discount) DCDiscount, ISNULL(SUM(l.SumBonus),0) LogSumBonus, dbo.fnTemp(ISNULL(SUM(l.SumBonus),0)) Скидка 
FROM r_DCards d
left join z_LogDiscRec l on l.DCardID = d.DCardID
where d.InUse = 1 
and d.DCTypeCode = 2 -- Накопичувальна
group by d.DCardID
having max(d.SumBonus) <> ISNULL(SUM(l.SumBonus),0) or max(d.Discount) <> dbo.fnTemp(ISNULL(SUM(l.SumBonus),0))
) gr 
join r_DCards on r_DCards.DCardID = gr.DCardID
--where gr.DCardID in ('2220000001151')

go
SELECT d.DCardID, max(d.SumBonus) DCSumBonus, max(d.Discount) DCDiscount, ISNULL(SUM(l.SumBonus),0) LogSumBonus, dbo.fnTemp(ISNULL(SUM(l.SumBonus),0)) Скидка 
FROM r_DCards d
left join z_LogDiscRec l on l.DCardID = d.DCardID
where d.InUse = 1 
and d.DCTypeCode = 2 -- Накопичувальна
group by d.DCardID
having max(d.SumBonus) <> ISNULL(SUM(l.SumBonus),0) or max(d.Discount) <> dbo.fnTemp(ISNULL(SUM(l.SumBonus),0)) --and d.DCardID in ('2220000227513')
order by 1
go
DROP FUNCTION dbo.fnTemp

/*
DECLARE @dc varchar(20) = '2220000314114'
SELECT * FROM r_DCards where DCardID = @dc

SELECT * FROM z_LogDiscRec where DCardID = @dc
order by LogDate desc

SELECT * FROM z_LogDiscExp where DCardID = @dc
order by LogDate desc

SELECT * FROM z_DocDC where DCardID = @dc
*/
--SELECT * FROM r_DCards where DCTypeCode = 2 order by 3

*/