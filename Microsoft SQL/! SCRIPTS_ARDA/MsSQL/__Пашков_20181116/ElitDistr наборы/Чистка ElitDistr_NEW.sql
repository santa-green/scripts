USE [ElitDistr_NEW]

truncate table z_LogDelete
truncate table z_LogUpdate
truncate table z_LogCreate
drop table [t_PInP_не то]
drop table t_PInP_D

BEGIN TRAN

--обновить несовподающие текущие остатки  
update t_Rem
set Qty = isnull(cr.Qty,0), AccQty = isnull(cr.AccQty,0)
  FROM dbo.zf_t_CalcRem() cr
  right join dbo.t_Rem tr on tr.ProdID = cr.ProdID and tr.OurID = cr.OurID and tr.SecID = cr.SecID and tr.PPID = cr.PPID and tr.StockID = cr.StockID
  where isnull(cr.Qty,0) <> isnull(tr.Qty,0) or cr.AccQty <> tr.AccQty
  
SELECT *  FROM dbo.zf_t_CalcRem() cr
right join dbo.t_Rem tr on tr.ProdID = cr.ProdID and tr.OurID = cr.OurID and tr.SecID = cr.SecID and tr.PPID = cr.PPID and tr.StockID = cr.StockID
where isnull(cr.Qty,0) <> isnull(tr.Qty,0) or cr.AccQty <> tr.AccQty
  
SELECT COUNT(*) FROM t_Ret 
SELECT COUNT(*) FROM t_CRRet 
SELECT COUNT(*) FROM t_CRet 
SELECT COUNT(*) FROM t_zInP 
SELECT COUNT(*) FROM at_t_IORes 
SELECT COUNT(*) FROM t_Ven 
SELECT COUNT(*) FROM t_SRec 
SELECT COUNT(*) FROM t_Exc
SELECT COUNT(*) FROM t_Est
SELECT COUNT(*) FROM t_Rec
SELECT COUNT(*) FROM t_Cst
SELECT COUNT(*) FROM t_Sale
SELECT COUNT(*) FROM t_SExp
SELECT COUNT(*) FROM t_Exp
SELECT COUNT(*) FROM t_Epp
SELECT COUNT(*) FROM t_Acc
SELECT COUNT(*) FROM t_Inv
SELECT COUNT(*) FROM t_PInP

SELECT COUNT(*) FROM t_PInP where PPID <> 0

SELECT * FROM t_rem ORDER BY 6 desc ,7 desc


DELETE t_Ret 
go 
DELETE t_CRRet 
go 
DELETE t_CRet 
go 
DELETE t_zInP 
go 
DELETE at_t_IORes 
go 
DELETE t_Ven 
go 
DELETE t_SRec 
go 
DELETE t_Exc
go 
DELETE t_Est
go 
DELETE t_Rec
go 
DELETE t_Cst
go 
DELETE t_Sale
go 
DELETE t_SExp
go 
DELETE t_Exp
go 
DELETE t_Epp
go 
DELETE t_Acc
go
DELETE t_Inv
go
;DISABLE TRIGGER ALL ON t_PInP; delete t_PInP where PPID <> 0;ENABLE  TRIGGER ALL ON t_PInP; 
go

SELECT COUNT(*) FROM t_Ret 
SELECT COUNT(*) FROM t_CRRet 
SELECT COUNT(*) FROM t_CRet 
SELECT COUNT(*) FROM t_zInP 
SELECT COUNT(*) FROM at_t_IORes 
SELECT COUNT(*) FROM t_Ven 
SELECT COUNT(*) FROM t_SRec 
SELECT COUNT(*) FROM t_Exc
SELECT COUNT(*) FROM t_Est
SELECT COUNT(*) FROM t_Rec
SELECT COUNT(*) FROM t_Cst
SELECT COUNT(*) FROM t_Sale
SELECT COUNT(*) FROM t_SExp
SELECT COUNT(*) FROM t_Exp
SELECT COUNT(*) FROM t_Epp
SELECT COUNT(*) FROM t_Acc
SELECT COUNT(*) FROM t_Inv
SELECT COUNT(*) FROM t_PInP


SELECT * FROM t_rem ORDER BY 6 desc ,7 desc


SELECT COUNT(*) FROM t_Retd 
SELECT COUNT(*) FROM t_CRRetd 
SELECT COUNT(*) FROM t_CRetd 
SELECT COUNT(*) FROM t_zInP 
SELECT COUNT(*) FROM at_t_IOResd 
SELECT COUNT(*) FROM t_Vend
SELECT COUNT(*) FROM t_SRecd
SELECT COUNT(*) FROM t_Excd
SELECT COUNT(*) FROM t_Estd
SELECT COUNT(*) FROM t_Recd
SELECT COUNT(*) FROM t_Cstd
SELECT COUNT(*) FROM t_Saled
SELECT COUNT(*) FROM t_SExpd
SELECT COUNT(*) FROM t_Expd
SELECT COUNT(*) FROM t_Eppd
SELECT COUNT(*) FROM t_Accd
SELECT COUNT(*) FROM t_Invd


SELECT *  FROM dbo.zf_t_CalcRem()

ROLLBACK TRAN

--Сжать базу 
DBCC SHRINKDATABASE ([ElitDistr_NEW])
      
