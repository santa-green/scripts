use ElitR
select '' as '÷≈Ќ“–јЋ№Ќџ… —≈–¬≈–, ƒнепр [S-SQL-D4].ElitR 10.1.0.155', ReplicaEventID, ReplicaSubCode, ExecStr, Status, Msg, DocTime 
from [s-sql-d4].elitr.dbo.z_ReplicaIn WITH (NOLOCK) where status != 1 ORDER BY ReplicaEventID  OPTION (FAST 1)
GO
select '' as 'ƒнепр, локальный сервер [S-MARKETA].ElitV_DP 192.168.70.2', ReplicaEventID, ReplicaSubCode, ExecStr, Status, Msg, DocTime 
from [S-VINTAGE].[ElitRTS501].dbo.z_replicain WITH (NOLOCK) where status != 1 ORDER BY ReplicaEventID  OPTION (FAST 1)
GO
--select ReplicaEventID, ReplicaSubCode, ExecStr as ' иев, локальный сервер [S-MARKETA2].ElitV_KIEV 192.168.74.3', Status, Msg, DocTime 
--from [s-marketa2].elitv_kiev.dbo.z_replicain WITH (NOLOCK) where status != 1  ORDER BY ReplicaEventID  OPTION (FAST 1)
--GO
select '' as 's-marketa3', *,'[s-marketa3].ElitRTS301.dbo.z_replicain' from [s-marketa3].ElitRTS301.dbo.z_replicain WITH (NOLOCK) where status != 1 --Harkov
order by replicaeventid  OPTION (FAST 1)
GO
select '' as 's-marketa4', *, '[s-marketa4].ElitRTS181.dbo.z_replicain' from [s-marketa4].ElitRTS181.dbo.z_replicain WITH (NOLOCK) where status != 1 --nagorka
order by replicaeventid  OPTION (FAST 1)
GO
/*
select '' as 's-marketa5', * from [192.168.22.21].ElitRTS401.dbo.z_replicain WITH (NOLOCK) where status != 1 --Odessa 192.168.22.21
order by replicaeventid  OPTION (FAST 1)
GO
select '' as 'CP1_DP', * from [CP1_DP].[ElitCP1].[dbo].[z_ReplicaIn] WITH (NOLOCK) where status != 1 --CofePoint DP 192.168.42.6
order by replicaeventid  OPTION (FAST 1)
GO
*/
--select '' as 'ElitRTS201', *,'[192.168.174.30].ElitRTS201.dbo.z_replicain' from [192.168.174.30].ElitRTS201.dbo.z_replicain WITH (NOLOCK) where status != 1 
--order by replicaeventid  OPTION (FAST 1)
--GO
select '' as 'ElitRTS302', *, '[192.168.157.22].ElitRTS302.dbo.z_replicain' from [192.168.157.22].ElitRTS302.dbo.z_replicain WITH (NOLOCK) where status != 1 
order by replicaeventid  OPTION (FAST 1)
GO
--select '' as 'ElitRTS220', *,'[192.168.174.38].ElitRTS220.dbo.z_replicain' from [192.168.174.38].ElitRTS220.dbo.z_replicain WITH (NOLOCK) where status != 1 
--order by replicaeventid  OPTION (FAST 1)
--GO
select '' as 'FFood601', *,'[192.168.42.6].FFood601.dbo.z_replicain' from [192.168.42.6].FFood601.dbo.z_replicain WITH (NOLOCK) where status != 1 
order by replicaeventid  OPTION (FAST 1)
GO
--select '' as 'ElitRTS222', * from [192.168.174.32].ElitRTS222.dbo.z_replicain WITH (NOLOCK) where status != 1 
--order by replicaeventid  OPTION (FAST 1)

/*
==================================================================

--1. лечение. пропусть эту реплику
update z_replicain 
set status = 1
--where status != 1 and ReplicaEventID in (13)
where ReplicaEventID IN (212,225)


SELECT * FROM z_replicain
--where status != 1 and ReplicaEventID <= 977135 AND ReplicaEventID >= 970345
--where status != 1 and ReplicaEventID = 18 AND ReplicaEventID >= 975729
where ReplicaEventID IN (18,24,46)
ORDER BY 1
==================================================================

--1. лечение. пропусть эту реплику на сетевом сервере 
update [s-marketa].elitv_dp.dbo.z_replicain set status = 1 where status != 1 and ReplicaEventID in (17922396)
update [s-marketa3].ElitRTS301.dbo.z_replicain set status = 1 where status != 1 and ReplicaEventID in (17922396)
update [s-marketa4].ElitRTS181.dbo.z_replicain set status = 1 where status != 1 and ReplicaEventID in (17922396)
update [192.168.174.30].ElitRTS201.dbo.z_replicain set status = 1 where status != 1 and ReplicaEventID in (17922396)
update [192.168.157.22].ElitRTS302.dbo.z_replicain set status = 1 where status != 1 and ReplicaEventID in (17922396)
update [192.168.174.38].ElitRTS220.dbo.z_replicain set status = 1 where status != 1 and ReplicaEventID in (17922396)
update [192.168.42.6].FFood601.dbo.z_replicain set status = 1 where status != 1 and ReplicaEventID in (17922396)
==================================================================

--2. лечение. пропусть реплики по условию
--поиск репликций
DECLARE @s nvarchar(100) = 'z_Replica_Ins_z_LogDiscRec_1600000000 324538'
select  * from z_ReplicaIn where status != 10 
and ExecStr like @s + '%'
order by replicaeventid 

--»зменение статуса на 1 дл€ отмены репликации
update z_replicain 
set status = 1
where status != 1 and ExecStr like @s + '%'

==================================================================

--3. лечение. пропусть реплики по условию
select  * from z_ReplicaIn 
where status != 1 and replicaeventid between 4526 and 4997
order by replicaeventid 

--»зменение статуса на 1 дл€ отмены репликации
update z_replicain 
set status = 1
where status != 1 and replicaeventid between 4526 and 4997

==================================================================
*/

/*
--киев ElitRTS220 192.168.174.38
--ќбновить статусы репликаций которые уже были обработаны 

SELECT * FROM z_replicain
where status != 1 
and ReplicaSubCode = 1600000000
and ReplicaEventID in (SELECT ReplicaEventID FROM [192.168.174.38].ElitRTS220.dbo.z_ReplicaOut WITH (NOLOCK) where status = 1)


update z_replicain 
set status = 1
where status != 1 
and ReplicaSubCode = 1600000000
and ReplicaEventID in (SELECT ReplicaEventID FROM [192.168.174.38].ElitRTS220.dbo.z_ReplicaOut WITH (NOLOCK) where status = 1)

*/

/*
--киев ElitRTS201 192.168.174.30
--ќбновить статусы репликаций которые уже были обработаны 

SELECT * FROM z_replicain
where status != 1 
and ReplicaSubCode = 800000000
and ReplicaEventID in (SELECT ReplicaEventID FROM [192.168.174.30].ElitRTS201.dbo.z_ReplicaOut WITH (NOLOCK) where status != 1)


update z_replicain 
set status = 1
where status != 1 
and ReplicaSubCode = 800000000
and ReplicaEventID in (SELECT ReplicaEventID FROM [192.168.174.30].ElitRTS201.dbo.z_ReplicaOut WITH (NOLOCK) where status = 1)

*/

/*
SELECT * FROM z_replicain
where status != 1 
and ReplicaSubCode = 800000000
and ReplicaEventID <= 538645


update z_replicain 
set status = 1
where status != 1 
and ReplicaSubCode = 800000000
and ReplicaEventID <= 538645

*/

/*
select ReplicaEventID, ReplicaSubCode, ExecStr as '÷≈Ќ“–јЋ№Ќџ… —≈–¬≈–, ƒнепр [S-SQL-D4].ElitR 10.1.0.155', Status, Msg, DocTime 
from [s-sql-d4].elitr.dbo.z_ReplicaIn WITH (NOLOCK) where status = 1 
and ReplicaSubCode = 800000000
ORDER BY ReplicaEventID  OPTION (FAST 1)


SELECT * FROM t_Sale
WHERE DocDate >= '20190330' AND DocDate <= '20190331' AND StockID = 1314

SELECT * FROM r_Codes3
WHERE CodeID3 IN (19, 27, 70,83, 73, 78, 81, 82, 84,  91, 92, 93, 94,95) --,89)


SELECT * FROM t_Sale
WHERE DocDate >= '20190228' AND DocDate <= '20190331' AND StockID = 1314
ORDER BY 3


SELECT ChID, DocID, DocDate, OurID, StockID, CompID, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, CRID, TRealSum
FROM t_Sale
WHERE DocDate = '20190331' 
AND StockID = 1314 and crid = 154



SELECT * FROM t_Sale
WHERE DocDate = '20190330' 
AND StockID = 1202 and crid = 104


SELECT * FROM r_CRs

*/