USE [Elit]
GO
/****** Object:  StoredProcedure [dbo].[af_tax_rpl_check_unregistered]    Script Date: 18.03.2021 19:00:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[af_tax_rpl_check_unregistered] (@compid int, @date date)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*DESCRIPTON*/ --'2021-03-18 19:01' rkv0 Проверяет какие налоговые незарегистрированные остались
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*test
SELECT * FROM [dbo].[af_tax_rpl_check_unregistered] (7031, '20210315')
*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
as
begin

DECLARE @list varchar(max)
SELECT @list = COALESCE(@list + ', ', '') + CAST(TaxDocID AS nvarchar) FROM (SELECT TaxDocID FROM t_inv WHERE compid in (@compid) and TaxDocDate = @date) m

DECLARE @duplicate varchar(max) = (
    SELECT [Номер налоговой] FROM [dbo].[af_tax_rpl_check] (@compid, @date, @list) 
    GROUP BY [Номер налоговой] having COUNT([Номер налоговой]) > 1
    )

SELECT * FROM [dbo].[af_tax_rpl_check] (@compid, @date, @list) WHERE AER_RPL_STATUS = 1
SELECT * FROM [dbo].[af_tax_rpl_check] (@compid, @date, @duplicate)
end;

GO
