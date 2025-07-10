
DECLARE @ChID INT = 3895
BEGIN
  
  --BEGIN TRAN EXEC ap_CalcPRet 738 ROLLBACK
  
  DECLARE @OurID INT, @CompID INT, @CompAddID INT, @BDate SMALLDATETIME, @EDate SMALLDATETIME, @CForm INT;
  DECLARE @ProdID INT, @PriceCC NUMERIC(21,9), @ProdPPDate SMALLDATETIME, @PriceWithTax BIT;
  DECLARE @AChID INT;
 
   SELECT 
    OurID, 
    CompID,
    CompAddID,
    BDate,
    EDate,
    CForm,
    PriceWithTax
  FROM at_t_PRet WITH(NOLOCK)
  WHERE ChID = 3895
   
  SELECT 
   @OurID = OurID, 
   @CompID = CompID,
   @CompAddID = CompAddID,
   @BDate = BDate,
   @EDate = EDate,
   @CForm = CForm,
   @PriceWithTax = PriceWithTax
  FROM at_t_PRet WITH(NOLOCK)
  WHERE ChID = @ChID;
  
	--BEGIN TRAN

  DELETE d
  FROM at_t_PRetA a WITH(NOLOCK)
  JOIN at_t_PRetD d ON d.AChID = a.AChID 
  WHERE a.ChID = @ChID;

  WITH TInv (ChID, DocID, DocDate, TaxDocID, TaxDocDate, SrcTaxDocID, SrcTaxDocDate, OurID, CompID, CompAddID, CodeID2, CodeID3) AS (
  SELECT ChID, DocID, DocDate, TaxDocID, TaxDocDate, SrcTaxDocID, SrcTaxDocDate, OurID, CompID, CompAddID, CodeID2, CodeID3
  FROM dbo.t_Inv WITH(NOLOCK)
  UNION
  SELECT ChID, DocID, DocDate, TaxDocID, TaxDocDate, SrcTaxDocID, SrcTaxDocDate, OurID, CompID, CompAddID, CodeID2, CodeID3
  FROM [s-sql-back].Elit2014.dbo.t_Inv WITH(NOLOCK) WHERE DocDate < '20150101'
  )
  , TInvD(ChID, ProdID, PPID, Qty, PriceCC_wt, PriceCC_nt) AS (
  SELECT ChID, ProdID, PPID, SUM(Qty), PriceCC_wt, PriceCC_nt FROM dbo.t_InvD WITH(NOLOCK) GROUP BY ChID, ProdID, PPID, PriceCC_wt, PriceCC_nt
  UNION ALL
  SELECT ChID, ProdID, PPID, SUM(Qty), PriceCC_wt, PriceCC_nt FROM [s-sql-back].Elit2014.dbo.t_InvD d WITH(NOLOCK)
    WHERE EXISTS(SELECT * FROM [s-sql-back].Elit2014.dbo.t_Inv WITH(NOLOCK) WHERE ChID = d.ChID AND DocDate < '20150101')
  GROUP BY ChID, ProdID, PPID, PriceCC_wt, PriceCC_nt
  )
  , TRet(ChID, DocDate, SrcTaxDocID, SrcTaxDocDate) AS (
  SELECT ChID, DocDate, SrcTaxDocID, SrcTaxDocDate FROM dbo.t_Ret WITH(NOLOCK)
  UNION
  SELECT ChID, DocDate, SrcTaxDocID, SrcTaxDocDate FROM [s-sql-back].Elit2014.dbo.t_Ret WITH(NOLOCK) WHERE DocDate < '20150101'
  )
  , TRetD(ChID, ProdID, PPID, Qty, PriceCC_wt, PriceCC_nt) AS (
  SELECT ChID, ProdID, PPID, SUM(Qty), PriceCC_wt, PriceCC_nt FROM dbo.t_RetD WITH(NOLOCK) GROUP BY ChID, ProdID, PPID, PriceCC_wt, PriceCC_nt
  UNION ALL
  SELECT ChID, ProdID, PPID, SUM(Qty), PriceCC_wt, PriceCC_nt FROM [s-sql-back].Elit2014.dbo.t_RetD d WITH(NOLOCK)
    WHERE EXISTS(SELECT * FROM [s-sql-back].Elit2014.dbo.t_Ret WITH(NOLOCK) WHERE ChID = d.ChID AND DocDate < '20150101')
  GROUP BY ChID, ProdID, PPID, PriceCC_wt, PriceCC_nt
  )----4.10.2017 gdn1  Смотреть  возврат товара в базе ElitDistr
  , TRetDistr(ChID, DocDate, SrcTaxDocID, SrcTaxDocDate) AS (
  SELECT ChID, DocDate, SrcTaxDocID, SrcTaxDocDate FROM dbo.t_Ret WITH(NOLOCK)
  UNION
  SELECT ChID, DocDate, SrcTaxDocID, SrcTaxDocDate FROM [s-sql-d4].ElitDistr.dbo.t_Ret
  )
  , TRetDDistr(ChID, ProdID, PPID, Qty, PriceCC_wt, PriceCC_nt) AS (
  SELECT ChID, ProdID, PPID, SUM(Qty), PriceCC_wt, PriceCC_nt FROM dbo.t_RetD WITH(NOLOCK) GROUP BY ChID, ProdID, PPID, PriceCC_wt, PriceCC_nt
  UNION ALL
  SELECT ChID, ProdID, PPID, SUM(Qty), PriceCC_wt, PriceCC_nt FROM [s-sql-d4].ElitDistr.dbo.t_RetD d WITH(NOLOCK)
    WHERE EXISTS(SELECT * FROM [s-sql-d4].ElitDistr.dbo.t_Ret WITH(NOLOCK) WHERE ChID = d.ChID )
  GROUP BY ChID, ProdID, PPID, PriceCC_wt, PriceCC_nt
  )
  , T AS (
  SELECT 
    f.AChID AChID, m.ChID, m.DocID AS DocNum, m.DocDate, m.TaxDocID, m.TaxDocDate, h.TaxPayer, m.CompID, d.PPID, tp.ProdPPDate, 
    CASE @PriceWithTax WHEN 1 THEN ROUND(d.PriceCC_wt,2) ELSE ROUND(d.PriceCC_nt,2) END PriceCC, SUM(d.Qty) Qty
  FROM at_t_PRetA f
	CROSS JOIN TInv m
  JOIN TInvD d ON d.ChID = m.ChID
  JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID
  JOIN r_Codes3 c3 WITH(NOLOCK) ON c3.CodeID3 = m.CodeID3 AND c3.CForm = @CForm
  CROSS APPLY dbo.af_GetCompReqs(@CompID,m.DocDate) h 
  WHERE f.ChID = @ChID
		AND m.CodeID2 NOT IN (43,44) AND m.OurID = @OurID AND m.CompID = @CompID 
    AND m.CompAddID = CASE @CompAddID WHEN 0 THEN m.CompAddID ELSE @CompAddID END
    AND m.DocDate BETWEEN @BDate AND @EDate
    AND d.ProdID = f.ProdID AND (f.ProdPPDate IS NULL OR tp.ProdPPDate = f.ProdPPDate)
    AND f.PriceCC = CASE f.PriceCC WHEN 0 THEN f.PriceCC ELSE (CASE @PriceWithTax WHEN 1 THEN ROUND(d.PriceCC_wt,2) ELSE ROUND(d.PriceCC_nt,2) END) END
  GROUP BY f.AChID, m.ChID, m.DocID, m.DocDate, m.TaxDocID, m.TaxDocDate, h.TaxPayer, m.CompID, d.PPID, tp.ProdPPDate, d.PriceCC_wt, d.PriceCC_nt

  UNION ALL
  SELECT 
    f.AChID AChID, im.ChID, im.DocID, im.DocDate, im.TaxDocID, im.TaxDocDate, h.TaxPayer, im.CompID, d.PPID, tp.ProdPPDate, 
    CASE @PriceWithTax WHEN 1 THEN ROUND(d.PriceCC_wt,2) ELSE ROUND(d.PriceCC_nt,2) END PriceCC, SUM(d.Qty) Qty
  FROM at_t_PRetA f
	CROSS JOIN TInv m
  JOIN TInvD d ON d.ChID = m.ChID
  JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID     
  JOIN TInv im ON im.TaxDocID = m.SrcTaxDocID AND im.TaxDocDate = m.SrcTaxDocDate
  JOIN r_Codes3 c3 WITH(NOLOCK) ON c3.CodeID3 = im.CodeID3 AND c3.CForm = @CForm
  CROSS APPLY dbo.af_GetCompReqs(@CompID,im.DocDate) h          
  WHERE f.ChID = @ChID
		AND im.CodeID2 NOT IN (43,44) AND im.OurID = @OurID AND im.CompID = @CompID 
    AND im.CompAddID = CASE @CompAddID WHEN 0 THEN im.CompAddID ELSE @CompAddID END
    AND m.DocDate BETWEEN @BDate AND @EDate  
    AND d.ProdID = f.ProdID AND (f.ProdPPDate IS NULL OR tp.ProdPPDate = f.ProdPPDate)
    AND f.PriceCC = CASE f.PriceCC WHEN 0 THEN f.PriceCC ELSE (CASE @PriceWithTax WHEN 1 THEN ROUND(d.PriceCC_wt,2) ELSE ROUND(d.PriceCC_nt,2) END) END
		AND EXISTS(SELECT * FROM TInvD WHERE ChID = im.ChID)
  GROUP BY f.AChID, im.ChID, im.DocID, im.DocDate, im.TaxDocID, im.TaxDocDate, h.TaxPayer, im.CompID, d.PPID, tp.ProdPPDate, d.PriceCC_wt, d.PriceCC_nt

  UNION ALL
  SELECT 
    f.AChID AChID, im.ChID, im.DocID, im.DocDate, im.TaxDocID, im.TaxDocDate, h.TaxPayer, im.CompID, dbo.aft_GetParentPPID(d.ProdID, d.PPID, m.SrcTaxDocDate) AS PPID, tp.ProdPPDate, 
    CASE @PriceWithTax WHEN 1 THEN ROUND(d.PriceCC_wt,2) ELSE ROUND(d.PriceCC_nt,2) END PriceCC, -SUM(d.Qty) Qty
  FROM at_t_PRetA f WITH(NOLOCK)
	CROSS JOIN TRet m
  JOIN TRetD d ON d.ChID = m.ChID
  JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID     
  JOIN TInv im ON im.TaxDocID = m.SrcTaxDocID AND im.TaxDocDate = m.SrcTaxDocDate
  JOIN r_Codes3 c3 WITH(NOLOCK) ON c3.CodeID3 = im.CodeID3 AND c3.CForm = @CForm
  CROSS APPLY dbo.af_GetCompReqs(@CompID,im.DocDate) h          
  WHERE f.ChID = @ChID
		AND im.CodeID2 NOT IN (43,44) AND im.OurID = @OurID AND im.CompID = @CompID 
    AND im.CompAddID = CASE @CompAddID WHEN 0 THEN im.CompAddID ELSE @CompAddID END
    AND m.DocDate BETWEEN @BDate AND @EDate
    AND d.ProdID = f.ProdID AND (f.ProdPPDate IS NULL OR tp.ProdPPDate = f.ProdPPDate)
    AND f.PriceCC = CASE f.PriceCC WHEN 0 THEN f.PriceCC ELSE (CASE @PriceWithTax WHEN 1 THEN ROUND(d.PriceCC_wt,2) ELSE ROUND(d.PriceCC_nt,2) END) END
		AND EXISTS(SELECT * FROM TInvD WHERE ChID = im.ChID)
  GROUP BY f.AChID, im.ChID, im.DocID, im.DocDate, im.TaxDocID, im.TaxDocDate, h.TaxPayer, im.CompID, d.ProdID, d.PPID, tp.ProdPPDate, d.PriceCC_wt, d.PriceCC_nt, m.SrcTaxDocDate  
  
  UNION ALL
  SELECT 
    f.AChID AChID, im.ChID, im.DocID, im.DocDate, im.TaxDocID, im.TaxDocDate, h.TaxPayer, im.CompID, dbo.aft_GetParentPPID(d.ProdID, d.PPID, m.SrcTaxDocDate) AS PPID, tp.ProdPPDate, 
    CASE @PriceWithTax WHEN 1 THEN ROUND(d.PriceCC_wt,2) ELSE ROUND(d.PriceCC_nt,2) END PriceCC, -SUM(d.Qty) Qty
  FROM at_t_PRetA f WITH(NOLOCK)
	CROSS JOIN TRetDistr m
  JOIN TRetDDistr d ON d.ChID = m.ChID
  JOIN t_PInP tp WITH(NOLOCK) ON tp.ProdID = d.ProdID AND tp.PPID = d.PPID     
  JOIN TInv im ON im.TaxDocID = m.SrcTaxDocID AND im.TaxDocDate = m.SrcTaxDocDate
  JOIN r_Codes3 c3 WITH(NOLOCK) ON c3.CodeID3 = im.CodeID3 AND c3.CForm = @CForm
  CROSS APPLY dbo.af_GetCompReqs(@CompID,im.DocDate) h          
  WHERE f.ChID = @ChID
		AND im.CodeID2 NOT IN (43,44) AND im.OurID = @OurID AND im.CompID = @CompID 
		AND @CompID in (10797,10798,10791)
    AND im.CompAddID = CASE @CompAddID WHEN 0 THEN im.CompAddID ELSE @CompAddID END
    AND m.DocDate BETWEEN @BDate AND @EDate
    AND d.ProdID = f.ProdID AND (f.ProdPPDate IS NULL OR tp.ProdPPDate = f.ProdPPDate)
    AND f.PriceCC = CASE f.PriceCC WHEN 0 THEN f.PriceCC ELSE (CASE @PriceWithTax WHEN 1 THEN ROUND(d.PriceCC_wt,2) ELSE ROUND(d.PriceCC_nt,2) END) END
		AND EXISTS(SELECT * FROM TInvD WHERE ChID = im.ChID)
  GROUP BY f.AChID, im.ChID, im.DocID, im.DocDate, im.TaxDocID, im.TaxDocDate, h.TaxPayer, im.CompID, d.ProdID, d.PPID, tp.ProdPPDate, d.PriceCC_wt, d.PriceCC_nt, m.SrcTaxDocDate  
  )

  --INSERT at_t_PRetD
  --(AChID, SrcPosID, ChID, DocNum, DocDate, TaxDocID, TaxDocDate, TaxPayer, CompID, PPID, ProdPPDate, PriceCC, MaxQty)
  SELECT 
    m.AChID, DENSE_RANK() OVER (PARTITION BY m.AChID ORDER BY m.ChID, m.PPID,m.PriceCC /*rss0 Кельман*/) SrcPosID, m.ChID, m.DocNum, m.DocDate, 
    m.TaxDocID, m.TaxDocDate, m.TaxPayer, m.CompID, dbo.aft_GetValidPPID(a.ProdID, m.PPID) PPID, m.ProdPPDate,m.PriceCC, SUM(m.Qty) MaxQty
  FROM T m
	JOIN dbo.at_t_PRetA a ON a.AChID = m.AChID
  GROUP BY m.AChID, m.ChID, m.DocNum, m.DocDate, m.TaxDocID, m.TaxDocDate, m.PPID, m.TaxPayer, m.CompID, m.ProdPPDate, m.PriceCC, a.ProdID
  HAVING SUM(m.Qty) != 0;

	--IF @@TRANCOUNT > 0 COMMIT;
END;


GO
