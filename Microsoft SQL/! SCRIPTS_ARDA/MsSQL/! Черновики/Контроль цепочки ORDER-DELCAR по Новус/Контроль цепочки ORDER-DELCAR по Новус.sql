USE Elit
GO

DECLARE Novus_taxdocs CURSOR LOCAL FAST_FORWARD FOR
SELECT TaxDocID, TaxDocDate FROM t_Inv WHERE OrderID IN (
    SELECT ID
    FROM [S-PPC.CONST.ALEF.UA].[alef_elit_test].dbo.at_EDI_reg_files
    WHERE 1 = 1
        and RetailersID = 252 
	    and DocType = 2000
        and InsertData >= '20210801' 
        and [status] = 10 --меняем статус на 50: цепочка ORDERS-DECLAR закрыта.
    )  and CompID = 7031 and TaxDocID <> 0

    DECLARE @taxdocid int, @taxdocdate date

    OPEN Novus_taxdocs
    FETCH NEXT FROM Novus_taxdocs INTO @taxdocid, @taxdocdate
    WHILE @@FETCH_STATUS = 0
        BEGIN
    --Ищем квитанцию от ДФС.
    IF 2 = (SELECT [Status] FROM dbo.[af_tax_rpl_check_all] (DEFAULT, 2021, DATEPART(MONTH, @taxdocdate), @taxdocid))
        BEGIN
            UPDATE [S-PPC.CONST.ALEF.UA].[alef_elit_test].dbo.at_EDI_reg_files SET [Status] = 50 WHERE ID = '4516927596' and compid = 7031 and [Status] = 10
        END
    ELSE
        BEGIN
            DECLARE @subject varchar(max) = 'Не закрыта цепочка EDI по заказу № ' + '4516927596'

            EXEC msdb.dbo.sp_send_dbmail  
            @profile_name = 'arda',
            @from_address = '<support_arda@const.dp.ua>',
            @recipients = 'rumyantsev@const.dp.ua',
            --@copy_recipients = 'support_arda@const.dp.ua',
            @subject = @subject,
            @body = 'TEST',  
            @body_format = 'HTML',
            @append_query_error = 1
        END          
    
    FETCH NEXT FROM Novus_taxdocs INTO @taxdocid, @taxdocdate
        END;
    CLOSE Novus_taxdocs
    DEALLOCATE Novus_taxdocs
			





