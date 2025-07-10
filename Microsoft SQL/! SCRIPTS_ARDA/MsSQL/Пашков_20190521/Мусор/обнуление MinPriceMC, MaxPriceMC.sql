--обнуление MinPriceMC, MaxPriceMC
BEGIN TRAN

SELECT MinPriceMC, MaxPriceMC,ProdID, ProdName FROM r_Prods where MinPriceMC <> 0 or  MaxPriceMC <> 0

update r_Prods
set MinPriceMC = 0, MaxPriceMC = 0
where MinPriceMC <> 0 or  MaxPriceMC <> 0


SELECT MinPriceMC, MaxPriceMC,ProdID, ProdName FROM r_Prods where MinPriceMC <> 0 or  MaxPriceMC <> 0

ROLLBACK TRAN



--ChID, ProdID, ProdName, UM, Country, Notes, PCatID, PGrID, Article1, Article2, Article3, Weight, Age, PriceWithTax, Note1, Note2, Note3, MinPriceMC, MaxPriceMC, MinRem, CstDty, CstPrc, CstExc, StdExtraR, StdExtraE, MaxExtra, MinExtra, UseAlts, UseCrts, PGrID1, PGrID2, PGrID3, PGrAID, PBGrID, LExpSet, EExpSet, InRems, IsDecQty, File1, File2, File3, AutoSet, Extra1, Extra2, Extra3, Extra4, Extra5, Norma1, Norma2, Norma3, Norma4, Norma5, RecMinPriceCC, RecMaxPriceCC, RecStdPriceCC, RecRemQty, InStopList, PrepareTime, AmortID, WeightGr, WeightGrWP, PGrID4, PGrID5, DistrID, ImpID, ScaleGrID, ScaleStandard, ScaleConditions, ScaleComponents, ExcCostCC, CstDtyNotes, CstExcNotes, BoxVolume, SalesChannelID, IndRetPriceCC, IndWSPriceCC, SupID, TaxFreeReason, CstProdCode, TaxTypeID