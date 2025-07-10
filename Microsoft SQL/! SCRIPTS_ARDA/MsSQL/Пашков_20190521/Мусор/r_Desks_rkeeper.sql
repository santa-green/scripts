SELECT DeskCode, (SELECT DeskName FROM r_Desks rdg WHERE rdg.DeskCode = TS.DeskCode), * FROM t_Sale ts WHERE ts.StockID = 1314
ORDER BY ts.DocDate DESC


SELECT * FROM r_DeskG rdg WHERE DeskGCode IN (113,113,106,113,116,118)


SELECT * FROM r_Desks rdg WHERE DeskGCode IN (113,113,106,113,116,118) ORDER BY DeskGCode


SELECT * FROM r_Desks rdg WHERE DeskCode IN (430,409,50) ORDER BY DeskGCode





SELECT DeskCode, (SELECT DeskName FROM r_Desks rdg WHERE rdg.DeskCode = TS.DeskCode), * FROM t_Sale ts WHERE ts.StockID = 1314 
--AND ts.DeskCode IN (SELECT DeskCode FROM r_Desks rdg WHERE DeskGCode IN (113,113,106,113,116,118) )
ORDER BY ts.DocDate DESC


SELECT DISTINCT DeskCode FROM t_Sale ts WHERE ts.StockID = 1314 AND ts.DeskCode IN (SELECT DeskCode FROM r_Desks rdg WHERE DeskGCode NOT IN (113,113,106,113,116,118) ) 
ORDER BY ts.DocDate DESC
