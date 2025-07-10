--Посмотреть блокировки [ sp_lock ] --http://isa.darlex.com.ua/index.php/sql-server/3-lock-posmotret-blokirovki
declare @l table(spid int, dbiid int, ObjId int, IndId int, Type varchar(8), Resource varchar(100), Mode varchar(10), Status varchar(50))
declare @lock table(spid int, CountLock int)

 --все блокировки
 insert into @l exec sp_lock 

 --блокировки с количеством объектов >1
insert into @lock select spId, count(*) from @l group by spId having Count(*)>1

 --чья сессия вызвала блокировку более одного объекта
select * from @lock l left join sys.dm_exec_sessions s on l.spid = s.session_id

 --детально по заблокированным объектам
select spid, dbiid, DBNAME = DB_NAME(dbiid) , ObjId, ObjName = OBJECT_NAME(ObjId) , IndId, Type, Resource, Mode, Status
from @l
where spid in (select spid from @lock)
ORDER BY 3
 --select * from sys.dm_exec_sessions

 --kill 142

/*

select * from sys.dm_exec_sessions

--exec sp_who exec sp_who2

*/