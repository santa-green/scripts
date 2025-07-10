--несовподающие остатки 
  SELECT *  FROM dbo.zf_t_CalcRem() cr
  right join dbo.t_Rem tr on tr.ProdID = cr.ProdID and tr.OurID = cr.OurID and tr.SecID = cr.SecID and tr.PPID = cr.PPID and tr.StockID = cr.StockID
  where isnull(cr.Qty,0) <> isnull(tr.Qty,0) or isnull(cr.AccQty,0) <> isnull(tr.AccQty,0)
 
  SELECT *  FROM dbo.zf_t_CalcRem() cr
  right join dbo.t_Rem tr on tr.ProdID = cr.ProdID and tr.OurID = cr.OurID and tr.SecID = cr.SecID and tr.PPID = cr.PPID and tr.StockID = cr.StockID
  where cr.Qty <> tr.Qty or cr.AccQty <> tr.AccQty
 
 /* обновить несовподающие текущие остатки 
update t_Rem
set Qty = isnull(cr.Qty,0), AccQty = isnull(cr.AccQty,0)
  FROM dbo.zf_t_CalcRem() cr
  right join dbo.t_Rem tr on tr.ProdID = cr.ProdID and tr.OurID = cr.OurID and tr.SecID = cr.SecID and tr.PPID = cr.PPID and tr.StockID = cr.StockID
  where cr.Qty <> tr.Qty or cr.AccQty <> tr.AccQty

 SELECT * FROM   t_Rem where 
 exists( 
 SELECT * FROM (
  SELECT tr.*  FROM dbo.zf_t_CalcRem() cr
  right join dbo.t_Rem tr on tr.ProdID = cr.ProdID and tr.OurID = cr.OurID and tr.SecID = cr.SecID and tr.PPID = cr.PPID and tr.StockID = cr.StockID
  where isnull(cr.Qty,0) <> isnull(tr.Qty,0) or cr.AccQty <> tr.AccQty
  ) n where t_Rem.OurID = n.OurID and  t_Rem.StockID = n.StockID and  t_Rem.SecID = n.SecID and  t_Rem.ProdID = n.ProdID and  t_Rem.PPID = n.PPID and  t_Rem.Qty = n.Qty and  t_Rem.AccQty = n.AccQty
)

 delete t_Rem  where 
 exists( 
 SELECT * FROM (
  SELECT tr.*  FROM dbo.zf_t_CalcRem() cr
  right join dbo.t_Rem tr on tr.ProdID = cr.ProdID and tr.OurID = cr.OurID and tr.SecID = cr.SecID and tr.PPID = cr.PPID and tr.StockID = cr.StockID
  where isnull(cr.Qty,0) <> isnull(tr.Qty,0) or cr.AccQty <> tr.AccQty
  ) n where t_Rem.OurID = n.OurID and  t_Rem.StockID = n.StockID and  t_Rem.SecID = n.SecID and  t_Rem.ProdID = n.ProdID and  t_Rem.PPID = n.PPID and  t_Rem.Qty = n.Qty and  t_Rem.AccQty = n.AccQty
)
*/
 
 /* для Elit
--блокируем изменение остатков
ALTER TABLE t_Rem
ENABLE TRIGGER a_tRem_ChangeDenied_IUD

IF OBJECT_ID (N'tempdb..#CalcRem', N'U') IS NOT NULL DROP TABLE #CalcRem
SELECT * into #CalcRem FROM dbo.zf_t_CalcRem()

IF OBJECT_ID (N'tempdb..#Rem', N'U') IS NOT NULL DROP TABLE #Rem
SELECT * into #Rem FROM dbo.t_Rem

--отменяем блокировку изменения остатков
ALTER TABLE t_Rem
DISABLE TRIGGER a_tRem_ChangeDenied_IUD

SELECT *, (SELECT UserName FROM r_Users u WITH(NOLOCK) WHERE u.UserID = m.UserCode ) FROM z_LogAU m ORDER BY 2 desc

*/

IF OBJECT_ID (N'tempdb..#CalcRem', N'U') IS NOT NULL DROP TABLE #CalcRem
SELECT * into #CalcRem FROM dbo.zf_t_CalcRem()

IF OBJECT_ID (N'tempdb..#Rem', N'U') IS NOT NULL DROP TABLE #Rem
SELECT * into #Rem FROM dbo.t_Rem



SELECT * FROM #CalcRem WITH (NOLOCK)
SELECT sum(Qty) FROM #CalcRem WITH (NOLOCK) --238950.341822333
SELECT count(*) FROM #CalcRem WITH (NOLOCK) --1444843
SELECT sum(Qty) FROM #Rem WITH (NOLOCK) --238950.341822333
SELECT count(*) FROM #Rem WITH (NOLOCK) --1445256

SELECT *  FROM #CalcRem where not (Qty = 0 and AccQty = 0)
SELECT *  FROM #Rem where not (Qty = 0 and AccQty = 0)


SELECT * FROM #CalcRem cr  WITH (NOLOCK) 
LEFT JOIN dbo.#Rem tr  WITH (NOLOCK) on tr.ProdID = cr.ProdID and tr.OurID = cr.OurID and tr.SecID = cr.SecID and tr.PPID = cr.PPID and tr.StockID = cr.StockID
where isnull(cr.Qty,0) <> isnull(tr.Qty,0) or isnull(cr.AccQty,0) <> isnull(tr.AccQty,0)

SELECT * FROM #Rem cr  WITH (NOLOCK) 
LEFT JOIN dbo.#CalcRem tr  WITH (NOLOCK) on tr.ProdID = cr.ProdID and tr.OurID = cr.OurID and tr.SecID = cr.SecID and tr.PPID = cr.PPID and tr.StockID = cr.StockID
where isnull(cr.Qty,0) <> isnull(tr.Qty,0) or isnull(cr.AccQty,0) <> isnull(tr.AccQty,0)

SELECT *  FROM #CalcRem --where not (Qty = 0 and AccQty = 0)
except
SELECT *  FROM #Rem --where not (Qty = 0 and AccQty = 0)
except
SELECT *  FROM #CalcRem

/* обновить несовподающие текущие остатки по #CalcRem
update t_Rem
set Qty = isnull(cr.Qty,0), AccQty = isnull(cr.AccQty,0)
  FROM #CalcRem cr
  right join #Rem tr on tr.ProdID = cr.ProdID and tr.OurID = cr.OurID and tr.SecID = cr.SecID and tr.PPID = cr.PPID and tr.StockID = cr.StockID
  where cr.Qty <> tr.Qty or cr.AccQty <> tr.AccQty

 SELECT * FROM   t_Rem where 
 exists( 
 SELECT * FROM (
  SELECT tr.*  FROM #CalcRem cr
  right join #Rem tr on tr.ProdID = cr.ProdID and tr.OurID = cr.OurID and tr.SecID = cr.SecID and tr.PPID = cr.PPID and tr.StockID = cr.StockID
  where isnull(cr.Qty,0) <> isnull(tr.Qty,0) or cr.AccQty <> tr.AccQty
  ) n where t_Rem.OurID = n.OurID and  t_Rem.StockID = n.StockID and  t_Rem.SecID = n.SecID and  t_Rem.ProdID = n.ProdID and  t_Rem.PPID = n.PPID and  t_Rem.Qty = n.Qty and  t_Rem.AccQty = n.AccQty
)

 delete t_Rem  where 
 exists( 
 SELECT * FROM (
  SELECT tr.*  FROM #CalcRem cr
  right join #Rem tr on tr.ProdID = cr.ProdID and tr.OurID = cr.OurID and tr.SecID = cr.SecID and tr.PPID = cr.PPID and tr.StockID = cr.StockID
  where isnull(cr.Qty,0) <> isnull(tr.Qty,0) or cr.AccQty <> tr.AccQty
  ) n where t_Rem.OurID = n.OurID and  t_Rem.StockID = n.StockID and  t_Rem.SecID = n.SecID and  t_Rem.ProdID = n.ProdID and  t_Rem.PPID = n.PPID and  t_Rem.Qty = n.Qty and  t_Rem.AccQty = n.AccQty
)

delete t_Rem  where Qty = 0 and AccQty = 0
*/

/* 
--Расчет текущих остатков
EXEC dbo.t_CalcRem

[a_tRem_ChangeDenied_IUD] -- для блокировки остатков

 SELECT * FROM t_Rem ORDER BY 7 desc

SELECT * FROM r_Prods where ProdID = 611055

SELECT * FROM t_Rem where ProdID = 33213 ORDER BY 1,2
SELECT * FROM #CalcRem where ProdID = 33213 ORDER BY 1,2

SELECT * FROM t_Rem where Qty < AccQty and AccQty <> 0

SELECT * FROM t_Rem where ppid = 0 and Qty <> 0

SELECT * FROM z_LogAU ORDER BY 2 desc

SELECT * FROM r_Users where USERID  in (14,1871,1881,1424,1872,1862)

SELECT * FROM r_Emps where EmpID in (10068,1074,10564,10085,10600,10546)

SELECT * FROM dbo.t_Rem tr where tr.AccQty <> 0
 

for Elit
Elit.dbo.ap_CalcRemIM --Расчёт промежуточных остатков (на конец каждого месяца)
ap_CalcRemByRemIM --Расчёт текущих остатков
*/