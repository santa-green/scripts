--Добавление прав 'sa' пользователю 'pvm0'
----------------------------------------------------------------------------------------------------------------
----Заполнение r_Users------------------------------------------------------------------------------------------
INSERT INTO r_Users
       (ChID, UserID, UserName, EmpID, Admin, Active, Emps, s_PPAcc, s_Cost, s_CCPL, s_CCPrice, s_CCDiscount, ValidOurs, ValidStocks, ValidPLs, ValidProds, 
       CanCopyRems, BDate, EDate, UseOpenAge, CanInitAltsPL, ShowPLCange, CanChangeStatus, CanChangeDiscount, CanPrintDoc, CanBuffDoc, CanChangeDocID, 
       CanChangeKursMC, AllowRestEditDesk, AllowRestReserve, AllowRestMove, CanExportPrint, p_SalaryAcc,  AllowRestChequeUnite, 
       AllowRestChequeDel, OpenAgeBType, OpenAgeBQty, OpenAgeEType, OpenAgeEQty)

SELECT (SELECT MAX(ChID)+1 FROM r_Users) ChID, (SELECT MAX(UserID)+1 FROM r_Users) UserID, 'pvm0' UserName, 0 EmpID, Admin,
       Active, Emps, s_PPAcc, s_Cost, s_CCPL, s_CCPrice, s_CCDiscount, ValidOurs, ValidStocks, ValidPLs, ValidProds, CanCopyRems, BDate, EDate, UseOpenAge, 
       CanInitAltsPL, ShowPLCange, CanChangeStatus, CanChangeDiscount, CanPrintDoc, CanBuffDoc, CanChangeDocID, CanChangeKursMC, AllowRestEditDesk, 
       AllowRestReserve, AllowRestMove, CanExportPrint, p_SalaryAcc,  AllowRestChequeUnite, AllowRestChequeDel, OpenAgeBType, OpenAgeBQty,
       OpenAgeEType, OpenAgeEQty

FROM r_Users WHERE UserName like 'sa' 
go
----------------------------------------------------------------------------------------------------------------
----Заполнение z_UserVars---------------------------------------------------------------------------------------
DECLARE @AUserCode int

SET @AUserCode=(SELECT UserID FROM r_Users WHERE UserName like 'pvm0')

INSERT INTO z_UserVars
     (UserCode, VarName, VarDesc, VarValue, VarInfo, VarType, VarSelType,  VarGroup, VarPosID, LabelPos, VarExtInfo, VarVisible)
SELECT @AUserCode, VarName, VarDesc, VarValue, VarInfo, VarType, VarSelType,  VarGroup, VarPosID, LabelPos, VarExtInfo, VarVisible
     from z_UserVars WHERE USERCode=0 AND VarName not in (SELECT VarName FROM z_UserVars WHERE UserCode=@AUserCode)
----------------------------------------------------------------------------------------------------------------
