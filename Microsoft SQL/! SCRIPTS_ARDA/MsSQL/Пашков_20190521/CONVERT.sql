declare @i int = 1

WHILE @i <= 14
BEGIN
  SELECT  str(@i) + ' - ' + CONVERT(nvarchar(30), GETDATE(), @i)
  SELECT @i += 1
END 


select @i  = 100

WHILE @i <= 114
BEGIN
  SELECT  str(@i) + ' - ' + CONVERT(nvarchar(30), GETDATE(), @i)
  SELECT @i += 1
END 

select @i  = 20
SELECT  str(@i) + ' - ' + CONVERT(nvarchar(30), GETDATE(), @i)

select @i  = 120
SELECT  str(@i) + ' - ' + CONVERT(nvarchar(30), GETDATE(), @i)

select @i  = 21
SELECT  str(@i) + ' - ' + CONVERT(nvarchar(30), GETDATE(), @i)

select @i  = 121
SELECT  str(@i) + ' - ' + CONVERT(nvarchar(30), GETDATE(), @i)

select @i  = 126
SELECT  str(@i) + ' - ' + CONVERT(nvarchar(30), GETDATE(), @i)


select @i  = 127
SELECT  str(@i) + ' - ' + CONVERT(nvarchar(30), GETDATE(), @i)

select @i  = 130
SELECT  str(@i) + ' - ' + CONVERT(nvarchar(30), GETDATE(), @i)

select @i  = 131
SELECT  str(@i) + ' - ' + CONVERT(nvarchar(30), GETDATE(), @i)

--https://msdn.microsoft.com/ru-ru/library/ms187928.aspx