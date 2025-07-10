
--ALTER FUNCTION [dbo].[zf_t_CalcRemByDateDate](
DECLARE @BDate smalldatetime = '2017-12-31', @EDate smalldatetime = '2017-12-31'
DECLARE @ProdID VARCHAR(MAX) = '803353' --код товаров

declare @out table(OurID int NULL, StockID int NULL, SecID int NULL, ProdID int NULL, PPID int NULL, Qty numeric(21, 9) NULL, AccQty numeric(21, 9) NULL)


--BEGIN
  IF @BDate IS NULL SET @BDate = '1900-01-01'
  IF @EDate IS NULL SET @EDate = '2079-06-06'

  --INSERT @out 
  --SELECT OurID, StockID, SecID, ProdID, PPID, SUM(Qty), SUM(AccQty) FROM (

select 'Возврат товара от получателя: Заголовок '
    SELECT DISTINCT t_Ret.OurID OurID, t_Ret.StockID StockID, t_RetD.SecID SecID, t_RetD.ProdID ProdID, t_RetD.PPID PPID, SUM(t_RetD.Qty) Qty, 0 AccQty    FROM r_Prods WITH (NOLOCK), t_RetD WITH (NOLOCK), t_Ret WITH(NOLOCK)     WHERE t_RetD.ProdID = r_Prods.ProdID AND t_Ret.ChID = t_RetD.ChID AND (r_Prods.InRems <> 0) AND (t_Ret.DocDate BETWEEN @BDate AND @EDate)
	AND ((0 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ) OR ( (SELECT [dbo].[zf_MatchFilterInt](r_Prods.ProdID,@ProdID,',')) = 1 and 1 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ))
    GROUP BY t_Ret.OurID, t_Ret.StockID, t_RetD.SecID, t_RetD.ProdID, t_RetD.PPID

  --UNION ALL 

select 'Возврат товара по чеку: Заголовок '
    SELECT DISTINCT t_CRRet.OurID OurID, t_CRRet.StockID StockID, t_CRRetD.SecID SecID, t_CRRetD.ProdID ProdID, t_CRRetD.PPID PPID, SUM(t_CRRetD.Qty) Qty, 0 AccQty    FROM r_Prods WITH (NOLOCK), t_CRRetD WITH (NOLOCK), t_CRRet WITH(NOLOCK)     WHERE t_CRRetD.ProdID = r_Prods.ProdID AND t_CRRet.ChID = t_CRRetD.ChID AND (r_Prods.InRems <> 0) AND (t_CRRet.DocDate BETWEEN @BDate AND @EDate)
	AND ((0 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ) OR ( (SELECT [dbo].[zf_MatchFilterInt](r_Prods.ProdID,@ProdID,',')) = 1 and 1 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ))
    GROUP BY t_CRRet.OurID, t_CRRet.StockID, t_CRRetD.SecID, t_CRRetD.ProdID, t_CRRetD.PPID

  --UNION ALL 

select 'Возврат товара поставщику: Заголовок '
    SELECT DISTINCT t_CRet.OurID OurID, t_CRet.StockID StockID, t_CRetD.SecID SecID, t_CRetD.ProdID ProdID, t_CRetD.PPID PPID, -SUM(t_CRetD.Qty) Qty, 0 AccQty    FROM r_Prods WITH (NOLOCK), t_CRetD WITH (NOLOCK), t_CRet WITH(NOLOCK)     WHERE t_CRetD.ProdID = r_Prods.ProdID AND t_CRet.ChID = t_CRetD.ChID AND (r_Prods.InRems <> 0) AND (t_CRet.DocDate BETWEEN @BDate AND @EDate)
	AND ((0 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ) OR ( (SELECT [dbo].[zf_MatchFilterInt](r_Prods.ProdID,@ProdID,',')) = 1 and 1 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ))
    GROUP BY t_CRet.OurID, t_CRet.StockID, t_CRetD.SecID, t_CRetD.ProdID, t_CRetD.PPID

  --UNION ALL 

select 'Входящие остатки товара '
    SELECT DISTINCT t_zInP.OurID OurID, t_zInP.StockID StockID, t_zInP.SecID SecID, t_zInP.ProdID ProdID, t_zInP.PPID PPID, SUM(t_zInP.Qty) Qty, 0 AccQty    FROM r_Prods WITH (NOLOCK), t_PInP WITH (NOLOCK), t_zInP WITH(NOLOCK)     WHERE t_PInP.ProdID = r_Prods.ProdID AND t_zInP.ProdID = t_PInP.ProdID AND t_zInP.PPID = t_PInP.PPID AND (r_Prods.InRems <> 0)
	AND ((0 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ) OR ( (SELECT [dbo].[zf_MatchFilterInt](r_Prods.ProdID,@ProdID,',')) = 1 and 1 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ))
    GROUP BY t_zInP.OurID, t_zInP.StockID, t_zInP.SecID, t_zInP.ProdID, t_zInP.PPID

  --UNION ALL 

select 'Заказ внутренний: Резерв: Заголовок '
    SELECT DISTINCT at_t_IORes.OurID OurID, at_t_IORes.StockID StockID, at_t_IOResD.SecID SecID, at_t_IOResD.ProdID ProdID, at_t_IOResD.PPID PPID, 0 Qty, SUM(at_t_IOResD.Qty) AccQty    FROM r_Prods WITH (NOLOCK), at_t_IOResD WITH (NOLOCK), at_t_IORes WITH(NOLOCK)     WHERE at_t_IOResD.ProdID = r_Prods.ProdID AND at_t_IORes.ChID = at_t_IOResD.ChID AND (r_Prods.InRems <> 0) AND (at_t_IORes.ReserveProds <> 0) AND (at_t_IORes.DocDate BETWEEN @BDate AND @EDate)
 	AND ((0 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ) OR ( (SELECT [dbo].[zf_MatchFilterInt](r_Prods.ProdID,@ProdID,',')) = 1 and 1 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ))
   GROUP BY at_t_IORes.OurID, at_t_IORes.StockID, at_t_IOResD.SecID, at_t_IOResD.ProdID, at_t_IOResD.PPID

  --UNION ALL 

select 'Инвентаризация товара: Заголовок '
    SELECT DISTINCT t_Ven.OurID OurID, t_Ven.StockID StockID, t_VenD.SecID SecID, t_VenA.ProdID ProdID, t_VenD.PPID PPID, SUM(t_VenD.NewQty) Qty, 0 AccQty    FROM r_Prods WITH (NOLOCK), t_PInP WITH (NOLOCK), t_VenA WITH (NOLOCK), t_VenD WITH (NOLOCK), t_Ven WITH(NOLOCK)     WHERE t_PInP.ProdID = r_Prods.ProdID AND t_VenD.DetProdID = t_PInP.ProdID AND t_VenD.PPID = t_PInP.PPID AND t_Ven.ChID = t_VenA.ChID AND t_VenA.ChID = t_VenD.ChID AND t_VenA.ProdID = t_VenD.DetProdID AND (r_Prods.InRems <> 0) AND (t_Ven.DocDate BETWEEN @BDate AND @EDate)
	AND ((0 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ) OR ( (SELECT [dbo].[zf_MatchFilterInt](r_Prods.ProdID,@ProdID,',')) = 1 and 1 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ))
    GROUP BY t_Ven.OurID, t_Ven.StockID, t_VenD.SecID, t_VenA.ProdID, t_VenD.PPID

  --UNION ALL 

select 'Инвентаризация товара: Заголовок '
    SELECT DISTINCT t_Ven.OurID OurID, t_Ven.StockID StockID, t_VenD.SecID SecID, t_VenA.ProdID ProdID, t_VenD.PPID PPID, -SUM(t_VenD.Qty) Qty, 0 AccQty    FROM r_Prods WITH (NOLOCK), t_PInP WITH (NOLOCK), t_VenA WITH (NOLOCK), t_VenD WITH (NOLOCK), t_Ven WITH(NOLOCK)     WHERE t_PInP.ProdID = r_Prods.ProdID AND t_VenD.DetProdID = t_PInP.ProdID AND t_VenD.PPID = t_PInP.PPID AND t_Ven.ChID = t_VenA.ChID AND t_VenA.ChID = t_VenD.ChID AND t_VenA.ProdID = t_VenD.DetProdID AND (r_Prods.InRems <> 0) AND (t_Ven.DocDate BETWEEN @BDate AND @EDate)
 	AND ((0 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ) OR ( (SELECT [dbo].[zf_MatchFilterInt](r_Prods.ProdID,@ProdID,',')) = 1 and 1 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ))
   GROUP BY t_Ven.OurID, t_Ven.StockID, t_VenD.SecID, t_VenA.ProdID, t_VenD.PPID

  --UNION ALL 

select 'Комплектация товара: Заголовок '
    SELECT DISTINCT t_SRec.OurID OurID, t_SRec.StockID StockID, t_SRecA.SecID SecID, t_SRecA.ProdID ProdID, t_SRecA.PPID PPID, SUM(t_SRecA.Qty) Qty, 0 AccQty    FROM t_SRecA WITH (NOLOCK), r_Prods WITH (NOLOCK), t_SRec WITH(NOLOCK)     WHERE t_SRec.ChID = t_SRecA.ChID AND t_SRecA.ProdID = r_Prods.ProdID AND (r_Prods.InRems <> 0) AND (t_SRec.DocDate BETWEEN @BDate AND @EDate)
 	AND ((0 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ) OR ( (SELECT [dbo].[zf_MatchFilterInt](r_Prods.ProdID,@ProdID,',')) = 1 and 1 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ))
   GROUP BY t_SRec.OurID, t_SRec.StockID, t_SRecA.SecID, t_SRecA.ProdID, t_SRecA.PPID

  --UNION ALL 

select 'Комплектация товара: Заголовок '
    SELECT DISTINCT t_SRec.OurID OurID, t_SRec.SubStockID StockID, t_SRecD.SubSecID SecID, t_SRecD.SubProdID ProdID, t_SRecD.SubPPID PPID, -SUM(t_SRecD.SubQty) Qty, 0 AccQty    FROM t_SRecA WITH (NOLOCK), t_SRecD WITH (NOLOCK), r_Prods WITH (NOLOCK), t_SRec WITH(NOLOCK)     WHERE t_SRec.ChID = t_SRecA.ChID AND t_SRecA.AChID = t_SRecD.AChID AND t_SRecD.SubProdID = r_Prods.ProdID AND (r_Prods.InRems <> 0) AND (t_SRec.DocDate BETWEEN @BDate AND @EDate)
  	AND ((0 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ) OR ( (SELECT [dbo].[zf_MatchFilterInt](r_Prods.ProdID,@ProdID,',')) = 1 and 1 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ))
  GROUP BY t_SRec.OurID, t_SRec.SubStockID, t_SRecD.SubSecID, t_SRecD.SubProdID, t_SRecD.SubPPID

  --UNION ALL 

select 'Перемещение товара: Заголовок '
    SELECT DISTINCT t_Exc.OurID OurID, t_Exc.NewStockID StockID, t_ExcD.NewSecID SecID, t_ExcD.ProdID ProdID, t_ExcD.PPID PPID, SUM(t_ExcD.Qty) Qty, 0 AccQty    FROM r_Prods WITH (NOLOCK), t_ExcD WITH (NOLOCK), t_Exc WITH(NOLOCK)     WHERE t_ExcD.ProdID = r_Prods.ProdID AND t_Exc.ChID = t_ExcD.ChID AND (r_Prods.InRems <> 0) AND (t_Exc.DocDate BETWEEN @BDate AND @EDate)
 	AND ((0 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ) OR ( (SELECT [dbo].[zf_MatchFilterInt](r_Prods.ProdID,@ProdID,',')) = 1 and 1 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ))
   GROUP BY t_Exc.OurID, t_Exc.NewStockID, t_ExcD.NewSecID, t_ExcD.ProdID, t_ExcD.PPID

  --UNION ALL 

select 'Перемещение товара: Заголовок '
    SELECT DISTINCT t_Exc.OurID OurID, t_Exc.StockID StockID, t_ExcD.SecID SecID, t_ExcD.ProdID ProdID, t_ExcD.PPID PPID, -SUM(t_ExcD.Qty) Qty, 0 AccQty    FROM r_Prods WITH (NOLOCK), t_ExcD WITH (NOLOCK), t_Exc WITH(NOLOCK)     WHERE t_ExcD.ProdID = r_Prods.ProdID AND t_Exc.ChID = t_ExcD.ChID AND (r_Prods.InRems <> 0) AND (t_Exc.DocDate BETWEEN @BDate AND @EDate)
 	AND ((0 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ) OR ( (SELECT [dbo].[zf_MatchFilterInt](r_Prods.ProdID,@ProdID,',')) = 1 and 1 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ))
   GROUP BY t_Exc.OurID, t_Exc.StockID, t_ExcD.SecID, t_ExcD.ProdID, t_ExcD.PPID

  --UNION ALL 

select 'Переоценка цен прихода: Заголовок '
    SELECT DISTINCT t_Est.OurID OurID, t_Est.StockID StockID, t_EstD.SecID SecID, t_EstD.ProdID ProdID, t_EstD.NewPPID PPID, SUM(t_EstD.Qty) Qty, 0 AccQty    FROM t_EstD WITH (NOLOCK), r_Prods WITH (NOLOCK), t_Est WITH(NOLOCK)     WHERE t_Est.ChID = t_EstD.ChID AND t_EstD.ProdID = r_Prods.ProdID AND (r_Prods.InRems <> 0) AND (t_Est.DocDate BETWEEN @BDate AND @EDate)
 	AND ((0 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ) OR ( (SELECT [dbo].[zf_MatchFilterInt](r_Prods.ProdID,@ProdID,',')) = 1 and 1 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ))
   GROUP BY t_Est.OurID, t_Est.StockID, t_EstD.SecID, t_EstD.ProdID, t_EstD.NewPPID

  --UNION ALL 

select 'Переоценка цен прихода: Заголовок '
    SELECT DISTINCT t_Est.OurID OurID, t_Est.StockID StockID, t_EstD.SecID SecID, t_EstD.ProdID ProdID, t_EstD.PPID PPID, -SUM(t_EstD.Qty) Qty, 0 AccQty    FROM r_Prods WITH (NOLOCK), t_EstD WITH (NOLOCK), t_Est WITH(NOLOCK)     WHERE t_EstD.ProdID = r_Prods.ProdID AND t_Est.ChID = t_EstD.ChID AND (r_Prods.InRems <> 0) AND (t_Est.DocDate BETWEEN @BDate AND @EDate)
	AND ((0 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ) OR ( (SELECT [dbo].[zf_MatchFilterInt](r_Prods.ProdID,@ProdID,',')) = 1 and 1 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ))
    GROUP BY t_Est.OurID, t_Est.StockID, t_EstD.SecID, t_EstD.ProdID, t_EstD.PPID

  --UNION ALL 

select 'Приход товара: Заголовок '
    SELECT DISTINCT t_Rec.OurID OurID, t_Rec.StockID StockID, t_RecD.SecID SecID, t_RecD.ProdID ProdID, t_RecD.PPID PPID, SUM(t_RecD.Qty) Qty, 0 AccQty    FROM r_Prods WITH (NOLOCK), t_RecD WITH (NOLOCK), t_Rec WITH(NOLOCK)     WHERE t_RecD.ProdID = r_Prods.ProdID AND t_Rec.ChID = t_RecD.ChID AND (r_Prods.InRems <> 0) AND (t_Rec.DocDate BETWEEN @BDate AND @EDate)
	AND ((0 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ) OR ( (SELECT [dbo].[zf_MatchFilterInt](r_Prods.ProdID,@ProdID,',')) = 1 and 1 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ))
    GROUP BY t_Rec.OurID, t_Rec.StockID, t_RecD.SecID, t_RecD.ProdID, t_RecD.PPID

  --UNION ALL 

select 'Приход товара по ГТД: Заголовок '
    SELECT DISTINCT t_Cst.OurID OurID, t_Cst.StockID StockID, t_CstD.SecID SecID, t_CstD.ProdID ProdID, t_CstD.PPID PPID, SUM(t_CstD.Qty) Qty, 0 AccQty    FROM r_Prods WITH (NOLOCK), t_CstD WITH (NOLOCK), t_Cst WITH(NOLOCK)     WHERE t_CstD.ProdID = r_Prods.ProdID AND t_Cst.ChID = t_CstD.ChID AND (r_Prods.InRems <> 0) AND (t_Cst.DocDate BETWEEN @BDate AND @EDate)
 	AND ((0 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ) OR ( (SELECT [dbo].[zf_MatchFilterInt](r_Prods.ProdID,@ProdID,',')) = 1 and 1 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ))
   GROUP BY t_Cst.OurID, t_Cst.StockID, t_CstD.SecID, t_CstD.ProdID, t_CstD.PPID

  --UNION ALL 

select 'Продажа товара оператором: Заголовок '
    SELECT DISTINCT t_Sale.OurID OurID, t_Sale.StockID StockID, t_SaleD.SecID SecID, t_SaleD.ProdID ProdID, t_SaleD.PPID PPID, -SUM(t_SaleD.Qty) Qty, 0 AccQty    FROM r_Prods WITH (NOLOCK), t_SaleD WITH (NOLOCK), t_Sale WITH(NOLOCK)     WHERE t_SaleD.ProdID = r_Prods.ProdID AND t_Sale.ChID = t_SaleD.ChID AND (r_Prods.InRems <> 0) AND (t_Sale.DocDate BETWEEN @BDate AND @EDate)
 	AND ((0 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ) OR ( (SELECT [dbo].[zf_MatchFilterInt](r_Prods.ProdID,@ProdID,',')) = 1 and 1 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ))
   GROUP BY t_Sale.OurID, t_Sale.StockID, t_SaleD.SecID, t_SaleD.ProdID, t_SaleD.PPID

  --UNION ALL 

select 'Разукомплектация товара: Заголовок '
    SELECT DISTINCT t_SExp.OurID OurID, t_SExp.StockID StockID, t_SExpA.SecID SecID, t_SExpA.ProdID ProdID, t_SExpA.PPID PPID, -SUM(t_SExpA.Qty) Qty, 0 AccQty    FROM t_SExpA WITH (NOLOCK), r_Prods WITH (NOLOCK), t_SExp WITH(NOLOCK)     WHERE t_SExp.ChID = t_SExpA.ChID AND t_SExpA.ProdID = r_Prods.ProdID AND (r_Prods.InRems <> 0) AND (t_SExp.DocDate BETWEEN @BDate AND @EDate)
	AND ((0 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ) OR ( (SELECT [dbo].[zf_MatchFilterInt](r_Prods.ProdID,@ProdID,',')) = 1 and 1 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ))
    GROUP BY t_SExp.OurID, t_SExp.StockID, t_SExpA.SecID, t_SExpA.ProdID, t_SExpA.PPID

  --UNION ALL 

select 'Разукомплектация товара: Заголовок '
    SELECT DISTINCT t_SExp.OurID OurID, t_SExp.SubStockID StockID, t_SExpD.SubSecID SecID, t_SExpD.SubProdID ProdID, t_SExpD.SubPPID PPID, SUM(t_SExpD.SubQty) Qty, 0 AccQty    FROM t_SExpA WITH (NOLOCK), t_SExpD WITH (NOLOCK), r_Prods WITH (NOLOCK), t_SExp WITH(NOLOCK)     WHERE t_SExp.ChID = t_SExpA.ChID AND t_SExpA.AChID = t_SExpD.AChID AND t_SExpD.SubProdID = r_Prods.ProdID AND (r_Prods.InRems <> 0) AND (t_SExp.DocDate BETWEEN @BDate AND @EDate)
 	AND ((0 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ) OR ( (SELECT [dbo].[zf_MatchFilterInt](r_Prods.ProdID,@ProdID,',')) = 1 and 1 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ))
   GROUP BY t_SExp.OurID, t_SExp.SubStockID, t_SExpD.SubSecID, t_SExpD.SubProdID, t_SExpD.SubPPID

  --UNION ALL 

select 'Расходная накладная: Заголовок '
    SELECT DISTINCT t_Inv.OurID OurID, t_Inv.StockID StockID, t_InvD.SecID SecID, t_InvD.ProdID ProdID, t_InvD.PPID PPID, -SUM(t_InvD.Qty) Qty, 0 AccQty    FROM r_Prods WITH (NOLOCK), t_InvD WITH (NOLOCK), t_Inv WITH(NOLOCK)     WHERE t_InvD.ProdID = r_Prods.ProdID AND t_Inv.ChID = t_InvD.ChID AND (r_Prods.InRems <> 0) AND (t_Inv.DocDate BETWEEN @BDate AND @EDate)
 	AND ((0 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ) OR ( (SELECT [dbo].[zf_MatchFilterInt](r_Prods.ProdID,@ProdID,',')) = 1 and 1 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ))
   GROUP BY t_Inv.OurID, t_Inv.StockID, t_InvD.SecID, t_InvD.ProdID, t_InvD.PPID

  --UNION ALL 

select 'Расходный документ: Заголовок '
    SELECT DISTINCT t_Exp.OurID OurID, t_Exp.StockID StockID, t_ExpD.SecID SecID, t_ExpD.ProdID ProdID, t_ExpD.PPID PPID, -SUM(t_ExpD.Qty) Qty, 0 AccQty    FROM r_Prods WITH (NOLOCK), t_ExpD WITH (NOLOCK), t_Exp WITH(NOLOCK)     WHERE t_ExpD.ProdID = r_Prods.ProdID AND t_Exp.ChID = t_ExpD.ChID AND (r_Prods.InRems <> 0) AND (t_Exp.DocDate BETWEEN @BDate AND @EDate)
	AND ((0 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ) OR ( (SELECT [dbo].[zf_MatchFilterInt](r_Prods.ProdID,@ProdID,',')) = 1 and 1 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ))
    GROUP BY t_Exp.OurID, t_Exp.StockID, t_ExpD.SecID, t_ExpD.ProdID, t_ExpD.PPID

  --UNION ALL 

select 'Расходный документ в ценах прихода: Заголовок '
    SELECT DISTINCT t_Epp.OurID OurID, t_Epp.StockID StockID, t_EppD.SecID SecID, t_EppD.ProdID ProdID, t_EppD.PPID PPID, -SUM(t_EppD.Qty) Qty, 0 AccQty    FROM r_Prods WITH (NOLOCK), t_EppD WITH (NOLOCK), t_Epp WITH(NOLOCK)     WHERE t_EppD.ProdID = r_Prods.ProdID AND t_Epp.ChID = t_EppD.ChID AND (r_Prods.InRems <> 0) AND (t_Epp.DocDate BETWEEN @BDate AND @EDate)
	AND ((0 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ) OR ( (SELECT [dbo].[zf_MatchFilterInt](r_Prods.ProdID,@ProdID,',')) = 1 and 1 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ))
    GROUP BY t_Epp.OurID, t_Epp.StockID, t_EppD.SecID, t_EppD.ProdID, t_EppD.PPID

  --UNION ALL 

select 'Счет на оплату товара: Заголовок '
    SELECT DISTINCT t_Acc.OurID OurID, t_Acc.StockID StockID, t_AccD.SecID SecID, t_AccD.ProdID ProdID, t_AccD.PPID PPID, 0 Qty, SUM(t_AccD.Qty) AccQty    FROM r_Prods WITH (NOLOCK), t_AccD WITH (NOLOCK), t_Acc WITH(NOLOCK)     WHERE t_AccD.ProdID = r_Prods.ProdID AND t_Acc.ChID = t_AccD.ChID AND (r_Prods.InRems <> 0) AND (t_Acc.ReserveProds <> 0) AND (t_Acc.DocDate BETWEEN @BDate AND @EDate)
 	AND ((0 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ) OR ( (SELECT [dbo].[zf_MatchFilterInt](r_Prods.ProdID,@ProdID,',')) = 1 and 1 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ))
   GROUP BY t_Acc.OurID, t_Acc.StockID, t_AccD.SecID, t_AccD.ProdID, t_AccD.PPID

--  ) q 
--  GROUP BY OurID,StockID,SecID,ProdID,PPID

--END

