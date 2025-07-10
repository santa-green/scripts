select * from t_Ven where DocID = 100000808

select * from t_Ven where ChID = 100009037

select * from t_VenA where ChID = 100009037 and ProdID = 610991

select * from t_VenD where ChID = 100009036 and DetProdID = 610017

select * from t_VenD_UM where ChID = 100009037 and DetProdID = 610991

ap_CalcVenByRemD

select * from t_VenA where ChID = 100009076 
--delete t_VenA where ChID = 100009076 
EXEC ap_CalcVenPeresortByRemD 100009076


select * from t_Ven where ChID = 100009076

select * from t_VenA where ChID = 100009076 and ProdID = 610043

INSERT t_VenA
       (ChID, ProdID)
VALUES (100009076, 610043)

exec ip_VenExport 100009037



select * from _TRemD WHERE ProdID in (select distinct ProdID from _TRemD WHERE Qty < 0) order by ProdID, PPID

select ProdID, SUM(Qty) from _TRemD WHERE ProdID in (select distinct ProdID from _TRemD WHERE Qty < 0) group by ProdID

select * from _TRemD WHERE ProdID in (610001)

	--Заполнение товарной части t_VenA
	--DECLARE VenA CURSOR FAST_FORWARD
	--FOR
	SELECT i.ProdID, p.UM, sum(Qty) Qty
	FROM _TRemD i 
	INNER JOIN r_Prods p ON i.ProdID = p.ProdID
	WHERE i.ProdID in (SELECT DISTINCT ProdID FROM _TRemD WHERE Qty < 0)  
	GROUP BY i.ProdID, p.UM
	HAVING SUM(Qty) > 0
	ORDER BY i.ProdID


declare VenA cursor fast_forward
for
select 
	i.ProdID, p.UM, sum(Qty) Qty
from _TRemD i 
inner join r_Prods p on i.ProdID = p.ProdID
WHERE i.ProdID in (select distinct ProdID from _TRemD WHERE Qty < 0) -- and i.ProdID in (610041,610054)
group by i.ProdID, p.UM
order by i.ProdID

declare 
	@TSrcPosID int, @ProdID int, @Qty float, 
	@UM varchar(10), @ProdList varchar(4000), 
	@BarCode varchar(50), @ChID int = 100009076

open VenA
	fetch next from VenA into @ProdID, @UM, @Qty
while @@fetch_status = 0 
begin
		select 
			@BarCode = BarCode
		from r_ProdMQ 
		where ProdID = @ProdID and UM = @UM
	
		select 
			@TSrcPosID = isnull(max(TSrcPosID), 0) + 1
		from t_VenA 
		where ChID = @ChID
	
		insert into t_VenA
		(
			ChID, ProdID, UM, TQty, TNewQty, 
			TSumCC_nt, TTaxSum, TSumCC_wt, 
			TNewSumCC_nt, TNewTaxSum, TNewSumCC_wt, 
			BarCode, Norma1, TSrcPosID
		)
		select
			@ChID, @ProdID, @UM, @Qty TQty, @Qty TNewQty, 
			0 TSumCC_nt, 0 TTaxSum, 0 TSumCC_wt, 
			0 TNewSumCC_nt, 0 TNewTaxSum, 0 TNewSumCC_wt, 
			@BarCode, 0 Norma1, @TSrcPosID

	fetch next from VenA into @ProdID, @UM, @Qty
end
close VenA
deallocate VenA

  SELECT ProdID,UM,TQty
  FROM t_VenA WITH(NOLOCK)
  WHERE ChID = 100009076
  ORDER BY TSrcPosID
  
  
  		--DECLARE VenDPPIDs CURSOR FOR
		SELECT rd.PPID, Qty RemQty, (tp.CostMC * 27) PriceCC
		FROM _TRemD rd
		JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = rd.ProdID AND tp.PPID = rd.PPID
		WHERE rd.ProdID = 610043 AND Qty != 0
		ORDER BY rd.PPID
		
		PPID	RemQty	         PriceCC
		93	   -0.000149000	    119.999999988
		94	   1.019948000	    80.000000001


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
	@TSrcPosID int, @ProdID int, @Qty float, 
	@UM varchar(10), @ProdList varchar(4000), 
	@BarCode varchar(50), @ChID int = 100009076			 
			 
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