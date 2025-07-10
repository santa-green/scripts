BEGIN TRAN


--Добавление пользователя const-pashkovv
insert r_Users
	SELECT 1900 ChID, 1900 UserID, 'const\pashkovv' UserName, EmpID, Admin, Active, Emps, s_PPAcc, s_Cost, s_CCPL, s_CCPrice, s_CCDiscount, ValidOurs, ValidStocks, ValidPLs, ValidProds, CanCopyRems, BDate, EDate, UseOpenAge, CanInitAltsPL, ShowPLCange, CanChangeStatus, CanChangeDiscount, CanPrintDoc, CanBuffDoc, CanChangeDocID, CanChangeKursMC, AllowRestEditDesk, AllowRestReserve, AllowRestMove, CanExportPrint, p_SalaryAcc, AllowRestChequeUnite, AllowRestChequeDel, OpenAgeBType, OpenAgeBQty, OpenAgeEType, OpenAgeEQty, AllowRestViewDesk
	FROM r_Users where UserName = 'pvm0'
	order by 3

SELECT * FROM  r_Users --where UserName = 'pvm0'
where Admin = 1
order by 1 desc


insert r_Users
	SELECT ChID,UserID,UserName,0 EmpID,Admin,Active,Emps,s_PPAcc,s_Cost,s_CCPL,s_CCPrice,s_CCDiscount,ValidOurs,ValidStocks,ValidPLs,ValidProds,CanCopyRems,BDate,EDate,UseOpenAge,CanInitAltsPL,ShowPLCange,CanChangeStatus,CanChangeDiscount,CanPrintDoc,CanBuffDoc,CanChangeDocID,CanChangeKursMC,AllowRestEditDesk,AllowRestReserve,AllowRestMove,CanExportPrint,p_SalaryAcc,AllowRestChequeUnite,AllowRestChequeDel,OpenAgeBType,OpenAgeBQty,OpenAgeEType,OpenAgeEQty,AllowRestViewDesk

	FROM [s-sql-d4].elit.dbo.r_Users where UserName = 'gdn1'


ROLLBACK TRAN
