--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHECK*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
DECLARE @compid int = 7031
DECLARE @date date = '20210316'

DECLARE @list varchar(max)
SELECT @list = COALESCE(@list + ', ', '') + CAST(TaxDocID AS nvarchar) FROM (SELECT TaxDocID FROM t_inv WHERE compid in (@compid) and TaxDocDate = @date) m

DECLARE @duplicate varchar(max) = (
    SELECT [Номер налоговой] FROM [dbo].[af_tax_rpl_check] (@compid, @date, @list) 
    GROUP BY [Номер налоговой] having COUNT([Номер налоговой]) > 1
    )

SELECT * FROM [dbo].[af_tax_rpl_check] (@compid, @date, @list) WHERE AER_RPL_STATUS = 1
SELECT * FROM [dbo].[af_tax_rpl_check] (@compid, @date, @duplicate)
