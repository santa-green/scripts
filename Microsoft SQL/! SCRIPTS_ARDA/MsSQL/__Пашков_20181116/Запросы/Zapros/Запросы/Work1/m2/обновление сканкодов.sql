USE OTData_5

SET NOCOUNT ON

PRINT 'Перенос таблички r_ProdMQ во временную таблицу'
SELECT
IDENTITY (INT,1,1) ChID,
ProdID,
'21_кг' AS UM,
1 AS QTy,
0 AS Weight,
NULL AS Notes,
'2107' + CONVERT (VARCHAR, ProdID) AS BarCode,
NULL AS ProdBarCode,
0 AS PLID
INTO _Temp_BarCode3
FROM r_ProdMQ p
WHERE BarCode LIKE '21%' AND LEN (BarCode) = 7 AND ProdiD < 1000 AND PLID = 0

SELECT
IDENTITY (INT,1,1) ChID,
ProdID,
'21_кг' AS UM,
1 AS QTy,
0 AS Weight,
NULL AS Notes,
'210' + CONVERT (VARCHAR, ProdID) AS BarCode,
NULL AS ProdBarCode,
0 AS PLID
INTO _Temp_BarCode4
FROM r_ProdMQ
WHERE BarCode LIKE '21%' AND LEN (BarCode) = 7 AND ProdiD >= 1000 AND ProdiD < 10000 AND PLID = 0

SELECT
IDENTITY (INT,1,1) ChID,
ProdID,
'21_кг' AS UM,
1 AS QTy,
0 AS Weight,
NULL AS Notes,
'21' + CONVERT (VARCHAR, ProdID) AS BarCode,
NULL AS ProdBarCode,
0 AS PLID
INTO _Temp_BarCode5
FROM r_ProdMQ
WHERE BarCode LIKE '21%' AND LEN (BarCode) = 7 AND ProdiD >= 10000 AND PLID = 0

PRINT 'Обновление r_ProdMQ'
DECLARE @I INT ,
	@X INT	
SELECT @I = MAX (ChID)
FROM _Temp_BarCode3
SET  @X = 1
WHILE @X <= @I
BEGIN
INSERT INTO r_ProdMQ
SELECT ProdID, UM, QTy, Weight, Notes, BarCode, ProdBarCode, PLID
FROM _Temp_BarCode3
WHERE _Temp_BarCode3.ChID = @X
SET @X = @X+1
END

SELECT @I = MAX (ChID)
FROM _Temp_BarCode4
SET  @X = 1
WHILE @X <= @I
BEGIN
INSERT INTO r_ProdMQ
SELECT ProdID, UM, QTy, Weight, Notes, BarCode, ProdBarCode, PLID
FROM _Temp_BarCode4
WHERE _Temp_BarCode4.ChID = @X
SET @X = @X+1
END

SELECT @I = MAX (ChID)
FROM _Temp_BarCode5
SET  @X = 1
WHILE @X <= @I
BEGIN
INSERT INTO r_ProdMQ
SELECT ProdID, UM, QTy, Weight, Notes, BarCode, ProdBarCode, PLID
FROM _Temp_BarCode5
WHERE _Temp_BarCode5.ChID = @X
SET @X = @X+1
END

DROP TABLE _Temp_BarCode3
DROP TABLE _Temp_BarCode4
DROP TABLE _Temp_BarCode5

PRINT 'Готово'