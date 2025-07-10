USE [Alef_Elit]
GO
/****** Object:  StoredProcedure [dbo].[ap_EDI_Resend_COMDOC_Metro]    Script Date: 17.03.2021 16:46:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[ap_EDI_Resend_COMDOC_Metro] @orderid varchar(20) --@orderid - № заказа в EDI.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[FIXED] '2021-03-17 16:46' rkv0 убрал строки с DocSum = 0.

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    SELECT * FROM at_EDI_reg_files WHERE [Status] IN (31) AND DocType = 5000 AND RetailersID = 17 AND Notes = @orderid --'45269021'
    UPDATE at_EDI_reg_files 
    SET [Status] = 8, LastUpdateData = GETDATE() 
    --[FIXED] '2021-03-17 16:46' rkv0 убрал строки с DocSum = 0.
    --WHERE [Status] IN (31) AND Notes = @orderid AND DocType = 5000 AND RetailersID = 17
    WHERE [Status] IN (31) AND Notes = @orderid AND DocType = 5000 AND RetailersID = 17 AND DocSum != 0
    SELECT * FROM at_EDI_reg_files WHERE [Status] IN (8,9) AND DocType = 5000 AND RetailersID = 17 AND Notes = @orderid --'45269021'

    --TEST:
    --EXEC [dbo].[ap_EDI_Resend_COMDOC_Metro] '45269021' 
END



GO
