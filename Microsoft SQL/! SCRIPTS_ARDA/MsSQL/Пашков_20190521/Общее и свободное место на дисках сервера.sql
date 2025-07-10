/*для включения xp_cmdshell
-- To allow advanced options to be changed.
EXEC sp_configure 'show advanced options', 1
GO
-- To update the currently configured value for advanced options.
RECONFIGURE
GO
-- To enable the feature.
EXEC sp_configure 'xp_cmdshell', 1
GO
-- To update the currently configured value for this feature.
RECONFIGURE
GO
*/

declare @drives table (drive char(1), free int)
insert into @drives exec xp_fixeddrives

--SELECT * FROM @drives

declare @drive char(1), @str varchar(255)
declare @tmp table (cmd_output varchar(255))
declare @drives_info table (drive char(1), free_bytes bigint, total_bytes bigint)

declare cur cursor local fast_forward
for select drive from @drives order by drive

open cur
fetch next from cur into @drive

while @@fetch_status = 0
begin
	delete from @tmp
	set @str = 'exec xp_cmdshell ''fsutil volume diskfree ' + @drive + ':'''	
	insert into @tmp exec (@str)
	
	insert into @drives_info
	select
		@drive,
		substring(t1.cmd_output, charindex(':', t1.cmd_output) + 2, len(t1.cmd_output) - charindex(':', t1.cmd_output) - 2),
		substring(t2.cmd_output, charindex(':', t2.cmd_output) + 2, len(t2.cmd_output) - charindex(':', t2.cmd_output) - 2)
        from @tmp t1, @tmp t2
	where (t1.cmd_output like 'Total # of free bytes%' and t2.cmd_output like 'Total # of bytes%') or
	      (t1.cmd_output like 'Всего свободно байт%' and t2.cmd_output like 'Всего байт%') 
	

	fetch next from cur into @drive
end
close cur 
deallocate cur 

select *, cast(free_bytes*100.0/total_bytes as numeric(15,2)) as [% free] from @drives_info

