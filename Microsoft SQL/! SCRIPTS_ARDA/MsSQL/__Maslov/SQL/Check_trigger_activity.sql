DECLARE @name VARCHAR(256)
DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD 
FOR 
SELECT o.name AS Object_Name
FROM sys.sql_modules m
INNER JOIN sys.objects o
ON m.object_id = o.object_id
WHERE  /*m.definition Like'%TReplica_Del_z_LogDiscRec%' or m.definition LIKE '%TRel1_Ins_r_CompsAdd%'
and */o.type in ('TR')--('P ','TF','FN')
order by LEN(m.definition)

OPEN CURSOR1
	FETCH NEXT FROM CURSOR1 INTO @name
WHILE @@FETCH_STATUS = 0	 
BEGIN

	IF OBJECTPROPERTY(OBJECT_ID(@name), 'ExecIsTriggerDisabled') = 1 PRINT @name + ' disabled'
		
	FETCH NEXT FROM CURSOR1 INTO @name
END
CLOSE CURSOR1
DEALLOCATE CURSOR1