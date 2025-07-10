ALTER Function [dbo].[af_GetRandomString](@num smallint)
RETURNS nVarChar(max)
as
begin
/*генерирует случайные символы в одной строке; @num - количество символов*/
/*
select dbo.af_GetRandomString(1000)
select len(dbo.af_GetRandomString(1000))
*/
DECLARE @pos int
DECLARE @txt nvarchar(max) = ''
SET @pos = @num

while @pos > 0
Begin
--IF Substring(@txt,@pos,1) not like '[0-9]'
	SET @txt += (SELECT(CHAR(CAST((SELECT * FROM rndView)*256 AS int))))
set @pos -= 1
end
	
return @txt
end
GO


/*CREATE VIEW rndView
AS
SELECT RAND() rndResult
GO*/

--ТЕСТ функции
if OBJECT_ID('tempdb..##test1', 'U') IS NOT NULL DROP TABLE ##test1
create table ##test1 (f1 nvarchar(max), f2 nvarchar(max), f3 nvarchar(max))

DECLARE @pos int = 100000
DECLARE @txt nvarchar(max) = ''
while @pos > 0
Begin

--	SET @txt += (SELECT(CHAR(CAST((SELECT * FROM rndView)*256 AS int))))
	SET @txt = dbo.af_GetRandomString(1000)
    INSERT INTO ##test1
    select @txt, dbo.AF_GETONLYNUM(@txt), dbo.AF_GETONLYNUMs(@txt)
set @pos -= 1
end

SELECT * FROM ##test1
SELECT * FROM ##test1 WHERE f2 <> f3
