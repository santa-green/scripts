--обновление столика по товарам Пригласительные билеты
SELECT distinct DeskCode, m.* FROM 		 t_Sale m 
		JOIN t_SaleD i ON i.ChiD = m.ChiD
		JOIN r_Prods p ON p.ProdID = i.ProdID 
		WHERE i.ProdID in (602687,602688,603101,603998,606392,800426,800592,802730)  -- Пригласительные билеты
		AND m.DocDate >= '2017-07-01'
		AND m.OurID = 6 AND m.StockID = 1201
		ORDER BY m.DocDate


BEGIN TRAN

		UPDATE m 
		SET DeskCode = 157 -- Столик: 157 
		FROM t_Sale m 
		JOIN t_SaleD i ON i.ChiD = m.ChiD 
		JOIN r_Prods p ON p.ProdID = i.ProdID 
		WHERE i.ProdID in (602687,602688,603101,603998,606392,800426,800592,802730)  -- Пригласительные билеты
		AND m.DocDate >= '2017-07-01'
		AND m.OurID = 6 AND m.StockID = 1201


SELECT distinct DeskCode, m.* FROM 		 t_Sale m 
		JOIN t_SaleD i ON i.ChiD = m.ChiD
		JOIN r_Prods p ON p.ProdID = i.ProdID 
		WHERE i.ProdID in (602687,602688,603101,603998,606392,800426,800592,802730)  -- Пригласительные билеты
		AND m.DocDate >= '2017-07-01'
		AND m.OurID = 6 AND m.StockID = 1201
		ORDER BY m.DocDate		
		
ROLLBACK TRAN
