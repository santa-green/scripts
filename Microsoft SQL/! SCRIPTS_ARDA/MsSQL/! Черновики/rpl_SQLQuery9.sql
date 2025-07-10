--UPDATE dbo.at_EDI_reg_files SET 
--    CompID = (
    
    DECLARE @compid int = 7001
    SELECT 
    (SELECT rc.CompID FROM [s-sql-d4].[elit].dbo.r_comps rc 
    JOIN [s-sql-d4].[elit].dbo.r_Uni ru ON ru.refid = rc.compid 
    WHERE ru.RefTypeID = 6680117 
        AND rc.code = CAST(@compid AS varchar) 
        AND rc.taxcode != '0' 
        AND rc.CompGrID2 like '2%'
        AND rc.CompID IN (SELECT CompID FROM [s-sql-d4].[elit].dbo.t_Inv WHERE TaxDocID = SUBSTRING(ID, 1, LEN(ID) - 1))
        ) FROM at_EDI_reg_files 
        WHERE [FileName] = '32000037029549J1201012100008004210920213200.RPL' 
        --AND chid = (SELECT MAX(CHID) FROM at_EDI_reg_files WHERE [FileName] = '32000037029549J1201012100008004210920213200.RPL');
        --)
    --    ,
    --RetailersID = (SELECT DISTINCT(ru.Notes) FROM [s-sql-d4].[elit].dbo.r_comps rc JOIN [s-sql-d4].[elit].dbo.r_Uni ru ON ru.refid = rc.compid 
    --WHERE ru.RefTypeID = 6680117 AND rc.code = CAST(@compid AS varchar) AND rc.taxcode != '0' AND rc.CompGrID2 like '2%'
    --)  
    WHERE [FileName] = @FileName AND chid = (SELECT MAX(CHID) FROM at_EDI_reg_files WHERE [FileName] = @FileName);


    UPDATE dbo.at_EDI_reg_files SET 
    CompID = (SELECT rc.CompID FROM [s-sql-d4].[elit].dbo.r_comps rc JOIN [s-sql-d4].[elit].dbo.r_Uni ru ON ru.refid = rc.compid 
        WHERE ru.RefTypeID = 6680117 AND rc.code = CAST(@compid AS varchar) AND rc.taxcode != '0' AND rc.CompGrID2 like '2%'
        AND rc.CompID IN (SELECT CompID FROM [s-sql-d4].[elit].dbo.t_Inv WHERE TaxDocID = SUBSTRING(ID, 1, LEN(ID) - 1))
        ),
    RetailersID = (SELECT DISTINCT(ru.Notes) FROM [s-sql-d4].[elit].dbo.r_comps rc JOIN [s-sql-d4].[elit].dbo.r_Uni ru ON ru.refid = rc.compid 
    WHERE ru.RefTypeID = 6680117 AND rc.code = CAST(@compid AS varchar) AND rc.taxcode != '0' AND rc.CompGrID2 like '2%'
    )  
    WHERE [FileName] = @FileName AND chid = (SELECT MAX(CHID) FROM at_EDI_reg_files WHERE [FileName] = @FileName)


SELECT rc.CompID, * FROM [s-sql-d4].[elit].dbo.r_comps rc JOIN [s-sql-d4].[elit].dbo.r_Uni ru ON ru.refid = rc.compid 
        WHERE ru.RefTypeID = 6680117 AND rc.code = CAST('32049199' AS varchar) AND rc.taxcode != '0' AND rc.CompGrID2 like '2%'
        AND rc.CompID IN (
            SELECT ti.CompID, * FROM [s-sql-d4].[elit].dbo.t_Inv ti, at_EDI_reg_files reg WHERE doctype = 8000 and ti.TaxDocID = SUBSTRING(ID, 1, LEN(ID) - 1)
            and [FileName] = '32000037029549J1201012100008004210920213200.RPL'
            --and ti.chid = (SELECT MAX(chid) FROM [s-sql-d4].[elit].dbo.t_Inv WHERE TaxDocID = SUBSTRING(reg.ID, 1, LEN(reg.ID) - 1))
            and ti.ourid = 1
            and ti.taxdocdate = cast(right('08092021', 4) + substring('08092021', 3, 2) + left('08092021', 2) as date)
            ORDER BY ti.chid DESC
            )
            
select convert(date, '08092021', 102)
SELECT CONVERT(DATETIME, CONVERT(VARCHAR, CONVERT(DATE, '08092021', 103), 102))
select convert(datetime, '23072009', 103)

declare @D varchar(8)
declare @taxdocdate date = '23072009'
select cast(right(@taxdocdate, 4) + substring(@taxdocdate, 3, 2) + left(@taxdocdate, 2) as date)

declare @D varchar(8)
set @D = '23072009'

select cast(right(@D, 4)+substring(@D, 3, 2)+left(@D, 2) as date)



SELECT * FROM [s-sql-d4].[elit].dbo.t_Inv WHERE taxdocid = 8005

--SELECT * FROM [s-sql-d4].[elit].dbo.R_COMPS WHERE CODE = '32049199'
SELECT * FROM at_EDI_reg_files WHERE [FileName] = '32000037029549J1201012100008004210920213200.RPL'
SELECT * FROM at_EDI_reg_files WHERE [FileName] = '32000037029549J1201012100008005210920213200.RPL'
SELECT MAX(CHID) FROM at_EDI_reg_files WHERE [FileName] = '32000037029549J1201012100008004210920213200.RPL'
SELECT [FileName] FROM at_EDI_reg_files WHERE [FileName] LIKE '%.rpl' AND [Status] = 0 AND InsertData > '20201112 19:00'

SELECT * FROM at_EDI_reg_files WHERE [FileName] = '32000037029549J1201012100008004210920213200.RPL'

BEGIN TRAN
	SELECT * FROM at_EDI_reg_files WHERE chid = 108235 
	UPDATE at_EDI_reg_files SET [status] = 0 WHERE chid = 108235
	SELECT * FROM at_EDI_reg_files WHERE chid = 108235 
ROLLBACK TRAN


SELECT * FROM [s-sql-d4].[elit].dbo.t_Inv WHERE taxdocid = 8005

SELECT ti.CompID, ti.taxdocid, ti.taxdocdate, reg.* 
FROM [s-sql-d4].[elit].dbo.t_Inv ti
JOIN at_EDI_reg_files reg ON ti.TaxDocID = SUBSTRING(reg.ID, 1, LEN(reg.ID) - 1)
WHERE doctype = 8000 
    --and reg.[FileName] = '32000037029549J1201012100008005210920213200.RPL'
    --and reg.chid = (SELECT MAX(CHID) FROM at_EDI_reg_files WHERE [FileName] = '32000037029549J1201012100008005210920213200.RPL')
    and ti.chid = (SELECT MAX(CHID) FROM [s-sql-d4].[elit].dbo.t_Inv WHERE ti.TaxDocID = SUBSTRING(reg.ID, 1, LEN(reg.ID) - 1))

SELECT * FROM [s-sql-d4].[elit].dbo.t_Inv where intdocid = 3440778
SELECT * FROM [s-sql-d4].[elit].dbo.t_Invd where chid = 200548087


DECLARE @comp_ecode varchar(max) = '32049199'
DECLARE @FileName varchar(max) = '32000037029549J1201012100008004210920213200.RPL'
DECLARE @taxdocid int = 8004
DECLARE @taxdocdate varchar(8) = '08092021'
select cast(right(@taxdocdate, 4) + substring(@taxdocdate, 3, 2) + left(@taxdocdate, 2) as date)
BEGIN TRAN
	SELECT * FROM at_EDI_reg_files WHERE chid = 108235 

	UPDATE dbo.at_EDI_reg_files SET 
    CompID = (SELECT rc.CompID FROM [s-sql-d4].[elit].dbo.r_comps rc JOIN [s-sql-d4].[elit].dbo.r_Uni ru ON ru.refid = rc.compid 
        WHERE ru.RefTypeID = 6680117 AND rc.code = CAST(@comp_ecode AS varchar) AND rc.taxcode != '0' AND rc.CompGrID2 like '2%'
        AND rc.CompID IN (
            SELECT CompID FROM [s-sql-d4].[elit].dbo.t_Inv WHERE TaxDocID = @taxdocid 
                                                        AND TaxDocDate = cast(right(@taxdocdate, 4) + substring(@taxdocdate, 3, 2) + left(@taxdocdate, 2) as date))
        )
        ,
    RetailersID = (SELECT DISTINCT(ru.Notes) FROM [s-sql-d4].[elit].dbo.r_comps rc JOIN [s-sql-d4].[elit].dbo.r_Uni ru ON ru.refid = rc.compid 
    WHERE ru.RefTypeID = 6680117 AND rc.code = CAST(@comp_ecode AS varchar) AND rc.taxcode != '0' AND rc.CompGrID2 like '2%'
    )  
    WHERE [FileName] = @FileName AND chid = (SELECT MAX(CHID) FROM at_EDI_reg_files WHERE [FileName] = @FileName);

	SELECT * FROM at_EDI_reg_files WHERE chid = 108235 
ROLLBACK TRAN
