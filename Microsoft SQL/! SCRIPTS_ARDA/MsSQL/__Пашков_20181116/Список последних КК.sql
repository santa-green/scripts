--Список последних КК

SELECT m.*, p.ProdName, p.UAProdName, sp.LayQty FROM it_Spec m
join (	SELECT ProdID, OurID, StockID,  max(DocDate) maxDocDate
	FROM it_Spec WITH (NOLOCK)
	group by ProdID, OurID, StockID
	) gr on gr.OurID = m.OurID and gr.ProdID = m.ProdID and gr.StockID = m.StockID and gr.maxDocDate = m.DocDate
join r_Prods p on p.ProdID = m.ProdID
join it_SpecParams sp on sp.ChID = m.ChID
where  --p.ProdName like '%п/ф%'
--and sp.LayQty != 1
--and m.OutQty != 1
--and  m.OutQty <> sp.LayQty
m.ProdID in (605403,607562,607410,607411,607409,607413,607414,607563,607415,607416,607417,607418,607412)
and  m.OurID = 12
and m.StockID = 1315 --in (1202,1314,1315)
ORDER BY m.ProdID, m.OurID, m.StockID,  m.DocDate

/*
SELECT m.*, sp.* FROM it_Spec m
join (	SELECT ProdID, OurID, StockID,  max(DocDate) maxDocDate
	FROM it_Spec WITH (NOLOCK)
	group by ProdID, OurID, StockID
	) gr on gr.OurID = m.OurID and gr.ProdID = m.ProdID and gr.StockID = m.StockID and gr.maxDocDate = m.DocDate
join it_SpecParams sp on sp.ChID = m.ChID
where m.OutQty <> sp.LayQty
ORDER BY m.DocDate desc
*/

--	SELECT ProdID, OurID, StockID,  max(DocDate)
--	FROM it_Spec WITH (NOLOCK)
--	group by ProdID, OurID, StockID
--	--having ProdID = 605656 and OurID = 9	and StockID =  1202
--	ORDER BY 4 desc
	
--SELECT * FROM it_Spec
--WHERE ProdID = 605656 and OurID = 9	and StockID =  1202	
--ORDER BY DocDate desc




--SELECT m.ProdID , count (m.ProdID) FROM it_Spec m
--join (	SELECT ProdID, OurID, StockID,  max(DocDate) maxDocDate
--	FROM it_Spec WITH (NOLOCK)
--	group by ProdID, OurID, StockID
--	) gr on gr.OurID = m.OurID and gr.ProdID = m.ProdID and gr.StockID = m.StockID and gr.maxDocDate = m.DocDate
--group by m.ProdID	