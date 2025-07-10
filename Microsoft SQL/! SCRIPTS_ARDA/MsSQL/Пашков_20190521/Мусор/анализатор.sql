SELECT vr.RepID, vrg.RepGrName + '\' + vr.RepName AS RepName
FROM dbo.v_Reps vr
JOIN dbo.v_RepGrs vrg ON vrg.RepGrID=vr.RepGrID
ORDER BY 2

SELECT ru.UserID, ru.UserName, re.EmpName
FROM dbo.r_Users ru
JOIN dbo.r_Emps re ON re.EmpID=ru.EmpID
ORDER BY UserName

SELECT *
FROM z_AzRoles
WHERE 
/*Filter*/ 1=1

SELECT ru.UserID, ru.UserName, z.AzRoleCode
FROM dbo.r_Users ru
LEFT JOIN dbo.z_AzRoleUsers z ON z.UserCode = ru.USerID
where UserName = 'tester'
ORDER BY 2

SELECT ParentDescs TableDesc, ParentCode TableCode, ParentDesc RefName
FROM dbo.vz_ValidTables
ORDER BY 1

SELECT ru.UserID, ru.UserName, z.AzRoleCode
FROM dbo.r_Users ru
LEFT JOIN dbo.z_AzRoleUsers z ON z.UserCode = ru.USerID
where AzRoleCode = 11 -- 11 - ”правл€ющий сетью супермаркетов
ORDER BY 2


SELECT *  
FROM dbo.v_Reps vr
JOIN dbo.v_RepGrs vrg ON vrg.RepGrID=vr.RepGrID
ORDER BY 2

SELECT zr.RepID, zr.AzRoleCode
FROM dbo.z_AzRoleReps zr
JOIN dbo.v_Reps vr ON vr.RepID=zr.RepID
JOIN dbo.v_RepGrs vrg ON vrg.RepGrID=vr.RepGrID
--WHERE AzRoleCode = 11 
ORDER BY vrg.RepGrName, vr.RepName

SELECT * FROM z_AzRoleReps


SELECT e.EmpName,*
FROM dbo.r_Users ru
LEFT JOIN dbo.r_Emps e ON e.EmpID = ru.EmpID
LEFT JOIN dbo.z_AzRoleUsers z ON z.UserCode = ru.USerID
where UserID = 1901 and UserCode is  null -- 11 - ”правл€ющий сетью супермаркетов
ORDER BY 1


SELECT * FROM z_AzRoleReps

SELECT * FROM z_AzRoleUsers

SELECT * FROM z_rep

SELECT * FROM v_Reps

SELECT TOP 1 1 FROM z_UserVars WHERE VarName = 'Az_LastIsGroup' AND UserCode = 1901

SELECT * FROM v_RepGrs  where RepGrID in (select RepGrID from v_Reps r where (RepID in (select RepID from v_RepUsers where UserID = 1901)) or (RepID not in (select RepID from v_RepUsers))) ORDER BY RepGrName

SELECT RepID, RepName, BDate, EDate, IsReady FROM v_Reps WHERE (RepGrID = 1) And ((RepID in (select RepID from v_RepUsers where UserID = 1901)) or (RepID not in (select RepID from v_RepUsers))) ORDER BY RepName

SELECT UserID FROM v_RepUsers group by UserID


SELECT * FROM v_RepUsers where UserID = 1901

SELECT * FROM v_RepUsers where UserID = 1847
SELECT * FROM z_AzRoleUsers where UserCode = 1847
SELECT * FROM v_RepGrs  where RepGrID in (select RepGrID from v_Reps r where (RepID in (select RepID from v_RepUsers where UserID = 1901)) or (RepID not in (select RepID from v_RepUsers))) ORDER BY RepGrName


SELECT e.EmpName,*
FROM dbo.r_Users ru
LEFT JOIN dbo.r_Emps e ON e.EmpID = ru.EmpID
LEFT JOIN dbo.z_AzRoleUsers z ON z.UserCode = ru.USerID
where UserID not in (SELECT UserID FROM v_RepUsers group by UserID)
ORDER BY 1


SELECT TOP 1 1 FROM z_UserVars WHERE VarName = 'Az_ExpandedGroups' AND UserCode = 1901
SELECT TOP 1 VarValue FROM z_UserVars WITH (NOLOCK, FASTFIRSTROW) WHERE VarName = 'Az_ExpandedGroups' AND UserCode = 1901
SELECT * FROM v_RepGrs  where RepGrID in (select RepGrID from v_Reps r where (RepID in (select RepID from v_RepUsers where UserID = 1901)) or (RepID not in (select RepID from v_RepUsers))) ORDER BY RepGrName

SELECT TOP 1 1 FROM z_UserVars WHERE VarName = 'Az_ExpandedGroups' AND UserCode = 1847
SELECT TOP 1 VarValue FROM z_UserVars WITH (NOLOCK, FASTFIRSTROW) WHERE VarName = 'Az_ExpandedGroups' AND UserCode = 1847
SELECT * FROM v_RepGrs  where RepGrID in (select RepGrID from v_Reps r where (RepID in (select RepID from v_RepUsers where UserID = 1847)) or (RepID not in (select RepID from v_RepUsers))) ORDER BY RepGrName