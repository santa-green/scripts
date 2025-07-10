SELECT * FROM r_Uni
SELECT RefID FROM r_Uni where RefTypeID = 1000000008 and RefID = 1201

SELECT * FROM r_UniTypes

t_GetProdDetail

t_GetPriceCC

SELECT ChID, UM, dbo.zf_GetProdTaxPercent(ProdID, dbo.zf_GetDate('20170928')) TaxPercent, PriceWithTax, CstDty, 0 AS CstDty2, CstPrc, CstExc, MinPriceMC, MaxPriceMC, MinRem, StdExtraR, StdExtraE, MinExtra, MaxExtra, UseAlts, UseCrts, InRems, IsDecQty, Extra1, Extra2, Extra3, Extra4, Extra5, PCatID, PGrID, PGrID1, PGrID2, PGrID3, PGrAID, InStopList , CstProdCode, TaxTypeID
FROM r_Prods WHERE ProdID=800779

SELECT m.BarCode FROM r_Prods p, r_ProdMQ m WHERE m.ProdID=p.ProdID AND p.UM=m.UM AND m.ProdID=800779

declare @p7 float
set @p7=0
declare @p8 float
set @p8=0
declare @p9 int
set @p9=0
declare @p10 int
set @p10=0
declare @p11 int
set @p11=0
declare @p12 float
set @p12=0
declare @p13 bit
set @p13=1
declare @p14 varchar(8000)
set @p14=NULL
exec t_GetProdDetail 11011,6,1201,1,800779,'',@p7 output,@p8 output,@p9 output,@p10 output,@p11 output,@p12 output,@p13 output,@p14 output
select @p7, @p8, @p9, @p10, @p11, @p12, @p13, @p14


declare @p8 float
set @p8=NULL
exec t_GetPriceCC 11011,799,800779,100179,27,0,0,@p8 output
select @p8

SELECT dbo.zf_GetIncludedTax(126.90, 20.00)

SELECT dbo.zf_InStopList(11011, '800779')