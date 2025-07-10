--exec t_CalcRem

--a_tRem_CheckNegativeRems_IU

/*
insert _Rem
 SELECT * FROM dbo.t_Rem

 SELECT * FROM dbo._Rem
*/


  --DELETE FROM dbo.t_Rem
  --INSERT dbo.t_Rem
SELECT *  FROM dbo.zf_t_CalcRem() cr --where cr.Qty =0 and cr.AccQty <>0
where (cr.Qty - cr.AccQty) <> 0 and cr.Qty <> 0  
  
  SELECT COUNT(*) FROM dbo.t_Rem where (Qty - AccQty) <=0
  31751
  
 --несовподающие остатки 
  SELECT *  FROM dbo.zf_t_CalcRem() cr
  right join dbo.t_Rem tr on tr.ProdID = cr.ProdID and tr.OurID = cr.OurID and tr.SecID = cr.SecID and tr.PPID = cr.PPID and tr.StockID = cr.StockID
  where isnull(cr.Qty,0) <> isnull(tr.Qty,0) or cr.AccQty <> tr.AccQty
 
   
/* обновить несовподающие остатки  
update t_Rem
set Qty = isnull(cr.Qty,0), AccQty = isnull(cr.AccQty,0)
  FROM dbo.zf_t_CalcRem() cr
  right join dbo.t_Rem tr on tr.ProdID = cr.ProdID and tr.OurID = cr.OurID and tr.SecID = cr.SecID and tr.PPID = cr.PPID and tr.StockID = cr.StockID
  where cr.Qty <> tr.Qty or cr.AccQty <> tr.AccQty
 
*/


SELECT * FROM dbo.t_Rem 
except 
SELECT *  FROM dbo.zf_t_CalcRem() cr --where cr.Qty =0 and cr.AccQty <>0
where (cr.Qty - cr.AccQty) <> 0 and cr.Qty <> 0  

SELECT *  FROM dbo.zf_t_CalcRem() cr --where cr.Qty =0 and cr.AccQty <>0
where (cr.Qty - cr.AccQty) <> 0 and cr.Qty <> 0
except
SELECT * FROM dbo.t_Rem 