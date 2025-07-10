--SELECT 'ProductID'+';'+'OutletID'+';'+'TAID'+';'+'Data'+';'+'OperationID'+';'+'DocID'+';'+'DocNo'+';'+'Qty'+';'+'Summ'  UNION ALL SELECT  cast(ProductID as varchar(250))+';'+cast(OutletID as varchar(250))+';'+cast(TAID as varchar (250))+';'+cast(Data as varchar(250))+';'+cast(OperationID as varchar(250))+';'+cast(DocID as varchar(250))+';'+cast(DocNo as varchar(250))+';'+cast(Qty as varchar(250))+';'+CAST(SUM as varchar(250))  FROM Elit.dbo.tmp_CamparyDelivery4

--SELECT * FROM Elit.dbo.tmp_CamparyDelivery4

--IF OBJECT_ID (N'dbo.tmp_Campary', N'U') IS NOT NULL DROP TABLE dbo.tmp_CamparyDelivery4

select * from dbo.tmp_CamparyDelivery4 d4 where d4.Data like '20180627'
/* Возврат товара от получателя: Заголовок */
SELECT p.ProdID ProductID,
CASE WHEN t.StockID IN (220,320) AND t.CompID NOT IN (4328,4339,4648,16157,54021,62668,65125,65954,71028,71204) THEN '100014684'
       ELSE c.ChID END OutletID,t.EmpID TAID,
       CONVERT(varchar(250),t.DocDate,112) Data,
       1 OperationID,t.DocID, t.ChID DocNo, SUM(QTy) Qty, SUM(d.Qty*pp.CostMC) SUM 
 --INTO dbo.tmp_CamparyDelivery4
FROM Elit.dbo.t_Ret t WITH(NOLOCK)
JOIN Elit.dbo.t_RetD d WITH(NOLOCK) ON d.ChID=t.ChID
JOIN Elit.dbo.r_Stocks s WITH(NOLOCK) ON s.StockID=t.StockID
JOIN Elit.dbo.r_Prods p WITH(NOLOCK) ON p.ProdID=d.ProdID AND p.PGrID1 BETWEEN 20 AND 26
JOIN Elit.dbo.r_Comps c WITH(NOLOCK) ON c.CompID=t.CompID
JOIN Elit.dbo.t_PInP pp WITH(NOLOCK) ON pp.ProdID=d.ProdID AND pp.PPID=d.PPID
WHERE s.StockID IN (4,304/*,11,311,27,327,85,385*/)
      AND DATEDIFF(DAY,t.DocDate,dbo.zf_GetDate(GETDATE())) <= 45 and CONVERT(varchar(250),t.DocDate,112) = '20180627'
GROUP BY c.ChID, p.ProdID,t.StockID,t.CompID,t.DocID,t.ChID,t.EmpID,t.DocDate

--Step 1 Prihod end
UNION ALL

SELECT p.ProdID ProductID,
CASE    WHEN t.StockID IN (220,320) AND t.CompID NOT IN (4328,4339,4648,16157,54021,62668,65125,65954,71028,71204) THEN '100014684'
       ELSE c.ChID END OutletID,
       t.EmpID TAID,
       CONVERT(varchar(250),t.DocDate,112) Data,
       2 OperationID,
       t.DocID, t.ChID DocNo, SUM(QTy) Qty, -SUM(d.Qty*pp.CostMC) --place minus at second SUM 
FROM Elit.dbo.t_CRet t WITH(NOLOCK)
JOIN Elit.dbo.t_CRetD d WITH(NOLOCK) ON d.ChID=t.ChID
JOIN Elit.dbo.r_Stocks s WITH(NOLOCK) ON s.StockID=t.StockID
JOIN Elit.dbo.r_Prods p WITH(NOLOCK) ON p.ProdID=d.ProdID AND p.PGrID1 BETWEEN 20 AND 26
JOIN Elit.dbo.r_Comps c WITH(NOLOCK) ON c.CompID=t.CompID
JOIN Elit.dbo.t_PInP pp WITH(NOLOCK) ON pp.ProdID=d.ProdID AND pp.PPID=d.PPID
WHERE s.StockID IN (4,304/*,11,311,27,327,85,385*/)
      AND DATEDIFF(DAY,t.DocDate,dbo.zf_GetDate(GETDATE()))<=45  and  t.DocDate <= dbo.zf_GetDate(GETDATE())
GROUP BY c.ChID, p.ProdID,t.StockID,t.CompID,t.DocID,t.ChID,t.EmpID,t.DocDate
--Step 2 return product

UNION ALL

SELECT p.ProdID ProductID,
CASE    WHEN t.StockID IN (220,320) AND t.CompID NOT IN (4328,4339,4648,16157,54021,62668,65125,65954,71028,71204) THEN '100014684'
       ELSE c.ChID END OutletID,
       t.EmpID TAID,
       CONVERT(varchar(250),t.DocDate,112) Data,
       3 OperationID,
       t.DocID, t.ChID DocNo, SUM(QTy) Qty, CASE WHEN SUM(SumCC_wt)=0  THEN 0.01 ELSE  SUM(SumCC_wt) END  Summ
FROM Elit.dbo.t_exp t WITH(NOLOCK)
JOIN Elit.dbo.t_expD d WITH(NOLOCK) ON d.ChID=t.ChID
JOIN Elit.dbo.r_Stocks s WITH(NOLOCK) ON s.StockID=t.StockID
JOIN Elit.dbo.r_Prods p WITH(NOLOCK) ON p.ProdID=d.ProdID AND p.PGrID1 BETWEEN 20 AND 26
JOIN Elit.dbo.r_Comps c WITH(NOLOCK) ON c.CompID=t.CompID
JOIN Elit.dbo.t_PInP pp WITH(NOLOCK) ON pp.ProdID=d.ProdID AND pp.PPID=d.PPID
WHERE  s.StockID IN (4,304/*,11,311,27,327,85,385*/)
      AND DATEDIFF(DAY,t.DocDate,dbo.zf_GetDate(GETDATE()))<=45  and  t.DocDate <= dbo.zf_GetDate(GETDATE())and CONVERT(varchar(250),t.DocDate,112) = '20180627'
GROUP BY c.ChID, p.ProdID,t.StockID,t.CompID,t.DocID,t.ChID,t.EmpID,t.DocDate
--Step 3 Otgruzka

UNION ALL

SELECT p.ProdID ProductID,
CASE WHEN t.StockID IN (220,320) AND t.CompID NOT IN (4328,4339,4648,16157,54021,62668,65125,65954,71028,71204) THEN '100014684'
       ELSE c.ChID END OutletID,
       t.EmpID TAID,
       CONVERT(varchar(250),t.DocDate,112) Data,
       3 OperationID,t.DocID, t.ChID DocNo, SUM(QTy) Qty, -SUM(SumCC_wt) SUM -- place minus at second SUM
FROM Elit.dbo.t_Inv t WITH(NOLOCK)
JOIN Elit.dbo.t_InvD d WITH(NOLOCK) ON d.ChID=t.ChID
JOIN Elit.dbo.r_Stocks s WITH(NOLOCK) ON s.StockID=t.StockID
JOIN Elit.dbo.r_Prods p WITH(NOLOCK) ON p.ProdID=d.ProdID AND p.PGrID1 BETWEEN 20 AND 26
JOIN Elit.dbo.r_Comps c WITH(NOLOCK) ON c.CompID=t.CompID
JOIN Elit.dbo.t_PInP pp WITH(NOLOCK) ON pp.ProdID=d.ProdID AND pp.PPID=d.PPID
WHERE s.StockID IN (4,304/*,11,311,27,327,85,385*/)
      AND DATEDIFF(DAY,t.DocDate,dbo.zf_GetDate(GETDATE()))<=45 and   t.DocDate <=dbo.zf_GetDate(GETDATE()) and CONVERT(varchar(250),t.DocDate,112) = '20180627'
GROUP BY c.ChID, p.ProdID,t.StockID,t.CompID,t.DocID,t.ChID,t.EmpID,t.DocDate
--Step 4 return product from narketplace-client on stock

UNION ALL


SELECT p.ProdID ProductID,
CASE  WHEN t.StockID IN (220,320) AND t.CompID NOT IN (4328,4339,4648,16157,54021,62668,65125,65954,71028,71204) THEN '100014684'
       ELSE c.ChID END OutletID,
       t.EmpID TAID,
       CONVERT(varchar(250),t.DocDate,112) Data,4 OperationID, t.DocID, t.ChID DocNo, SUM(QTy) Qty, -SUM(SumCC_wt) SUM
FROM Elit.dbo.t_Ret t WITH(NOLOCK)
JOIN Elit.dbo.t_RetD d WITH(NOLOCK) ON d.ChID=t.ChID
JOIN Elit.dbo.r_Stocks s WITH(NOLOCK) ON s.StockID=t.StockID
JOIN Elit.dbo.r_Prods p WITH(NOLOCK) ON p.ProdID=d.ProdID AND p.PGrID1 BETWEEN 20 AND 26
JOIN Elit.dbo.r_Comps c WITH(NOLOCK) ON c.CompID=t.CompID
JOIN Elit.dbo.t_PInP pp WITH(NOLOCK) ON pp.ProdID=d.ProdID AND pp.PPID=d.PPID
WHERE s.StockID IN (4,304/*,11,311,27,327,85,385*/)
      AND DATEDIFF(DAY,t.DocDate,dbo.zf_GetDate(GETDATE()))<=45  and  t.DocDate <= dbo.zf_GetDate(GETDATE()) and CONVERT(varchar(250),t.DocDate,112) = '20180627'
GROUP BY c.ChID, p.ProdID,t.StockID,t.CompID,t.DocID,t.ChID,t.EmpID,t.DocDate

SELECT * FROM dbo.tmp_Campary where data = '2018-06-27'
select'ProductID'+';'+'Data'+';'+'Qty'+';'+'Summ' UNION All  select cast(ProductID as varchar(250))+';'+CONVERT( varchar, Data, 112)+';'+cast(Qty as varchar (250))+';'+cast(Summ as varchar (250)) from Elit.dbo.tmp_Campary where StockID in (85,385)