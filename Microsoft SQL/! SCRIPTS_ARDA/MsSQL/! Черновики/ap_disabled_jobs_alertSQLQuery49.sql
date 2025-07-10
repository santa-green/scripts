create TRIGGER [dbo].Alert_on_job_disabled
   ON  [dbo].[sysjobs]
   AFTER UPDATE
AS 
BEGIN
DECLARE @old_status BIT, @new_status BIT, @job_name VARCHAR(1024)
 
SELECT @old_status = enabled FROM deleted
SELECT @new_status = enabled, @job_name = name FROM inserted
 
  IF(@old_status <> @new_status)
  BEGIN
    INSERT INTO msdb.dbo.jobs_disabled_event_log(login_name, job_name, job_status, action_timestamp)
    VALUES(ORIGINAL_LOGIN(), @job_name, @new_status, GETDATE())
    
    --DECLARE @body_content VARCHAR(1024) = '';
    --SET @body_content = 'SQL job : ' + @job_name + ' has been ' + 
    --          CASE @new_status WHEN 1 THEN 'Enabled' ELSE 'Disabled' END 
    --          + ' @ ' + CAST(GETDATE() AS VARCHAR(30))
  END
END