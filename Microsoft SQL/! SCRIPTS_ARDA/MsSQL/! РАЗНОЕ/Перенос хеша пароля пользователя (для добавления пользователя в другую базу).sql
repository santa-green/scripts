/*
����� ���������� ������� ������ �������� ������������, �����, � �������, ������������ ���������� ������ GMS �����������, ������� ���������� ����� � ��������� ��� �� ����� ������� � � ����� �� ��� ����� ������������ ���. � ����� ������ ��� �������� ������ ������������ � ������ ���� ������� ������� ��������� ����:

1. � ������� ������� ���� ���������� ��� ������ ������������. ���� ��� ����� ��� ����, ����� ����� �������� ������������ � ����� ����, �� ��������� ������� ������. ��������� ������ ������� ����� ������� ����������. ���������� ��������� ����� ���������.
*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--yaa6 ���� ���� ����������� 0x010036fed70e3e1f5091700ae000411c2e4959d232e88b8d56fd
--mvm 0x010030772de989d8c26bc2832592444efd57a6dd500564aec495
--pva8 0x010031fb1735566caf0c74a7dc07232776a545ca08576c53f1fe

USE master
GO

BEGIN
    DECLARE @UserName NVARCHAR(50) = 'pva8' --�������� ���

    DECLARE @PWD NVARCHAR(max)
    DECLARE @Query NVARCHAR(max)

    SET  @Query = N'SELECT @PWD = dbo.fn_varbintohexstr(cast(l.password as varbinary(256)))  from  master.[dbo].syslogins l WHERE upper(l.name) like upper('''+ @UserName +''')';

    EXEC sp_executesql  @Query, N'@PWD nvarchar(max) out',@PWD = @PWD out;
    PRINT @PWD
END;
/*
2. ��������� ������������ � ������� GMS �������� ������� (������ ������ ����� �������).
3. � ������� ������� ���� ��������������� ������ ������������.
*/
BEGIN
    DECLARE @UserName nvarchar(50) = 'pva8' --������������
    DECLARE @PWD nvarchar(max)

    SET @PWD = '0x010031fb1735566caf0c74a7dc07232776a545ca08576c53f1fe' --�������� ��������� ������ ������� �������
    --�������� ��� --( 0x0100fc1bc3a04bd52946002fac7fcac792c1be38c676f6c6adbd ) ��� ������ smeniparol

    EXEC( 'ALTER LOGIN '+ @UserName+' WITH CHECK_POLICY = OFF');
    EXEC( 'ALTER LOGIN '+ @UserName+' WITH PASSWORD='+@PWD+' HASHED '); 
    EXEC( 'ALTER LOGIN '+ @UserName+' WITH CHECK_POLICY = ON');
END;

--SELECT * FROM master.[dbo].syslogins WHERE name like '%rkv%'
--SELECT * FROM master.[dbo].syslogins WHERE name like '%corp\rumyantsev%'
/*
dbname 	sysname 	Name of the default database of the user when a connection is established.
language 	sysname 	Default language of the user.
hasaccess 	int 	1 = Login has been granted access to the server.
isntname 	int 	1 = Login is a Windows user or group. 0 = Login is a SQL Server login. (isntgroup 	int 	1 = Login is a Windows group. isntuser 	int 	1 = Login is a Windows user.)
*/

--EXEC sp_helptext 'fn_varbintohexstr';
--EXEC sp_helptext 'fn_varbintohexsubstring';
