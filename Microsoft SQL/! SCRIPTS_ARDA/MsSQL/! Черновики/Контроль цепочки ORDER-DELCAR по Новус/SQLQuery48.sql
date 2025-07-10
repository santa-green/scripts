SELECT * FROM t_inv WHERE TaxDocID = 4025 and CompID in (7001, 7003)
SELECT * FROM t_inv WHERE TaxDocID = 3126 and CompID in (7136, 7138)
SELECT * from dbo.af_GetCompInfo('7001')
SELECT * from dbo.af_GetCompInfo('7003')

SELECT * FROM dbo.[af_tax_rpl_check_all] (7003, 2021, 8, '4025')
SELECT * FROM dbo.[af_tax_rpl_check_all] (7003, 2021, 8, '6020')
SELECT * FROM dbo.[af_tax_rpl_check_all] (7158, 2021, 8, '3126')

sp_helptext '[af_tax_rpl_check_all]'
SELECT * FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.[av_EDI_ALEF_EDI_RPL] WHERE AER_TAX_ID = 4025
SELECT * FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.at_EDI_reg_files WHERE id = '40252'
SELECT * FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.[av_EDI_ALEF_EDI_RPL] WHERE AER_TAX_ID = 3126
SELECT * FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.at_EDI_reg_files WHERE DocType in(2000, 8000) and retailersid = 252 and insertdata >= '20210801'
EXEC dbo.ap_Get_tInv_by_EDI_Order '4516766927'

SELECT * FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.at_EDI_reg_files WHERE DocType in (2000, 8000) and retailersid = 252 AND ID = '4516766927'
SELECT * FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.at_EDI_reg_files WHERE DocType in(2000, 8000) and retailersid = 252 and insertdata >= '20210801' 
    --and insertdata >= '20210801' and id like '%3030%'
    and insertdata >= '20210801' and SUBSTRING(ID, 1, 5) = 30302

SELECT * FROM at_EDI_reg_files WHERE ChID IN (103493) and [status] = 10
SELECT * FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.at_EDI_reg_files WHERE [filename] = '32000037029549J1201012100025033210820213200.RPL'


BEGIN TRAN
	UPDATE at_EDI_reg_files SET [status] = 11 
        WHERE EXISTS (
            SELECT * FROM at_EDI_reg_files WITH(NOLOCK) WHERE DocType = 8000 AND SUBSTRING(ID, 1, 4) = (
                                                                                        SELECT taxdocid FROM [s-sql-d4].[elit].dbo.t_inv where orderid = (
                                                                                            SELECT ID FROM at_EDI_reg_files WHERE DocType = 2000)
                                                                                        )
            )
ROLLBACK TRAN


SELECT * FROM at_EDI_reg_files WHERE [FileName] LIKE '%.rpl' AND [Status] != 0 AND InsertData > '20201112 19:00' ORDER BY LastUpdateData DESC



/*CompID и RetailersID отличаются только полем в Select*/

BEGIN TRAN
    BEGIN
    DECLARE @CHID varchar(max) = 104174
    SELECT * FROM at_EDI_reg_files WHERE ChID = @CHID

    DECLARE @compid varchar(max) = '32049199'
    DECLARE @FileName varchar(max) = '32000037029549J1201012100004025210820213200.RPL'

    UPDATE dbo.at_EDI_reg_files SET 
    CompID = (SELECT rc.CompID FROM [s-sql-d4].[elit].dbo.r_comps rc JOIN [s-sql-d4].[elit].dbo.r_Uni ru ON ru.refid = rc.compid WHERE ru.RefTypeID = 6680117 AND rc.code = CAST(@compid AS varchar) AND rc.taxcode != '0' AND rc.CompGrID2 like '2%'
    AND rc.CompID IN (SELECT CompID FROM [s-sql-d4].[elit].dbo.t_Inv WHERE TaxDocID = SUBSTRING(ID, 1, LEN(ID) - 1))
    ),
    RetailersID = (SELECT DISTINCT(ru.Notes) FROM [s-sql-d4].[elit].dbo.r_comps rc JOIN [s-sql-d4].[elit].dbo.r_Uni ru ON ru.refid = rc.compid WHERE ru.RefTypeID = 6680117 AND rc.code = CAST(@compid AS varchar) AND rc.taxcode != '0' AND rc.CompGrID2 like '2%')  
    WHERE [FileName] = @FileName AND chid = (SELECT MAX(CHID) FROM at_EDI_reg_files WHERE [FileName] = @FileName);

    SELECT * FROM at_EDI_reg_files WHERE ChID = @CHID 

    END
ROLLBACK TRAN



--SELECT MAX(rc.CompID) 
SELECT rc.CompID
FROM [s-sql-d4].[elit].dbo.r_comps rc 
JOIN [s-sql-d4].[elit].dbo.r_Uni ru ON ru.refid = rc.compid 
WHERE ru.RefTypeID = 6680117 AND rc.code = CAST('32049199' AS varchar) AND rc.taxcode != '0' AND rc.CompGrID2 like '2%'
AND rc.CompID = (SELECT CompID FROM [s-sql-d4].[elit].dbo.t_Inv WHERE SUBSTRING(
    ID, 1, LEN(ID) - 1 
))

SELECT * FROM r_comps where Code = '32049199' and taxcode != '0' AND CompGrID2 like '2%' and compid in (7001, 7003)
SELECT * FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.at_EDI_reg_files where id = '300702'
SELECT CompID, * FROM t_Inv WHERE TaxDocID = SUBSTRING((SELECT ID FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.at_EDI_reg_files WHERE ChID = 107476), 1, 5)

select SUBSTRING('300702', 1, LEN('300702') - 1)
SELECT * FROM at_EDI_reg_files WHERE [FileName] = '32000037029549J1201012100031122410820213200.RPL'
SELECT * FROM [s-sql-d4].[elit].dbo.T_iNV WHERE TAXDOCID = 31122 ORDER BY COMPID DESC
SELECT * from af_GetCompInfo('7001')

SELECT * INTO tempdb..backup_at_EDI_reg_files
FROM at_EDI_reg_files WITH(TABLOCK)

SELECT * FROM at_EDI_reg_files WHERE [FileName] LIKE '%.rpl' AND [Status] != 0 AND InsertData > '20210731'


SELECT * FROM dbo.[af_tax_rpl_check_all] (7158, 2021, 8, '26136,26228,27264,27267,28048,28049,31120')
SELECT * FROM dbo.[af_tax_rpl_check_all] (7138, 2021, 8, '26136')

BEGIN TRAN
SELECT * FROM dbo.at_EDI_reg_files WHERE [filename] in ('32000037029549J1201012100028048410820213200.RPL', '32000037029549J1201012100028049410820213200.RPL', '32000037029549J1201012100027267610820213200.RPL', '32000037029549J1201012100027264410820213200.RPL', '32000037029549J1201012100026136410820213200.RPL', '32000037029549J1201012100026228410820213200.RPL')
UPDATE dbo.at_EDI_reg_files SET CompID = 7136 WHERE [filename] in ('32000037029549J1201012100028048410820213200.RPL', '32000037029549J1201012100028049410820213200.RPL', '32000037029549J1201012100027267610820213200.RPL', '32000037029549J1201012100027264410820213200.RPL', '32000037029549J1201012100026136410820213200.RPL', '32000037029549J1201012100026228410820213200.RPL')
SELECT * FROM dbo.at_EDI_reg_files WHERE [filename] in ('32000037029549J1201012100028048410820213200.RPL', '32000037029549J1201012100028049410820213200.RPL', '32000037029549J1201012100027267610820213200.RPL', '32000037029549J1201012100027264410820213200.RPL', '32000037029549J1201012100026136410820213200.RPL', '32000037029549J1201012100026228410820213200.RPL')
ROLLBACK TRAN

SELECT * FROM dbo.at_EDI_reg_files WHERE ID like '%26136%'
SELECT * FROM t_inv WHERE TaxDocID in ('26136', '26228', '27264', '27267', '28048', '28049', '31120') and DocDate >= '20210801'


--multiple cte.
;WITH 
    sample1_cte ([Предприятие Код], [Предприятие Название]) as (SELECT compid, compname FROM r_comps WHERE compid = 1),
    sample2_cte ([Предприятие Код], [Предприятие Название]) as (SELECT compid, compname FROM r_comps WHERE compid = 2)
SELECT * FROM sample1_cte m1
full join sample2_cte m2 ON m1.[Предприятие Код] = m2.[Предприятие Код]

sp_helptext '[ap_EXITE_EDIN_billing_check]'

SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0)