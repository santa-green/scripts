SET LANGUAGE N'Russian'
SELECT MAX(ADate) ADate,
CAST(DATENAME(month, MAX(ADate)) + ' ' + CAST(YEAR(MAX(ADate)) AS VARCHAR) AS VARCHAR(200)) Name
FROM dbo.zf_DatesBetween(DATEADD(month,-6,dbo.zf_GetDate(GETDATE())),dbo.zf_GetMonthLastDay(GETDATE()),1)
GROUP BY MONTH(ADate), YEAR(ADate)
ORDER BY 1