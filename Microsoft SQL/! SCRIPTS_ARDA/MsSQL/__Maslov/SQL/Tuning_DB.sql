-- 1. Import license.
/*
INSERT z_Vars
SELECT * 
FROM [S-SQL-D4].[ElitR].dbo.z_Vars
--FROM [10.1.0.155].[ElitR].dbo.z_Vars
WHERE VarName in ('z_ServerName','z_GMSServerLicsName','z_GMSServerLicsPort','z_ServerPort')
*/
-- 2. Add new employer or copy all list in DB.
-- 3. Create user - kassir or someone.

-- 4. Get prods from main base.
/*TRUNCATE TABLE r_Banks;
INSERT r_Banks SELECT ChID, BankID, BankName, Address, PostIndex, City, Region, Phone, Fax,0,null FROM [S-SQL-D4].ElitR.dbo.r_Banks;
*/
/*ALTER TABLE [dbo].[z_LogDiscExp]  NOCHECK  CONSTRAINT [FK_z_LogDiscExp_r_Discs];
delete  r_Discs; 
ALTER TABLE [dbo].[z_LogDiscExp]  CHECK  CONSTRAINT [FK_z_LogDiscExp_r_Discs];
INSERT r_Discs SELECT ChID, DiscCode, DiscName, ThisChargeOnly, ThisDocBonus, OtherDocsBonus, ChargeDCard, DiscOnlyWithDCard, ChargeAfterClose, Priority, AllowDiscs, Shed1, Shed2, Shed3, BDate, EDate, GenProcs, InUse, DocCode, SimpleDisc, SaveDiscToDCard, SaveBonusToDCard, DiscFromDCard, ReProcessPosDiscs, ValidOurs, ValidStocks, AutoSelDiscs, ShortCut, Notes, GroupDisc, PrintInCheque, AllowZeroPrice,0,0 FROM [S-SQL-D4].ElitR.dbo.r_Discs;
*/
/*TRUNCATE TABLE r_DiscChargeD;
INSERT r_DiscChargeD SELECT * FROM [S-SQL-D4].ElitR.dbo.r_DiscChargeD;
*/

/* TRUNCATE TABLE r_DiscChargeDT;
INSERT r_DiscChargeDT SELECT * FROM [S-SQL-D4].ElitR.dbo.r_DiscChargeDT;
*/
/*DISABLE TRIGGER ALL ON r_DCTypes;
DELETE r_DCTypes;
--INSERT r_DCTypes SELECT * FROM [S-SQL-D4].ElitR.dbo.r_DCTypes;
ENABLE TRIGGER ALL ON r_DCTypes;
*/

/* TRUNCATE TABLE r_DiscDC;
INSERT r_DiscDC SELECT * FROM [S-SQL-D4].ElitR.dbo.r_DiscDC;
*/
/* TRUNCATE TABLE r_DiscMessages;
INSERT r_DiscMessages SELECT * FROM [S-SQL-D4].ElitR.dbo.r_DiscMessages;
*/

DISABLE TRIGGER ALL ON r_Prods;
delete  r_Prods;
ENABLE TRIGGER ALL ON r_Prods;

DISABLE TRIGGER ALL ON r_Prods;
insert r_Prods	(ChID,ProdID,ProdName,UM,Country,Notes,PCatID,PGrID,Article1,Article2,Article3,Weight,Age,PriceWithTax,Note1,Note2,Note3,MinPriceMC,MaxPriceMC,MinRem,CstDty,CstPrc,CstExc,StdExtraR,StdExtraE,MaxExtra,MinExtra,UseAlts,UseCrts,PGrID1,PGrID2,PGrID3,PGrAID,PBGrID,LExpSet,EExpSet,InRems,IsDecQty,File1,File2,File3,AutoSet,Extra1,Extra2,Extra3,Extra4,Extra5,Norma1,Norma2,Norma3,Norma4,Norma5,RecMinPriceCC,RecMaxPriceCC,RecStdPriceCC,RecRemQty,InStopList,PrepareTime,ScaleGrID,ScaleStandard,ScaleConditions,ScaleComponents,TaxFreeReason,CstProdCode,TaxTypeID,CstDty2,CounID	)
		 select
				 ChID,ProdID,ProdName,UM,Country,Notes,PCatID,PGrID,Article1,Article2,Article3,Weight,Age,PriceWithTax,Note1,Note2,Note3,MinPriceMC,MaxPriceMC,MinRem,CstDty,CstPrc,CstExc,StdExtraR,StdExtraE,MaxExtra,MinExtra,UseAlts,UseCrts,PGrID1,PGrID2,PGrID3,PGrAID,PBGrID,LExpSet,EExpSet,InRems,IsDecQty,File1,File2,File3,AutoSet,Extra1,Extra2,Extra3,Extra4,Extra5,Norma1,Norma2,Norma3,Norma4,Norma5,RecMinPriceCC,RecMaxPriceCC,RecStdPriceCC,RecRemQty,InStopList,PrepareTime,ScaleGrID,ScaleStandard,ScaleConditions,ScaleComponents,TaxFreeReason,CstProdCode,TaxTypeID,0,0	
				 from [S-SQL-D4].ElitR.dbo.r_Prods;
ENABLE TRIGGER ALL ON r_Prods;

DISABLE TRIGGER ALL ON b_PInP; INSERT b_PInP SELECT ProdID, PPID, PPDesc, PriceCC_In, PriceMC, Priority, ProdDate, CompID, Article, CostAC, CostCC, PPWeight, File1, File2, File3, PPDelay, ProdPPDate, IsCommission, CstProdCode, CstDocCode, ParentDocCode, ParentChID,null,0 FROM [S-SQL-D4].ElitR.dbo.b_PInP; ENABLE TRIGGER ALL ON b_PInP;

--INSERT r_ProdAC SELECT * FROM [S-SQL-D4].ElitR.dbo.r_ProdAC

--INSERT r_ProdCV SELECT * FROM [S-SQL-D4].ElitR.dbo.r_ProdCV

--INSERT r_ProdEC SELECT * FROM [S-SQL-D4].ElitR.dbo.r_ProdEC

--INSERT r_ProdImages SELECT * FROM [S-SQL-D4].ElitR.dbo.r_ProdImages

INSERT r_ProdLV SELECT * FROM [S-SQL-D4].ElitR.dbo.r_ProdLV;

--INSERT r_ProdMA SELECT * FROM [S-SQL-D4].ElitR.dbo.r_ProdMA

--INSERT r_ProdME SELECT * FROM [S-SQL-D4].ElitR.dbo.r_ProdME

DISABLE TRIGGER ALL ON r_ProdMP; INSERT r_ProdMP SELECT ProdID, PLID, PriceMC, Notes, CurrID, DepID FROM [S-SQL-D4].ElitR.dbo.r_ProdMP WHERE PLID != 0; ENABLE TRIGGER ALL ON r_ProdMP;

TRUNCATE TABLE r_ProdMQ;
INSERT r_ProdMQ SELECT ProdID, UM, Qty, Weight, Notes, BarCode, ProdBarCode, PLID,0 FROM [S-SQL-D4].ElitR.dbo.r_ProdMQ

TRUNCATE TABLE r_ProdMS;
INSERT r_ProdMS SELECT ProdID, SProdID, LExp, EExp, LExpSub, EExpSub, UseSubItems, UseSubDoc FROM [S-SQL-D4].ElitR.dbo.r_ProdMS


INSERT r_ProdMSE SELECT * FROM [S-SQL-D4].ElitR.dbo.r_ProdMSE;


INSERT r_ProdValues SELECT * FROM [S-SQL-D4].ElitR.dbo.r_ProdValues;

TRUNCATE TABLE t_PInP;
DISABLE TRIGGER ALL ON t_PInP; INSERT t_PInP SELECT ProdID, PPID, PPDesc, PriceMC_In, PriceMC, Priority, ProdDate, CurrID, CompID, Article, CostAC, PPWeight, File1, File2, File3, PriceCC_In, CostCC, PPDelay, ProdPPDate, IsCommission, CstProdCode, CstDocCode, ISNULL(ParentDocCode,0), ISNULL(ParentChID,0), 0, CostMC FROM [S-SQL-D4].ElitR.dbo.t_PInP where ProdID != 0 AND PPID = 0; ENABLE TRIGGER ALL ON t_PInP;

TRUNCATE TABLE	r_Stocks;
DISABLE TRIGGER ALL ON r_Stocks; insert r_Stocks	(	ChID,StockID,StockName,StockGID,Notes,PLID,EmpID,IsWholesale,Address,StockTaxID	) select 	ChID,StockID,StockName,StockGID,Notes,PLID,EmpID,IsWholesale,Address,StockTaxID	from [S-SQL-D4].ElitR.dbo.r_Stocks;	ENABLE  TRIGGER ALL ON r_Stocks;

TRUNCATE TABLE r_StockCRProds;
INSERT r_StockCRProds SELECT * FROM [S-SQL-D4].ElitR.dbo.r_StockCRProds;


--SELECT * FROM z_Vars where varname in ('t_SaleHideZeroRems')
--SELECT dbo.zf_Var('t_SaleHideZeroRems')
--EXEC t_SaleMenuExt 1, 1, 1, 0



--INSERT r_CompContacts SELECT * FROM [S-SQL-D4].ElitR.dbo.r_CompContacts;

DISABLE TRIGGER ALL ON r_CompMG; INSERT r_CompMG SELECT * FROM [S-SQL-D4].ElitR.dbo.r_CompMG; ENABLE TRIGGER ALL ON r_CompMG;

DISABLE TRIGGER ALL ON r_Comps;
DELETE r_Comps;
INSERT r_Comps SELECT * FROM [S-SQL-D4].ElitR.dbo.r_Comps;
ENABLE TRIGGER ALL ON r_Comps;

DISABLE TRIGGER ALL ON r_CompsAC;
INSERT r_CompsAC SELECT CompID, BankID, CompAccountAC, DefaultAccount, Notes, null FROM [S-SQL-D4].ElitR.dbo.r_CompsAC where CompID > 1;
ENABLE TRIGGER ALL ON r_CompsAC;

DISABLE TRIGGER ALL ON r_CompsAdd;
INSERT r_CompsAdd SELECT CompID, CompAdd, CompAddDesc, CompDefaultAdd FROM [S-SQL-D4].ElitR.dbo.r_CompsAdd;
ENABLE TRIGGER ALL ON r_CompsAdd;

DISABLE TRIGGER ALL ON r_CompsCC;
INSERT r_CompsCC SELECT CompID, BankID, CompAccountCC, DefaultAccount, Notes, null FROM [S-SQL-D4].ElitR.dbo.r_CompsCC where CompID>1;
ENABLE TRIGGER ALL ON r_CompsCC;

--INSERT r_CompValues SELECT * FROM [S-SQL-D4].ElitR.dbo.r_CompValues;
--SELECT * FROM r_CompsCC

TRUNCATE TABLE r_Emps;

DISABLE TRIGGER ALL ON r_Emps;
INSERT r_Emps SELECT * FROM [S-SQL-D4].ElitR.dbo.r_Emps;
ENABLE TRIGGER ALL ON r_Emps;


ALTER TABLE [dbo].[z_LogState]  NOCHECK  CONSTRAINT [FK_z_LogState_r_Users];
delete r_Users where UserID > 0
ALTER TABLE [dbo].[z_LogState]  CHECK  CONSTRAINT [FK_z_LogState_r_Users];
INSERT r_Users SELECT ChID, UserID, UserName, EmpID, Admin, Active, Emps, s_PPAcc, s_Cost, s_CCPL, s_CCPrice, s_CCDiscount, CanCopyRems, BDate, EDate, UseOpenAge, CanInitAltsPL, ShowPLCange, CanChangeStatus, CanChangeDiscount, CanPrintDoc, CanBuffDoc, CanChangeDocID, CanChangeKursMC, AllowRestEditDesk, AllowRestReserve, AllowRestMove, CanExportPrint, p_SalaryAcc, AllowRestChequeUnite, AllowRestChequeDel, OpenAgeBType, OpenAgeBQty, OpenAgeEType, OpenAgeEQty, AllowRestViewDesk FROM [S-SQL-D4].ElitR.dbo.r_Users where UserID > 0;

TRUNCATE TABLE r_Ours;
INSERT r_Ours SELECT ChID, OurID, OurName, Address, PostIndex, City, Region, Code, TaxRegNo, TaxCode, OurDesc, Phone, Fax, OurShort, Note1, Note2, Note3, Job1, Job2, Job3, DayBTime, DayETime, EvenBTime, EvenETime, EvenPayFac, NightBTime, NightETime, NightPayFac, OverPayFactor, ActType, FinForm, PropForm, EcActType, PensFundID, SocInsFundID, SocUnEFundID, SocAddFundID, MinExcPowerID, TaxNotes, TaxOKPO, ActTypeCVED, TerritoryID, ExcComRegNum, SysTaxType, FixTaxPercent, TaxPayer, OurNameFull, NULL FROM [S-SQL-D4].ElitR.dbo.r_Ours;
SELECT * FROM r_Ours

TRUNCATE TABLE r_CRSrvs;
INSERT r_CRSrvs SELECT * FROM [S-SQL-D4].ElitR.dbo.r_CRSrvs;


TRUNCATE TABLE r_CRs;
INSERT r_CRs SELECT ChID, CRID, CRName, Notes, FinID, FacID, CRPort, CRCode, SrvID, StockID, SecID, CashType, UseProdNotes, BaudRate, LEDType, CanEditPrice, PaperWarning, DecQtyFromRef, UseStockPL, CashRegMode, NetPort, ModemID, ModemPassword, IP, GroupProds, AutoUpdateTaxes, 0, 0, 0, 0, 0 FROM [S-SQL-D4].ElitR.dbo.r_CRs;
SELECT * FROM r_CRs

TRUNCATE TABLE r_CRDeskG;
DISABLE TRIGGER ALL ON r_CRDeskG;
ALTER TABLE [dbo].[r_CRDeskG]  NOCHECK  CONSTRAINT [FK_r_CRDeskG_r_DeskG];
INSERT r_CRDeskG SELECT * FROM [S-SQL-D4].ElitR.dbo.r_CRDeskG;
ALTER TABLE [dbo].[r_CRDeskG]  CHECK  CONSTRAINT [FK_r_CRDeskG_r_DeskG];
ENABLE TRIGGER ALL ON r_CRDeskG;

BEGIN TRAN;
TRUNCATE TABLE r_Opers;
INSERT r_Opers SELECT ChID, OperID, OperName, OperPwd, EmpID, OperLockPwd FROM [S-SQL-D4].ElitR.dbo.r_Opers;
ROLLBACK TRAN;

/*


TRUNCATE TABLE	r_ProdA;
DISABLE TRIGGER ALL ON r_ProdA; insert r_ProdA	(	ChID,PGrAID,PGrAName,Notes	) select 	ChID,PGrAID,PGrAName,Notes	from [S-SQL-D4].ElitR.dbo.r_ProdA;	ENABLE  TRIGGER ALL ON r_ProdA;
DISABLE TRIGGER ALL ON r_Users; insert r_Users	(	ChID,UserID,UserName,EmpID,Admin,Active,Emps,s_PPAcc,s_Cost,s_CCPL,s_CCPrice,s_CCDiscount,CanCopyRems,BDate,EDate,UseOpenAge,CanInitAltsPL,ShowPLCange,CanChangeStatus,CanChangeDiscount,CanPrintDoc,CanBuffDoc,CanChangeDocID,CanChangeKursMC,AllowRestEditDesk,AllowRestReserve,AllowRestMove,CanExportPrint,p_SalaryAcc,AllowRestChequeUnite,AllowRestChequeDel,OpenAgeBType,OpenAgeBQty,OpenAgeEType,OpenAgeEQty,AllowRestViewDesk	) select 	ChID,UserID,UserName,EmpID,Admin,Active,Emps,s_PPAcc,s_Cost,s_CCPL,s_CCPrice,s_CCDiscount,CanCopyRems,BDate,EDate,UseOpenAge,CanInitAltsPL,ShowPLCange,CanChangeStatus,CanChangeDiscount,CanPrintDoc,CanBuffDoc,CanChangeDocID,CanChangeKursMC,AllowRestEditDesk,AllowRestReserve,AllowRestMove,CanExportPrint,p_SalaryAcc,AllowRestChequeUnite,AllowRestChequeDel,OpenAgeBType,OpenAgeBQty,OpenAgeEType,OpenAgeEQty,AllowRestViewDesk	from [S-SQL-D4].ElitR.dbo.r_Users WHERE ChID > 0 and UserName not in ('A1000000000788A');	ENABLE  TRIGGER ALL ON r_Users;

TRUNCATE TABLE	r_Codes1;
DISABLE TRIGGER ALL ON r_Codes1; insert r_Codes1	(	ChID,CodeID1,CodeName1,Notes	) select 	ChID,CodeID1,CodeName1,Notes	from [S-SQL-D4].ElitR.dbo.r_Codes1;	ENABLE  TRIGGER ALL ON r_Codes1;
TRUNCATE TABLE	r_Codes2;
DISABLE TRIGGER ALL ON r_Codes2; insert r_Codes2	(	ChID,CodeID2,CodeName2,Notes	) select 	ChID,CodeID2,CodeName2,Notes	from [S-SQL-D4].ElitR.dbo.r_Codes2;	ENABLE  TRIGGER ALL ON r_Codes2;
TRUNCATE TABLE	r_Codes3;
DISABLE TRIGGER ALL ON r_Codes3; insert r_Codes3	(	ChID,CodeID3,CodeName3,Notes	) select 	ChID,CodeID3,CodeName3,Notes	from [S-SQL-D4].ElitR.dbo.r_Codes3;	ENABLE  TRIGGER ALL ON r_Codes3;
TRUNCATE TABLE	r_Codes4;
DISABLE TRIGGER ALL ON r_Codes4; insert r_Codes4	(	ChID,CodeID4,CodeName4,Notes	) select 	ChID,CodeID4,CodeName4,Notes	from [S-SQL-D4].ElitR.dbo.r_Codes4;	ENABLE  TRIGGER ALL ON r_Codes4;
TRUNCATE TABLE	r_Codes5;
DISABLE TRIGGER ALL ON r_Codes5; insert r_Codes5	(	ChID,CodeID5,CodeName5,Notes	) select 	ChID,CodeID5,CodeName5,Notes	from [S-SQL-D4].ElitR.dbo.r_Codes5;	ENABLE  TRIGGER ALL ON r_Codes5;
DISABLE TRIGGER ALL ON r_CompContacts; insert r_CompContacts	(	CompID,Contact,PhoneWork,PhoneMob,PhoneHome,eMail,Job,BirthDate	) select 	CompID,Contact,PhoneWork,PhoneMob,PhoneHome,eMail,Job,BirthDate	from [S-SQL-D4].ElitR.dbo.r_CompContacts;	ENABLE  TRIGGER ALL ON r_CompContacts;
TRUNCATE TABLE	r_CompGrs1;
DISABLE TRIGGER ALL ON r_CompGrs1; insert r_CompGrs1	(	ChID,CompGrID1,CompGrName1,Notes	) select 	ChID,CompGrID1,CompGrName1,Notes	from [S-SQL-D4].ElitR.dbo.r_CompGrs1;	ENABLE  TRIGGER ALL ON r_CompGrs1;


TRUNCATE TABLE	r_CompGrs2;
DISABLE TRIGGER ALL ON r_CompGrs2; insert r_CompGrs2	(	ChID,CompGrID2,CompGrName2,Notes	) select 	ChID,CompGrID2,CompGrName2,Notes	from [S-SQL-D4].ElitR.dbo.r_CompGrs2;	ENABLE  TRIGGER ALL ON r_CompGrs2;
TRUNCATE TABLE	r_CompGrs3;
DISABLE TRIGGER ALL ON r_CompGrs3; insert r_CompGrs3	(	ChID,CompGrID3,CompGrName3,Notes	) select 	ChID,CompGrID3,CompGrName3,Notes	from [S-SQL-D4].ElitR.dbo.r_CompGrs3;	ENABLE  TRIGGER ALL ON r_CompGrs3;
TRUNCATE TABLE	r_CompGrs4;
DISABLE TRIGGER ALL ON r_CompGrs4; insert r_CompGrs4	(	ChID,CompGrID4,CompGrName4,Notes	) select 	ChID,CompGrID4,CompGrName4,Notes	from [S-SQL-D4].ElitR.dbo.r_CompGrs4;	ENABLE  TRIGGER ALL ON r_CompGrs4;
TRUNCATE TABLE	r_CompGrs5;
DISABLE TRIGGER ALL ON r_CompGrs5; insert r_CompGrs5	(	ChID,CompGrID5,CompGrName5,Notes	) select 	ChID,CompGrID5,CompGrName5,Notes	from [S-SQL-D4].ElitR.dbo.r_CompGrs5;	ENABLE  TRIGGER ALL ON r_CompGrs5;
DISABLE TRIGGER ALL ON r_Comps; delete  r_Comps; ENABLE  TRIGGER ALL ON r_Comps;
DISABLE TRIGGER ALL ON r_Comps; insert r_Comps	(	ChID,CompID,CompName,CompShort,Address,PostIndex,City,Region,Code,TaxRegNo,TaxCode,TaxPayer,CompDesc,Contact,Phone1,Phone2,Phone3,Fax,EMail,HTTP,Notes,CodeID1,CodeID2,CodeID3,CodeID4,CodeID5,UseCodes,PLID,UsePL,Discount,UseDiscount,PayDelay,UsePayDelay,MaxCredit,CalcMaxCredit,EmpID,Contract1,Contract2,Contract3,License1,License2,License3,Job1,Job2,Job3,TranPrc,MorePrc,FirstEventMode,CompType,SysTaxType,FixTaxPercent,InStopList,Value1,Value2,Value3,PassNo,PassSer,PassDate,PassDept,CompGrID1,CompGrID2,CompGrID3,CompGrID4,CompGrID5,CompNameFull,IsResident,ReasonRegCode	) select 	ChID,CompID,CompName,CompShort,Address,PostIndex,City,Region,Code,TaxRegNo,TaxCode,TaxPayer,CompDesc,Contact,Phone1,Phone2,Phone3,Fax,EMail,HTTP,Notes,CodeID1,CodeID2,CodeID3,CodeID4,CodeID5,UseCodes,PLID,UsePL,Discount,UseDiscount,PayDelay,UsePayDelay,MaxCredit,CalcMaxCredit,EmpID,Contract1,Contract2,Contract3,License1,License2,License3,Job1,Job2,Job3,TranPrc,MorePrc,FirstEventMode,CompType,SysTaxType,FixTaxPercent,InStopList,Value1,Value2,Value3,PassNo,PassSer,PassDate,PassDept,CompGrID1,CompGrID2,CompGrID3,CompGrID4,CompGrID5,CompNameFull,null,null	from [S-SQL-D4].ElitR.dbo.r_Comps;	ENABLE  TRIGGER ALL ON r_Comps;
TRUNCATE TABLE	r_CompsAC;
DISABLE TRIGGER ALL ON r_CompsAC; insert r_CompsAC	(	CompID,BankID,CompAccountAC,DefaultAccount,Notes,IBANCode	) select 	CompID,BankID,CompAccountAC,DefaultAccount,Notes,null	from [S-SQL-D4].ElitR.dbo.r_CompsAC;	ENABLE  TRIGGER ALL ON r_CompsAC;
DISABLE TRIGGER ALL ON r_CompsAdd; insert r_CompsAdd	(	CompID,CompAdd,CompAddDesc,CompDefaultAdd	) select 	CompID,CompAdd,CompAddDesc,CompDefaultAdd	from [S-SQL-D4].ElitR.dbo.r_CompsAdd;	ENABLE  TRIGGER ALL ON r_CompsAdd;
TRUNCATE TABLE	r_CompsCC;
DISABLE TRIGGER ALL ON r_CompsCC; insert r_CompsCC	(	CompID,BankID,CompAccountCC,DefaultAccount,Notes,IBANCode	) select 	CompID,BankID,CompAccountCC,DefaultAccount,Notes,null	from [S-SQL-D4].ElitR.dbo.r_CompsCC;	ENABLE  TRIGGER ALL ON r_CompsCC;
DISABLE TRIGGER ALL ON r_CompValues; insert r_CompValues	(	CompID,VarName,VarValue	) select 	CompID,VarName,VarValue	from [S-SQL-D4].ElitR.dbo.r_CompValues;	ENABLE  TRIGGER ALL ON r_CompValues;
DISABLE TRIGGER ALL ON r_CRMP; insert r_CRMP	(	CRID,ProdID,CRProdName,CRProdID,TaxID,SecID,FixedPrice,PriceCC,DecimalQty,BarCode	) select 	CRID,ProdID,CRProdName,CRProdID,TaxID,SecID,FixedPrice,PriceCC,DecimalQty,BarCode	from [S-SQL-D4].ElitR.dbo.r_CRMP;	ENABLE  TRIGGER ALL ON r_CRMP;



DISABLE TRIGGER ALL ON r_CRShed; insert r_CRShed	(	CRID,SrcPosID,Shed,CashRegAction,UseSched	) select 	CRID,SrcPosID,Shed,CashRegAction,UseSched	from [S-SQL-D4].ElitR.dbo.r_CRShed;	ENABLE  TRIGGER ALL ON r_CRShed;
TRUNCATE TABLE	r_CRUniInput;
DISABLE TRIGGER ALL ON r_CRUniInput; insert r_CRUniInput	(	ChID,UniInputCode,UniInputAction,UniInputMask,Notes,UniInput	) select 	ChID,UniInputCode,UniInputAction,UniInputMask,Notes,UniInput	from [S-SQL-D4].ElitR.dbo.r_CRUniInput;	ENABLE  TRIGGER ALL ON r_CRUniInput;
TRUNCATE TABLE	r_Currs;
DISABLE TRIGGER ALL ON r_Currs; insert r_Currs	(	ChID,CurrID,CurrName,CurrDesc,KursMC,KursCC	) select 	ChID,CurrID,CurrName,CurrDesc,KursMC,KursCC	from [S-SQL-D4].ElitR.dbo.r_Currs;	ENABLE  TRIGGER ALL ON r_Currs;
TRUNCATE TABLE	r_DCTypeG;
DISABLE TRIGGER ALL ON r_DCTypeG; insert r_DCTypeG	(	ChID,DCTypeGCode,DCTypeGName,Notes,MainDialog,CloseDialogAfterEnter,ProcessingID	) select 	ChID,DCTypeGCode,DCTypeGName,Notes,MainDialog,CloseDialogAfterEnter,ProcessingID	from [S-SQL-D4].ElitR.dbo.r_DCTypeG;	ENABLE  TRIGGER ALL ON r_DCTypeG;
DISABLE TRIGGER ALL ON r_DCTypes; delete  r_DCTypes; ENABLE  TRIGGER ALL ON r_DCTypes;
DISABLE TRIGGER ALL ON r_DCTypes; insert r_DCTypes	(	ChID,DCTypeCode,DCTypeName,Value1,Value2,Value3,InitSum,ProdID,Notes,MaxQty,DCTypeGCode,DeactivateAfterUse,NoManualDCardEnter	) select 	ChID,DCTypeCode,DCTypeName,Value1,Value2,Value3,InitSum,ProdID,Notes,MaxQty,DCTypeGCode,DeactivateAfterUse,NoManualDCardEnter	from [S-SQL-D4].ElitR.dbo.r_DCTypes;	ENABLE  TRIGGER ALL ON r_DCTypes;
TRUNCATE TABLE	r_Deps;
DISABLE TRIGGER ALL ON r_Deps; insert r_Deps	(	ChID,DepID,DepName,Notes	) select 	ChID,DepID,DepName,Notes	from [S-SQL-D4].ElitR.dbo.r_Deps;	ENABLE  TRIGGER ALL ON r_Deps;
TRUNCATE TABLE	r_DiscDC;
DISABLE TRIGGER ALL ON r_DiscDC; ALTER TABLE [r_DiscDC]  NOCHECK  CONSTRAINT [FK_r_DiscDC_r_Discs]; insert r_DiscDC	(	DiscCode,DCTypeCode,ForRec,ForExp	) select 	DiscCode,DCTypeCode,ForRec,ForExp	from [S-SQL-D4].ElitR.dbo.r_DiscDC;	ENABLE  TRIGGER ALL ON r_DiscDC; ALTER TABLE[r_DiscDC]  CHECK  CONSTRAINT [FK_r_DiscDC_r_Discs]; 

ALTER TABLE [dbo].[z_LogDiscExp]  NOCHECK  CONSTRAINT [FK_z_LogDiscExp_r_Discs];
delete  r_Discs; 
ALTER TABLE [dbo].[z_LogDiscExp]  CHECK  CONSTRAINT [FK_z_LogDiscExp_r_Discs];
DISABLE TRIGGER ALL ON r_Discs; insert r_Discs	(	ChID,DiscCode,DiscName,ThisChargeOnly,ThisDocBonus,OtherDocsBonus,ChargeDCard,DiscOnlyWithDCard,ChargeAfterClose,Priority,AllowDiscs,Shed1,Shed2,Shed3,BDate,EDate,GenProcs,InUse,DocCode,SimpleDisc,SaveDiscToDCard,SaveBonusToDCard,DiscFromDCard,ReProcessPosDiscs,ValidOurs,ValidStocks,AutoSelDiscs,ShortCut,Notes,GroupDisc,PrintInCheque,AllowZeroPrice,AllowEditQty,RedistributeDiscSumInBusket	) select 	ChID,DiscCode,DiscName,ThisChargeOnly,ThisDocBonus,OtherDocsBonus,ChargeDCard,DiscOnlyWithDCard,ChargeAfterClose,Priority,AllowDiscs,Shed1,Shed2,Shed3,BDate,EDate,GenProcs,InUse,DocCode,SimpleDisc,SaveDiscToDCard,SaveBonusToDCard,DiscFromDCard,ReProcessPosDiscs,ValidOurs,ValidStocks,AutoSelDiscs,ShortCut,Notes,GroupDisc,PrintInCheque,AllowZeroPrice,0,0	from [S-SQL-D4].ElitR.dbo.r_Discs;	ENABLE  TRIGGER ALL ON r_Discs;

TRUNCATE TABLE	r_Emps;
DISABLE TRIGGER ALL ON r_Emps; insert r_Emps	(	ChID,EmpID,EmpName,UAEmpName,EmpLastName,EmpFirstName,EmpParName,UAEmpLastName,UAEmpFirstName,UAEmpParName,EmpInitials,UAEmpInitials,TaxCode,EmpSex,BirthDay,File1,File2,File3,Education,FamilyStatus,BirthPlace,Phone,InPhone,Mobile,EMail,Percent1,Percent2,Percent3,Notes,MilStatus,MilFitness,MilRank,MilSpecialCalc,MilProfes,MilCalcGrp,MilCalcCat,MilStaff,MilRegOffice,MilNum,PassNo,PassSer,PassDate,PassDept,DisNum,PensNum,WorkBookNo,WorkBookSer,PerFileNo,InStopList,BarCode,ShiftPostID,IsCitizen,CertInsurSer,CertInsurNum	) select 	ChID,EmpID,EmpName,UAEmpName,EmpLastName,EmpFirstName,EmpParName,UAEmpLastName,UAEmpFirstName,UAEmpParName,EmpInitials,UAEmpInitials,TaxCode,EmpSex,BirthDay,File1,File2,File3,Education,FamilyStatus,BirthPlace,Phone,InPhone,Mobile,EMail,Percent1,Percent2,Percent3,Notes,MilStatus,MilFitness,MilRank,MilSpecialCalc,MilProfes,MilCalcGrp,MilCalcCat,MilStaff,MilRegOffice,MilNum,PassNo,PassSer,PassDate,PassDept,DisNum,PensNum,WorkBookNo,WorkBookSer,PerFileNo,InStopList,BarCode,ShiftPostID,IsCitizen,CertInsurSer,CertInsurNum	from [S-SQL-D4].ElitR.dbo.r_Emps;	ENABLE  TRIGGER ALL ON r_Emps;
TRUNCATE TABLE	r_Levies;
DISABLE TRIGGER ALL ON r_Levies; insert r_Levies	(	LevyID,LevyName,Notes	) select 	LevyID,LevyName,Notes	from [S-SQL-D4].ElitR.dbo.r_Levies;	ENABLE  TRIGGER ALL ON r_Levies;


TRUNCATE TABLE	r_LevyCR;
DISABLE TRIGGER ALL ON r_LevyCR; insert r_LevyCR	(	LevyID,CashType,TaxID,CRTaxPercent,Override,TaxTypeID	) select 	LevyID,CashType,TaxID,CRTaxPercent,Override,TaxTypeID	from [S-SQL-D4].ElitR.dbo.r_LevyCR;	ENABLE  TRIGGER ALL ON r_LevyCR;
TRUNCATE TABLE	r_LevyRates;
DISABLE TRIGGER ALL ON r_LevyRates; insert r_LevyRates	(	LevyID,ChDate,LevyPercent	) select 	LevyID,ChDate,LevyPercent	from [S-SQL-D4].ElitR.dbo.r_LevyRates;	ENABLE  TRIGGER ALL ON r_LevyRates;
TRUNCATE TABLE	r_OperCRs;
DISABLE TRIGGER ALL ON r_OperCRs; insert r_OperCRs	(	CRID,OperID,CROperID,OperMaxQty,CanEditDiscount,CRVisible,OperPwd,AllowChequeClose,AllowAddToChequeFromCat,CRAdmin,AllowChangeDCType	) select 	CRID,OperID,CROperID,OperMaxQty,CanEditDiscount,CRVisible,OperPwd,AllowChequeClose,AllowAddToChequeFromCat,0,0	from [S-SQL-D4].ElitR.dbo.r_OperCRs;	ENABLE  TRIGGER ALL ON r_OperCRs;
TRUNCATE TABLE	r_Opers;
DISABLE TRIGGER ALL ON r_Opers; insert r_Opers	(	ChID,OperID,OperName,OperPwd,EmpID,OperLockPwd	) select 	ChID,OperID,OperName,OperPwd,EmpID,OperLockPwd	from [S-SQL-D4].ElitR.dbo.r_Opers;	ENABLE  TRIGGER ALL ON r_Opers;
TRUNCATE TABLE	r_Ours;
DISABLE TRIGGER ALL ON r_Ours; insert r_Ours	(	ChID,OurID,OurName,Address,PostIndex,City,Region,Code,TaxRegNo,TaxCode,OurDesc,Phone,Fax,OurShort,Note1,Note2,Note3,Job1,Job2,Job3,DayBTime,DayETime,EvenBTime,EvenETime,EvenPayFac,NightBTime,NightETime,NightPayFac,OverPayFactor,ActType,FinForm,PropForm,EcActType,PensFundID,SocInsFundID,SocUnEFundID,SocAddFundID,MinExcPowerID,TaxNotes,TaxOKPO,ActTypeCVED,TerritoryID,ExcComRegNum,SysTaxType,FixTaxPercent,TaxPayer,OurNameFull,IsResident	) select 	ChID,OurID,OurName,Address,PostIndex,City,Region,Code,TaxRegNo,TaxCode,OurDesc,Phone,Fax,OurShort,Note1,Note2,Note3,Job1,Job2,Job3,DayBTime,DayETime,EvenBTime,EvenETime,EvenPayFac,NightBTime,NightETime,NightPayFac,OverPayFactor,ActType,FinForm,PropForm,EcActType,PensFundID,SocInsFundID,SocUnEFundID,SocAddFundID,MinExcPowerID,TaxNotes,TaxOKPO,ActTypeCVED,TerritoryID,ExcComRegNum,SysTaxType,FixTaxPercent,TaxPayer,OurNameFull,null	from [S-SQL-D4].ElitR.dbo.r_Ours;	ENABLE  TRIGGER ALL ON r_Ours;
TRUNCATE TABLE	r_OursAC;
DISABLE TRIGGER ALL ON r_OursAC; insert r_OursAC	(	OurID,BankID,AccountAC,DefaultAccount,Notes,GAccID,IBANCode	) select 	OurID,BankID,AccountAC,DefaultAccount,Notes,GAccID,null	from [S-SQL-D4].ElitR.dbo.r_OursAC;	ENABLE  TRIGGER ALL ON r_OursAC;
TRUNCATE TABLE	r_OursCC;
DISABLE TRIGGER ALL ON r_OursCC; insert r_OursCC	(	OurID,BankID,AccountCC,DefaultAccount,Notes,GAccID,IBANCode	) select 	OurID,BankID,AccountCC,DefaultAccount,Notes,GAccID,null	from [S-SQL-D4].ElitR.dbo.r_OursCC;	ENABLE  TRIGGER ALL ON r_OursCC;
DISABLE TRIGGER ALL ON r_OurValues; insert r_OurValues	(	OurID,VarName,VarValue	) select 	OurID,VarName,VarValue	from [S-SQL-D4].ElitR.dbo.r_OurValues;	ENABLE  TRIGGER ALL ON r_OurValues;
TRUNCATE TABLE	r_PayForms;
DISABLE TRIGGER ALL ON r_PayForms; insert r_PayForms	(	ChID,PayFormCode,PayFormName,Notes,SumLabel,NotesLabel,CanEnterNotes,NotesMask,CanEnterSum,MaxQty,IsDefault,ForSale,ForRet,AutoCalcSum,DCTypeGCode,GroupPays	) select 	ChID,PayFormCode,PayFormName,Notes,SumLabel,NotesLabel,CanEnterNotes,NotesMask,CanEnterSum,MaxQty,IsDefault,ForSale,ForRet,AutoCalcSum,DCTypeGCode,GroupPays	from [S-SQL-D4].ElitR.dbo.r_PayForms;	ENABLE  TRIGGER ALL ON r_PayForms;
TRUNCATE TABLE	r_PLs;
DISABLE TRIGGER ALL ON r_PLs; insert r_PLs	(	ChID,PLID,PLName,Notes	) select 	ChID,PLID,PLName,Notes	from [S-SQL-D4].ElitR.dbo.r_PLs;	ENABLE  TRIGGER ALL ON r_PLs;


TRUNCATE TABLE	r_POSPays;
DISABLE TRIGGER ALL ON r_POSPays; insert r_POSPays	(	ChID,POSPayID,POSPayName,POSPayClass,POSPayPort,POSPayTimeout,Notes,UseGrpCardForDiscs,UseUnionCheque,BankID,PrintTranInfoInCheque	) select 	ChID,POSPayID,POSPayName,POSPayClass,POSPayPort,POSPayTimeout,Notes,UseGrpCardForDiscs,0,0,0	from [S-SQL-D4].ElitR.dbo.r_POSPays;	ENABLE  TRIGGER ALL ON r_POSPays;
DISABLE TRIGGER ALL ON r_ProdAC; insert r_ProdAC	(	ProdID,PLID,ChPLID,ExpE,ExpR,Notes	) select 	ProdID,PLID,ChPLID,ExpE,ExpR,Notes	from [S-SQL-D4].ElitR.dbo.r_ProdAC;	ENABLE  TRIGGER ALL ON r_ProdAC;
TRUNCATE TABLE	r_ProdBG;
DISABLE TRIGGER ALL ON r_ProdBG; insert r_ProdBG	(	ChID,PBGrID,PBGrName,Notes,Tare	) select 	ChID,PBGrID,PBGrName,Notes,Tare	from [S-SQL-D4].ElitR.dbo.r_ProdBG;	ENABLE  TRIGGER ALL ON r_ProdBG;
TRUNCATE TABLE	r_ProdC;
DISABLE TRIGGER ALL ON r_ProdC; insert r_ProdC	(	ChID,PCatID,PCatName,Notes	) select 	ChID,PCatID,PCatName,Notes	from [S-SQL-D4].ElitR.dbo.r_ProdC;	ENABLE  TRIGGER ALL ON r_ProdC;
DISABLE TRIGGER ALL ON r_ProdCV; insert r_ProdCV	(	ProdID,CompID,BDate,EDate,Value1,Note1,Value2,Note2,Value3,Note3	) select 	ProdID,CompID,BDate,EDate,Value1,Note1,Value2,Note2,Value3,Note3	from [S-SQL-D4].ElitR.dbo.r_ProdCV;	ENABLE  TRIGGER ALL ON r_ProdCV;
DISABLE TRIGGER ALL ON r_ProdEC; insert r_ProdEC	(	ProdID,CompID,ExtProdID	) select 	ProdID,CompID,ExtProdID	from [S-SQL-D4].ElitR.dbo.r_ProdEC;	ENABLE  TRIGGER ALL ON r_ProdEC;
TRUNCATE TABLE	r_ProdG;
DISABLE TRIGGER ALL ON r_ProdG; insert r_ProdG	(	ChID,PGrID,PGrName,Notes	) select 	ChID,PGrID,PGrName,Notes	from [S-SQL-D4].ElitR.dbo.r_ProdG;	ENABLE  TRIGGER ALL ON r_ProdG;
TRUNCATE TABLE	r_ProdG1;
DISABLE TRIGGER ALL ON r_ProdG1; insert r_ProdG1	(	ChID,PGrID1,PGrName1,Notes	) select 	ChID,PGrID1,PGrName1,Notes	from [S-SQL-D4].ElitR.dbo.r_ProdG1;	ENABLE  TRIGGER ALL ON r_ProdG1;
TRUNCATE TABLE	r_ProdG2;
DISABLE TRIGGER ALL ON r_ProdG2; insert r_ProdG2	(	ChID,PGrID2,PGrName2,Notes	) select 	ChID,PGrID2,PGrName2,Notes	from [S-SQL-D4].ElitR.dbo.r_ProdG2;	ENABLE  TRIGGER ALL ON r_ProdG2;


TRUNCATE TABLE	r_ProdG3;
DISABLE TRIGGER ALL ON r_ProdG3; insert r_ProdG3	(	ChID,PGrID3,PGrName3,Notes	) select 	ChID,PGrID3,PGrName3,Notes	from [S-SQL-D4].ElitR.dbo.r_ProdG3;	ENABLE  TRIGGER ALL ON r_ProdG3;
DISABLE TRIGGER ALL ON r_ProdLV; insert r_ProdLV	(	ProdID,LevyID	) select 	ProdID,LevyID	from [S-SQL-D4].ElitR.dbo.r_ProdLV;	ENABLE  TRIGGER ALL ON r_ProdLV;
DISABLE TRIGGER ALL ON r_ProdMA; insert r_ProdMA	(	ProdID,AProdID,ValidSets,Priority,Notes	) select 	ProdID,AProdID,ValidSets,Priority,Notes	from [S-SQL-D4].ElitR.dbo.r_ProdMA;	ENABLE  TRIGGER ALL ON r_ProdMA;
DISABLE TRIGGER ALL ON r_ProdME; insert r_ProdME	(	ProdID,CodeID1,CodeID2,CodeID3,CodeID4,CodeID5,LExp,EExp,ExpType	) select 	ProdID,CodeID1,CodeID2,CodeID3,CodeID4,CodeID5,LExp,EExp,ExpType	from [S-SQL-D4].ElitR.dbo.r_ProdME;	ENABLE  TRIGGER ALL ON r_ProdME;
TRUNCATE TABLE	r_ProdMP;
DISABLE TRIGGER ALL ON r_ProdMP; insert r_ProdMP	(	ProdID,PLID,PriceMC,Notes,CurrID,DepID	) select 	ProdID,PLID,PriceMC,Notes,CurrID,DepID	from [S-SQL-D4].ElitR.dbo.r_ProdMP;	ENABLE  TRIGGER ALL ON r_ProdMP;
DISABLE TRIGGER ALL ON r_ProdMQ; insert r_ProdMQ	(	ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID,TareWeight	) select 	ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID,0	from [S-SQL-D4].ElitR.dbo.r_ProdMQ;	ENABLE  TRIGGER ALL ON r_ProdMQ;
DISABLE TRIGGER ALL ON r_ProdMS; insert r_ProdMS	(	ProdID,SProdID,LExp,EExp,LExpSub,EExpSub,UseSubItems,UseSubDoc	) select 	ProdID,SProdID,LExp,EExp,LExpSub,EExpSub,UseSubItems,UseSubDoc	from [S-SQL-D4].ElitR.dbo.r_ProdMS;	ENABLE  TRIGGER ALL ON r_ProdMS;
DISABLE TRIGGER ALL ON r_ProdMSE; insert r_ProdMSE	(	ProdID,SProdID,LExp,EExp,LExpSub,EExpSub,UseSubItems,UseSubDoc	) select 	ProdID,SProdID,LExp,EExp,LExpSub,EExpSub,UseSubItems,UseSubDoc	from [S-SQL-D4].ElitR.dbo.r_ProdMSE;	ENABLE  TRIGGER ALL ON r_ProdMSE;
DISABLE TRIGGER ALL ON r_ProdValues; insert r_ProdValues	(	ProdID,VarName,VarValue	) select 	ProdID,VarName,VarValue	from [S-SQL-D4].ElitR.dbo.r_ProdValues;	ENABLE  TRIGGER ALL ON r_ProdValues;

TRUNCATE TABLE	r_Spends;
DISABLE TRIGGER ALL ON r_Spends; insert r_Spends	(	ChID,SpendCode,SpendName,Notes	) select 	ChID,SpendCode,SpendName,Notes	from [S-SQL-D4].ElitR.dbo.r_Spends;	ENABLE  TRIGGER ALL ON r_Spends;
TRUNCATE TABLE	r_StateDocs;
DISABLE TRIGGER ALL ON r_StateDocs; insert r_StateDocs	(	DocCode,StateCode	) select 	DocCode,StateCode	from [S-SQL-D4].ElitR.dbo.r_StateDocs;	ENABLE  TRIGGER ALL ON r_StateDocs;
TRUNCATE TABLE	r_StateDocsChange;
DISABLE TRIGGER ALL ON r_StateDocsChange; insert r_StateDocsChange	(	UserCode,StateCode	) select 	UserCode,StateCode	from [S-SQL-D4].ElitR.dbo.r_StateDocsChange;	ENABLE  TRIGGER ALL ON r_StateDocsChange;
TRUNCATE TABLE	r_StateRules;
DISABLE TRIGGER ALL ON r_StateRules; insert r_StateRules	(	StateRuleCode,Notes,StateCodeFrom,StateCodeTo,DenyUsers	) select 	StateRuleCode,Notes,StateCodeFrom,StateCodeTo,DenyUsers	from [S-SQL-D4].ElitR.dbo.r_StateRules;	ENABLE  TRIGGER ALL ON r_StateRules;
DISABLE TRIGGER ALL ON r_StateRuleUsers; ALTER TABLE [r_StateRuleUsers]  NOCHECK  CONSTRAINT [FK_r_StateRuleUsers_r_Users]; insert r_StateRuleUsers	(	StateRuleCode,UserCode	) select 	StateRuleCode,UserCode	from [S-SQL-D4].ElitR.dbo.r_StateRuleUsers; ALTER TABLE [r_StateRuleUsers]  CHECK  CONSTRAINT [FK_r_StateRuleUsers_r_Users]; ENABLE  TRIGGER ALL ON r_StateRuleUsers;
TRUNCATE TABLE	r_States;
DISABLE TRIGGER ALL ON r_States; insert r_States	(	ChID,StateCode,StateName,StateInfo,CanChangeDoc	) select 	ChID,StateCode,StateName,StateInfo,CanChangeDoc	from [S-SQL-D4].ElitR.dbo.r_States;	ENABLE  TRIGGER ALL ON r_States;
DISABLE TRIGGER ALL ON r_StockCRProds; insert r_StockCRProds	(	StockID,ProdID,CRProdID,CRProdGroup	) select 	StockID,ProdID,CRProdID,CRProdGroup	from [S-SQL-D4].ElitR.dbo.r_StockCRProds;	ENABLE  TRIGGER ALL ON r_StockCRProds;
TRUNCATE TABLE	r_StockGs;
DISABLE TRIGGER ALL ON r_StockGs; insert r_StockGs	(	ChID,StockGID,StockGName,Notes	) select 	ChID,StockGID,StockGName,Notes	from [S-SQL-D4].ElitR.dbo.r_StockGs;	ENABLE  TRIGGER ALL ON r_StockGs;
TRUNCATE TABLE	r_Stocks;
DISABLE TRIGGER ALL ON r_Stocks; insert r_Stocks	(	ChID,StockID,StockName,StockGID,Notes,PLID,EmpID,IsWholesale,Address,StockTaxID	) select 	ChID,StockID,StockName,StockGID,Notes,PLID,EmpID,IsWholesale,Address,StockTaxID	from [S-SQL-D4].ElitR.dbo.r_Stocks;	ENABLE  TRIGGER ALL ON r_Stocks;
TRUNCATE TABLE	r_Taxes;
DISABLE TRIGGER ALL ON r_Taxes; insert r_Taxes	(	TaxTypeID,TaxName,TaxDesc,TaxID,Notes	) select 	TaxTypeID,TaxName,TaxDesc,TaxID,Notes	from [S-SQL-D4].ElitR.dbo.r_Taxes;	ENABLE  TRIGGER ALL ON r_Taxes;

TRUNCATE TABLE	r_TaxRates;
DISABLE TRIGGER ALL ON r_TaxRates; insert r_TaxRates	(	TaxTypeID,ChDate,TaxPercent	) select 	TaxTypeID,ChDate,TaxPercent	from [S-SQL-D4].ElitR.dbo.r_TaxRates;	ENABLE  TRIGGER ALL ON r_TaxRates;
TRUNCATE TABLE	r_Uni;
DISABLE TRIGGER ALL ON r_Uni; insert r_Uni	(	RefTypeID,RefID,RefName,Notes	) select 	RefTypeID,RefID,RefName,Notes	from [S-SQL-D4].ElitR.dbo.r_Uni;	ENABLE  TRIGGER ALL ON r_Uni;
TRUNCATE TABLE	r_UniTypes;
DISABLE TRIGGER ALL ON r_UniTypes; insert r_UniTypes	(	ChID,RefTypeID,RefTypeName,Notes	) select 	ChID,RefTypeID,RefTypeName,Notes	from [S-SQL-D4].ElitR.dbo.r_UniTypes;	ENABLE  TRIGGER ALL ON r_UniTypes;
TRUNCATE TABLE	t_PInP;
DISABLE TRIGGER ALL ON t_PInP; insert t_PInP	(	ProdID,PPID,PPDesc,PriceMC_In,PriceMC,Priority,ProdDate,CurrID,CompID,Article,CostAC,PPWeight,File1,File2,File3,PriceCC_In,CostCC,PPDelay,ProdPPDate,IsCommission,PriceAC_In,CostMC,CstProdCode,CstDocCode,ParentDocCode,ParentChID	) select 	ProdID,PPID,PPDesc,PriceMC_In,PriceMC,Priority,ProdDate,CurrID,CompID,Article,CostAC,PPWeight,File1,File2,File3,PriceCC_In,CostCC,PPDelay,ProdPPDate,IsCommission,PriceAC_In,CostMC,CstProdCode,CstDocCode,ParentDocCode,ParentChID	from [S-SQL-D4].ElitR.dbo.t_PInP;	ENABLE  TRIGGER ALL ON t_PInP;
DISABLE TRIGGER ALL ON r_CRPOSPays; insert r_CRPOSPays	(	POSPayID,IsDefault,WPID	) select 	POSPayID,IsDefault,CRID WPID	from [S-SQL-D4].ElitR.dbo.r_CRPOSPays;	ENABLE  TRIGGER ALL ON r_CRPOSPays;
DISABLE TRIGGER ALL ON r_CRMM; insert r_CRMM	(	MPayDesc,CodeID1,CodeID2,CodeID3,CodeID4,CodeID5,IsRec,WPRoleID	) select 	MPayDesc,CodeID1,CodeID2,CodeID3,CodeID4,CodeID5,IsRec,CRID WPRoleID	from [S-SQL-D4].ElitR.dbo.r_CRMM;	ENABLE  TRIGGER ALL ON r_CRMM;

TRUNCATE TABLE	r_CRDeskG;
ALTER TABLE [dbo].[r_CRDeskG]  NOCHECK  CONSTRAINT [FK_r_CRDeskG_r_DeskG];
DISABLE TRIGGER ALL ON r_CRDeskG; insert r_CRDeskG	(	DeskGCode,WPID	) select 	DeskGCode,CRID WPID	from [S-SQL-D4].ElitR.dbo.r_CRDeskG;	ENABLE  TRIGGER ALL ON r_CRDeskG;
ALTER TABLE [dbo].[r_CRDeskG]  CHECK  CONSTRAINT [FK_r_CRDeskG_r_DeskG];

ALTER TABLE [dbo].[z_LogDiscRec]  NOCHECK  CONSTRAINT [FK_z_LogDiscRec_r_DCards];
ALTER TABLE [dbo].[z_LogDiscExp]  NOCHECK  CONSTRAINT [FK_z_LogDiscExp_r_DCards];
ALTER TABLE [dbo].[z_DocDC]  NOCHECK  CONSTRAINT [FK_z_DocDC_r_DCards];
delete	r_DCards;
ALTER TABLE [dbo].[z_DocDC]  CHECK  CONSTRAINT [FK_z_DocDC_r_DCards];
ALTER TABLE [dbo].[z_LogDiscExp]  CHECK  CONSTRAINT [FK_z_LogDiscExp_r_DCards];
ALTER TABLE [dbo].[z_LogDiscRec]  CHECK  CONSTRAINT [FK_z_LogDiscRec_r_DCards];
DISABLE TRIGGER ALL ON r_DCards; insert r_DCards	(	ChID,CompID,DCardID,Discount,SumCC,InUse,Notes,Value1,Value2,Value3,IsCrdCard,Note1,EDate,DCTypeCode,FactPostIndex,SumBonus,Status,IsPayCard,BDate,AskPWDDCardEnter,AutoSaveOddMoneyToProcessing	) select 	ChID,CompID,DCardID,Discount,SumCC,InUse,Notes,Value1,Value2,Value3,IsCrdCard,Note1,EDate,DCTypeCode,FactPostIndex,SumBonus,Status,IsPayCard,BDate, 0, 0	from [S-SQL-D4].ElitR.dbo.r_DCards;	ENABLE  TRIGGER ALL ON r_DCards;

TRUNCATE TABLE	r_CRs;
DISABLE TRIGGER ALL ON r_CRs; insert r_CRs	(ChID, CRID, CRName, Notes, FinID, FacID, CRPort, CRCode, SrvID, StockID, SecID, CashType, UseProdNotes, BaudRate, LEDType, CanEditPrice, PaperWarning, DecQtyFromRef, UseStockPL, CashRegMode, NetPort, ModemID, ModemPassword, IP, GroupProds, AutoUpdateTaxes,BackupCRJournalAfterZReport,BackupCRJournalAfterChequeType, BackupCRJournalChequeTimeout, BackupCRJournalInTime, BackupCRJournalExecTime) select 	ChID, CRID, CRName, Notes, FinID, FacID, CRPort, CRCode, SrvID, StockID, SecID, CashType, UseProdNotes, BaudRate, LEDType, CanEditPrice, PaperWarning, DecQtyFromRef, UseStockPL, CashRegMode, NetPort, ModemID, ModemPassword, IP, GroupProds, AutoUpdateTaxes, 0, 0, 0, 0, 0 from [S-SQL-D4].ElitR.dbo.r_CRs;	ENABLE  TRIGGER ALL ON r_CRs;
TRUNCATE TABLE	r_Banks;
DISABLE TRIGGER ALL ON r_Banks; insert r_Banks	(	ChID,BankID,BankName,Address,PostIndex,City,Region,Phone,Fax,BankGrID,SWIFTBICCode	) select 	ChID,BankID,BankName,Address,PostIndex,City,Region,Phone,Fax,0,null	from [S-SQL-D4].ElitR.dbo.r_Banks where BankID <> 0;	ENABLE  TRIGGER ALL ON r_Banks;
*/

--5. z_DocOpenList. Убрать ограничение по видимым справочникам.
--6. Для того чтобы появилась вкладка "Ресторан" и "Услуги", в z_Vars.
--переменные "sol_HiderWPRolesRest" и "sol_HiderWPRolesServices" нужно
--поставить в ноль.
--7. Перенос меню.
/*UPDATE r_WPRoles set MenuID = 1, DefaultMenuID = 1
UPDATE r_CRs set UseStockPL = 1

select * from r_ProdMQ where prodid = 801117
select * from r_MenuP
SELECT * FROM r_Prods where prodid = 603796
SELECT * FROM t_PInP
SELECT s.PLID, mcr.UseStockPL FROM r_CRs mcr WITH (NOLOCK) INNER JOIN r_Stocks s WITH (NOLOCK) ON mcr.StockID = s.StockID AND mcr.CRID = 1 
INSERT r_Menu SELECT * FROM ElitRTS502.dbo.r_Menu WHERE ChID != 0
INSERT r_MenuP SELECT * FROM ElitRTS502.dbo.r_MenuP
INSERT r_MenuM SELECT * FROM ElitRTS502.dbo.r_MenuM


DISABLE TRIGGER ALL ON r_WPs; INSERT r_WPs SELECT * from ElitRTS502.dbo.r_WPs WHERE ChID != 0; ENABLE TRIGGER ALL ON r_WPs;
DISABLE TRIGGER ALL ON r_WPRoles; INSERT r_WPRoles SELECT * from ElitRTS502.dbo.r_WPRoles WHERE ChID != 0; ENABLE TRIGGER ALL ON r_WPRoles;


select * from r_Prods where ProdID = 606118
insert r_pls SELECT * FROM [S-SQL-D4].ElitR.dbo.r_pls where chid !=0
SELECT * FROM [S-SQL-D4].ElitR.dbo.t_PInP where ParentDocCode in (null)

SELECT * FROM r_stocks where StockID = 1001*/

--FFood316_data
SELECT * FROM z_Vars where VarValue = '1'
t_RecalcPriceCC
SELECT m.MenuID, d.SubMenuID, m.MenuName, m.BgColor, m.Picture FROM r_Menu m JOIN r_MenuM d ON m.MenuID = d.SubMenuID WHERE d.MenuID = 5
ORDER BY d.OrderID
SELECT * FROM r_WPRoles
SELECT * FROM z_Vars WHERE VarValue = '0'

SELECT ProdID FROM r_MenuP where MenuID = 7

SELECT * FROM r_Prods where ProdID --= 603601

BEGIN TRAN;
UPDATE r_ProdMQ
SET BarCode = REPLACE(BarCode,'_упак','')
where BarCode like '%_упак%' 
and ProdID in (603589,603605,801051,801117,801120,801123,801125,603583,603593,603599,603597,603606,801118,801438,603601,801121,603871,603863)

SELECT * FROM r_ProdMQ where BarCode like '%_упак%' 
and ProdID in (603589,603605,801051,801117,801120,801123,801125,603583,603593,603599,603597,603606,801118,801438,603601,801121,603871,603863)
ROLLBACK TRAN;

SELECT * FROM r_ProdMQ where ProdID in (603589,603605,801051,801117,801120,801123,801125,603583,603593,603599,603597,603606,801118,801438,603601,801121,603871,603863)
SELECT * FROM sysobjects WHERE name = 't_SaleCustomCheckOKButton'

SELECT * FROM t_SaleTempPays

SELECT * FROM r_CRs where CRID = 2 or CRID = 601
SELECT * FROM r_CRs where CRID = 601
UPDATE r_WPs SET CRID = 601 where WPID = 1
SELECT * FROM r_WPs

SELECT * FROM r_Stocks where StockID = 1 or StockID = 1001 
SELECT * FROM r_WPRoles