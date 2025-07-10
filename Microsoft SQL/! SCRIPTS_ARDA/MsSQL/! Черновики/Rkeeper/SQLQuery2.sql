USE ElitR
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

/*SELECT SUSER_SID ('rkv0')
SELECT SUSER_SID ()
SELECT SUSER_SID ('corp\rumyantsev')
SELECT SUSER_SID ('const\rumyantsev')
select len(0x010500000000000515000000BAF7F98653E6CBC2AF0DB94580470000)
EXEC ap_Rkiper_Import_Sale*/
