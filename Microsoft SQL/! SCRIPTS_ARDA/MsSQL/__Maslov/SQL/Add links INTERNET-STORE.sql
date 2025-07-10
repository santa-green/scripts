DECLARE @ParChID INT, @ChildChID INT


DECLARE CURSOR1 CURSOR LOCAL FAST_FORWARD --добавляем категории
FOR 
SELECT m.ChID, ati.ChID
FROM t_Sale m
JOIN at_t_IORes ati ON ati.DocID = CAST(SUBSTRING(m.Notes, 0, CHARINDEX(' -', m.Notes) ) AS INT)
WHERE m.OurID = 6
AND m.DocDate >= '20190321'
AND m.DocDate <= '20190327'
AND m.Notes != ''
AND m.InDocID = 0
AND m.Notes LIKE '%РОЗНИЦА%'--'%Опт%'
AND ati.RemSchID = 2--1
--ORDER BY 3

--SELECT  * FROM z_DocLinks WHERE  ParentChID = 19502 and ChildChID = 800025036
--SELECT * FROM t_Sale WHERE ChID = 800025020 AND DeskCode = 233 and StockID in (1252,1201,1243,723) AND TRealSum <> 0 

OPEN CURSOR1
	FETCH NEXT FROM CURSOR1 INTO @ChildChID, @ParChID
WHILE @@FETCH_STATUS = 0		 
BEGIN
  
  IF EXISTS (SELECT * FROM t_Sale WHERE ChID = @ChildChID AND DeskCode = 233 and StockID in (1252,1201,1243,723) AND TRealSum <> 0 )
  BEGIN
	IF NOT EXISTS (SELECT  * FROM z_DocLinks WHERE  ParentChID = @ParChID and ChildChID = @ChildChID )
	BEGIN 
		INSERT z_DocLinks
		(LinkDocDate, ParentDocCode, ParentChID, ParentDocDate, ParentDocID, ChildDocCode, ChildChID, ChildDocDate, ChildDocID, LinkSumCC, DocLinkTypeID)
		SELECT 
		 GETDATE() LinkDocDate, 666004 ParentDocCode, i.ChID ParentChID, i.DocDate ParentDocDate, i.DocID ParentDocID, 
		 11035 ChildDocCode, m.ChID ChildChID, m.DocDate ChildDocDate, m.DocID ChildDocID, 0 LinkSumCC, 0 DocLinkTypeID  
		FROM t_Sale m WITH(NOLOCK)
		JOIN at_t_IORes i WITH(NOLOCK) ON i.ChID = @ParChID
		WHERE m.ChID = @ChildChID
		  
		/* Обновление статуса, номер заказа, клиент, ДК, признаки 4,5 в ЗВР */
		UPDATE i
		SET StateCode = 140
		FROM at_t_IORes i
		JOIN z_DocLinks l WITH(NOLOCK) ON l.ParentDocCode = 666004 AND l.ChildDocCode = 11035 AND l.ParentChID = i.ChID
		WHERE l.ChildChID = @ChildChID
	END
  
	UPDATE m
	SET 
	 m.DCardID = i.DCardID, 
	 m.InDocID = i.DocID, 
	 m.ClientID = i.ClientID, 
	 m.ExpTime = i.ExpTime, 
	 m.CodeID4 = i.CodeID4, 
	 m.CodeID5 = i.CodeID5, 
	 m.BLineID = 1,
	 m.Visitors = 0 ,
	 m.RemSchID = i.RemSchID 
	FROM t_Sale m
	JOIN z_DocLinks l WITH(NOLOCK) ON l.ParentDocCode = 666004 AND l.ChildDocCode = 11035 AND l.ChildChID = m.ChID
	JOIN at_t_IORes i WITH(NOLOCK) ON i.ChID = l.ParentChID
	WHERE m.ChID = @ChildChID
  END

	FETCH NEXT FROM CURSOR1 INTO @ChildChID, @ParChID
END
CLOSE CURSOR1
DEALLOCATE CURSOR1

/*
SELECT * FROM at_t_IORes WHERE DocID = 177176

SELECT * FROM r_Uni WHERE RefTypeID = 1000000002
1	Опт
2	Розница


176927
*/

	--SELECT * FROM t_Sale WHERE ChID = 100684064  --100684063
	--SELECT * FROM at_t_IORes WHERE ChID = 19481