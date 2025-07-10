	10297085	3	z_Replica_Ins_z_DocLinks_3 0,11035,100421550,'2017-03-09T00:00:00','100353981',14342,19661,'2017-03-09T00:00:00','600001807',3964.650000000,31	2	The transaction ended in the trigger. The batch has been aborted.  Невозможно добавление данных в таблицу 'Документы - Взаимосвязи (z_DocLinks)'. Отсутствуют данные в главной таблице 'Продажа товара оператором: Заголовок (t_Sale)'.	2017-03-23 10:00:00.000
	
	
	
	exec z_Replica_Ins_z_DocLinks_3 0,11035,100421550,'2017-03-09T00:00:00','100353981',14342,19661,'2017-03-09T00:00:00','600001807',3964.650000000,31
	
ALTER PROCEDURE [dbo].[z_Replica_Ins_z_DocLinks_3](@LinkID int, @ParentDocCode int, @ParentChID int, @ParentDocDate smalldatetime, @ParentDocID varchar(50), @ChildDocCode int, @ChildChID int, @ChildDocDate smalldatetime, @ChildDocID varchar(50), @LinkSumCC numeric(21, 9),
  @DocLinkTypeID int)
	
  INSERT INTO z_DocLinks( LinkDocDate, ParentDocCode, ParentChID, ParentDocDate, ParentDocID, ChildDocCode, ChildChID, ChildDocDate, ChildDocID,
    LinkSumCC, DocLinkTypeID)
  VALUES( (getdate()), @ParentDocCode, @ParentChID, @ParentDocDate, @ParentDocID, @ChildDocCode, @ChildChID, @ChildDocDate, @ChildDocID,
    @LinkSumCC, @DocLinkTypeID)
  
  
	SELECT LinkDocDate, ParentDocCode, ParentChID, ParentDocDate, ParentDocID, ChildDocCode, ChildChID, ChildDocDate, ChildDocID,
    LinkSumCC, DocLinkTypeID FROM [s-sql-d4].elitr.dbo.z_DocLinks
    where ParentDocCode  = 11035 and ParentChID = 100421550
    
    SELECT * FROM z_Docs where DocCode = 14342
    
    SELECT * FROM [s-sql-d4].elitr.dbo.t_sale  where chid = 600001807
    
    
      
