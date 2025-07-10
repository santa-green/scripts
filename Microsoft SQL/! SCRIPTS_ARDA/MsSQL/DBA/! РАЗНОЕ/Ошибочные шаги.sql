
--Ошибочные шаги
SELECT  sj.name
       ,sh.run_date
       ,sh.run_time
       ,sh.run_duration
       ,sh.step_name
       --STUFF(STUFF(RIGHT(REPLICATE('0', 6) +  CAST(sh.run_time as varchar(6)), 6), 3, 0, ':'), 6, 0, ':') 'run_time',
       --STUFF(STUFF(STUFF(RIGHT(REPLICATE('0', 8) + CAST(sh.run_duration as varchar(8)), 8), 3, 0, ':'), 6, 0, ':'), 9, 0, ':') 'run_duration (DD:HH:MM:SS)  '
       ,sh.sql_message_id
       ,sh.step_id
		,len(sh.message)
       ,cast(sh.message as varchar(500))
       ,sh.run_status
       ,sh.*
FROM msdb.dbo.sysjobs sj
JOIN msdb.dbo.sysjobhistory sh
ON sj.job_id = sh.job_id
where sh.sql_message_id <> 0 --name = N'VC_Sync'  
ORDER BY sj.name, sh.run_date desc, sh.run_time desc, sh.step_id desc

