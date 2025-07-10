

select * from [s-sql-d4].elitr.dbo.r_Prods 
	where ProdID not in (select ProdID from t_PInP where ppid = 0)
	
	--insert t_PInP
	select * from [s-sql-d4].elitr.dbo.t_PInP where ppid = 0 and ProdID = 604552
	
	select * from test_t_PInP_deleted
	
		--delete t_PInP where ppid = 0 and ProdID = 604552
		
		SELECT * FROM test_t_PInP_inserted i, test_t_PInP_deleted d WHERE i.PPID = 0 OR d.PPID = 0
		
				SELECT * FROM test_t_PInP_deleted d WHERE i.PPID = 0 OR d.PPID = 0
				
				
	select * from t_PInP where ProdID = 611561
	
		select * from t_PInP where ppid <> 0 and PriceMC_In =0 