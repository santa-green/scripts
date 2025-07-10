USE [Alef_Elit]
GO
/****** Object:  StoredProcedure [dbo].[ap_EDI_Resend_COMDOC_Rozetka]    Script Date: 18.08.2021 16:58:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<rkv0>
-- Create date: <'2019-11-05 10:54'>
-- Description:	<по сети Rozetka меняет статус DESADV для повторного формирования и отправки COMDOC на ftp>
-- =============================================
ALTER PROCEDURE [dbo].[ap_EDI_Resend_COMDOC_Rozetka] @orderid varchar(20) --@orderid - № заказа в EDI.
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    SELECT * FROM at_EDI_reg_files WHERE [Status] IN (10,11) AND ID = @orderid AND Notes LIKE 'DESADV%'
    UPDATE at_EDI_reg_files 
    SET [Status] = 3, LastUpdateData = GETDATE() 
    WHERE [Status] IN (10,11) AND ID = @orderid AND DocType = 24000 AND RetailersID = 17154 AND Notes LIKE 'DESADV%'
    
    SELECT * FROM at_EDI_reg_files WHERE [Status] IN (3) AND ID = @orderid AND Notes LIKE 'DESADV%'

    --SELECT * FROM at_EDI_reg_files WHERE [Status] = 10 AND ID = 'РОЗ10659346' AND Notes LIKE 'DESADV%'

    --TEST:
    --EXEC [ap_EDI_Resend_COMDOC_Rozetka] 'РОЗ10777330' 
END



GO


