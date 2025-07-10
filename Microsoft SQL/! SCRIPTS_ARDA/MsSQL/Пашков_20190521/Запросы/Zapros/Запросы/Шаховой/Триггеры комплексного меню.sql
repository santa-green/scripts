ALTER TRIGGER iT_Upd_iv_ComplexMenuA ON iv_ComplexMenuA
INSTEAD OF UPDATE
AS
IF (SELECT COUNT(*) FROM deleted) = 1
BEGIN
  UPDATE m   
  SET  
    m.SrcPosID = i.SrcPosID,     
    m.Notes = i.Notes,
    m.IsRelated = i.IsRelated   
  FROM it_ComplexMenu m WITH (NOLOCK)  
  INNER JOIN deleted d  
  ON m.PLID = d.PLID AND m.ProdID = d.ProdID AND m.SrcPosID = d.SrcPosID  
  CROSS JOIN inserted i
END
GO

/**************************************************************************************************/
/**************************************************************************************************/
/**************************************************************************************************/
ALTER TRIGGER iT_Ins_iv_ComplexMenuA ON iv_ComplexMenuA
INSTEAD OF INSERT
AS

DELETE m 
FROM it_ComplexMenu m WITH (NOLOCK)
INNER JOIN inserted i 
ON m.PLID = i.PLID AND m.SubProdID = i.ProdID

INSERT INTO it_ComplexMenu
(
  PLID, ProdID, SrcPosID, IsRelated, Notes, SubProdID, DetQty, MaxQty
)
SELECT
  PLID, ProdID, SrcPosID, IsRelated, Notes, ProdID, 1 DetQty, MaxQty
FROM inserted i


GO

/**************************************************************************************************/
/**************************************************************************************************/
/**************************************************************************************************/

ALTER TRIGGER iT_Del_iv_ComplexMenuA ON iv_ComplexMenuA
INSTEAD OF DELETE
AS
DELETE m
FROM it_ComplexMenu m WITH (NOLOCK)  
INNER JOIN deleted d  
ON m.PLID = d.PLID AND m.ProdID = d.ProdID AND m.SrcPosID = d.SrcPosID

IF NOT EXISTS
(
  SELECT  
    TOP 1 1    
  FROM it_ComplexMenu m WITH (NOLOCK)  
  INNER JOIN deleted d  
  ON m.PLID = d.PLID AND m.ProdID = d.ProdID
)
INSERT INTO it_ComplexMenu
(
  PLID, ProdID, SrcPosID, IsRelated, Notes, SubProdID, MaxQty
)
SELECT
  PLID, ProdID, 0 SrcPosID, 0 IsRelated, NULL Notes, ProdID, MaxQty    
FROM deleted

GO

/**************************************************************************************************/
/**************************************************************************************************/
/**************************************************************************************************/



ALTER TRIGGER iT_Ins_iv_ComplexMenuD ON iv_ComplexMenuD
INSTEAD OF INSERT
AS

INSERT INTO it_ComplexMenu
(
  PLID, ProdID, SrcPosID, IsRelated, Notes, SubProdID, DetQty, MaxQty
)
SELECT
  PLID, ProdID, SrcPosID, IsRelated, 
  (
    SELECT    
      TOP 1 Notes       
    FROM it_ComplexMenu n WITH (NOLOCK)
    WHERE
      n.PLID = i.PLID
      AND n.ProdID = i.ProdID
      AND n.SrcPosID = i.SrcPosID 
  ), SubProdID, DetQty, 
  (
     SELECT    
      TOP 1 MaxQty      
    FROM it_ComplexMenu n WITH (NOLOCK)
    WHERE
      n.PLID = i.PLID
      AND n.ProdID = i.ProdID
  )  
FROM inserted i

DELETE m 
FROM it_ComplexMenu m WITH (NOLOCK)
INNER JOIN inserted i 
ON m.PLID = i.PLID AND m.SubProdID = i.ProdID

GO

/**************************************************************************************************/
/**************************************************************************************************/
/**************************************************************************************************/


ALTER TRIGGER iT_Upd_iv_ComplexMenuD ON iv_ComplexMenuD
INSTEAD OF UPDATE
AS
IF (SELECT COUNT(*) FROM deleted) = 1
BEGIN
  IF UPDATE(SubProdID)
  UPDATE m   
  SET  
    m.SubProdID = i.SubProdID,
    m.IsRelated = i.IsRelated     
  FROM it_ComplexMenu m WITH (NOLOCK)  
  INNER JOIN deleted d  
  ON m.PLID = d.PLID AND m.SubProdID = d.SubProdID  
  CROSS JOIN inserted i  

  IF UPDATE(PriceCC)  
  BEGIN  
    UPDATE mp  
    SET
      mp.PriceMC = i.PriceCC  
    FROM r_ProdMP mp WITH (NOLOCK)    
    INNER JOIN inserted i ON mp.PLID = i.PLID
    AND mp.ProdID = i.SubProdID AND i.SubProdID > 0     

    INSERT INTO r_ProdMP    
    (    
      PLID, ProdID, CurrID, PriceMC, Notes
    )    
    SELECT    
      i.PLID, i.SubProdID, dbo.zf_GetCurrCC(), i.PriceCC, ''
    FROM r_ProdMP mp WITH (NOLOCK)    
    RIGHT JOIN inserted i ON mp.PLID = i.PLID
    AND mp.ProdID = i.SubProdID
    WHERE mp.ProdID IS NULL AND i.SubProdID > 0      
  END    

  IF UPDATE(IsRelated)
  UPDATE m   
  SET  
    m.IsRelated = i.IsRelated     
  FROM it_ComplexMenu m WITH (NOLOCK)  
  INNER JOIN deleted d  
  ON m.PLID = d.PLID AND m.SubProdID = d.SubProdID  
  CROSS JOIN inserted i     

  IF UPDATE(DetQty)
  UPDATE m   
  SET  
    m.DetQty = i.DetQty     
  FROM it_ComplexMenu m WITH (NOLOCK)  
  INNER JOIN deleted d  
  ON m.PLID = d.PLID AND m.SubProdID = d.SubProdID  
  CROSS JOIN inserted i 
END


GO
/**************************************************************************************************/
/**************************************************************************************************/
/**************************************************************************************************/


ALTER TRIGGER iT_Del_iv_ComplexMenuD ON iv_ComplexMenuD
INSTEAD OF DELETE
AS
DELETE m
FROM it_ComplexMenu m WITH (NOLOCK)  
INNER JOIN deleted d  
ON m.PLID = d.PLID AND m.SubProdID = d.SubProdID

IF NOT EXISTS
(
  SELECT  
    TOP 1 1    
  FROM it_ComplexMenu m WITH (NOLOCK)  
  INNER JOIN deleted d  
  ON m.PLID = d.PLID AND m.ProdID = d.ProdID  
  AND m.SrcPosID = d.SrcPosID
)
INSERT INTO it_ComplexMenu
(
  PLID, ProdID, SrcPosID, IsRelated, Notes, SubProdID, DetQty, MaxQty
)
SELECT
  PLID, ProdID, SrcPosID, IsRelated, Notes, ProdID, DetQty, MaxQty    
FROM deleted d


GO
/**************************************************************************************************/
/**************************************************************************************************/
/**************************************************************************************************/

ALTER TRIGGER iT_Ins_iv_ComplexMenu ON iv_ComplexMenu
INSTEAD OF INSERT
AS
INSERT INTO it_ComplexMenu
(
  PLID, ProdID, SrcPosID, IsRelated, SubProdID, MaxQty
)
SELECT
  PLID, ProdID, 0 SrcPosID, 0 IsRelated, ProdID SubProdID, MaxQty  
FROM inserted

GO