--список связанных серверов
SELECT * FROM sys.servers where name in 
(
'S-SQL-D4','CP1_DP','S-MARKETA','S-MARKETA2','S-MARKETA3','S-MARKETA4','192.168.22.21','192.168.157.22','192.168.174.38','192.168.174.30','192.168.174.31'
)