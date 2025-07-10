BEGIN TRAN test
BEGIN 
    --устанавливаем параметры, запускаем тест, проверяем, запускаем на горячую.
    DECLARE @declar_list varchar(max) = '7645,7646,7648,7651,7671,7663,7664,7668,7669,7658';
    DECLARE @doc_date date = '20191223';

    IF OBJECT_ID('tempdb..#output_declar', 'U') IS NOT NULL DROP TABLE #output_declar;
    SELECT top(0) * INTO #output_declar FROM at_z_FilesExchange;

    UPDATE at_z_FilesExchange
    SET StateCode = 402
    OUTPUT inserted.* INTO #output_declar
    WHERE [FileName] like '%j12%' 
        AND DocDate = @doc_date
        AND (SELECT [dbo].[zf_MatchFilterInt](FileData.value('(./DECLAR/DECLARBODY/HNUM)[1]','varchar(10)'), @declar_list, ',')) = 1;
    SELECT * FROM #output_declar;
END;
ROLLBACK TRAN test;

