--2 варианта преобразования колонки в строку.
DROP TABLE #val
select top 3 compid into #val from r_comps 
SELECT * FROM #val
SELECT 
SUBSTRING((SELECT   ',' + cast(CompID as nvarchar(max)) as [text()] FROM #val /*where TABLE_CATALOG = 'ElitR_316' and TABLE_NAME = 'z_LogDiscExp'*/
for XML PATH('')),2,65535)


DROP TABLE #val_2
select top 3 compid into #val_2 from r_comps 
SELECT * FROM #val_2
DECLARE @result NVARCHAR(max) 
SELECT @result = COALESCE(@result + ', ', '') + CAST(CompID AS nvarchar) FROM #val_2
SELECT @result
