ALTER FUNCTION [dbo].[af_GetFirstCharsFromWords] (@s VARCHAR(MAX), @cSigns INT, @fSpaces BIT)
RETURNS VARCHAR(MAX)
AS
BEGIN
--=====================================================================
-- Author: moa0;
-- Create date: '2020-04-17 18:17:12.097'
-- Desription: ������� ��������� ��������� ������ @s �� �������� �� �����,
--			   � ���� ����� ��������� �� 24 �������� (��� ��� ��� 10 �������� + '#').
--			   �������� @cSigns ��������� ������� �������� ����� �������� � �����.
--			   �������� @fSpaces ��������� ��������� �� �������.
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

--���� � ������ ��� ��������, �� ��� ���� ��� ���� �������, � ������ ������ ����� �� ������. �����.
IF (SELECT CHARINDEX(' ', @s) ) = 0
BEGIN
 RETURN 'No Spaces'
END;

DECLARE @fWhile BIT = 1
	   ,@UKTVED VARCHAR(11) = ''
	   ,@Word VARCHAR(MAX) = ''
	   ,@result VARCHAR(MAX) = ''

--���� � ������ ��� ���� ��� ��� ���, �� ���������� ��� � ������� �� ������.
IF (SELECT CHARINDEX('#', @s) ) > 0
BEGIN
	SELECT @UKTVED = SUBSTRING(@s, 1, CHARINDEX('#', @s))
		  ,@s = SUBSTRING(@s, CHARINDEX('#', @s)+1, LEN(@s))
END;

--������� ������ �����.
SELECT @result = @result + SUBSTRING(@s,1,@cSigns)
	  ,@s = SUBSTRING(@s,CHARINDEX(' ', @s)+1, LEN(@s))

--� � ����� ���� ��������� �����.
WHILE (@fWhile = 1)
BEGIN
	
	--������� ����� � ������� ��� �� ������ ������ � ��������.
	SELECT @Word = SUBSTRING(@s,1,CHARINDEX(' ', @s))
		  ,@s = SUBSTRING(@s,CHARINDEX(' ', @s)+1, LEN(@s))
	
	--��������� ��������� ����� � �������������� ������ � ������� �������� ��� �� �������� ���������� � @cSigns.
	--���� ���������� �������� @fSpaces, �� ��������� ������.
	SELECT @result = @result
				   + CASE WHEN @fSpaces = 1
							THEN ' '
							ELSE '' END
				   --� ��� ������� ������ �������, ������� ����� ������� � @Word.
				   + LTRIM( RTRIM(SUBSTRING(@Word,1,@cSigns)) )
	
	--���� ������� ���������, �� ���������� ��������� ����� � ���������� ����.
	IF (SELECT CHARINDEX(' ', @s) ) = 0
		SELECT @result = @result 
			  		   + CASE WHEN @fSpaces = 1
							THEN ' '
							ELSE '' END
					   + SUBSTRING(@s,1,@cSigns)
			  ,@fWhile = 0;

END;  

--���� ��� ��� ��� ���, �� ���������� ��� � ������.
IF @UKTVED != '' SET @result = @UKTVED + @result;

  RETURN @result

END

