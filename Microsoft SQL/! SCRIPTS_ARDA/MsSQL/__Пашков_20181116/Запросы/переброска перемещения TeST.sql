DECLARE @docid int , @chid int , @OurID int

SET @OurID = 9 
SET @docid  = 200001929    
SELECT * FROM [s-sql-d4].elitR.dbo.t_Exc
WHERE docid = @docid  and OurID = @OurID 
SELECT * FROM t_Exc
WHERE docid = @docid  AND OurID = @OurID

IF NOT EXISTS ( 
SELECT * FROM t_Exc
WHERE docid = @docid  AND OurID = @OurID )

BEGIN

SELECT @chid = chid FROM [s-sql-d4].elitR.dbo.t_Exc
WHERE docid = @docid  and OurID = @OurID 


ALTER TABLE dbo.t_Exc DISABLE TRIGGER TReplica_Ins_t_Exc
INSERT  t_Exc
SELECT * FROM [s-sql-d4].elitR.dbo.t_Exc
WHERE chid  = @chid
ALTER TABLE dbo.t_Exc ENABLE TRIGGER TReplica_Ins_t_Exc

ALTER TABLE dbo.t_PInP DISABLE TRIGGER TReplica_Ins_t_PInP
INSERT t_PInP
SELECT *
FROM [s-sql-d4].elitR.dbo.t_PInP tp
WHERE exists (SELECT * FROM [s-sql-d4].elitR.dbo.t_ExcD WHERE ChID = @chid  AND ProdID = tp.ProdID AND PPID = tp.PPID)
AND not exists (SELECT * FROM t_PInP WHERE ProdID = tp.ProdID and PPID = tp.PPID)
ALTER TABLE dbo.t_PInP ENABLE TRIGGER TReplica_Ins_t_PInP

ALTER TABLE dbo.t_ExcD DISABLE TRIGGER TReplica_Ins_t_ExcD
INSERT  t_ExcD
SELECT * FROM [s-sql-d4].elitR.dbo.t_ExcD
WHERE chid =  @chid
ALTER TABLE dbo.t_ExcD ENABLE TRIGGER TReplica_Ins_t_ExcD

END
ELSE 
PRINT 'ÄÎÊÓÌÅÍÒ ÑÓÙÅÑÒÂÓÅÒ'


SELECT * FROM t_Exc
WHERE docid = @docid  AND OurID = @OurID