SELECT * FROM av_VC_ExportRemsR where ProdID in (802391,802389,802384)
SELECT * FROM av_VC_ExportRemsW where ProdID in (802391,802389,802384)

/* Экспорт остатков ОПТ */
SELECT * FROM av_VC_ExportRemsW i
JOIN OPENQUERY (VintageClub,'
SELECT HIGH_PRIORITY b.storage_id,b.item_id,b.count 
FROM vintagemarket.shop_item_balance AS b
JOIN vintagemarket.storage AS s ON s.storage_id = b.storage_id
WHERE s.region_id = 1 AND b.item_id >= 600000') vc ON vc.item_id = i.ProdID
WHERE vc.count != i.Qty

SELECT * FROM  OPENQUERY (VintageClub,'
SELECT HIGH_PRIORITY b.storage_id,b.item_id,b.count 
FROM vintagemarket.shop_item_balance AS b
JOIN vintagemarket.storage AS s ON s.storage_id = b.storage_id
WHERE s.region_id = 1 AND s.name = ''опт.'' AND b.item_id >= 600000') 
    
    
  SELECT * FROM av_VC_ExportRemsR i
  JOIN OPENQUERY (VintageClub,'
SELECT HIGH_PRIORITY b.storage_id,b.item_id,b.count 
FROM vintagemarket.shop_item_balance AS b
JOIN vintagemarket.storage AS s ON s.storage_id = b.storage_id
WHERE s.region_id = 1 AND s.name = ''Розн.'' AND b.item_id >= 600000') vc ON vc.item_id = i.ProdID
  WHERE vc.count != i.Qty