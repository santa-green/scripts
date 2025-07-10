--EXEC xp_fixeddrives 
--EXEC ap_CheckFreeSpaceOnServerDisk 


SELECT distinct(volume_mount_point),
  '-->>' 'SIZE', 
  total_bytes/1048576 as 'Size, Mb', total_bytes/1048576/1024 as 'Size, Gb',
  '-->>' 'FREE',
  available_bytes/1048576 as 'Free, Mb', available_bytes/1048576/1024 as 'Free, Gb',
  (select ceiling(((available_bytes/1048576* 1.0)/(total_bytes/1048576* 1.0) *100))) as 'FreePercentage, %'
FROM sys.master_files AS f CROSS APPLY 
  sys.dm_os_volume_stats(f.database_id, f.file_id)
group by volume_mount_point, total_bytes/1048576, 
  available_bytes/1048576 order by 1