USE [Elit_TEST]
GO
/****** Object:  UserDefinedFunction [dbo].[af_FilterToFilter]    Script Date: 21.09.2020 18:31:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[af_FilterToFilter](@Filter VARCHAR(MAX))
RETURNS VARCHAR(MAX)
AS
BEGIN
  DECLARE @Afilter VARCHAR(MAX)
  DECLARE @ABuf INT
  DECLARE @AVal INT
  DECLARE @AMVal INT
  DECLARE @APrVal INT

  SET @Afilter = REPLACE(REPLACE(@Filter,CHAR(13),''),CHAR(10),'')
  IF @Afilter = '' RETURN ''
  DECLARE Aloop CURSOR FAST_FORWARD LOCAL FOR
    SELECT DISTINCT AValue FROM dbo.afx_FilterToTable(@AFilter) ORDER BY 1
  OPEN Aloop
  SET @Afilter = ''

  FETCH NEXT FROM Aloop INTO @AVal
  WHILE @@FETCH_STATUS = 0
  BEGIN
    IF @AVal - ISNULL(@ABuf,0) = 1
    BEGIN
      -- Сохраняем начало диапазона на всякий случай
      SET @AMVal = @AVal
      -- Сохраняем предыдущие значения
      SET @APrVal = ISNULL(@ABuf, @AVal)

      WHILE @AVal = ISNULL(@ABuf,0) + 1
      BEGIN
        SET @ABuf = @AVal
        FETCH NEXT FROM Aloop INTO @AVal
      END
      
      -- Если строка фильтра пуста, заносим в неё минимальное значение из диапазона
      IF LEN(@Afilter) = 0
        SET @Afilter = CAST(@AMVal AS VARCHAR(10)) + ','
      
      IF @ABuf - @APrVal = 1 
        SET @Afilter = SUBSTRING(@Afilter, 1, LEN(@Afilter) - 1) + ',' + CAST(@ABuf AS VARCHAR(10)) + ','
      ELSE IF @ABuf - @APrVal > 1
        SET @Afilter = SUBSTRING(@Afilter, 1, LEN(@Afilter) - 1) + '-' + CAST(@ABuf AS VARCHAR(10)) + ','
		  
		  IF @AVal <> @ABuf
        SET @Afilter = @Afilter + CAST(@AVal AS VARCHAR(10)) + ','
    END
    ELSE
    BEGIN
      SET @Afilter = @Afilter + CAST(@AVal AS VARCHAR(10)) + ','
    END
    SET @ABuf = @AVal
    FETCH NEXT FROM Aloop INTO @AVal
  END
  CLOSE Aloop
  DEALLOCATE Aloop
  RETURN SUBSTRING(@Afilter, 1, LEN(@Afilter) - 1)
END
GO
