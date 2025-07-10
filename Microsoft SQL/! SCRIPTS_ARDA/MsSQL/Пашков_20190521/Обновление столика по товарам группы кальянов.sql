--обновление столика по товарам группы кальянов 
SELECT distinct DeskCode, m.* FROM 		 t_Sale m 
		JOIN t_SaleD i ON i.ChiD = m.ChiD
		JOIN r_Prods p ON p.ProdID = i.ProdID 
		WHERE p.PGrID5 = 104 and  m.DocDate >= '2017-07-01'
		ORDER BY m.DocTime desc


BEGIN TRAN

		UPDATE m 
		SET DeskCode = 265 -- Кальяны "Бар А Він" закрытие в/в счетов 
		FROM t_Sale m 
		JOIN t_SaleD i ON i.ChiD = m.ChiD
		JOIN r_Prods p ON p.ProdID = i.ProdID 
		WHERE p.PGrID5 = 104 and  m.DocDate >= '2017-07-01'
		
ROLLBACK TRAN
