--„истка ElitR for ElitRTS 
/*
1-сделать бекап ElitR в папку \\s-sql-d4\E:\OT38ElitServer\Import\ElitRTS.bak

USE master
BACKUP DATABASE ElitR TO DISK = 'E:\OT38ElitServer\Import\ElitRTS.bak' WITH INIT, NOUNLOAD, NAME = 'ElitRTS.bak', SKIP, STATS=10, NOFORMAT, COMPRESSION
      

2-¬ыбрасываем пользователей из ElitR_test_empty

USE master
DECLARE @DBID int, @SPID int, @Cmd varchar(8000) 
SELECT * FROM master.dbo.sysprocesses sp WHERE dbid=(SELECT database_id FROM master.sys.databases where name = 'ElitR_test_empty' )
   -------------------------------------------------------------------------------
    -- ¬ыбрасываем пользователей
    -------------------------------------------------------------------------------
    DECLARE KillAll CURSOR FAST_FORWARD LOCAL FOR
      SELECT spid FROM master.dbo.sysprocesses sp 
        WHERE dbid=(SELECT database_id FROM master.sys.databases where name = 'ElitR_test_empty' )
    OPEN KillAll
    FETCH NEXT FROM KillAll INTO @SPID
    WHILE @@FETCH_STATUS = 0 BEGIN
      SET @Cmd='KILL ' + CAST(@SPID AS varchar)
      EXEC(@Cmd)
      FETCH NEXT FROM KillAll INTO @SPID
    END
    CLOSE KillAll
    DEALLOCATE KillAll

    
3-востановить бекап 1.bak в базу ElitR_test_empty

4-запустить скрипт „истка ElitR for ElitRTS.sql (3 мин 38 сек)

5-Ќазначить нужную базу по главной в приложение OTMDB38

6---проверка и изменение пор€дка выполнени€ тригеров

USE ElitR_test_empty
select * from sys.objects where  (type='TR' or type='TA') and ObjectProperty(object_id, 'ExecIsFirstDeleteTrigger') = 1
ORDER BY 1,parent_object_id

EXEC sp_settriggerorder @triggername=N'[dbo].[TGMSRel3_Del_r_DeviceTypes]', @order=N'none', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TGMSRel3_Del_t_Sale]', @order=N'none', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TGMSRel3_Del_t_SaleD]', @order=N'none', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TGMSRel3_Del_t_SaleTemp]', @order=N'none', @stmttype=N'DELETE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TGMSRel3_Del_t_SaleTempD]', @order=N'none', @stmttype=N'DELETE'

select * from sys.objects where  (type='TR' or type='TA') and ObjectProperty(object_id, 'ExecIsFirstUpdateTrigger') = 1
ORDER BY 1,parent_object_id

EXEC sp_settriggerorder @triggername=N'[dbo].[TGMSRel2_Upd_r_DeviceTypes]', @order=N'none', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TGMSRel2_Upd_t_Sale]', @order=N'none', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TGMSRel2_Upd_t_SaleD]', @order=N'none', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TGMSRel2_Upd_t_SaleTemp]', @order=N'none', @stmttype=N'UPDATE'
EXEC sp_settriggerorder @triggername=N'[dbo].[TGMSRel2_Upd_t_SaleTempD]', @order=N'none', @stmttype=N'UPDATE'

select * from sys.objects where  (type='TR' or type='TA') and ObjectProperty(object_id, 'ExecIsFirstInsertTrigger') = 1
ORDER BY 1,parent_object_id

EXEC sp_settriggerorder @triggername=N'[dbo].[TGMSRel2_Ins_r_DeviceTypes]', @order=N'none', @stmttype=N'INSERT'

7-доработаки дл€ локальных баз
”даление лишних тригеров которы приводили к дублированию записей в r_ProdLV при синхронизации

IF OBJECT_ID ('a_rProds_SetValues_U', 'TR') IS NOT NULL   DROP TRIGGER a_rProds_SetValues_U;
IF OBJECT_ID ('a_rProds_SetValues_I', 'TR') IS NOT NULL   DROP TRIGGER a_rProds_SetValues_I;

8-—жать базу (6 мин)

  USE [ElitR_test_empty]
  DBCC SHRINKDATABASE ([ElitR_test_empty])
    
9-сделать бекап ElitR_test_empty

*/
USE [ElitR_test_empty]


DROP TABLE __clients;
DROP TABLE __discsql;
DROP TABLE __ppids;
DROP TABLE __t_RetChIDs;
DROP TABLE __t_VenD;
DROP TABLE __z_ReplicaEvents;
DROP TABLE __z_ReplicaIn;
DROP TABLE __z_ReplicaOut;
DROP TABLE _calc;
DROP TABLE _CheckReplica;
DROP TABLE _DateQty;
DROP TABLE _eppd;
DROP TABLE _Prods;
DROP TABLE _ReplicaOut;
DROP TABLE _test;
DROP TABLE _TRemD;
-- at_c_CompExpImport
-- at_c_CompRecImport
-- at_r_Clients
-- at_r_ClientsAdd
-- at_r_CompClients
-- at_r_OurMEDoc
-- use in sync -- at_r_ProdG4
-- use in sync -- at_r_ProdG5
-- use in sync -- at_r_ProdG6
-- use in sync -- at_r_ProdG7
-- use in sync -- at_r_ProdsAmort
-- at_r_prodstemp3
-- use in sync -- at_r_Regions
TRUNCATE TABLE at_t_IORes;
TRUNCATE TABLE at_t_IOResD;
TRUNCATE TABLE at_z_AzRepsLog;
-- at_z_Contracts
-- at_z_ContractsAdd
-- b_Acc
-- b_AccD
-- b_AExp
-- b_ARec
-- b_ARepA
-- b_ARepADP
-- b_ARepADS
-- b_ARepADV
-- b_BankExpAC
-- b_BankExpCC
-- b_BankPayAC
-- b_BankPayCC
-- b_BankRecAC
-- b_BankRecCC
-- b_CExp
-- b_CInv
-- b_CInvD
-- b_CRec
-- b_CRepA
-- b_CRepADP
-- b_CRepADS
-- b_CRepADV
-- b_CRet
-- b_CRetD
-- b_Cst
-- b_CstD
-- b_DStack
-- b_Exp
-- b_ExpD
-- b_GOperDocs
-- b_GTran
-- b_GTranD
-- b_GView
-- b_GViewD
-- b_GViewU
-- b_Inv
-- b_InvD
-- b_LExp
-- b_LExpD
-- b_LRec
-- b_LRecD
-- b_PAcc
-- b_PAccD
-- b_PCost
-- b_PCostD
-- b_PCostDDExp
-- b_PCostDDExpProds
-- b_PCostDExp
-- b_PEst
-- b_PEstD
-- b_PExc
-- b_PExcD
-- b_PInP
-- b_PVen
-- b_PVenA
-- b_PVenD
-- b_Rec
-- b_RecD
-- b_Rem
-- b_RemD
-- b_RepA
-- b_RepADP
-- b_RepADS
-- b_RepADV
-- b_Ret
-- b_RetD
-- b_SDep
-- b_SDepD
-- b_SExc
-- b_SExcD
-- b_SExp
-- b_SExpD
-- b_SInv
-- b_SInvD
-- b_SPut
-- b_SPutD
-- b_SRec
-- b_SRecD
-- b_SRep
-- b_SRepDP
-- b_SRepDV
-- b_SVen
-- b_SVenD
-- b_SWer
-- b_SWerD
-- b_TExp
-- b_TranC
-- b_TranE
-- b_TranH
-- b_TranP
-- b_TranS
-- b_TranV
-- b_TRec
-- b_WBill
-- b_WBillA
-- b_WBillD
-- b_zInBA
-- b_zInBC
-- b_zInC
-- b_zInCA
-- b_zInE
-- b_zInH
-- b_zInP
-- b_zInS
-- b_zInV
-- c_CompCor
-- c_CompCurr
-- c_CompExp
-- c_CompIn
-- c_CompRec
-- c_EmpCor
-- c_EmpCurr
-- c_EmpExc
-- c_EmpExp
-- c_EmpIn
-- c_EmpRec
-- c_EmpRep
-- c_OurCor
-- c_OurIn
-- c_PlanExp
-- c_PlanRec
-- c_Sal
-- c_SalD
-- dtproperties
-- ir_AM
-- ir_AMD
-- ir_AMStocks
-- ir_DCardsOld
-- ir_DeliveryGroup
-- use in sync -- ir_OperTypes
-- use in sync -- ir_PLProdGrs
-- use in sync -- ir_ProdMPA
-- use in sync -- ir_ProdOpers
-- use in sync -- ir_StockFilters
-- use in sync -- ir_StockSubs
-- it_AktPlan
-- it_AktPlanD
-- it_AktPlanPCat
-- it_AktPlanSpends
-- it_AktPlanStocks
-- it_CancPrice
-- it_CancPriceCats
-- it_CancPriceD
-- it_ComplexMenu
-- it_OrdProdsRnd
-- it_PrintPriceList
-- it_RecUnknBarCodes
-- it_Spec
-- it_SpecD
-- it_SpecDesc
-- it_SpecParams
-- it_SpecT
TRUNCATE TABLE it_TSD_barcode;
TRUNCATE TABLE it_TSD_contragents;
TRUNCATE TABLE it_TSD_doc_details;
TRUNCATE TABLE it_TSD_doc_detailsinv;
TRUNCATE TABLE it_TSD_doc_head;
TRUNCATE TABLE it_TSD_doc_headinv;
TRUNCATE TABLE it_TSD_goods;
TRUNCATE TABLE it_TSD_sklad;
TRUNCATE TABLE it_TSD_users;
-- p_CommunalTax
-- p_CommunalTaxD
-- p_CommunalTaxDD
-- p_CPIs
-- p_CWTime
-- p_CWTimeCor
-- p_CWTimeD
-- p_CWTimeDD
-- p_CWTimeDDExt
-- p_DTran
-- p_EDis
-- p_EExc
-- p_EGiv
-- p_ELeav
-- p_ELeavCor
-- p_ELeavCorD
-- p_ELeavD
-- p_ELeavDD
-- p_ELeavDP
-- p_EmpIn
-- p_EmpInLeavs
-- p_EmpInLExp
-- p_EmpInLRec
-- p_EmpInWTime
-- p_EmpSchedExt
-- p_EmpSchedExtD
-- p_ESic
-- p_ESicA
-- p_ESicD
-- p_ETrp
-- p_EWri
-- p_EWriP
-- p_EWrk
-- p_EWrkD
-- p_LExc
-- p_LExcD
-- p_LExp
-- p_LExpD
-- p_LMem
-- p_LMemD
-- p_LRec
-- p_LRecD
-- p_LRecDCor
-- p_LRecDCorCR
-- p_LRecDD
-- p_LStr
-- p_LStrD
-- p_OPWrk
-- p_OPWrkD
-- p_TSer
-- p_TSerD
-- p_WExc
-- r_AssetC
-- r_AssetG
-- r_AssetG1
-- r_AssetGDeps
-- r_AssetH
-- r_Assets
-- use in sync -- r_Banks
-- r_Carrs
-- r_CarrsC
-- use in sync -- r_Codes1
-- use in sync -- r_Codes2
-- use in sync -- r_Codes3
-- use in sync -- r_Codes4
-- use in sync -- r_Codes5
-- use in sync -- r_CompContacts
-- r_CompG
-- use in sync -- r_CompGrs1
-- use in sync -- r_CompGrs2
-- use in sync -- r_CompGrs3
-- use in sync -- r_CompGrs4
-- use in sync -- r_CompGrs5
-- r_CompMG
-- use in sync -- r_Comps
-- use in sync -- r_CompsAC
-- use in sync -- r_CompsAdd
-- use in sync -- r_CompsCC
-- use in sync -- r_CompValues
-- use in sync -- r_CRDeskG
-- use in sync -- r_CRMM
-- use in sync -- r_CRMP
-- use in sync -- r_CRPOSPays
-- use in sync -- r_CRs
-- use in sync -- r_CRShed
-- r_CRSrvs
-- use in sync -- r_CRUniInput
-- r_CurrH
-- use in sync -- r_Currs
-- r_DBIs
-- use in sync -- r_DCardKin
-- use in sync -- r_DCards
-- use in sync -- r_DCTypeG
-- r_DCTypeP
-- use in sync -- r_DCTypes
-- use in sync -- r_Deps
-- r_DeskG
-- r_Desks
-- r_DeviceTypes
-- r_DiscChargeD
-- r_DiscChargeDT
-- use in sync -- r_DiscDC
-- r_DiscMessages
-- r_DiscMessagesT
-- use in sync -- r_Discs
-- r_DiscSale
-- r_DiscSaleBonus
-- r_DiscSaleD
-- r_DiscSaleDBonus
-- r_DiscSaleDT
-- r_DiscSaleT
-- r_DiscsT
-- r_DocShed
-- r_DocShedD
-- r_EmpAcc
-- r_EmpAct
-- r_EmpAdd
-- r_EmpInc
-- r_EmpKin
-- r_EmpMO
-- r_EmpMP
-- r_EmpMPst
-- r_EmpNames
-- use in sync -- r_Emps
-- r_Executors
-- r_ExecutorServices
-- r_ExecutorShifts
-- r_GAccFA
-- r_GAccs
-- r_GAccs1
-- r_GAccs2
-- r_GOperC
-- r_GOperD
-- r_GOperFC
-- r_GOperFD
-- r_GOpers
-- r_GVols
-- r_Holidays
-- use in sync -- r_Levies
-- use in sync -- r_LevyCR
-- use in sync -- r_LevyRates
-- r_Mods
-- r_NormMH
-- r_Norms
-- use in sync -- r_OperCRs
-- use in sync -- r_Opers
-- use in sync -- r_Ours
-- use in sync -- r_OursAC
-- use in sync -- r_OursCC
-- use in sync -- r_OurValues
-- use in sync -- r_PayForms
-- r_PayTypeCats
-- r_PayTypes
-- r_PCs
-- r_PersonDC
-- r_PersonExecutorsBL
-- r_PersonPreferences
-- r_PersonResourcesBL
-- r_Persons
-- use in sync -- r_PLs
-- use in sync -- r_POSPays
-- r_PostC
-- r_PostMC
-- r_Posts
-- r_Prevs
-- r_Processings
-- r_Prod_Calc
-- use in sync -- r_ProdA
-- use in sync -- r_ProdAC
-- use in sync -- r_ProdBG
-- use in sync -- r_ProdC
-- use in sync -- r_ProdCV
-- use in sync -- r_ProdEC
-- use in sync -- r_ProdG
-- use in sync -- r_ProdG1
-- use in sync -- r_ProdG2
-- use in sync -- r_ProdG3
-- r_ProdImages
-- use in sync -- r_ProdLV
-- use in sync -- r_ProdMA
-- use in sync -- r_ProdME
-- use in sync -- r_ProdMP
TRUNCATE TABLE r_ProdMPCh;
-- use in sync -- r_ProdMQ
-- use in sync -- r_ProdMS
-- use in sync -- r_ProdMSE
-- use in sync -- r_Prods
-- use in sync -- r_ProdValues
-- r_Resources
-- r_ResourceSched
-- r_ResourceTypes
-- r_ScaleDefKeys
-- r_ScaleDefs
-- r_ScaleGrMW
-- r_ScaleGrs
-- r_Scales
-- r_Secs
-- r_ServiceCompatibility
-- r_ServiceResources
-- r_Services
-- r_ShedMD
-- r_ShedMS
-- r_Sheds
-- use in sync -- r_Spends
-- use in sync -- r_StateDocs
-- use in sync -- r_StateDocsChange
-- use in sync -- r_StateRules
-- use in sync -- r_StateRuleUsers
-- use in sync -- r_States
-- use in sync -- r_StockCRProds
-- use in sync -- r_StockGs
-- use in sync -- r_Stocks
-- r_Subs
-- use in sync -- r_Taxes
-- use in sync -- r_TaxRates
-- r_TaxRegionRates
-- r_TaxRegions
-- use in sync -- r_Uni
-- use in sync -- r_UniTypes
-- use in sync -- r_Users
-- r_WPrefs
-- r_WrkTypes
-- r_WTSigns
-- r_WWeeks
DISABLE TRIGGER ALL ON t_Acc; delete  t_Acc; ENABLE  TRIGGER ALL ON t_Acc;
DISABLE TRIGGER ALL ON t_AccD; delete  t_AccD; ENABLE  TRIGGER ALL ON t_AccD;
DISABLE TRIGGER ALL ON t_AccRoutes; delete  t_AccRoutes; ENABLE  TRIGGER ALL ON t_AccRoutes;
DISABLE TRIGGER ALL ON t_AccSpends; delete  t_AccSpends; ENABLE  TRIGGER ALL ON t_AccSpends;
DISABLE TRIGGER ALL ON t_Booking; delete  t_Booking; ENABLE  TRIGGER ALL ON t_Booking;
DISABLE TRIGGER ALL ON t_BookingD; delete  t_BookingD; ENABLE  TRIGGER ALL ON t_BookingD;
DISABLE TRIGGER ALL ON t_BookingTemp; delete  t_BookingTemp; ENABLE  TRIGGER ALL ON t_BookingTemp;
DISABLE TRIGGER ALL ON t_BookingTempD; delete  t_BookingTempD; ENABLE  TRIGGER ALL ON t_BookingTempD;
DISABLE TRIGGER ALL ON t_Cos; delete  t_Cos; ENABLE  TRIGGER ALL ON t_Cos;
DISABLE TRIGGER ALL ON t_CosD; delete  t_CosD; ENABLE  TRIGGER ALL ON t_CosD;
DISABLE TRIGGER ALL ON t_CosSpends; delete  t_CosSpends; ENABLE  TRIGGER ALL ON t_CosSpends;
DISABLE TRIGGER ALL ON t_CRet; delete  t_CRet; ENABLE  TRIGGER ALL ON t_CRet;
DISABLE TRIGGER ALL ON t_CRetD; delete  t_CRetD; ENABLE  TRIGGER ALL ON t_CRetD;
DISABLE TRIGGER ALL ON t_CRetRoutes; delete  t_CRetRoutes; ENABLE  TRIGGER ALL ON t_CRetRoutes;
DISABLE TRIGGER ALL ON t_CRetSpends; delete  t_CRetSpends; ENABLE  TRIGGER ALL ON t_CRetSpends;
DISABLE TRIGGER ALL ON t_CRRet; delete  t_CRRet; ENABLE  TRIGGER ALL ON t_CRRet;
DISABLE TRIGGER ALL ON t_CRRetD; delete  t_CRRetD; ENABLE  TRIGGER ALL ON t_CRRetD;
DISABLE TRIGGER ALL ON t_CRRetDLV; delete  t_CRRetDLV; ENABLE  TRIGGER ALL ON t_CRRetDLV;
DISABLE TRIGGER ALL ON t_CRRetPays; delete  t_CRRetPays; ENABLE  TRIGGER ALL ON t_CRRetPays;
DISABLE TRIGGER ALL ON t_Cst; delete  t_Cst; ENABLE  TRIGGER ALL ON t_Cst;
DISABLE TRIGGER ALL ON t_CstD; delete  t_CstD; ENABLE  TRIGGER ALL ON t_CstD;
DISABLE TRIGGER ALL ON t_CstRoutes; delete  t_CstRoutes; ENABLE  TRIGGER ALL ON t_CstRoutes;
DISABLE TRIGGER ALL ON t_CstSpends; delete  t_CstSpends; ENABLE  TRIGGER ALL ON t_CstSpends;
DISABLE TRIGGER ALL ON t_DeskRes; delete  t_DeskRes; ENABLE  TRIGGER ALL ON t_DeskRes;
DISABLE TRIGGER ALL ON t_DeskResD; delete  t_DeskResD; ENABLE  TRIGGER ALL ON t_DeskResD;
DISABLE TRIGGER ALL ON t_Dis; delete  t_Dis; ENABLE  TRIGGER ALL ON t_Dis;
DISABLE TRIGGER ALL ON t_DisD; delete  t_DisD; ENABLE  TRIGGER ALL ON t_DisD;
DISABLE TRIGGER ALL ON t_DisDD; delete  t_DisDD; ENABLE  TRIGGER ALL ON t_DisDD;
DISABLE TRIGGER ALL ON t_DisRoutes; delete  t_DisRoutes; ENABLE  TRIGGER ALL ON t_DisRoutes;
DISABLE TRIGGER ALL ON t_DisSpends; delete  t_DisSpends; ENABLE  TRIGGER ALL ON t_DisSpends;
DISABLE TRIGGER ALL ON t_EOExp; delete  t_EOExp; ENABLE  TRIGGER ALL ON t_EOExp;
DISABLE TRIGGER ALL ON t_EOExpD; delete  t_EOExpD; ENABLE  TRIGGER ALL ON t_EOExpD;
DISABLE TRIGGER ALL ON t_EOExpDD; delete  t_EOExpDD; ENABLE  TRIGGER ALL ON t_EOExpDD;
DISABLE TRIGGER ALL ON t_EOExpRoutes; delete  t_EOExpRoutes; ENABLE  TRIGGER ALL ON t_EOExpRoutes;
DISABLE TRIGGER ALL ON t_EOExpSpends; delete  t_EOExpSpends; ENABLE  TRIGGER ALL ON t_EOExpSpends;
DISABLE TRIGGER ALL ON t_EORec; delete  t_EORec; ENABLE  TRIGGER ALL ON t_EORec;
DISABLE TRIGGER ALL ON t_EORecD; delete  t_EORecD; ENABLE  TRIGGER ALL ON t_EORecD;
DISABLE TRIGGER ALL ON t_EORecRoutes; delete  t_EORecRoutes; ENABLE  TRIGGER ALL ON t_EORecRoutes;
DISABLE TRIGGER ALL ON t_EORecSpends; delete  t_EORecSpends; ENABLE  TRIGGER ALL ON t_EORecSpends;
TRUNCATE TABLE t_Epp;
TRUNCATE TABLE t_EppD;
DISABLE TRIGGER ALL ON t_EppRoutes; delete  t_EppRoutes; ENABLE  TRIGGER ALL ON t_EppRoutes;
DISABLE TRIGGER ALL ON t_EppSpends; delete  t_EppSpends; ENABLE  TRIGGER ALL ON t_EppSpends;
TRUNCATE TABLE t_Est;
TRUNCATE TABLE t_EstD;
TRUNCATE TABLE t_Exc;
TRUNCATE TABLE t_ExcD;
DISABLE TRIGGER ALL ON t_ExcRoutes; delete  t_ExcRoutes; ENABLE  TRIGGER ALL ON t_ExcRoutes;
DISABLE TRIGGER ALL ON t_ExcSpends; delete  t_ExcSpends; ENABLE  TRIGGER ALL ON t_ExcSpends;
TRUNCATE TABLE t_Exp;
TRUNCATE TABLE t_ExpD;
DISABLE TRIGGER ALL ON t_ExpRoutes; delete  t_ExpRoutes; ENABLE  TRIGGER ALL ON t_ExpRoutes;
DISABLE TRIGGER ALL ON t_ExpSpends; delete  t_ExpSpends; ENABLE  TRIGGER ALL ON t_ExpSpends;
TRUNCATE TABLE t_Inv;
TRUNCATE TABLE t_InvD;
DISABLE TRIGGER ALL ON t_InvRoutes; delete  t_InvRoutes; ENABLE  TRIGGER ALL ON t_InvRoutes;
DISABLE TRIGGER ALL ON t_InvSpends; delete  t_InvSpends; ENABLE  TRIGGER ALL ON t_InvSpends;
DISABLE TRIGGER ALL ON t_IOExp; delete  t_IOExp; ENABLE  TRIGGER ALL ON t_IOExp;
DISABLE TRIGGER ALL ON t_IOExpD; delete  t_IOExpD; ENABLE  TRIGGER ALL ON t_IOExpD;
DISABLE TRIGGER ALL ON t_IOExpRoutes; delete  t_IOExpRoutes; ENABLE  TRIGGER ALL ON t_IOExpRoutes;
DISABLE TRIGGER ALL ON t_IOExpSpends; delete  t_IOExpSpends; ENABLE  TRIGGER ALL ON t_IOExpSpends;
DISABLE TRIGGER ALL ON t_IORec; delete  t_IORec; ENABLE  TRIGGER ALL ON t_IORec;
DISABLE TRIGGER ALL ON t_IORecD; delete  t_IORecD; ENABLE  TRIGGER ALL ON t_IORecD;
DISABLE TRIGGER ALL ON t_IORecRoutes; delete  t_IORecRoutes; ENABLE  TRIGGER ALL ON t_IORecRoutes;
DISABLE TRIGGER ALL ON t_IORecSpends; delete  t_IORecSpends; ENABLE  TRIGGER ALL ON t_IORecSpends;
TRUNCATE TABLE t_MonIntExp;
TRUNCATE TABLE t_MonIntRec;
TRUNCATE TABLE t_MonRec;
DISABLE TRIGGER ALL ON t_PInP; delete t_PInP where PPID <> 0;ENABLE  TRIGGER ALL ON t_PInP; 
DISABLE TRIGGER ALL ON t_PInPCh; delete  t_PInPCh; ENABLE  TRIGGER ALL ON t_PInPCh;
TRUNCATE TABLE t_Rec;
TRUNCATE TABLE t_RecD;
DISABLE TRIGGER ALL ON t_RecRoutes; delete  t_RecRoutes; ENABLE  TRIGGER ALL ON t_RecRoutes;
DISABLE TRIGGER ALL ON t_RecSpends; delete  t_RecSpends; ENABLE  TRIGGER ALL ON t_RecSpends;
TRUNCATE TABLE t_Rem;
DISABLE TRIGGER ALL ON t_RemD; delete  t_RemD; ENABLE  TRIGGER ALL ON t_RemD;
DISABLE TRIGGER ALL ON t_RestShift; delete  t_RestShift; ENABLE  TRIGGER ALL ON t_RestShift;
DISABLE TRIGGER ALL ON t_RestShiftD; delete  t_RestShiftD; ENABLE  TRIGGER ALL ON t_RestShiftD;
DISABLE TRIGGER ALL ON t_Ret; delete  t_Ret; ENABLE  TRIGGER ALL ON t_Ret;
DISABLE TRIGGER ALL ON t_RetD; delete  t_RetD; ENABLE  TRIGGER ALL ON t_RetD;
DISABLE TRIGGER ALL ON t_RetRoutes; delete  t_RetRoutes; ENABLE  TRIGGER ALL ON t_RetRoutes;
DISABLE TRIGGER ALL ON t_RetSpends; delete  t_RetSpends; ENABLE  TRIGGER ALL ON t_RetSpends;
TRUNCATE TABLE t_Sale;
TRUNCATE TABLE t_SaleC;
TRUNCATE TABLE t_SaleD;
TRUNCATE TABLE t_SaleDLV;
TRUNCATE TABLE t_SalePays;
TRUNCATE TABLE t_SaleTemp;
TRUNCATE TABLE t_SaleTempD;
TRUNCATE TABLE t_SaleTempM;
TRUNCATE TABLE t_SaleTempPays;
TRUNCATE TABLE t_SEst;
TRUNCATE TABLE t_SEstD;
TRUNCATE TABLE t_SExp;
TRUNCATE TABLE t_SExpA;
TRUNCATE TABLE t_SExpD;
DISABLE TRIGGER ALL ON t_SExpE; delete  t_SExpE; ENABLE  TRIGGER ALL ON t_SExpE;
DISABLE TRIGGER ALL ON t_SExpM; delete  t_SExpM; ENABLE  TRIGGER ALL ON t_SExpM;
DISABLE TRIGGER ALL ON t_SPExp; delete  t_SPExp; ENABLE  TRIGGER ALL ON t_SPExp;
DISABLE TRIGGER ALL ON t_SPExpA; delete  t_SPExpA; ENABLE  TRIGGER ALL ON t_SPExpA;
DISABLE TRIGGER ALL ON t_SPExpD; delete  t_SPExpD; ENABLE  TRIGGER ALL ON t_SPExpD;
DISABLE TRIGGER ALL ON t_SPExpE; delete  t_SPExpE; ENABLE  TRIGGER ALL ON t_SPExpE;
DISABLE TRIGGER ALL ON t_SPExpM; delete  t_SPExpM; ENABLE  TRIGGER ALL ON t_SPExpM;
DISABLE TRIGGER ALL ON t_SPRec; delete  t_SPRec; ENABLE  TRIGGER ALL ON t_SPRec;
DISABLE TRIGGER ALL ON t_SPRecA; delete  t_SPRecA; ENABLE  TRIGGER ALL ON t_SPRecA;
DISABLE TRIGGER ALL ON t_SPRecD; delete  t_SPRecD; ENABLE  TRIGGER ALL ON t_SPRecD;
DISABLE TRIGGER ALL ON t_SPRecE; delete  t_SPRecE; ENABLE  TRIGGER ALL ON t_SPRecE;
DISABLE TRIGGER ALL ON t_SPRecM; delete  t_SPRecM; ENABLE  TRIGGER ALL ON t_SPRecM;
TRUNCATE TABLE t_SRec;
TRUNCATE TABLE t_SRecA;
TRUNCATE TABLE t_SRecD;
TRUNCATE TABLE t_SRecE;
TRUNCATE TABLE t_SRecM;
TRUNCATE TABLE t_Ven;
TRUNCATE TABLE t_VenA;
TRUNCATE TABLE t_VenD;
TRUNCATE TABLE t_VenD_UM;
TRUNCATE TABLE t_VenRoutes;
TRUNCATE TABLE t_VenSpends;
TRUNCATE TABLE t_zInP;
TRUNCATE TABLE t_zRep;
-- v_Databases
-- v_Fields
-- v_Formulas
-- v_Graphs
-- v_Joins
-- v_MapSG
-- v_Notify
-- v_Params
-- v_RepGrs
-- v_Replace
-- v_Reps
-- v_RepUsers
-- v_Scripts
-- v_SourceGrs
-- v_Sources
-- v_Tables
-- v_UFields
-- v_UGraphs
-- v_UNotify
-- v_UParams
-- v_UReps
-- v_UScripts
-- v_UViewFields
-- v_UViews
-- v_Valids
-- v_ViewFields
-- v_Views
-- z_AccDefDocs
-- z_AccDefObjects
-- z_AccDefs
-- z_AccDefTables
-- z_AppDocs
-- z_AppPrints
-- z_AppRoles
-- z_Apps
-- z_AppUsers
-- z_AUFields
-- z_AUGroups
-- z_AUTables
-- z_AutoUpdate
-- z_AzRoleReps
-- z_AzRoles
-- z_AzRoleUsers
-- z_AzValids
-- z_BarMask
-- z_Contracts
-- z_DatasetFields
-- z_DatasetLinks
-- z_DataSets
-- z_DocCats
TRUNCATE TABLE z_DocDC;
-- z_DocForms
-- z_DocGrps
TRUNCATE TABLE z_DocLinks;
-- z_DocLinks_Tax
-- z_DocLinkTypes
-- z_DocPrints
-- z_DocRoles
-- z_Docs
-- z_DocShed
-- z_DocUsers
-- z_Fields
-- z_FieldsRep
-- z_FieldsRepGrps
-- z_FRUDFR
-- z_FRUDFRD
-- z_FRUDFs
-- z_InAcc
-- z_Licenses
-- z_LogAU
-- z_LogCashReg
TRUNCATE TABLE z_LogCreate;
TRUNCATE TABLE z_LogDelete;
TRUNCATE TABLE z_LogDiscExp;
TRUNCATE TABLE z_LogDiscRec;
-- z_LogDiscRecTemp
-- z_LogMetrics
TRUNCATE TABLE z_LogPrint;
-- z_LogProcessingExchange
-- z_LogProcessings
TRUNCATE TABLE z_LogScale;
TRUNCATE TABLE z_LogState;
-- z_LogTools
TRUNCATE TABLE z_LogUpdate;
-- z_Lookups
-- z_MetricaEvents
-- z_Objects
-- z_OpenAge
-- z_OpenAgeH
-- z_Relations
-- z_ReplicaConfigEvents
-- z_ReplicaConfigIn
-- z_ReplicaConfigOut
-- z_ReplicaConfigSent
TRUNCATE TABLE z_ReplicaEvents;
-- z_ReplicaFields
-- z_ReplicaFilters
TRUNCATE TABLE z_ReplicaIn;
TRUNCATE TABLE z_ReplicaOut;
-- z_ReplicaPCs
-- z_ReplicaPubs
-- z_ReplicaReplace
-- z_ReplicaSubs
-- z_ReplicaTables
-- z_RoleDocs
-- z_RoleObjects
-- z_Roles
-- z_RoleTables
-- z_RoleUsers
-- z_Tables
-- z_ToolApps
-- z_ToolDocs
-- z_ToolFields
-- z_ToolPages
-- z_ToolRep
-- z_Tools
-- z_ToolUserEvents
-- z_UserCodes1
-- z_UserCodes2
-- z_UserCodes3
-- z_UserCodes4
-- z_UserCodes5
-- z_UserCompG
-- z_UserComps
-- z_UserDocs
-- z_UserObjects
-- z_UserOpenAge
-- z_UserOpenAgeH
-- z_UserOurs
-- z_UserPLs
-- z_UserProdC
-- z_UserProdG
-- z_UserProdG1
-- z_UserStockGs
-- z_UserStocks
-- z_UserTables
-- z_UserVars
-- z_VarPages
-- z_Vars
-- z_WCopy
-- z_WCopyD
-- z_WCopyDF
-- z_WCopyDV
-- z_WCopyF
-- z_WCopyFF
-- z_WCopyFUF
-- z_WCopyFV
-- z_WCopyFVUF
-- z_WCopyP
-- z_WCopyT
-- z_WCopyU
-- z_WCopyUV



