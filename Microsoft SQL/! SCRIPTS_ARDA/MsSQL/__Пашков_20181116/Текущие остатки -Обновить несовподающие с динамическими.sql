--несовподающие остатки 
  SELECT *  FROM dbo.zf_t_CalcRem() cr
  right join dbo.t_Rem tr on tr.ProdID = cr.ProdID and tr.OurID = cr.OurID and tr.SecID = cr.SecID and tr.PPID = cr.PPID and tr.StockID = cr.StockID
  where isnull(cr.Qty,0) <> isnull(tr.Qty,0) or cr.AccQty <> tr.AccQty
 
  SELECT *  FROM dbo.zf_t_CalcRem() cr
  right join dbo.t_Rem tr on tr.ProdID = cr.ProdID and tr.OurID = cr.OurID and tr.SecID = cr.SecID and tr.PPID = cr.PPID and tr.StockID = cr.StockID
  where cr.Qty <> tr.Qty or cr.AccQty <> tr.AccQty
   
/* обновить несовподающие текущие остатки  
update t_Rem
set Qty = isnull(cr.Qty,0), AccQty = isnull(cr.AccQty,0)
  FROM dbo.zf_t_CalcRem() cr
  right join dbo.t_Rem tr on tr.ProdID = cr.ProdID and tr.OurID = cr.OurID and tr.SecID = cr.SecID and tr.PPID = cr.PPID and tr.StockID = cr.StockID
  where cr.Qty <> tr.Qty or cr.AccQty <> tr.AccQty
 
*/
/*
SELECT * FROM r_Prods where ProdID = 611055

SELECT * FROM t_Rem where ProdID = 30691 ORDER BY 1,2

SELECT * FROM t_Rem where Qty < AccQty and AccQty <> 0

SELECT * FROM t_Rem where ppid = 0 and Qty <> 0

SELECT * FROM z_LogAU ORDER BY 2 desc

SELECT * FROM r_Users where USERID  in (14,1871,1881,1424,1872,1862)

SELECT * FROM r_Emps where EmpID in (10068,1074,10564,10085,10600,10546)

*/