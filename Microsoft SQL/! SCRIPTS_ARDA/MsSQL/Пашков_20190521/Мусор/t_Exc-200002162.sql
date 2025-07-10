SELECT * FROM t_Exc where DocID = 200002162
200002375

SELECT * FROM t_Exc where ChID = 200002375

SELECT * FROM t_ExcD where ChID = 200002375


SELECT * FROM [s-sql-d4].elitr.dbo.t_Exc where ChID = 200002375

SELECT * FROM [s-sql-d4].elitr.dbo.t_ExcD where ChID = 200002375


SELECT * FROM t_Exc where ChID = 200002375
except
SELECT * FROM [s-sql-d4].elitr.dbo.t_Exc where ChID = 200002375


SELECT * FROM t_ExcD where ChID = 200002375
except
SELECT * FROM [s-sql-d4].elitr.dbo.t_ExcD where ChID = 200002375
except
SELECT * FROM t_ExcD where ChID = 200002375

SELECT * FROM t_ExcD where ChID = 200002375 and SrcPosID in (4,90)
SELECT * FROM [s-sql-d4].elitr.dbo.t_ExcD where ChID = 200002375 and SrcPosID in (4,90)




--insert t_ExcD
SELECT * FROM [s-sql-d4].elitr.dbo.t_ExcD where ChID = 200002375 and SrcPosID in (77)

SELECT * FROM t_pinp where prodid = 801453 and PPID = 50007
--insert t_pinp
SELECT * FROM [s-sql-d4].elitr.dbo.t_pinp where prodid = 801453 and PPID = 50007