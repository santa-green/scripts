SELECT * FROM z_Roles

SELECT * FROM z_RoleDocs where RoleCode = 30

SELECT * FROM z_RoleUsers where RoleCode = 30

SELECT * FROM z_RoleObjects where ObjCode = 5333 --RoleCode = 30

SELECT * FROM z_RoleTables

SELECT * FROM r_Users u
join r_Emps e on e.EmpID = u.EmpID
where UserName in ('bvy1','kev19','pep','201','bin2') 
or EmpName like '%Воропаев%'

SELECT * FROM r_Users where Admin = 1

SELECT * FROM r_Emps where EmpName like '%Воропаев%'

SELECT u.ChID, u.UserID, u.UserName, u.EmpID, u.Admin, u.Active,e.EmpName,* FROM r_Users u
join r_Emps e on e.EmpID = u.EmpID
where Admin = 1


SELECT u.ChID, u.UserID, u.UserName, u.EmpID, u.Admin, u.Active,e.EmpName,* FROM r_Users u
join r_Emps e on e.EmpID = u.EmpID  where u.UserName in ('tester')


sp_helprole db_owner

sp_helprolemember db_owner

SELECT * FROM z_UserObjects where UserCode = 1901
ObjCode = 5333


SELECT * FROM z_RoleObjects where ObjCode = 5333 --RoleCode = 30

SELECT * FROM z_Objects where ObjName = 'ap_ReWriteOffNegRems'