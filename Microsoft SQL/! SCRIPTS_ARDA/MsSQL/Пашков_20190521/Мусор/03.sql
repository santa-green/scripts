SELECT top 10000 * FROM dbo.z_LogDiscExp 
--where --DBiID = 1 
--and 
--DocCode =1011
ORDER BY LogDate desc


SELECT top 10000 * FROM dbo.z_LogDiscExp lde
join t_Sale s on s.ChID = lde.ChID and DocCode = 11035
ORDER BY LogDate desc


SELECT top 10000 * FROM dbo.z_LogDiscExp lde
join t_SaleTemp s on s.ChID = lde.ChID and DocCode = 1011
ORDER BY LogDate desc

SELECT * FROM [192.168.174.30].ElitRTS201.dbo.z_LogDiscExp WHERE DocCode != 11035
SELECT * FROM [192.168.174.30].ElitRTS201.dbo.t_SaleTemp 

SELECT distinct top 10000 DocCode FROM dbo.z_LogDiscExp lde

SELECT * FROM z_Docs
WHERE DocCode = 11035
ORDER BY 1

SELECT * FROM z_LogDiscExp
WHERE ChiD = 4418
ORDER BY 1