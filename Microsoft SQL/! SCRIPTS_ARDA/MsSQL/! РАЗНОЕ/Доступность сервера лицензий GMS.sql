IF OBJECT_ID('tempdb..#temp', 'U') IS NOT NULL DROP TABLE #temp
CREATE TABLE #temp (output varchar(max))
INSERT INTO #temp EXEC xp_cmdshell 'powershell.exe "Test-NetConnection -ComputerName 10.1.0.36 -Port 10502 -InformationLevel Quiet"'
SELECT * FROM #temp
DECLARE @subject nvarchar(max) = '�������� ������� �������� GMS: s-gms-lics.const.alef.ua';

--������� ���.
/*
IF OBJECT_ID('Elit..GMS_License_Server_Log', 'U') IS NOT NULL DROP TABLE GMS_License_Server_Log
CREATE TABLE GMS_License_Server_Log (ID int IDENTITY(1,1), Net_Status varchar(max), Log_time datetime DEFAULT CURRENT_TIMESTAMP)
*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*���� ���� ������: */
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
IF EXISTS(SELECT * FROM #temp WHERE output = 'False')
    BEGIN
        --������ ������ �� ������������ ����������� � ���.
        --IF OBJECT_ID('Elit..GMS_License_Server_Log', 'U') IS NOT NULL DROP TABLE GMS_License_Server_Log
        --CREATE TABLE GMS_License_Server_Log (ID int IDENTITY(1,1), Net_Status varchar(max), Log_time datetime DEFAULT CURRENT_TIMESTAMP)
        INSERT INTO GMS_License_Server_Log (Net_Status) VALUES ('False')

        IF (SELECT Net_Status FROM GMS_License_Server_Log WHERE ID = (SELECT MAX(ID) FROM GMS_License_Server_Log)) = 'False' 
            AND (SELECT Net_Status FROM GMS_License_Server_Log WHERE ID = (SELECT MAX(ID)-1 FROM GMS_License_Server_Log)) = 'True'
            BEGIN
                SELECT '���� ����������..'
                --���������� ����������� (FAILURE).
                EXEC msdb.dbo.sp_send_dbmail  
		         @profile_name = 'arda'
		        ,@from_address = '<support_arda@const.dp.ua>'
		        ,@recipients = 'rumyantsev@const.dp.ua'
		        --,@copy_recipients  = 'rumyantsev.kv@gmail.com;mi703148@gmail.com;maslovolegw@gmail.com;alexandr.kotsurenko@gmail.com'   
		        ,@body = '<font size="15" color="red" face="Arial">������ �������� <b>����������</b>. ������ � GMS Office Tools �������� ����������! ��� ������������� ����������� ������ ����� ���������� �����������.'
		        ,@subject = @subject
		        ,@body_format = 'HTML'--'HTML'
                ,@importance = 'HIGH'
            END;

    END;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*���� ���� ��������: */
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
IF EXISTS(SELECT * FROM #temp WHERE output = 'True')
    BEGIN
        --������ ������ �� ������������ ����������� � ���.
        INSERT INTO GMS_License_Server_Log (Net_Status) VALUES ('True')
        --�������� �� ��������� �������.
        IF (SELECT Net_Status FROM GMS_License_Server_Log WHERE ID = (SELECT MAX(ID) FROM GMS_License_Server_Log)) = 'True' 
            AND (SELECT Net_Status FROM GMS_License_Server_Log WHERE ID = (SELECT MAX(ID)-1 FROM GMS_License_Server_Log)) = 'False'
            BEGIN
                SELECT '���������.'
                --���������� ����������� (SUCCESS).
                EXEC msdb.dbo.sp_send_dbmail  
		         @profile_name = 'arda'
		        ,@from_address = '<support_arda@const.dp.ua>'
		        ,@recipients = 'rumyantsev@const.dp.ua'
		        --,@copy_recipients  = 'rumyantsev.kv@gmail.com;mi703148@gmail.com;maslovolegw@gmail.com;alexandr.kotsurenko@gmail.com'   
		        ,@body = '<font size="15" color="green" face="Arial"> ������ �������� <b>��������</b>. ����� �������� � GMS Office Tools!'
		        ,@subject = @subject
		        ,@body_format = 'HTML'--'HTML'
                ,@importance = 'LOW'
            END;
    END;

--����� ���� (��� �����).
SELECT * FROM GMS_License_Server_Log