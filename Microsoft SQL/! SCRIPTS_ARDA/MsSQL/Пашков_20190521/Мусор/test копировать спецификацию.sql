SELECT * FROM it_CancPrice where ChID = 6417
SELECT * FROM it_CancPriceD where ChID = 6417 ORDER BY SrcPosID

BEGIN TRAN


--DECLARE @ChID int = 6417
--,@Stocks varchar(200) = '1201,1252,1260'

--SELECT * FROM it_CancPrice WHERE ChID =6417

	EXEC [dbo].[ap_Copy_it_CancPrice]  @ChID = 6417, @Stocks = '1201,1252,1260'  
	  	  
	  SELECT * FROM it_CancPrice where ChID >= 6498
	  SELECT * FROM it_CancPriceD where ChID >= 6498 ORDER BY 1, SrcPosID
ROLLBACK TRAN


[ap_Copy_t_SEst]
