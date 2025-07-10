

CREATE PROCEDURE dbo.a_ReleaseReserve(@ChID int)  AS
BEGIN

  SET NOCOUNT ON

  UPDATE a
  SET ReserveProds=0
  FROM a_Order o INNER JOIN t_Acc a ON a.ChID=o.AccChID
  WHERE o.ChID=@ChID

END

GO
