USE [Elit]
GO
/****** Object:  StoredProcedure [dbo].[af_tax_rpl_check_unregistered]    Script Date: 19.03.2021 9:47:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[ap_tax_rpl_check_unregistered] @compid int, @date date
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*DESCRIPTON*/ --'2021-03-18 19:01' rkv0 Проверяет какие налоговые незарегистрированные остались
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*test
EXEC [dbo].[ap_tax_rpl_check_unregistered] 7031, '20210315'
*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
as
BEGIN

DECLARE @list varchar(max)
SELECT @list = COALESCE(@list + ', ', '') + CAST(TaxDocID AS nvarchar) FROM (SELECT TaxDocID FROM t_inv WHERE compid in (@compid) and TaxDocDate = @date) m

DECLARE @duplicate_list varchar(max)
SELECT @duplicate_list = COALESCE(@duplicate_list + ', ', '') +
    [Номер налоговой] FROM [dbo].[af_tax_rpl_check_all] (@compid, @date, @list) 
    GROUP BY [Номер налоговой] having COUNT([Номер налоговой]) > 1

--SELECT * FROM [dbo].[af_tax_rpl_check_all] (@compid, @date, @list) WHERE AER_RPL_STATUS = 1
--SELECT * FROM [dbo].[af_tax_rpl_check_all] (@compid, @date, @duplicate_list)

SELECT 'ПОЛУЧЕНА ТОЛЬКО ОДНА ОТРИЦАТЕЛЬНАЯ КВИТАНЦИЯ!', af_un.Notes, * FROM [dbo].[af_tax_rpl_check_all] (@compid, @date, @list) af_all
left JOIN [dbo].[af_tax_rpl_check_all] (@compid, @date, @duplicate_list) af_un ON af_all.[номер налоговой] = af_un.[Номер налоговой]
WHERE af_all.AER_RPL_STATUS = 1 and af_un.Notes is null

END;



GO

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DECLARE @list varchar(max)
DECLARE @compid int = 7031
DECLARE @date date = '20210315'

SELECT @list = COALESCE(@list + ', ', '') + CAST(TaxDocID AS nvarchar) FROM (SELECT TaxDocID FROM t_inv WHERE compid in (@compid) and TaxDocDate = @date) m

DECLARE @duplicate_list varchar(max)
SELECT @duplicate_list = COALESCE(@duplicate_list + ', ', '') +
    [Номер налоговой] FROM [dbo].[af_tax_rpl_check_all] (@compid, @date, @list) 
    GROUP BY [Номер налоговой] having COUNT([Номер налоговой]) > 1

select '111'    
SELECT * FROM [dbo].[af_tax_rpl_check_all] (@compid, @date, @list) WHERE AER_RPL_STATUS = 1
SELECT * FROM [dbo].[af_tax_rpl_check_all] (@compid, @date, @duplicate_list)

SELECT 'ПОЛУЧЕНА ТОЛЬКО ОДНА ОТРИЦАТЕЛЬНАЯ КВИТАНЦИЯ!', af_un.Notes, * FROM [dbo].[af_tax_rpl_check_all] (@compid, @date, @list) af_all
left JOIN [dbo].[af_tax_rpl_check_all] (@compid, @date, @duplicate_list) af_un ON af_all.[номер налоговой] = af_un.[Номер налоговой]
WHERE af_all.AER_RPL_STATUS = 1 and af_un.Notes is null

