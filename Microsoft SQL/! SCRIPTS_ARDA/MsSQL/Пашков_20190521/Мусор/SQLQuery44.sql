SELECT DocID, DocDate, KursMC, Notes FROM t_Epp WITH(NOLOCK) 	WHERE ChID = 2126   
SELECT * FROM t_Epp WITH(NOLOCK) 	WHERE ChID = 2126   
SELECT * FROM t_EppD WITH(NOLOCK) 	WHERE ChID = 2126   

		SELECT SrcPosID, ProdID, PPID, UM, Qty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt, BarCode
		FROM t_EppD i
		WHERE i.ChID = 2126 
		ORDER BY i.SrcPosID
	
	
	
		
BEGIN TRAN

DECLARE @NewChIDRec int

SELECT * FROM t_Epp
WHERE ChiD = 2126
ORDER BY 1
SELECT * FROM t_EppD
WHERE ChiD = 2126
ORDER BY 1


EXEC dbo.z_NewChID 't_Rec', @NewChIDRec OUTPUT 
select @NewChIDRec

EXEC [ap_PerebrosMegduFirmami] 6,1201,2126

SELECT * FROM t_Rec
WHERE ChiD = @NewChIDRec
ORDER BY 1
SELECT * FROM t_RecD
WHERE ChiD = @NewChIDRec
ORDER BY 1

SELECT pp.* FROM t_RecD rd
join t_PInP pp on pp.ProdID = rd.ProdID and pp.PPID = rd.PPID 
WHERE ChiD = @NewChIDRec
ORDER BY 1

SELECT pp.* FROM t_EppD rd
join t_PInP pp on pp.ProdID = rd.ProdID and pp.PPID = rd.PPID 
WHERE ChiD = 2126
ORDER BY 1

ROLLBACK TRAN
