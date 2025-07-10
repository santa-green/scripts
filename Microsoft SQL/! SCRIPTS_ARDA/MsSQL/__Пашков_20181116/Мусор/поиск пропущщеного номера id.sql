--поиск пропущщеного номера id

DECLARE @date as datetime
select @date = GETDATE()

SELECT top  1 t.LogID+1 FROM [z_LogDiscRec] t WHERE NOT EXISTS (SELECT LogID FROM [z_LogDiscRec] t2 WHERE t2.LogID=t.LogID+1) ORDER BY 1

select DATEDIFF ( millisecond , @date , Cast (GETDATE() as DATETIME) ) millisecond
select @date = GETDATE()

SELECT MIN(t1.LogID)+1 FirstEmptyID FROM [z_LogDiscRec] as t1 
LEFT JOIN [z_LogDiscRec] AS diff ON (t1.LogID = diff.LogID - 1) 
WHERE diff.LogID IS NULL and t1.LogID <> 1

select DATEDIFF ( millisecond , @date , Cast (GETDATE() as DATETIME) ) millisecond
select @date = GETDATE()
