declare @p3 bit
set @p3=NULL
declare @p4 varchar(8000)
set @p4=NULL
declare @p5 int
set @p5=NULL
exec t_SaleAfterClose 2695,0,@p3 output,@p4 output,@p5 output
select @p3, @p4, @p5

select * from t_Sale where ChID = 2695
select * from t_SaleD where ChID = 2695

DECLARE @T [TABLEINT]
		INSERT @T SELECT ChID FROM t_Sale where ChID = 2695

SELECT d.PriceCC_wt, rp.IndRetPriceCC, * FROM dbo.t_Sale m
        JOIN dbo.t_SaleD d ON d.ChID = m.ChID
        JOIN dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID      
        JOIN dbo.r_Comps rc WITH(NOLOCK) ON rc.CompID = m.CompID
        WHERE m.ChID IN (SELECT ID FROM @T)
        AND m.OurID IN (7,8,9,11)
        --AND m.CodeID1 BETWEEN 51 AND 79
        AND m.DocDate >= '20140618'
        AND m.CodeID2 != 44
        AND d.PriceCC_wt < rp.IndRetPriceCC

a_tSale_CheckValues_U
ap_TR_CheckProdsMinPrice