USE [Elit]
GO
/****** Object:  View [dbo].[av_at_desadv_autosend]    Script Date: 09.06.2021 17:15:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[av_at_desadv_autosend] WITH VIEW_METADATA AS
DROP VIEW [dbo].[av_at_desadv_autosend] WITH VIEW_METADATA AS
SELECT  * FROM (
SELECT rc.VarValue FROM r_uni ru WITH(NOLOCK)
join r_CompValues rc ON ru.RefID = rc.CompID 
WHERE ru.RefTypeID = 6680134 AND  rc.VarName = 'base_gln' /*в этом универсальном справочнике указан список предприятий, которые должны улетать через ftp автоматом (без папки Черновики). */

) GMSView
GO


SELECT * FROM r_uni WHERE RefTypeID = 6680134 and RefID = 7144 -- AND VarName = 'base_gln'
SELECT * FROM r_uni WHERE RefTypeID = 6680134 and RefID = 7004 -- AND VarName = 'base_gln'
SELECT * FROM r_CompValues WHERE VarName = 'base_gln' and CompID in(7144, 7004)
SELECT * FROM r_CompValues WHERE CompID in(7142)

begin tran
SELECT * FROM r_CompValues WHERE CompID in(7142)
--delete from r_CompValues WHERE CompID = 7142 and VarValue = 'base_gln'
SELECT * FROM r_CompValues WHERE CompID in(7142)
rollback tran

SELECT * FROM r_CompValues WHERE VarName = 'base_gln' and CompID in(7011)
SELECT * FROM r_CompValues WHERE VarValue = '9864066810109'

SELECT * FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.alef_edi_gln_ot WHERE zec_kod_kln_ot in (7011) ORDER BY 4 DESC--9863521530712
--9991027100105 Сильпо

insert into r_CompValues values (7142, 'BASE_GLN', '9991027100105')
insert into r_CompValues select (7142, 'BASE_GLN', '9991027100105')
--9864066810109 Омега
--9863521530712 Омега

insert into r_CompValues
SELECT DISTINCT 7142 'Compid', 'BASE_GLN' 'VarName', zec_kod_base  'VarValue' FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.alef_edi_gln_ot  
WHERE zec_kod_kln_ot in (7011) AND zec_kod_base != '9991027100105'

    EXEC dbo.ap_EXITE_Sync

    SELECT top(1000) *
    FROM dbo.at_z_filesExchange
    WHERE 1 = 1
        --and docdate = convert(date, getdate(), 102)
    	--and [filename] like '%iftmin%'
    ORDER BY doctime DESC
    
    SELECT * FROM at_gln WHERE gln = '9863521530712'
    SELECT * FROM at_gln WHERE gln = '9864066810109'
    SELECT * FROM at_gln WHERE gln = '9863521530712'
    SELECT * FROM at_gln WHERE retailersid = 7

    SELECT compid, * FROM t_inv WHERE orderid = '45347573'

    SELECT * FROM r_uni WHERE RefTypeID = 6680134