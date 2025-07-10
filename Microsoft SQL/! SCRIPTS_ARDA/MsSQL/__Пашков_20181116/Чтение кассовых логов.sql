--Чтение кассовых логов 
 
--Кассовые логи 
 --IF OBJECT_ID (N'tempdb..#temp', N'U') IS NOT NULL DROP TABLE #temp
--SELECT  * INTO #temp FROM  OPENROWSET(BULK N'd:\Tmp\Logs\501\2018-04-02\501_2018-04-02_09-00-50-468_CR_FULL.log', SINGLE_CLOB) as ttt
--SELECT * FROM #temp

IF OBJECT_ID (N'tempdb..#temp', N'U') IS NOT NULL DROP TABLE #temp
CREATE TABLE #temp (f1 NVARCHAR(max))
BULK INSERT tempdb..#temp from [d:\Tmp\Logs\501\2018-04-02\501_2018-04-02_09-00-50-468_CR_FULL.log] with ( CODEPAGE = 1251 , rowterminator ='\n')
SELECT * FROM #temp

BEGIN
IF OBJECT_ID (N'tempdb..#CMD', N'U') IS NOT NULL DROP TABLE #CMD
CREATE TABLE #CMD (cmd NVARCHAR(2),info1 NVARCHAR(10),info2 NVARCHAR(50),info3 NVARCHAR(250))

INSERT INTO #CMD (cmd, info1, info2, info3)
SELECT '29','29H(41)','Инициализация','Запись текущих настроек во ФЛЕШ-память.'
union all SELECT '2B','2Bh(43)','Инициализация','Header, Footer и параметры печати'
union all SELECT '3D','3Dh(61)','Инициализация','Дата и время'
union all SELECT '48','48h(72)','Инициализация','Фискализация'
union all SELECT '53','53h(83)','Инициализация','Дес. точка,  использ. налоговые группы, ставки налогов'
union all SELECT '54','54h(84)','Инициализация','Режим продаж'
union all SELECT '57','57H (87)','Инициализация','Программирование дополнительных форм оплаты'
union all SELECT '5B','5Bh(91)','Инициализация','Заводской номер'
union all SELECT '5C','5Ch(92)','Инициализация','Фискальный номер'
union all SELECT '62','62h(98)','Инициализация','Налоговый/Идентификационный номер'
union all SELECT '65','65h(101)','Инициализация','Задать пароль оператора'
union all SELECT '66','66h(102)','Инициализация','Задать имя оператора'
union all SELECT '68','68h(104)','Инициализация','Обнулить данные оператора'
union all SELECT '6B','6Bh(107)','Инициализация','Программирование артикулов и получение информации об артикулах'
union all SELECT '73','73h(115)','Инициализация','Загрузка логотипа'
union all SELECT '76','76h(118)','Инициализация','Пароль администратора'
union all SELECT '77','77h(119)','Инициализация','Обнулить операторские пароли'
union all SELECT '26','26h(38)','Продажа','Открыть нефискальный чек'
union all SELECT '27','27h(39)','Продажа','Закрыть нефискальный чек'
union all SELECT '2A','2Ah(42)','Продажа','Печать нефискального текста'
union all SELECT '30','30h(48)','Продажа','Открыть фискальный чек'
union all SELECT '33','33h(51)','Продажа','Подсумма (SubTotal)'
union all SELECT '34','34h(52)','Продажа','Регистрация продажи и вывод на дисплей'
union all SELECT '35','35h(53)','Продажа','Итог (Total)'
union all SELECT '36','36h(54)','Продажа','Печать фискального текста'
union all SELECT '37','37H (55)','Продажа','Вычисление суммы доп. оплаты и запрос на закрытие чека'
union all SELECT '38','38h(56)','Продажа','Закрыть фискальный чек'
union all SELECT '39','39h(57)','Продажа','Аннулировать чек'
union all SELECT '3A','3Ah(58)','Продажа','Регистрация продажи'
union all SELECT '55','55h(85)','Продажа','Открыть чек возврата'
union all SELECT '58','58H(88)','Продажа','Печат на баркод.'
union all SELECT '5D','5DH(93)','Продажа','Печат на разделителна линия.'
union all SELECT '6D','6Dh(109)','Продажа','Печать копии чека'
union all SELECT '45','45h(69)','Дневной отчет','Сделать Z-отчет или X-отчет '
union all SELECT '32','32h(50)','Отчеты','Налоговые ставки за указанный период'
union all SELECT '49','49h(73)','Отчеты','Полный периодический отчет (по номеру)'
union all SELECT '5E','5Eh(94)','Отчеты','Полный периодический отчет (по дате)'
union all SELECT '4F','4Fh(79)','Отчеты','Сокращенный периодический отчет (по дате)'
union all SELECT '5F','5Fh(95)','Отчеты','Сокращенный периодический отчет (по номеру)'
union all SELECT '69','69h(105)','Отчеты','Отчет операторов'
union all SELECT '6D','6Dh(111)','Отчеты','Отчет товаров'
union all SELECT '3E','3Eh(62)','Передать информацию в прикладную программу','Вернуть дату и время'
union all SELECT '40','40h(64)','Передать информацию в прикладную программу','Информация о последнем Z-отчете'
union all SELECT '41','41h(65)','Передать информацию в прикладную программу','Суммы за день'
union all SELECT '43','43h(67)','Передать информацию в прикладную программу','Суммы коррекций за день'
union all SELECT '44','44h(68)','Передать информацию в прикладную программу','Размер свободной фискальной памяти'
union all SELECT '4A','4Ah(74)','Передать информацию в прикладную программу','Состояние регистратора'
union all SELECT '4С','4Сh(76)','Передать информацию в прикладную программу','Состояние фискальной транзакции'
union all SELECT '56','56H(86)','Передать информацию в прикладную программу','Получаване датата на последния фискален запис.'
union all SELECT '5A','5Ah(90)','Передать информацию в прикладную программу','Диагностическая информация'
union all SELECT '61','61h(97)','Передать информацию в прикладную программу','Налоговые ставки'
union all SELECT '63','63h(99)','Передать информацию в прикладную программу','Налоговый/идентификационный номер'
union all SELECT '67','67h(103)','Передать информацию в прикладную программу','Информация о чеке'
union all SELECT '6E','6Eh(110)','Передать информацию в прикладную программу','Дополнительная информация по типам оплаты'
union all SELECT '70','70h(112)','Передать информацию в прикладную программу','Информация об операторе'
union all SELECT '71','71h(113)','Передать информацию в прикладную программу','Номер последнего фискального чека'
union all SELECT '72','72h(114)','Передать информацию в прикладную программу','Получение информации из фискальной памяти'
union all SELECT '2С','2Сh(44)','Команды принтера','Пропуск строк'
union all SELECT '2D','2Dh(45)','Команды принтера','Отрезать чек'
union all SELECT '21','21h(33)','Дисплей','Очистка дисплея'
union all SELECT '23','23h(35)','Дисплей','Вывод текста (нижний ряд)'
union all SELECT '2F','2Fh(47)','Дисплей','Вывод текста (верхний ряд)'
union all SELECT '3F','3Fh(63)','Дисплей','Вывод даты и времени'
union all SELECT '64','64h(100)','Дисплей','Дисплей – непосредственный вывод'
union all SELECT '46','46h(70)','Другие','Служебный внос и вынос '
union all SELECT '47','47h(71)','Другие','Печать диагностической информации'
union all SELECT '50','50h(80)','Другие','Звуковой сигнал'
union all SELECT '59','59h(89)','Другие','Программирование тестовой области'
union all SELECT '6A','6Ah(106)','Другие','Открыть денежный ящик'

SELECT * FROM #CMD  
END

/*
CREATE FUNCTION dbo.fn_16to10 (@val AS VARCHAR(2))
RETURNS INT
AS
BEGIN
	RETURN (SELECT (CHARINDEX(SUBSTRING(@val, LEN(@val) - 2 + 1, 1),'0123456789ABCDEF') - 1)*16 + (CHARINDEX(SUBSTRING(@val, LEN(@val) - 1 + 1, 1),'0123456789ABCDEF') - 1))
END

GO

CREATE FUNCTION dbo.fn_ASCIIto16 (@val AS VARCHAR(max))
RETURNS VARCHAR(max)
AS
BEGIN
	DECLARE @i int = 1, @result varchar(max)= ''
	WHILE @i <= LEN(@val)
	BEGIN
		SET @result = @result + RIGHT('00' + ASCII(SUBSTRING(@val, @i, 1)), 2)
		--SET @result = @result + SUBSTRING(@val, @i, 1)
		SET @i = @i + 1
	END
	
	RETURN @result
END

CREATE FUNCTION dbo.fn_16toCHAR (@val AS VARCHAR(max))
RETURNS VARCHAR(max)
AS
BEGIN
	DECLARE @i int = 1, @result varchar(max)= ''
	WHILE @i <= LEN(@val)
	BEGIN
		SET @result = @result + CHAR( (SELECT (CHARINDEX(SUBSTRING(SUBSTRING(@val, @i, 2), 1, 1),'0123456789ABCDEF') - 1)*16 + (CHARINDEX(SUBSTRING(SUBSTRING(@val, @i, 2), 2, 1),'0123456789ABCDEF') - 1)) )
		SET @i = @i + 2
	END
	RETURN @result
END
*/



SELECT l21, cmd, cmd_info, data, ost, f1 FROM (
SELECT 
SUBSTRING(W,3,2) len,
dbo.fn_16to10(SUBSTRING(W,3,2))-32 len_dec,
SUBSTRING(W,5,2) seq,
(dbo.fn_16to10(SUBSTRING(W,5,2))-32) seq_dec,
SUBSTRING(W,7,2) cmd,
(SELECT top 1 info2+'-'+info3 FROM #CMD m where m.cmd = SUBSTRING(W,7,2) ) cmd_info,
--SUBSTRING(W,(dbo.fn_16to10(SUBSTRING(W,3,2))-32)*2-8+7,(dbo.fn_16to10(SUBSTRING(W,3,2))-32)*2-8) data,
SUBSTRING(W,9,(dbo.fn_16to10(SUBSTRING(W,3,2))-32)*2-8) data,
SUBSTRING(W,(dbo.fn_16to10(SUBSTRING(W,3,2))-32)*2+3 ,8) bcc,
* FROM (
SELECT 
case when wr = 1 then SUBSTRING(f1,CHARINDEX('[',f1)+1,CHARINDEX(']',f1)-CHARINDEX('[',f1)-1) end W,
case when wr = 2 then SUBSTRING(f1,CHARINDEX('[',f1)+1,CHARINDEX(']',f1)-CHARINDEX('[',f1)-1) end R
,* FROM (
SELECT f1, LEFT(f1,21) 'l21', ISDATE(LEFT(f1,21)) is_date, SUBSTRING(f1,23,3) s3
,case when SUBSTRING(f1,23,3) = 'W [' then 1 when SUBSTRING(f1,23,3) = 'R [' then 2 else 0 end wr
,CHARINDEX('[',f1) b
,CHARINDEX(']',f1) e
,SUBSTRING(f1,CHARINDEX('[',f1),CHARINDEX(']',f1)-CHARINDEX('[',f1)+1) com
,case when ISDATE(LEFT(f1,21))= 0 then SUBSTRING(f1,0,len(f1)) when ISDATE(LEFT(f1,21))= 1 AND SUBSTRING(f1,23,3) in ('W [','R [') then SUBSTRING(f1,CHARINDEX(']',f1)+1,len(f1)) else SUBSTRING(f1,22,len(f1)) end ost
FROM #temp 
) s1) s2
where s2.W is not null
)s3
--where s3.cmd in ('3A','6B')


/*
select CHAR(5)
select ASCII('')
*/

