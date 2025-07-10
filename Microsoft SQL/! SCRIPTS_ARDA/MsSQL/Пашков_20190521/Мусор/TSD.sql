SELECT * FROM it_TSD_doc_head
SELECT * FROM it_TSD_doc_details
SELECT * FROM it_TSD_goods
SELECT * FROM it_TSD_barcode
SELECT * FROM it_TSD_contragents
SELECT * FROM it_TSD_sklad
SELECT * FROM it_TSD_users

--SELECT * FROM it_TSD_doc_detailsinv
--SELECT * FROM it_TSD_doc_headinv





SELECT * FROM it_TSD_goods where Id_good = 600379

SELECT DISTINCT  p.ProdID, p.ProdName, p.ProdID, ISNULL(mp.PriceMC,0) 
               FROM r_ProdMQ as mq WITH(NOLOCK)    
               INNER JOIN r_Prods as p WITH(NOLOCK) ON mq.ProdID=p.ProdID
               LEFT JOIN r_ProdMP as mp WITH(NOLOCK) ON mq.ProdID=mp.ProdID and mp.PlID = 83
               INNER JOIN t_Pinp np WITH(NOLOCK) ON np.ProdID = p.ProdID 
               WHERE  mp.ProdID = 600379 and p.ProdID BETWEEN 600001 AND 605000 or p.ProdID = 605382   or p.ProdID  BETWEEN 605142 and 605145 or p.ProdID BETWEEN 605423 and 605427       
               or p.ProdID BETWEEN 611698	AND 611753  or p.ProdID BETWEEN 800001 AND 900000 AND p.prodid not in (select id_good from it_TSD_goods) 
				 
				 
SELECT * FROM r_ProdMP where ProdID = 600379 		

SELECT * FROM r_ProdMQ where ProdID = 600379 		 

SELECT * FROM r_Prods where ProdID = 600379 

ip_ExpToTSD

SELECT * FROM it_TSD_doc_head
SELECT * FROM it_TSD_doc_details where Id_doc in (18974,18978)
SELECT * FROM it_TSD_users