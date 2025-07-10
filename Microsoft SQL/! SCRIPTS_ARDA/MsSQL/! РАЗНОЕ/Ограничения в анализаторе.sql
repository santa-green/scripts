-- Ограничения в анализаторе
--DECLARE @UserName varchar(50) = 'const\pashkovv'
DECLARE @UserName varchar(50) = 'sat15'
--DECLARE @UserName varchar(50) = 'tlr'


SELECT ru.UserID, ru.UserName, re.EmpName, ru.Admin, z.AzRoleCode, ar.AzRoleName, av.TableCode, av.AzValids,
vt.ParentDescs , vt.ParentDesc 
FROM dbo.r_Users ru
JOIN dbo.r_Emps re ON re.EmpID=ru.EmpID
LEFT JOIN dbo.z_AzRoleUsers z ON z.UserCode = ru.USerID
LEFT JOIN z_AzRoles ar ON ar.AzRoleCode = z.AzRoleCode
LEFT JOIN z_AzValids av ON av.AzRoleCode = ar.AzRoleCode
LEFT JOIN vz_ValidTables vt ON vt.ParentCode = av.TableCode
--LEFT JOIN dbo.z_AzRoleReps arr ON arr.AzRoleCode=av.AzRoleCode
--LEFT JOIN dbo.v_Reps vr ON vr.RepID=arr.RepID
--LEFT JOIN dbo.v_RepGrs vrg ON vrg.RepGrID=vr.RepGrID
where 1=1
and ru.UserName = @UserName
--and z.AzRoleCode is null and re.EmpName not like '%уволен%'
ORDER BY 3,2


SELECT * FROM v_RepGrs  where RepGrID in (select RepGrID from v_Reps r where (RepID in (select RepID from v_RepUsers where UserID = (SELECT ru.UserID FROM dbo.r_Users ru where ru.UserName = @UserName) )) or (RepID not in (select RepID from v_RepUsers))) ORDER BY RepGrName

select * from v_Reps r where (RepID in (select RepID from v_RepUsers where UserID = (SELECT ru.UserID FROM dbo.r_Users ru where ru.UserName = @UserName) )) or (RepID not in (select RepID from v_RepUsers))
--and RepGrID = 12
ORDER BY  RepGrID 

select * from v_RepUsers where UserID = (SELECT ru.UserID FROM dbo.r_Users ru where ru.UserName = @UserName)
ORDER BY  1 

select * from z_UserStockGs where UserID = (SELECT ru.UserID FROM dbo.r_Users ru where ru.UserName = @UserName)
select * from z_UserStocks where UserID = (SELECT ru.UserID FROM dbo.r_Users ru where ru.UserName = @UserName)


/*
--добавить отчет RepID пользователю UserID
INSERT v_RepUsers (RepID,UserID,APOpen,APEdit,APDelete,APExportTemplate,APExportReport) 
            VALUES(551,    1835,     1,    0,       0,               0,             0)


-- скопировать отчеты одной роли в другую Elit
BEGIN TRAN


INSERT z_AzRoleReps
	SELECT 104 AzRoleCode, RepID FROM z_AzRoleReps where AzRoleCode = 29 and RepID not in (SELECT RepID FROM z_AzRoleReps where AzRoleCode = 104)


ROLLBACK TRAN


--не принадлижащие отчеты никому
select * from v_Reps r where RepID not in (select RepID from v_RepUsers)

SELECT * FROM dbo.r_Users ru where ru.UserName = @UserName


select * from v_Reps r where RepID not in (select RepID from v_RepUsers where UserID = 0)

BEGIN TRAN


--скопировать отчеты пользователю
insert  v_RepUsers
	SELECT RepID, 1955 UserID,APOpen,APEdit,APDelete,APExportTemplate,APExportReport  FROM v_RepUsers where UserID = 1372
	--SELECT * FROM v_RepUsers where UserID = 1955

SELECT RepID, 0, 1 APOpen, 0 APEdit, 0 APDelete, 0  APExportTemplate, 0  APExportReport FROM v_Reps
SELECT * FROM v_Reps

ROLLBACK TRAN


*/

/*
SELECT AzRoleCode  FROM z_AzRoleUsers where UserCode = (SELECT ru.UserID FROM dbo.r_Users ru where ru.UserName = @UserName)
SELECT ru.UserID FROM dbo.r_Users ru where ru.UserName = @UserName

sELECT zr.RepID, zr.AzRoleCode,*
FROM dbo.z_AzRoleReps zr
JOIN dbo.v_Reps vr ON vr.RepID=zr.RepID
JOIN dbo.v_RepGrs vrg ON vrg.RepGrID=vr.RepGrID
WHERE AzRoleCode = (SELECT AzRoleCode  FROM z_AzRoleUsers where UserCode = (SELECT ru.UserID FROM dbo.r_Users ru where ru.UserName = @UserName)) 
ORDER BY vrg.RepGrName, vr.RepName




SELECT vr.RepID, vrg.RepGrName + '\' + vr.RepName AS RepName,*
FROM dbo.v_Reps vr
JOIN dbo.v_RepGrs vrg ON vrg.RepGrID=vr.RepGrID
ORDER BY 1

SELECT RepID, RepName, BDate, EDate, IsReady FROM v_Reps WHERE (RepGrID = 16) And ((RepID in (select RepID from v_RepUsers where UserID = 1901)) or (RepID not in (select RepID from v_RepUsers))) ORDER BY RepName




exec sp_executesql N'SELECT zr.RepID, zr.AzRoleCode
FROM dbo.z_AzRoleReps zr
JOIN dbo.v_Reps vr ON vr.RepID=zr.RepID
JOIN dbo.v_RepGrs vrg ON vrg.RepGrID=vr.RepGrID
WHERE AzRoleCode = @P1 
ORDER BY vrg.RepGrName, vr.RepName',N'@P1 int',58


exec sp_executesql N'SELECT z_AzRoleUsers.AzRoleCode, z_AzRoleUsers.UserCode
FROM dbo.z_AzRoleUsers JOIN dbo.r_Users ON z_AzRoleUsers.UserCode=r_Users.UserID
WHERE AzRoleCode = @P1 
ORDER BY r_Users.UserName',N'@P1 int',58



exec sp_executesql N'SELECT z_AzValids.AzRoleCode, z_AzValids.TableCode, z_AzValids.AzValids FROM dbo.z_AzValids
WHERE AzRoleCode = @P1 ',N'@P1 int',58

SELECT * FROM z_AzValids








SELECT TOP 1 UserID FROM r_Users WITH (NOLOCK, FASTFIRSTROW) WHERE UserName='tester'	
SELECT TOP 1 EmpName FROM r_Emps m, r_Users d WITH (NOLOCK, FASTFIRSTROW) WHERE m.EmpID=d.EmpID AND UserName='tester'
select c.Length from sysobjects o, syscolumns c where c.id = o.id And o.Name = 'v_UFields' And c.name = 'OFilter'
SELECT TOP 1 VarName FROM z_UserVars WITH (NOLOCK, FASTFIRSTROW) WHERE UserCode = 1901 AND VarDesc = 'Развернутые группы'
SELECT TOP 1 VarDesc FROM z_UserVars WITH (NOLOCK, FASTFIRSTROW) WHERE UserCode = 1901 AND VarName = 'Az_ExpAndedGroups'
SELECT TOP 1 VarValue FROM z_Vars WITH (NOLOCK, FASTFIRSTROW) WHERE VarName = 'Az_SQLCommAnds'

SELECT * FROM v_RepGrs  where RepGrID in (select RepGrID from v_Reps r where (RepID in (select RepID from v_RepUsers where UserID = 1901)) or (RepID not in (select RepID from v_RepUsers))) ORDER BY RepGrName
SELECT * FROM v_RepGrs  where RepGrID in (select RepGrID from v_Reps r where (RepID in (select RepID from v_RepUsers where UserID = 1536)) or (RepID not in (select RepID from v_RepUsers))) ORDER BY RepGrName
SELECT RepID, RepName, BDate, EDate, IsReady FROM v_Reps WHERE (RepGrID = 1) And ((RepID in (select RepID from v_RepUsers where UserID = 1901)) or (RepID not in (select RepID from v_RepUsers))) ORDER BY RepName


select * from v_Reps ORDER BY 1


SELECT * FROM r_Stocks where StockID in (33,711,1252,1260,1253,1259)
SELECT distinct StockGID FROM r_Stocks where StockID in (33,711,1252,1260,1253,1259)

a_UpdateAzPerms

select * from v_RepUsers where userid = 2046
select * from v_RepUsers where userid = 1709
select * from z_AzRoleReps where AzRoleCode = 368
select count(*) from v_RepUsers where userid = 1709

SELECT count(*) FROM z_AzRoleReps where AzRoleCode = 13

--добавить новые отчеты в роль 368
insert z_AzRoleReps
	SELECT 368 AzRoleCode , RepID FROM dbo.v_Reps r where r.RepID not in (select RepID from z_AzRoleReps where AzRoleCode = 368)
*/
select * from z_AzRoles  where AzRoleCode = 368
select * from z_AzRoleReps where AzRoleCode = 368

