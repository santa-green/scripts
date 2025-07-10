DECLARE @OldUserName varchar(20) = 'bag3',
		@NewUserName varchar(20) = 'bli1',
		@NewEmpID int =  6303--Код нового служащего
		
SELECT * FROM r_Users where UserName = @OldUserName

SELECT * FROM r_Emps where EmpID in (SELECT EmpID FROM r_Users where UserName = @OldUserName)

SELECT * FROM r_Emps where EmpID in (@NewEmpID)

SELECT * FROM r_Users where UserName = @NewUserName


--INSERT r_Users
	SELECT (SELECT MAX(ChID)+1 FROM r_Users) ChID,
	 (SELECT MAX(UserID)+1 FROM r_Users) UserID, 
	 @NewUserName UserName, 
	 @NewEmpID EmpID, 
	 Admin, Active, Emps, s_PPAcc, s_Cost, s_CCPL, s_CCPrice, s_CCDiscount, ValidOurs, 
	 ValidStocks, ValidPLs, ValidProds, CanCopyRems, BDate, EDate, UseOpenAge, CanInitAltsPL,
	 ShowPLCange, CanChangeStatus, CanChangeDiscount, CanPrintDoc, CanBuffDoc, CanChangeDocID, 
	 CanChangeKursMC, AllowRestEditDesk, AllowRestReserve, AllowRestMove, CanExportPrint, 
	 p_SalaryAcc, AllowRestChequeUnite, AllowRestChequeDel, OpenAgeBType, OpenAgeBQty,
	 OpenAgeEType, OpenAgeEQty, AllowRestViewDesk
	 FROM r_Users where UserName = @OldUserName

--поиск служащего
SELECT * FROM r_Emps where EmpName like '%Белая%'