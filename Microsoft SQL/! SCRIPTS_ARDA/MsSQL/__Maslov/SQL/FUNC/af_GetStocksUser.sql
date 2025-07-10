ALTER FUNCTION [dbo].[af_GetStocksUser]()
RETURNS VARCHAR(MAX)
AS
BEGIN
--moa0 17-04-2019 18:09 Переделал функцию под справочник универсальный
/* Получить список складов для пользователя */
	DECLARE @Str VARCHAR(MAX) = ''
	/*
	IF ISNULL(IS_MEMBER('Днепр Экономист'),0) = 1 SELECT @Str = @Str + case when @Str = '' then '' else ',' end + '1200,1201,1203,1204,1205,1256,1257,1327'
	IF ISNULL(IS_MEMBER('Днепр Нагорка'),0) = 1 SELECT @Str = @Str + case when @Str = '' then '' else ',' end + '1257'
	IF ISNULL(IS_MEMBER('Киев Экономист'),0) = 1 SELECT @Str = @Str + case when @Str = '' then '' else ',' end + '1241,1243'
	IF ISNULL(IS_MEMBER('Харьков Экономист'),0) = 1 SELECT @Str = @Str + case when @Str = '' then '' else ',' end + '1252,1245'
	IF ISNULL(IS_MEMBER('Харьков2 ТСД'),0) = 1 SELECT @Str = @Str + case when @Str = '' then '' else ',' end + '1245'

	--IF SUSER_SNAME() = 'const\pashkovv' SET @Str = '1200,1201,1203,1204,1205,1256,1257,1327,1241,1252,1245,1243'
	--IF SUSER_SNAME() = 'pvm0' SET @Str = '1200,1201,1203,1204,1205,1256,1257,1327,1241,1252,1245,1243'
		
	IF SUSER_SNAME() = 'const\pashkovv' SET @Str = ''
	IF SUSER_SNAME() = 'pvm0' SET @Str = ''
	IF SUSER_SNAME() = 'CONST\rumyantsev' SET @Str = ''
	IF SUSER_SNAME() = 'bin2' OR SUSER_SNAME() = 'tester' SELECT @Str = @Str + case when @Str = '' then '' else ',' end + '730'

	IF @Str = '' SET @Str = '0'
	*/
	SELECT @Str = ISNULL( (SELECT CASE  WHEN ISNULL(Notes, '') = '' THEN '' ELSE Notes END FROM r_Uni WHERE RefTypeID = 1000000011 AND (IS_MEMBER(RefName) = 1 OR SUSER_SNAME() = RefName) ), 0)
	--SELECT * FROM r_Uni WHERE RefTypeID = 1000000011
  RETURN @Str
END

GO
