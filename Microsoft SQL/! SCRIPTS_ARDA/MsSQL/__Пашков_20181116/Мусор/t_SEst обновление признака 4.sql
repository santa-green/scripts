SELECT * FROM r_Uni where RefTypeID = 1000000005



SELECT ISNULL((SELECT top 1 CAST(RefName AS INT) FROM r_Uni WHERE RefTypeID = 1000000005 and ISNUMERIC(RefName) = 1 and RefID = 83 ), 0)




--[ap_UpdatePromoPricesFrom_t_SEst]


SELECT 
CodeID4, 
(SELECT top 1 PLID FROM  t_SEstD d where d.ChID = m.ChID) ,
 (SELECT ISNULL((SELECT top 1 CAST(RefName AS INT) FROM r_Uni WHERE RefTypeID = 1000000005 and ISNUMERIC(RefName) = 1 and RefID = (SELECT top 1 PLID FROM  t_SEstD d where d.ChID = m.ChID) ), 0)),m.* FROM t_SEst m

ORDER BY 3 desc


BEGIN TRAN

SELECT *, (SELECT top 1 PLID FROM t_SEstD d where d.ChID = m.ChID) FROM t_SEst m ORDER BY CodeID4 desc

update m 
set CodeID4 = (SELECT ISNULL((SELECT top 1 CAST(RefName AS INT) FROM r_Uni WHERE RefTypeID = 1000000005 and ISNUMERIC(RefName) = 1 and RefID = (SELECT top 1 PLID FROM  t_SEstD d where d.ChID = m.ChID) ), 0))
FROM t_SEst m

SELECT *, (SELECT top 1 PLID FROM t_SEstD d where d.ChID = m.ChID) FROM t_SEst m ORDER BY CodeID4 desc

ROLLBACK TRAN


/*
insert r_Uni
SELECT * FROM elitr.dbo.r_Uni
WHERE RefID not in (SELECT RefID FROM r_Uni)
ORDER BY 1


insert r_UniTypes
SELECT * FROM elitr.dbo.r_UniTypes
WHERE RefTypeID not in (SELECT RefTypeID FROM r_UniTypes)
ORDER BY 1
*/