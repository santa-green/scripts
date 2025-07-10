SELECT * FROM r_Prods where PGrID3 in (8,9,10,12)


BEGIN TRAN


	UPDATE sd
	SET 
	 sd.PPID = id.PPID
	FROM  t_SaleD sd
	JOIN t_Sale s WITH(NOLOCK) ON s.ChID = sd.ChID and s.DeskCode = 233
	JOIN z_DocLinks l WITH(NOLOCK) ON l.ParentDocCode = 666004 AND l.ChildDocCode = 11035 AND l.ChildChID = sd.ChID
	JOIN at_t_IOResD id WITH(NOLOCK) ON id.ChID = l.ParentChID  and sd.ProdID = id.ProdID  and sd.SrcPosID = id.SrcPosID 
	JOIN at_t_IORes i WITH(NOLOCK) ON i.ChID = id.ChID  and i.RemSchID = 1 
	WHERE sd.ChID = 800009521
	

SELECT * 
	FROM  t_SaleD sd
	JOIN t_Sale s WITH(NOLOCK) ON s.ChID = sd.ChID and s.DeskCode = 233
	JOIN z_DocLinks l WITH(NOLOCK) ON l.ParentDocCode = 666004 AND l.ChildDocCode = 11035 AND l.ChildChID = sd.ChID
	JOIN at_t_IOResD id WITH(NOLOCK) ON id.ChID = l.ParentChID  and sd.ProdID = id.ProdID  and id.SrcPosID = sd.SrcPosID
	JOIN at_t_IORes i WITH(NOLOCK) ON i.ChID = id.ChID  and i.RemSchID = 1 
	WHERE sd.ChID = 800009521
	ORDER BY 1,4


ROLLBACK TRAN	
	



SELECT sd.ChID, sd.ProdID, COUNT(sd.PPID) c
	FROM  t_SaleD sd
	JOIN t_Sale s WITH(NOLOCK) ON s.ChID = sd.ChID and s.DeskCode = 233
	JOIN z_DocLinks l WITH(NOLOCK) ON l.ParentDocCode = 666004 AND l.ChildDocCode = 11035 AND l.ChildChID = sd.ChID
	JOIN at_t_IOResD id WITH(NOLOCK) ON id.ChID = l.ParentChID  and sd.ProdID = id.ProdID  
	JOIN at_t_IORes i WITH(NOLOCK) ON i.ChID = id.ChID  and i.RemSchID = 1 
	--WHERE sd.ChID = 100483775
	group  BY sd.ChID, sd.ProdID
	ORDER BY c desc
	
	SELECT * FROM at_t_IOResD
	WHERE ChiD = 5258
	ORDER BY 1
	
		
	SELECT * FROM at_t_IORes
	WHERE ChiD = 5258
	ORDER BY 1