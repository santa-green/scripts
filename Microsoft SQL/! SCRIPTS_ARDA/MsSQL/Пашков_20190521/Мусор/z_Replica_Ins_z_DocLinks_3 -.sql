z_Replica_Upd_z_DocLinks_3

	10297213	3	z_Replica_Ins_b_TExp_3 19662,600001808,'75','2017-03-09T00:00:00',27.000000000,9,1,501.140000000,100.250000000,601.390000000,'',63,18,27,0,0,0,0,0,0.000000000,0.000000000,0,11,0,0,0,0,0.000000000,0.000000000,0,0,0.000000000,0.000000000,501.141673340,100.228320000,0.000000000,0.000000000,0.000000000,0.000000000,0.000000000,0.000000000,0.000000000,0.000000000,0.000000000,0.000000000,0,1202	2	Procedure or function z_Replica_Ins_b_TExp_3 has too many arguments specified.	2017-03-23 10:05:00.000
	
	z_replicain
	
		SELECT * FROM [s-sql-d4].elitr.dbo.b_TExp where chid not in (SELECT ChID FROM b_TExp)


SELECT ChID FROM b_TExp

SELECT * FROM 	z_replicain where ExecStr like 'z_Replica_Ins_b_TExp_3%' and Status <> 0


SELECT *  FROM 	z_replicain where ExecStr like 'z_Replica_Ins_b_TExp_3%' and Status <> 0 and (len(ExecStr) - len(replace(ExecStr, ',', '')) + 1) = 47
 
select len(ExecStr) - len(replace(ExecStr, ',', '')) + 1 

SELECT (len(ExecStr) - len(replace(ExecStr, ',', '')) + 1) , * FROM 	z_replicain where ExecStr like 'z_Replica_Ins_b_TExp_3%' and Status <> 1 and (len(ExecStr) - len(replace(ExecStr, ',', '')) + 1) = 47
order by 2

10297220

Cannot insert explicit value for identity column in table 'z_DocLinks' when IDENTITY_INSERT is set to OFF.

DECLARE @S VARCHAR(100)='abc;defg;GETTHIS;hijk;';
WITH Positions AS
(
 SELECT N=ROW_NUMBER()OVER(ORDER BY number),number
 FROM master.dbo.spt_values
 
 WHERE type='P' AND number BETWEEN 1 AND LEN(@S) AND SUBSTRING(@S,number,1)=';'
)
--SELECT * FROM Positions
SELECT SUBSTRING(@S,B.number+1,E.number-B.number-1)
FROM Positions B JOIN Positions E ON B.N=E.N-1
WHERE E.N=3;

SELECT * FROM master.dbo.spt_values WHERE type='P' 

 SELECT N=ROW_NUMBER()OVER(ORDER BY number),number
 FROM master.dbo.spt_values,z_replicain
 WHERE type='P' AND number BETWEEN 1 AND LEN(z_replicain.ExecStr) AND SUBSTRING(z_replicain.ExecStr,number,1)=','
  
go

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

--SELECT * FROM master.dbo.spt_values WHERE type='P' 

DECLARE @joke VARCHAR(256) = '0040095D'

SELECT SUBSTRING(@joke,7,2)+SUBSTRING(@joke,5,2)+SUBSTRING(@joke,3,2)+SUBSTRING(@joke,1,2)
