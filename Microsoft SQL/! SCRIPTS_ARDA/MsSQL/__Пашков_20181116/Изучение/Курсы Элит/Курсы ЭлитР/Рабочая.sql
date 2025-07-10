Begin Tran

DECLARE @TableName varchar(255), @Sql nvarchar(max),@DocName varchar(255)

DECLARE c CURSOR FOR 
SELECT t.TableName,d.DocName FROM z_Docs d left join z_Tables t on d.DocCode = t.DocCode
 WHERE d.FormClass <> ''  AND d.DocCode IN (SELECT a.DocCode FROM z_AppDocs a WHERE a.AppCode IN (100, 101, 102, 103, 104, 105,11000)) and d.DocCatCode=1 and t.TableCode like '%001' 
 and d.Doccode in (11002,11021,11022,11003,11011,11004,11012,11015,11035,11016,11321,11322,11018)
   ORDER BY d.DocName; -- Таблица с которой вытягиваем
OPEN  c;
FETCH NEXT FROM c INTO @TableName,@DocName;
WHILE @@fetch_status = 0
BEGIN
--Меняем курс ОВ в документах
set @sql ='
Begin Tran
Update d
set d.KursMC =28.00
From '+@TableName+' d 
where DocDate >''20160229'' and d.KursMC=27.00
and d.OurID in (7,8,9) and d.CodeID in ( )
Rollback

'
Print @DocName
Print @TableName
Print @sql


FETCH NEXT FROM c INTO @TableName,@DocName;
END
CLOSE c
DEALLOCATE c

Rollback Tran
go


SELECT t.TableName,d.DocName,d.DocCode FROM z_Docs d left join z_Tables t on d.DocCode = t.DocCode
 WHERE d.FormClass <> ''  AND d.DocCode IN (SELECT a.DocCode FROM z_AppDocs a WHERE a.AppCode IN (100, 101, 102, 103, 104, 105,11000)) and d.DocCatCode=1 and t.TableCode like '%001' 
 and d.Doccode in (11002,11021,11022,11003,11011,11004,11012,11015,11035,11016,11321,11322,11018)
   ORDER BY d.DocName;





   Select *
   From z_Tables
   Where DocCode = 11011


   Select *
   From t_MonRec
