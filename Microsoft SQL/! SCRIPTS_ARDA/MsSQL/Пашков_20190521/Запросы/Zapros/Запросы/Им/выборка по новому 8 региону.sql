select ProdID , ProdName , PGrID4 from r_Prods where ProdID in (600362,600364)
select * from r_ProdMp where  ProdID in (600362,600364) and PLID = 28

select * from av_VC_ExportRemsW where ProdID in (600362,600364)

select * FROM OPENQUERY (VintageClub,'
SELECT HIGH_PRIORITY b.* 
FROM vintagemarket.shop_item_balance AS b
JOIN vintagemarket.storage AS s ON s.storage_id = b.storage_id
WHERE s.region_id = 1 AND s.name = ''Îïò.'' AND b.count > 0 and item_id in (600362,600364)') 
  
 select * FROM OPENQUERY (VintageClub,'
SELECT HIGH_PRIORITY s.* 
FROM vintagemarket.shop_item_balance AS b
JOIN vintagemarket.storage AS s ON s.storage_id = b.storage_id
WHERE s.region_id = 1 AND s.name = ''Îïò.'' AND b.count > 0 and item_id in (600362,600364)') 
  