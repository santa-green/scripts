IF OBJECT_ID (N'tempdb..#linenum', N'U') IS NOT NULL DROP TABLE #linenum
create table #linenum (s varchar(max))
insert into #linenum
--EXEC xp_cmdshell 'net time \\s-sql-d4 & net time \\s-ppc & net time \\s-vintage';
EXEC xp_cmdshell 'net time \\s-sql-d4 & net time \\S-PPC.CONST.ALEF.UA & net time \\s-vintage & net time \\s-elit-dp'; --s-vintage
EXEC xp_cmdshell 'net time \\192.168.70.35';
EXEC xp_cmdshell 'ping 192.168.70.35';
SELECT s wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww FROM #linenum where s like '%“екущее врем€%'

use alef_elit
EXEC xp_cmdshell 'net time \\s-elit-dp';
EXEC xp_cmdshell 'net time \\S-PPC.CONST.ALEF.UA';
EXEC xp_cmdshell 'net time \\172.30.0.110';
EXEC xp_cmdshell 'net time \\s-sql-d4 /set /y';
EXEC xp_cmdshell 'w32tm /query /Status';
EXEC xp_cmdshell 'w32tm /query /Source';
EXEC xp_cmdshell 'w32tm /monitor';
EXEC xp_cmdshell 'w32tm /register';
EXEC xp_cmdshell 'w32tm /query /Configuration';
EXEC xp_cmdshell 'w32tm /config /syncfromflags:manual /manualpeerlist:s-vdc3.corp.local /update';
EXEC xp_cmdshell 'w32tm /config /update';
EXEC xp_cmdshell 'net stop w32time';
EXEC xp_cmdshell 'net start w32time';
EXEC xp_cmdshell 'w32tm /resync';

EXEC xp_cmdshell 'w32tm /query /Source';
EXEC [S-SQL-D4].master.dbo.xp_cmdshell 'w32tm /query /Source';

EXEC [S-SQL-D4].master.dbo.xp_cmdshell 'w32tm /query /Status';
EXEC [S-SQL-D4].master.dbo.xp_cmdshell 'w32tm /query /manualpeerlist';
EXEC [S-SQL-D4].master.dbo.xp_cmdshell 'w32tm /monitor';
EXEC [S-SQL-D4].master.dbo.xp_cmdshell 'w32tm /resync';

/*
Alef_Elit2 s-vdc3.corp.local 
alef_elit s-dc.const.alef.ua 
s-vdc4.corp.local [10.1.0.84]

ќсновные команды конфигурации w32tm синхронизации времени
w32tm /register Ч –егистраци€ и включение службы со стандартными параметрами.
w32tm /unregister Ч ќтключение службы и удаление параметров конфигурации.
w32tm /monitor Ч ѕросмотр информации по домену.
w32tm /resync Ч  оманда принудительной синхронизации с заданным в конфигурации источником.
w32tm /config /update Ч ѕрименить и сохранить конфигурацию.
w32tm /config /syncfromflags:domhier /update Ц «адаем настройку синхронизации с контроллером домена.
w32tm /config /syncfromflags:manual /manualpeerlist:time.windows.com Ц задать конкретные источники синхронизации времени по протоколу NTP.
ѕросмотр параметров (/query)
w32tm /query /computer:<target>  Ч »нформаци€ о стутусе синхронизации определенной станции (если им€ не указано Ч используетс€ локальный компьютер).
w32tm /query /Source Ц ѕоказать источник времени.
w32tm /query /Configuration Ч ¬ывод всех настроек службы времени Windows.
w32tm /query /Peers Ц ѕоказать источники времени и их состо€ние.
w32tm /query /Status Ц —татус службы времени.
w32tm /query /Verbose Ц ѕодробный вывод всей информации о работе службы.

—инхронизаци€ через Net time
“ак же можно воспользоватс€ вспомогательной службой net time дл€ синхронизации времени.
net time /setsntp:time.itmake.org Ч «адаем источник синхронизации.
net time /querysntp Ч просмотр информации о заданном источнике времени.
net time \\server.lan.local /set /y Ц ѕринудительна€ синхронизаци€ с указанного источника.

*/