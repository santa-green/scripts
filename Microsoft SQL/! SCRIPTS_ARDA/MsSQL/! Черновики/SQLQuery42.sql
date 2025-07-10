  
ALTER PROCEDURE [dbo].[TEST_ap_EXITE_EDI_chain_control] @test tinyint = NULL  
as  
--Исходные данные.  
BEGIN  
  
/*  
EXEC dbo.[ap_EXITE_EDI_chain_control] @test = 1  
*/  
    DECLARE @recipients varchar(max)    
    SET @recipients = (SELECT CASE WHEN @test = 1 THEN 'rumyantsev@const.dp.ua' ELSE 'support_arda@const.dp.ua;tancyura@const.dp.ua;bibik@const.dp.ua' END)    
  
    IF GETDATE() >= '20211001'  
    BEGIN  
        DECLARE @start_date varchar(max) = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0)  
        SELECT @start_date   
    END  
    ELSE  
    BEGIN  
        --SELECT @start_date = '20210823' --в входящем реестре неправильно обновлялись compid (с 01.09.2021 уже норм).  
        SELECT @start_date = '20210820' --в входящем реестре неправильно обновлялись compid (с 01.09.2021 уже норм).  
        SELECT @start_date   
    END  
  
    IF OBJECT_ID('tempdb..#html', 'U') IS NOT NULL DROP TABLE #html    
    CREATE TABLE #html ([№ Заказа] varchar(250), [Код предприятия] int, [Предприятие] varchar(1000), [№ Налоговой] int, [Дата налоговой] date)  
  
END  
  
--CURSOR STARTS.  
DECLARE @compid int  
DECLARE cursor_tax CURSOR LOCAL FAST_FORWARD FOR  
--SELECT DISTINCT(compid) from r_comps WHERE CompID IN (7001, 7003, 7138, 7136, 7031, 7144, 7013, 7018, 7016)  
SELECT DISTINCT(compid) from r_comps WHERE CompID IN (7001, 7003)  
  
OPEN cursor_tax  
FETCH NEXT FROM cursor_tax INTO @compid  
WHILE @@FETCH_STATUS = 0  
BEGIN  

DECLARE @COMPID int = 7001
DECLARE @start_date date = '20210120'
    ;WITH cte as (SELECT OrderID, Compid, (SELECT CompShort FROM r_comps rc WHERE rc.CompID = @compid) 'CompShort', TaxDocID, TaxDocDate   
                    FROM t_Inv WITH(NOLOCK) WHERE OrderID IN (  
        --SELECT ID  
        SELECT Notes  
        FROM [S-PPC.CONST.ALEF.UA].[alef_elit_test].dbo.at_EDI_reg_files WITH(NOLOCK)  
        WHERE CompID IN (@compid)   
         and DocType = 5000  
            and CAST(InsertData AS date) >= @start_date  
            and [status] = 31   
        )  and CompID IN (@compid) and TaxDocID <> 0 and OurID = 1 and CAST(TaxDocDate AS date) >= @start_date  
    )
    SELECT * FROM cte

    INSERT INTO #html  
    SELECT OrderID, Compid, CompShort, TaxDocID, TaxDocDate FROM cte  
    OUTER APPLY dbo.[af_tax_rpl_check_all] (@compid, DATEPART(YEAR, TaxDocDate), DATEPART(MONTH, TaxDocDate), TaxDocID) rpl  
    WHERE [Status] IS NULL AND CAST(TaxDocDate AS date) < CAST(GETDATE() AS date)  
  
    FETCH NEXT FROM cursor_tax INTO @compid  
END;  
CLOSE cursor_tax  
DEALLOCATE cursor_tax  
--CURSOR ENDS.  
  
SELECT * FROM #html  
  
IF EXISTS (  
SELECT TOP 1 1 FROM #html  
)  
    BEGIN  
    --Блок отправки email.  
    DECLARE @subject varchar(max) = 'Не закрыты цепочки EDI по заказам'  
    DECLARE @body varchar(max)    
    DECLARE @msg varchar(max)    
    SET @msg = '<p style="font-size: 14; color: Purple"> Возможные причины: не подписана/получена приходная, не отправлена/не подписана расходная по Розетке, не отправлена на регистрацию/не зарегистрированная налоговая </p>' +    
        '<p edo-v2.edin.ua/app/#/service/edi/chain/list/outbox/0 </p>' +  
        '<p style="font-size: 12; color: gray"><i>[для администратора БД] Отправлено [D4] JOB "ELIT EDIN_control" [ap_EXITE_EDI_chain_control] )</i></p>'    
    
    DECLARE @head_html varchar(max) = NULL    
    DECLARE @table varchar(max) = '#html'    
      
    SELECT @head_html = ISNULL(@head_html, '') + '<th>' + COLUMN_NAME + '</th>'    
    FROM tempdb.INFORMATION_SCHEMA.COLUMNS    
    WHERE TABLE_NAME = (SELECT [name]    
                        FROM tempdb.sys.tables    
                        WHERE object_id = OBJECT_ID('tempdb..' + @table))    
    ORDER BY ORDINAL_POSITION    
    
        DECLARE @fields_html varchar(max) = NULL    
        SELECT @fields_html = ISNULL(@fields_html, '') + CASE WHEN @fields_html IS NULL THEN ''    
                            ELSE ',' END + QUOTENAME(COLUMN_NAME) + ' as td'    
        FROM tempdb.INFORMATION_SCHEMA.COLUMNS    
        WHERE TABLE_NAME = (SELECT [name]    
                            FROM tempdb.sys.tables    
                            WHERE object_id = OBJECT_ID('tempdb..' + @table))    
        ORDER BY ORDINAL_POSITION    
    
     DECLARE @SQL NVARCHAR(4000);    
        DECLARE @result NVARCHAR(MAX)    
        SET @SQL = 'SELECT @result = (    
            SELECT '+ @fields_html +' FROM #html t FOR XML RAW(''tr''), ELEMENTS    
            )';    
        SELECT @SQL    
        EXEC sp_executesql           @SQL    
        ,                            N'@result NVARCHAR(MAX) output'    
        ,                  @result = @result OUTPUT    
    
        DECLARE @body_html NVARCHAR(MAX)    
  
        SET @body_html = N'<table  bordercolor=#d133ff  border="4"><tr>'   
        + ISNULL(@Head_html, '[sysadmin] FAILED: @Head_html IS NULL') + '</tr>'   
        + ISNULL(@result, '[sysadmin] FAILED: @result IS NULL') + N'</table>'    
  
        SET @body = ISNULL(@body_html, '[sysadmin] FAILED: @body_html IS NULL')   
        + ISNULL(@msg, '[sysadmin] FAILED: @msg IS NULL')    
    
            EXEC msdb.dbo.sp_send_dbmail @profile_name       = 'arda'    
            ,                            @from_address       = '<support_arda@const.dp.ua>'    
            ,                            @recipients         = @recipients    
            ,                            @subject            = @subject    
            ,                            @body               = @body    
            ,                            @body_format        = 'HTML'    
            ,                            @append_query_error = 1    
            ,                            @importance         = 'high'    
    
 END 