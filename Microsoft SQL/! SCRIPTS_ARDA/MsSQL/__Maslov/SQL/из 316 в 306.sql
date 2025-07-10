select * from ElitR_316.dbo.z_Tables m where m.TableCode in (select m1.TableCode from ElitR_316.dbo.z_ReplicaTables m1 where m1.ReplicaPubCode <> 1500000000)
order by m.TableCode

select * from ElitR_306.dbo.z_Tables m2 --where m2.TableCode in (select m1.TableCode from ElitR_306.dbo.z_ReplicaTables)
order by m2.TableCode


-- z_LogDiscRec tabel
BEGIN TRAN;
DISABLE TRIGGER ALL ON ElitR_306.dbo.z_LogDiscRec; 

ALTER TABLE [dbo].[z_LogDiscRec]  NOCHECK  CONSTRAINT [FK_z_LogDiscRec_r_Discs];

Insert ElitR_306.dbo.z_LogDiscRec (LogID,TempBonus,DocCode,ChID,SrcPosID,DiscCode,SumBonus,LogDate,BonusType,SaleSrcPosID,DBiID,DCardID)
select LogID,TempBonus,DocCode,ChID,SrcPosID,DiscCode,SumBonus,LogDate,BonusType,SaleSrcPosID,DBiID,DCardChID
from ElitR_316.dbo.z_LogDiscRec  ;

select * from ElitR_316.dbo.r_CRDeskG;
select * from ElitR_306.dbo.r_CRDeskG;

ALTER TABLE [dbo].[z_LogDiscRec]  CHECK  CONSTRAINT [FK_z_LogDiscRec_r_Discs];

ENABLE  TRIGGER ALL ON ElitR_306.dbo.z_LogDiscRec;
ROLLBACK TRAN;
-- end z_LogDiscRec table


-- z_DocDC tabel
BEGIN TRAN;
DISABLE TRIGGER ALL ON ElitR_306.dbo.z_DocDC; 

Insert ElitR_306.dbo.z_DocDC ([DocCode],[ChID],[DCardID])
select [DocCode],[ChID],[DCardChID] from ElitR_316.dbo.z_DocDC dc where dc.DocCode = 1011 ;

select * from ElitR_306.dbo.z_DocDC;

ENABLE  TRIGGER ALL ON ElitR_306.dbo.z_DocDC;
ROLLBACK TRAN;
-- end z_DocDC table


-- t_CRRet table
-- two rows from 316 absent in 306
BEGIN TRAN;
DISABLE TRIGGER ALL ON ElitR_306.dbo.t_CRRet; 

--Insert ElitR_306.dbo.t_CRRet (ChID, DocID, IntDocID, DocDate, KursMC, OurID, StockID, CompID, CRID, OperID, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, EmpID, Notes, Discount, CreditID, DCardID, SrcDocID, SrcDocDate, CurrID, TSumCC_nt, TTaxSum, TSumCC_wt, StateCode, DocTime, TaxDocID, TaxDocDate, DepID, ClientID, InDocID, DeclNum, DeclDate, DeskCode, BLineID, TRealSum, TLevySum, RemSChId)
--select ChID, DocID, IntDocID, DocDate, KursMC, OurID, StockID, CompID, CRID, OperID, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, EmpID, Notes, Discount, CreditID, ISNULL(DCardID,'<Нет дисконтной карты>'), SrcDocID, SrcDocDate, CurrID, TSumCC_nt, TTaxSum, TSumCC_wt, StateCode, DocTime, TaxDocID, TaxDocDate, DepID, ClientID, InDocID, DeclNum, DeclDate, DeskCode, BLineID, TRealSum, TLevySum, RemSChId
--from ElitR_316.dbo.t_CRRet  ;

insert ElitR_306.dbo.t_CRRet(ChID,DocID,IntDocID,DocDate,KursMC,OurID,StockID,CompID,CRID,OperID,CodeID1,CodeID2,CodeID3,CodeID4,CodeID5,EmpID,Notes,Discount,CreditID,DCardID,SrcDocID,SrcDocDate,CurrID,TSumCC_nt,TTaxSum,TSumCC_wt,StateCode,DocTime,TaxDocID,TaxDocDate,DepID,ClientID,InDocID,DeclNum,DeclDate,DeskCode,BLineID,TRealSum,TLevySum,RemSChId) select ChID, DocID, IntDocID, DocDate, KursMC, OurID, StockID, CompID, CRID, OperID, CodeID1, CodeID2, CodeID3, CodeID4, CodeID5, EmpID, Notes, Discount, CreditID, ISNULL(DCardID,'<Нет дисконтной карты>'), SrcDocID, SrcDocDate, CurrID, TSumCC_nt, TTaxSum, TSumCC_wt, StateCode, DocTime, TaxDocID, TaxDocDate, DepID, ClientID, InDocID, DeclNum, DeclDate, DeskCode, BLineID, TRealSum, TLevySum, RemSChId from ElitR_316.dbo.t_CRRet;


select * from ElitR_306.dbo.t_CRRet;

ENABLE  TRIGGER ALL ON ElitR_306.dbo.t_CRRet;
ROLLBACK TRAN;
-- end t_CRRet table

-- z_LogDiscExp table
BEGIN TRAN;
DISABLE TRIGGER ALL ON ElitR_306.dbo.z_LogDiscExp; 

ALTER TABLE [dbo].[z_LogDiscExp]  NOCHECK  CONSTRAINT [FK_z_LogDiscExp_r_Discs];

Insert ElitR_306.dbo.z_LogDiscExp (BonusType,ChID,DBiID,DCardID,DiscCode,Discount,DocCode,GroupDiscount,GroupSumBonus,LogDate,LogID,SrcPosID,SumBonus,TempBonus)
select BonusType,ChID,DBiID,DCardChID,DiscCode,Discount,DocCode,GroupDiscount,GroupSumBonus,LogDate,LogID,SrcPosID,SumBonus,TempBonus
from ElitR_316.dbo.z_LogDiscExp  ;

select * from ElitR_306.dbo.z_LogDiscExp;

ALTER TABLE [dbo].[z_LogDiscExp]  CHECK  CONSTRAINT [FK_z_LogDiscExp_r_Discs];

ENABLE  TRIGGER ALL ON ElitR_306.dbo.z_LogDiscExp;
ROLLBACK TRAN;
-- end z_LogDiscExp table


-- t_CRRetD table
-- one row from 316 absent in 306
BEGIN TRAN;
DISABLE TRIGGER ALL ON ElitR_306.dbo.t_CRRetD; 

Insert ElitR_306.dbo.t_CRRetD (BarCode,ChID,CreateTime,EmpID,ModifyTime,PPID,PriceCC_nt,PriceCC_wt,ProdID,Qty,RealPrice,RealSum,SaleSrcPosID,SecID,SrcPosID,SumCC_nt,SumCC_wt,Tax,TaxSum,TaxTypeID,UM)
select BarCode,ChID,CreateTime,EmpID,ModifyTime,PPID,PriceCC_nt,PriceCC_wt,ProdID,Qty,RealPrice,RealSum,SaleSrcPosID,SecID,SrcPosID,SumCC_nt,SumCC_wt,Tax,TaxSum,TaxTypeID,UM
from ElitR_316.dbo.t_CRRetD ;

select * from ElitR_306.dbo.t_CRRetD;

ENABLE  TRIGGER ALL ON ElitR_306.dbo.t_CRRetD;
ROLLBACK TRAN;
-- end t_CRRet table


-- t_CRRetDLV table
BEGIN TRAN;
DISABLE TRIGGER ALL ON ElitR_306.dbo.t_CRRetDLV; 

Insert ElitR_306.dbo.t_CRRetDLV (ChID,LevyID,LevySum,SrcPosID)
select ChID,LevyID,LevySum,SrcPosID
from ElitR_316.dbo.t_CRRetDLV ;

select * from ElitR_306.dbo.t_CRRetDLV;

ENABLE  TRIGGER ALL ON ElitR_306.dbo.t_CRRetDLV;
ROLLBACK TRAN;
-- end t_CRRetDLV table


-- t_CRRetPays table
-- four rows from 316(BServID,ChequeText,POSPayText,PrintState) absent in 306
BEGIN TRAN;
DISABLE TRIGGER ALL ON ElitR_306.dbo.t_CRRetPays; 

Insert ElitR_306.dbo.t_CRRetPays (ChID,Notes,PayFormCode,POSPayDocID,POSPayID,POSPayRRN,SrcPayPosID,SrcPosID,SumCC_wt)
select ChID,Notes,PayFormCode,POSPayDocID,POSPayID,POSPayRRN,SrcPayPosID,SrcPosID,SumCC_wt
from ElitR_316.dbo.t_CRRetPays ;

select * from ElitR_306.dbo.t_CRRetPays;

ENABLE  TRIGGER ALL ON ElitR_306.dbo.t_CRRetPays;
ROLLBACK TRAN;
-- end t_CRRetPays table


-- t_MonIntExp table
BEGIN TRAN;
DISABLE TRIGGER ALL ON ElitR_306.dbo.t_MonIntExp; 

Insert ElitR_306.dbo.t_MonIntExp (ChID,OurID,CRID,DocDate,DocTime,CodeID1,CodeID2,CodeID3,CodeID4,CodeID5,SumCC,Notes,OperID,StateCode,DocID,IntDocID)
select ChID,OurID,CRID,DocDate,DocTime,CodeID1,CodeID2,CodeID3,CodeID4,CodeID5,SumCC,Notes,OperID,StateCode,DocID,IntDocID
from ElitR_316.dbo.t_MonIntExp ;

select * from ElitR_306.dbo.t_MonIntExp;

ENABLE  TRIGGER ALL ON ElitR_306.dbo.t_MonIntExp;
ROLLBACK TRAN;
-- end t_MonIntExp table


-- t_MonIntRec table
BEGIN TRAN;
DISABLE TRIGGER ALL ON ElitR_306.dbo.t_MonIntRec; 

Insert ElitR_306.dbo.t_MonIntRec (ChID,OurID,CRID,DocDate,DocTime,CodeID1,CodeID2,CodeID3,CodeID4,CodeID5,SumCC,Notes,OperID,StateCode,DocID,IntDocID)
select ChID,OurID,CRID,DocDate,DocTime,CodeID1,CodeID2,CodeID3,CodeID4,CodeID5,SumCC,Notes,OperID,StateCode,DocID,IntDocID
from ElitR_316.dbo.t_MonIntRec ;

select * from ElitR_306.dbo.t_MonIntRec;

ENABLE  TRIGGER ALL ON ElitR_306.dbo.t_MonIntRec;
ROLLBACK TRAN;
-- end t_MonIntRec table



-- t_MonRec table
BEGIN TRAN;
DISABLE TRIGGER ALL ON ElitR_306.dbo.t_MonRec; 

Insert ElitR_306.dbo.t_MonRec (ChID,OurID,AccountAC,DocDate,DocID,StockID,CompID,CompAccountAC,CurrID,KursMC,KursCC,SumAC,Subject,CodeID1,CodeID2,CodeID3,CodeID4,CodeID5,EmpID,StateCode,DepID)
select ChID,OurID,AccountAC,DocDate,DocID,StockID,CompID,CompAccountAC,CurrID,KursMC,KursCC,SumAC,Subject,CodeID1,CodeID2,CodeID3,CodeID4,CodeID5,EmpID,StateCode,DepID
from ElitR_316.dbo.t_MonRec ;

select * from ElitR_306.dbo.t_MonRec;

ENABLE  TRIGGER ALL ON ElitR_306.dbo.t_MonRec;
ROLLBACK TRAN;
-- end t_MonRec table


-- t_Sale table
-- two rows from 316(WPID,DCardChID) absent in 306
BEGIN TRAN;
DISABLE TRIGGER ALL ON ElitR_306.dbo.t_Sale; 

Insert ElitR_306.dbo.t_Sale (ChID,DocID,DocDate,KursMC,OurID,StockID,CompID,CodeID1,CodeID2,CodeID3,CodeID4,CodeID5,Discount,Notes,CRID,OperID,CreditID,DocTime,TaxDocID,TaxDocDate,DCardID,EmpID,IntDocID,CashSumCC,ChangeSumCC,CurrID,TSumCC_nt,TTaxSum,TSumCC_wt,StateCode,DeskCode,Visitors,TPurSumCC_nt,TPurTaxSum,TPurSumCC_wt,DocCreateTime,DepID,ClientID,InDocID,ExpTime,DeclNum,DeclDate,BLineID,TRealSum,TLevySum,RemSChId)
select ChID,DocID,DocDate,KursMC,OurID,StockID,CompID,CodeID1,CodeID2,CodeID3,CodeID4,CodeID5,Discount,Notes,CRID,OperID,CreditID,DocTime,TaxDocID,TaxDocDate,DCardID,EmpID,IntDocID,CashSumCC,ChangeSumCC,CurrID,TSumCC_nt,TTaxSum,TSumCC_wt,StateCode,DeskCode,Visitors,TPurSumCC_nt,TPurTaxSum,TPurSumCC_wt,DocCreateTime,DepID,ClientID,InDocID,ExpTime,DeclNum,DeclDate,BLineID,TRealSum,TLevySum,RemSChId
from ElitR_316.dbo.t_Sale ;

select * from ElitR_306.dbo.t_Sale;

ENABLE  TRIGGER ALL ON ElitR_306.dbo.t_Sale;
ROLLBACK TRAN;
-- end t_Sale table


-- t_SaleC table
BEGIN TRAN;
DISABLE TRIGGER ALL ON ElitR_306.dbo.t_SaleC; 

Insert ElitR_306.dbo.t_SaleC (ChID,SrcPosID,ProdID,UM,Qty,PriceCC_nt,SumCC_nt,Tax,TaxSum,PriceCC_wt,SumCC_wt,BarCode,CReasonID,EmpID,CreateTime,ModifyTime)
select ChID,SrcPosID,ProdID,UM,Qty,PriceCC_nt,SumCC_nt,Tax,TaxSum,PriceCC_wt,SumCC_wt,BarCode,CReasonID,EmpID,CreateTime,ModifyTime
from ElitR_316.dbo.t_SaleC ;

select * from ElitR_306.dbo.t_SaleC;

ENABLE  TRIGGER ALL ON ElitR_306.dbo.t_SaleC;
ROLLBACK TRAN;
-- end t_SaleC table


-- t_SaleD table
BEGIN TRAN;
DISABLE TRIGGER ALL ON ElitR_306.dbo.t_SaleD; 

Insert ElitR_306.dbo.t_SaleD (ChID,SrcPosID,ProdID,PPID,UM,Qty,PriceCC_nt,SumCC_nt,Tax,TaxSum,PriceCC_wt,SumCC_wt,BarCode,SecID,PurPriceCC_nt,PurTax,PurPriceCC_wt,PLID,Discount,DepID,IsFiscal,SubStockID,OutQty,EmpID,CreateTime,ModifyTime,TaxTypeID,RealPrice,RealSum)
select ChID,SrcPosID,ProdID,PPID,UM,Qty,PriceCC_nt,SumCC_nt,Tax,TaxSum,PriceCC_wt,SumCC_wt,BarCode,SecID,PurPriceCC_nt,PurTax,PurPriceCC_wt,PLID,Discount,DepID,IsFiscal,SubStockID,OutQty,EmpID,CreateTime,ModifyTime,TaxTypeID,RealPrice,RealSum
from ElitR_316.dbo.t_SaleD ;

select * from ElitR_306.dbo.t_SaleD;

ENABLE  TRIGGER ALL ON ElitR_306.dbo.t_SaleD;
ROLLBACK TRAN;
-- end t_SaleD table


-- t_SaleDLV table
BEGIN TRAN;
DISABLE TRIGGER ALL ON ElitR_306.dbo.t_SaleDLV; 

Insert ElitR_306.dbo.t_SaleDLV (ChID,SrcPosID,LevyID,LevySum)
select ChID,SrcPosID,LevyID,LevySum
from ElitR_316.dbo.t_SaleDLV ;

select * from ElitR_306.dbo.t_SaleDLV;

ENABLE  TRIGGER ALL ON ElitR_306.dbo.t_SaleDLV;
ROLLBACK TRAN;
-- end t_SaleDLV table


-- t_SalePays table
-- five rows from 316(ChequeText,BServID,PayPartsQty,ContractNo,POSPayText) absent in 306
BEGIN TRAN;
DISABLE TRIGGER ALL ON ElitR_306.dbo.t_SalePays; 

Insert ElitR_306.dbo.t_SalePays (ChID,SrcPosID,PayFormCode,SumCC_wt,Notes,POSPayID,POSPayDocID,POSPayRRN,IsFiscal)
select ChID,SrcPosID,PayFormCode,SumCC_wt,Notes,POSPayID,POSPayDocID,POSPayRRN,IsFiscal
from ElitR_316.dbo.t_SalePays ;

select * from ElitR_306.dbo.t_SalePays;

ENABLE  TRIGGER ALL ON ElitR_306.dbo.t_SalePays;
ROLLBACK TRAN;
-- end t_SalePays table


-- t_zRep table
-- five rows from 316(ChequeText,BServID,PayPartsQty,ContractNo,POSPayText) absent in 306
BEGIN TRAN;
DISABLE TRIGGER ALL ON ElitR_306.dbo.t_zRep; 

Insert ElitR_306.dbo.t_zRep (ChID,DocDate,DocTime,CRID,OperID,OurID,DocID,FacID,FinID,ZRepNum,SumCC_wt,Sum_A,Sum_B,Sum_C,Sum_D,RetSum_A,RetSum_B,RetSum_C,RetSum_D,SumCash,SumCard,SumCredit,SumCheque,SumOther,RetSumCash,RetSumCard,RetSumCredit,RetSumCheque,RetSumOther,SumMonRec,SumMonExp,SumRem,Notes,Sum_E,Sum_F,RetSum_E,RetSum_F,Tax_A,Tax_B,Tax_C,Tax_D,Tax_E,Tax_F,RetTax_A,RetTax_B,RetTax_C,RetTax_D,RetTax_E,RetTax_F)
select ChID,DocDate,DocTime,CRID,OperID,OurID,DocID,FacID,FinID,ZRepNum,SumCC_wt,Sum_A,Sum_B,Sum_C,Sum_D,RetSum_A,RetSum_B,RetSum_C,RetSum_D,SumCash,SumCard,SumCredit,SumCheque,SumOther,RetSumCash,RetSumCard,RetSumCredit,RetSumCheque,RetSumOther,SumMonRec,SumMonExp,SumRem,Notes,Sum_E,Sum_F,RetSum_E,RetSum_F,Tax_A,Tax_B,Tax_C,Tax_D,Tax_E,Tax_F,RetTax_A,RetTax_B,RetTax_C,RetTax_D,RetTax_E,RetTax_F
from ElitR_316.dbo.t_zRep ;

select * from ElitR_306.dbo.t_zRep;

ENABLE  TRIGGER ALL ON ElitR_306.dbo.t_zRep;
ROLLBACK TRAN;
-- end t_zRep table


select LogID, TempBonus, DocCode, ChID, SrcPosID, DiscCode, SumBonus, LogDate, BonusType, SaleSrcPosID, DBiID, DCardID
 from ElitR_306.dbo.z_LogDiscRec
select LogID, TempBonus, DocCode, ChID, SrcPosID, DiscCode, SumBonus, LogDate, BonusType, SaleSrcPosID, DBiID, DCardChID
 from ElitR_316.dbo.z_LogDiscRec


select * from ElitR_306.dbo.r_Prods
select * from ElitR_316.dbo.r_Banks

select distinct COLUMN_NAME,DATA_TYPE,IS_NULLABLE from ElitR_306.INFORMATION_SCHEMA.COLUMNS order by 1;

select COLUMN_NAME,DATA_TYPE,IS_NULLABLE from ElitR_306.INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'r_Banks';
select COLUMN_NAME,DATA_TYPE,IS_NULLABLE from INFORMATION_SCHEMA.COLUMNS

select * from ElitR_316.dbo.z_LogDiscExp where DiscCode = 124;
select TABLE_NAME from ElitR_306.INFORMATION_SCHEMA.COLUMNS where COLUMN_NAME = 'DiscCode';
BEGIN TRAN;
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

select * from ElitR_316.dbo.r_DiscChargeD;
ROLLBACK TRAN;



select * from dbo.z_ReplicaTables m where m.ReplicaPubCode = 1500000000

select * from dbo.z_ReplicaTables

select 'TRUNCATE TABLE',TableName from ElitR_316.dbo.z_Tables m where m.TableCode in (select m1.TableCode from ElitR_316.dbo.z_ReplicaTables m1 where m1.ReplicaPubCode <> 1500000000)
order by m.TableCode

declare @counter int;
set @counter = 3;
while @counter < 109
begin
select 'A'+@counter+'&", "&';
set @counter += 1;
end

select distinct * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 't_CRet';
select * from Elit.dbo.z_Tables m where m.TableName = 't_Rec ';
select * from at_t_IORes
SELECT * FROM av_t_IORes

update r_users 
set UserName = 'VINTAGE-VM1\tester'
where UserName = 'tester'

select * from r_users where UserName = 'tester'

DECLARE @BDate smalldatetime, @EDate smalldatetime;
  IF @BDate IS NULL SET @BDate = '1900-01-01'
  IF @EDate IS NULL SET @EDate = '2079-06-06'
  
    SELECT m.OurID, m.StockID, d.SecID, d.ProdID, d.PPID, SUM(d.Qty) Qty, 0 AccQty
    FROM r_Prods rp WITH(NOLOCK), t_RetD d WITH(NOLOCK), t_Ret m WITH(NOLOCK)
    WHERE d.ProdID = rp.ProdID AND m.ChID = d.ChID AND (rp.InRems <> 0) AND (m.DocDate BETWEEN @BDate AND @EDate)  
      AND m.StockID in (4,304)
      AND m.OurID in (SELECT AValue FROM dbo.af_GetValidsTable('ValidOurs'))    
    GROUP BY m.OurID, m.StockID, d.SecID, d.ProdID, d.PPID


select 'Table'+';'+'DayFrom'+';'+'DayTo' union all select 'Delivery'+';'+CONVERT(varchar,GETDATE()-45,112)+';'+convert(varchar,GETDATE(),112) union all select 'Stocks'+';'+CONVERT(varchar,GETDATE()-45,112)+';'+convert(varchar,GETDATE(),112)
CREATE TABLE dbo.tmp_CamparyStatus (
TableName VARCHAR(200)
,DayFrom VARCHAR()
,DayTo SMALLDATETIME
)
INSERT INTO dbo.tmp_CamparyStatus (TableName,DayFrom,DayTo)
VALUES ('Delivery;',CONVERT(varchar,GETDATE()-45,112),CONVERT(varchar,GETDATE(),112))
SELECT * FROM dbo.tmp_CamparyStatus




--IF OBJECT_ID (N'dbo.tmp_Campary', N'U') IS NOT NULL select 1 else select 2

DECLARE @DayPeriod INT = DATEdiff( dd,'2016-12-31',dbo.zf_GetDate(GETDATE()) );
IF OBJECT_ID (N'dbo.tmp_CamparyStatus', N'U') IS NOT NULL DROP TABLE dbo.tmp_CamparyStatus
SELECT *  
 INTO dbo.tmp_CamparyStatus
FROM (
select 'Delivery' TableName,CONVERT(varchar,GETDATE()-@DayPeriod,112) DayFrom,CONVERT(varchar,GETDATE(),112) DayTo
union all select 'Stocks',CONVERT(varchar,GETDATE()-@DayPeriod,112), CONVERT(varchar,GETDATE(),112)
) s
select 'Table'+';'+'DayFrom'+';'+'DayTo' union all
SELECT TableName +';'+ DayFrom +';'+ DayTo FROM tmp_CamparyStatus

IF OBJECT_ID (N'tempdb..#NotInv', N'U') IS NOT NULL DROP TABLE #NotInv
	CREATE TABLE #NotInv (Num INT IDENTITY(1,1) NOT NULL ,TaxDocID INT null, TaxDocDate SMALLDATETIME null, ProdID INT NULL, Qty NUMERIC(21,9))

	INSERT #NotInv
	--="union all select "&C4&",'"&ТЕКСТ(D4;"ГГГГ-ММ-ДД")&"',"&H4&","&L4&""
	SELECT 10109,'2017-10-31',31959,37
UNION ALL SELECT 2832,'2017-05-11',32111,1
UNION ALL SELECT 344,'2017-08-01',23774,20
UNION ALL SELECT 3614,'2017-04-11',3499,7
UNION ALL SELECT 3614,'2017-04-11',3499,7
UNION ALL SELECT 3614,'2017-04-11',3499,7
UNION ALL SELECT 3614,'2017-04-11',3499,7
UNION ALL SELECT 3614,'2017-04-11',3499,7
UNION ALL SELECT 232,'2017-04-11',3232,7

SELECT * FROM #NotInv