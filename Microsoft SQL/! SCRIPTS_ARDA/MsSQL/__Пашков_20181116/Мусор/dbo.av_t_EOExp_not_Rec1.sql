

ALTER VIEW [dbo].[av_t_EOExp_not_Rec] WITH VIEW_METADATA AS
SELECT * FROM (
SELECT  * FROM t_EOExp 
where ChID not in (SELECT e.ChID FROM  t_Rec m
JOIN z_DocLinks l WITH(NOLOCK) ON l.ParentDocCode = 11211 
	AND l.ChildDocCode = 11002 AND l.ChildChID = m.ChID
JOIN t_EOExp e WITH(NOLOCK) ON e.ChID = l.ParentChID)
AND OurID = 6

) GMSView

GO
--SELECT * FROM [av_t_EOExp_not_Rec]
