--alter table svintage_rkeeper_1_1_ping_log alter column Net_Status char(5)
SELECT top 1000 * FROM svintage_rkeeper_1_1_ping_log WITH(NOLOCK) ORDER BY Log_time DESC
SELECT * FROM svintage_rkeeper_1_1_ping_log WITH(NOLOCK) ORDER BY Log_time DESC
SELECT * FROM svintage_rkeeper_1_1_ping_log WITH(NOLOCK) WHERE Net_Status = 'True' ORDER BY Log_time DESC
SELECT * FROM svintage_rkeeper_1_1_ping_log WITH(NOLOCK) WHERE Net_Status = 'False' ORDER BY Log_time DESC
SELECT * FROM svintage_rkeeper_1_1_ping_log WITH(NOLOCK) ORDER BY Log_time DESC


IF (SELECT Net_Status FROM svintage_rkeeper_1_1_ping_log WHERE ID = (SELECT MAX(ID) FROM svintage_rkeeper_1_1_ping_log)) = 'True' 
    AND (SELECT Net_Status FROM svintage_rkeeper_1_1_ping_log WHERE ID = (SELECT MAX(ID)-1 FROM svintage_rkeeper_1_1_ping_log)) = 'False'


SELECT * FROM svintage_rkeeper_1_1_ping_log t1, svintage_rkeeper_1_1_ping_log t2 WITH(NOLOCK) 
WHERE t1.Net_Status = 'True' and t2.Net_Status ORDER BY Log_time DESC


--Выборка всех отключений станции 1.1.
if OBJECT_ID('tempdb..#hub', 'U') IS NOT NULL DROP TABLE #hub
select top(0) * into #hub from svintage_rkeeper_1_1_ping_log

DECLARE @row int = 1
WHILE @row <= (SELECT count(*) FROM svintage_rkeeper_1_1_ping_log)
begin
    IF (SELECT COUNT(*) FROM
    (
    SELECT * FROM svintage_rkeeper_1_1_ping_log WHERE (id = @row and net_status = 'True')
    UNION ALL
    SELECT * FROM svintage_rkeeper_1_1_ping_log WHERE (id = (@row + 1) and net_status = 'False')
    ) m ) = 2
    --SELECT * FROM svintage_rkeeper_1_1_ping_log WHERE ID = @row + 1
    insert into #hub SELECT m.Net_Status, m.Log_time FROM svintage_rkeeper_1_1_ping_log m WHERE m.ID = @row + 1
    set @row += 1
end

SELECT * FROM (
SELECT ID, Net_Status, Log_time
, (SELECT Net_Status FROM svintage_rkeeper_1_1_ping_log s where s.id = (m.id - 1)) Net_Status_do
, (SELECT Log_time FROM svintage_rkeeper_1_1_ping_log s where s.id = (m.id - 1)) Log_time_do
FROM svintage_rkeeper_1_1_ping_log m
) s1  
where Net_Status <> Net_Status_do and Net_Status = 'False'
ORDER BY id desc

--SELECT * FROM svintage_rkeeper_1_1_ping_log t1 
--WHERE ID in (
--    SELECT ID FROM svintage_rkeeper_1_1_ping_log t2 
--    WHERE t2.Net_Status = 'False' and EXISTS(SELECT * FROM svintage_rkeeper_1_1_ping_log WHERE Net_Status = 'True' and ID = (t2.ID+1))
--    ) ORDER BY ID DESC


SELECT * FROM svintage_rkeeper_1_1_ping_log t1 
WHERE t1.Net_Status = 'False' and EXISTS (SELECT * FROM svintage_rkeeper_1_1_ping_log t2 WHERE t2.Net_Status = 'True' and t2.ID = (t1.ID-1))
ORDER BY ID DESC

    DECLARE @IP_address char(15) = '192.168.70.35'
    DECLARE @ping varchar(max) = 'ping ' + @ip_address
    select @ping
    EXEC xp_cmdshell @ping
