use master
execute as login = 'rkv0'
go
select system_user;
--revert
exec [S-PPC.CONST.ALEF.UA].[master].dbo.xp_cmdshell 'powershell.exe -command e:\Exite\powershell\ps_backups.ps1'
select system_user;

/*USE ElitR
EXECUTE AS LOGIN = 'rkv0' -- дл€ запуска OPENROWSET('Microsoft.ACE.OLEDB.12.0')
GO
EXEC [dbo].[ap_rkeeper_menu_check] 
/*
select system_user;
revert
grant exec on dbo.ap_rkeeper_menu_check to [CORPumyantsev] --достаточно одной таблэтки..
EXECUTE AS LOGIN = 'pvm0' -- дл€ запуска OPENROWSET('Microsoft.ACE.OLEDB.12.0')
EXECUTE AS LOGIN = 'CORPumyantsev' -- дл€ запуска OPENROWSET('Microsoft.ACE.OLEDB.12.0')
*/
ap_CheckFreeSpaceOnServerDisk*/