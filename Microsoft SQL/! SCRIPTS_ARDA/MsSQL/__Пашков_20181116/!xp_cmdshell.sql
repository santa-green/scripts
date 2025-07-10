/*
EXEC master..xp_cmdshell  'ping s-elit-dp'

EXEC master..xp_cmdshell  'ping 192.168.74.34'
EXEC master..xp_cmdshell  'ping 192.168.74.29'

EXEC master..xp_cmdshell  'telnet s-elit-dp 10101'

EXEC master..xp_cmdshell  'telnet 192.168.74.34 10101'

EXEC master..xp_cmdshell  'dir e:\OT38ElitServer\Import\'
 
 
EXEC master..xp_cmdshell  'dir e:\Sync\serversync\'

EXEC master..xp_cmdshell  'dir e:\'

EXEC master..xp_cmdshell  'dir e:\Sync\serversync\logs /o-d'


EXEC master..xp_cmdshell  'FORFILES /p e:\Sync\serversync\logs /D 10.03.2017 /C "cmd /c copy @path e:\OT38ElitServer\ServerSync\Logs"'

*/

--EXEC master..xp_cmdshell  'replace e:\Sync\serversync\logs\*.* e:\OT38ElitServer\ServerSync\Logs /A'

/*
EXEC master..xp_cmdshell  'SC query'

EXEC master..xp_cmdshell  'SC query otmsyncs'

EXEC master..xp_cmdshell  'sc qc otmsyncs'

EXEC master..xp_cmdshell  'sc start otmsyncs'

EXEC master..xp_cmdshell  'sc stop otmsyncs'



EXEC master..xp_cmdshell  'dir \\s-sql-backup.corp.local\E\'


EXEC master..xp_cmdshell  'dir \\s-sql-backup.corp.local\f\Backup\S-SQL-D4\2016' 
      
EXEC master..xp_cmdshell  'dir E:\OT38ElitServer\Import\'     
 
EXEC master..xp_cmdshell  'dir E:\TempBackup\2018-09-03\03.09.2018'      
EXEC master..xp_cmdshell  'dir E:\TempBackup\'      
EXEC master..xp_cmdshell  'type E:\TempBackup\log.log'      
"C:\Program Files\7-Zip\7z.exe" a -bd -y -ssw -m0=lzma2:d48m -mmt12 -w -xr!*Export\* -xr!Import\Backup\* \\s-sql-backup.corp.local\e$\Reports\S-SQL-D4\OT38ElitServer_2018-09-04.7z E:\OT38ElitServer > E:\TempBackup\log.log  

EXEC master..xp_cmdshell  'dir \\192.168.74.3\OT38\Backup\' 





EXEC master..xp_cmdshell  'dir \\s-sql-backup.corp.local\G\S-SQL-D4\2017-05-05\'

EXEC master..xp_cmdshell  'copy \\s-sql-backup.corp.local\G\S-SQL-D4\2017-05-05\Elit_backup_2017-05-05_22-46-13.bak  E:\OT38ElitServer\Import\' 




EXEC master..xp_cmdshell  'net user' 

EXEC master..xp_cmdshell  'net user Administrator' 
EXEC master..xp_cmdshell  'net user Гость' 

EXEC master..xp_cmdshell  'WHOAMI' 
 
EXEC master..xp_cmdshell  'net localgroup ' 

EXEC master..xp_cmdshell  'net share'
EXEC master..xp_cmdshell  'net share E$'
EXEC master..xp_cmdshell  'net share ServerSync'
EXEC master..xp_cmdshell  'net share OT38ElitServer'

EXEC master..xp_cmdshell  'net share E' 

EXEC master..xp_cmdshell  'w32tm /query /configuration'

EXEC master..xp_cmdshell  'tasklist /v'
EXEC master..xp_cmdshell  'tasklist'
*/ 


EXEC master..xp_cmdshell  'dir E:\OT38ElitServer\Log /o:s  /s /a-d'
EXEC master..xp_cmdshell  'dir E:\ /o:s  /s /a-d'
EXEC master..xp_cmdshell  'dir C:\ '
EXEC master..xp_cmdshell  'dir E:\ '
EXEC master..xp_cmdshell  'dir E:\SQLData\MSSQL10_50.MSSQLSERVER\MSSQL /o:s  /s /a-d'
EXEC master..xp_cmdshell  'dir E:\SQLData\ /o:s  /s /a-d'
EXEC master..xp_cmdshell  'dir E:\SQLData\'


    