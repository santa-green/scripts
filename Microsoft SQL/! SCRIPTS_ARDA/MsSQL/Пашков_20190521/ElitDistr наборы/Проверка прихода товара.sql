--0 проверка прихода товара 
-- цена в файле import_t_Rec-ElitDistr.xlsx без НДС

USE ElitDistr
EXECUTE AS LOGIN = 'pvm0' -- для запуска OPENROWSET('Microsoft.ACE.OLEDB.12.0'
GO
--REVERT


IF OBJECT_ID (N'tempdb..#tmp', N'U') IS NOT NULL DROP TABLE #tmp
CREATE TABLE #tmp (ProdID int null, PPID int null, Qty numeric(21,9) null, Price numeric(21,9) null)
