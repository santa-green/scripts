USE [Alef_Elit]
GO
/****** Object:  StoredProcedure [dbo].[ALEF_WEB_EDI_SETI_CompID]    Script Date: 01.07.2021 12:42:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[ALEF_WEB_EDI_SETI_CompID] 
	-- Add the parameters for the stored procedure here
	@seti varchar(10)
AS
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
    -- Insert statements for procedure here
	select Compid, '(' + cast(Compid as varchar(10)) + ') ' + CompName as CN, 
	0 as CAI, '(0) неизвестно' as CAN, 0 as SKL
	from [s-sql-d4].Elit.dbo.r_Comps c
	where c.Compid in
		(select ZEC_KOD_KLN_OT
		from dbo.ALEF_EDI_GLN_OT
		where exists(select * from dbo.ALEF_EDI_GLN_SETI where EGS_GLN_SETI_ID = @seti and (EGS_GLN_ID = ZEC_KOD_BASE or EGS_GLN_ID = ZEC_KOD_ADD)))
	order by Compid;

END


GO

[ALEF_WEB_EDI_SETI_CompID] 982
SELECT * FROM ALEF_EDI_GLN_OT WHERE ZEC_KOD_KLN_OT in (7136, 7138, 7158)
sp_help ALEF_EDI_GLN_OT 
SELECT * FROM [s-sql-d4].[elit].dbo.r_CompsAdd WHERE CompID in (7136, 7138, 7158) ORDER BY CompID DESC
