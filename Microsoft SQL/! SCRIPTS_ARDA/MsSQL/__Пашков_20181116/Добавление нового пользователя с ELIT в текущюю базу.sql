BEGIN TRAN

--Скопировать пользователя из базы Elit в текушюю базу
	DECLARE @UserName varchar(50) = 'CONST\gancev'

			
	SELECT * FROM Elit.dbo.r_Users where UserName = @UserName

	SELECT * FROM Elit.dbo.r_Emps where EmpID in (SELECT EmpID FROM Elit.dbo.r_Users where UserName = @UserName)


	INSERT r_Users
		SELECT (SELECT MAX(ChID)+1 FROM r_Users) ChID,
		 (SELECT MAX(UserID)+1 FROM r_Users) UserID, 
		 UserName, 
		 EmpID, 
		 Admin, Active, Emps, s_PPAcc, s_Cost, s_CCPL, s_CCPrice, s_CCDiscount, ValidOurs, 
		 ValidStocks, ValidPLs, ValidProds, CanCopyRems, BDate, EDate, UseOpenAge, CanInitAltsPL,
		 ShowPLCange, CanChangeStatus, CanChangeDiscount, CanPrintDoc, CanBuffDoc, CanChangeDocID, 
		 CanChangeKursMC, AllowRestEditDesk, AllowRestReserve, AllowRestMove, CanExportPrint, 
		 p_SalaryAcc, AllowRestChequeUnite, AllowRestChequeDel, OpenAgeBType, OpenAgeBQty,
		 OpenAgeEType, OpenAgeEQty, AllowRestViewDesk
		 FROM Elit.dbo.r_Users where UserName = @UserName

	--требуется для базы Elit
	--INSERT z_UserVars
		SELECT   UserCode , 
		VarName ,VarDesc,VarValue,VarInfo,VarType,VarSelType,VarGroup,VarPosID,LabelPos,VarExtInfo,VarVisible,ObjectDef 
		from z_UserVars 
		WHERE  UserCode = 2002


ROLLBACK TRAN


--поиск служащего
--SELECT * FROM r_Emps where EmpName like '%Белая%'