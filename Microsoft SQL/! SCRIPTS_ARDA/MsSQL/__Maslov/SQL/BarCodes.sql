SELECT m.ProdID, m.UM, rpmq.UM, rpmq.BarCode, (SELECT BarCode FROM r_ProdMQ WHERE ProdID = m.ProdID AND BarCode NOT LIKE '%[^0-9]%') 'Good barcode'
FROM r_Prods m
JOIN r_ProdMQ rpmq ON rpmq.ProdID = m.ProdID AND rpmq.UM = m.UM
WHERE rpmq.BarCode LIKE '%[^0-9]%'
	  AND LEN(rpmq.BarCode) > 4
	  AND EXISTS (SELECT BarCode FROM r_ProdMQ WHERE ProdID = m.ProdID AND BarCode NOT LIKE '%[^0-9]%')
	  --AND m.ProdID = 602092
	  --AND rpmq.BarCode != ''


--SELECT * FROM r_Prods WHERE ProdID in (602092,802714,803275,803277)
--SELECT * FROM r_Prods WHERE ProdID in (600875)
--SELECT * FROM r_ProdMQ WHERE ProdID in (602092,802714,803275,803277)
