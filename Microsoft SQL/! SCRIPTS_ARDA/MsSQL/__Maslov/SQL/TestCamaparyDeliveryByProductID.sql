DECLARE 
@StockID VARCHAR(MAX) = '11,311'
,@DayPeriod INT = 45
,@EDate smalldatetime = '2018-08-02'
,@PGrID1 VARCHAR(MAX) = '20-26'
,@StockIDNotInCompID VARCHAR(MAX) = '220,320'
,@NotInCompID VARCHAR(MAX) = '4328,4339,4648,16157,54021,62668,65125,65954,71028,71204'
,@ChangeCompID VARCHAR(MAX) = '100014684'
,@ProdIDTest INT = 32030

DECLARE @BDate smalldatetime
IF @EDate IS NULL SET @EDate = dbo.zf_GetDate(GETDATE())
IF @DayPeriod IS NULL SET @BDate = '1900-01-01' ELSE SET @BDate = DATEADD(day ,-@DayPeriod,dbo.zf_GetDate(@EDate)) 

IF 1 = 0 /* Возврат товара от получателя: Заголовок */
BEGIN
SELECT rp.ProdID ProductID,
	CASE WHEN m.StockID IN (select AValue from zf_FilterToTable(@StockIDNotInCompID)) AND m.CompID NOT IN (select AValue from zf_FilterToTable(@NotInCompID)) THEN @ChangeCompID ELSE c.ChID END OutletID,
	m.EmpID TAID, CONVERT(varchar(250),m.DocDate,112) Data, 4 OperationID,m.DocID, m.ChID DocNo,
	SUM(QTy) Qty, SUM(d.Qty*tp.CostMC) Summ
FROM Elit.dbo.t_Ret m WITH(NOLOCK)
JOIN Elit.dbo.t_RetD d WITH(NOLOCK) ON d.ChID=m.ChID
JOIN Elit.dbo.r_Stocks s WITH(NOLOCK) ON s.StockID=m.StockID
JOIN Elit.dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID=d.ProdID AND rp.PGrID1 IN (select AValue from zf_FilterToTable(@PGrID1))
JOIN Elit.dbo.r_Comps c WITH(NOLOCK) ON c.CompID=m.CompID
JOIN Elit.dbo.t_PInP tp WITH(NOLOCK) ON tp.ProdID=d.ProdID AND tp.PPID=d.PPID
WHERE s.StockID IN (select AValue from zf_FilterToTable(@StockID))
      AND (m.DocDate BETWEEN @BDate AND @EDate)  
      AND (rp.InRems <> 0)
      --AND (rp.ProdID = @ProdIDTest)
GROUP BY c.ChID, rp.ProdID,m.StockID,m.CompID,m.DocID,m.ChID,m.EmpID,m.DocDate


	SELECT m.OurID, m.StockID, d.SecID, d.ProdID, d.PPID, SUM(d.Qty) Qty, 0 AccQty
    FROM r_Prods rp WITH(NOLOCK), t_RetD d WITH(NOLOCK), t_Ret m WITH(NOLOCK)
    WHERE d.ProdID = rp.ProdID AND m.ChID = d.ChID AND (rp.InRems <> 0) AND (m.DocDate BETWEEN @BDate AND @EDate)  
      AND m.StockID in (SELECT AValue from zf_FilterToTable(@StockID))
      AND m.OurID in (SELECT AValue FROM dbo.af_GetValidsTable('ValidOurs'))
      AND rp.PGrID1 IN (select AValue from zf_FilterToTable(@PGrID1))
      --AND (rp.ProdID = @ProdIDTest)    
    GROUP BY m.OurID, m.StockID, d.SecID, d.ProdID, d.PPID
END

IF 1 = 0 /* Возврат товара по чеку: Заголовок */
BEGIN

SELECT rp.ProdID ProductID,
	CASE WHEN m.StockID IN (select AValue from zf_FilterToTable(@StockIDNotInCompID)) AND m.CompID NOT IN (select AValue from zf_FilterToTable(@NotInCompID)) THEN @ChangeCompID ELSE c.ChID END OutletID,
	m.EmpID TAID, CONVERT(varchar(250),m.DocDate,112) Data, -1 OperationID,m.DocID, m.ChID DocNo,
	SUM(QTy) Qty, SUM(d.Qty*tp.CostMC) Summ
FROM Elit.dbo.t_CRRet m WITH(NOLOCK)
JOIN Elit.dbo.t_CRRetD d WITH(NOLOCK) ON d.ChID=m.ChID
JOIN Elit.dbo.r_Stocks s WITH(NOLOCK) ON s.StockID=m.StockID
JOIN Elit.dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID=d.ProdID AND rp.PGrID1 IN (select AValue from zf_FilterToTable(@PGrID1))
JOIN Elit.dbo.r_Comps c WITH(NOLOCK) ON c.CompID=m.CompID
JOIN Elit.dbo.t_PInP tp WITH(NOLOCK) ON tp.ProdID=d.ProdID AND tp.PPID=d.PPID
WHERE s.StockID IN (select AValue from zf_FilterToTable(@StockID))
      AND (m.DocDate BETWEEN @BDate AND @EDate)  
      AND (rp.InRems <> 0)
      --AND (rp.ProdID = @ProdIDTest)
GROUP BY c.ChID, rp.ProdID,m.StockID,m.CompID,m.DocID,m.ChID,m.EmpID,m.DocDate


    SELECT m.OurID, m.StockID, d.SecID, d.ProdID, d.PPID, SUM(d.Qty) Qty, 0 AccQty
    FROM r_Prods rp WITH(NOLOCK), av_t_CRRetD d WITH(NOLOCK), av_t_CRRet m WITH(NOLOCK)
    WHERE d.ProdID = rp.ProdID AND m.ChID = d.ChID AND (rp.InRems <> 0) AND (m.DocDate BETWEEN @BDate AND @EDate)
      AND m.StockID in (SELECT AValue from zf_FilterToTable(@StockID))
      AND m.OurID in (SELECT AValue FROM dbo.af_GetValidsTable('ValidOurs'))
      --AND (rp.ProdID = @ProdIDTest)   
    GROUP BY m.OurID, m.StockID, d.SecID, d.ProdID, d.PPID
END

IF 1 = 0 /* Возврат товара поставщику: Заголовок */
BEGIN
SELECT rp.ProdID ProductID,
	CASE WHEN m.StockID IN (select AValue from zf_FilterToTable(@StockIDNotInCompID)) AND m.CompID NOT IN (select AValue from zf_FilterToTable(@NotInCompID)) THEN @ChangeCompID ELSE c.ChID END OutletID,
	m.EmpID TAID, CONVERT(varchar(250),m.DocDate,112) Data, 2 OperationID,m.DocID, m.ChID DocNo,
	-SUM(QTy) Qty, -SUM(d.Qty*tp.CostMC) Summ
FROM Elit.dbo.t_CRet m WITH(NOLOCK)
JOIN Elit.dbo.t_CRetD d WITH(NOLOCK) ON d.ChID=m.ChID
JOIN Elit.dbo.r_Stocks s WITH(NOLOCK) ON s.StockID=m.StockID
JOIN Elit.dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID=d.ProdID AND rp.PGrID1 IN (select AValue from zf_FilterToTable(@PGrID1))
JOIN Elit.dbo.r_Comps c WITH(NOLOCK) ON c.CompID=m.CompID
JOIN Elit.dbo.t_PInP tp WITH(NOLOCK) ON tp.ProdID=d.ProdID AND tp.PPID=d.PPID
WHERE s.StockID IN (select AValue from zf_FilterToTable(@StockID))
      AND (m.DocDate BETWEEN @BDate AND @EDate)  
      AND (rp.InRems <> 0)
      --AND (rp.ProdID = @ProdIDTest)
GROUP BY c.ChID, rp.ProdID,m.StockID,m.CompID,m.DocID,m.ChID,m.EmpID,m.DocDate


SELECT m.OurID, m.StockID, d.SecID, d.ProdID, d.PPID, -SUM(d.Qty) Qty, 0 AccQty
    FROM r_Prods rp WITH(NOLOCK), av_t_CRetD d WITH(NOLOCK), av_t_CRet m WITH(NOLOCK)
    WHERE d.ProdID = rp.ProdID AND m.ChID = d.ChID AND (rp.InRems <> 0) AND (m.DocDate BETWEEN @BDate AND @EDate)
      AND m.StockID in (SELECT AValue from zf_FilterToTable(@StockID))
      AND m.OurID in (SELECT AValue FROM dbo.af_GetValidsTable('ValidOurs'))
      --AND (rp.ProdID = @ProdIDTest)  
    GROUP BY m.OurID, m.StockID, d.SecID, d.ProdID, d.PPID

END

IF 1 = 1 /* Входящие остатки товара */
BEGIN
SELECT rp.ProdID ProductID,
	--CASE WHEN m.StockID IN (select AValue from zf_FilterToTable(@StockIDNotInCompID)) AND m.CompID NOT IN (select AValue from zf_FilterToTable(@NotInCompID)) THEN @ChangeCompID ELSE c.ChID END 
	0 OutletID,
	/*m.EmpID*/0 TAID, CONVERT(varchar(250),m.DocDate,112) Data, -31 OperationID,m.DocID, m.ChID DocNo,
	SUM(m.Qty) Qty, SUM(m.Qty*tp.CostMC) Summ
FROM Elit.dbo.t_zInP m WITH(NOLOCK) --ON d.ChID=m.ChID
JOIN Elit.dbo.r_Stocks s WITH(NOLOCK) ON s.StockID=m.StockID
JOIN Elit.dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID=m.ProdID AND rp.PGrID1 IN (select AValue from zf_FilterToTable(@PGrID1))
--JOIN Elit.dbo.r_Comps c WITH(NOLOCK) ON c.CompID=m.CompID
JOIN Elit.dbo.t_PInP tp WITH(NOLOCK) ON tp.ProdID=m.ProdID AND tp.PPID=m.PPID
WHERE s.StockID IN (select AValue from zf_FilterToTable(@StockID))
      AND (m.DocDate BETWEEN @BDate AND @EDate)  
      AND (rp.InRems <> 0)
      --AND (rp.ProdID = @ProdIDTest)
GROUP BY /*c.ChID,*/ rp.ProdID,m.StockID,/*m.CompID,*/m.DocID,m.ChID,/*m.EmpID,*/m.DocDate

    SELECT m.OurID, m.StockID, m.SecID, m.ProdID, m.PPID, SUM(m.Qty) Qty, 0 AccQty
    FROM r_Prods rp WITH(NOLOCK), t_PInP tp WITH(NOLOCK), t_zInp m WITH(NOLOCK)
    WHERE tp.ProdID = rp.ProdID AND m.ProdID = tp.ProdID AND m.PPID = tp.PPID AND (rp.InRems <> 0)
      AND m.StockID in (SELECT AValue from zf_FilterToTable(@StockID))
      AND m.OurID in (SELECT AValue FROM dbo.af_GetValidsTable('ValidOurs'))
      --AND (rp.ProdID = @ProdIDTest)    
    GROUP BY m.OurID, m.StockID, m.SecID, m.ProdID, m.PPID
END

IF 1 = 0 /* Заказ внутренний: Резерв: Заголовок */
BEGIN
SELECT rp.ProdID ProductID,
	CASE WHEN m.StockID IN (select AValue from zf_FilterToTable(@StockIDNotInCompID)) AND m.CompID NOT IN (select AValue from zf_FilterToTable(@NotInCompID)) THEN @ChangeCompID ELSE c.ChID END OutletID,
	m.EmpID TAID, CONVERT(varchar(250),m.DocDate,112) Data, -2 OperationID,m.DocID, m.ChID DocNo,
	SUM(QTy) Qty, SUM(d.Qty*tp.CostMC) Summ
FROM Elit.dbo.at_t_IORes m WITH(NOLOCK)
JOIN Elit.dbo.at_t_IOResD d WITH(NOLOCK) ON d.ChID=m.ChID
JOIN Elit.dbo.r_Stocks s WITH(NOLOCK) ON s.StockID=m.StockID
JOIN Elit.dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID=d.ProdID AND rp.PGrID1 IN (select AValue from zf_FilterToTable(@PGrID1))
JOIN Elit.dbo.r_Comps c WITH(NOLOCK) ON c.CompID=m.CompID
JOIN Elit.dbo.t_PInP tp WITH(NOLOCK) ON tp.ProdID=d.ProdID AND tp.PPID=d.PPID
WHERE s.StockID IN (select AValue from zf_FilterToTable(@StockID))
      AND (m.DocDate BETWEEN @BDate AND @EDate)  
	  AND (m.ReserveProds <> 0)
      AND (rp.InRems <> 0)
      --AND (rp.ProdID = @ProdIDTest) 
GROUP BY c.ChID, rp.ProdID,m.StockID,m.CompID,m.DocID,m.ChID,m.EmpID,m.DocDate

SELECT m.OurID, m.StockID, d.SecID, d.ProdID, d.PPID, 0 Qty, SUM(d.NewQty) AccQty
    FROM r_Prods rp WITH(NOLOCK), av_t_IOResD d WITH(NOLOCK), av_t_IORes m WITH(NOLOCK)
    WHERE d.ProdID = rp.ProdID AND m.ChID = d.ChID AND (rp.InRems <> 0) AND (m.ReserveProds <> 0) AND (m.DocDate BETWEEN @BDate AND @EDate)
      AND m.StockID in (SELECT AValue from zf_FilterToTable(@StockID))
      AND m.OurID in (SELECT AValue FROM dbo.af_GetValidsTable('ValidOurs'))
      --AND (rp.ProdID = @ProdIDTest)    
    GROUP BY m.OurID, m.StockID, d.SecID, d.ProdID, d.PPID
END

IF 1 = 0 /* Инвентаризация товара: Заголовок*/
BEGIN
SELECT rp.ProdID ProductID,
	CASE WHEN m.StockID IN (select AValue from zf_FilterToTable(@StockIDNotInCompID)) AND m.CompID NOT IN (select AValue from zf_FilterToTable(@NotInCompID)) THEN @ChangeCompID ELSE c.ChID END OutletID,
	m.EmpID TAID, CONVERT(varchar(250),m.DocDate,112) Data, 6 OperationID,m.DocID, m.ChID DocNo,
	SUM(QTy) Qty, SUM(d.Qty*tp.CostMC) Summ
FROM Elit.dbo.t_Ven m WITH(NOLOCK)
JOIN Elit.dbo.t_VenD d WITH(NOLOCK) ON d.ChID=m.ChID
JOIN Elit.dbo.r_Stocks s WITH(NOLOCK) ON s.StockID=m.StockID
JOIN Elit.dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID=d.DetProdID AND rp.PGrID1 IN (select AValue from zf_FilterToTable(@PGrID1))
JOIN Elit.dbo.r_Comps c WITH(NOLOCK) ON c.CompID=m.CompID
JOIN Elit.dbo.t_PInP tp WITH(NOLOCK) ON tp.ProdID=d.DetProdID AND tp.PPID=d.PPID
WHERE s.StockID IN (select AValue from zf_FilterToTable(@StockID))
      AND (m.DocDate BETWEEN @BDate AND @EDate)  
      AND (rp.InRems <> 0)
      --AND (rp.ProdID = @ProdIDTest)
GROUP BY c.ChID, rp.ProdID,m.StockID,m.CompID,m.DocID,m.ChID,m.EmpID,m.DocDate

SELECT m.OurID, m.StockID, d.SecID, a.ProdID, d.PPID, SUM(d.NewQty) Qty, 0 AccQty
    FROM r_Prods rp WITH(NOLOCK), av_t_PInP tp WITH(NOLOCK), av_t_VenA a WITH(NOLOCK), av_t_VenD d WITH(NOLOCK), av_t_Ven m WITH(NOLOCK)
    WHERE tp.ProdID = rp.ProdID AND d.DetProdID = tp.ProdID AND d.PPID = tp.PPID AND m.ChID = a.ChID AND a.ChID = d.ChID AND a.ProdID = d.DetProdID AND (rp.InRems <> 0) AND (m.DocDate BETWEEN @BDate AND @EDate)
      AND m.StockID in (SELECT AValue from zf_FilterToTable(@StockID))
      AND m.OurID in (SELECT AValue FROM dbo.af_GetValidsTable('ValidOurs'))
      --AND (rp.ProdID = @ProdIDTest)   
    GROUP BY m.OurID, m.StockID, d.SecID, a.ProdID, d.PPID
END

IF 1 = 0 /* Инвентаризация товара: Заголовок MINUS*/
BEGIN
SELECT rp.ProdID ProductID,
	CASE WHEN m.StockID IN (select AValue from zf_FilterToTable(@StockIDNotInCompID)) AND m.CompID NOT IN (select AValue from zf_FilterToTable(@NotInCompID)) THEN @ChangeCompID ELSE c.ChID END OutletID,
	m.EmpID TAID, CONVERT(varchar(250),m.DocDate,112) Data, 6 OperationID,m.DocID, m.ChID DocNo,
	-SUM(QTy) Qty, -SUM(d.Qty*tp.CostMC) Summ
FROM Elit.dbo.t_Ven m WITH(NOLOCK)
JOIN Elit.dbo.t_VenD d WITH(NOLOCK) ON d.ChID=m.ChID
JOIN Elit.dbo.r_Stocks s WITH(NOLOCK) ON s.StockID=m.StockID
JOIN Elit.dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID=d.DetProdID AND rp.PGrID1 IN (select AValue from zf_FilterToTable(@PGrID1))
JOIN Elit.dbo.r_Comps c WITH(NOLOCK) ON c.CompID=m.CompID
JOIN Elit.dbo.t_PInP tp WITH(NOLOCK) ON tp.ProdID=d.DetProdID AND tp.PPID=d.PPID
WHERE s.StockID IN (SELECT AValue from zf_FilterToTable(@StockID))
      AND (m.DocDate BETWEEN @BDate AND @EDate)  
      AND (rp.InRems <> 0)
      --AND (rp.ProdID = @ProdIDTest)
GROUP BY c.ChID, rp.ProdID,m.StockID,m.CompID,m.DocID,m.ChID,m.EmpID,m.DocDate

SELECT m.OurID, m.StockID, d.SecID, a.ProdID, d.PPID, -SUM(d.Qty) Qty, 0 AccQty
    FROM r_Prods rp WITH(NOLOCK), av_t_PInP tp WITH(NOLOCK), av_t_VenA a WITH(NOLOCK), av_t_VenD d WITH(NOLOCK), av_t_Ven m WITH(NOLOCK)
    WHERE tp.ProdID = rp.ProdID AND d.DetProdID = tp.ProdID AND d.PPID = tp.PPID AND m.ChID = a.ChID AND a.ChID = d.ChID AND a.ProdID = d.DetProdID AND (rp.InRems <> 0) AND (m.DocDate BETWEEN @BDate AND @EDate)
      AND m.StockID in (SELECT AValue from zf_FilterToTable(@StockID))
      AND m.OurID in (SELECT AValue FROM dbo.af_GetValidsTable('ValidOurs'))
      --AND (rp.ProdID = @ProdIDTest)    
    GROUP BY m.OurID, m.StockID, d.SecID, a.ProdID, d.PPID
END

IF 1 = 0 /* Комплектация товара: Заголовок*/
BEGIN
SELECT rp.ProdID ProductID,
	--CASE WHEN m.StockID IN (select AValue from zf_FilterToTable(@StockIDNotInCompID)) AND m.CompID NOT IN (select AValue from zf_FilterToTable(@NotInCompID)) THEN @ChangeCompID ELSE c.ChID END 
	0 OutletID,
	m.EmpID TAID, CONVERT(varchar(250),m.DocDate,112) Data, -9 OperationID,m.DocID, m.ChID DocNo,
	SUM(QTy) Qty, SUM(d.Qty*tp.CostMC) Summ
FROM Elit.dbo.t_SRec m WITH(NOLOCK)
JOIN Elit.dbo.t_SRecA d WITH(NOLOCK) ON d.ChID=m.ChID
JOIN Elit.dbo.r_Stocks s WITH(NOLOCK) ON s.StockID=m.StockID
JOIN Elit.dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID=d.ProdID AND rp.PGrID1 IN (select AValue from zf_FilterToTable(@PGrID1))
--JOIN Elit.dbo.r_Comps c WITH(NOLOCK) ON c.CompID=m.CompID
JOIN Elit.dbo.t_PInP tp WITH(NOLOCK) ON tp.ProdID=d.ProdID AND tp.PPID=d.PPID
WHERE s.StockID IN (select AValue from zf_FilterToTable(@StockID))
      AND (m.DocDate BETWEEN @BDate AND @EDate)  
      AND (rp.InRems <> 0)
      --AND (rp.ProdID = @ProdIDTest)  
GROUP BY /*c.ChID,*/ rp.ProdID,m.StockID,/*m.CompID,*/m.DocID,m.ChID,m.EmpID,m.DocDate

SELECT m.OurID, m.StockID, a.SecID, a.ProdID, a.PPID, SUM(a.Qty) Qty, 0 AccQty
    FROM av_t_SRecA a WITH(NOLOCK), r_Prods rp WITH(NOLOCK), av_t_SRec m WITH(NOLOCK)
    WHERE m.ChID = a.ChID AND a.ProdID = rp.ProdID AND (rp.InRems <> 0) AND (m.DocDate BETWEEN @BDate AND @EDate)
      AND m.StockID in (SELECT AValue from zf_FilterToTable(@StockID))
      AND m.OurID in (SELECT AValue FROM dbo.af_GetValidsTable('ValidOurs'))
	  --AND (rp.ProdID = @ProdIDTest)    
    GROUP BY m.OurID, m.StockID, a.SecID, a.ProdID, a.PPID
END

IF 1 = 0 /* Комплектация товара: Заголовок minus*/
BEGIN
SELECT rp.ProdID ProductID,
	--CASE WHEN m.StockID IN (select AValue from zf_FilterToTable(@StockIDNotInCompID)) AND m.CompID NOT IN (select AValue from zf_FilterToTable(@NotInCompID)) THEN @ChangeCompID ELSE c.ChID END 
	0 OutletID,
	m.EmpID TAID, CONVERT(varchar(250),m.DocDate,112) Data, -10 OperationID,m.DocID, m.ChID DocNo,
	-SUM(QTy) Qty, -SUM(d.Qty*tp.CostMC) Summ
FROM Elit.dbo.t_SRec m WITH(NOLOCK)
JOIN Elit.dbo.t_SRecA d WITH(NOLOCK) ON d.ChID=m.ChID
JOIN Elit.dbo.r_Stocks s WITH(NOLOCK) ON s.StockID=m.StockID
JOIN Elit.dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID=d.ProdID AND rp.PGrID1 IN (select AValue from zf_FilterToTable(@PGrID1))
--JOIN Elit.dbo.r_Comps c WITH(NOLOCK) ON c.CompID=m.CompID
JOIN Elit.dbo.t_PInP tp WITH(NOLOCK) ON tp.ProdID=d.ProdID AND tp.PPID=d.PPID
WHERE s.StockID IN (select AValue from zf_FilterToTable(@StockID))
      AND (m.DocDate BETWEEN @BDate AND @EDate)  
      AND (rp.InRems <> 0)
      --AND (rp.ProdID = @ProdIDTest)
GROUP BY /*c.ChID,*/ rp.ProdID,m.StockID,/*m.CompID,*/m.DocID,m.ChID,m.EmpID,m.DocDate

    SELECT m.OurID, m.SubStockID StockID, d.SubSecID SecID, d.SubProdID ProdID, d.SubPPID PPID, -SUM(d.SubQty) Qty, 0 AccQty
    FROM av_t_SRecA a WITH(NOLOCK), av_t_SRecD d WITH(NOLOCK), r_Prods rp WITH(NOLOCK), av_t_SRec m WITH(NOLOCK)
    WHERE m.ChID = a.ChID AND a.AChID = d.AChID AND d.SubProdID = rp.ProdID AND (rp.InRems <> 0) AND (m.DocDate BETWEEN @BDate AND @EDate)
      AND m.SubStockID in (SELECT AValue from zf_FilterToTable(@StockID))
      AND m.OurID in (SELECT AValue FROM dbo.af_GetValidsTable('ValidOurs'))
      --AND (rp.ProdID = @ProdIDTest)  
    GROUP BY m.OurID, m.SubStockID, d.SubSecID, d.SubProdID, d.SubPPID
END

IF 1 = 0 /* Перемещение товара: Заголовок*/
BEGIN
SELECT rp.ProdID ProductID,
	CASE WHEN m.NewStockID IN (select AValue from zf_FilterToTable(@StockIDNotInCompID)) AND m.CompID NOT IN (select AValue from zf_FilterToTable(@NotInCompID)) THEN @ChangeCompID ELSE c.ChID END OutletID,
	m.EmpID TAID, CONVERT(varchar(250),m.DocDate,112) Data, 5 OperationID,m.DocID, m.ChID DocNo,
	SUM(d.Qty) Qty, SUM(d.Qty*tp.CostMC) Summ
FROM Elit.dbo.t_Exc m WITH(NOLOCK)
JOIN Elit.dbo.t_ExcD d WITH(NOLOCK) ON d.ChID=m.ChID
JOIN Elit.dbo.r_Stocks s WITH(NOLOCK) ON s.StockID=m.NewStockID
JOIN Elit.dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID=d.ProdID AND rp.PGrID1 IN (select AValue from zf_FilterToTable(@PGrID1))
JOIN Elit.dbo.r_Comps c WITH(NOLOCK) ON c.CompID=m.CompID
JOIN Elit.dbo.t_PInP tp WITH(NOLOCK) ON tp.ProdID=d.ProdID AND tp.PPID=d.PPID
WHERE s.StockID IN (select AValue from zf_FilterToTable(@StockID))
      AND (m.DocDate BETWEEN @BDate AND @EDate)  
      AND (rp.InRems <> 0)
      --AND (rp.ProdID = @ProdIDTest)  
GROUP BY c.ChID, rp.ProdID,m.NewStockID,m.CompID,m.DocID,m.ChID,m.EmpID,m.DocDate

    SELECT m.OurID, m.NewStockID StockID, d.NewSecID SecID, d.ProdID, d.PPID, SUM(d.Qty) Qty, 0 AccQty
    FROM r_Prods rp WITH(NOLOCK), av_t_ExcD d WITH(NOLOCK), av_t_Exc m WITH(NOLOCK)
    WHERE d.ProdID = rp.ProdID AND m.ChID = d.ChID AND (rp.InRems <> 0) AND (m.DocDate BETWEEN @BDate AND @EDate)
      AND m.NewStockID in (SELECT AValue from zf_FilterToTable(@StockID))
      AND m.OurID in (SELECT AValue FROM dbo.af_GetValidsTable('ValidOurs'))
      --AND (rp.ProdID = @ProdIDTest)
    GROUP BY m.OurID, m.NewStockID, d.NewSecID, d.ProdID, d.PPID
END

IF 1 = 0 /* Перемещение товара: Заголовок minus*/
BEGIN
SELECT rp.ProdID ProductID,
	CASE WHEN m.StockID IN (select AValue from zf_FilterToTable(@StockIDNotInCompID)) AND m.CompID NOT IN (select AValue from zf_FilterToTable(@NotInCompID)) THEN @ChangeCompID ELSE c.ChID END OutletID,
	m.EmpID TAID, CONVERT(varchar(250),m.DocDate,112) Data, 5 OperationID,m.DocID, m.ChID DocNo,
	-SUM(QTy) Qty, -SUM(d.Qty*tp.CostMC) Summ
FROM Elit.dbo.t_Exc m WITH(NOLOCK)
JOIN Elit.dbo.t_ExcD d WITH(NOLOCK) ON d.ChID=m.ChID
JOIN Elit.dbo.r_Stocks s WITH(NOLOCK) ON s.StockID=m.StockID
JOIN Elit.dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID=d.ProdID AND rp.PGrID1 IN (select AValue from zf_FilterToTable(@PGrID1))
JOIN Elit.dbo.r_Comps c WITH(NOLOCK) ON c.CompID=m.CompID
JOIN Elit.dbo.t_PInP tp WITH(NOLOCK) ON tp.ProdID=d.ProdID AND tp.PPID=d.PPID
WHERE s.StockID IN (SELECT AValue from zf_FilterToTable(@StockID))
      AND (m.DocDate BETWEEN @BDate AND @EDate)  
      AND (rp.InRems <> 0)
      --AND (rp.ProdID = @ProdIDTest)
GROUP BY c.ChID, rp.ProdID,m.StockID,m.CompID,m.DocID,m.ChID,m.EmpID,m.DocDate    
    
    SELECT m.OurID, m.StockID, d.SecID, d.ProdID, d.PPID, -SUM(d.Qty) Qty, 0 AccQty
    FROM r_Prods rp WITH(NOLOCK), av_t_ExcD d WITH(NOLOCK), av_t_Exc m WITH(NOLOCK)
    WHERE d.ProdID = rp.ProdID AND m.ChID = d.ChID AND (rp.InRems <> 0) AND (m.DocDate BETWEEN @BDate AND @EDate)
      AND m.StockID in (SELECT AValue from zf_FilterToTable(@StockID))
      AND m.OurID in (SELECT AValue FROM dbo.af_GetValidsTable('ValidOurs'))
      --AND (rp.ProdID = @ProdIDTest)    
    GROUP BY m.OurID, m.StockID, d.SecID, d.ProdID, d.PPID
END

IF 1 = 0 /* Переоценка цен прихода: Заголовок */
BEGIN
SELECT rp.ProdID ProductID,
	CASE WHEN m.StockID IN (select AValue from zf_FilterToTable(@StockIDNotInCompID)) AND m.CompID NOT IN (select AValue from zf_FilterToTable(@NotInCompID)) THEN @ChangeCompID ELSE c.ChID END OutletID,
	m.EmpID TAID, CONVERT(varchar(250),m.DocDate,112) Data, -3 OperationID,m.DocID, m.ChID DocNo,
	SUM(QTy) Qty, SUM(d.Qty*tp.CostMC) Summ
FROM Elit.dbo.t_Est m WITH(NOLOCK)
JOIN Elit.dbo.t_EstD d WITH(NOLOCK) ON d.ChID=m.ChID
JOIN Elit.dbo.r_Stocks s WITH(NOLOCK) ON s.StockID=m.StockID
JOIN Elit.dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID=d.ProdID AND rp.PGrID1 IN (select AValue from zf_FilterToTable(@PGrID1))
JOIN Elit.dbo.r_Comps c WITH(NOLOCK) ON c.CompID=m.CompID
JOIN Elit.dbo.t_PInP tp WITH(NOLOCK) ON tp.ProdID=d.ProdID AND tp.PPID=d.PPID
WHERE s.StockID IN (select AValue from zf_FilterToTable(@StockID))
      AND (m.DocDate BETWEEN @BDate AND @EDate)  
      AND (rp.InRems <> 0)
      --AND (rp.ProdID = @ProdIDTest)  
GROUP BY c.ChID, rp.ProdID,m.StockID,m.CompID,m.DocID,m.ChID,m.EmpID,m.DocDate

    SELECT m.OurID, m.StockID, d.SecID, d.ProdID, d.NewPPID PPID, SUM(d.Qty) Qty, 0 AccQty
    FROM av_t_EstD d WITH(NOLOCK), r_Prods rp WITH(NOLOCK), av_t_Est m WITH(NOLOCK)
    WHERE m.ChID = d.ChID AND d.ProdID = rp.ProdID AND (rp.InRems <> 0) AND (m.DocDate BETWEEN @BDate AND @EDate)
      AND m.StockID in (SELECT AValue from zf_FilterToTable(@StockID))
      AND m.OurID in (SELECT AValue FROM dbo.af_GetValidsTable('ValidOurs'))
      --AND (rp.ProdID = @ProdIDTest)    
    GROUP BY m.OurID, m.StockID, d.SecID, d.ProdID, d.NewPPID
END

IF 1 = 0 /* Переоценка цен прихода: Заголовок minus*/
BEGIN
SELECT rp.ProdID ProductID,
	CASE WHEN m.StockID IN (select AValue from zf_FilterToTable(@StockIDNotInCompID)) AND m.CompID NOT IN (select AValue from zf_FilterToTable(@NotInCompID)) THEN @ChangeCompID ELSE c.ChID END OutletID,
	m.EmpID TAID, CONVERT(varchar(250),m.DocDate,112) Data, -4 OperationID,m.DocID, m.ChID DocNo,
	-SUM(QTy) Qty, -SUM(d.Qty*tp.CostMC) Summ
FROM Elit.dbo.t_Est m WITH(NOLOCK)
JOIN Elit.dbo.t_EstD d WITH(NOLOCK) ON d.ChID=m.ChID
JOIN Elit.dbo.r_Stocks s WITH(NOLOCK) ON s.StockID=m.StockID
JOIN Elit.dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID=d.ProdID AND rp.PGrID1 IN (select AValue from zf_FilterToTable(@PGrID1))
JOIN Elit.dbo.r_Comps c WITH(NOLOCK) ON c.CompID=m.CompID
JOIN Elit.dbo.t_PInP tp WITH(NOLOCK) ON tp.ProdID=d.ProdID AND tp.PPID=d.PPID
WHERE s.StockID IN (SELECT AValue from zf_FilterToTable(@StockID))
      AND (m.DocDate BETWEEN @BDate AND @EDate)  
      AND (rp.InRems <> 0) 
      --AND (rp.ProdID = @ProdIDTest)  
GROUP BY c.ChID, rp.ProdID,m.StockID,m.CompID,m.DocID,m.ChID,m.EmpID,m.DocDate

    SELECT m.OurID, m.StockID, d.SecID, d.ProdID, d.PPID, -SUM(d.Qty) Qty, 0 AccQty
    FROM r_Prods rp WITH(NOLOCK), av_t_EstD d WITH(NOLOCK), av_t_Est m WITH(NOLOCK)
    WHERE d.ProdID = rp.ProdID AND m.ChID = d.ChID AND (rp.InRems <> 0) AND (m.DocDate BETWEEN @BDate AND @EDate)
      AND m.StockID in (SELECT AValue from zf_FilterToTable(@StockID))
      AND m.OurID in (SELECT AValue FROM dbo.af_GetValidsTable('ValidOurs'))  
      --AND (rp.ProdID = @ProdIDTest)    
    GROUP BY m.OurID, m.StockID, d.SecID, d.ProdID, d.PPID
END

IF 1 = 0 /* Приход товара: Заголовок */
BEGIN
SELECT rp.ProdID ProductID,
	CASE WHEN m.StockID IN (select AValue from zf_FilterToTable(@StockIDNotInCompID)) AND m.CompID NOT IN (select AValue from zf_FilterToTable(@NotInCompID)) THEN @ChangeCompID ELSE c.ChID END OutletID,
	m.EmpID TAID, CONVERT(varchar(250),m.DocDate,112) Data, 1 OperationID,m.DocID, m.ChID DocNo, 
	SUM(d.QTy) Qty, SUM(d.Qty*tp.CostMC) Summ 
FROM Elit.dbo.t_Rec m WITH(NOLOCK)
JOIN Elit.dbo.t_RecD d WITH(NOLOCK) ON d.ChID=m.ChID
JOIN Elit.dbo.r_Stocks s WITH(NOLOCK) ON s.StockID=m.StockID
JOIN Elit.dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID=d.ProdID AND rp.PGrID1 IN (select AValue from zf_FilterToTable(@PGrID1))
JOIN Elit.dbo.r_Comps c WITH(NOLOCK) ON c.CompID=m.CompID
JOIN Elit.dbo.t_PInP tp WITH(NOLOCK) ON tp.ProdID=d.ProdID AND tp.PPID=d.PPID
WHERE s.StockID IN (select AValue from zf_FilterToTable(@StockID))
      AND (m.DocDate BETWEEN @BDate AND @EDate)
      AND (rp.InRems <> 0)
      --AND (rp.ProdID = @ProdIDTest)
GROUP BY c.ChID, rp.ProdID,m.StockID,m.CompID,m.DocID,m.ChID,m.EmpID,m.DocDate

SELECT m.OurID, m.StockID, d.SecID, d.ProdID, d.PPID, SUM(d.Qty) Qty, 0 AccQty
    FROM r_Prods rp WITH(NOLOCK), av_t_RecD d WITH(NOLOCK), av_t_Rec m WITH(NOLOCK)
    WHERE d.ProdID = rp.ProdID AND m.ChID = d.ChID AND (rp.InRems <> 0) AND (m.DocDate BETWEEN @BDate AND @EDate)
      AND m.StockID in (SELECT AValue from zf_FilterToTable(@StockID))
      AND m.OurID in (SELECT AValue FROM dbo.af_GetValidsTable('ValidOurs'))
      --AND (rp.ProdID = @ProdIDTest)   
    GROUP BY m.OurID, m.StockID, d.SecID, d.ProdID, d.PPID
END

IF 1 = 0 /* Продажа товара оператором: Заголовок */
BEGIN
SELECT rp.ProdID ProductID,
	CASE WHEN m.StockID IN (select AValue from zf_FilterToTable(@StockIDNotInCompID)) AND m.CompID NOT IN (select AValue from zf_FilterToTable(@NotInCompID)) THEN @ChangeCompID ELSE c.ChID END OutletID,
	m.EmpID TAID, CONVERT(varchar(250),m.DocDate,112) Data, -5 OperationID,m.DocID, m.ChID DocNo,
	-SUM(QTy) Qty, -SUM(d.Qty*tp.CostMC) Summ
FROM Elit.dbo.t_Sale m WITH(NOLOCK)
JOIN Elit.dbo.t_SaleD d WITH(NOLOCK) ON d.ChID=m.ChID
JOIN Elit.dbo.r_Stocks s WITH(NOLOCK) ON s.StockID=m.StockID
JOIN Elit.dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID=d.ProdID AND rp.PGrID1 IN (select AValue from zf_FilterToTable(@PGrID1))
JOIN Elit.dbo.r_Comps c WITH(NOLOCK) ON c.CompID=m.CompID
JOIN Elit.dbo.t_PInP tp WITH(NOLOCK) ON tp.ProdID=d.ProdID AND tp.PPID=d.PPID
WHERE s.StockID IN (SELECT AValue from zf_FilterToTable(@StockID))
      AND (m.DocDate BETWEEN @BDate AND @EDate)  
      AND (rp.InRems <> 0)
      --AND (rp.ProdID = @ProdIDTest)
GROUP BY c.ChID, rp.ProdID,m.StockID,m.CompID,m.DocID,m.ChID,m.EmpID,m.DocDate

    SELECT m.OurID, m.StockID, d.SecID, d.ProdID, d.PPID, -SUM(d.Qty) Qty, 0 AccQty
    FROM r_Prods rp WITH(NOLOCK), av_t_SaleD d WITH(NOLOCK), av_t_Sale m WITH(NOLOCK)
    WHERE d.ProdID = rp.ProdID AND m.ChID = d.ChID AND (rp.InRems <> 0) AND (m.DocDate BETWEEN @BDate AND @EDate)
      AND m.StockID in (SELECT AValue from zf_FilterToTable(@StockID))
      AND m.OurID in (SELECT AValue FROM dbo.af_GetValidsTable('ValidOurs'))
      --AND (rp.ProdID = @ProdIDTest)   
    GROUP BY m.OurID, m.StockID, d.SecID, d.ProdID, d.PPID
END

IF 1 = 0 /* Разукомплектация товара: Заголовок minus*/
BEGIN
SELECT rp.ProdID ProductID,
	--CASE WHEN m.StockID IN (SELECT AValue from zf_FilterToTable(@StockIDNotInCompID)) AND m.CompID NOT IN (SELECT AValue from zf_FilterToTable(@NotInCompID)) THEN @ChangeCompID ELSE c.ChID END 
	0 OutletID,
	m.EmpID TAID, CONVERT(varchar(250),m.DocDate,112) Data, -12 OperationID,m.DocID, m.ChID DocNo,
	-SUM(QTy) Qty, -SUM(d.Qty*tp.CostMC) Summ
FROM Elit.dbo.t_SExp m WITH(NOLOCK)
JOIN Elit.dbo.t_SExpA d WITH(NOLOCK) ON d.ChID=m.ChID
JOIN Elit.dbo.r_Stocks s WITH(NOLOCK) ON s.StockID=m.StockID
JOIN Elit.dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID=d.ProdID AND rp.PGrID1 IN (SELECT AValue from zf_FilterToTable(@PGrID1))
--JOIN Elit.dbo.r_Comps c WITH(NOLOCK) ON c.CompID=m.CompID
JOIN Elit.dbo.t_PInP tp WITH(NOLOCK) ON tp.ProdID=d.ProdID AND tp.PPID=d.PPID
WHERE s.StockID IN (SELECT AValue from zf_FilterToTable(@StockID))
      AND (m.DocDate BETWEEN @BDate AND @EDate)  
      AND (rp.InRems <> 0)
      --AND (rp.ProdID = @ProdIDTest)
GROUP BY /*c.ChID,*/ rp.ProdID,m.StockID,/*m.CompID,*/m.DocID,m.ChID,m.EmpID,m.DocDate

    SELECT m.OurID, m.StockID, a.SecID, a.ProdID, a.PPID, -SUM(a.Qty) Qty, 0 AccQty
    FROM av_t_SExpA a WITH(NOLOCK), r_Prods rp WITH(NOLOCK), av_t_SExp m WITH(NOLOCK)
    WHERE m.ChID = a.ChID AND a.ProdID = rp.ProdID AND (rp.InRems <> 0) AND (m.DocDate BETWEEN @BDate AND @EDate)
      AND m.StockID in (SELECT AValue from zf_FilterToTable(@StockID))
      AND m.OurID in (SELECT AValue FROM dbo.af_GetValidsTable('ValidOurs'))
      --AND (rp.ProdID = @ProdIDTest)    
    GROUP BY m.OurID, m.StockID, a.SecID, a.ProdID, a.PPID
END

IF 1 = 0 /* Разукомплектация товара: Заголовок */
BEGIN
SELECT rp.ProdID ProductID,
	--CASE WHEN m.StockID IN (SELECT AValue from zf_FilterToTable(@StockIDNotInCompID)) AND m.CompID NOT IN (SELECT AValue from zf_FilterToTable(@NotInCompID)) THEN @ChangeCompID ELSE c.ChID END 
	0 OutletID,
	m.EmpID TAID, CONVERT(varchar(250),m.DocDate,112) Data, -11 OperationID,m.DocID, m.ChID DocNo,
	SUM(QTy) Qty, SUM(d.Qty*tp.CostMC) Summ
FROM Elit.dbo.t_SExp m WITH(NOLOCK)
JOIN Elit.dbo.t_SExpA d WITH(NOLOCK) ON d.ChID=m.ChID
JOIN Elit.dbo.r_Stocks s WITH(NOLOCK) ON s.StockID=m.StockID
JOIN Elit.dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID=d.ProdID AND rp.PGrID1 IN (SELECT AValue from zf_FilterToTable(@PGrID1))
--JOIN Elit.dbo.r_Comps c WITH(NOLOCK) ON c.CompID=m.CompID
JOIN Elit.dbo.t_PInP tp WITH(NOLOCK) ON tp.ProdID=d.ProdID AND tp.PPID=d.PPID
WHERE s.StockID IN (SELECT AValue from zf_FilterToTable(@StockID))
      AND (m.DocDate BETWEEN @BDate AND @EDate)  
      AND (rp.InRems <> 0)
      --AND (rp.ProdID = @ProdIDTest)
GROUP BY /*c.ChID,*/ rp.ProdID,m.StockID,/*m.CompID,*/m.DocID,m.ChID,m.EmpID,m.DocDate

    SELECT m.OurID, m.SubStockID StockID, d.SubSecID SecID, d.SubProdID ProdID, d.SubPPID PPID, SUM(d.SubQty) Qty, 0 AccQty
    FROM av_t_SExpA a WITH(NOLOCK), av_t_SExpD d WITH(NOLOCK), r_Prods rp WITH(NOLOCK), av_t_SExp m WITH(NOLOCK)
    WHERE m.ChID = a.ChID AND a.AChID = d.AChID AND d.SubProdID = rp.ProdID AND (rp.InRems <> 0) AND (m.DocDate BETWEEN @BDate AND @EDate)
      AND m.SubStockID in (SELECT AValue from zf_FilterToTable(@StockID))
      AND m.OurID in (SELECT AValue FROM dbo.af_GetValidsTable('ValidOurs'))
      --AND (rp.ProdID = @ProdIDTest)    
    GROUP BY m.OurID, m.SubStockID, d.SubSecID, d.SubProdID, d.SubPPID
END

IF 1 = 0 /* Расходная накладная: Заголовок */
BEGIN
SELECT rp.ProdID ProductID,
	CASE WHEN m.StockID IN (SELECT AValue from zf_FilterToTable(@StockIDNotInCompID)) AND m.CompID NOT IN (SELECT AValue from zf_FilterToTable(@NotInCompID)) THEN @ChangeCompID ELSE c.ChID END OutletID,
	m.EmpID TAID, CONVERT(varchar(250),m.DocDate,112) Data, 3 OperationID,m.DocID, m.ChID DocNo,
	-SUM(QTy) Qty, -SUM(d.Qty*tp.CostMC) Summ
FROM Elit.dbo.t_Inv m WITH(NOLOCK)
JOIN Elit.dbo.t_InvD d WITH(NOLOCK) ON d.ChID=m.ChID
JOIN Elit.dbo.r_Stocks s WITH(NOLOCK) ON s.StockID=m.StockID
JOIN Elit.dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID=d.ProdID AND rp.PGrID1 IN (SELECT AValue from zf_FilterToTable(@PGrID1))
JOIN Elit.dbo.r_Comps c WITH(NOLOCK) ON c.CompID=m.CompID
JOIN Elit.dbo.t_PInP tp WITH(NOLOCK) ON tp.ProdID=d.ProdID AND tp.PPID=d.PPID
WHERE s.StockID IN (SELECT AValue from zf_FilterToTable(@StockID))
      AND (m.DocDate BETWEEN @BDate AND @EDate)  
      AND (rp.InRems <> 0)
      --AND (rp.ProdID = @ProdIDTest) 
GROUP BY c.ChID, rp.ProdID,m.StockID,m.CompID,m.DocID,m.ChID,m.EmpID,m.DocDate

    SELECT m.OurID, m.StockID, d.SecID, d.ProdID, d.PPID, -SUM(d.Qty) Qty, 0 AccQty
    FROM r_Prods rp WITH(NOLOCK), av_t_InvD d WITH(NOLOCK), av_t_Inv m WITH(NOLOCK)
    WHERE d.ProdID = rp.ProdID AND m.ChID = d.ChID AND (rp.InRems <> 0) AND (m.DocDate BETWEEN @BDate AND @EDate)
      AND m.StockID in (SELECT AValue from zf_FilterToTable(@StockID))
      AND m.OurID in (SELECT AValue FROM dbo.af_GetValidsTable('ValidOurs'))
      --AND (rp.ProdID = @ProdIDTest)    
    GROUP BY m.OurID, m.StockID, d.SecID, d.ProdID, d.PPID
END

IF 1 = 0 /* Расходный документ: Заголовок */
BEGIN
SELECT rp.ProdID ProductID,
	CASE WHEN m.StockID IN (SELECT AValue from zf_FilterToTable(@StockIDNotInCompID)) AND m.CompID NOT IN (SELECT AValue from zf_FilterToTable(@NotInCompID)) THEN @ChangeCompID ELSE c.ChID END OutletID,
	m.EmpID TAID, CONVERT(varchar(250),m.DocDate,112) Data, 6 OperationID,m.DocID, m.ChID DocNo,
	-SUM(QTy) Qty, -SUM(d.Qty*tp.CostMC) Summ
FROM Elit.dbo.t_Exp m WITH(NOLOCK)
JOIN Elit.dbo.t_ExpD d WITH(NOLOCK) ON d.ChID=m.ChID
JOIN Elit.dbo.r_Stocks s WITH(NOLOCK) ON s.StockID=m.StockID
JOIN Elit.dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID=d.ProdID AND rp.PGrID1 IN (SELECT AValue from zf_FilterToTable(@PGrID1))
JOIN Elit.dbo.r_Comps c WITH(NOLOCK) ON c.CompID=m.CompID
JOIN Elit.dbo.t_PInP tp WITH(NOLOCK) ON tp.ProdID=d.ProdID AND tp.PPID=d.PPID
WHERE s.StockID IN (SELECT AValue from zf_FilterToTable(@StockID))
      AND (m.DocDate BETWEEN @BDate AND @EDate)  
      AND (rp.InRems <> 0)
      --AND (rp.ProdID = @ProdIDTest)
GROUP BY c.ChID, rp.ProdID,m.StockID,m.CompID,m.DocID,m.ChID,m.EmpID,m.DocDate

    SELECT m.OurID, m.StockID, d.SecID, d.ProdID, d.PPID, -SUM(d.Qty) Qty, 0 AccQty
    FROM r_Prods rp WITH(NOLOCK), av_t_ExpD d WITH(NOLOCK), av_t_Exp m WITH(NOLOCK)
    WHERE d.ProdID = rp.ProdID AND m.ChID = d.ChID AND (rp.InRems <> 0) AND (m.DocDate BETWEEN @BDate AND @EDate)
      AND m.StockID in (SELECT AValue from zf_FilterToTable(@StockID))
      AND m.OurID in (SELECT AValue FROM dbo.af_GetValidsTable('ValidOurs'))
      --AND (rp.ProdID = @ProdIDTest)   
    GROUP BY m.OurID, m.StockID, d.SecID, d.ProdID, d.PPID

END

IF 1 = 0 /* Расходный документ в ценах прихода: Заголовок */
BEGIN
SELECT rp.ProdID ProductID,
	CASE WHEN m.StockID IN (SELECT AValue from zf_FilterToTable(@StockIDNotInCompID)) AND m.CompID NOT IN (SELECT AValue from zf_FilterToTable(@NotInCompID)) THEN @ChangeCompID ELSE c.ChID END OutletID,
	m.EmpID TAID, CONVERT(varchar(250),m.DocDate,112) Data, 6 OperationID,m.DocID, m.ChID DocNo,
	-SUM(d.QTy) Qty, -SUM(d.Qty*tp.CostMC) Summ
FROM Elit.dbo.t_Epp m WITH(NOLOCK)
JOIN Elit.dbo.t_EppD d WITH(NOLOCK) ON d.ChID=m.ChID
JOIN Elit.dbo.r_Stocks s WITH(NOLOCK) ON s.StockID=m.StockID
JOIN Elit.dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID=d.ProdID AND rp.PGrID1 IN (SELECT AValue from zf_FilterToTable(@PGrID1))
JOIN Elit.dbo.r_Comps c WITH(NOLOCK) ON c.CompID=m.CompID
JOIN Elit.dbo.t_PInP tp WITH(NOLOCK) ON tp.ProdID=d.ProdID AND tp.PPID=d.PPID
WHERE s.StockID IN (SELECT AValue from zf_FilterToTable(@StockID))
      AND (m.DocDate BETWEEN @BDate AND @EDate)  
      AND (rp.InRems <> 0)
      --AND (rp.ProdID = @ProdIDTest) 
GROUP BY c.ChID, rp.ProdID,m.StockID,m.CompID,m.DocID,m.ChID,m.EmpID,m.DocDate

    SELECT m.OurID, m.StockID, d.SecID, d.ProdID, d.PPID, -SUM(d.Qty) Qty, 0 AccQty
    FROM r_Prods rp WITH(NOLOCK), av_t_EppD d WITH(NOLOCK), av_t_Epp m WITH(NOLOCK)
    WHERE d.ProdID = rp.ProdID AND m.ChID = d.ChID AND (rp.InRems <> 0) AND (m.DocDate BETWEEN @BDate AND @EDate)
      AND m.StockID in (SELECT AValue from zf_FilterToTable(@StockID))
      AND m.OurID in (SELECT AValue FROM dbo.af_GetValidsTable('ValidOurs'))
      --AND (rp.ProdID = @ProdIDTest)    
    GROUP BY m.OurID, m.StockID, d.SecID, d.ProdID, d.PPID
END

IF 1 = 0 /* Счет на оплату товара: Заголовок */
BEGIN
SELECT rp.ProdID ProductID,
	CASE WHEN m.StockID IN (SELECT AValue from zf_FilterToTable(@StockIDNotInCompID)) AND m.CompID NOT IN (SELECT AValue from zf_FilterToTable(@NotInCompID)) THEN @ChangeCompID ELSE c.ChID END OutletID,
	m.EmpID TAID, CONVERT(varchar(250),m.DocDate,112) Data, -8 OperationID,m.DocID, m.ChID DocNo,
	0 Qty, SUM(d.Qty*tp.CostMC) Summ
FROM Elit.dbo.t_Acc m WITH(NOLOCK)
JOIN Elit.dbo.t_AccD d WITH(NOLOCK) ON d.ChID=m.ChID
JOIN Elit.dbo.r_Stocks s WITH(NOLOCK) ON s.StockID=m.StockID
JOIN Elit.dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID=d.ProdID AND rp.PGrID1 IN (SELECT AValue from zf_FilterToTable(@PGrID1))
JOIN Elit.dbo.r_Comps c WITH(NOLOCK) ON c.CompID=m.CompID
JOIN Elit.dbo.t_PInP tp WITH(NOLOCK) ON tp.ProdID=d.ProdID AND tp.PPID=d.PPID
WHERE s.StockID IN (SELECT AValue from zf_FilterToTable(@StockID))
      AND (m.DocDate BETWEEN @BDate AND @EDate)
      AND (m.ReserveProds <> 0) 
      AND (rp.InRems <> 0)
      --AND (rp.ProdID = @ProdIDTest)
GROUP BY c.ChID, rp.ProdID,m.StockID,m.CompID,m.DocID,m.ChID,m.EmpID,m.DocDate

    SELECT m.OurID, m.StockID, d.SecID, d.ProdID, d.PPID, 0 Qty, SUM(d.Qty) AccQty
    FROM r_Prods rp WITH(NOLOCK), Elit.dbo.t_AccD d WITH(NOLOCK), Elit.dbo.t_Acc m WITH(NOLOCK)
    WHERE d.ProdID = rp.ProdID AND m.ChID = d.ChID AND (rp.InRems <> 0) AND (m.ReserveProds <> 0) AND (m.DocDate BETWEEN @BDate AND @EDate)
      AND m.StockID in (SELECT AValue from zf_FilterToTable(@StockID))
      AND m.OurID in (SELECT AValue FROM dbo.af_GetValidsTable('ValidOurs'))
      --AND (rp.ProdID = @ProdIDTest)    
    GROUP BY m.OurID, m.StockID, d.SecID, d.ProdID, d.PPID
END
