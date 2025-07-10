CREATE FUNCTION [dbo].[af_CamparyDelivery](
@StockID VARCHAR(MAX)
,@DayPeriod INT
,@EDate smalldatetime
,@PGrID1 VARCHAR(MAX)
,@StockIDNotInCompID VARCHAR(MAX)
,@NotInCompID VARCHAR(MAX)
,@ChangeCompID VARCHAR(MAX)
)
RETURNS @out table(ProductID INT NOT NULL, OutletID INT NOT NULL, TAID INT NOT NULL, Data VARCHAR(250) NOT NULL, OperationID INT NOT NULL, DocID INT NOT NULL, DocNo INT NOT NULL, Qty NUMERIC(38,9) NULL, Summ NUMERIC(38,9) NULL)
AS
BEGIN
/*
SELECT * FROM [dbo].[af_CamparyDelivery]('4,304', 45, null, '20-26', '220,320', '4328,4339,4648,16157,54021,62668,65125,65954,71028,71204', '100014684')

DECLARE 
@StockID VARCHAR(MAX) = '4,304'
,@DayPeriod INT = 45
,@EDate smalldatetime = null
,@PGrID1 VARCHAR(MAX) = '20-26'
,@StockIDNotInCompID VARCHAR(MAX) = '220,320'
,@NotInCompID VARCHAR(MAX) = '4328,4339,4648,16157,54021,62668,65125,65954,71028,71204'
,@ChangeCompID VARCHAR(MAX) = '100014684'
*/

DECLARE @BDate smalldatetime
IF @EDate IS NULL SET @EDate = dbo.zf_GetDate(GETDATE())
IF @DayPeriod IS NULL SET @BDate = '1900-01-01' ELSE SET @BDate = DATEADD(day ,-@DayPeriod,dbo.zf_GetDate(@EDate)) 

  INSERT @out 
  SELECT ProductID, OutletID, TAID , Data, OperationID, DocID, DocNo, Qty, Summ FROM (

  
SELECT p.ProdID ProductID,
	CASE WHEN t.StockID IN (select AValue from zf_FilterToTable(@StockIDNotInCompID)) AND t.CompID NOT IN (select AValue from zf_FilterToTable(@NotInCompID)) THEN @ChangeCompID ELSE c.ChID END OutletID,
	t.EmpID TAID, CONVERT(varchar(250),t.DocDate,112) Data, 1 OperationID,t.DocID, t.ChID DocNo, 
	SUM(d.QTy) Qty, SUM(d.Qty*pp.CostMC) Summ 
FROM Elit.dbo.t_Rec t WITH(NOLOCK)
JOIN Elit.dbo.t_RecD d WITH(NOLOCK) ON d.ChID=t.ChID
JOIN Elit.dbo.r_Stocks s WITH(NOLOCK) ON s.StockID=t.StockID
JOIN Elit.dbo.r_Prods p WITH(NOLOCK) ON p.ProdID=d.ProdID AND p.PGrID1 IN (select AValue from zf_FilterToTable(@PGrID1))
JOIN Elit.dbo.r_Comps c WITH(NOLOCK) ON c.CompID=t.CompID
JOIN Elit.dbo.t_PInP pp WITH(NOLOCK) ON pp.ProdID=d.ProdID AND pp.PPID=d.PPID
WHERE s.StockID IN (select AValue from zf_FilterToTable(@StockID))
      AND (t.DocDate BETWEEN @BDate AND @EDate)
      --AND DATEDIFF(DAY,t.DocDate,@EDate) <= @DayPeriod
GROUP BY c.ChID, p.ProdID,t.StockID,t.CompID,t.DocID,t.ChID,t.EmpID,t.DocDate

  ) q 
  GROUP BY ProductID, OutletID, TAID , Data, OperationID, DocID, DocNo, Qty, Summ
  RETURN

END