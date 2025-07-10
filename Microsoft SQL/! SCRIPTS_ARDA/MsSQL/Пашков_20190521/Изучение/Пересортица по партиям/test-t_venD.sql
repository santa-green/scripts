			--INSERT t_VenD
			--(ChID, DetProdID, SrcPosID, PPID, DetUM, Qty, PriceCC_nt, PriceCC_wt, Tax, TaxSum,
			-- SumCC_nt, SumCC_wt, NewQty, NewSumCC_nt, NewTaxSum, NewSumCC_wt, SecID)
			--VALUES 
			--(@ChID, @ProdID, @SrcPosID, @PPID, @UM, @Qty, dbo.zf_GetProdPrice_nt(@PriceCC, @ProdID,@DocDate),
			-- @PriceCC, dbo.zf_GetProdPrice_wtTax(@PriceCC, @ProdID,@DocDate),
			-- dbo.zf_GetProdPrice_wtTax(@PriceCC, @ProdID,@DocDate) * @Qty,
			-- dbo.zf_GetProdPrice_nt(@PriceCC, @ProdID,@DocDate) * @Qty, (@PriceCC * @Qty), @NewQty, 
			-- dbo.zf_GetProdPrice_nt(@PriceCC, @ProdID,@DocDate) * @NewQty,dbo.zf_GetProdPrice_wtTax(@PriceCC,
			-- @ProdID,@DocDate) * @NewQty, (@PriceCC * @NewQty), 1)
			
		--PPID	RemQty	         PriceCC
		--93	   -0.000149000	    119.999999988
		--94	   1.019948000	    80.000000001
			 

declare 
	@ProdID int = 610043,
	@Qty float = -0.000149000, 
	@SrcPosID int = 1,
	@PPID int = 93,
	@UM varchar(10) = 'Í„', 
	@ChID int = 100009076	,		 
	@PriceCC NUMERIC(21,9) = 119.999999988,
	@DocDate SMALLDATETIME = '2016-12-31',
	@NewQty float = 0
			 
			INSERT t_VenD
			(ChID, DetProdID, SrcPosID, PPID, DetUM, Qty, PriceCC_nt, PriceCC_wt, Tax, TaxSum,
			 SumCC_nt, SumCC_wt, NewQty, NewSumCC_nt, NewTaxSum, NewSumCC_wt, SecID)
			VALUES 
			(@ChID, @ProdID, @SrcPosID, @PPID, @UM, @Qty, dbo.zf_GetProdPrice_nt(@PriceCC, @ProdID,@DocDate),
			 @PriceCC, dbo.zf_GetProdPrice_wtTax(@PriceCC, @ProdID,@DocDate),
			 dbo.zf_GetProdPrice_wtTax(@PriceCC, @ProdID,@DocDate) * @Qty,
			 dbo.zf_GetProdPrice_nt(@PriceCC, @ProdID,@DocDate) * @Qty, (@PriceCC * @Qty), @NewQty, 
			 dbo.zf_GetProdPrice_nt(@PriceCC, @ProdID,@DocDate) * @NewQty,dbo.zf_GetProdPrice_wtTax(@PriceCC,
			 @ProdID,@DocDate) * @NewQty, (@PriceCC * @NewQty), 1)
			 
declare 
	@ProdID int = 610043,
	@Qty float = 1.019948000, 
	@SrcPosID int = 2,
	@PPID int = 94,
	@UM varchar(10) = 'Í„', 
	@ChID int = 100009076	,		 
	@PriceCC NUMERIC(21,9) = 80.000000001,
	@DocDate SMALLDATETIME = '2016-12-31',
	@NewQty float = 1.0198
			 
			INSERT t_VenD
			(ChID, DetProdID, SrcPosID, PPID, DetUM, Qty, PriceCC_nt, PriceCC_wt, Tax, TaxSum,
			 SumCC_nt, SumCC_wt, NewQty, NewSumCC_nt, NewTaxSum, NewSumCC_wt, SecID)
			VALUES 
			(@ChID, @ProdID, @SrcPosID, @PPID, @UM, @Qty, dbo.zf_GetProdPrice_nt(@PriceCC, @ProdID,@DocDate),
			 @PriceCC, dbo.zf_GetProdPrice_wtTax(@PriceCC, @ProdID,@DocDate),
			 dbo.zf_GetProdPrice_wtTax(@PriceCC, @ProdID,@DocDate) * @Qty,
			 dbo.zf_GetProdPrice_nt(@PriceCC, @ProdID,@DocDate) * @Qty, (@PriceCC * @Qty), @NewQty, 
			 dbo.zf_GetProdPrice_nt(@PriceCC, @ProdID,@DocDate) * @NewQty,dbo.zf_GetProdPrice_wtTax(@PriceCC,
			 @ProdID,@DocDate) * @NewQty, (@PriceCC * @NewQty), 1)		


declare 
	@ProdID int = 610043,
	@Qty float = 1.019948000, 
	@SrcPosID int = 2,
	@PPID int = 94,
	@UM varchar(10) = 'Í„', 
	@ChID int = 100009076	,		 
	@PriceCC NUMERIC(21,9) = 80.000000001,
	@DocDate SMALLDATETIME = '2016-12-31',
	@NewQty float = 1.0198
			 
			INSERT t_VenD
			(ChID, DetProdID, SrcPosID, PPID, DetUM, Qty, PriceCC_nt,
			 PriceCC_wt, Tax, 
			 TaxSum,
			 SumCC_nt, SumCC_wt, NewQty, 
			 NewSumCC_nt,
			 NewTaxSum, NewSumCC_wt, SecID)
			VALUES 
			(@ChID, @ProdID, @SrcPosID, @PPID, @UM, @Qty, dbo.zf_GetProdPrice_nt(@PriceCC, @ProdID,@DocDate),
			 @PriceCC, dbo.zf_GetProdPrice_wtTax(@PriceCC, @ProdID,@DocDate),
			 dbo.zf_GetProdPrice_wtTax(@PriceCC, @ProdID,@DocDate) * @Qty,
			 dbo.zf_GetProdPrice_nt(@PriceCC, @ProdID,@DocDate) * @Qty, (@PriceCC * @Qty), @NewQty, 
			 dbo.zf_GetProdPrice_nt(@PriceCC, @ProdID,@DocDate) * @NewQty,dbo.zf_GetProdPrice_wtTax(@PriceCC,
			 @ProdID,@DocDate) * @NewQty, (@PriceCC * @NewQty), 1)					 	 