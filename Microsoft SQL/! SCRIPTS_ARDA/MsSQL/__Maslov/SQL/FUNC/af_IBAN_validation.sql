-- =============================================
-- Author:		<rkv0,Kirl>
-- Create date: <'2019-08-05 13:49'>
-- Description:	<Проводит валидацию IBAN>
-- =============================================
/*
--Для теста.
SELECT [dbo].[af_IBAN_validation]('UA903052992990004149123456789')
*/

ALTER FUNCTION [dbo].[af_IBAN_validation](@iban varchar(34))
RETURNS int
AS
BEGIN

/*Алгоритм проверки IBAN выглядит следующим образом: https://ru.qwerty.wiki/wiki/International_Bank_Account_Number
Убедитесь, что общая длина IBAN является правильным согласно стране. Если нет, то IBAN является недействительным
Переместить четыре начальные символы до конца строки
Заменить каждую букву в строке с двумя цифрами, тем самым расширяя строку, где А = 10, В = 11, ..., Z = 35
Интерпретировать строку как десятичное целое и вычислить остаток от этого числа при делении на 97
Если остаток равен 1, тест цифры чека передается и IBAN может быть действительным.*/

	IF (SELECT CHARINDEX('UA', @iban)) = 0 --OR (@iban IS NULL)
	BEGIN
		RETURN 1;
	END;
    --создаем табличную переменную для хранения соответствий букв и чисел.
    DECLARE @iban_abc table (letter char(1), num tinyint);
    INSERT INTO @iban_abc (letter, num) VALUES
    ('A', 10),('B', 11),('C', 12),('D', 13),('E', 14),('F', 15),('G', 16),('H', 17),('I', 18),('J', 19),('K', 20),('L', 21),('M', 22),('N', 23),('O', 24),('P', 25),('Q', 26),('R', 27),('S', 28),('T', 29),('U', 30),('V', 31),('W', 32),('X', 33),('Y', 34),('Z', 35);

    --меняем буквы на цифры согласно табличной переменной @iban_abc
    DECLARE @letter1 tinyint = (SELECT num FROM @iban_abc WHERE letter = SUBSTRING(@iban,1,1));
    DECLARE @letter2 tinyint = (SELECT num FROM @iban_abc WHERE letter = SUBSTRING(@iban,2,1));
    SET @iban = REPLACE(@iban,SUBSTRING(@iban,1,1),@letter1);
    SET @iban = REPLACE(@iban,SUBSTRING(@iban,3,1),@letter2);
        
    --переносим в конец первые 6 символов iban-кода.
    SET @iban = SUBSTRING(@iban,7,100) + SUBSTRING(@iban,1,6);

    IF cast(@iban as numeric(34,0)) % 97 = 1 RETURN 1 ELSE RETURN 0;
    RETURN 1;
END