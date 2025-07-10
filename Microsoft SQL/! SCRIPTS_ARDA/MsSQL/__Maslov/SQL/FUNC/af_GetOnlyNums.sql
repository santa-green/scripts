--=====================================================================
-- Author: moa0;
-- Create date: '2020-01-15 10:37:36.072'
-- Desription: функция удаляет из строки все символы кроме цифр.
--=====================================================================
ALTER FUNCTION [dbo].[af_GetOnlyNums] (@s VARCHAR(MAX))
RETURNS VARCHAR(MAX)
AS
BEGIN
/*
SELECT dbo.af_GetOnlyNums('qwert13d313hyv09')
*/ 
  RETURN (SELECT CAST(SUBSTRING(@s,V.number,1) AS VARCHAR)
		 	FROM master.dbo.spt_values V
		 	WHERE V.type='P' AND V.number BETWEEN 1 AND LEN(@s) AND SUBSTRING(@s,V.number,1) LIKE '[0123456789]'
		 	ORDER BY V.number
		 	FOR XML PATH('')
		 )
END

