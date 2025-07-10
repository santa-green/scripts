--Сумма размеров баз данных на сервере 
SELECT 'Сумма размеров баз данных на сервере'
SELECT
CONVERT(BIGINT ,SUM(mf.size)) * 8192  as 'size,byte',
CONVERT(dec (15,2),CONVERT(dec (15,2),CONVERT(BIGINT ,SUM(mf.size))) *8*1024/1024/1024 ) as 'size,MB', 
CONVERT(dec (15,2),CONVERT(dec (15,2),CONVERT(BIGINT ,SUM(mf.size))) *8*1024/1024/1024/1024 ) as 'size,GB' 
FROM sys.master_files mf join sys.databases db on db.database_id = mf.database_id


--общий размер баз данных на сервере 
SELECT 'общий размер баз данных на сервере'
SELECT db.name, 
CONVERT(BIGINT ,SUM(mf.size)) * 8192  as 'size,byte',
CONVERT(dec (15,2),CONVERT(dec (15,2),CONVERT(BIGINT ,SUM(mf.size))) *8*1024/1024/1024 ) as 'size,MB', 
CONVERT(dec (15,2),CONVERT(dec (15,2),CONVERT(BIGINT ,SUM(mf.size))) *8*1024/1024/1024/1024 ) as 'size,GB' 
FROM sys.master_files mf
join sys.databases db on db.database_id = mf.database_id
group by db.name
ORDER BY 2


--размер файлов баз данных на сервере
SELECT 'размер файлов баз данных на сервере'
SELECT db.name, mf.physical_name, 
CONVERT(dec (15,2),CONVERT(BIGINT ,mf.size) * 8192)  as 'size,byte', 
CONVERT(dec (15,2),CONVERT(dec (15,2),CONVERT(BIGINT ,mf.size)) * 8192 / 1048576) as 'size,MB', 
CONVERT(dec (15,2),CONVERT(dec (15,2),CONVERT(BIGINT ,mf.size)) * 8192 / 1048576 / 1024) as 'size,GB'
, * FROM sys.master_files mf
join sys.databases db on db.database_id = mf.database_id
ORDER BY 1


--SELECT CheckDateTime,  SUM(size) 'size,8KB' , CONVERT(dec (15,2),CONVERT(dec (15,2),CONVERT(BIGINT ,SUM(size))) *8*1024/1024/1024/1024 ) 'size,GB'  FROM _Log_master_files GROUP BY CheckDateTime ORDER BY 1 desc

SELECT max(CheckDateTime), size_GB FROM (
SELECT CheckDateTime,  CONVERT(dec (15,2),CONVERT(dec (15,2),CONVERT(BIGINT ,SUM(size))) *8*1024/1024/1024/1024 ) 'size_GB'  
FROM _Log_master_files GROUP BY CheckDateTime ) gr
GROUP BY size_GB
ORDER BY 1 desc


SELECT t1.size - t2.size,
db.name, mf.physical_name, mf.file_id,mf.data_space_id ,
CONVERT(dec (15,2),CONVERT(BIGINT ,t1.size) * 8192)  as 't1 size,byte', 
CONVERT(dec (15,2),CONVERT(dec (15,2),CONVERT(BIGINT ,t1.size)) * 8192 / 1048576) as 't1 size,MB', 
CONVERT(dec (15,2),CONVERT(dec (15,2),CONVERT(BIGINT ,t1.size)) * 8192 / 1048576 / 1024) as 't1 size,GB',
CONVERT(dec (15,2),CONVERT(BIGINT ,t2.size) * 8192)  as 't2 size,byte', 
CONVERT(dec (15,2),CONVERT(dec (15,2),CONVERT(BIGINT ,t2.size)) * 8192 / 1048576) as 't2 size,MB', 
CONVERT(dec (15,2),CONVERT(dec (15,2),CONVERT(BIGINT ,t2.size)) * 8192 / 1048576 / 1024) as 't2 size,GB'
FROM [_Log_master_files] t1
full join  [_Log_master_files] t2 on t1.database_id = t2.database_id and t1.file_id = t2.file_id and t1.data_space_id = t2.data_space_id
join sys.master_files mf on mf.database_id = t1.database_id and mf.file_id = t1.file_id and mf.data_space_id = t1.data_space_id
join sys.databases db on db.database_id = mf.database_id
where 
t1.CheckDateTime = '2017-10-06 09:21:39.200' and
t2.CheckDateTime = '2017-10-06 00:01:04.763' 
ORDER BY 1 desc


/*
EXEC master.dbo.xp_FixedDrives

exec xp_cmdshell 'fsutil volume diskfree E:'
exec xp_cmdshell 'fsutil volume diskfree C:'

SELECT size, FILEPROPERTY(name, 'SpaceUsed'), * FROM sys.database_files WHERE file_id=1 AND (size-CAST(FILEPROPERTY(name, 'SpaceUsed') AS int)/128.0)>100

SELECT * FROM sys.database_files


SELECT * FROM sys.databases 
SELECT * FROM sys.master_files 
SELECT * FROM dbo.sysfiles
exec sp_spaceused
2577296
460152

3037448

E
Всего свободно байт           :  16.208617472
Всего байт                    : 375.673315328
C
Всего свободно байт           :   9.707016192
Всего байт                    :  74.792820736

exec sp_spaceused
dbcc shrinkfile (tempdev,45000) --Сокращает размер указанного файла данных в Мб
exec sp_spaceused

dbcc opentran
SELECT db_name(dbid) as db_name,spid,loginame, status,hostname, program_name, nt_domain, nt_username,login_time, last_batch,  * FROM master.dbo.sysprocesses sp
DBCC SQLPERF(LOGSPACE);

--DBCC FREEPROCCACHE
--DBCC DROPCLEANBUFFERS
--DBCC FREESYSTEMCACHE ('ALL')
--DBCC FREESESSIONCACHE

SELECT name ,size/128.0 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS int)/128.0 AS AvailableSpaceInMB
FROM sys.database_files;

SELECT 
	o.name,
	SUM (p.reserved_page_count) * 8 as reservedpages,
	SUM (p.used_page_count) * 8 as usedpages,
	SUM (
		CASE
			WHEN (p.index_id < 2) THEN (p.in_row_data_page_count + p.lob_used_page_count + p.row_overflow_used_page_count)
			ELSE p.lob_used_page_count + p.row_overflow_used_page_count
		END
		) as pages,
	SUM (
		CASE
			WHEN (p.index_id < 2) THEN p.row_count
			ELSE 0
		END
		) as [rowCount]
FROM sys.dm_db_partition_stats p
	join sys.objects as o
		on o.object_id = p.object_id
		and o.type = 'U'
group by o.name
order by reservedpages desc


select db_name(sa.dbid) as DBname 
	, sa.name as LogicalName
	, case sa.groupid
		WHEN 0 then 'LOG'
		ELSE sfg.groupname
	  end as Filegroup
	, sa.filename as Filename
	, cast(sf.size*8/1024. as numeric(19,3))as sizeMB
	, cast(sf.spaceused*8/1024. as numeric(19,3)) as spaceusedMB
	, cast((sf.size-sf.spaceused)*8/1024. as numeric(19,3)) as freespaceMB
	, case sf.maxsize
		when -1 then 'Unlimited'
		else cast(cast(sf.maxsize*8/1024.  as numeric(19,3))as varchar(22))
	  end as maxsizeMB
	, cast(sf.growth*8/1024. as numeric(19,3)) as nextgrowthMB
from master..sysaltfiles sa 
left join (
	select   cast(size as bigint) as size
			,fileid
			,groupid
			,cast(fileproperty(name,'SpaceUsed')as bigint) as spaceused 
			,cast(maxsize as bigint) as maxsize
			,cast(case 
				when status & 0x100000 = 0 then growth
				else size*growth/100
			 end as bigint) as growth
	from sysfiles
	) sf on sf.fileid=sa.fileid 
		and sf.groupid = sa.groupid
left outer join sysfilegroups sfg on sfg.groupid = sf.groupid
where sa.dbid = db_id()
order by case when sa.groupid = 0 then 1 else 0 end, sa.groupid, sa.fileid


*/