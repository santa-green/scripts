--=====================================================================
-- Author: moa0;
-- Create date: '2019-10-07 09:34:35.141'
-- Desription: возвращает дату указанного дн€ со смещением недели.
--=====================================================================
ALTER FUNCTION [dbo].[af_GetDateOfDayInDependenceFromWeek] (@DateFrom SMALLDATETIME, @DayNumber INT, @WeekAdd INT)
RETURNS SMALLDATETIME
AS
BEGIN
/*
SELECT dbo.af_GetDateOfDayInDependenceFromWeek('20191010',6,3)
*/
/*
‘ункци€ возвращает дату дн€ недели со смещением по неделе.
@DateFrom - дата от которой будет проводитс€ расчет;
@DayNumber - пор€дковый номер дн€ недели. ¬ зависимости от выбранного формата
			 номер будет разный.   примеру в настройках первый день недели
			 выставлен воскресеньем, тогда его номер будет 1;
@WeekAdd - смещение недели.   примеру 1 - это через неделю от указанной даты.
		   -1 - это на прошлой неделе.

ѕример.
Ќужно получить дату следующего вторника (вторник второй день, значит 2). —егодн€
"11.10.2019". “огда вызов функции будет выгл€дить так:
SELECT dbo.af_GetDateOfDayInDependenceFromWeek('20191011',2,1)
*/

  --≈сли кто-то захочет втавить не корректный номер дн€ недели, то вернем ему дату и все.
  IF @DayNumber NOT BETWEEN 1 AND 7
  BEGIN
	RETURN @DateFrom
  END;
  
  --ќбъ€вл€ем переменные.
  /*
  ¬ычисл€ем текущий день недели, с расчетом на то, что недел€ начинаетс€ с понедельника.
  Ёто нужно потому что стандартна€ функци€ "SET DATEFIRST 1" не работает (по причинам, 
  которые известны только разработчикам и јллаху).
  */
									--≈сли параметр, который указывает на день начала недели определ€ет,
									--что недел€ начинаетс€ с понедельника.
  DECLARE @CurrDayOfWeek INT = CASE WHEN @@DATEFIRST = 1
										THEN DATEPART(WEEKDAY, @DateFrom)
									--≈сли параметр, который указывает на день начала недели определ€ет,
									--что недел€ начинаетс€ с воскресень€ и сегодн€ воскресенье.
									WHEN DATEPART(WEEKDAY, @DateFrom) = 1 AND @@DATEFIRST = 7
										THEN 7
									--≈сли параметр, который указывает на день начала недели определ€ет,
									--что недел€ начинаетс€ с воскресень€, то вычитаем 1, чтобы получить
									--нужный формат.
									WHEN DATEPART(WEEKDAY, @DateFrom) > 1 AND @@DATEFIRST = 7
										THEN DATEPART(WEEKDAY, @DateFrom) - 1 
									END
  --¬ычисл€ем количество дней, на которое нужно сместить дату @DateFrom.
  DECLARE @DayBias INT = CASE WHEN @CurrDayOfWeek >= @DayNumber
								THEN (7*@WeekAdd) - (@CurrDayOfWeek - @DayNumber)
							    ELSE (7*@WeekAdd) + (@DayNumber - @CurrDayOfWeek)
							  END
  
  RETURN DATEADD(DAY, @DayBias, @DateFrom)
END

