ALTER PROCEDURE [dbo].[ap_VC_IM_Logs] @RegionID INT = -1, @UpdateState INT = -1, @ProdID INT = -1, @Value VARCHAR(4000) = '', @Status VARCHAR(50) = '', @StatusText VARCHAR(500) = ''
AS
BEGIN
/*
EXEC ap_VC_IM_Logs @RegionID = 1
SELECT * FROM z_Logs_IM
*/
SET NOCOUNT ON 

IF @RegionID = -1 OR @UpdateState = -1 OR @ProdID = -1
BEGIN
  RETURN;
END;

INSERT INTO z_Logs_IM
SELECT @RegionID, @ProdID, @UpdateState, GETDATE(), @Value, @Status, @StatusText

END