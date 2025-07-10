exec sp_start_job 'ELIT ExiteSync', @step_name = ''
SELECT top 1 * FROM msdb.dbo.sysjobstepslogs --WHERE name like '%sync%'
SELECT * FROM msdb.dbo.sysjobs WHERE name like '%sync%'
SELECT * FROM msdb.dbo.sysjobsteps WHERE job_id = 'B269304F-E217-4715-A4BE-D2E7BE8CB635'
exec msdb.dbo.sp_help_jobactivity @job_name = 'ELIT ExiteSync'

USE msdb
SELECT * FROM sysjobs m
JOIN sysjobsteps d ON m.job_id = d.job_id
WHERE m.[name] like '%ELIT ExiteSync%'