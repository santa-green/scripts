

SELECT CheckDateTime,  SUM(size) 'size,8KB' , CONVERT(dec (15,2),CONVERT(dec (15,2),CONVERT(BIGINT ,SUM(size))) *8*1024/1024/1024/1024 ) 'size,GB'  FROM _Log_master_files GROUP BY CheckDateTime ORDER BY 1 desc

SELECT database_id, file_id, data_space_id, size,  CONVERT(dec (15,2),CONVERT(dec (15,2),CONVERT(BIGINT ,size)) *8*1024/1024/1024/1024 ) 'size,GB' FROM [_Log_master_files] where CheckDateTime = '2017-09-20 22:02:13.760'
--except
SELECT database_id, file_id, data_space_id, size,  CONVERT(dec (15,2),CONVERT(dec (15,2),CONVERT(BIGINT ,size)) *8*1024/1024/1024/1024 ) 'size,GB' FROM [_Log_master_files] where CheckDateTime = '2017-09-20 21:59:32.027'


SELECT * FROM [_Log_master_files] where CheckDateTime = '2017-09-20 17:26:03.050'

SELECT * FROM [_Log_master_files] ORDER BY 1 desc


SELECT CheckDateTime,  SUM(size) 'size,8KB' , CONVERT(dec (15,2),CONVERT(dec (15,2),CONVERT(BIGINT ,SUM(size))) *8*1024/1024/1024/1024 ) 'size,GB'  FROM _Log_master_files GROUP BY CheckDateTime ORDER BY 1

--предпоследн€€ дата
SELECT top 1 CheckDateTime FROM (SELECT CheckDateTime,  SUM(size) size FROM _Log_master_files GROUP BY CheckDateTime ) gr 
where size <> 
(
SELECT size FROM (SELECT CheckDateTime,  SUM(size) size FROM _Log_master_files where CheckDateTime = (SELECT max(CheckDateTime) FROM [_Log_master_files]) GROUP BY CheckDateTime ) gr 
) ORDER BY CheckDateTime desc

--последн€€ дата 
SELECT max(CheckDateTime) FROM [_Log_master_files]


SELECT max(CheckDateTime) FROM [_Log_master_files] where CheckDateTime <> (SELECT max(CheckDateTime) FROM [_Log_master_files]) 

SELECT max(CheckDateTime) FROM [_Log_master_files]
SELECT max(CheckDateTime) FROM [_Log_master_files] where CheckDateTime <> (SELECT max(CheckDateTime) FROM [_Log_master_files]) 



SELECT database_id, file_id, data_space_id, size FROM [_Log_master_files] where CheckDateTime = (SELECT max(CheckDateTime) FROM [_Log_master_files])
--except
SELECT database_id, file_id, data_space_id, size FROM [_Log_master_files] where CheckDateTime = (SELECT max(CheckDateTime) FROM [_Log_master_files] where CheckDateTime <> (SELECT max(CheckDateTime) FROM [_Log_master_files]))

SELECT db.name, mf.physical_name, 
CONVERT(dec (15,2),CONVERT(BIGINT ,mf.size) * 8192)  as 'size,byte', 
CONVERT(dec (15,2),CONVERT(dec (15,2),CONVERT(BIGINT ,mf.size)) * 8192 / 1048576) as 'size,MB', 
CONVERT(dec (15,2),CONVERT(dec (15,2),CONVERT(BIGINT ,mf.size)) * 8192 / 1048576 / 1024) as 'size,GB'
, * FROM sys.master_files mf
join sys.databases db on db.database_id = mf.database_id
where mf.database_id = 5 and mf.file_id = 1 and mf.data_space_id = 1
ORDER BY 1


SELECT * FROM [_Log_master_files] mf where mf.database_id = 5 and mf.file_id = 1 and mf.data_space_id = 1




SELECT (SELECT top 1  max(CheckDateTime) FROM [_Log_master_files] lmf where lmf.database_id = ex.database_id and  lmf.file_id = ex.file_id and  lmf.data_space_id = ex.data_space_id and  lmf.size = ex.size)
, db.name, CONVERT(dec (15,2),CONVERT(dec (15,2),CONVERT(BIGINT ,ex.size)) * 8192 / 1048576) as 'size,MB', ex.database_id, ex.file_id, ex.data_space_id FROM (

SELECT database_id, file_id, data_space_id, size FROM [_Log_master_files] where CheckDateTime = (SELECT max(CheckDateTime) FROM [_Log_master_files])
except
SELECT database_id, file_id, data_space_id, size FROM [_Log_master_files] where CheckDateTime = 
(SELECT top 1 CheckDateTime FROM (SELECT CheckDateTime,  SUM(size) size FROM _Log_master_files GROUP BY CheckDateTime ) gr 
where size <> 
(
SELECT size FROM (SELECT CheckDateTime,  SUM(size) size FROM _Log_master_files where CheckDateTime = (SELECT max(CheckDateTime) FROM [_Log_master_files]) GROUP BY CheckDateTime ) gr 
) ORDER BY CheckDateTime desc )
 
) ex
join sys.databases db on db.database_id = ex.database_id



SELECT (SELECT top 1  max(CheckDateTime) FROM [_Log_master_files] lmf where lmf.database_id = ex.database_id and  lmf.file_id = ex.file_id and  lmf.data_space_id = ex.data_space_id and  lmf.size = ex.size)
, db.name, CONVERT(dec (15,2),CONVERT(dec (15,2),CONVERT(BIGINT ,ex.size)) * 8192 / 1048576) as 'size,MB', ex.database_id, ex.file_id, ex.data_space_id FROM (

SELECT CheckDateTime,database_id, file_id, data_space_id, size FROM [_Log_master_files] where CheckDateTime = (SELECT max(CheckDateTime) FROM [_Log_master_files])
except
SELECT CheckDateTime,database_id, file_id, data_space_id, size FROM [_Log_master_files] where CheckDateTime = 
(SELECT top 1 CheckDateTime FROM (SELECT CheckDateTime,  SUM(size) size FROM _Log_master_files GROUP BY CheckDateTime ) gr 
where size <> 
(
SELECT size FROM (SELECT CheckDateTime,  SUM(size) size FROM _Log_master_files where CheckDateTime = (SELECT max(CheckDateTime) FROM [_Log_master_files]) GROUP BY CheckDateTime ) gr 
) ORDER BY CheckDateTime desc )
 
) ex
join sys.databases db on db.database_id = ex.database_id




SELECT CheckDateTime,database_id, file_id, data_space_id, size FROM [_Log_master_files] where CheckDateTime = 
(SELECT top 1 CheckDateTime FROM (SELECT CheckDateTime,  SUM(size) size FROM _Log_master_files GROUP BY CheckDateTime ) gr 
where size <> 
(
SELECT size FROM (SELECT CheckDateTime,  SUM(size) size FROM _Log_master_files where CheckDateTime = (SELECT max(CheckDateTime) FROM [_Log_master_files]) GROUP BY CheckDateTime ) gr 
) ORDER BY CheckDateTime desc )
except
SELECT CheckDateTime,database_id, file_id, data_space_id, size FROM [_Log_master_files] where CheckDateTime = (SELECT max(CheckDateTime) FROM [_Log_master_files])
