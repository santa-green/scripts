DECLARE @Chid_t_EOExp int = null


SELECT doc_type, id_doc FROM it_TSD_doc_head WHERE doc_type IN (0) --and sklad_out_id in (select sklad from #sklad)
						AND id_doc IN  (SELECT Id_doc FROM it_TSD_doc_details GROUP BY Id_doc HAVING SUM (Count_real)=0 )
						AND id_doc NOT IN   (SELECT ParentChID FROM z_DocLinks WHERE ParentDocCode = 11211 AND ParentDocDate >= GETDATE ()-30 AND ChildDocCode = 11002)
						
	SELECT doc_type, id_doc FROM it_TSD_doc_head WHERE doc_type IN (0) --and sklad_out_id in (select sklad from #sklad)
						AND id_doc     IN  (SELECT Id_doc FROM it_TSD_doc_details GROUP BY Id_doc HAVING SUM (Count_real)=0 )
						AND id_doc NOT IN   (SELECT ParentChID FROM z_DocLinks WHERE ParentDocCode = 11211 AND ParentDocDate >= GETDATE ()-30 AND ChildDocCode = 11002)
						AND Id_doc = 20849
												
						
SELECT * FROM it_TSD_doc_head	where id_doc = 20849		

SELECT    OurID ,   StockID ,     CompID
			FROM t_EOExp WHERE ChID = 20696 /*and StockID in (select sklad from #sklad)*/			
			
		 select 
				111 AS ChID, 
				1111 AS DocID, 
				dd.doc_date AS DocDate,
				dbo.zf_GetRateMC(dbo.zf_GetCurrCC()) AS KursMC, 
				6 AS OurID,
				1252 AS StockID, 
				81 AS CompID,
				/*dd.id_user AS EmpID,*/
				0 AS EmpID, 
				1111 AS IntDocID, 
				dbo.zf_GetCurrCC() AS CurrID ,
			    0  CodeID1,
			    r.CodeID2  CodeID2,
			    0  CodeID3
				FROM (SELECT * FROM it_TSD_doc_head WHERE id_doc =20696  ) dd
				JOIN r_Comps r ON r.CompID = 81
				GROUP BY dd.Doc_date, dd.id_contragent, dd.id_user ,r.CodeID1,r.CodeID2,r.CodeID3	
				
				
SELECT Id_good, Count_real FROM it_TSD_doc_details WHERE id_doc = 20696 	


SELECT * FROM t_EOExp
WHERE ChiD = 20696
ORDER BY 1	


SELECT * FROM t_EOExpD
WHERE ChiD = 20696
ORDER BY 1	

SELECT * FROM it_TSD_doc_head	where id_doc = 20849		
SELECT * FROM it_TSD_doc_details	where id_doc = 20849		

				
SELECT ParentChID,* FROM z_DocLinks WHERE ParentDocCode = 11211 AND /*ParentDocDate >= GETDATE ()-30 AND*/ ChildDocCode = 11002
and ParentChID in (20848)

SELECT * FROM z_Docs
WHERE DocCode = 11002
ORDER BY 1				