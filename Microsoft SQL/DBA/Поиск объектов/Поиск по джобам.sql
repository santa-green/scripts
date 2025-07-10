DECLARE @text varchar(max) = 'ap_OP_Importt_Inv802'
SELECT m.[name], step_id, step_name, subsystem, command, * FROM msdb.dbo.sysjobs m
JOIN msdb.dbo.sysjobsteps d ON m.job_id = d.job_id
WHERE [command] like '%' + @text + '%'

[ap_OP_Importt_Inv802]