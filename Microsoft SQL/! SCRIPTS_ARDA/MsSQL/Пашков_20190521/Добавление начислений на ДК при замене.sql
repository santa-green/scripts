-- ����� �� ap_ChangeDCard
-- ��� ������ �� ���� �� ��������� ����� ���������� ������� �������������
DECLARE 
  @OldDCardID VARCHAR(250) = '2220000278966', -- ������ ����� 
  @NewDCardID VARCHAR(250) = '2220000260039'	-- ����� �����

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