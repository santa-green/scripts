ALTER FUNCTION [dbo].[af_GetFirstCharsFromWords] (@s VARCHAR(MAX), @cSigns INT, @fSpaces BIT)
RETURNS VARCHAR(MAX)
AS
BEGIN
--=====================================================================
-- Author: moa0;
-- Create date: '2020-04-17 18:17:12.097'
-- Desription: функция разделяет полученую строку @s по пробелам на слова,
--			   и если нужно сокращает до 24 символов (код УКТ ВЭД 10 символов + '#').
--			   Параметр @cSigns указывает сколько символов нужно оставить в слове.
--			   Параметр @fSpaces указывает оставлять ли пробелы.
--=====================================================================
/*
SELECT Notes, dbo.af_GetFirstCharsFromWords(Notes, 4, 0)
FROM r_Prods
WHERE ProdID IN (606034,600001, 804100)

SELECT ProdID
	  , Notes
	  , CASE
			WHEN LEN(dbo.af_GetFirstCharsFromWords(Notes, 4, 1) ) <= 35
				THEN dbo.af_GetFirstCharsFromWords(Notes, 4, 1)
			WHEN LEN(dbo.af_GetFirstCharsFromWords(Notes, 4, 0) ) <= 35
				THEN dbo.af_GetFirstCharsFromWords(Notes, 4, 0)
			WHEN LEN(dbo.af_GetFirstCharsFromWords(Notes, 3, 1) ) <= 35
				THEN dbo.af_GetFirstCharsFromWords(Notes, 3, 1)
			WHEN LEN(dbo.af_GetFirstCharsFromWords(Notes, 3, 1) ) <= 35
				THEN dbo.af_GetFirstCharsFromWords(Notes, 3, 0)
			ELSE '-' END
FROM r_Prods
WHERE ProdID IN (SELECT ProdID FROM r_ProdLV)
-- AND ProdID IN (606034,600001, 804100)
*/

--Если в строке нет пробелов, то нет слов для этой функции, а значит дальше можно не искать. Выход.
IF (SELECT CHARINDEX(' ', @s) ) = 0
BEGIN
 RETURN 'No Spaces'
END;

DECLARE @fWhile BIT = 1
	   ,@UKTVED VARCHAR(11) = ''
	   ,@Word VARCHAR(MAX) = ''
	   ,@result VARCHAR(MAX) = ''

--Если в строке уже есть код УКТ ВЭД, то запоминаем его и удаляем из строки.
IF (SELECT CHARINDEX('#', @s) ) > 0
BEGIN
	SELECT @UKTVED = SUBSTRING(@s, 1, CHARINDEX('#', @s))
		  ,@s = SUBSTRING(@s, CHARINDEX('#', @s)+1, LEN(@s))
END;

--Достаем первое слово.
SELECT @result = @result + SUBSTRING(@s,1,@cSigns)
	  ,@s = SUBSTRING(@s,CHARINDEX(' ', @s)+1, LEN(@s))

--И в цикле ищем остальные слова.
WHILE (@fWhile = 1)
BEGIN
	
	--Находим слово и удаляем его из строки вместе с пробелом.
	SELECT @Word = SUBSTRING(@s,1,CHARINDEX(' ', @s))
		  ,@s = SUBSTRING(@s,CHARINDEX(' ', @s)+1, LEN(@s))
	
	--Вставляем найденное слово в результирующую строку и попутно обрезаем его до значения указанного в @cSigns.
	--Если установлен параметр @fSpaces, то вставляем пробел.
	SELECT @result = @result
				   + CASE WHEN @fSpaces = 1
							THEN ' '
							ELSE '' END
				   --А еще убираем лишние пробелы, которые могут попасть в @Word.
				   + LTRIM( RTRIM(SUBSTRING(@Word,1,@cSigns)) )
	
	--Если пробелы кончились, то вытягиваем последнее слово и прекращаем цикл.
	IF (SELECT CHARINDEX(' ', @s) ) = 0
		SELECT @result = @result 
			  		   + CASE WHEN @fSpaces = 1
							THEN ' '
							ELSE '' END
					   + SUBSTRING(@s,1,@cSigns)
			  ,@fWhile = 0;

END;  

--Если был код УКТ ВЭД, то дописываем его в начало.
IF @UKTVED != '' SET @result = @UKTVED + @result;

  RETURN @result

END

