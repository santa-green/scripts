
		 --declare @ChID int = 100393139
		 
   --  select * from t_SaleDLV where ChID = @ChID

   --  delete  t_SaleDLV where ChID = @ChID
     
     select * from t_Sale where DocID in (129780,129787,129788,129650) and DocDate > '2016-01-01'
     
     


     select * from t_Sale where chID in (100392300,100393139,100393146,100393147)
     
          select * from t_Saled where chID in (100392300,100393139,100393146,100393147)

     
          select t_SaleD.* from t_Sale 
          join t_SaleD on t_Sale.ChID = t_SaleD.chid
          where DocDate >= '2016-11-01' and t_SaleD.ProdID = 605535
          
          
          select * from t_Saled where ProdID = 605535 and CreateTime >= '2016-11-01'
          order by CreateTime