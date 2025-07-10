--Проверка времени выполнения задания 
DECLARE 
@job_name varchar(250) = 'VC_Sync' 	--имя джоба который мониторится
,@Max_Time_sec int = 150 		--секунд, максимальное время за которое должен отработать джоб
,@runs_sec int 			-- время которое проработал джоб
,@start_execution_date varchar(250)
,@current_execution_step varchar(250)
    
select @runs_sec = DATEDIFF(ss,start_execution_date ,GETDATE()), 
@start_execution_date = CONVERT( varchar, start_execution_date, 120),
@current_execution_step = current_execution_step
from 
(
    select job_id job_id,job_name job_name,start_execution_date  start_execution_date,DATEDIFF(ss,start_execution_date ,GETDATE())  as runs
    from
    openrowset('SQLNCLI', 'Server=localhost;Trusted_Connection=yes;', 'exec msdb.dbo.sp_help_jobactivity ')
    where  job_name in (@job_name)
) as t1
inner join 
(
    select job_id job_id,name name,originating_server originating_server, current_execution_step current_execution_step
    from
    openrowset('SQLNCLI', 'Server=localhost;Trusted_Connection=yes;', 'exec msdb.dbo.sp_help_job @execution_status =0')
    where  name in (@job_name)
) as t2 on t1.job_id=t2.job_id

select @runs_sec, @start_execution_date, @current_execution_step

  --Отправка почтового сообщения если время которое проработал джоб больше чем максимальное время за которое должен отработать джоб
  IF @runs_sec > @Max_Time_sec
  BEGIN TRY 
  	DECLARE @subject varchar(250), @body varchar(max), @tableHTML  NVARCHAR(MAX) 
	SET @subject = 'Тревога!!! Задание (джоб)  ' + CAST(@job_name as varchar) + ' запущеное ' + @start_execution_date +
		           ' Работает слишком долго: ' + CAST(@runs_sec as varchar) + ' секунд. И привысил предел в ' + CAST(@Max_Time_sec as varchar) + ' секунд.'+
		           ' Текущий шаг: ' + @current_execution_step
	
	EXEC msdb.dbo.sp_send_dbmail  
	@profile_name = 'main',  
	@recipients = 'pashkovv@const.dp.ua; vintagednepr2@const.dp.ua',  
	@subject = @subject,
	@body = '',  
	@body_format = 'HTML'
  END TRY  
  BEGIN CATCH
    SELECT  
    ERROR_NUMBER() AS ErrorNumber  
    ,ERROR_SEVERITY() AS ErrorSeverity  
    ,ERROR_STATE() AS ErrorState  
    ,ERROR_PROCEDURE() AS ErrorProcedure  
    ,ERROR_LINE() AS ErrorLine  
    ,ERROR_MESSAGE() AS ErrorMessage; 
  END CATCH