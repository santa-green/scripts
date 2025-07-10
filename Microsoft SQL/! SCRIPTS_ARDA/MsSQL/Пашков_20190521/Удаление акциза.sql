
		 declare @ChID int = 100391740, @SrcPosID int = 1
		 
     select * from t_SaleDLV where ChID = @ChID and SrcPosID = @SrcPosID

     delete  t_SaleDLV where ChID = @ChID and SrcPosID = @SrcPosID
     
     
     --t_saled