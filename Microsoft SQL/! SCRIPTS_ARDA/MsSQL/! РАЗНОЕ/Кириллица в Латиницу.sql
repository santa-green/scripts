USE [Elit]
GO
/****** Object:  UserDefinedFunction [dbo].[Cyrillic2Latin]    Script Date: 24.09.2020 9:48:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION [dbo].[ap_Cyrillic2Latin] (@cyrillic nvarchar(MAX))
RETURNS nvarchar(max)
AS 
BEGIN
    SET @cyrillic = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@cyrillic,N'ый',N'y'),N'ЫЙ',N'Y'),N'а',N'a'),N'б',N'b'),N'в',N'v'),N'г',N'g'),N'д',N'd'),N'е',N'e'),N'ё',N'yo'),N'ж',N'zh'),N'з',N'z'),N'и',N'i'),N'й',N'y'),N'к',N'k'),N'л',N'l'),N'м',N'm'),N'н',N'n'),N'о',N'o'),N'п',N'p'),N'р',N'r'),N'с',N's'),N'т',N't'),N'у',N'u'),N'ф',N'f'),N'х',N'kh'),N'ц',N'c'),N'ч',N'ch'),N'ш',N'sh'),N'щ',N'shch'),N'ъ',N''),N'ы',N'y'),N'ь',N''),N'э',N'e'),N'ю',N'yu'),N'я',N'ya'),N'А',N'A'),N'Б',N'B'),N'В',N'V'),N'Г',N'G'),N'Д',N'D'),N'Е',N'E'),N'Ё',N'YO'),N'Ж',N'ZH'),N'З',N'Z'),N'И',N'I'),N'Й',N'Y'),N'К',N'K'),N'Л',N'L'),N'М',N'M'),N'Н',N'N'),N'О',N'O'),N'П',N'P'),N'Р',N'R'),N'С',N'S'),N'Т',N'T'),N'У',N'U'),N'Ф',N'F'),N'Х',N'KH'),N'Ц',N'C'),N'Ч',N'CH'),N'Ш',N'SH'),N'Щ',N'SHCH'),N'Ъ',N''),N'Ы',N'Y'),N'Ь',N''),N'Э',N'E'),N'Ю',N'YU'),N'Я',N'YA')
    RETURN @cyrillic
END;

--select [dbo].[ap_Cyrillic2Latin]('жвачка')


GO
