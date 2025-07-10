--Проверка процедур,функций путем изменения

IF OBJECT_ID (N'tempdb..#temptable', N'U') IS NOT NULL DROP TABLE #temptable
create table #temptable (object_id int, name NVARCHAR(MAX), ErrorNumber int, ErrorSeverity int, ErrorState int, ErrorProcedure NVARCHAR(MAX), ErrorLine int, ErrorMessage NVARCHAR(MAX))

DECLARE @script NVARCHAR(MAX)
DECLARE @object_id NVARCHAR(MAX)
DECLARE @name NVARCHAR(MAX)
DECLARE @ResultForPos INT 
DECLARE CUR CURSOR STATIC 
FOR
SELECT  m.object_id, o.name, STUFF (definition,CHARINDEX ('create',definition),6,'alter')  script FROM  sys.sql_modules m
INNER JOIN sys.objects o
ON m.object_id = o.object_id
WHERE not (o.type = 'D' or  type='TR' or type='TA') --исключить тригера и ограничения
ORDER BY 3
--WHERE m.definition Like '%t_DiscUpdateDCard_120%'


OPEN CUR
FETCH NEXT FROM CUR INTO @object_id, @name, @script
WHILE @@FETCH_STATUS = 0    		 
BEGIN
	--skript
	--EXEC SP_EXECUTESQL @script


  BEGIN TRY 

EXEC @ResultForPos = SP_EXECUTESQL @script
--if  @ResultForPos <> 0 print @ResultForPos

  END TRY  
  BEGIN CATCH

  insert #temptable
    SELECT  
	@object_id object_id,
	@name name,
    ERROR_NUMBER() AS ErrorNumber  
    ,ERROR_SEVERITY() AS ErrorSeverity  
    ,ERROR_STATE() AS ErrorState  
    ,case when ERROR_PROCEDURE() is null then @script else ERROR_PROCEDURE() end  AS ErrorProcedure  
    ,ERROR_LINE() AS ErrorLine  
    ,ERROR_MESSAGE() AS ErrorMessage; 

	print ERROR_PROCEDURE()
	--print ERROR_MESSAGE()
	if ERROR_PROCEDURE() is null print @script

  END CATCH  

FETCH NEXT FROM CUR INTO @object_id, @name, @script
	
END 
CLOSE CUR
DEALLOCATE CUR

SELECT * FROM #temptable

/*
zf_GetUserCode

SELECT   STUFF (definition,CHARINDEX ('create',definition),6,'alter')  script,* FROM  sys.sql_modules m
INNER JOIN sys.objects o
ON m.object_id = o.object_id
test_CheckReplica

SELECT * FROM  sys.sql_modules m
INNER JOIN sys.objects o
ON m.object_id = o.object_id
where m.object_id = 109959468

DF_1

SELECT distinct o.type FROM  sys.sql_modules m
INNER JOIN sys.objects o
ON m.object_id = o.object_id
where o.type != 'D'


test_CheckReplica
ap_VC_Exprot_SaleTemp_Odessa
ap_VC_SaleTemp_Export_401
ap_VC_SaleTemp_Export_test


ap_VC_Exprot_SaleTemp_Harkov
ap_VC_ImportOrders_Odessa
ap_VC_Exprot_SaleTemp_Dnepr
ap_VC_Exprot_SaleTemp_Kiev
*/