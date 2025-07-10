use otdata_m2

SET NOCOUNT ON

PRINT ' - Очистка поля Notes в таблице r_ProdMQ'
UPDATE r_ProdMQ
SET Notes = NULL WHERE Notes IS NOT NULL

PRINT ' - Заполнение поля Notes в таблице r_ProdMQ новым скан-кодом'
UPDATE r_ProdMQ
SET Notes = '22' + CONVERT (VARCHAR, ProdID)
WHERE BarCode LIKE '22%' AND LEN (BarCode) = 7 AND PLID = 0 AND ProdID BETWEEN 10000 AND 99999

UPDATE r_ProdMQ
SET Notes = '220' + CONVERT (VARCHAR, ProdID)
WHERE BarCode LIKE '22%' AND LEN (BarCode) = 7 AND PLID = 0 AND ProdID BETWEEN 1000 AND 9999

PRINT ' - Перенос данных во временную таблицу'
SELECT
IDENTITY (INT,1,1) ChID,
ProdID, BarCode, Notes
INTO _Temp_r_ProdMQ
FROM r_ProdMQ
WHERE Notes IS NOT NULL

PRINT ' - Заполнение поля BarCode в таблице r_ProdMQ новым скан-кодом'
DECLARE @I INT ,
	@X INT	
SELECT @I = MAX (ChID)
FROM _Temp_r_ProdMQ
PRINT ' - Обновляется ' + CONVERT (VARCHAR, @I) + ' записей'
SET  @X = 1
WHILE @X <= @I
BEGIN 
PRINT @X
UPDATE r_ProdMQ
SET r_ProdMQ.BarCode = _Temp_r_ProdMQ.Notes
FROM _Temp_r_ProdMQ
WHERE _Temp_r_ProdMQ.ProdID = r_ProdMQ.ProdID AND _Temp_r_ProdMQ.BarCode = r_ProdMQ.BarCode AND _Temp_r_ProdMQ.ChID = @X
SET @X = @X+1
END

PRINT ' - Удаление временных таблиц'
DROP TABLE _Temp_r_ProdMQ

PRINT ' - Очистка поля Notes в таблице r_ProdMQ'
UPDATE r_ProdMQ
SET Notes = NULL WHERE Notes IS NOT NULL

--PRINT '(c) IT-Maks 22/02/2007. Дима, пошли на пиво!!!'