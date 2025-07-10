USE Elit
-- оптимизация сжатого списка кодов
DECLARE @Filter VARCHAR(MAX) = 
'

2,4,9-12,15-18,20,22-30,37,42-48,59,61,67,85,92,102-104,114,122-129,137,192,220,204,228,304,322-328,337,403-409,904,1004,1104,1424,1428,2504,2520,2524,2528,2600-2999,4000-19999
'
SELECT len(@Filter) 'до сжатия', len(dbo.[af_FilterToFilter](@Filter)) 'после сжатия', dbo.[af_FilterToFilter](@Filter) 'сжатый фильтр'


--показать пользователей у которых можно уменьшить фильтр складов
DECLARE @ValidStocks varchar(max)
DECLARE @UserName varchar(max)
DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD
FOR 
SELECT UserName,ValidStocks FROM r_Users WITH (NOLOCK) WHERE LEN(ValidStocks) > 2 ORDER BY LEN(ValidStocks) desc
--SELECT username,ValidStocks, len(ValidStocks) FROM r_Users WITH (NOLOCK) WHERE LEN(ValidStocks) > 2 ORDER BY 3 desc


OPEN CURSOR1
	FETCH NEXT FROM CURSOR1 INTO @UserName,@ValidStocks
WHILE @@FETCH_STATUS = 0
BEGIN
	--Script
	IF len(dbo.[af_FilterToFilter](@ValidStocks))<> len(@ValidStocks) 
		SELECT @UserName,len(@ValidStocks) 'до сжатия', len(dbo.[af_FilterToFilter](@ValidStocks)) 'после сжатия', dbo.[af_FilterToFilter](@ValidStocks) 'сжатый фильтр'
	
	FETCH NEXT FROM CURSOR1 INTO @UserName,@ValidStocks
END
CLOSE CURSOR1
DEALLOCATE CURSOR1

--SELECT * FROM r_Stocks ORDER BY 2