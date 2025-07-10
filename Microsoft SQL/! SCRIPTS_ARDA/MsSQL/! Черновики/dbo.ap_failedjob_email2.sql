USE [msdb]
GO
/****** Object:  StoredProcedure [dbo].[ap_failedjob_email]    Script Date: 23.02.2021 16:28:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[ap_sendemail_failedjobs]
AS
BEGIN
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*DESCRIPTION*/
--created by rkv0 '2021-02-23 16:25' 
--Отправляем email-уведомление о поломанном джобе.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ADDED] '2020-06-30 11:57' rkv0. 
--[ADDED] rkv0 '2021-02-23 15:41' добавил название джоба, шага и статуса.

/*
INFO:
dbo.sysjobhistory: Contains information about the execution of scheduled jobs by SQL Server Agent.
In most cases the data is updated only after the job step completes and the table typically contains no records for job steps that are currently in progress, but in some cases underlying processes do provide information about in progress job steps.
SELECT * FROM sysjobhistory ORDER BY 1 DESC --лог выполнения джобов.
SELECT dbo.agent_datetime(last_run_date, last_run_time), * FROM dbo.sysjobsteps ORDER BY dbo.agent_datetime(last_run_date, last_run_time) desc --таблица по шагам джобов.
SELECT * FROM sysjobs ORDER BY date_created DESC --инфо по всем джобам на сервере.
*/

IF EXISTS(
        SELECT h.step_id StepID, j.name JobName,h.step_name StepName,
            CONVERT(CHAR(10), CAST(STR(h.run_date,8, 0) AS dateTIME), 111) RunDate, --STR() function: converts numeric value to character value.
            STUFF(STUFF(RIGHT('000000' + CAST ( h.run_time AS VARCHAR(6 ) ) ,6),5,0,':'),3,0,':') RunTime, --run_time: Time the job or step started in HHMMSS format.
            h.run_duration StepDuration, --run_duration: Elapsed time in the execution of the job or step in HHMMSS format.
            case h.run_status when 0 then 'failed'--Failed(0), Succeeded(1), Retry(2), Canceled(3), In progress(4).
            when 1 then 'Succeded' 
            when 2 then 'Retry' 
            when 3 then 'Cancelled' 
            when 4 then 'In Progress' 
            end as ExecutionStatus, 
            h.[message] MessageGenerated
            FROM sysjobhistory h inner join sysjobs j
            ON j.job_id = h.job_id
            WHERE --j.name = 'workflow'
                h.run_status IN (0,2,3)
                AND j.[enabled] = 1 --only enabled jobs.
            AND dbo.agent_datetime(h.run_date, h.run_time) > CAST(DATEADD(MINUTE, -15, SYSDATETIME()) AS datetime) --проверяем за последние 15 минут (dbo.agent_datetime() - недокументированная функция)
            )          
    --отправляем письмо
    BEGIN

                DECLARE @num nvarchar(16)
		        DECLARE @body_str nvarchar(max)
		        DECLARE @subject nvarchar(max)
                --[ADDED] rkv0 '2021-02-23 15:41' добавил название джоба, шага и статуса.
                DECLARE @jobname varchar(max) = (SELECT DISTINCT(j.[name]) JobName FROM sysjobhistory h inner join sysjobs j ON j.job_id = h.job_id WHERE h.run_status IN (0,2,3) AND dbo.agent_datetime(h.run_date, h.run_time) > CAST(DATEADD(MINUTE, -15, SYSDATETIME()) AS datetime))
                DECLARE @stepname varchar(max) = (SELECT step_name FROM sysjobhistory h inner join sysjobs j ON j.job_id = h.job_id WHERE step_id = (SELECT MAX(step_id) FROM sysjobhistory h inner join sysjobs j ON j.job_id = h.job_id WHERE h.run_status IN (0,2,3) AND dbo.agent_datetime(h.run_date, h.run_time) > CAST(DATEADD(MINUTE, -45, SYSDATETIME()) AS datetime)) AND h.run_status IN (0,2,3) AND dbo.agent_datetime(h.run_date, h.run_time) > CAST(DATEADD(MINUTE, -15, SYSDATETIME()) AS datetime))
                DECLARE @stepid varchar(max) = (SELECT MAX(step_id) FROM sysjobhistory h inner join sysjobs j ON j.job_id = h.job_id WHERE h.run_status IN (0,2,3) AND dbo.agent_datetime(h.run_date, h.run_time) > CAST(DATEADD(MINUTE, -15, SYSDATETIME()) AS datetime))
                DECLARE @jobstatus varchar(max) = (SELECT top 1 case h.run_status when 0 then 'failed'
                    when 1 then 'Succeded' 
                    when 2 then 'Retry' 
                    when 3 then 'Cancelled' 
                    when 4 then 'In Progress' 
                    end FROM sysjobhistory h inner join sysjobs j ON j.job_id = h.job_id WHERE h.run_status IN (0,2,3) AND dbo.agent_datetime(h.run_date, h.run_time) > CAST(DATEADD(MINUTE, -15, SYSDATETIME()) AS datetime))

                SET @subject = 'JOB FAILED !! ' + 'Status: ' + @jobstatus + '. ' + @jobname + ': ' + 'StepID: ' + @stepid + ': ' + @stepname;

                SET @body_str = 'Внимание! Поломался джоб! Детали во вложении.' + char(10) + char(13) + 'Проверка каждые 15 мин: [s-ppc] JOB: "Jobs status check", Step 1: "Failed jobs notification"';

		        EXEC msdb.dbo.sp_send_dbmail  
		         @profile_name = 'arda'
                 --[ADDED] '2020-06-30 11:57' rkv0. 
		        ,@recipients = 'support_arda@const.dp.ua;rumyantsev.kv@gmail.com;maslovolegw@gmail.com;alexandr.kotsurenko@gmail.com;mi703148@gmail.com'
		        --,@recipients = 'rumyantsev@const.dp.ua' --для теста.
		        ,@subject = @subject
		        ,@body = @body_str
		        ,@body_format = 'TEXT'
		        ,@importance = 'high'
                ,@execute_query_database = 'msdb'
                ,@query = 'SELECT 
                h.step_id StepID, j.name JobName,h.step_name StepName,
                case h.run_status when 0 then ''failed''
                when 1 then ''Succeded'' 
                when 2 then ''Retry'' 
                when 3 then ''Cancelled'' 
                when 4 then ''In Progress'' 
                end as ExecutionStatus
            
            FROM sysjobhistory h inner join sysjobs j
            ON j.job_id = h.job_id
             
            WHERE 
                h.run_status IN (0,2,3) 
                AND dbo.agent_datetime(h.run_date, h.run_time) > CAST(DATEADD(MINUTE, -15, SYSDATETIME()) AS datetime)
                '
                ,@attach_query_result_as_file = 1
                ,@query_attachment_filename = 'Failed jobs.txt'
                --,@append_query_error = 1

    END;
END;

GO
