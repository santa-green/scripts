EXEC xp_fixeddrives 
--EXEC ap_CheckFreeSpaceOnServerDisk 

--������ ������ ������� �� ������� ���� ������
SELECT distinct(volume_mount_point), 
  total_bytes/1048576 as Size_in_MB, 
  available_bytes/1048576 as Free_in_MB,
  (select ceiling(((available_bytes/1048576* 1.0)/(total_bytes/1048576* 1.0) *100))) as FreePercentage
FROM sys.master_files AS f CROSS APPLY 
  sys.dm_os_volume_stats(f.database_id, f.file_id)
group by volume_mount_point, total_bytes/1048576, 
  available_bytes/1048576 order by 1

  SELECT * FROM   sys.dm_os_volume_stats(49,1) --���� F
  SELECT * FROM   sys.dm_os_volume_stats(1,1) --���� E
