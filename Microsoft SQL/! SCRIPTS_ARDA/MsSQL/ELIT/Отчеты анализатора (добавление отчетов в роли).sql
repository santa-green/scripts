

--Живые роли 205,206,208,209,210,213,214,215,406,407,424
--Все 203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,406,407,424

SELECT * 
,'INSERT INTO z_AzRoleReps(AzRoleCode,RepID) values (' + cast( AzRoleCode as varchar) + ',879);' script
,'INSERT INTO z_AzRoleReps(AzRoleCode,RepID) values (' + cast( AzRoleCode as varchar) + ',922);' script
,'INSERT INTO z_AzRoleReps(AzRoleCode,RepID) values (' + cast( AzRoleCode as varchar) + ',897);' script
, 'EXEC a_UpdateAzPerms @UserMode = 1, @Code = ' + cast(AzRoleCode as varchar) + ';'
FROM z_AzRoles WHERE AzRoleCode in (205,206,208,209,210,213,214,215,406,407,424)  


SELECT * FROM z_AzRoleReps WHERE AzRoleCode in (203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,406,407,424) and RepID in (879,922,897) 
SELECT * FROM z_AzRoleReps WHERE AzRoleCode = 414
SELECT * FROM z_AzRoles WHERE AzRoleName like 'Региональный маркетинг-менеджер%'

SELECT distinct(r.AzRoleName), r.AzRoleCode FROM z_AzRoleUsers u
right JOIN z_AzRoles r ON u.AzRoleCode = r.AzRoleCode
WHERE r.AzRoleCode in (203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,406,407,424) and r.AzRoleCode not in (203,204,207,211,212,216,217,218,219,220,221)
and u.AzRoleCode is null

--TRAN
BEGIN TRAN
    SELECT * FROM z_AzRoleReps WHERE AzRoleCode in (205,206,208,209,210,213,214,215,406,407,424) and repid in (879,922,897) ORDER BY 1 DESC
    
    INSERT INTO z_AzRoleReps(AzRoleCode,RepID) values (205,879);	INSERT INTO z_AzRoleReps(AzRoleCode,RepID) values (205,922);	INSERT INTO z_AzRoleReps(AzRoleCode,RepID) values (205,897);	EXEC a_UpdateAzPerms @UserMode = 1, @Code = 205;
    INSERT INTO z_AzRoleReps(AzRoleCode,RepID) values (206,879);	INSERT INTO z_AzRoleReps(AzRoleCode,RepID) values (206,922);	INSERT INTO z_AzRoleReps(AzRoleCode,RepID) values (206,897);	EXEC a_UpdateAzPerms @UserMode = 1, @Code = 206;
    INSERT INTO z_AzRoleReps(AzRoleCode,RepID) values (208,879);	INSERT INTO z_AzRoleReps(AzRoleCode,RepID) values (208,922);	INSERT INTO z_AzRoleReps(AzRoleCode,RepID) values (208,897);	EXEC a_UpdateAzPerms @UserMode = 1, @Code = 208;
    INSERT INTO z_AzRoleReps(AzRoleCode,RepID) values (209,879);	INSERT INTO z_AzRoleReps(AzRoleCode,RepID) values (209,922);	INSERT INTO z_AzRoleReps(AzRoleCode,RepID) values (209,897);	EXEC a_UpdateAzPerms @UserMode = 1, @Code = 209;
    INSERT INTO z_AzRoleReps(AzRoleCode,RepID) values (210,879);	INSERT INTO z_AzRoleReps(AzRoleCode,RepID) values (210,922);	INSERT INTO z_AzRoleReps(AzRoleCode,RepID) values (210,897);	EXEC a_UpdateAzPerms @UserMode = 1, @Code = 210;
    INSERT INTO z_AzRoleReps(AzRoleCode,RepID) values (213,879);	INSERT INTO z_AzRoleReps(AzRoleCode,RepID) values (213,922);	INSERT INTO z_AzRoleReps(AzRoleCode,RepID) values (213,897);	EXEC a_UpdateAzPerms @UserMode = 1, @Code = 213;
    INSERT INTO z_AzRoleReps(AzRoleCode,RepID) values (214,879);	INSERT INTO z_AzRoleReps(AzRoleCode,RepID) values (214,922);	INSERT INTO z_AzRoleReps(AzRoleCode,RepID) values (214,897);	EXEC a_UpdateAzPerms @UserMode = 1, @Code = 214;
    INSERT INTO z_AzRoleReps(AzRoleCode,RepID) values (215,879);	INSERT INTO z_AzRoleReps(AzRoleCode,RepID) values (215,922);	INSERT INTO z_AzRoleReps(AzRoleCode,RepID) values (215,897);	EXEC a_UpdateAzPerms @UserMode = 1, @Code = 215;
    INSERT INTO z_AzRoleReps(AzRoleCode,RepID) values (406,879);	INSERT INTO z_AzRoleReps(AzRoleCode,RepID) values (406,922);	INSERT INTO z_AzRoleReps(AzRoleCode,RepID) values (406,897);	EXEC a_UpdateAzPerms @UserMode = 1, @Code = 406;
    INSERT INTO z_AzRoleReps(AzRoleCode,RepID) values (407,879);	INSERT INTO z_AzRoleReps(AzRoleCode,RepID) values (407,922);	INSERT INTO z_AzRoleReps(AzRoleCode,RepID) values (407,897);	EXEC a_UpdateAzPerms @UserMode = 1, @Code = 407;
    
    SELECT * FROM z_AzRoleReps WHERE AzRoleCode in (205,206,208,209,210,213,214,215,406,407,424) and repid in (879,922,897) ORDER BY 1 DESC
ROLLBACK TRAN

SELECT * FROM z_AzRoleReps
SELECT * FROM v_reps WHERE repid in (879,922,897) --v_Reps	Анализатор - Отчеты
