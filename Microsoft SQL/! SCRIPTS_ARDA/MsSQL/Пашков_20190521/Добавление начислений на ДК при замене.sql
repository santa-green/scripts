-- взято из ap_ChangeDCard
-- при замене ДК карт на локальных базах необходимо сделать нижеследующее
DECLARE 
  @OldDCardID VARCHAR(250) = '2220000278966', -- Старая карта 
  @NewDCardID VARCHAR(250) = '2220000260039'	-- Новая карта

SELECT *  FROM z_LogDiscRec
where DCardID in(@OldDCardID, @NewDCardID)

INSERT z_DocDC
(DocCode,ChID,DCardID)
SELECT DocCode,ChID,@NewDCardID DCardID
FROM z_DocDC dc WITH(NOLOCK)
WHERE DCardID = @OldDCardID AND NOT EXISTS (SELECT * FROM z_DocDC WHERE DocCode = dc.DocCode AND ChID = dc.ChID AND DCardID = @NewDCardID)

update z_LogDiscRec
set DCardID = @NewDCardID   
where DCardID = @OldDCardID 
  
SELECT *  FROM z_LogDiscRec
where DCardID in(@OldDCardID, @NewDCardID)