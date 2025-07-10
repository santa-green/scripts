
BEGIN TRY  
    exec sp_testlinkedserver [CP1_DP]
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

if existsserver('CP1_DP') select 'bingo'

CREATE TABLE #TBLPING ([idx] [int] IDENTITY (1,1) NOT NULL,
[val] [varchar] (8000) NULL )
set @rabStr='PING ' + @LinkServer
INSERT INTO #TBLPING (val) EXEC master..xp_cmdshell @Val = @rabStr
if exists(SELECT * FROM #TBLPING WHERE val LIKE '%Unknown host %')
set @message='Нет связи с linked server"ом ' 
else
begin 
Delete #TBLPING
set @rabStr='ODBCPING /SS-MARKETA /Usa '
INSERT INTO #TBLPING (val) EXEC master..xp_cmdshell 'ping 192.168.70.2'
if exists(SELECT * FROM #TBLPING WHERE val LIKE '%COULD NOT CONNECT TO SQL SERVER%')
set @message='Linked server не отзывается.'
else ...
и не забыть в конце
drop table #TBLPING

EXEC master..xp_cmdshell  'osql /L'

Exec master..xp_cmdshell 'ISQL -L'
Exec master..xp_cmdshell 'OSQL -L'

Exec sp_testlinkedserver [CP1_DP]

exec sp_testlinkedserver [S-MARKETA3]

sp_linkedservers

EXEC sp_configure 'remote login timeout', 1
reconfigure with override 
go 
