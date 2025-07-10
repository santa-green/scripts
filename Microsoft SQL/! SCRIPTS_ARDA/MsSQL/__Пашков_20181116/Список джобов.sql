--список джобов
SELECT j.job_id, database_name,name, description,step_id, step_name, command,enabled FROM [msdb].dbo.sysjobs j
join [msdb].dbo.sysjobsteps js on js.job_id = j.job_id
where name like 'ELITR%'
ORDER BY name,step_id

--джобы с ошибками
select * from openrowset('SQLNCLI', 'Server=localhost;Trusted_Connection=yes;', 'exec msdb.dbo.sp_help_jobactivity')
where run_status <> 1

select * from openrowset('SQLNCLI', 'Server=S-MARKETA;Trusted_Connection=yes;', 'exec msdb.dbo.sp_help_jobactivity')
where run_status <> 1

select * from openrowset('SQLNCLI', 'Server=193.200.33.199;Trusted_Connection=yes;', 'exec msdb.dbo.sp_help_jobactivity')
where run_status <> 1

--поиск по телу шагов джобов
SELECT j.job_id, database_name,name, description,step_id, step_name, command,enabled FROM [msdb].dbo.sysjobs j
join [msdb].dbo.sysjobsteps js on js.job_id = j.job_id
where command like '%reshetnyak@const.dp.ua%'
ORDER BY name,step_id


select *
from [msdb].[dbo].[sysjobschedules] as js
inner join [msdb].[dbo].[sysschedules] as ss on js.[schedule_id]=ss.[schedule_id]

SELECT * FROM [msdb].dbo.[sysschedules]

SELECT * FROM [msdb].dbo.sysjobs j
join [msdb].dbo.sysjobsteps js on js.job_id = j.job_id
ORDER BY 1

