 USE tempdb;
 GO

 /* ������:
 ����������� ����� �������� 32767 ������ ��� ����� ��.
 ��� ������� �� �������� ����� (������ �������� � RAM) � ���������� (HDD -> �������� ��������� � commited trans). ���������� ����� �� ������������ � �������� �������������� ��.
 �� ���������, ms sql server ���������� ������ ������ �������������� ���� ������ (��� ����������� �������������� ������ �� ������). � ������� ������ - ������ �� ������ full backup / full+diff backup.
 �������� (truncate) ������� ����� ������ �����, �� �� ����� ��� �������� �������. ������������ ���� DBCC SHRINKFILE.
 Microsoft ����������� ��������� mdf (���� ������) � ldf (���) ����� �� ������ ������ ��� ������� �������� ������ � �������.
 */
 ALTER DATABASE tempdb ADD LOG FILE
 (
    NAME = templog_extra, --���������� ���
    FILENAME = 'O:\OptimumDB_extra\templog_extra.ldf', --��� �����
    SIZE = 100MB,
    --MAXSIZE = 100GB, --��� �������� ������������� ������� "��� �����������" (� ������), ����� ������ �� ��������� ���� ��������. (� ������ - 2 �� ��� ldf � 16 �� ��� mdf).
    FILEGROWTH = 100MB --�������� MB (���� �� ������� ������� ���������); ����������� �� ��������� 64 ��; ���� ������� 0 - ������ ���������� � ��������� SIZE; FILEGROWTH < MAXSIZE; ���� �������� �� ������, �������� ��� ms sql server 2008: 10% ldf, 1MB mdf.
 );
 GO

 --��������� ��������� ����������:
 SELECT * FROM sys.database_files WHERE [type_desc] = 'LOG';
 SELECT * FROM sys.database_files
 SELECT * FROM sys.master_files WHERE [type_desc] = 'LOG' AND [name] like 'temp%'

 SELECT COUNT(Operation) FROM sys.fn_dblog (NULL, NULL)
 SELECT TOP 10 [End Time], * FROM sys.fn_dblog (NULL, NULL)

 


ALTER DATABASE tempdb MODIFY FILE
 (
    NAME = templog_extra, --���������� ���
    FILENAME = 'O:\OptimumDB_extra\templog_extra.ldf', --��� �����
    --SIZE = 100MB,
    MAXSIZE = 100GB --��� �������� ������������� ������� "��� �����������" (� ������), ����� ������ �� ��������� ���� ��������. (� ������ - 2 �� ��� ldf � 16 �� ��� mdf).
    --FILEGROWTH = 100MB --�������� MB (���� �� ������� ������� ���������); ����������� �� ��������� 64 ��; ���� ������� 0 - ������ ���������� � ��������� SIZE; FILEGROWTH < MAXSIZE; ���� �������� �� ������, �������� ��� ms sql server 2008: 10% ldf, 1MB mdf.
 );
 GO


 --DBCC SHRINKFILE (templog_extra, 50)

 ALTER DATABASE tempdb MODIFY FILE
 (
    NAME = templog, --���������� ���
    --FILENAME = 'O:\OptimumDB_extra\templog_extra.ldf', --��� �����
    SIZE = 6000MB,
    --MAXSIZE = 100GB, --��� �������� ������������� ������� "��� �����������" (� ������), ����� ������ �� ��������� ���� ��������. (� ������ - 2 �� ��� ldf � 16 �� ��� mdf).
    FILEGROWTH = 100MB --�������� MB (���� �� ������� ������� ���������); ����������� �� ��������� 64 ��; ���� ������� 0 - ������ ���������� � ��������� SIZE; FILEGROWTH < MAXSIZE; ���� �������� �� ������, �������� ��� ms sql server 2008: 10% ldf, 1MB mdf.
 );
 GO
 DBCC SHRINKFILE (templog, 5000)

 SELECT TOP 100 * FROM tempdb.sys.fn_dblog(NULL, NULL) --ORDER BY [Begin Time] DESC
