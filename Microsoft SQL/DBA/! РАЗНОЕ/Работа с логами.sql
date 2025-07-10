 USE tempdb;
 GO

 /* ТЕОРИЯ:
 Максимально можно добавить 32767 файлов для одной БД.
 ЖТР состоит из активной части (данные хранятся в RAM) и неактивной (HDD -> хранится информаия о commited trans). Неактивная часть не используется в процессе восстановления БД.
 По умолчанию, ms sql server предлагает полную модель восстановления базы данных (для возможности восстановления вплоть до минуты). В простой модели - только на момент full backup / full+diff backup.
 Усечение (truncate) убирает место внутри файла, но на диске оно остается прежним. Использовать надо DBCC SHRINKFILE.
 Microsoft рекомендует размещать mdf (файл данных) и ldf (лог) файлы на разных дисках для большей скорости работы с данными.
 */
 ALTER DATABASE tempdb ADD LOG FILE
 (
    NAME = templog_extra, --логическое имя
    FILENAME = 'O:\OptimumDB_extra\templog_extra.ldf', --имя файла
    SIZE = 100MB,
    --MAXSIZE = 100GB, --для указания максимального размера "без ограничений" (в студии), нужно просто не указывать этот параметр. (в теории - 2 ТБ для ldf и 16 ТБ для mdf).
    FILEGROWTH = 100MB --дефолтно MB (если не указать единицу измерения); Округляется до ближайших 64 кБ; если указать 0 - размер фиксирован в параметре SIZE; FILEGROWTH < MAXSIZE; если параметр не указан, дефолтно для ms sql server 2008: 10% ldf, 1MB mdf.
 );
 GO

 --проверяем результат добавления:
 SELECT * FROM sys.database_files WHERE [type_desc] = 'LOG';
 SELECT * FROM sys.database_files
 SELECT * FROM sys.master_files WHERE [type_desc] = 'LOG' AND [name] like 'temp%'

 SELECT COUNT(Operation) FROM sys.fn_dblog (NULL, NULL)
 SELECT TOP 10 [End Time], * FROM sys.fn_dblog (NULL, NULL)

 


ALTER DATABASE tempdb MODIFY FILE
 (
    NAME = templog_extra, --логическое имя
    FILENAME = 'O:\OptimumDB_extra\templog_extra.ldf', --имя файла
    --SIZE = 100MB,
    MAXSIZE = 100GB --для указания максимального размера "без ограничений" (в студии), нужно просто не указывать этот параметр. (в теории - 2 ТБ для ldf и 16 ТБ для mdf).
    --FILEGROWTH = 100MB --дефолтно MB (если не указать единицу измерения); Округляется до ближайших 64 кБ; если указать 0 - размер фиксирован в параметре SIZE; FILEGROWTH < MAXSIZE; если параметр не указан, дефолтно для ms sql server 2008: 10% ldf, 1MB mdf.
 );
 GO


 --DBCC SHRINKFILE (templog_extra, 50)

 ALTER DATABASE tempdb MODIFY FILE
 (
    NAME = templog, --логическое имя
    --FILENAME = 'O:\OptimumDB_extra\templog_extra.ldf', --имя файла
    SIZE = 6000MB,
    --MAXSIZE = 100GB, --для указания максимального размера "без ограничений" (в студии), нужно просто не указывать этот параметр. (в теории - 2 ТБ для ldf и 16 ТБ для mdf).
    FILEGROWTH = 100MB --дефолтно MB (если не указать единицу измерения); Округляется до ближайших 64 кБ; если указать 0 - размер фиксирован в параметре SIZE; FILEGROWTH < MAXSIZE; если параметр не указан, дефолтно для ms sql server 2008: 10% ldf, 1MB mdf.
 );
 GO
 DBCC SHRINKFILE (templog, 5000)

 SELECT TOP 100 * FROM tempdb.sys.fn_dblog(NULL, NULL) --ORDER BY [Begin Time] DESC
