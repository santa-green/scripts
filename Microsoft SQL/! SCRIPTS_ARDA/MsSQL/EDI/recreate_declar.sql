SELECT * FROM r_Uni where RefTypeID = 6680138 and RefName like '%<C_RAJ>%'
SELECT * FROM at_EDI_reg_files WHERE [Status] = 4 ORDER BY LastUpdateData DESC
SELECT * FROM at_EDI_reg_files WHERE InsertData >=  convert(date, GETDATE()-3, 102) and Notes like '%документ не прийнято%' ORDER BY LastUpdateData DESC

SELECT * FROM ALEF_EDI_RPL WHERE AER_RPL_STATUS = 1 and AER_AUDIT_DATE >= convert(date, getdate()-3, 102) ORDER BY AER_AUDIT_DATE DESC --75580
DECLARE @OutChID INT, @ErrMsg VARCHAR(250); exec [ap_EXITE_CreateMessage] @MsgType ='DECLAR', @DocCode = 11012, @ChID = 200352402, @OutChID = @OutChID OUTPUT, @ErrMsg = @ErrMsg OUTPUT; SELECT @OutChID, @ErrMsg
SELECT * FROM ALEF_EDI_RPL WHERE AER_TAX_ID = 31140

SELECT * FROM [elit].dbo.at_z_FilesExchange
WHERE 1 = 1
    and DocTime >= convert(date, '20201201', 102) and DocTime < CONVERT(date, '20210101', 102)
    --and [FileName] like '%J12%'
    and [FileName] like '%comdoc%'
    and StateCode = 403 --503 для METRO!!!! Отправить через resendmetro !!!!!!!!!!!!!!
    --AND FileData.value('(./DECLAR/DECLARBODY/HTINBUY)[1]', 'varchar(100)') IN (36003603)
ORDER BY DocTime DESC
--SELECT * FROM [elit].dbo.at_z_FilesExchange WITH(NOLOCK) ORDER BY DocTime DESC
--select convert(date, GETDATE()-3, 102)

SELECT OrderID, TaxDocID, * FROM t_Inv 
WHERE 1 = 1
and OurID = 1
and DocDate >= '20210315' 
and TaxDocID in (15065,15080,15073,16232,16241,16237,16235)
--and TaxDocID in (4033)
--AND CompID not in (7001, 7003)
AND CompID in (7031)
--30001, 30002 отправлены '2021-01-05 17:12' 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*RECREATE_DECLAR*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Все незарегистрированные налоговые находим здесь:
SELECT * FROM ALEF_EDI_RPL WHERE AER_RPL_STATUS = 1 and AER_AUDIT_DATE >= convert(date, getdate()-3, 102) ORDER BY AER_TAX_ID
SELECT * FROM ALEF_EDI_RPL WHERE AER_RPL_STATUS = 1 and AER_AUDIT_DATE >= convert(date, getdate()-3, 102) ORDER BY AER_AUDIT_DATE DESC --75580
--Для сети METRO.
SELECT * FROM ALEF_EDI_RPL WHERE AER_RPL_STATUS = 1 and AER_AUDIT_DATE >= convert(date, getdate()-3, 102) and AER_FILECONTENT.value('(./DECLAR/DECLARBODY/HTINBUY)[1]', 'varchar(100)') = 32049199 ORDER BY AER_AUDIT_DATE DESC --75580


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*ACTION !!*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF OBJECT_ID('tempdb..#recreate_declar', 'U') IS NOT NULL DROP TABLE #recreate_declar
CREATE TABLE #recreate_declar (CHID varchar(255))
SELECT * FROM #recreate_declar
INSERT INTO #recreate_declar VALUES(200480672)
INSERT INTO #recreate_declar VALUES(200480712)
INSERT INTO #recreate_declar VALUES(200480753)
INSERT INTO #recreate_declar VALUES(200480786)
INSERT INTO #recreate_declar VALUES(200480963)
INSERT INTO #recreate_declar VALUES(200480995)
INSERT INTO #recreate_declar VALUES(200481038)
SELECT * FROM #recreate_declar

BEGIN TRAN

    DECLARE @resend_chid varchar(100)
    DECLARE @OutChID INT, @ErrMsg VARCHAR(250)
    DECLARE re_declar_cursor CURSOR LOCAL FAST_FORWARD FOR
    SELECT * FROM #recreate_declar

    OPEN re_declar_cursor
    FETCH NEXT FROM re_declar_cursor INTO @resend_chid
    WHILE @@FETCH_STATUS = 0
        BEGIN
            EXEC [ap_EXITE_CreateMessage] @MsgType ='DECLAR', @DocCode = 11012, @ChID = @resend_chid, @OutChID = @OutChID OUTPUT, @ErrMsg = @ErrMsg OUTPUT; 
            SELECT @OutChID 'OutChID', @ErrMsg 'Error Message'
            /*
            DECLARE @OutChID INT, @ErrMsg VARCHAR(250); exec [ap_EXITE_CreateMessage] @MsgType ='DECLAR', @DocCode = 11012, @ChID = 200458255, @OutChID = @OutChID OUTPUT, @ErrMsg = @ErrMsg OUTPUT; SELECT @OutChID, @ErrMsg
            */
            FETCH NEXT FROM re_declar_cursor INTO @resend_chid
        END;    
    CLOSE re_declar_cursor;
    DEALLOCATE re_declar_cursor;

    SELECT top(15) * FROM at_z_FilesExchange WHERE StateCode = 402 ORDER BY DocTime DESC
  
ROLLBACK TRAN