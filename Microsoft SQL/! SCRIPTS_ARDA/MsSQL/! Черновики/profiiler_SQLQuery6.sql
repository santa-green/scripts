SELECT * FROM [s-sql-d4].[elit].dbo.r_comps WHERE CompID in (7136, 7138, 7158)
SELECT * FROM [s-sql-d4].[elit].dbo.r_CompsAdd WHERE CompID in (7136, 7138, 7158) ORDER BY CompID DESC
SELECT * FROM [s-sql-d4].[elit].dbo.r_CompsAdd WHERE compadd like '%Київська обл., м. Бровари, Об''їздна дорога, 62%'
SELECT * FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_GLN_OT WHERE ZEC_KOD_KLN_OT in (7136, 7138, 7158) ORDER BY ZEC_KOD_KLN_OT DESC
SELECT * FROM ALEF_EDI_GLN_OT WHERE ZEC_KOD_KLN_OT in (7136, 7138, 7158) ORDER BY ZEC_KOD_KLN_OT DESC
SELECT * FROM test_profiler
drop table test_profiler
ALEF_WEB_EDI_SETI_CompID