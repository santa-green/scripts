DECLARE @usr varchar(max) = 2090

SELECT * FROM [ElitR].dbo.av_UserInfo WHERE EmpName like '%' + @usr + '%' OR UserName like '%' + @usr + '%' OR EmpID = @usr OR UserID = @usr

;WITH UID_CTE (Usver) as (
    select @usr
    --UNION select 1941
    --UNION select 6808
    --UNION select 6809 
)

SELECT rus.UserName, ru.UserCode, rem.EmpName, * FROM z_AzRoleUsers ru --z_AzRoleUsers	Роли Анализатора - Пользователи
JOIN z_AzRoles r ON r.AzRoleCode = ru.AzRoleCode --z_AzRoles	Роли Анализатора
JOIN z_AzRoleReps rp ON rp.AzRoleCode = ru.AzRoleCode --z_AzRoleReps	Роли Анализатора - Отчёты
JOIN v_Reps vr ON vr.RepID = rp.repid --v_Reps	Анализатор - Отчеты
JOIN r_Users rus ON rus.UserID = ru.UserCode
JOIN r_Emps rem ON rem.EmpID = rus.EmpID
WHERE r.AzRoleCode in (2090)
--WHERE r.AzRoleCode in (430)
--WHERE ru.UserCode in (SELECT UserID FROM av_UserInfo WHERE EmpID in (SELECT * FROM UID_CTE) OR UserID in(SELECT * FROM UID_CTE))

SELECT vr.repid, vr.repname FROM z_AzRoles za 
JOIN z_AzRoleReps rp ON rp.AzRoleCode = za.AzRoleCode
JOIN v_Reps vr ON vr.RepID = rp.RepID 
WHERE za.AzRoleCode = 328 --328 Бухгалтер (32 отчета) (pva8)
EXCEPT
SELECT vr.repid, vr.repname FROM z_AzRoles za 
JOIN z_AzRoleReps rp ON rp.AzRoleCode = za.AzRoleCode
JOIN v_Reps vr ON vr.RepID = rp.RepID 
WHERE za.AzRoleCode = 413 --413 Бухгалтер фирма 3 (30 отчетов) (zen)

IF EXISTS (SELECT * FROM Elit.dbo.av_UserInfo WITH(NOLOCK) WHERE EmpName like '%rka0%' OR UserName like '%rka0%' OR EmpID like '%rka0%')
    SELECT 'r_Users+r_Emps' 'TABLE', EmpID 'EmpID / Код служащего', UserID, UserName, [Admin], Active, EmpName, UAEmpName, BirthDay, MilProfes, Notes, BirthPlace FROM Elit.dbo.av_UserInfo WITH(NOLOCK)  
WHERE EmpName like '%rka0%' OR UserName like '%rka0%' OR EmpID like '%rka0%'
ELSE (SELECT 'OK')

use ElitDistr
SELECT * FROM r_Emps
SELECT * FROM r_Users WHERE UserName like '%rkv%'
SELECT * FROM elit..r_Users WHERE UserName like '%zen%'


SELECT * FROM elit..r_Users WHERE UserName like '%pva8%'
SELECT * FROM ElitDistr..r_Users WHERE UserName like '%rkv%'
SELECT * FROM ElitDistr..r_Users WHERE EmpID = 7131
SELECT * FROM r_Users WHERE UserName like '%pva8%'

SELECT top(10)* FROM z_logupdate ORDER BY DocDate DESC
SELECT top(10)* FROM elit..z_logupdate WHERE UserCode = 2106 ORDER BY LogID DESC

SELECT * FROM ElitDistr..r_Users WHERE UserName like '%pva8%'
SELECT * FROM ElitDistr..r_Emps WHERE EmpName like '%румянцев%'

begin tran
    SELECT * FROM ElitDistr..r_Users WHERE UserName IN ('pva8', 'zen')
    INSERT INTO ElitDistr..r_Users 
    --SELECT (SELECT MAX(CHID) + 1 FROM ElitDistr..r_Users) CHID, UserID, UserName, EmpID, Admin, Active, Emps, s_PPAcc, s_Cost, s_CCPL, s_CCPrice, s_CCDiscount, ValidOurs, ValidStocks, ValidPLs, ValidProds, CanCopyRems, BDate, EDate, UseOpenAge, CanInitAltsPL, ShowPLCange, CanChangeStatus, CanChangeDiscount, CanPrintDoc, CanBuffDoc, CanChangeDocID, CanChangeKursMC, AllowRestEditDesk, AllowRestReserve, AllowRestMove, CanExportPrint, p_SalaryAcc, AllowRestChequeClose, AllowRestChequeUnite, AllowRestChequeDel, OpenAgeBType, OpenAgeBQty, OpenAgeEType, OpenAgeEQty FROM ElitDistr..r_Users WHERE UserName = 'zen'
    SELECT 1974 CHID, 1974 UserID, 'pva8' UserName, 10564 EmpID, Admin, Active, Emps, s_PPAcc, s_Cost, s_CCPL, s_CCPrice, s_CCDiscount, ValidOurs, ValidStocks, ValidPLs, ValidProds, CanCopyRems, BDate, EDate, UseOpenAge, CanInitAltsPL, ShowPLCange, CanChangeStatus, CanChangeDiscount, CanPrintDoc, CanBuffDoc, CanChangeDocID, CanChangeKursMC, AllowRestEditDesk, AllowRestReserve, AllowRestMove, CanExportPrint, p_SalaryAcc, AllowRestChequeClose, AllowRestChequeUnite, AllowRestChequeDel, OpenAgeBType, OpenAgeBQty, OpenAgeEType, OpenAgeEQty FROM ElitDistr..r_Users WHERE UserName = 'zen'
    SELECT * FROM ElitDistr..r_Users WHERE UserName IN ('pva8', 'zen')
rollback tran

SELECT * FROM ElitDistr..r_Users WHERE UserName like '%ZEN%' ORDER BY ChID DESC
SELECT * FROM ElitDistr..r_Users ORDER BY EmpID DESC
r_emps
z_RelationError
select dbo.zf_GetTableDesc4Name('r_Users')