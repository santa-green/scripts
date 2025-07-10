USE [Elit]
GO
/****** Object:  UserDefinedFunction [dbo].[af_tax_rpl_check]    Script Date: 17.03.2021 16:12:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[af_tax_rpl_check] (@compid smallint, @taxdate date, @list varchar(max))
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*DESCRIPTON*/ --rkv0 '2020-11-27 17:35' передаем в параметры номера налоговых и получаем на выход таблицу с деталями по квитанциям дфс.
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*test
SELECT * FROM [dbo].[af_tax_rpl_check] (7031, '20210225', '25011, 25012, 25013, 25014, 25015, 25016, 25017, 25018, 25019, 25020, 25021, 25022, 25023')
*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

RETURNS @result TABLE (
    [check!] varchar(max),
    [Номер налоговой] varchar(max),
    [Дата налоговой] varchar(max), 
    [Квитанция получена нашей системой] varchar(max), 
    Notes varchar(max), 
    [Status] varchar(max), 
    [Предприятие] varchar(max), 
    LastUpdateData varchar(max), 
    RetailersID varchar(max), 
    DocType varchar(max), 
    AER_RPL_DATE varchar(max), 
    AER_RPL_STATUS varchar(max), 
    AER_AUDIT_DATE varchar(max), 
    AER_FILENAME varchar(max))
AS
    BEGIN
        DECLARE @taxid_check TABLE (taxid int) 
        INSERT INTO @taxid_check SELECT * FROM dbo.[af_SplitString] (@list, ',')

        INSERT INTO @result
        SELECT 
            taxid 'check!',
            AER_TAX_ID 'Номер налоговой', 
            AER_TAX_DATE 'Дата налоговой', 
            CONVERT(varchar(16), InsertData, 20) 'Квитанция получена нашей системой', 
            CASE WHEN SUBSTRING(Notes, 1, LEN('Документ прийнято.')) = 'Документ прийнято.' THEN SUBSTRING(Notes, 1, LEN('Документ прийнято.')) ELSE Notes END,
            [Status], 
            CompID 'Предприятие', 
            LastUpdateData, 
            RetailersID, 
            DocType, 
            AER_RPL_DATE, 
            AER_RPL_STATUS, 
            AER_AUDIT_DATE, 
            AER_FILENAME
        
        FROM @taxid_check tic
        LEFT JOIN [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.[av_EDI_ALEF_EDI_RPL] rpl ON rpl.aer_tax_id = tic.taxid 
        left JOIN [S-PPC.CONST.ALEF.UA].Alef_Elit.dbo.at_EDI_reg_files reg ON reg.id = CAST(rpl.AER_RPL_ID as varchar) and reg.[filename] = rpl.AER_FILENAME
        WHERE reg.compid = @compid and rpl.AER_TAX_DATE >= @taxdate

        --ORDER BY [Номер налоговой] DESC
        ORDER BY [Квитанция получена нашей системой] DESC, AER_AUDIT_DATE DESC

        RETURN

    END;






GO
