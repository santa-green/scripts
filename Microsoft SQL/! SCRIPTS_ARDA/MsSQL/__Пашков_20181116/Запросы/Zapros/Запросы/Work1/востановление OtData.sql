
RESTORE DATABASE OtData
FROM DISK = 'e:\sqldata\data\backup\OtData_backup'
WITH
MOVE 'OTData_D' TO 'e:\sqldata\data\OTData_D',
MOVE 'OTData_L' TO 'e:\sqldata\data\OTData_L'