--=====================================================================
-- Author: moa0;
-- Create date: '2019-10-07 09:34:35.141'
-- Desription: ���������� ���� ���������� ��� �� ��������� ������.
--=====================================================================
ALTER FUNCTION [dbo].[af_GetDateOfDayInDependenceFromWeek] (@DateFrom SMALLDATETIME, @DayNumber INT, @WeekAdd INT)
RETURNS SMALLDATETIME
AS
BEGIN
/*
SELECT dbo.af_GetDateOfDayInDependenceFromWeek('20191010',6,3)
*/
/*
������� ���������� ���� ��� ������ �� ��������� �� ������.
@DateFrom - ���� �� ������� ����� ���������� ������;
@DayNumber - ���������� ����� ��� ������. � ����������� �� ���������� �������
			 ����� ����� ������. � ������� � ���������� ������ ���� ������
			 ��������� ������������, ����� ��� ����� ����� 1;
@WeekAdd - �������� ������. � ������� 1 - ��� ����� ������ �� ��������� ����.
		   -1 - ��� �� ������� ������.

������.
����� �������� ���� ���������� �������� (������� ������ ����, ������ 2). �������
"11.10.2019". ����� ����� ������� ����� ��������� ���:
SELECT dbo.af_GetDateOfDayInDependenceFromWeek('20191011',2,1)
*/

  --���� ���-�� ������� ������� �� ���������� ����� ��� ������, �� ������ ��� ���� � ���.
  IF @DayNumber NOT BETWEEN 1 AND 7
  BEGIN
	RETURN @DateFrom
  END;
  
  --��������� ����������.
  /*
  ��������� ������� ���� ������, � �������� �� ��, ��� ������ ���������� � ������������.
  ��� ����� ������ ��� ����������� ������� "SET DATEFIRST 1" �� �������� (�� ��������, 
  ������� �������� ������ ������������� � ������).
  */
									--���� ��������, ������� ��������� �� ���� ������ ������ ����������,
									--��� ������ ���������� � ������������.
  DECLARE @CurrDayOfWeek INT = CASE WHEN @@DATEFIRST = 1
										THEN DATEPART(WEEKDAY, @DateFrom)
									--���� ��������, ������� ��������� �� ���� ������ ������ ����������,
									--��� ������ ���������� � ����������� � ������� �����������.
									WHEN DATEPART(WEEKDAY, @DateFrom) = 1 AND @@DATEFIRST = 7
										THEN 7
									--���� ��������, ������� ��������� �� ���� ������ ������ ����������,
									--��� ������ ���������� � �����������, �� �������� 1, ����� ��������
									--������ ������.
									WHEN DATEPART(WEEKDAY, @DateFrom) > 1 AND @@DATEFIRST = 7
										THEN DATEPART(WEEKDAY, @DateFrom) - 1 
									END
  --��������� ���������� ����, �� ������� ����� �������� ���� @DateFrom.
  DECLARE @DayBias INT = CASE WHEN @CurrDayOfWeek >= @DayNumber
								THEN (7*@WeekAdd) - (@CurrDayOfWeek - @DayNumber)
							    ELSE (7*@WeekAdd) + (@DayNumber - @CurrDayOfWeek)
							  END
  
  RETURN DATEADD(DAY, @DayBias, @DateFrom)
END

