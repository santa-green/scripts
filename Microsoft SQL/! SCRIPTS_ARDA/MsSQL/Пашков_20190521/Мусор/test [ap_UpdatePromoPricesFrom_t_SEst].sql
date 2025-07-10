BEGIN TRAN

DECLARE @Date SMALLDATETIME = '2017-07-13'
	,@ChID int 

SELECT * FROM t_SEstD d WITH(NOLOCK) 
JOIN t_SEst m WITH(NOLOCK) ON m.ChID = d.ChID
where m.DocDate = @Date

EXEC z_NewChID 'r_ProdMPCh', @ChID OUTPUT

SELECT * FROM r_ProdMPCh where chid >= @ChID and ChDate = dbo.zf_GetDate(GETDATE())

--SELECT * FROM r_ProdMP where ProdID in (803083,600001 )and PLID = 70


setuser 'CORP\Cluster'
select SUSER_NAME()

EXEC [dbo].[ap_UpdatePromoPricesFrom_t_SEst] @Date

--SELECT * FROM t_SEstD d WITH(NOLOCK) 
--JOIN t_SEst m WITH(NOLOCK) ON m.ChID = d.ChID
--where m.DocDate = @Date

--SELECT * FROM r_ProdMPCh where ChDate = dbo.zf_GetDate(GETDATE()) ORDER BY ChTime desc

SELECT * FROM r_ProdMPCh where chid >= @ChID and ChDate = dbo.zf_GetDate(GETDATE())

--SELECT * FROM r_ProdMP where ProdID in (803083,600001 )and PLID = 70

ROLLBACK TRAN

