RESTORE DATABASE OTData_Test
FROM DISK = 'E:\SQLData\OTData_Test\OTData_backup'
WITH
MOVE 'OTData_D' TO 'E:\SQLData\OTData_Test\OTData_D',
MOVE 'OTData_L' TO 'E:\SQLData\OTData_Test\OTData_L'