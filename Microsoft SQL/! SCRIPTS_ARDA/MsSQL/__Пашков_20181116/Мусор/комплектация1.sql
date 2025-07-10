--select * from t_SRec where DocID = 100002238

declare @ChID int = 100015449

select * from t_SRec where ChID = @ChID

select * from t_SRecA where ChID = @ChID

select * from t_SRecD where AChID in (select AChID from t_SRecA where chid = @ChID) order by AChID

