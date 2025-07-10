--BEGIN TRAN;

TRUNCATE TABLE	ElitR_316.dbo.r_UniTypes
TRUNCATE TABLE	ElitR_316.dbo.r_Uni
TRUNCATE TABLE	ElitR_316.dbo.r_Currs
TRUNCATE TABLE	ElitR_316.dbo.r_Ours
TRUNCATE TABLE	ElitR_316.dbo.r_OursCC
TRUNCATE TABLE	ElitR_316.dbo.r_OursAC
TRUNCATE TABLE	ElitR_316.dbo.r_OurValues
TRUNCATE TABLE	ElitR_316.dbo.r_Deps
TRUNCATE TABLE	ElitR_316.dbo.r_Emps;
DISABLE TRIGGER ALL ON ElitR_316.dbo.r_Users; DISABLE TRIGGER ALL ON ElitR_316.dbo.z_DataSets; ALTER TABLE ElitR_316.[dbo].[r_StateRuleUsers]  NOCHECK  CONSTRAINT [FK_r_StateRuleUsers_r_Users]; ALTER TABLE ElitR_316.[dbo].[z_LogState]  NOCHECK  CONSTRAINT [FK_z_LogState_r_Users]; delete  ElitR_316.dbo.r_Users; ALTER TABLE ElitR_316.[dbo].[r_StateRuleUsers]  CHECK  CONSTRAINT [FK_r_StateRuleUsers_r_Users]; ALTER TABLE ElitR_316.[dbo].[z_LogState]  CHECK  CONSTRAINT [FK_z_LogState_r_Users]; ENABLE  TRIGGER ALL ON ElitR_316.dbo.z_DataSets; ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_Users;

TRUNCATE TABLE	ElitR_316.dbo.r_Codes1
TRUNCATE TABLE	ElitR_316.dbo.r_Codes2
TRUNCATE TABLE	ElitR_316.dbo.r_Codes3
TRUNCATE TABLE	ElitR_316.dbo.r_Codes4
TRUNCATE TABLE	ElitR_316.dbo.r_Codes5
TRUNCATE TABLE	ElitR_316.dbo.r_PLs
TRUNCATE TABLE	ElitR_316.dbo.ir_PLProdGrs
TRUNCATE TABLE	ElitR_316.dbo.r_Spends
TRUNCATE TABLE	ElitR_316.dbo.r_States
TRUNCATE TABLE	ElitR_316.dbo.r_StateRules

TRUNCATE TABLE	ElitR_316.dbo.r_StateRuleUsers
TRUNCATE TABLE	ElitR_316.dbo.r_StateDocs
TRUNCATE TABLE	ElitR_316.dbo.r_StateDocsChange
TRUNCATE TABLE	ElitR_316.dbo.r_CompGrs1
TRUNCATE TABLE	ElitR_316.dbo.r_CompGrs2
TRUNCATE TABLE	ElitR_316.dbo.r_CompGrs3
TRUNCATE TABLE	ElitR_316.dbo.r_CompGrs4
TRUNCATE TABLE	ElitR_316.dbo.r_CompGrs5;
DISABLE TRIGGER ALL ON ElitR_316.dbo.r_Comps; delete  ElitR_316.dbo.r_Comps; ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_Comps;
TRUNCATE TABLE	ElitR_316.dbo.r_CompsAC

TRUNCATE TABLE	ElitR_316.dbo.r_CompsCC
TRUNCATE TABLE	ElitR_316.dbo.r_CompsAdd
TRUNCATE TABLE	ElitR_316.dbo.r_CompValues
TRUNCATE TABLE	ElitR_316.dbo.r_CompContacts
TRUNCATE TABLE	ElitR_316.dbo.r_StockGs
TRUNCATE TABLE	ElitR_316.dbo.r_Stocks
TRUNCATE TABLE	ElitR_316.dbo.r_StockCRProds
TRUNCATE TABLE	ElitR_316.dbo.ir_StockSubs
TRUNCATE TABLE	ElitR_316.dbo.ir_StockFilters
TRUNCATE TABLE	ElitR_316.dbo.r_ProdC

TRUNCATE TABLE	ElitR_316.dbo.r_ProdG
TRUNCATE TABLE	ElitR_316.dbo.r_ProdG1
TRUNCATE TABLE	ElitR_316.dbo.r_ProdG2
TRUNCATE TABLE	ElitR_316.dbo.r_ProdG3
TRUNCATE TABLE	ElitR_316.dbo.r_ProdA
TRUNCATE TABLE	ElitR_316.dbo.r_ProdBG;
DISABLE TRIGGER ALL ON ElitR_316.dbo.r_Prods; delete  ElitR_316.dbo.r_Prods; ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_Prods;
TRUNCATE TABLE	ElitR_316.dbo.t_PInP
TRUNCATE TABLE	ElitR_316.dbo.r_ProdMQ
TRUNCATE TABLE	ElitR_316.dbo.r_ProdMP

TRUNCATE TABLE	ElitR_316.dbo.r_ProdMA
TRUNCATE TABLE	ElitR_316.dbo.r_ProdMS
TRUNCATE TABLE	ElitR_316.dbo.r_ProdME
TRUNCATE TABLE	ElitR_316.dbo.r_ProdAC
TRUNCATE TABLE	ElitR_316.dbo.r_ProdEC
TRUNCATE TABLE	ElitR_316.dbo.r_ProdCV
TRUNCATE TABLE	ElitR_316.dbo.r_ProdMSE
TRUNCATE TABLE	ElitR_316.dbo.r_ProdValues
TRUNCATE TABLE	ElitR_316.dbo.r_ProdLV
TRUNCATE TABLE	ElitR_316.dbo.ir_ProdMPA

TRUNCATE TABLE	ElitR_316.dbo.ir_ProdOpers
TRUNCATE TABLE	ElitR_316.dbo.r_DCTypeG;
DISABLE TRIGGER ALL ON ElitR_316.dbo.r_DCTypes; delete  ElitR_316.dbo.r_DCTypes; ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_DCTypes;
ALTER TABLE ElitR_316.[dbo].[z_LogDiscExp]  NOCHECK  CONSTRAINT [FK_z_LogDiscExp_r_DCards]; ALTER TABLE ElitR_316.[dbo].[z_LogDiscRec]  NOCHECK  CONSTRAINT [FK_z_LogDiscRec_r_DCards]; ALTER TABLE ElitR_316.[dbo].[z_DocDC]  NOCHECK  CONSTRAINT [FK_z_DocDC_r_DCards]; delete ElitR_316.dbo.r_DCards; ALTER TABLE ElitR_316.[dbo].[z_DocDC]  CHECK  CONSTRAINT [FK_z_DocDC_r_DCards]; ALTER TABLE ElitR_316.[dbo].[z_LogDiscRec]  CHECK  CONSTRAINT [FK_z_LogDiscRec_r_DCards]; ALTER TABLE ElitR_316.[dbo].[z_LogDiscExp]  CHECK  CONSTRAINT [FK_z_LogDiscExp_r_DCards];  
TRUNCATE TABLE	ElitR_316.dbo.r_PayForms;
DISABLE TRIGGER ALL ON ElitR_316.dbo.r_CRs; delete  ElitR_316.dbo.r_CRs; ENABLE  TRIGGER ALL ON ElitR_316.dbo.r_CRs;
TRUNCATE TABLE	ElitR_316.dbo.r_CRMP
TRUNCATE TABLE	ElitR_316.dbo.r_CRMM
TRUNCATE TABLE	ElitR_316.dbo.r_CRDeskG
TRUNCATE TABLE	ElitR_316.dbo.r_CRShed

TRUNCATE TABLE	ElitR_316.dbo.r_Opers
TRUNCATE TABLE	ElitR_316.dbo.r_OperCRs
TRUNCATE TABLE	ElitR_316.dbo.r_CRUniInput
TRUNCATE TABLE	ElitR_316.dbo.r_POSPays
TRUNCATE TABLE	ElitR_316.dbo.r_CRPOSPays
TRUNCATE TABLE	ElitR_316.dbo.r_Taxes
TRUNCATE TABLE	ElitR_316.dbo.r_TaxRates
TRUNCATE TABLE	ElitR_316.dbo.r_Levies
TRUNCATE TABLE	ElitR_316.dbo.r_LevyRates
TRUNCATE TABLE	ElitR_316.dbo.r_LevyCR

TRUNCATE TABLE	ElitR_316.dbo.at_r_ProdsAmort
TRUNCATE TABLE	ElitR_316.dbo.at_r_Regions
TRUNCATE TABLE	ElitR_316.dbo.at_r_ProdG4;
TRUNCATE TABLE	ElitR_316.dbo.at_r_ProdG5
TRUNCATE TABLE	ElitR_316.dbo.at_r_ProdG6
TRUNCATE TABLE	ElitR_316.dbo.at_r_ProdG7
TRUNCATE TABLE  ElitR_316.dbo.r_Banks
TRUNCATE TABLE	ElitR_316.dbo.ir_OperTypes;

delete ElitR_316.dbo.r_DiscChargeD where DiscCode <> 124;
delete ElitR_316.dbo.r_DiscChargeDT where DiscCode <> 124;
delete ElitR_316.dbo.r_DiscDC where DiscCode <> 124;
delete ElitR_316.dbo.r_DiscMessages where DiscCode <> 124;
delete ElitR_316.dbo.r_DiscMessagesT where DiscCode <> 124;
ALTER TABLE ElitR_316.[dbo].[z_LogDiscExp]  NOCHECK  CONSTRAINT [FK_z_LogDiscExp_r_Discs]; ALTER TABLE ElitR_316.[dbo].[z_LogDiscRec]  NOCHECK  CONSTRAINT [FK_z_LogDiscRec_r_Discs]; delete  ElitR_316.dbo.r_Discs where DiscCode <> 124; ALTER TABLE ElitR_316.[dbo].[z_LogDiscExp]  CHECK  CONSTRAINT [FK_z_LogDiscExp_r_Discs]; ALTER TABLE ElitR_316.[dbo].[z_LogDiscRec]  CHECK  CONSTRAINT [FK_z_LogDiscRec_r_Discs];
delete ElitR_316.dbo.r_DiscSale where DiscCode <> 124;
delete ElitR_316.dbo.r_DiscSaleBonus where DiscCode <> 124;
delete ElitR_316.dbo.r_DiscSaleD where DiscCode <> 124;
delete ElitR_316.dbo.r_DiscSaleDBonus where DiscCode <> 124;

delete ElitR_316.dbo.r_DiscSaleDT where DiscCode <> 124;
delete ElitR_316.dbo.r_DiscSaleT where DiscCode <> 124;
delete ElitR_316.dbo.r_DiscsT where DiscCode <> 124;




TRUNCATE TABLE	ElitR_316.dbo.z_LogDiscRec
TRUNCATE TABLE	ElitR_316.dbo.z_DocDC
TRUNCATE TABLE	ElitR_316.dbo.t_CRRet
TRUNCATE TABLE	ElitR_316.dbo.z_LogDiscExp
TRUNCATE TABLE	ElitR_316.dbo.t_CRRetD
TRUNCATE TABLE	ElitR_316.dbo.t_CRRetDLV
TRUNCATE TABLE	ElitR_316.dbo.t_CRRetPays
TRUNCATE TABLE	ElitR_316.dbo.t_MonIntExp
TRUNCATE TABLE	ElitR_316.dbo.t_MonIntRec
TRUNCATE TABLE	ElitR_316.dbo.t_MonRec

TRUNCATE TABLE	ElitR_316.dbo.t_Sale
TRUNCATE TABLE	ElitR_316.dbo.t_SaleC
TRUNCATE TABLE	ElitR_316.dbo.t_SaleD
TRUNCATE TABLE	ElitR_316.dbo.t_SaleDLV
TRUNCATE TABLE	ElitR_316.dbo.t_SalePays
TRUNCATE TABLE	ElitR_316.dbo.t_zRep


--ROLLBACK TRAN;