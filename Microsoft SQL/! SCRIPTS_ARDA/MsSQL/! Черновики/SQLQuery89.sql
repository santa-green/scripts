EXEC [s-sql-d4].[elit].dbo.af_Get_tInv_by_EDI_Order '  ÐÎÇ10659346  '
/*ÏÅÐÅÎÒÏÐÀÂÊÀ ÐÎÇÅÒÊÈ*/          EXEC [S-PPC.CONST.ALEF.UA].[alef_elit].[dbo].[ap_EDI_Resend_COMDOC_Rozetka] 'ÐÎÇ10659346';

DECLARE @chid varchar = 200537704

SELECT DISTINCT reg.ID
,               (SELECT ChID
FROM [S-SQL-D4].ELIT.dbo.t_Inv
WHERE TaxDocID != 0
	AND OrderID = reg.ID)
FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.at_EDI_reg_files reg
WHERE [Status] = 3
	AND DocType = 24000
	AND Notes LIKE 'DESADV%'
	AND InsertData > '2019-10-21'
	AND RetailersID = 17154 --17154 - ñåòü Ðîçåòêà

SELECT CstProdCode, * FROM [s-sql-d4].[elit].dbo.t_PInP WHERE ProdID = 33235
SELECT CstProdCode, * FROM [s-sql-d4].[elit_test].dbo.t_PInP WHERE ProdID = 33235
SELECT CstProdCode, * FROM [s-sql-d4].[elit].dbo.t_PInP WHERE ProdID = 34867

SELECT CstProdCode, * FROM [s-sql-d4].[elit].dbo.t_PInP WHERE ProdID = 3248
SELECT CstProdCode, * FROM [s-sql-d4].[elit].dbo.t_PInP WHERE ProdID = 26139
SELECT CstProdCode, * FROM [s-sql-d4].[elit].dbo.t_PInP WHERE ProdID = 34867

IF EXISTS (
    SELECT td.ProdID, pp.CstProdCode, pp.PPID, pp.* FROM t_inv ti
    JOIN t_InvD td ON ti.ChID = td.ChID
    LEFT JOIN    dbo.t_PInP              pp WITH(NOLOCK) ON pp.ProdID = td.ProdID and pp.PPID = td.PPID
    WHERE ti.chid = 200519848
    and (pp.CstProdCode = '' OR pp.CstProdCode IS NULL)
) SELECT 'go to the next step...CONTINUE'


SELECT TOP 10 OrderID, * FROM T_INV WHERE CompID = 7136 ORDER BY DocDate DESC
SELECT * FROM t_InvD WHERE ChID = 200519336




SELECT top(1000) *
FROM dbo.at_z_filesExchange
WHERE 1 = 1
    --and docdate = convert(date, getdate(), 102)
	--and [filename] like '%desadv%'
ORDER BY doctime DESC
