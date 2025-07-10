USE [Elit]
GO
/****** Object:  UserDefinedFunction [dbo].[af_NumToText]    Script Date: 29.10.2020 17:00:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[af_NumToText] (@Num BIGINT, @Lang TINYINT = 1, @Gender TINYINT = 1)
RETURNS VARCHAR(255)
AS
BEGIN
  /* @Gender - 0 - female, 1 - male, 2 - und */
  DECLARE @nword VARCHAR(255), @th TINYINT, @gr SMALLINT, @d3 TINYINT, @d2 TINYINT, @d1 TINYINT
  IF @Num<0 RETURN '*** Error: Negative value' ELSE IF @Num=0 RETURN 'Ноль'
  /* особый случай */
  WHILE @Num>0
  BEGIN
    SET @th=ISNULL(@th,0)+1    SET @gr=@Num%1000    SET @Num=(@Num-@gr)/1000
    IF @gr>0
    BEGIN
      SET @d3=(@gr-@gr%100)/100
      SET @d1=@gr%10
      SET @d2=(@gr-@d3*100-@d1)/10
      IF @d2=1 SET @d1=10+@d1
      IF @Lang = 0
        SET @nword=CASE @d3
                  WHEN 1 THEN ' сто' WHEN 2 THEN ' двести' WHEN 3 THEN ' триста'
                  WHEN 4 THEN ' четыреста' WHEN 5 THEN ' пятьсот' WHEN 6 THEN ' шестьсот'
                  WHEN 7 THEN ' семьсот' WHEN 8 THEN ' восемьсот' WHEN 9 THEN ' девятьсот' ELSE '' END
                +CASE @d2
                  WHEN 2 THEN ' двадцать' WHEN 3 THEN ' тридцать' WHEN 4 THEN ' сорок'
                  WHEN 5 THEN ' пятьдесят' WHEN 6 THEN ' шестьдесят' WHEN 7 THEN ' семьдесят'
                  WHEN 8 THEN ' восемьдесят' WHEN 9 THEN ' девяносто' ELSE '' END
                +CASE @d1
                  WHEN 1 THEN (CASE WHEN @th=2 OR (@th=1 AND @Gender=0) THEN ' одна' WHEN (@th=1 AND @Gender=2) THEN ' одно' ELSE ' один' END)
                  WHEN 2 THEN (CASE WHEN @th=2 OR (@th=1 AND @Gender=0) THEN ' две' ELSE ' два' END)
                  WHEN 3 THEN ' три' WHEN 4 THEN ' четыре' WHEN 5 THEN ' пять'
                  WHEN 6 THEN ' шесть' WHEN 7 THEN ' семь' WHEN 8 THEN ' восемь'
                  WHEN 9 THEN ' девять' WHEN 10 THEN ' десять' WHEN 11 THEN ' одиннадцать'
                  WHEN 12 THEN ' двенадцать' WHEN 13 THEN ' тринадцать' WHEN 14 THEN ' четырнадцать'
                  WHEN 15 THEN ' пятнадцать' WHEN 16 THEN ' шестнадцать' WHEN 17 THEN ' семнадцать'
                  WHEN 18 THEN ' восемнадцать' WHEN 19 THEN ' девятнадцать' ELSE '' END
                +CASE @th
                  WHEN 2 THEN ' тысяч'     +(CASE WHEN @d1=1 THEN 'а' WHEN @d1 IN (2,3,4) THEN 'и' ELSE ''   END)
                  WHEN 3 THEN ' миллион' WHEN 4 THEN ' миллиард' WHEN 5 THEN ' триллион' WHEN 6 THEN ' квадриллион' WHEN 7 THEN ' квинтиллион'
                  ELSE '' END
                +CASE WHEN @th IN (3,4,5,6,7) THEN (CASE WHEN @d1=1 THEN '' WHEN @d1 IN (2,3,4) THEN 'а' ELSE 'ов' END) ELSE '' END
                +ISNULL(@nword,'')
      ELSE IF @Lang = 1
            SET @nword=CASE @d3
                  WHEN 1 THEN ' сто' WHEN 2 THEN ' двісті' WHEN 3 THEN ' триста'
                  WHEN 4 THEN ' чотириста' WHEN 5 THEN ' п’ятсот' WHEN 6 THEN ' шістсот'
                  WHEN 7 THEN ' сімсот' WHEN 8 THEN ' вісімсот' WHEN 9 THEN ' дев’ятсот' ELSE '' END
                +CASE @d2
                  WHEN 2 THEN ' двадцять' WHEN 3 THEN ' тридцять' WHEN 4 THEN ' сорок'
                  WHEN 5 THEN ' п’ятдесят' WHEN 6 THEN ' шістдесят' WHEN 7 THEN ' сімдесят'
                  WHEN 8 THEN ' вісімдесят' WHEN 9 THEN ' дев’яносто' ELSE '' END
                +CASE @d1
                  WHEN 1 THEN (CASE WHEN @th=2 OR (@th=1 AND @Gender=0) THEN ' одна' WHEN (@th=1 AND @Gender=2) THEN ' одне' ELSE ' один' END)
                  WHEN 2 THEN (CASE WHEN @th=2 OR (@th=1 AND @Gender=0) THEN ' дві' ELSE ' два' END)
                  WHEN 3 THEN ' три' WHEN 4 THEN ' чотири' WHEN 5 THEN ' п’ять'
                  WHEN 6 THEN ' шість' WHEN 7 THEN ' сім' WHEN 8 THEN ' вісім'
                  WHEN 9 THEN ' дев’ять' WHEN 10 THEN ' десять' WHEN 11 THEN ' одинадцять'
                  WHEN 12 THEN ' дванадцять' WHEN 13 THEN ' тринадцять' WHEN 14 THEN ' чотирнадцять'
                  WHEN 15 THEN ' п’ятнадцять' WHEN 16 THEN ' шістнадцять' WHEN 17 THEN ' сімнадцять'
                  WHEN 18 THEN ' вісімнадцять' WHEN 19 THEN ' дев’ятнадцять' ELSE '' END
                +CASE @th
                  WHEN 2 THEN ' тисяч' +(CASE WHEN @d1=1 THEN 'а' WHEN @d1 IN (2,3,4) THEN 'і' ELSE ''   END)
                  WHEN 3 THEN ' мільйон' WHEN 4 THEN ' мільярд' WHEN 5 THEN ' трильйон' WHEN 6 THEN ' квадрильйон' WHEN 7 THEN ' квінтильйон'
                  ELSE '' END
                +CASE WHEN @th IN (3,4,5,6,7) THEN (CASE WHEN @d1=1 THEN '' WHEN @d1 IN (2,3,4) THEN 'и' ELSE 'ів' END) ELSE '' END
                +ISNULL(@nword,'')
    END
  END
  RETURN UPPER(SUBSTRING(@nword,2,1))+SUBSTRING(@nword,3,LEN(@nword)-2)
END
GO
