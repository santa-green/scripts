SELECT c.TaxPayer, c.CompID, d.Qty, d.PriceCC_nt, d.SumCC_nt, d.Tax, d.TaxSum, d.PriceCC_wt, d.SumCC_wt, * FROM t_Rec r
join t_RecD d on d.ChID = r.ChID
left join r_Comps c on c.CompID = r.CompID
where
	--OurID in (6)
	--and 
	DocDate > '2017-01-01'
	and (c.TaxPayer = 1 and d.Tax = 0)
	--or (d.Qty = 0  or d.SumCC_nt = 0 or d.PriceCC_nt = 0 )
ORDER BY DocDate

SELECT c.TaxPayer, c.CompID, d.Qty, d.PriceCC_nt, d.SumCC_nt, d.Tax, d.TaxSum, d.PriceCC_wt, d.SumCC_wt, * FROM t_Rec r
join t_RecD d on d.ChID = r.ChID
left join r_Comps c on c.CompID = r.CompID
where
	OurID in (6)
	and DocDate > '2017-01-01'
	--and (c.TaxPayer = 0 and d.PriceCC_nt = 0)
	and (d.Qty = 0  or d.SumCC_nt = 0 or d.PriceCC_nt = 0 )
ORDER BY DocDate

/*
begin tran

DECLARE @chid int = 6409
DECLARE @ChIDTable table(ChID int NULL) 
insert into @ChIDTable 
	SELECT r.ChID FROM t_Rec r
	join t_RecD d on d.ChID = r.ChID
	left join r_Comps c on c.CompID = r.CompID
	where
	OurID in (6)
	and DocDate > '2017-01-01'
	and (c.TaxPayer = 1 and d.Tax = 0)

SELECT * FROM  t_Rec where ChID in ( SELECT * FROM @ChIDTable)

--SELECT * FROM  t_Rec where ChID = @chid
--SELECT * FROM  t_RecD where ChID = @chid

update d
set 
	PriceCC_nt = d.PriceCC_wt * 5/6, 
	SumCC_nt = d.PriceCC_wt * 5/6 * d.Qty, 
	Tax = d.PriceCC_wt /6, 
	TaxSum = d.PriceCC_wt /6 * d.Qty
FROM t_Rec r
join t_RecD d on d.ChID = r.ChID
left join r_Comps c on c.CompID = r.CompID
where
	OurID in (6)
	and DocDate > '2017-01-01'
	and (c.TaxPayer = 1 and d.Tax = 0)
and d.ChID in ( SELECT * FROM @ChIDTable)

--SELECT * FROM  t_Rec where ChID = @chid
--SELECT * FROM  t_RecD where ChID = @chid

SELECT * FROM  t_Rec where ChID in ( SELECT * FROM @ChIDTable)

rollback tran


*/


SELECT distinct r.ChID,r.DocID, r.DocDate, r.StockID, r.OurID, r.CompID FROM t_Rec r
join t_RecD d on d.ChID = r.ChID
left join r_Comps c on c.CompID = r.CompID
where OurID in (6)
and 
c.TaxPayer = 1 and d.Tax = 0 
and DocDate > '2017-01-01'
ORDER BY DocDate

SELECT top 1  * FROM t_RecD

--SELECT * FROM r_Comps where CompID = 81

--SELECT * FROM t_Sale where StockID = 1241 ORDER BY DocDate

SELECT c.TaxPayer, c.CompID,d.PriceCC_nt, d.Tax, d.PriceCC_wt, d.Qty, * FROM t_Rec r
join t_RecD d on d.ChID = r.ChID
left join r_Comps c on c.CompID = r.CompID
where OurID = 6
and d.Qty = 0 
ORDER BY DocDate

SELECT c.TaxPayer, c.CompID,d.PriceCC_nt, d.Tax, d.PriceCC_wt, d.Qty, * FROM t_Rec r
join t_RecD d on d.ChID = r.ChID
left join r_Comps c on c.CompID = r.CompID
where --OurID = 6
--and 
c.TaxPayer = 0 and d.Tax != 0 
ORDER BY DocDate