DECLARE @joke VARCHAR(256) = '0040095D'

SELECT SUBSTRING(@joke,7,2)+SUBSTRING(@joke,5,2)+SUBSTRING(@joke,3,2)+SUBSTRING(@joke,1,2)

DECLARE @S VARCHAR(100) = '0009405d'
DECLARE @HexRevers VARCHAR(100) = ''
;WITH Positions AS
(
 SELECT N=ROW_NUMBER()OVER(ORDER BY number),SUBSTRING(@S,number,2) s,number%2 mod
 FROM master.dbo.spt_values
 WHERE type='P' AND number BETWEEN 1 AND LEN(@S) AND number%2 = 1
)
--SELECT * FROM Positions
SELECT @HexRevers = @HexRevers + s FROM Positions ORDER BY n desc

SELECT @HexRevers