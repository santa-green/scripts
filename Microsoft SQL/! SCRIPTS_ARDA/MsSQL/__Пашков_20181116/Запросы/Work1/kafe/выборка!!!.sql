use otdatacafe

select ChID ,SrcPosID ,ProdID ,PPID ,UM ,Qty ,SetCostCC ,SetValue1 ,SetValue2 ,SetValue3 ,PriceCC_nt ,SumCC_nt ,Tax ,TaxSum ,PriceCC_wt ,SumCC_wt ,Extra ,PriceCC ,NewPriceCC_nt ,NewSumCC_nt ,NewTax ,NewTaxSum ,NewPriceCC_wt ,NewSumCC_wt ,AChID ,BarCode ,SecID
from t_srecA
 where chid = 15