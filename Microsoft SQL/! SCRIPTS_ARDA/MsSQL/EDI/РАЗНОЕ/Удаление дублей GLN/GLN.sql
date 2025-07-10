IF OBJECT_ID('Tempdb..#GLN_update', 'U') IS NOT NULL DROP TABLE #GLN_update
create table #gln_update (compid int, gln nvarchar(100))
go
INSERT INTO #gln_update VALUES (7011, '9864066810109')
SELECT * FROM #gln_update


SELECT 1 'duplicates'
SELECT CompID,GLNCode,count(*) dubli 
FROM  r_CompsAdd 
where GLNCode <> '' 
group by CompID,GLNCode 
having count(*) > 1
ORDER BY 1

SELECT 2 'r_CompsAdd'
SELECT * FROM r_CompsAdd WHERE CompID = (select compid from #gln_update) and GLNCode = (select gln from #gln_update)
SELECT 3 'at_GLN'
SELECT * FROM at_GLN WHERE gln = (select gln from #gln_update)
--SELECT 4
--SELECT * FROM at_GLN WHERE gln = '9864232143185'

SELECT 5 'zec_kod_base'
SELECT * FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_GLN_OT WHERE zec_kod_add = (select gln from #gln_update)
SELECT * FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_GLN_OT WHERE zec_kod_kln_ot = (select compid from #gln_update)    

--SELECT 6
--SELECT * FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_GLN_OT WHERE zec_kod_base = '9864232143185'

SELECT 7
SELECT * FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.ALEF_EDI_GLN_OT WHERE zec_kod_kln_ot = (select compid from #gln_update) AND zec_kod_add = (select gln from #gln_update) --AND ZEC_KOD_ADD_OT = 81

--SELECT 8
--SELECT * FROM at_GLN WHERE Adress like '%Маршала Бабаджаняна%'


--TRAN
SELECT 'update!!!!!!!'
BEGIN TRAN
    -- !!!!!!!!!!!! @compaddid !!!!!!!!!!!!
    DECLARE @compaddid int = 56
    SELECT * FROM r_CompsAdd WHERE CompID = (select compid from #gln_update) AND GLNCode = (select gln from #gln_update) AND CompAddID IN (SELECT CompAddID FROM r_CompsAdd WHERE CompID = (select compid from #gln_update) AND GLNCode = (select gln from #gln_update))
    UPDATE r_CompsAdd SET GLNCode = '' WHERE CompID = (select compid from #gln_update) AND GLNCode = (select gln from #gln_update) AND CompAddID = @compaddid
    SELECT * FROM r_CompsAdd WHERE CompID = (select compid from #gln_update) AND GLNCode = (select gln from #gln_update) AND CompAddID = @compaddid
    SELECT * FROM r_CompsAdd WHERE CompID = (select compid from #gln_update) AND GLNCode = (select gln from #gln_update) AND CompAddID IN (SELECT CompAddID FROM r_CompsAdd WHERE CompID = (select compid from #gln_update) AND GLNCode = (select gln from #gln_update))
ROLLBACK TRAN

