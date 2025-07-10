SELECT session_id                                                      
,      percent_complete                                                
,      DATEADD(MILLISECOND,estimated_completion_time,CURRENT_TIMESTAMP) Estimated_finish_time
,      (total_elapsed_time/1000)/60                                     Total_Elapsed_Time_MINS
,      DB_NAME(Database_id)                                             Database_Name
,      command                                                         
,      sql_handle                                                      
FROM sys.dm_exec_requests
WHERE command LIKE '%restore%'
--WHERE command LIKE '%backup%'