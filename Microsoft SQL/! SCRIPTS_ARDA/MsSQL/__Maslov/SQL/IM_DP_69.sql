BEGIN TRAN;

EXEC ap_VC_ImportOrders_Dnepr_new

--SELECT *
--FROM t_IMOrders
--WHERE DocID = 10001269



--SELECT * FROM dbo.tf_GetPPIDRems(8,6,1201,1,800621)
--SELECT * FROM dbo.tf_GetPPIDRems(8,6,1200,1,800621)

ROLLBACK TRAN;

          SELECT
           d.ProdID, d.Qty, d.Qty OrdQty, rp.UM, mq.BarCode, 
           d.PurPrice PurPrice, ROUND(d.PurPrice * (1 - (d.Discount / 100)), 2) OrdPrice, Discount,     
           (CASE d.IsVIP WHEN 0 THEN dbo.af_VC_GetPLID(m.RegionID) WHEN 1 THEN 32 WHEN 2 THEN 25 END) PLID,
           rp.TaxTypeID
          FROM t_IMOrdersD d
          JOIN t_IMOrders m ON m.DocID = d.DocID
          JOIN dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID 
          JOIN dbo.r_ProdMQ mq WITH(NOLOCK) ON mq.ProdID = d.ProdID AND mq.UM = rp.UM
          WHERE d.RemSchID = 2 AND d.DocID = 10001274 AND rp.PGrID1 IN (SELECT AValue FROM dbo.zf_FilterToTable('200-207,209-399,401-501,704'))
          ORDER BY d.PosID 

		  SELECT * FROM t_IMOrdersD 
		  WHERE DocID = 10001278

		  
SELECT * FROM t_SaleTempD
WHERE ChID = 1947


SELECT * FROM dbo.r_DCards WITH(NOLOCK) WHERE ChID=0 AND DCTypeCode IN (1,2)
--INSERT INTO t_IMOrders
--SELECT DocID, DocDate, ExpDate, ExpTime, ClientID, Address, Notes, PayFormCode, Recipient, Phone, DeliveryType, DeliveryPriceCC, RegionID, CompType, Code, DCardID, ShopifyOrderID, ImportDate, 0
--FROM ElitR.dbo.t_IMOrders
--WHERE DocID = 10001274

--INSERT INTO t_IMOrdersD
--SELECT * FROM ElitR.dbo.t_IMOrdersD
--WHERE DocID = 10001274
--UPDATE t_IMOrders SET Status = 1 WHERE DocID = 10001269

--  SELECT
--   (SELECT TOP 1 ChID FROM dbo.at_t_IORes WITH(NOLOCK) WHERE DocID = i.DocID ORDER BY 1) ChID, 
--   (SELECT COALESCE(MAX(SrcPosID),0) + 1 FROM dbo.at_t_IOResD WITH(NOLOCK) WHERE ChID = (SELECT TOP 1 ChID FROM dbo.at_t_IORes WITH(NOLOCK) WHERE DocID = i.DocID ORDER BY 1)) SrcPosID,
--   CASE i.DeliveryType WHEN 'courier' THEN '8000' WHEN 'express' THEN '7999' END BarCode,  
--   CASE i.DeliveryType WHEN 'courier' THEN 8000 WHEN 'express' THEN 7999 END ProdID,  
--   0 PPID, 'послуга' UM, 1 Qty, 1 OrdQty, 
--   dbo.zf_GetProdPrice_nt(i.DeliveryPriceCC,CASE i.DeliveryType WHEN 'courier' THEN 8000 WHEN 'express' THEN 7999 END, ExpDate) PriceCC_nt,
--   dbo.zf_GetProdPrice_nt(i.DeliveryPriceCC,CASE i.DeliveryType WHEN 'courier' THEN 8000 WHEN 'express' THEN 7999 END, ExpDate) SumCC_nt,
--   dbo.zf_GetProdPrice_wtTax(i.DeliveryPriceCC,CASE i.DeliveryType WHEN 'courier' THEN 8000 WHEN 'express' THEN 7999 END, ExpDate) Tax, 
--   dbo.zf_GetProdPrice_wtTax(i.DeliveryPriceCC,CASE i.DeliveryType WHEN 'courier' THEN 8000 WHEN 'express' THEN 7999 END, ExpDate) TaxSum, 
--   i.DeliveryPriceCC PriceCC_wt, i.DeliveryPriceCC SumCC_wt, 1 SecID, 
--   dbo.af_VC_GetPLID(i.RegionID) PLID, 0 Discount, 
--   dbo.zf_GetProdPrice_nt(i.DeliveryPriceCC,CASE i.DeliveryType WHEN 'courier' THEN 8000 WHEN 'express' THEN 7999 END, ExpDate) PurPriceCC_nt, 
--   dbo.zf_GetProdPrice_wtTax(i.DeliveryPriceCC,CASE i.DeliveryType WHEN 'courier' THEN 8000 WHEN 'express' THEN 7999 END, ExpDate) PurTax, 
--   i.DeliveryPriceCC PurPriceCC_wt
--  FROM t_IMOrders i
--  WHERE i.DeliveryPriceCC > 0 AND i.DeliveryType IN ('courier','express')
--  AND DocID = 50001059

--         SELECT
--           d.ProdID, d.Qty, d.Qty OrdQty, rp.UM, mq.BarCode, 
--           d.PurPrice PurPrice, ROUND(d.PurPrice * (1 - (d.Discount / 100)), 2) OrdPrice, Discount,     
--           (CASE d.IsVIP WHEN 0 THEN dbo.af_VC_GetPLID(m.RegionID) WHEN 1 THEN 32 WHEN 2 THEN 25 END) PLID,
--           rp.TaxTypeID
--          FROM t_IMOrdersD d
--          JOIN t_IMOrders m ON m.DocID = d.DocID
--          JOIN dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID = d.ProdID 
--          JOIN dbo.r_ProdMQ mq WITH(NOLOCK) ON mq.ProdID = d.ProdID AND mq.UM = rp.UM
--          WHERE d.RemSchID = 2 AND rp.PGrID1 IN (SELECT AValue FROM dbo.zf_FilterToTable('200-207,209-399,401-501,704'))
--          AND m.DocID = 10001269
--		  ORDER BY d.PosID
--BEGIN TRAN;

--  /* Добавление доставки - "Курьерская" и "Экспресс" ЗВР */
--  INSERT dbo.at_t_IOResD
--  (ChID, SrcPosID, BarCode, ProdID, PPID, UM, Qty, OrdQty, PriceCC_nt, SumCC_nt, Tax, TaxSum, PriceCC_wt, SumCC_wt,
--   SecID, PLID, Discount, PurPriceCC_nt, PurTax, PurPriceCC_wt)
--  SELECT
--   (SELECT TOP 1 ChID FROM dbo.at_t_IORes WITH(NOLOCK) WHERE DocID = i.DocID ORDER BY 1) ChID, 
--   (SELECT COALESCE(MAX(SrcPosID),0) + 1 FROM dbo.at_t_IOResD WITH(NOLOCK) WHERE ChID = (SELECT TOP 1 ChID FROM dbo.at_t_IORes WITH(NOLOCK) WHERE DocID = i.DocID ORDER BY 1)) SrcPosID,
--   CASE i.DeliveryType WHEN 'courier' THEN '8000' WHEN 'express' THEN '7999' END BarCode,  
--   CASE i.DeliveryType WHEN 'courier' THEN 8000 WHEN 'express' THEN 7999 END ProdID,  
--   0 PPID, 'послуга' UM, 1 Qty, 1 OrdQty, 
--   dbo.zf_GetProdPrice_nt(i.DeliveryPriceCC,CASE i.DeliveryType WHEN 'courier' THEN 8000 WHEN 'express' THEN 7999 END, ExpDate) PriceCC_nt,
--   dbo.zf_GetProdPrice_nt(i.DeliveryPriceCC,CASE i.DeliveryType WHEN 'courier' THEN 8000 WHEN 'express' THEN 7999 END, ExpDate) SumCC_nt,
--   dbo.zf_GetProdPrice_wtTax(i.DeliveryPriceCC,CASE i.DeliveryType WHEN 'courier' THEN 8000 WHEN 'express' THEN 7999 END, ExpDate) Tax, 
--   dbo.zf_GetProdPrice_wtTax(i.DeliveryPriceCC,CASE i.DeliveryType WHEN 'courier' THEN 8000 WHEN 'express' THEN 7999 END, ExpDate) TaxSum, 
--   i.DeliveryPriceCC PriceCC_wt, i.DeliveryPriceCC SumCC_wt, 1 SecID, 
--   dbo.af_VC_GetPLID(i.RegionID) PLID, 0 Discount, 
--   dbo.zf_GetProdPrice_nt(i.DeliveryPriceCC,CASE i.DeliveryType WHEN 'courier' THEN 8000 WHEN 'express' THEN 7999 END, ExpDate) PurPriceCC_nt, 
--   dbo.zf_GetProdPrice_wtTax(i.DeliveryPriceCC,CASE i.DeliveryType WHEN 'courier' THEN 8000 WHEN 'express' THEN 7999 END, ExpDate) PurTax, 
--   i.DeliveryPriceCC PurPriceCC_wt
--  FROM t_IMOrders i
--  WHERE i.DeliveryPriceCC > 0 AND i.DeliveryType IN ('courier','express')
--  AND DocID = 50001059
    
--  /* Добавление доставки в ПТО ВД (в случае отгрузки ТОЛЬКО по розничной схеме) */
--  INSERT dbo.t_SaleTempD
--  (ChID, SrcPosID, 
--   ProdID, UM, Qty, RealQty, PriceCC_wt, SumCC_wt, PurPriceCC_wt, PurSumCC_wt, 
--   BarCode, RealBarCode, PLID, UseToBarQty, PosStatus, 
--   CSrcPosID, CanEditQty, TaxTypeID)
--  SELECT 
--   l.ChildChID, (SELECT MAX(SrcPosID) + 1 FROM dbo.t_SaleTempD WHERE ChID = l.ChildChID) SrcPosID,
--   d.ProdID, d.UM, d.Qty, 1 RealQty, d.PriceCC_wt, d.SumCC_wt, d.PurPriceCC_wt, d.PurPriceCC_wt * d.Qty PurSumCC_wt,
--   d.BarCode, d.BarCode RealBarCode, d.PLID, 0 UseToBarQty, 1 PosStatus, 
--   (SELECT MAX(SrcPosID) + 1 FROM dbo.t_SaleTempD WHERE ChID = l.ChildChID) CSrcPosID, 1 CanEditQty, p.TaxTypeID
--  FROM dbo.at_t_IOResD d WITH(NOLOCK)
--  JOIN at_t_IORes m WITH(NOLOCK) ON m.ChID = d.ChID
--  JOIN t_IMOrders o ON o.DocID = m.DocID
--  JOIN z_DocLinks l WITH(NOLOCK) ON l.ParentDocCode = 666004 AND l.ChildDocCode = 1011 AND l.ParentChID = d.ChID
--  JOIN dbo.r_Prods p WITH(NOLOCK) ON p.ProdID = d.ProdID
--  WHERE d.ProdID IN (7999,8000,8001) AND m.RemSchID IN (1,2)
--  AND m.DocID = 50001059
--ROLLBACK TRAN;
--UPDATE t_IMOrders SET DeliveryType = 'courier' WHERE DocID = 50001059