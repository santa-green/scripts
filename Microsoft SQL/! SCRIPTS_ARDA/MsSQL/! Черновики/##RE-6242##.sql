--ap_EXITE_CreateMessage
--[ap_Workflow_Create_DECLAR]
SELECT rc.CompGrID2, d.depid, rc.compname, m.zec_kod_kln_ot, m.ZEC_KOD_SKLAD_OT FROM alef_edi_gln_ot m WITH(NOLOCK)
JOIN [S-SQL-D4].[ELIT].dbo.av_at_r_CompOurTerms1 d ON m.zec_kod_kln_ot = d.compid
JOIN [S-SQL-D4].[ELIT].dbo.r_comps rc ON rc.compid = d.compid
--WHERE d.depid != 10000 /*and m.zec_kod_sklad_ot != 30*/
GROUP BY rc.CompGrID2, d.depid, m.zec_kod_kln_ot, m.zec_kod_sklad_ot, rc.compname
ORDER BY m.zec_kod_sklad_ot DESC

SELECT * FROM alef_edi_gln_ot m WITH(NOLOCK) WHERE m.zec_kod_kln_ot = 65439
SELECT * FROM alef_edi_gln_ot m WITH(NOLOCK) WHERE m.zec_kod_kln_ot = 71521

SELECT CompGrID2, * FROM [S-SQL-D4].[ELIT].dbo.r_comps WITH(NOLOCK) WHERE compid = 7001
SELECT * FROM [S-SQL-D4].[ELIT].dbo.r_compsadd WITH(NOLOCK) WHERE compid = 7001
SELECT DepID, * FROM av_at_r_CompOurTerms1 WITH(NOLOCK) WHERE compid = 71527
--SELECT * FROM at_r_CompOurTerms WITH(NOLOCK) WHERE compid = 71527

SELECT * FROM [s-sql-d4].Elit.dbo.z_tables WITH(NOLOCK) WHERE tableName LIKE '%at_r_CompOurTerms%' OR tableDesc LIKE '%at_r_CompOurTerms%';
SELECT * FROM INFORMATION_SCHEMA.TABLES WITH(NOLOCK) WHERE TABLE_NAME like '%at_r_CompOurTerms%'


SELECT m.ZEC_KOD_ADD, rc.CompGrID2 'rc.CompGrID2 - Классификация', rca.CompGrID2 'rca.CompGrID2 - Адреса доставки', d.depid, rc.compname, m.zec_kod_kln_ot, m.ZEC_KOD_SKLAD_OT FROM alef_edi_gln_ot m WITH(NOLOCK)

SELECT * FROM alef_edi_gln_ot m WITH(NOLOCK) WHERE m.ZEC_KOD_KLN_OT = 65439

SELECT * FROM [S-SQL-D4].[ELIT].dbo.r_compsadd rca WITH(NOLOCK) WHERE rca.compid = 65439 and glncode != ''

SELECT * FROM alef_edi_gln_ot m WITH(NOLOCK)
JOIN [S-SQL-D4].[ELIT].dbo.av_at_r_CompOurTerms1 d ON m.zec_kod_kln_ot = d.compid
JOIN [S-SQL-D4].[ELIT].dbo.r_compsadd rca WITH(NOLOCK) ON rca.glncode = m.ZEC_KOD_ADD AND rca.Compid = m.zec_kod_kln_ot
JOIN [S-SQL-D4].[ELIT].dbo.r_comps rc ON rc.compid = d.compid
WHERE m.ZEC_KOD_KLN_OT = 65439
WHERE d.depid = 10000 and rca.CompGrID2 = 2030 and m.ZEC_KOD_SKLAD_OT = 220

GROUP BY m.ZEC_KOD_ADD, rca.CompGrID2, rc.CompGrID2, d.depid, m.zec_kod_kln_ot, m.zec_kod_sklad_ot, rc.compname
ORDER BY m.zec_kod_sklad_ot DESC

SELECT * FROM [S-SQL-D4].[ELIT].dbo.r_compsadd WITH(NOLOCK) WHERE compid = 4735

SELECT rc.CompGrID2, rca.CompGrID2, * FROM alef_edi_gln_ot m WITH(NOLOCK)

SELECT rca.CompGrID2 'rca.CompGrID2 - Адреса доставки', d.depid, m.ZEC_KOD_SKLAD_OT, '--', m.ZEC_KOD_ADD, rc.CompGrID2 'rc.CompGrID2 - Классификация', rc.compname, m.zec_kod_kln_ot FROM alef_edi_gln_ot m WITH(NOLOCK)
JOIN [S-SQL-D4].[ELIT].dbo.av_at_r_CompOurTerms1 d ON m.zec_kod_kln_ot = d.compid
JOIN [S-SQL-D4].[ELIT].dbo.r_comps rc ON rc.compid = d.compid
JOIN [S-SQL-D4].[ELIT].dbo.r_compsadd rca WITH(NOLOCK) ON rca.glncode = m.ZEC_KOD_ADD AND rca.Compid = m.zec_kod_kln_ot
WHERE d.depid = 10000 and rca.CompGrID2 = 2030 and m.ZEC_KOD_SKLAD_OT = 220
ORDER BY COMPNAME DESC

--TRAN
BEGIN
BEGIN TRAN
    SELECT * FROM alef_edi_gln_ot m WITH(NOLOCK) WHERE m.ZEC_KOD_ADD in ('9864232368946', '9864232293187', '9864066870738', '9864232348061')
    SELECT * FROM alef_edi_gln_ot WITH(ROWLOCK, UPDLOCK) ORDER BY 1 DESC
        update alef_edi_gln_ot WITH(ROWLOCK) SET ZEC_KOD_SKLAD_OT = 30 WHERE ZEC_KOD_ADD in ('9864232368946', '9864232293187', '9864066870738', '9864232348061')
    SELECT * FROM alef_edi_gln_ot WITH(ROWLOCK, UPDLOCK) ORDER BY 1 DESC
    SELECT * FROM alef_edi_gln_ot m WITH(NOLOCK) WHERE m.ZEC_KOD_ADD in ('9864232368946', '9864232293187', '9864066870738', '9864232348061')
ROLLBACK TRAN
END;







