IF OBJECT_ID (N'tempdb..#linenum', N'U') IS NOT NULL DROP TABLE #linenum
create table #linenum (s varchar(max))
insert into #linenum
--EXEC xp_cmdshell 'net time \\s-sql-d4 & net time \\s-ppc & net time \\s-vintage';
EXEC xp_cmdshell 'net time \\s-sql-d4 & net time \\S-PPC.CONST.ALEF.UA & net time \\s-vintage & net time \\s-elit-dp'; --s-vintage
EXEC xp_cmdshell 'net time \\192.168.70.35';
EXEC xp_cmdshell 'ping 192.168.70.35';
SELECT s wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww FROM #linenum where s like '%������� �����%'

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

�������� ������� ������������ w32tm ������������� �������
w32tm /register � ����������� � ��������� ������ �� ������������ �����������.
w32tm /unregister � ���������� ������ � �������� ���������� ������������.
w32tm /monitor � �������� ���������� �� ������.
w32tm /resync � ������� �������������� ������������� � �������� � ������������ ����������.
w32tm /config /update � ��������� � ��������� ������������.
w32tm /config /syncfromflags:domhier /update � ������ ��������� ������������� � ������������ ������.
w32tm /config /syncfromflags:manual /manualpeerlist:time.windows.com � ������ ���������� ��������� ������������� ������� �� ��������� NTP.
�������� ���������� (/query)
w32tm /query /computer:<target>  � ���������� � ������� ������������� ������������ ������� (���� ��� �� ������� � ������������ ��������� ���������).
w32tm /query /Source � �������� �������� �������.
w32tm /query /Configuration � ����� ���� �������� ������ ������� Windows.
w32tm /query /Peers � �������� ��������� ������� � �� ���������.
w32tm /query /Status � ������ ������ �������.
w32tm /query /Verbose � ��������� ����� ���� ���������� � ������ ������.

������������� ����� Net time
��� �� ����� �������������� ��������������� ������� net time ��� ������������� �������.
net time /setsntp:time.itmake.org � ������ �������� �������������.
net time /querysntp � �������� ���������� � �������� ��������� �������.
net time \\server.lan.local /set /y � �������������� ������������� � ���������� ���������.

*/