--Обновление признак 4 Переоценки цен продажи

BEGIN TRAN


SELECT *, (SELECT top 1 PLID FROM t_SEstD d where d.ChID = m.ChID) FROM t_SEst m ORDER BY CodeID4 desc

update m 
set CodeID4 = (SELECT ISNULL((SELECT top 1 CAST(RefName AS INT) FROM r_Uni WHERE RefTypeID = 1000000005 and ISNUMERIC(RefName) = 1 and RefID = (SELECT top 1 PLID FROM  t_SEstD d where d.ChID = m.ChID) ), 0))
FROM t_SEst m

SELECT *, (SELECT top 1 PLID FROM t_SEstD d where d.ChID = m.ChID) FROM t_SEst m ORDER BY CodeID4 desc


ROLLBACK TRAN



