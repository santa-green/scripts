select * from z_Vars


--USE ElitV_DP2

--SELECT * FROM z_Vars

--�������� ��������
SELECT * 
FROM z_Vars
WHERE VarName in ('z_ServerName','z_GMSServerLicsName','z_GMSServerLicsPort','z_ServerPort')

--������� �������� �� ��������� �������
-- INSERT z_Vars
SELECT * 
FROM [S-SQL-D4].[ElitR].dbo.z_Vars
--FROM [10.1.0.155].[ElitR].dbo.z_Vars
WHERE VarName in ('z_ServerName','z_GMSServerLicsName','z_GMSServerLicsPort','z_ServerPort')

/*
--�������� ��������

delete z_Vars
WHERE VarName in ('z_ServerName','z_GMSServerLicsName','z_GMSServerLicsPort','z_ServerPort')

*/
