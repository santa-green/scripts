USE [ElitR_test_IM]
GO
/****** Object:  StoredProcedure [dbo].[t_CorrectSalePrice]    Script Date: 11/10/2016 16:37:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[t_CorrectSalePrice](@DocCode int, @ChID int,
  @ProdID int, @RateMC numeric(21, 9), @Qty numeric(21, 9), @AllowZeroPrice bit, @PriceCC_wt numeric(21, 9) OUTPUT)
/* Корректирует цену продажи с учетом ограничений */
AS
BEGIN
  DECLARE @MinSalePrice numeric(21, 9)
  DECLARE @MaxSalePrice numeric(21, 9)
  SELECT @MinSalePrice = dbo.zf_RoundPriceSale(IndRetPriceCC * 1.05), @MaxSalePrice = dbo.zf_RoundPriceSale(MaxPriceMC * 1) FROM r_Prods WITH(NOLOCK) WHERE ProdID = @ProdID

  IF @DocCode = 1011 AND (SELECT TOP 1 CashType FROM t_SaleTemp s, r_CRs c WITH(NOLOCK) WHERE s.CRID = c.CRID AND s.ChID = @ChID) <> 8
    BEGIN
      IF @MinSalePrice = 0
        SET @MinSalePrice = 0.01
      IF (@Qty > 0) AND (dbo.zf_RoundPriceSale(@MinSalePrice * @Qty) < 0.01)
        SET @MinSalePrice = dbo.zf_RoundPriceSale(0.01 / @Qty)
    END

  IF @AllowZeroPrice = 1 
    SELECT @MinSalePrice = 0

  IF @PriceCC_wt > @MaxSalePrice AND @MaxSalePrice <> 0
    SET @PriceCC_wt = @MaxSalePrice

  IF @PriceCC_wt < @MinSalePrice
    SET @PriceCC_wt = @MinSalePrice
END
GO
