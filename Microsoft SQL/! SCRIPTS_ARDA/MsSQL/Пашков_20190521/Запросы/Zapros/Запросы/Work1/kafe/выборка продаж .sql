use otdatacafe
declare @AChID int
select @AChID = max (AChID)
from t_srecA
print @AChID



select 16 as ChID ,identity(smallint,1,1) as SrcPosID ,td.ProdID , 0 as PPID ,td.UM ,sum (td.Qty) as qty,0 as SetCostCC ,0 as SetValue1 ,0 as SetValue2 ,0 as SetValue3 ,0 as PriceCC_nt ,0 as SumCC_nt ,0 as Tax ,0 as TaxSum ,0 as PriceCC_wt ,0 as SumCC_wt ,0 as Extra ,0 as PriceCC ,0 as NewPriceCC_nt ,0 as NewSumCC_nt ,0 as NewTax ,0 as NewTaxSum ,0 as NewPriceCC_wt ,0 as NewSumCC_wt ,@AChID as AChID ,td.BarCode ,1 as SecID
 into _T_srecA
from t_saled td
 group by td.ProdID ,td.UM, td.BarCode