BEGIN TRAN;

--TRUNCATE TABLE	ElitR_316.dbo.r_UniTypes
--TRUNCATE TABLE	ElitR_316.dbo.r_Uni
--TRUNCATE TABLE	ElitR_316.dbo.r_Currs
--TRUNCATE TABLE	ElitR_316.dbo.r_Ours
--TRUNCATE TABLE	ElitR_316.dbo.r_OursCC
--TRUNCATE TABLE	ElitR_316.dbo.r_OursAC
--TRUNCATE TABLE	ElitR_316.dbo.r_OurValues
--TRUNCATE TABLE	ElitR_316.dbo.r_Deps
--TRUNCATE TABLE	ElitR_316.dbo.r_Emps;

--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_Users;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.z_DataSets;
--ALTER TABLE ElitR_316.[dbo].[r_StateRuleUsers]  NOCHECK  CONSTRAINT [FK_r_StateRuleUsers_r_Users]; 
--ALTER TABLE ElitR_316.[dbo].[z_LogState]  NOCHECK  CONSTRAINT [FK_z_LogState_r_Users];
--delete  ElitR_316.dbo.r_Users; 
--ALTER TABLE ElitR_316.[dbo].[r_StateRuleUsers]  CHECK  CONSTRAINT [FK_r_StateRuleUsers_r_Users];
--ALTER TABLE ElitR_316.[dbo].[z_LogState]  CHECK  CONSTRAINT [FK_z_LogState_r_Users];
--ENABLE  TRIGGER ALL ON ElitR_316.dbo.z_DataSets;
--ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_Users;


--TRUNCATE TABLE	ElitR_316.dbo.r_Codes1
--TRUNCATE TABLE	ElitR_316.dbo.r_Codes2
--TRUNCATE TABLE	ElitR_316.dbo.r_Codes3
--TRUNCATE TABLE	ElitR_316.dbo.r_Codes4
--TRUNCATE TABLE	ElitR_316.dbo.r_Codes5
--TRUNCATE TABLE	ElitR_316.dbo.r_PLs
--TRUNCATE TABLE	ElitR_316.dbo.ir_PLProdGrs
--TRUNCATE TABLE	ElitR_316.dbo.r_Spends
--TRUNCATE TABLE	ElitR_316.dbo.r_States



--TRUNCATE TABLE	ElitR_316.dbo.r_StateRules
--TRUNCATE TABLE	ElitR_316.dbo.r_StateRuleUsers
--TRUNCATE TABLE	ElitR_316.dbo.r_StateDocs
--TRUNCATE TABLE	ElitR_316.dbo.r_StateDocsChange
--TRUNCATE TABLE	ElitR_316.dbo.r_CompGrs1
--TRUNCATE TABLE	ElitR_316.dbo.r_CompGrs2
--TRUNCATE TABLE	ElitR_316.dbo.r_CompGrs3
--TRUNCATE TABLE	ElitR_316.dbo.r_CompGrs4
--TRUNCATE TABLE	ElitR_316.dbo.r_CompGrs5;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_Comps; delete  ElitR_316.dbo.r_Comps; ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_Comps;



--TRUNCATE TABLE	ElitR_316.dbo.r_CompsAC
--TRUNCATE TABLE	ElitR_316.dbo.r_CompsCC
--TRUNCATE TABLE	ElitR_316.dbo.r_CompsAdd
--TRUNCATE TABLE	ElitR_316.dbo.r_CompValues
--TRUNCATE TABLE	ElitR_316.dbo.r_CompContacts
--TRUNCATE TABLE	ElitR_316.dbo.r_StockGs
--TRUNCATE TABLE	ElitR_316.dbo.r_Stocks
--TRUNCATE TABLE	ElitR_316.dbo.r_StockCRProds
--TRUNCATE TABLE	ElitR_316.dbo.ir_StockSubs
--TRUNCATE TABLE	ElitR_316.dbo.ir_StockFilters



--TRUNCATE TABLE	ElitR_316.dbo.r_ProdC
--TRUNCATE TABLE	ElitR_316.dbo.r_ProdG
--TRUNCATE TABLE	ElitR_316.dbo.r_ProdG1
--TRUNCATE TABLE	ElitR_316.dbo.r_ProdG2
--TRUNCATE TABLE	ElitR_316.dbo.r_ProdG3
--TRUNCATE TABLE	ElitR_316.dbo.r_ProdA
--TRUNCATE TABLE	ElitR_316.dbo.r_ProdBG;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_Prods; delete  ElitR_316.dbo.r_Prods; ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_Prods;
--TRUNCATE TABLE	ElitR_316.dbo.t_PInP
--TRUNCATE TABLE	ElitR_316.dbo.r_ProdMQ



--TRUNCATE TABLE	ElitR_316.dbo.r_ProdMP
--TRUNCATE TABLE	ElitR_316.dbo.r_ProdMA
--TRUNCATE TABLE	ElitR_316.dbo.r_ProdMS
--TRUNCATE TABLE	ElitR_316.dbo.r_ProdME
--TRUNCATE TABLE	ElitR_316.dbo.r_ProdAC
--TRUNCATE TABLE	ElitR_316.dbo.r_ProdEC
--TRUNCATE TABLE	ElitR_316.dbo.r_ProdCV
--TRUNCATE TABLE	ElitR_316.dbo.r_ProdMSE
--TRUNCATE TABLE	ElitR_316.dbo.r_ProdValues
--TRUNCATE TABLE	ElitR_316.dbo.r_ProdLV


--TRUNCATE TABLE	ElitR_316.dbo.ir_ProdMPA
--TRUNCATE TABLE	ElitR_316.dbo.ir_ProdOpers
--TRUNCATE TABLE	ElitR_316.dbo.r_DCTypeG;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_DCTypes; delete  ElitR_316.dbo.r_DCTypes; ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_DCTypes;

ALTER TABLE ElitR_316.[dbo].[z_LogDiscExp]  NOCHECK  CONSTRAINT [FK_z_LogDiscExp_r_DCards];
ALTER TABLE ElitR_316.[dbo].[z_LogDiscRec]  NOCHECK  CONSTRAINT [FK_z_LogDiscRec_r_DCards];  
ALTER TABLE ElitR_316.[dbo].[z_DocDC]  NOCHECK  CONSTRAINT [FK_z_DocDC_r_DCards]; 
delete ElitR_316.dbo.r_DCards;
ALTER TABLE ElitR_316.[dbo].[z_DocDC]  CHECK  CONSTRAINT [FK_z_DocDC_r_DCards];
ALTER TABLE ElitR_316.[dbo].[z_LogDiscRec]  CHECK  CONSTRAINT [FK_z_LogDiscRec_r_DCards]; 
ALTER TABLE ElitR_316.[dbo].[z_LogDiscExp]  CHECK  CONSTRAINT [FK_z_LogDiscExp_r_DCards];  

--TRUNCATE TABLE	ElitR_316.dbo.r_PayForms;

DISABLE TRIGGER ALL ON ElitR_316.dbo.r_CRs; delete  ElitR_316.dbo.r_CRs; ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_CRs;

--TRUNCATE TABLE	ElitR_316.dbo.r_CRMP
--TRUNCATE TABLE	ElitR_316.dbo.r_CRMM
--TRUNCATE TABLE	ElitR_316.dbo.r_CRDeskG



--TRUNCATE TABLE	ElitR_316.dbo.r_CRShed
--TRUNCATE TABLE	ElitR_316.dbo.r_Opers
--TRUNCATE TABLE	ElitR_316.dbo.r_OperCRs
--TRUNCATE TABLE	ElitR_316.dbo.r_CRUniInput
--TRUNCATE TABLE	ElitR_316.dbo.r_POSPays

--ALTER TABLE ElitR_316.[dbo].[z_LogDiscExp]  NOCHECK  CONSTRAINT [FK_z_LogDiscExp_r_Discs];
--ALTER TABLE ElitR_316.[dbo].[z_LogDiscRec]  NOCHECK  CONSTRAINT [FK_z_LogDiscRec_r_Discs]; 
--delete  ElitR_316.dbo.r_Discs; 
--ALTER TABLE ElitR_316.[dbo].[z_LogDiscExp]  CHECK  CONSTRAINT [FK_z_LogDiscExp_r_Discs];
--ALTER TABLE ElitR_316.[dbo].[z_LogDiscRec]  CHECK  CONSTRAINT [FK_z_LogDiscRec_r_Discs];

--TRUNCATE TABLE	ElitR_316.dbo.r_DiscDC
--TRUNCATE TABLE	ElitR_316.dbo.r_CRPOSPays
--TRUNCATE TABLE	ElitR_316.dbo.r_Taxes
--TRUNCATE TABLE	ElitR_316.dbo.r_TaxRates

--TRUNCATE TABLE	ElitR_316.dbo.r_Levies
--TRUNCATE TABLE	ElitR_316.dbo.r_LevyRates
--TRUNCATE TABLE	ElitR_316.dbo.r_LevyCR
--TRUNCATE TABLE	ElitR_316.dbo.at_r_ProdsAmort
--TRUNCATE TABLE	ElitR_316.dbo.at_r_Regions
--TRUNCATE TABLE	ElitR_316.dbo.at_r_ProdG4;
--TRUNCATE TABLE	ElitR_316.dbo.at_r_ProdG5
--TRUNCATE TABLE	ElitR_316.dbo.at_r_ProdG6
--TRUNCATE TABLE	ElitR_316.dbo.at_r_ProdG7
--TRUNCATE TABLE	ElitR_316.dbo.ir_OperTypes;

--DISABLE TRIGGER ALL ON ElitR_316.dbo.at_r_ProdG4; insert ElitR_316.dbo.at_r_ProdG4	(	ChID,PGrID4,PGrName4,Notes	) select 	ChID,PGrID4,PGrName4,Notes	from ElitR_306.dbo.at_r_ProdG4;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.at_r_ProdG4;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.at_r_ProdG5; insert ElitR_316.dbo.at_r_ProdG5	(	ChID,PGrID5,PGrName5,Notes,IsExcise	) select 	ChID,PGrID5,PGrName5,Notes,IsExcise	from ElitR_306.dbo.at_r_ProdG5;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.at_r_ProdG5;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.at_r_ProdG6; insert ElitR_316.dbo.at_r_ProdG6	(	ChID,PGrID6,PGrName6,Notes,CodeID5	) select 	ChID,PGrID6,PGrName6,Notes,CodeID5	from ElitR_306.dbo.at_r_ProdG6;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.at_r_ProdG6;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.at_r_ProdsAmort; insert ElitR_316.dbo.at_r_ProdsAmort	(	ChID,AmortID,AmortName,Notes,AmortPercent	) select 	ChID,AmortID,AmortName,Notes,AmortPercent	from ElitR_306.dbo.at_r_ProdsAmort;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.at_r_ProdsAmort;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.at_r_Regions; insert ElitR_316.dbo.at_r_Regions	(	ChID,RegionID,RegionName,Notes	) select 	ChID,RegionID,RegionName,Notes	from ElitR_306.dbo.at_r_Regions;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.at_r_Regions;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.ir_OperTypes; insert ElitR_316.dbo.ir_OperTypes	(	ChID,OperTypeID,OperTypeDesc,Notes	) select 	ChID,OperTypeID,OperTypeDesc,Notes	from ElitR_306.dbo.ir_OperTypes;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.ir_OperTypes;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.ir_PLProdGrs; insert ElitR_316.dbo.ir_PLProdGrs	(	PLID,PLProdGrID,PLProdGrName,ParentPLProdGrID	) select 	PLID,PLProdGrID,PLProdGrName,ParentPLProdGrID	from ElitR_306.dbo.ir_PLProdGrs;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.ir_PLProdGrs;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.ir_ProdMPA; insert ElitR_316.dbo.ir_ProdMPA	(	ProdID,PLID,PLProdGrID,DepID,CRProdID,CRProdName,Qty,PriceCC,Value1,Value2,Value3,InUse	) select 	ProdID,PLID,PLProdGrID,DepID,CRProdID,CRProdName,Qty,PriceCC,Value1,Value2,Value3,InUse	from ElitR_306.dbo.ir_ProdMPA;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.ir_ProdMPA;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.ir_ProdOpers; insert ElitR_316.dbo.ir_ProdOpers	(	ProdID,Percent1,Percent2,IsDefault,BDate,EDate,OperTypeID	) select 	ProdID,Percent1,Percent2,IsDefault,BDate,EDate,OperTypeID	from ElitR_306.dbo.ir_ProdOpers;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.ir_ProdOpers;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.at_r_ProdG7; insert ElitR_316.dbo.at_r_ProdG7	(	ChID,PGrID7,PGrName7,Notes	) select 	ChID,PGrID7,PGrName7,Notes	from ElitR_306.dbo.at_r_ProdG7;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.at_r_ProdG7;

--DISABLE TRIGGER ALL ON ElitR_316.dbo.ir_StockFilters; insert ElitR_316.dbo.ir_StockFilters	(	StockID,SrcPosID,FilterType,PCatFilter,PGrFilter,PProdFilter,Notes	) select 	StockID,SrcPosID,FilterType,PCatFilter,PGrFilter,PProdFilter,Notes	from ElitR_306.dbo.ir_StockFilters;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.ir_StockFilters;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.ir_StockSubs; insert ElitR_316.dbo.ir_StockSubs	(	StockID,SubStockID,DepID,IsFiscal	) select 	StockID,SubStockID,DepID,IsFiscal	from ElitR_306.dbo.ir_StockSubs;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.ir_StockSubs;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_Banks; insert ElitR_316.dbo.r_Banks	(	ChID,BankID,BankName,Address,PostIndex,City,Region,Phone,Fax,BankGrID,SWIFTBICCode	) select 	ChID,BankID,BankName,Address,PostIndex,City,Region,Phone,Fax,0,null	from ElitR_306.dbo.r_Banks;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_Banks;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_Codes1; insert ElitR_316.dbo.r_Codes1	(	ChID,CodeID1,CodeName1,Notes	) select 	ChID,CodeID1,CodeName1,Notes	from ElitR_306.dbo.r_Codes1;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_Codes1;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_Codes2; insert ElitR_316.dbo.r_Codes2	(	ChID,CodeID2,CodeName2,Notes	) select 	ChID,CodeID2,CodeName2,Notes	from ElitR_306.dbo.r_Codes2;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_Codes2;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_Codes3; insert ElitR_316.dbo.r_Codes3	(	ChID,CodeID3,CodeName3,Notes,CForm	) select 	ChID,CodeID3,CodeName3,Notes,CForm	from ElitR_306.dbo.r_Codes3;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_Codes3;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_Codes4; insert ElitR_316.dbo.r_Codes4	(	ChID,CodeID4,CodeName4,Notes,RegionID	) select 	ChID,CodeID4,CodeName4,Notes,RegionID	from ElitR_306.dbo.r_Codes4;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_Codes4;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_Codes5; insert ElitR_316.dbo.r_Codes5	(	ChID,CodeID5,CodeName5,Notes	) select 	ChID,CodeID5,CodeName5,Notes	from ElitR_306.dbo.r_Codes5;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_Codes5;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_CompContacts; insert ElitR_316.dbo.r_CompContacts	(	CompID,Contact,PhoneWork,PhoneMob,PhoneHome,eMail,Job,BirthDate	) select 	CompID,Contact,PhoneWork,PhoneMob,PhoneHome,eMail,Job,BirthDate	from ElitR_306.dbo.r_CompContacts;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_CompContacts;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_CompGrs1; insert ElitR_316.dbo.r_CompGrs1	(	ChID,CompGrID1,CompGrName1,Notes	) select 	ChID,CompGrID1,CompGrName1,Notes	from ElitR_306.dbo.r_CompGrs1;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_CompGrs1;

--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_CompGrs2; insert ElitR_316.dbo.r_CompGrs2	(	ChID,CompGrID2,CompGrName2,Notes	) select 	ChID,CompGrID2,CompGrName2,Notes	from ElitR_306.dbo.r_CompGrs2;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_CompGrs2;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_CompGrs3; insert ElitR_316.dbo.r_CompGrs3	(	ChID,CompGrID3,CompGrName3,Notes	) select 	ChID,CompGrID3,CompGrName3,Notes	from ElitR_306.dbo.r_CompGrs3;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_CompGrs3;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_CompGrs4; insert ElitR_316.dbo.r_CompGrs4	(	ChID,CompGrID4,CompGrName4,Notes	) select 	ChID,CompGrID4,CompGrName4,Notes	from ElitR_306.dbo.r_CompGrs4;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_CompGrs4;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_CompGrs5; insert ElitR_316.dbo.r_CompGrs5	(	ChID,CompGrID5,CompGrName5,Notes	) select 	ChID,CompGrID5,CompGrName5,Notes	from ElitR_306.dbo.r_CompGrs5;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_CompGrs5;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_Comps; insert ElitR_316.dbo.r_Comps	(	ChID,CompID,CompName,CompShort,Address,PostIndex,City,Region,Code,TaxRegNo,TaxCode,TaxPayer,CompDesc,Contact,Phone1,Phone2,Phone3,Fax,EMail,HTTP,Notes,CodeID1,CodeID2,CodeID3,CodeID4,CodeID5,UseCodes,PLID,UsePL,Discount,UseDiscount,PayDelay,UsePayDelay,MaxCredit,CalcMaxCredit,EmpID,Contract1,Contract2,Contract3,License1,License2,License3,Job1,Job2,Job3,TranPrc,MorePrc,FirstEventMode,CompType,SysTaxType,FixTaxPercent,InStopList,Value1,Value2,Value3,PassNo,PassSer,PassDate,PassDept,CompGrID1,CompGrID2,CompGrID3,CompGrID4,CompGrID5,CompNameFull,ExtCode,RegionID,IsResident,ReasonRegCode	) select 	ChID,CompID,CompName,CompShort,Address,PostIndex,City,Region,Code,TaxRegNo,TaxCode,TaxPayer,CompDesc,Contact,Phone1,Phone2,Phone3,Fax,EMail,HTTP,Notes,CodeID1,CodeID2,CodeID3,CodeID4,CodeID5,UseCodes,PLID,UsePL,Discount,UseDiscount,PayDelay,UsePayDelay,MaxCredit,CalcMaxCredit,EmpID,Contract1,Contract2,Contract3,License1,License2,License3,Job1,Job2,Job3,TranPrc,MorePrc,FirstEventMode,CompType,SysTaxType,FixTaxPercent,InStopList,Value1,Value2,Value3,PassNo,PassSer,PassDate,PassDept,CompGrID1,CompGrID2,CompGrID3,CompGrID4,CompGrID5,CompNameFull,ExtCode,RegionID,null,null	from ElitR_306.dbo.r_Comps;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_Comps;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_CompsAC; insert ElitR_316.dbo.r_CompsAC	(	CompID,BankID,CompAccountAC,DefaultAccount,Notes,IBANCode	) select 	CompID,BankID,CompAccountAC,DefaultAccount,Notes,null	from ElitR_306.dbo.r_CompsAC;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_CompsAC;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_CompsAdd; insert ElitR_316.dbo.r_CompsAdd	(	CompID,CompAdd,CompAddDesc,CompDefaultAdd,CompAddID	) select 	CompID,CompAdd,CompAddDesc,CompDefaultAdd,CompAddID	from ElitR_306.dbo.r_CompsAdd;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_CompsAdd;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_CompsCC; insert ElitR_316.dbo.r_CompsCC	(	CompID,BankID,CompAccountCC,DefaultAccount,Notes,IBANCode	) select 	CompID,BankID,CompAccountCC,DefaultAccount,Notes,null	from ElitR_306.dbo.r_CompsCC;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_CompsCC;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_CompValues; insert ElitR_316.dbo.r_CompValues	(	CompID,VarName,VarValue	) select 	CompID,VarName,VarValue	from ElitR_306.dbo.r_CompValues;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_CompValues;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_CRMP; insert ElitR_316.dbo.r_CRMP	(	CRID,ProdID,CRProdName,CRProdID,TaxID,SecID,FixedPrice,PriceCC,DecimalQty,BarCode	) select 	CRID,ProdID,CRProdName,CRProdID,TaxID,SecID,FixedPrice,PriceCC,DecimalQty,BarCode	from ElitR_306.dbo.r_CRMP;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_CRMP;

--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_CRShed; insert ElitR_316.dbo.r_CRShed	(	CRID,SrcPosID,Shed,CashRegAction,UseSched	) select 	CRID,SrcPosID,Shed,CashRegAction,UseSched	from ElitR_306.dbo.r_CRShed;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_CRShed;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_CRUniInput; insert ElitR_316.dbo.r_CRUniInput	(	ChID,UniInputCode,UniInputAction,UniInputMask,Notes,UniInput	) select 	ChID,UniInputCode,UniInputAction,UniInputMask,Notes,UniInput	from ElitR_306.dbo.r_CRUniInput;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_CRUniInput;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_Currs; insert ElitR_316.dbo.r_Currs	(	ChID,CurrID,CurrName,CurrDesc,KursMC,KursCC	) select 	ChID,CurrID,CurrName,CurrDesc,KursMC,KursCC	from ElitR_306.dbo.r_Currs;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_Currs;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_DCTypeG; insert ElitR_316.dbo.r_DCTypeG	(	ChID,DCTypeGCode,DCTypeGName,Notes,MainDialog,CloseDialogAfterEnter,ProcessingID	) select 	ChID,DCTypeGCode,DCTypeGName,Notes,MainDialog,CloseDialogAfterEnter,ProcessingID	from ElitR_306.dbo.r_DCTypeG;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_DCTypeG;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_DCTypes; insert ElitR_316.dbo.r_DCTypes	(	ChID,DCTypeCode,DCTypeName,Value1,Value2,Value3,InitSum,ProdID,Notes,MaxQty,DCTypeGCode,DeactivateAfterUse,NoManualDCardEnter	) select 	ChID,DCTypeCode,DCTypeName,Value1,Value2,Value3,InitSum,ProdID,Notes,MaxQty,DCTypeGCode,DeactivateAfterUse,NoManualDCardEnter	from ElitR_306.dbo.r_DCTypes;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_DCTypes;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_Deps; insert ElitR_316.dbo.r_Deps	(	ChID,DepID,DepName,Notes	) select 	ChID,DepID,DepName,Notes	from ElitR_306.dbo.r_Deps;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_Deps;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_DiscDC; ALTER TABLE ElitR_316.[dbo].[r_DiscDC]  NOCHECK  CONSTRAINT [FK_r_DiscDC_r_Discs]; insert ElitR_316.dbo.r_DiscDC	(	DiscCode,DCTypeCode,ForRec,ForExp	) select 	DiscCode,DCTypeCode,ForRec,ForExp	from ElitR_306.dbo.r_DiscDC;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_DiscDC; ALTER TABLE ElitR_316.[dbo].[r_DiscDC]  CHECK  CONSTRAINT [FK_r_DiscDC_r_Discs]; 
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_Discs; insert ElitR_316.dbo.r_Discs	(	ChID,DiscCode,DiscName,ThisChargeOnly,ThisDocBonus,OtherDocsBonus,ChargeDCard,DiscOnlyWithDCard,ChargeAfterClose,Priority,AllowDiscs,Shed1,Shed2,Shed3,BDate,EDate,GenProcs,InUse,DocCode,SimpleDisc,SaveDiscToDCard,SaveBonusToDCard,DiscFromDCard,ReProcessPosDiscs,ValidOurs,ValidStocks,AutoSelDiscs,ShortCut,Notes,GroupDisc,PrintInCheque,AllowZeroPrice,AllowEditQty,RedistributeDiscSumInBusket	) select 	ChID,DiscCode,DiscName,ThisChargeOnly,ThisDocBonus,OtherDocsBonus,ChargeDCard,DiscOnlyWithDCard,ChargeAfterClose,Priority,AllowDiscs,Shed1,Shed2,Shed3,BDate,EDate,GenProcs,InUse,DocCode,SimpleDisc,SaveDiscToDCard,SaveBonusToDCard,DiscFromDCard,ReProcessPosDiscs,ValidOurs,ValidStocks,AutoSelDiscs,ShortCut,Notes,GroupDisc,PrintInCheque,AllowZeroPrice,0,0	from ElitR_306.dbo.r_Discs;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_Discs;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_Emps; insert ElitR_316.dbo.r_Emps	(	ChID,EmpID,EmpName,UAEmpName,EmpLastName,EmpFirstName,EmpParName,UAEmpLastName,UAEmpFirstName,UAEmpParName,EmpInitials,UAEmpInitials,TaxCode,EmpSex,BirthDay,File1,File2,File3,Education,FamilyStatus,BirthPlace,Phone,InPhone,Mobile,EMail,Percent1,Percent2,Percent3,Notes,MilStatus,MilFitness,MilRank,MilSpecialCalc,MilProfes,MilCalcGrp,MilCalcCat,MilStaff,MilRegOffice,MilNum,PassNo,PassSer,PassDate,PassDept,DisNum,PensNum,WorkBookNo,WorkBookSer,PerFileNo,InStopList,BarCode,ShiftPostID,IsCitizen,CertInsurSer,CertInsurNum	) select 	ChID,EmpID,EmpName,UAEmpName,EmpLastName,EmpFirstName,EmpParName,UAEmpLastName,UAEmpFirstName,UAEmpParName,EmpInitials,UAEmpInitials,TaxCode,EmpSex,BirthDay,File1,File2,File3,Education,FamilyStatus,BirthPlace,Phone,InPhone,Mobile,EMail,Percent1,Percent2,Percent3,Notes,MilStatus,MilFitness,MilRank,MilSpecialCalc,MilProfes,MilCalcGrp,MilCalcCat,MilStaff,MilRegOffice,MilNum,PassNo,PassSer,PassDate,PassDept,DisNum,PensNum,WorkBookNo,WorkBookSer,PerFileNo,InStopList,BarCode,ShiftPostID,IsCitizen,CertInsurSer,CertInsurNum	from ElitR_306.dbo.r_Emps;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_Emps;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_Levies; insert ElitR_316.dbo.r_Levies	(	LevyID,LevyName,Notes	) select 	LevyID,LevyName,Notes	from ElitR_306.dbo.r_Levies;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_Levies;

--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_LevyCR; insert ElitR_316.dbo.r_LevyCR	(	LevyID,CashType,TaxID,CRTaxPercent,Override,TaxTypeID	) select 	LevyID,CashType,TaxID,CRTaxPercent,Override,TaxTypeID	from ElitR_306.dbo.r_LevyCR;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_LevyCR;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_LevyRates; insert ElitR_316.dbo.r_LevyRates	(	LevyID,ChDate,LevyPercent	) select 	LevyID,ChDate,LevyPercent	from ElitR_306.dbo.r_LevyRates;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_LevyRates;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_OperCRs; insert ElitR_316.dbo.r_OperCRs	(	CRID,OperID,CROperID,OperMaxQty,CanEditDiscount,CRVisible,OperPwd,AllowChequeClose,AllowAddToChequeFromCat,CRAdmin,AllowChangeDCType	) select 	CRID,OperID,CROperID,OperMaxQty,CanEditDiscount,CRVisible,OperPwd,AllowChequeClose,AllowAddToChequeFromCat,0,0	from ElitR_306.dbo.r_OperCRs;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_OperCRs;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_Opers; insert ElitR_316.dbo.r_Opers	(	ChID,OperID,OperName,OperPwd,EmpID,OperLockPwd	) select 	ChID,OperID,OperName,OperPwd,EmpID,OperLockPwd	from ElitR_306.dbo.r_Opers;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_Opers;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_Ours; insert ElitR_316.dbo.r_Ours	(	ChID,OurID,OurName,Address,PostIndex,City,Region,Code,TaxRegNo,TaxCode,OurDesc,Phone,Fax,OurShort,Note1,Note2,Note3,Job1,Job2,Job3,DayBTime,DayETime,EvenBTime,EvenETime,EvenPayFac,NightBTime,NightETime,NightPayFac,OverPayFactor,ActType,FinForm,PropForm,EcActType,PensFundID,SocInsFundID,SocUnEFundID,SocAddFundID,MinExcPowerID,TaxNotes,TaxOKPO,ActTypeCVED,TerritoryID,ExcComRegNum,SysTaxType,FixTaxPercent,TaxPayer,OurNameFull,IsResident	) select 	ChID,OurID,OurName,Address,PostIndex,City,Region,Code,TaxRegNo,TaxCode,OurDesc,Phone,Fax,OurShort,Note1,Note2,Note3,Job1,Job2,Job3,DayBTime,DayETime,EvenBTime,EvenETime,EvenPayFac,NightBTime,NightETime,NightPayFac,OverPayFactor,ActType,FinForm,PropForm,EcActType,PensFundID,SocInsFundID,SocUnEFundID,SocAddFundID,MinExcPowerID,TaxNotes,TaxOKPO,ActTypeCVED,TerritoryID,ExcComRegNum,SysTaxType,FixTaxPercent,TaxPayer,OurNameFull,null	from ElitR_306.dbo.r_Ours;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_Ours;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_OursAC; insert ElitR_316.dbo.r_OursAC	(	OurID,BankID,AccountAC,DefaultAccount,Notes,GAccID,IBANCode	) select 	OurID,BankID,AccountAC,DefaultAccount,Notes,GAccID,null	from ElitR_306.dbo.r_OursAC;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_OursAC;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_OursCC; insert ElitR_316.dbo.r_OursCC	(	OurID,BankID,AccountCC,DefaultAccount,Notes,GAccID,IBANCode	) select 	OurID,BankID,AccountCC,DefaultAccount,Notes,GAccID,null	from ElitR_306.dbo.r_OursCC;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_OursCC;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_OurValues; insert ElitR_316.dbo.r_OurValues	(	OurID,VarName,VarValue	) select 	OurID,VarName,VarValue	from ElitR_306.dbo.r_OurValues;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_OurValues;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_PayForms; insert ElitR_316.dbo.r_PayForms	(	ChID,PayFormCode,PayFormName,Notes,SumLabel,NotesLabel,CanEnterNotes,NotesMask,CanEnterSum,MaxQty,IsDefault,ForSale,ForRet,AutoCalcSum,DCTypeGCode,GroupPays,IsFiscal	) select 	ChID,PayFormCode,PayFormName,Notes,SumLabel,NotesLabel,CanEnterNotes,NotesMask,CanEnterSum,MaxQty,IsDefault,ForSale,ForRet,AutoCalcSum,DCTypeGCode,GroupPays,IsFiscal	from ElitR_306.dbo.r_PayForms;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_PayForms;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_PLs; insert ElitR_316.dbo.r_PLs	(	ChID,PLID,PLName,Notes	) select 	ChID,PLID,PLName,Notes	from ElitR_306.dbo.r_PLs;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_PLs;

--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_POSPays; insert ElitR_316.dbo.r_POSPays	(	ChID,POSPayID,POSPayName,POSPayClass,POSPayPort,POSPayTimeout,Notes,UseGrpCardForDiscs,UseUnionCheque,BankID,PrintTranInfoInCheque	) select 	ChID,POSPayID,POSPayName,POSPayClass,POSPayPort,POSPayTimeout,Notes,UseGrpCardForDiscs,0,0,0	from ElitR_306.dbo.r_POSPays;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_POSPays;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_ProdA; insert ElitR_316.dbo.r_ProdA	(	ChID,PGrAID,PGrAName,Notes	) select 	ChID,PGrAID,PGrAName,Notes	from ElitR_306.dbo.r_ProdA;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_ProdA;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_ProdAC; insert ElitR_316.dbo.r_ProdAC	(	ProdID,PLID,ChPLID,ExpE,ExpR,Notes	) select 	ProdID,PLID,ChPLID,ExpE,ExpR,Notes	from ElitR_306.dbo.r_ProdAC;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_ProdAC;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_ProdBG; insert ElitR_316.dbo.r_ProdBG	(	ChID,PBGrID,PBGrName,Notes,Tare	) select 	ChID,PBGrID,PBGrName,Notes,Tare	from ElitR_306.dbo.r_ProdBG;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_ProdBG;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_ProdC; insert ElitR_316.dbo.r_ProdC	(	ChID,PCatID,PCatName,Notes	) select 	ChID,PCatID,PCatName,Notes	from ElitR_306.dbo.r_ProdC;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_ProdC;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_ProdCV; insert ElitR_316.dbo.r_ProdCV	(	ProdID,CompID,BDate,EDate,Value1,Note1,Value2,Note2,Value3,Note3	) select 	ProdID,CompID,BDate,EDate,Value1,Note1,Value2,Note2,Value3,Note3	from ElitR_306.dbo.r_ProdCV;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_ProdCV;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_ProdEC; insert ElitR_316.dbo.r_ProdEC	(	ProdID,CompID,ExtProdID	) select 	ProdID,CompID,ExtProdID	from ElitR_306.dbo.r_ProdEC;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_ProdEC;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_ProdG; insert ElitR_316.dbo.r_ProdG	(	ChID,PGrID,PGrName,Notes,CodeID2	) select 	ChID,PGrID,PGrName,Notes,CodeID2	from ElitR_306.dbo.r_ProdG;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_ProdG;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_ProdG1; insert ElitR_316.dbo.r_ProdG1	(	ChID,PGrID1,PGrName1,Notes,CodeID1	) select 	ChID,PGrID1,PGrName1,Notes,CodeID1	from ElitR_306.dbo.r_ProdG1;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_ProdG1;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_ProdG2; insert ElitR_316.dbo.r_ProdG2	(	ChID,PGrID2,PGrName2,Notes	) select 	ChID,PGrID2,PGrName2,Notes	from ElitR_306.dbo.r_ProdG2;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_ProdG2;

--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_ProdG3; insert ElitR_316.dbo.r_ProdG3	(	ChID,PGrID3,PGrName3,Notes,Priority	) select 	ChID,PGrID3,PGrName3,Notes,Priority	from ElitR_306.dbo.r_ProdG3;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_ProdG3;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_ProdLV; insert ElitR_316.dbo.r_ProdLV	(	ProdID,LevyID	) select 	ProdID,LevyID	from ElitR_306.dbo.r_ProdLV;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_ProdLV;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_ProdMA; insert ElitR_316.dbo.r_ProdMA	(	ProdID,AProdID,ValidSets,Priority,Notes	) select 	ProdID,AProdID,ValidSets,Priority,Notes	from ElitR_306.dbo.r_ProdMA;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_ProdMA;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_ProdME; insert ElitR_316.dbo.r_ProdME	(	ProdID,CodeID1,CodeID2,CodeID3,CodeID4,CodeID5,LExp,EExp,ExpType	) select 	ProdID,CodeID1,CodeID2,CodeID3,CodeID4,CodeID5,LExp,EExp,ExpType	from ElitR_306.dbo.r_ProdME;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_ProdME;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_ProdMP; insert ElitR_316.dbo.r_ProdMP	(	ProdID,PLID,PriceMC,Notes,CurrID,DepID,InUse,PromoPriceCC,BDate,EDate,StockID	) select 	ProdID,PLID,PriceMC,Notes,CurrID,DepID,InUse,PromoPriceCC,BDate,EDate,StockID	from ElitR_306.dbo.r_ProdMP;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_ProdMP;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_ProdMQ; insert ElitR_316.dbo.r_ProdMQ	(	ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID,TareWeight	) select 	ProdID,UM,Qty,Weight,Notes,BarCode,ProdBarCode,PLID,0	from ElitR_306.dbo.r_ProdMQ;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_ProdMQ;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_ProdMS; insert ElitR_316.dbo.r_ProdMS	(	ProdID,SProdID,LExp,EExp,LExpSub,EExpSub,UseSubItems,UseSubDoc,Priority	) select 	ProdID,SProdID,LExp,EExp,LExpSub,EExpSub,UseSubItems,UseSubDoc,Priority	from ElitR_306.dbo.r_ProdMS;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_ProdMS;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_ProdMSE; insert ElitR_316.dbo.r_ProdMSE	(	ProdID,SProdID,LExp,EExp,LExpSub,EExpSub,UseSubItems,UseSubDoc	) select 	ProdID,SProdID,LExp,EExp,LExpSub,EExpSub,UseSubItems,UseSubDoc	from ElitR_306.dbo.r_ProdMSE;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_ProdMSE;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_Prods; insert ElitR_316.dbo.r_Prods	(	ChID,ProdID,ProdName,UM,Country,Notes,PCatID,PGrID,Article1,Article2,Article3,Weight,Age,PriceWithTax,Note1,Note2,Note3,MinPriceMC,MaxPriceMC,MinRem,CstDty,CstPrc,CstExc,StdExtraR,StdExtraE,MaxExtra,MinExtra,UseAlts,UseCrts,PGrID1,PGrID2,PGrID3,PGrAID,PBGrID,LExpSet,EExpSet,InRems,IsDecQty,File1,File2,File3,AutoSet,Extra1,Extra2,Extra3,Extra4,Extra5,Norma1,Norma2,Norma3,Norma4,Norma5,RecMinPriceCC,RecMaxPriceCC,RecStdPriceCC,RecRemQty,InStopList,PrepareTime,AmortID,PGrID4,UseDiscount,ScaleGrID,ScaleStandard,ScaleConditions,ScaleComponents,PGrID5,PGrID6,PGrID7,UAProdName,TaxFreeReason,CstProdCode,WeightGr,WeightGrWP,BoxVolume,OldProdID,IndWSPriceCC,IndRetPriceCC,TaxTypeID,CstDty2,CounID	) select 	ChID,ProdID,ProdName,UM,Country,Notes,PCatID,PGrID,Article1,Article2,Article3,Weight,Age,PriceWithTax,Note1,Note2,Note3,MinPriceMC,MaxPriceMC,MinRem,CstDty,CstPrc,CstExc,StdExtraR,StdExtraE,MaxExtra,MinExtra,UseAlts,UseCrts,PGrID1,PGrID2,PGrID3,PGrAID,PBGrID,LExpSet,EExpSet,InRems,IsDecQty,File1,File2,File3,AutoSet,Extra1,Extra2,Extra3,Extra4,Extra5,Norma1,Norma2,Norma3,Norma4,Norma5,RecMinPriceCC,RecMaxPriceCC,RecStdPriceCC,RecRemQty,InStopList,PrepareTime,AmortID,PGrID4,UseDiscount,ScaleGrID,ScaleStandard,ScaleConditions,ScaleComponents,PGrID5,PGrID6,PGrID7,UAProdName,TaxFreeReason,CstProdCode,WeightGr,WeightGrWP,BoxVolume,OldProdID,IndWSPriceCC,IndRetPriceCC,TaxTypeID,0,0	from ElitR_306.dbo.r_Prods;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_Prods;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_ProdValues; insert ElitR_316.dbo.r_ProdValues	(	ProdID,VarName,VarValue	) select 	ProdID,VarName,VarValue	from ElitR_306.dbo.r_ProdValues;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_ProdValues;

--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_Spends; insert ElitR_316.dbo.r_Spends	(	ChID,SpendCode,SpendName,Notes	) select 	ChID,SpendCode,SpendName,Notes	from ElitR_306.dbo.r_Spends;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_Spends;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_StateDocs; insert ElitR_316.dbo.r_StateDocs	(	DocCode,StateCode	) select 	DocCode,StateCode	from ElitR_306.dbo.r_StateDocs;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_StateDocs;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_StateDocsChange; insert ElitR_316.dbo.r_StateDocsChange	(	UserCode,StateCode	) select 	UserCode,StateCode	from ElitR_306.dbo.r_StateDocsChange;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_StateDocsChange;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_StateRules; insert ElitR_316.dbo.r_StateRules	(	StateRuleCode,Notes,StateCodeFrom,StateCodeTo,DenyUsers	) select 	StateRuleCode,Notes,StateCodeFrom,StateCodeTo,DenyUsers	from ElitR_306.dbo.r_StateRules;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_StateRules;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_StateRuleUsers; ALTER TABLE ElitR_316.[dbo].[r_StateRuleUsers]  NOCHECK  CONSTRAINT [FK_r_StateRuleUsers_r_Users]; insert ElitR_316.dbo.r_StateRuleUsers	(	StateRuleCode,UserCode	) select 	StateRuleCode,UserCode	from ElitR_306.dbo.r_StateRuleUsers; ALTER TABLE ElitR_316.[dbo].[r_StateRuleUsers]  CHECK  CONSTRAINT [FK_r_StateRuleUsers_r_Users]; ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_StateRuleUsers;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_States; insert ElitR_316.dbo.r_States	(	ChID,StateCode,StateName,StateInfo,CanChangeDoc	) select 	ChID,StateCode,StateName,StateInfo,CanChangeDoc	from ElitR_306.dbo.r_States;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_States;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_StockCRProds; insert ElitR_316.dbo.r_StockCRProds	(	StockID,ProdID,CRProdID,CRProdGroup	) select 	StockID,ProdID,CRProdID,CRProdGroup	from ElitR_306.dbo.r_StockCRProds;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_StockCRProds;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_StockGs; insert ElitR_316.dbo.r_StockGs	(	ChID,StockGID,StockGName,Notes	) select 	ChID,StockGID,StockGName,Notes	from ElitR_306.dbo.r_StockGs;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_StockGs;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_Stocks; insert ElitR_316.dbo.r_Stocks	(	ChID,StockID,StockName,StockGID,Notes,PLID,EmpID,IsWholesale,Address,StockTaxID,ExtCode,RegionID,DepID	) select 	ChID,StockID,StockName,StockGID,Notes,PLID,EmpID,IsWholesale,Address,StockTaxID,ExtCode,RegionID,DepID	from ElitR_306.dbo.r_Stocks;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_Stocks;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_Taxes; insert ElitR_316.dbo.r_Taxes	(	TaxTypeID,TaxName,TaxDesc,TaxID,Notes	) select 	TaxTypeID,TaxName,TaxDesc,TaxID,Notes	from ElitR_306.dbo.r_Taxes;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_Taxes;

--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_TaxRates; insert ElitR_316.dbo.r_TaxRates	(	TaxTypeID,ChDate,TaxPercent	) select 	TaxTypeID,ChDate,TaxPercent	from ElitR_306.dbo.r_TaxRates;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_TaxRates;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_Uni; insert ElitR_316.dbo.r_Uni	(	RefTypeID,RefID,RefName,Notes	) select 	RefTypeID,RefID,RefName,Notes	from ElitR_306.dbo.r_Uni;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_Uni;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_UniTypes; insert ElitR_316.dbo.r_UniTypes	(	ChID,RefTypeID,RefTypeName,Notes	) select 	ChID,RefTypeID,RefTypeName,Notes	from ElitR_306.dbo.r_UniTypes;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_UniTypes;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_Users; insert ElitR_316.dbo.r_Users	(	ChID,UserID,UserName,EmpID,Admin,Active,Emps,s_PPAcc,s_Cost,s_CCPL,s_CCPrice,s_CCDiscount,CanCopyRems,BDate,EDate,UseOpenAge,CanInitAltsPL,ShowPLCange,CanChangeStatus,CanChangeDiscount,CanPrintDoc,CanBuffDoc,CanChangeDocID,CanChangeKursMC,AllowRestEditDesk,AllowRestReserve,AllowRestMove,CanExportPrint,p_SalaryAcc,AllowRestChequeUnite,AllowRestChequeDel,OpenAgeBType,OpenAgeBQty,OpenAgeEType,OpenAgeEQty,AllowRestViewDesk	) select 	ChID,UserID,UserName,EmpID,Admin,Active,Emps,s_PPAcc,s_Cost,s_CCPL,s_CCPrice,s_CCDiscount,CanCopyRems,BDate,EDate,UseOpenAge,CanInitAltsPL,ShowPLCange,CanChangeStatus,CanChangeDiscount,CanPrintDoc,CanBuffDoc,CanChangeDocID,CanChangeKursMC,AllowRestEditDesk,AllowRestReserve,AllowRestMove,CanExportPrint,p_SalaryAcc,AllowRestChequeUnite,AllowRestChequeDel,OpenAgeBType,OpenAgeBQty,OpenAgeEType,OpenAgeEQty,AllowRestViewDesk	from ElitR_306.dbo.r_Users;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_Users;

--DISABLE TRIGGER ALL ON ElitR_316.dbo.t_PInP; insert ElitR_316.dbo.t_PInP	(	ProdID,PPID,PPDesc,PriceMC_In,PriceMC,Priority,ProdDate,DLSDate,CurrID,CompID,Article,CostAC,PPWeight,File1,File2,File3,PriceCC_In,CostCC,PPDelay,ProdPPDate,IsCommission,PriceAC_In,CostMC,CstProdCode,CstDocCode,ParentDocCode,ParentChID,ElitProdID	) select 	ProdID,PPID,PPDesc,PriceMC_In,PriceMC,Priority,ProdDate,DLSDate,CurrID,CompID,Article,CostAC,PPWeight,File1,File2,File3,PriceCC_In,CostCC,PPDelay,ProdPPDate,IsCommission,PriceAC_In,CostMC,CstProdCode,CstDocCode,ParentDocCode,ParentChID,ElitProdID	from ElitR_306.dbo.t_PInP;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.t_PInP;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_CRPOSPays; insert ElitR_316.dbo.r_CRPOSPays	(	POSPayID,IsDefault,WPID	) select 	POSPayID,IsDefault,CRID WPID	from ElitR_306.dbo.r_CRPOSPays;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_CRPOSPays;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_CRMM; insert ElitR_316.dbo.r_CRMM	(	MPayDesc,CodeID1,CodeID2,CodeID3,CodeID4,CodeID5,IsRec,WPRoleID	) select 	MPayDesc,CodeID1,CodeID2,CodeID3,CodeID4,CodeID5,IsRec,CRID WPRoleID	from ElitR_306.dbo.r_CRMM;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_CRMM;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_CRDeskG; insert ElitR_316.dbo.r_CRDeskG	(	DeskGCode,WPID	) select 	DeskGCode,CRID WPID	from ElitR_306.dbo.r_CRDeskG;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_CRDeskG;

DISABLE TRIGGER ALL ON ElitR_316.dbo.r_DCards; insert ElitR_316.dbo.r_DCards	(	ChID,CompID,DCardID,Discount,SumCC,InUse,Notes,Value1,Value2,Value3,IsCrdCard,Note1,EDate,DCTypeCode,FactPostIndex,SumBonus,Status,IsPayCard,BDate,AskPWDDCardEnter,AutoSaveOddMoneyToProcessing	) select 	ChID,CompID,DCardID,Discount,SumCC,InUse,Notes,Value1,Value2,Value3,IsCrdCard,Note1,EDate,DCTypeCode,FactPostIndex,SumBonus,Status,IsPayCard,BDate, 0, 0	from ElitR_306.dbo.r_DCards;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_DCards;
--DISABLE TRIGGER ALL ON ElitR_316.dbo.r_CRs; insert ElitR_316.dbo.r_CRs	(ChID, CRID, CRName, Notes, FinID, FacID, CRPort, CRCode, SrvID, StockID, SecID, CashType, UseProdNotes, BaudRate, LEDType, CanEditPrice, PaperWarning, DecQtyFromRef, UseStockPL, CashRegMode, NetPort, ModemID, ModemPassword, NFOurID, IP, GroupProds, AutoUpdateTaxes,BackupCRJournalAfterZReport,BackupCRJournalAfterChequeType, BackupCRJournalChequeTimeout, BackupCRJournalInTime, BackupCRJournalExecTime) select 	ChID, CRID, CRName, Notes, FinID, FacID, CRPort, CRCode, SrvID, StockID, SecID, CashType, UseProdNotes, BaudRate, LEDType, CanEditPrice, PaperWarning, DecQtyFromRef, UseStockPL, CashRegMode, NetPort, ModemID, ModemPassword, NFOurID, IP, GroupProds, AutoUpdateTaxes, 0, 0, 0, 0, 0 from ElitR_306.dbo.r_CRs;	ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_CRs;

ROLLBACK TRAN;