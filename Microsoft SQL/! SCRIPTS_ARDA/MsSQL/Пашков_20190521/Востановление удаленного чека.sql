SELECT * FROM t_Sale m
JOIN t_SaleD d ON d.ChID = m.ChID
JOIN r_Prods p ON p.ProdID = d.ProdID
WHERE m.ChiD = 1600002260
ORDER BY 1


select ReplicaEventID, ReplicaSubCode, ExecStr as 'ЦЕНТРАЛЬНЫЙ СЕРВЕР, Днепр [S-SQL-D4].ElitR 10.1.0.155', Status, Msg, DocTime 
from [s-sql-d4].elitr.dbo.z_ReplicaIn WITH (NOLOCK) where status = 1 
and ExecStr like '%1600002260%'
ORDER BY ReplicaEventID  OPTION (FAST 1)




BEGIN TRAN


--востановление чека
DECLARE @ReplicaEventID INT, @ExecStr varchar(2000)
DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD
FOR 
	select ReplicaEventID, ExecStr
	from [s-sql-d4].elitr.dbo.z_ReplicaIn WITH (NOLOCK) where status = 1 
	and ExecStr like '%1600002260%'
	 
	--для исключения строчки с z_Replica_Ins_t_MonRec
	--and ReplicaEventID not in (61024)
	
	ORDER BY ReplicaEventID

OPEN CURSOR1
	FETCH NEXT FROM CURSOR1 
	INTO @ReplicaEventID, @ExecStr
WHILE @@FETCH_STATUS = 0
BEGIN
	--Script
	EXEC(@ExecStr) 
	FETCH NEXT FROM CURSOR1 
	INTO @ReplicaEventID, @ExecStr
END
CLOSE CURSOR1
DEALLOCATE CURSOR1


SELECT * FROM t_Sale m
JOIN t_SaleD d ON d.ChID = m.ChID
JOIN r_Prods p ON p.ProdID = d.ProdID
WHERE m.ChiD = 1600002260
ORDER BY 1


ROLLBACK TRAN