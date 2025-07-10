DECLARE @UserName varchar(20) = 'zoa3'

SELECT * FROM r_Users where UserName in (@UserName) --UserID = 1449

SELECT * FROM r_Emps where EmpID = (SELECT EmpID FROM r_Users where UserName = @UserName )

select * from sys.database_principals where name = @UserName

--Роли из таблицы 
SELECT * FROM z_RoleUsers 
join z_Roles on z_Roles.RoleCode = z_RoleUsers.RoleCode
where UserCode = (SELECT UserID FROM r_Users where UserName = @UserName )
order by RoleName
--Роли из базы
select (SELECT name FROM sys.database_principals where principal_id = dbrm.role_principal_id) RoleName,* from sys.database_principals dbp
join sys.database_role_members dbrm on dbrm.member_principal_id = dbp.principal_id
where dbp.name = @UserName
order by RoleName

--Документы
SELECT * FROM z_RoleDocs
join z_Docs on z_Docs.DocCode = z_RoleDocs.DocCode
where z_RoleDocs.RoleCode in 
(SELECT z_RoleUsers.RoleCode FROM z_RoleUsers 
join z_Roles on z_Roles.RoleCode = z_RoleUsers.RoleCode
where UserCode = (SELECT UserID FROM r_Users where UserName = @UserName )
)order by RoleCode,DocName 

--Таблицы
SELECT * FROM z_RoleTables
join z_Tables on z_Tables.TableCode = z_RoleTables.TableCode
where RoleCode in
(SELECT z_RoleUsers.RoleCode FROM z_RoleUsers 
join z_Roles on z_Roles.RoleCode = z_RoleUsers.RoleCode
where UserCode = (SELECT UserID FROM r_Users where UserName = @UserName )
)order by RoleCode,TableName 

--Процедуры
SELECT * FROM z_RoleObjects
join z_Objects on z_Objects.ObjCode = z_RoleObjects.ObjCode
where RoleCode in
(SELECT z_RoleUsers.RoleCode FROM z_RoleUsers 
join z_Roles on z_Roles.RoleCode = z_RoleUsers.RoleCode
where UserCode = (SELECT UserID FROM r_Users where UserName = @UserName )
)
and z_Objects.ObjType = 'P'
order by RoleCode,ObjDesc 

--Функции
SELECT * FROM z_RoleObjects
join z_Objects on z_Objects.ObjCode = z_RoleObjects.ObjCode
where RoleCode in
(SELECT z_RoleUsers.RoleCode FROM z_RoleUsers 
join z_Roles on z_Roles.RoleCode = z_RoleUsers.RoleCode
where UserCode = (SELECT UserID FROM r_Users where UserName = @UserName )
)
and z_Objects.ObjType <> 'P'
order by RoleCode,ObjDesc 


--Документы + Таблицы
SELECT * FROM z_RoleTables
join z_Tables on z_Tables.TableCode = z_RoleTables.TableCode
join z_Docs on z_Docs.DocCode = z_Tables.DocCode

where RoleCode in
(SELECT z_RoleUsers.RoleCode FROM z_RoleUsers 
join z_Roles on z_Roles.RoleCode = z_RoleUsers.RoleCode
where UserCode = (SELECT UserID FROM r_Users where UserName = @UserName )
)order by RoleCode,TableName 


/*
SELECT * FROM z_UserTables

SELECT * FROM z_UserDocs

SELECT * FROM z_UserObjects --group by 

--SELECT * FROM z_User

SELECT * FROM r_Users where UserID in (1449,1460) 

exec sp_helprole 

sp_helplogins 'rly'

sp_helpservlogins 'rly'

sp_helpsrvrole 

sp_helpuser 'rly'

sp_helpsrvrolemember 

select * from sys.database_principals 


SELECT USER_NAME(member_principal_id) name ,* FROM sys.database_role_members where USER_NAME(member_principal_id) = 'rly'
SELECT USER_NAME(member_principal_id) name ,* FROM sys.database_role_members where member_principal_id = user_id('rly')
SELECT * FROM sys.database_role_members where member_principal_id = user_id('rly')


select * from sys.database_principals dbp
join sys.database_role_members dbrm on dbrm.member_principal_id = dbp.principal_id
where dbrm.member_principal_id = user_id('rly')

*/

/*
--Документы
SELECT z_RoleDocs.*,  FROM z_RoleDocs
join z_Docs on z_Docs.DocCode = z_RoleDocs.DocCode
where z_RoleDocs.RoleCode in 
(SELECT z_RoleUsers.RoleCode FROM z_RoleUsers 
join z_Roles on z_Roles.RoleCode = z_RoleUsers.RoleCode
where UserCode = (SELECT UserID FROM r_Users where UserName = @UserName )
)order by RoleCode,DocName 

--Таблицы
SELECT * FROM z_RoleTables




DECLARE @UserName varchar(20) = 'rly'

SELECT * FROM (
SELECT distinct * FROM (
SELECT TableName FROM z_RoleTables
join z_Tables on z_Tables.TableCode = z_RoleTables.TableCode
where RoleCode in
(SELECT z_RoleUsers.RoleCode FROM z_RoleUsers 
join z_Roles on z_Roles.RoleCode = z_RoleUsers.RoleCode
where UserCode = (SELECT UserID FROM r_Users where UserName = @UserName )
)
)s1
where  TableName  in ('r_Prods','t_RetD','t_Ret','t_CRRetD','t_CRRet','t_CRetD','t_CRet','t_PInP','t_zInP','at_t_IOResD','at_t_IORes','t_VenA','t_VenD','t_Ven','t_SRecA','t_SRec','t_SRecD','t_ExcD','t_Exc','t_EstD','t_Est','t_RecD','t_Rec','t_CstD','t_Cst','t_SaleD','t_Sale','t_SExpA','t_SExp','t_SExpD','t_InvD','t_Inv','t_ExpD','t_Exp','t_EppD','t_Epp','t_AccD','t_Acc')
) s2
right join (

SELECT distinct TableName FROM z_Tables where  TableName  in ('r_Prods','t_RetD','t_Ret','t_CRRetD','t_CRRet','t_CRetD','t_CRet','t_PInP','t_zInP','at_t_IOResD','at_t_IORes','t_VenA','t_VenD','t_Ven','t_SRecA','t_SRec','t_SRecD','t_ExcD','t_Exc','t_EstD','t_Est','t_RecD','t_Rec','t_CstD','t_Cst','t_SaleD','t_Sale','t_SExpA','t_SExp','t_SExpD','t_InvD','t_Inv','t_ExpD','t_Exp','t_EppD','t_Epp','t_AccD','t_Acc')
)s3 on s3.TableName = s2.TableName

*/