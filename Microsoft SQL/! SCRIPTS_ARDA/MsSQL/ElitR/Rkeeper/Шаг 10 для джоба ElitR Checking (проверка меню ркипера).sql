USE ElitR

--��� "�������� ���� Rkeeper", ���������� 1 ���/����: 08:00-09:00.
/*HISTORY*/
--���� �����...

IF (CONVERT (time, GETDATE()) > '08:00:00'  AND CONVERT (time, GETDATE()) < '08:59:00')

BEGIN

    --������� ������������ ���� Log_Checks.txt.
    EXEC master..xp_cmdshell 'IF EXIST \\s-sql-d4\OT38ElitServer\Import\R_keeper\Log_Checks.txt (del \\s-sql-d4\OT38ElitServer\Import\R_keeper\Log_Checks.txt)'
    --���������� Log_Checks.txt � \\s-sql-d4\OT38ElitServer\Import\R_keeper\ � ���������� ����������.
    EXEC master..xp_cmdshell  'sqlcmd -u -i "\\S-elit-dp\F\! SCRIPTS\Rkeeper\!�������� ���� �������.sql"   -E -S s-sql-d4 | "%systemroot%\system32\mshta.exe" "javascript:try { var objFSO = new ActiveXObject(''Scripting.FileSystemObject''); with (new ActiveXObject(''ADODB.Stream'')) { Type = 2; Mode = 3; Open(); Charset = ''windows-1251''; WriteText(objFSO.GetStandardStream(0).ReadAll()); Position = 0; Charset = ''cp866''; objFSO.GetStandardStream(1).Write(ReadText()); Close() } } catch (e){}; close();" 1 > "\\s-sql-d4\OT38ElitServer\Import\R_keeper\Log_Checks.txt"'

	DECLARE @File nvarchar(max), @subject nvarchar(max), @checkresult nvarchar(200), @importance nvarchar(10)

    --���������� ������ �����.
    DECLARE @t TABLE([output] nvarchar(200))
    INSERT INTO @t
    EXEC master..xp_cmdshell 'powershell.exe "Get-ChildItem -Path \\s-sql-d4\OT38ElitServer\Import\R_keeper\Log_Checks.txt | %{$_.Length}";'
    SELECT * FROM @t WHERE output IS NOT NULL
/*    --������ ��������� �� ������� ����� (���������� ������� ����� sql).
    DECLARE @s TABLE(size nvarchar(200))
    INSERT INTO @s
    SELECT LEFT(RTRIM(LTRIM(REPLACE([output], '1 ������', ''))),len(LTRIM(REPLACE([output], '1 ������', '')))-5) AS 'Size' FROM @t WHERE CHARINDEX('1 ������', [output]) > 0

    SELECT * FROM @s
    SELECT CAST(REPLACE((SELECT * FROM @s),' ','') AS INT)
    SELECT CAST(REPLACE('20 055',' ','') AS INT)
*/

    IF (SELECT * FROM @t WHERE output IS NOT NULL) BETWEEN 350 AND 370 
        BEGIN
            SET @checkresult = 'OK: ����������� ����� Rkeeper � �������� �� ����������.'
            SET @importance  = 'low'
        END;
        ELSE
        BEGIN
	        SET @checkresult = '��������! ���������� ����������� ����� Rkeeper � ��������!'
            SET @importance  = 'high'
        END;

        select @checkresult

    SET @File = N' ��� ����� ���������� �����: \\s-sql-d4\OT38ElitServer\Import\R_keeper\LogChecks.txt'

    SET @subject = 'Rkeeper ���-����: ' + CONVERT(varchar(10), GETDATE(), 112) + ' ' + LEFT(CAST(getdate() AS time),5) + ' >> ' + @checkresult
    
    --���������� ������
	    BEGIN

		    DECLARE @body_str nvarchar(max) = '���������� [S-SQL-D4] JOB ElitR Checking ��� 10 (�������� ���� Rkeeper)' + char(10) + char(13) + @File

		    EXEC msdb.dbo.sp_send_dbmail  
		     @profile_name = 'main'
		    ,@recipients = 'support_arda@const.dp.ua'--'rumyantsev@const.dp.ua'
		    ,@subject = @subject
		    ,@body = @body_str
		    ,@body_format = 'TEXT'
		    ,@importance = @importance

	    END

END

