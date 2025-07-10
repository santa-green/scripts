select * from z_Vars


--USE ElitV_DP2

--SELECT * FROM z_Vars

--проверка лицензии
SELECT * 
FROM z_Vars
WHERE VarName in ('z_ServerName','z_GMSServerLicsName','z_GMSServerLicsPort','z_ServerPort')

--Возврат лицензии из времменой таблицы
-- INSERT z_Vars
SELECT * 
FROM [S-SQL-D4].[ElitR].dbo.z_Vars
--FROM [10.1.0.155].[ElitR].dbo.z_Vars
WHERE VarName in ('z_ServerName','z_GMSServerLicsName','z_GMSServerLicsPort','z_ServerPort')

/*
--удаление лицензии

delete z_Vars
WHERE VarName in ('z_ServerName','z_GMSServerLicsName','z_GMSServerLicsPort','z_ServerPort')

*/
