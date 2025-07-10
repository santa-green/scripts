

DECLARE 
	@NDate smalldatetime,
  @BDate smalldatetime = '2016-12-31', 
  @EDate smalldatetime = '2016-12-31'
  
CREATE TABLE #RemDD
(
 	OurID tinyint, 
 	StockID int, 
	SecID int, 
	ProdID int, 
	PPID int, 
	Qty numeric(21, 9),
	AccQty numeric(21, 9), 
	DocDate smalldatetime
)
CREATE TABLE #InRem
(
	 OurID tinyint, 
	 StockID int, 
	 SecID int, 
	 ProdID int, 
	 PPID int, 
	 Qty numeric(21, 9), 
	 AccQty numeric(21, 9),
)
	 	
INSERT INTO #RemDD
SELECT OurID, StockID, SecID, ProdID, PPID, Qty, AccQty, @BDate
FROM dbo.zf_t_CalcRemByDateDate(NULL, @BDate)
WHERE (Qty <> 0 OR AccQty <> 0)
and OurID = 12 and StockID = 1207
	
INSERT INTO #InRem
SELECT OurID, StockID, SecID, ProdID, PPID, Qty, AccQty
FROM dbo.zf_t_CalcRemByDateDate ('2079-01-01', '1900-01-01')
WHERE Qty <> 0 OR AccQty <> 0

select * from #RemDD
select * from #InRem

  /* Удаление временных таблиц */
  DROP TABLE #RemDD
  DROP TABLE #InRem


SELECT OurID, StockID, SecID, ProdID, PPID, Qty, AccQty, '2016-12-31'
FROM dbo.zf_t_CalcRemByDateDate(NULL, '2016-12-31')
WHERE Qty <> 0 OR AccQty <> 0
and OurID = 12 and StockID = 1207




select ProdID from #RemDD WHERE (Qty <> 0 OR AccQty <> 0) and OurID = 12 and StockID = 1207 and Qty < 0 GROUP BY ProdID


select * from #RemDD WHERE ProdID in (select ProdID from #RemDD WHERE (Qty <> 0 OR AccQty <> 0) and OurID = 12 and StockID = 1207 and Qty < 0 GROUP BY ProdID) and OurID = 12 and StockID = 1207
order by ProdID, PPID