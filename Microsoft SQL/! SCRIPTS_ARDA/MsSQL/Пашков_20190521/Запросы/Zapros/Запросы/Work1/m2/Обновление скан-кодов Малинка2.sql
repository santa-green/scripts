use otdata_m2

SET NOCOUNT ON

PRINT ' - ������� ���� Notes � ������� r_ProdMQ'
UPDATE r_ProdMQ
SET Notes = NULL WHERE Notes IS NOT NULL

PRINT ' - ���������� ���� Notes � ������� r_ProdMQ ����� ����-�����'
UPDATE r_ProdMQ
SET Notes = '22' + CONVERT (VARCHAR, ProdID)
WHERE BarCode LIKE '22%' AND LEN (BarCode) = 7 AND PLID = 0 AND ProdID BETWEEN 10000 AND 99999

UPDATE r_ProdMQ
SET Notes = '220' + CONVERT (VARCHAR, ProdID)
WHERE BarCode LIKE '22%' AND LEN (BarCode) = 7 AND PLID = 0 AND ProdID BETWEEN 1000 AND 9999

PRINT ' - ������� ������ �� ��������� �������'
SELECT
IDENTITY (INT,1,1) ChID,
ProdID, BarCode, Notes
INTO _Temp_r_ProdMQ
FROM r_ProdMQ
WHERE Notes IS NOT NULL

PRINT ' - ���������� ���� BarCode � ������� r_ProdMQ ����� ����-�����'
DECLARE @I INT ,
	@X INT	
SELECT @I = MAX (ChID)
FROM _Temp_r_ProdMQ
PRINT ' - ����������� ' + CONVERT (VARCHAR, @I) + ' �������'
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

PRINT ' - �������� ��������� ������'
DROP TABLE _Temp_r_ProdMQ

PRINT ' - ������� ���� Notes � ������� r_ProdMQ'
UPDATE r_ProdMQ
SET Notes = NULL WHERE Notes IS NOT NULL

--PRINT '(c) IT-Maks 22/02/2007. ����, ����� �� ����!!!'