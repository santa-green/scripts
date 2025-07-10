RESTORE DATABASE otdata_m6
FROM DISK = 'E:\sqldata\Otdata_6\OTData_backup_Dif'
WITH recovery,
MOVE 'OTData_D' TO 'E:\sqldata\Otdata_6\Otdata_M6_D',
MOVE 'OTData_L' TO 'E:\sqldata\Otdata_6\Otdata_M6_L'