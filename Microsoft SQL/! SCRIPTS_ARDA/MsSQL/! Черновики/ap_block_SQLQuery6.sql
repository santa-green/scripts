alter PROCEDURE [dbo].[ap_block_notify] @test bit = NULL  
--������ ��������� �� �������� ����������: ap_SendEmail_do_Blocked (��� 1).  
--@Testing = null ������� �����, @Testing = 1 � ������� ��� ���������� ��� �������,   
--@Testing = 2 ���������� ����� (��� ��������� � ����), @Testing = 3 ���������� ����� � ������� ��� ���������� ��� �������  
as  
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
/*CHANGELOG*/  
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
--[FIXED] rkv0 '2021-08-03 17:34' �� ������ ������ �� ElitR.  
--[CHANGED] rkv0 '2021-08-25 15:12' �������� �������� �� ISNULL, �.�. ������ �������� ������ ������ (���� ��������).  
--[ADDED] rkv0 '2021-09-02 11:23' ������� ����� �� ���������, ����� �� ������������ ������ ������ (������ ���� �������� �� ����������).
  
  
begin  
 SET NOCOUNT ON  
/* --TEST--
EXEC [dbo].[ap_block_notify] @test = 1 
*/
    DECLARE @recipients varchar(max)  
    SET @recipients = (SELECT CASE WHEN @test = 1 THEN 'rumyantsev@const.dp.ua' ELSE 'support_arda@const.dp.ua;tancyura@const.dp.ua;khiluk@const.dp.ua' END)  
    SELECT @recipients  
  
 --#region tempdb..block_notify  
 IF OBJECT_ID('tempdb..block_notify', 'U') IS NOT NULL  
  DROP TABLE tempdb..block_notify  
  
    SELECT * INTO tempdb..block_notify  
    FROM (SELECT spid                               
    --,            [status] + CONVERT(varchar, GETDATE(), 113) as [status]                           
    ,            [status] as [status]                           
    ,            CONVERT(CHAR(3), blocked)         AS blocked  
    ,            loginame --dvv4, moa0                                                                                                                                                                                                                         
                                                         
    ,            SUBSTRING([program_name] ,1,250)   AS program  
    ,            SUBSTRING(DB_NAME(p.dbid),1,20)   AS [database]  
    ,            SUBSTRING(hostname, 1, 12)        AS host  
    ,            cmd                                
    ,            sys.fn_varbintohexstr (waittype )    waittype --,cast(waittype as varchar) waittype  
    ,            cast(t.[text] as varchar(250))       text  
    ,            waittime / 1000       'Wait Time, s'  
    FROM        sys.sysprocesses                    p  
    CROSS APPLY sys.dm_exec_sql_text (p.sql_handle) t  
    /*test*/ WHERE ( ([status] != 'sleeping' AND @test = 1) OR  
    --WHERE (  
      
      (  
       spid IN (SELECT blocked  
       FROM sys.sysprocesses  
       WHERE blocked <> 0)  
       AND blocked = 0)  
      or (blocked <> 0))  
     AND ( [dbo].[zf_MatchFilterInt](p.dbid, '1,10,14',',') = 1)) m  
  
     SELECT *  
     FROM tempdb..block_notify  
  
     IF @test = 1 WAITFOR DELAY '00:00:03'  
     ELSE WAITFOR DELAY '00:00:30'  
      
    IF NOT EXISTS (SELECT 1 FROM        sys.sysprocesses                    p  
        CROSS APPLY sys.dm_exec_sql_text (p.sql_handle) t  
    --WHERE CASE WHEN @test = 1 THEN [status] != 'sleeping' OR  
    /*test*/ WHERE ( ([status] != 'sleeping' AND @test = 1) OR  
    --WHERE (  
          (  
           spid IN (SELECT blocked  
           FROM sys.sysprocesses  
           WHERE blocked <> 0)  
           AND blocked = 0)  
          or (blocked <> 0))  
         AND ( [dbo].[zf_MatchFilterInt](p.dbid, '1,10,14',',') = 1))  
        BEGIN  
            RETURN  
        END;  
  
    INSERT INTO tempdb..block_notify  
    SELECT spid                               
    --,            current_timestamp '����� ������'  
    --,            [status] + CONVERT(varchar, GETDATE(), 113) as [status]                           
    ,            [status] as [status]                           
    ,            CONVERT(CHAR(3), blocked)         AS blocked  
    ,            loginame                           
    ,            SUBSTRING([program_name] ,1,250)   AS program  
    ,            SUBSTRING(DB_NAME(p.dbid),1,20)   AS [database]  
    ,            SUBSTRING(hostname, 1, 12)        AS host  
    ,            cmd                                
    ,            sys.fn_varbintohexstr (waittype )    waittype --,cast(waittype as varchar) waittype  
    ,            cast(t.[text] as varchar(250))       text  
    ,            waittime / 1000       'Wait Time, s'  
    FROM        sys.sysprocesses                    p  
    CROSS APPLY sys.dm_exec_sql_text (p.sql_handle) t  
    /*test*/ WHERE ( ([status] != 'sleeping' AND @test = 1) OR  
    --WHERE (  
      (  
       spid IN (SELECT blocked  
       FROM sys.sysprocesses  
       WHERE blocked <> 0)  
       AND blocked = 0)  
      or (blocked <> 0))  
     AND ( [dbo].[zf_MatchFilterInt](p.dbid, '1,10,14',',') = 1)  
  
    SELECT *  
    FROM tempdb..block_notify  
     --#endregion tempdb..block_notify  
  
  
 --#region �������� HTML  
    SELECT spid, count(spid), loginame, [database]  
    FROM tempdb..block_notify  
    group by spid, loginame, [database]  
    having count(spid) > 1  
   
    IF EXISTS (SELECT 1  
    FROM tempdb..block_notify  
    group by spid, loginame, [database]  
    having count(spid) > 1  
        )  
 BEGIN  
  DECLARE @subject varchar(max) = '���������� � ���������� 30 ������'  
  DECLARE @body varchar(max)  
  DECLARE @msg varchar(max)  
  SET @msg = '<p style="font-size: 14; color: red"> ���� ���� "+" � ���� ��� ��������� -> ���� ��������� ��������� ���������! </p>' +  
        '<p style="font-size: 12; color: gray"><i>[��� �������������� ��] ���������� [S-PPC] JOB "ELIT Blocked" ��� 2   
            (����������� � ������ ���������� / [ap_block_notify] )</i></p>'  
  
        IF OBJECT_ID('tempdb..#html_init', 'U') IS NOT NULL  
         DROP TABLE #html_init  
        IF OBJECT_ID('tempdb..#html', 'U') IS NOT NULL  
         DROP TABLE #html  
  
SELECT   
       spid  
,      [status]   
,      loginame                           
,      [database]  
,      [program]                         
,      [host]   
 INTO #html_init  
FROM      tempdb..block_notify          m  
group by spid, [status], loginame, [database], [program], [host]  
having count(spid) > 1  
  
SELECT * FROM #html_init  
  
SELECT  
    m.spid,  
    m.[status],  
    CASE WHEN m.loginame = 'CORP\cluster' THEN '��������� ������������ CORP\cluster' ELSE m.loginame END '�����',  
    CONVERT(CHAR(3), sp.blocked) '��� ������������: spid',  
    CASE WHEN sp.blocked = 0 THEN '+' ELSE '-' END '��� ���������',  
    [database],  
    m.host '��� ����������',  
    CASE   
        WHEN m.program like '%sql%agent%'   
        THEN '����: ' + (SELECT TOP 1 [name] FROM msdb.dbo.sysjobs WHERE job_id = msdb.dbo.[GetJobIdFromProgramName] (m.program))   
        ELSE m.program END '����������',  
    ISNULL(gui.EmpID, 0000)           '��� ����������',  
    ISNULL(gui.EmpName, '[��� ����]') '���',  
    --[FIXED] rkv0 '2021-08-03 17:34' �� ������ ������ �� ElitR.  
    --(SELECT EMail FROM r_Emps WHERE EmpID = (SELECT EmpID FROM af_GetUserInfo(m.loginame))) 'email'  
    COALESCE(  
    (SELECT EMail FROM r_Emps WHERE EmpID = (SELECT EmpID FROM af_GetUserInfo(m.loginame))),   
    (SELECT EMail FROM ElitR.dbo.r_Emps WHERE EmpID = (SELECT EmpID FROM af_GetUserInfo(m.loginame)))   
    ) 'email'  
INTO #html  
FROM #html_init m  
LEFT JOIN dbo.af_GetUserInfo('ALL_USERS') gui ON gui.UserName = m.loginame  
JOIN sys.sysprocesses sp ON sp.spid = m.spid  
  
SELECT * FROM #html  
  
 DECLARE @head_html varchar(max) = NULL  
 DECLARE @table varchar(max) = '#html'  
    
    SELECT @head_html = ISNULL(@head_html, '') + '<th>' + COLUMN_NAME + '</th>'  
 FROM tempdb.INFORMATION_SCHEMA.COLUMNS  
 WHERE TABLE_NAME = (SELECT [name]  
  FROM tempdb.sys.tables  
  WHERE object_id = OBJECT_ID('tempdb..' + @table))  
 ORDER BY ORDINAL_POSITION  
  
 DECLARE @fields_html varchar(max) = NULL  
 SELECT @fields_html = ISNULL(@fields_html, '') + CASE WHEN @fields_html IS NULL THEN ''  
                        ELSE ',' END + QUOTENAME(COLUMN_NAME) + ' as td'  
 FROM tempdb.INFORMATION_SCHEMA.COLUMNS  
 WHERE TABLE_NAME = (SELECT [name]  
  FROM tempdb.sys.tables  
  WHERE object_id = OBJECT_ID('tempdb..' + @table))  
 ORDER BY ORDINAL_POSITION  
  
 DECLARE @SQL NVARCHAR(4000);  
 DECLARE @result NVARCHAR(MAX)  
 SET @SQL = 'SELECT @result = (  
        SELECT '+ @fields_html +' FROM #html t FOR XML RAW(''tr''), ELEMENTS  
        )';  
    SELECT @SQL  
 EXEC sp_executesql           @SQL  
 ,                            N'@result NVARCHAR(MAX) output'  
 ,                  @result = @result OUTPUT  
 
 --[ADDED] rkv0 '2021-09-02 11:23' ������� ����� �� ���������, ����� �� ������������ ������ ������ (������ ���� �������� �� ����������).
 IF @result IS NULL RETURN

 DECLARE @body_html NVARCHAR(MAX)  
    --[CHANGED] rkv0 '2021-08-25 15:12' �������� �������� �� ISNULL, �.�. ������ �������� ������ ������ (���� ��������).  
 --SET @body_html = N'<table  bordercolor=#eaa665 border="4"><tr>' + @Head_html + '</tr>' + @result + N'</table>'  
 SET @body_html = N'<table  bordercolor=#eaa665 border="4"><tr>' + ISNULL(@Head_html, '[sysadmin] FAILED: @Head_html IS NULL') + '</tr>' + ISNULL(@result, '[sysadmin] FAILED: @result IS NULL') + N'</table>'  
 SET @body = ISNULL(@body_html, '[sysadmin] FAILED: @body_html IS NULL') + ISNULL(@msg, '[sysadmin] FAILED: @msg IS NULL')  
  
    DECLARE @copy_recipients varchar(max)  
    SET @copy_recipients = (SELECT CASE WHEN @test = 1 THEN 'rumyantsev@const.dp.ua'  
                                                  ELSE (SELECT SUBSTRING((SELECT DISTINCT ';' + EMail as [text()]  
     FROM #html  
     WHERE EMail <> '' for XML PATH('')),2,65535)) END)  
    SELECT @copy_recipients  
  
 EXEC msdb.dbo.sp_send_dbmail @profile_name       = 'arda'  
 ,                            @from_address       = '<support_arda@const.dp.ua>'  
 ,                            @recipients         = @recipients  
 ,                            @copy_recipients    = @copy_recipients  
 ,                            @subject            = @subject  
 ,                            @body               = @body  
 ,                            @body_format        = 'HTML'  
 ,                            @append_query_error = 1  
 ,                            @importance         = 'high'  
  
 END  
--#endregion �������� HTML  
  
end  
  
  
  
  
  
  
  