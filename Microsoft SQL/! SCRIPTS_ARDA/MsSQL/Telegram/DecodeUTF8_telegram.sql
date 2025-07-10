SELECT * FROM [dbo].[at_JSON_from_Telegram]
SELECT * FROM [dbo].[at_JSON_details] ORDER BY 1,2
SELECT * FROM [dbo].[at_JSON_details] where  NAME = 'text' ORDER BY 1 desc
SELECT [dbo].[DecodeUTF8_telegram](StringValue),* FROM [dbo].[at_JSON_details] where  NAME = 'text' ORDER BY 2 desc


--{"update_id":960343858, "message":{"message_id":11338,"from":{"id":340466470,"is_bot":false,"first_name":"Oleg","last_name":"Maslov","username":"FoxOzz","language_code":"ru"},"chat":{"id":340466470,"first_name":"Oleg","last_name":"Maslov","username":"FoxOzz","type":"private"},"date":1567780353,"text":"Hello fck"}}


SELECT CONVERT(INT, CONVERT(VARBINARY, '043f', 2))
SELECT NCHAR(CONVERT(INT, CONVERT(VARBINARY, '043f', 2)))
SELECT NCHAR(CONVERT(INT, CONVERT(VARBINARY, '20e3', 2)))
SELECT [dbo].[DecodeUTF8_telegram]('1\u20e3')

alter function [dbo].[DecodeUTF8_telegram](@utf8 nvarchar(max)) returns nvarchar(max)
as
BEGIN
/*скал€рна€ функци€ озвол€ет раскодировать сообщение в телеграмме с UTF8 в с1251*/
/*
SELECT [dbo].[DecodeUTF8_telegram]('1\u20e3')
*/
	DECLARE @pos int
	DECLARE @hex NVARCHAR(4)
	set @pos = PATINDEX ('%\u%',@utf8)--находим начальную позицию \u
	while @pos > 0
	BEGIN
		set @hex = substring(@utf8,@pos+2,4)--достаем строку из 4 символов в которой шеснадцатиричный код символа в UTF8
		set @utf8 =replace( @utf8, '\u' + @hex,  ISNULL( NCHAR(CONVERT(INT, CONVERT(VARBINARY, @hex, 2))) ,'') )--замен€ем код типа \u20e3 на одиночный символ
		set @pos = PATINDEX ('%\u%',@utf8)--находим начальную позицию \u
	END

	return @utf8
END


DECLARE @utf8 nvarchar(max) = '1\u20e3'
	DECLARE @pos int
	DECLARE @hex NVARCHAR(4)
	set @pos = PATINDEX ('%\u%',@utf8)
	while @pos > 0
	BEGIN
		set @hex = substring(@utf8,@pos+2,4)
		select @hex, @pos,CONVERT(VARBINARY, @hex, 2),CONVERT(INT, CONVERT(VARBINARY, @hex, 2)),ISNULL( NCHAR(CONVERT(INT, CONVERT(VARBINARY, @hex, 2))) ,'')
		set @utf8 =replace( @utf8, '\u' + @hex,  ISNULL( NCHAR(CONVERT(INT, CONVERT(VARBINARY, @hex, 2))) ,'') )
		select @utf8
		set @pos = PATINDEX ('%\u%',@utf8)
	END

	select @utf8











CREATE FUNCTION [dbo].[URLEncode] 
    (@decodedString VARCHAR(4000))
RETURNS VARCHAR(4000)
AS
BEGIN
/******
*       select dbo.URLEncode('привет')
**/

DECLARE @encodedString VARCHAR(4000)

IF @decodedString LIKE '%[^a-zA-Z0-9*-.!_]%' ESCAPE '!'
BEGIN
    SELECT @encodedString = REPLACE(
                                    COALESCE(@encodedString, @decodedString),
                                    SUBSTRING(@decodedString,num,1),
                                    '%' + SUBSTRING(master.dbo.fn_varbintohexstr(CONVERT(VARBINARY(1),ASCII(SUBSTRING(@decodedString,num,1)))),3,3))
    FROM dbo.numbers 
    WHERE num BETWEEN 1 AND LEN(@decodedString) AND SUBSTRING(@decodedString,num,1) like '[^a-zA-Z0-9*-.!_]' ESCAPE '!'
END
ELSE
BEGIN
    SELECT @encodedString = @decodedString 
END

RETURN @encodedString

END




alter FUNCTION dbo.UrlEncode(@url NVARCHAR(1024))
RETURNS NVARCHAR(3072)
AS
BEGIN
    DECLARE @count INT, @c NCHAR(1), @i INT, @urlReturn NVARCHAR(3072)
    SET @count = LEN(@url)
    SET @i = 1
    SET @urlReturn = ''    
    WHILE (@i <= @count)
     BEGIN
        SET @c = SUBSTRING(@url, @i, 1)
        IF @c LIKE N'[A-Za-z0-9()''*\-._!~]' COLLATE Latin1_General_BIN ESCAPE N'\' COLLATE Latin1_General_BIN
         BEGIN
            SET @urlReturn = @urlReturn + @c
         END
        ELSE
         BEGIN
            SET @urlReturn = 
                   @urlReturn + '%'
                   + SUBSTRING(sys.fn_varbintohexstr(CAST(@c AS VARBINARY(MAX))),3,2)
                   + ISNULL(NULLIF(SUBSTRING(sys.fn_varbintohexstr(CAST(@c AS VARBINARY(MAX))),5,2), '00'), '')
         END
        SET @i = @i +1
     END
    RETURN @urlReturn
END

create function [dbo].[DecodeUTF8](@utf8 varchar(max)) returns nvarchar(max)
as
begin
    declare @xml xml;

    with e2(n) as (select top(16) 0 from (values(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0),(0)) e(n))
    , e3(n) as (select top(256) 0 from e2, e2 e)
    , e4(n) as (select top(65536) 0 from e3, e3 e)
    , e5(n) as (select top(power(2.,31)-1) row_number() over (order by(select 0)) from e4, e4 e)
    , numbers(i) as (select top(datalength(@utf8)) row_number() over (order by(select 0)) from e5)
    , x as (
        select *
        from numbers
        cross apply (select byte = convert(tinyint, convert(binary(1), substring(@utf8, i, 1)))) c
        cross apply (select n = floor(log(~(byte) * 2 + 1, 2)) - 1) d
        cross apply (select bytes = case when n in (5,4,3) then 7 - n else 1 end) e
        cross apply (select data = byte % power(2, n)) f
    )
    select @xml =
    (
        select nchar(case x.bytes
            when 1 then x.data
            when 2 then power(2, 6) * x.data + x2.data 
            when 3 then power(2, 6*2) * x.data + power(2, 6) * x2.data + x3.data
            when 4 then power(2, 6*3) * x.data + power(2, 6*2) * x2.data + power(2, 6) * x3.data + x4.data
          end)
        from x
        left join x x2 on x2.i = x.i + 1 and x.bytes > 1
        left join x x3 on x3.i = x.i + 2 and x.bytes > 2
        left join x x4 on x4.i = x.i + 3 and x.bytes > 3
        where x.n <> 6
        order by x.i
        for xml path('')
    );

    return @xml.value('.', 'nvarchar(max)');
end