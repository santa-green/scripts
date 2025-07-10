USE Elit

--проверка на разные цены в РН для одного товара
SELECT gr.ChID,	gr.ProdID, gr.ProdName, gr.UM, count(gr.PriceCC_nt) FROM (
	SELECT m.ChID,
	d.ProdID, rp.ProdName, rp.UM, d.PriceCC_nt,
	sum(d.Qty) sumQty, 
	sum(d.PriceCC_nt) sumPriceCC_nt,  
	sum(d.Qty * d.PriceCC_nt) as SumCC_nt, 
	sum(d.Tax) sumTax
	,count(d.PriceCC_nt) countPriceCC_nt
	FROM dbo.t_Inv m WITH(NOLOCK)
	JOIN dbo.t_InvD d WITH(NOLOCK) ON m.ChID=d.ChID
	JOIN dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID
	--WHERE m.ChID = 200090583
	GROUP BY m.ChID, d.ProdID, rp.ProdName, rp.UM,d.PriceCC_nt
	having count(d.PriceCC_nt) > 1

)gr
GROUP BY gr.ChID,	gr.ProdID, gr.ProdName, gr.UM
having count(gr.PriceCC_nt) > 1