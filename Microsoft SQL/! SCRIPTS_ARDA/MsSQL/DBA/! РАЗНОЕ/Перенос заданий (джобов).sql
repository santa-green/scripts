--собираем те задания, которые переносить не нужно
select ss.[schedule_uid]
	  ,js.[job_id]
into #tbl_notentity
from [msdb].[dbo].[sysjobschedules] as js
inner join [msdb].[dbo].[sysschedules] as ss on js.[schedule_id]=ss.[schedule_id]
--where [job_id] in (
--	<список GUID-ов тех заданий, которые переносить не нужно>
--)
SELECT * FROM #tbl_notentity

select *
--into #tbl_notentity
from [msdb].[dbo].[sysjobschedules] as js
inner join [msdb].[dbo].[sysschedules] as ss on js.[schedule_id]=ss.[schedule_id]


--переносим задания
select *, 0 as IsAdd
into #tbl_jobs
from [СЕРВЕР-ПОЛУЧАТЕЛЬ].[msdb].[dbo].[sysjobs];

;with src as (
	select *
	from [msdb].[dbo].[sysjobs] as src
	where not exists (
		select top(1) 1 from #tbl_notentity as t where t.[job_id]=src.[job_id]
	)
)
merge #tbl_jobs as trg
using src on trg.[job_id]=src.[job_id]
when not matched by target then
INSERT ([job_id]
      ,[originating_server_id]
      ,[name]
      ,[enabled]
      ,[description]
      ,[start_step_id]
      ,[category_id]
      ,[owner_sid]
      ,[notify_level_eventlog]
      ,[notify_level_email]
      ,[notify_level_netsend]
      ,[notify_level_page]
      ,[notify_email_operator_id]
      ,[notify_netsend_operator_id]
      ,[notify_page_operator_id]
      ,[delete_level]
      ,[date_created]
      ,[date_modified]
      ,[version_number]
	  ,[IsAdd])
VALUES (src.[job_id]
      ,src.[originating_server_id]
      ,src.[name]
      ,src.[enabled]
      ,src.[description]
      ,src.[start_step_id]
      ,src.[category_id]
      ,src.[owner_sid]
      ,src.[notify_level_eventlog]
      ,src.[notify_level_email]
      ,src.[notify_level_netsend]
      ,src.[notify_level_page]
      ,src.[notify_email_operator_id]
      ,src.[notify_netsend_operator_id]
      ,src.[notify_page_operator_id]
      ,src.[delete_level]
      ,src.[date_created]
      ,src.[date_modified]
      ,src.[version_number]
	  ,1);

insert into [СЕРВЕР-ПОЛУЧАТЕЛЬ].[msdb].[dbo].[sysjobs]([job_id]
      ,[originating_server_id]
      ,[name]
      ,[enabled]
      ,[description]
      ,[start_step_id]
      ,[category_id]
      ,[owner_sid]
      ,[notify_level_eventlog]
      ,[notify_level_email]
      ,[notify_level_netsend]
      ,[notify_level_page]
      ,[notify_email_operator_id]
      ,[notify_netsend_operator_id]
      ,[notify_page_operator_id]
      ,[delete_level]
      ,[date_created]
      ,[date_modified]
      ,[version_number])
select [job_id]
      ,[originating_server_id]
      ,[name]
      ,[enabled]
      ,[description]
      ,[start_step_id]
      ,[category_id]
      ,[owner_sid]
      ,[notify_level_eventlog]
      ,[notify_level_email]
      ,[notify_level_netsend]
      ,[notify_level_page]
      ,[notify_email_operator_id]
      ,[notify_netsend_operator_id]
      ,[notify_page_operator_id]
      ,[delete_level]
      ,[date_created]
      ,[date_modified]
      ,[version_number]
from #tbl_jobs
where IsAdd=1;

--drop table #tbl_jobs;

--переносим шаги заданий
select *, 0 as IsAdd
into #tbl_jobsteps
from [СЕРВЕР-ПОЛУЧАТЕЛЬ].[msdb].[dbo].[sysjobsteps];

;with src as (
	select *
	from [msdb].[dbo].[sysjobsteps] as src
	where not exists (
		select top(1) 1 from #tbl_notentity as t where t.[job_id]=src.[job_id]
	)
)
merge #tbl_jobsteps as trg
using src on trg.[job_id]=src.[job_id] and trg.[step_id]=src.[step_id]
when not matched by target then
INSERT ([job_id]
      ,[step_id]
      ,[step_name]
      ,[subsystem]
      ,[command]
      ,[flags]
      ,[additional_parameters]
      ,[cmdexec_success_code]
      ,[on_success_action]
      ,[on_success_step_id]
      ,[on_fail_action]
      ,[on_fail_step_id]
      ,[server]
      ,[database_name]
      ,[database_user_name]
      ,[retry_attempts]
      ,[retry_interval]
      ,[os_run_priority]
      ,[output_file_name]
      ,[last_run_outcome]
      ,[last_run_duration]
      ,[last_run_retries]
      ,[last_run_date]
      ,[last_run_time]
      ,[proxy_id]
      ,[step_uid]
	  ,[IsAdd])
VALUES (src.[job_id]
      ,src.[step_id]
      ,src.[step_name]
      ,src.[subsystem]
      ,src.[command]
      ,src.[flags]
      ,src.[additional_parameters]
      ,src.[cmdexec_success_code]
      ,src.[on_success_action]
      ,src.[on_success_step_id]
      ,src.[on_fail_action]
      ,src.[on_fail_step_id]
      ,src.[server]
      ,src.[database_name]
      ,src.[database_user_name]
      ,src.[retry_attempts]
      ,src.[retry_interval]
      ,src.[os_run_priority]
      ,src.[output_file_name]
      ,src.[last_run_outcome]
      ,src.[last_run_duration]
      ,src.[last_run_retries]
      ,src.[last_run_date]
      ,src.[last_run_time]
      ,src.[proxy_id]
      ,src.[step_uid]
	  ,1);

insert into [СЕРВЕР-ПОЛУЧАТЕЛЬ].[msdb].[dbo].[sysjobsteps]([job_id]
      ,[step_id]
      ,[step_name]
      ,[subsystem]
      ,[command]
      ,[flags]
      ,[additional_parameters]
      ,[cmdexec_success_code]
      ,[on_success_action]
      ,[on_success_step_id]
      ,[on_fail_action]
      ,[on_fail_step_id]
      ,[server]
      ,[database_name]
      ,[database_user_name]
      ,[retry_attempts]
      ,[retry_interval]
      ,[os_run_priority]
      ,[output_file_name]
      ,[last_run_outcome]
      ,[last_run_duration]
      ,[last_run_retries]
      ,[last_run_date]
      ,[last_run_time]
      ,[proxy_id]
      ,[step_uid])
select [job_id]
      ,[step_id]
      ,[step_name]
      ,[subsystem]
      ,[command]
      ,[flags]
      ,[additional_parameters]
      ,[cmdexec_success_code]
      ,[on_success_action]
      ,[on_success_step_id]
      ,[on_fail_action]
      ,[on_fail_step_id]
      ,[server]
      ,[database_name]
      ,[database_user_name]
      ,[retry_attempts]
      ,[retry_interval]
      ,[os_run_priority]
      ,[output_file_name]
      ,[last_run_outcome]
      ,[last_run_duration]
      ,[last_run_retries]
      ,[last_run_date]
      ,[last_run_time]
      ,[proxy_id]
      ,[step_uid]
from #tbl_jobsteps
where IsAdd=1;

drop table #tbl_jobsteps;

--переносим расписания заданий
select *, 0 as IsAdd
into #tbl_sysschedules
from [СЕРВЕР-ПОЛУЧАТЕЛЬ].[msdb].[dbo].[sysschedules];

;with src as (
	select *
	from [msdb].[dbo].[sysschedules] as src
	where not exists (
		select top(1) 1 from #tbl_notentity as t where t.[schedule_uid]=src.[schedule_uid]
	)
)
merge #tbl_sysschedules as trg
using src on trg.[schedule_uid]=src.[schedule_uid]
when not matched by target then
INSERT ([schedule_id]
	  ,[schedule_uid]
      ,[originating_server_id]
      ,[name]
      ,[owner_sid]
      ,[enabled]
      ,[freq_type]
      ,[freq_interval]
      ,[freq_subday_type]
      ,[freq_subday_interval]
      ,[freq_relative_interval]
      ,[freq_recurrence_factor]
      ,[active_start_date]
      ,[active_end_date]
      ,[active_start_time]
      ,[active_end_time]
      ,[date_created]
      ,[date_modified]
      ,[version_number]
	  ,[IsAdd])
VALUES (src.[schedule_id]
	  ,src.[schedule_uid]
      ,src.[originating_server_id]
      ,src.[name]
      ,src.[owner_sid]
      ,src.[enabled]
      ,src.[freq_type]
      ,src.[freq_interval]
      ,src.[freq_subday_type]
      ,src.[freq_subday_interval]
      ,src.[freq_relative_interval]
      ,src.[freq_recurrence_factor]
      ,src.[active_start_date]
      ,src.[active_end_date]
      ,src.[active_start_time]
      ,src.[active_end_time]
      ,src.[date_created]
      ,src.[date_modified]
      ,src.[version_number]
	  ,1);

insert into [СЕРВЕР-ПОЛУЧАТЕЛЬ].[msdb].[dbo].[sysschedules]([schedule_uid]
      ,[originating_server_id]
      ,[name]
      ,[owner_sid]
      ,[enabled]
      ,[freq_type]
      ,[freq_interval]
      ,[freq_subday_type]
      ,[freq_subday_interval]
      ,[freq_relative_interval]
      ,[freq_recurrence_factor]
      ,[active_start_date]
      ,[active_end_date]
      ,[active_start_time]
      ,[active_end_time]
      ,[date_created]
      ,[date_modified]
      ,[version_number])
select [schedule_uid]
      ,[originating_server_id]
      ,[name]
      ,[owner_sid]
      ,[enabled]
      ,[freq_type]
      ,[freq_interval]
      ,[freq_subday_type]
      ,[freq_subday_interval]
      ,[freq_relative_interval]
      ,[freq_recurrence_factor]
      ,[active_start_date]
      ,[active_end_date]
      ,[active_start_time]
      ,[active_end_time]
      ,[date_created]
      ,[date_modified]
      ,[version_number]
from #tbl_sysschedules
where IsAdd=1;

drop table #tbl_sysschedules;

--переносим связи между расписаниями и их заданиями
select js.*, ss.[schedule_uid], 0 as IsAdd
into #tbl_jobschedules
from [СЕРВЕР-ПОЛУЧАТЕЛЬ].[msdb].[dbo].[sysjobschedules] as js
inner join [СЕРВЕР-ПОЛУЧАТЕЛЬ].[msdb].[dbo].[sysschedules] as ss on js.[schedule_id]=ss.[schedule_id];

;with src as (
	select js.[job_id]
		  ,js.[next_run_date]
		  ,js.[next_run_time]
		  ,ss.[schedule_uid]
		  ,serv.[schedule_id]
	from [msdb].[dbo].[sysjobschedules] as js
	inner join [msdb].[dbo].[sysschedules] as ss on js.[schedule_id]=ss.[schedule_id]
	inner join [СЕРВЕР-ПОЛУЧАТЕЛЬ].[msdb].[dbo].[sysschedules] as serv on serv.[schedule_uid]=ss.[schedule_uid]
	where not exists (
		select top(1) 1 from #tbl_notentity as t where t.[schedule_uid]=ss.[schedule_uid]
	)
)
merge #tbl_jobschedules as trg
using src on trg.[job_id]=src.[job_id] and trg.[schedule_uid]=src.[schedule_uid]
when not matched by target then
INSERT ([schedule_id]
      ,[schedule_uid]
	  ,[job_id]
      ,[next_run_date]
      ,[next_run_time]
	  ,[IsAdd])
VALUES (src.[schedule_id]
      ,src.[schedule_uid]
	  ,src.[job_id]
      ,src.[next_run_date]
      ,src.[next_run_time]
	  ,1);

insert into [СЕРВЕР-ПОЛУЧАТЕЛЬ].[msdb].[dbo].[sysjobschedules]([schedule_id]
      ,[job_id]
	  )
select [schedule_id]
      ,[job_id]
from #tbl_jobschedules
where IsAdd=1;

drop table #tbl_jobschedules;

--переносим целевые сервера
select *, 0 as IsAdd
into #tbl_sysjobservers
from [СЕРВЕР-ПОЛУЧАТЕЛЬ].[msdb].[dbo].[sysjobservers];

;with src as (
	select *
	from [msdb].[dbo].[sysjobservers] as src
	where not exists (
		select top(1) 1 from #tbl_notentity as t where t.[job_id]=src.[job_id]
	)
)
merge #tbl_sysjobservers as trg
using src on trg.[job_id]=src.[job_id] and trg.[server_id]=src.[server_id]
when not matched by target then
INSERT ([job_id]
      ,[server_id]
      ,[last_run_outcome]
      ,[last_outcome_message]
      ,[last_run_date]
      ,[last_run_time]
      ,[last_run_duration]
	  ,[IsAdd])
VALUES (src.[job_id]
      ,src.[server_id]
      ,src.[last_run_outcome]
      ,src.[last_outcome_message]
      ,src.[last_run_date]
      ,src.[last_run_time]
      ,src.[last_run_duration]
	  ,1);

insert into [СЕРВЕР-ПОЛУЧАТЕЛЬ].[msdb].[dbo].[sysjobservers]([job_id]
      ,[server_id]
      ,[last_run_outcome]
      ,[last_outcome_message]
      ,[last_run_date]
      ,[last_run_time]
      ,[last_run_duration])
select [job_id]
      ,[server_id]
      ,[last_run_outcome]
      ,[last_outcome_message]
      ,[last_run_date]
      ,[last_run_time]
      ,[last_run_duration]
from #tbl_sysjobservers
where IsAdd=1;

drop table #tbl_sysjobservers;

drop table #tbl_notentity;

--регистрируем задания и активизируем их расписания, переведя в неактивный режим эти задания (выключение заданий)
declare @job_id uniqueidentifier;

--делаем владельца новых заданий sa
update sj
set sj.[owner_sid]=0x01
from #tbl_jobs as t
inner join [СЕРВЕР-ПОЛУЧАТЕЛЬ].[msdb].[dbo].[sysjobs] as sj on t.[job_id]=sj.[job_id]
where [IsAdd]=1;

while(exists(select top(1) 1 from #tbl_jobs where [IsAdd]=1))
begin
	select top(1)
	@job_id=[job_id]
	from #tbl_jobs
	where [IsAdd]=1;

	EXEC [СЕРВЕР-ПОЛУЧАТЕЛЬ].[msdb].[dbo].sp_update_job @job_id=@job_id, 
			@enabled=0

	delete from #tbl_jobs
	where [job_id]=@job_id;
end

drop table #tbl_jobs;