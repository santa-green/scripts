select * from dbo.af_GetSpecSubs(9, 1202, 1203, '20161223', 800780, 2)

	SELECT TOP 1  ChID, *
	FROM it_Spec WITH(NOLOCK)
	WHERE StockID = 1202 AND DocDate <= '20161223' AND ProdID = 800780
	ORDER BY DocDate DESC, DocID DESC
ChID	ChID	DocID	IntDocID	DocDate	OurID	EmpID	Notes	StateCode	ProdID	UM	OutQty	OutUM	StockID
9898	9898	9893	9893	2015-05-20 00:00:00	9	10393	NULL	0	800780	пл€ш	0.750000000	л	1202


     SELECT SUM(Qty - AccQty) FROM dbo.af_CalcRemD_F('20161223' ,9,1203,1,800780) 
     
     /*dbo.zf_t_CalcRemByDateDate(NULL, @DocDate)*/
                            /*WHERE OurID = @OurID AND StockID = @SubStockID AND ProdID = @ProdID*/
                            /*HAVING ISNULL(SUM(Qty - AccQty),0) > 0*/
@RemQty= 12

	  /* –аскрутка на составл€ющие по  алькул€ционной карте */
	 	--DECLARE SRecD CURSOR LOCAL FAST_FORWARD FOR 
	 	SELECT ProdID, 12 * SUM(Qty) Qty, UseSubItems
		FROM it_SpecD d WITH(NOLOCK)
		WHERE ChID = 9898
		GROUP BY ProdID, UseSubItems 
ProdID	Qty	UseSubItems
611559	9.000000	0
