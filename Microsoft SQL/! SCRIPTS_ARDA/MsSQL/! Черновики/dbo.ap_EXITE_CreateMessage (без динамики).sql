USE [Elit]
GO
/****** Object:  StoredProcedure [dbo].[ap_EXITE_CreateMessage]    Script Date: 01.04.2021 14:41:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[ap_EXITE_CreateMessage] @MsgType VARCHAR(20), @DocCode INT, @ChID INT, @OutChID INT OUTPUT, @ErrMsg VARCHAR(250) OUTPUT
AS

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*DESCRIPTION*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[ap_EXITE_ExportDoc] формирует xml файл, который запихивается сразу в таблицу at_z_FilesExchange (со статусом 402).
--Также в этой процедуре [ap_EXITE_CreateMessage]  формируется имя файла: по COMDOC и DECLAR.

/* TEST
DECLARE @OutChID INT, @ErrMsg VARCHAR(250); exec [ap_EXITE_CreateMessage] @MsgType ='CONTRL', @DocCode = 11012, @ChID = 200479574, @OutChID = @OutChID OUTPUT, @ErrMsg = @ErrMsg OUTPUT; SELECT @OutChID, @ErrMsg
DECLARE @OutChID INT, @ErrMsg VARCHAR(250); exec [ap_EXITE_CreateMessage] @MsgType ='desadv', @DocCode = 11012, @ChID = 200426460, @OutChID = @OutChID OUTPUT, @ErrMsg = @ErrMsg OUTPUT; SELECT @OutChID, @ErrMsg
DECLARE @OutChID INT, @ErrMsg VARCHAR(250); exec [ap_EXITE_CreateMessage] @MsgType ='DECLAR', @DocCode = 11012, @ChID = 200347215, @OutChID = @OutChID OUTPUT, @ErrMsg = @ErrMsg OUTPUT; SELECT @OutChID, @ErrMsg
SELECT top 100 * FROM at_z_FilesExchange ORDER BY 1 DESC
DECLARE @OutChID INT, @ErrMsg VARCHAR(250); exec [ap_EXITE_CreateMessage] @MsgType ='INVOICE', @DocCode = 11012, @ChID = 200437457, @OutChID = @OutChID OUTPUT, @ErrMsg = @ErrMsg OUTPUT; SELECT @OutChID, @ErrMsg
DECLARE @OutChID INT, @ErrMsg VARCHAR(250); exec [ap_EXITE_CreateMessage] @MsgType ='PACKAGE_METRO', @DocCode = 11012, @ChID = 200352402, @OutChID = @OutChID OUTPUT, @ErrMsg = @ErrMsg OUTPUT; SELECT @OutChID, @ErrMsg
SELECT * FROM at_z_FilesExchange WHERE StateCode IN (502,503) ORDER BY 3 DESC
SELECT top 100 * FROM at_z_FilesExchange WHERE StateCode IN (402) AND FILENAME LIKE '%PACKAGE%' ORDER BY 3 DESC
*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--20190110 pvm0 изменение в имени файла, изменен код с 2801 на 2810 (номер ДПI - ОФМС ВЕЛИКИХ ПЛАТНИКИВ) и версия xml c 08 на 10
-- [CHANGED] rkv0 '2020-11-03 14:47' изменил текст сообщения, т.к. office tools ограничивает количество отображаемых символов.
--[ADDED] rkv0 '2020-11-05 15:54' добавил проверку на совпадение количества в РН и в RECADV для сети METRO. Если количества не сходятся, отправка документа СЧЕТ/INVOICE блокируется (выдаем ошибку).
--[FIXED] rkv0 '2020-11-11 13:40' убрал проверку по статусу, т.к. он делает лишнюю блокировку (обратно на 10 его ничто не меняет при корректировке расходной). Оставляем сравнение только по суммам - надежно и достаточно.
--[CHANGED] rkv0 '2021-03-04 15:35' еще с 01.01 изменен номер ДПИ, с 01.03 изменена версия налоговой.
-- [CHANGED] '2021-03-17 10:46' rkv0 изменен номер версии налоговой (заявка №5763).
--[CHANGED] '2021-04-01 12:23' rkv0 фильтруем нулевые RECADV.



SET @OutChID = 0
DECLARE @DocType VARCHAR(20) = @MSGType
DECLARE @CH INT
DECLARE @DID INT
DECLARE @OurID INT
DECLARE @CompID INT
DECLARE @TOKEN INT
DECLARE @X XML
DECLARE @FName VARCHAR(250)

BEGIN TRY
  EXEC [dbo].[ap_EXITE_ExportDoc] @DocType = @DocType, @DocCode = @DocCode, @ChID = @ChID, @Out = @X OUT, @TOKEN = @TOKEN OUT
END TRY
BEGIN CATCH
  SELECT  @ErrMsg = ERROR_MESSAGE() OPTION (MAXRECURSION 0) 
  RETURN
END CATCH

IF @X IS NULL
BEGIN
  -- [CHANGED] rkv0 '2020-11-03 14:47' изменил текст сообщения, т.к. office tools ограничивает количество отображаемых символов.
  --SELECT @ErrMsg = 'Невозможно отправить сообщение по накладной ' + CAST((SELECT DocID FROM dbo.t_Inv WITH(NOLOCK) WHERE ChID = @ChID) AS VARCHAR) 
  --+ '. Возможно, не заполнены соответствующие поля справочников/документов или отсутствует связь накладной с заказом из eXite (заказ получен не из eXite).'
  --+ ' Проверьте в Справочнике предприятий на вкладке Адреса доставки в строчке с адресом должен быть указан Номер GLN (его можно посмотреть  в заказе на сайте-https://edo.edi-n.com)'
  SELECT @ErrMsg = --'Невозможно отправить сообщение по накладной ' + CAST((SELECT DocID FROM dbo.t_Inv WITH(NOLOCK) WHERE ChID = @ChID) AS VARCHAR) 
  'Возможные причины:' + char(10) + char(13) + '1) В справочнике предприятий -> Адреса доставки -> д.б. указан номер GLN (см. заказ на сайте EDIN)'
  + char(10) + char(13) + '2) Не заполнены соотв. поля справ-ков/док-ов;' + char(10) + char(13) + '3) Заказ получен не из EDIN.'
  RETURN --выход из процедуры.
END

EXEC dbo.z_DocLookup 'OurID', @DocCode, @ChID, @OurID OUT

--[ADDED] rkv0 '2020-11-05 15:54' добавил проверку на совпадение количества в РН и в RECADV для сети METRO. Если количества не сходятся, отправка документа СЧЕТ/INVOICE блокируется (выдаем ошибку).
IF @DocType = 'INVOICE'
BEGIN

--TEST
/*
revert
SELECT system_user
EXECUTE AS LOGIN = 'yaa6'
*/
--TEST

    DECLARE @OrderID varchar(250) = (SELECT OrderID FROM t_Inv WITH(NOLOCK) WHERE ChID = @ChID)
    DECLARE @base_sum int = (SELECT SUM(d.Qty / ISNULL([dbo].[af_GetQtyInUM] (d.ProdID,'метро/един.'),1) ) FROM t_Inv m JOIN t_InvD d ON d.ChID = m.ChID WHERE m.OrderID = @OrderID)
    IF EXISTS (
        SELECT * FROM [S-PPC.CONST.ALEF.UA].[alef_elit].[dbo].[av_EDI_Recadv2Invoice_METRO] WITH(NOLOCK)
            WHERE 1 = 1
            --+ страховка на случай, если вдруг статус каким-то образом изменился с 11 на другой, а количества не сходятся.
            AND Notes = @OrderID
            --[FIXED] rkv0 '2020-11-11 13:40' убрал проверку по статусу, т.к. он делает лишнюю блокировку (обратно на 10 его ничто не меняет при корректировке расходной). Оставляем сравнение только по суммам - надежно и достаточно.
            --([Status] = 11 OR DocSum != @base_sum)
            AND DocSum != @base_sum
            --[CHANGED] '2021-04-01 12:23' rkv0 фильтруем нулевые RECADV.
            AND DocSum != 0
            )
        BEGIN
            SELECT @ErrMsg = 'ВНИМАНИЕ!' + char(10) + char(13) + 'Документ СЧЕТ (ChID = ' + cast(@ChID as varchar) + ') не может быть отправлен, т.к. обнаружено расхождение по количеству бутылок в нашей Расходной накладной и Уведомлении о приёме от сети METRO. Расходная накладная подлежит корректировке.'
            RETURN --выход из блока IF @DocType = 'INVOICE' процедуры.
        END;
END;

IF @DocType = 'DECLAR'
BEGIN 
    --SET @FName =(SELECT '2801'+'00'+dbo.af_GetFiltered(ro.Code)+'J12'+'010'+'08'+'1'+'00'+RIGHT('00000' + CAST(m.TaxDocID AS VARCHAR) + CAST(ISNULL((SELECT COUNT(*) FROM dbo.z_DocLinks zdlt WITH(NOLOCK) JOIN dbo.at_z_FilesExchange zfet WITH(NOLOCK) ON zfet.ChID = zdlt.ChildChID WHERE zdlt.ParentChID = m.ChID AND zdlt.ParentDocCode = 11012 AND zdlt.ChildDocCode = 666029 AND zfet.StateCode = 403),0) + 1 AS VARCHAR), 7)+'1'+  Cast(LEFT(CONVERT(char(10), m.TaxDocDate, 101), 2)as Varchar(max))+Cast (YEAR(m.TaxDocDate) as VARCHAR(MAX))+'2801'+'.xml'
    --20190110 pvm0 изменение в имени файла, изменен код с 2801 на 2810 (номер ДПI - ОФМС ВЕЛИКИХ ПЛАТНИКИВ) и версия xml c 08 на 10
    
    --[CHANGED] rkv0 '2021-03-04 15:35' еще с 01.01 изменен номер ДПИ, с 01.03 изменена версия налоговой.
    --SET @FName =(SELECT '2810'+'00'+dbo.af_GetFiltered(ro.Code)+'J12'+'010'+'10'+'1'+'00'+RIGHT('00000' + CAST(m.TaxDocID AS VARCHAR) + CAST(ISNULL((SELECT COUNT(*) FROM dbo.z_DocLinks zdlt WITH(NOLOCK) JOIN dbo.at_z_FilesExchange zfet WITH(NOLOCK) ON zfet.ChID = zdlt.ChildChID WHERE zdlt.ParentChID = m.ChID AND zdlt.ParentDocCode = 11012 AND zdlt.ChildDocCode = 666029 AND zfet.StateCode = 403),0) + 1 AS VARCHAR), 7)+'1'+  Cast(LEFT(CONVERT(char(10), m.TaxDocDate, 101), 2)as Varchar(max))+Cast (YEAR(m.TaxDocDate) as VARCHAR(MAX))+'2810'+'.xml'
    --спецификация EDIN по формировании имени файла здесь: --https://wiki.edin.ua/uk/latest/XML/XML-structure.html#declar
    SET @FName = (SELECT 
          '3200' --код ДПИ получателя [4 символа, <C_REG>, <C_RAJ>].
        + '00' + dbo.af_GetFiltered(ro.Code) --код ЕДРПОУ [10 символов, <TIN>]
        + 'J12' --код документа "налоговая накладная" [3 символа, <C_DOC>]
        + '010' --подтип документа [3 символа, <C_DOC_SUB>]
        -- [CHANGED] '2021-03-17 10:46' rkv0 изменен номер версии налоговой (заявка №5763).
        --+ '11' --номер версии документа [2 символа, <C_DOC_VER>]
        + '12' --номер версии документа [2 символа, <C_DOC_VER>]
        + '1' --состояние документа [1 символ, <C_DOC_STAN>]
        + '00' --номер нового отчетного (уточняющего) документа в отчетном периоде [2 символа, <C_DOC_TYPE>]
        + RIGHT('00000' + CAST(m.TaxDocID AS VARCHAR) + CAST(ISNULL((SELECT COUNT(*) FROM dbo.z_DocLinks zdlt WITH(NOLOCK) JOIN dbo.at_z_FilesExchange zfet WITH(NOLOCK) ON zfet.ChID = zdlt.ChildChID WHERE zdlt.ParentChID = m.ChID AND zdlt.ParentDocCode = 11012 AND zdlt.ChildDocCode = 666029 AND zfet.StateCode = 403),0) + 1 AS VARCHAR), 7) --(например: 0003039) порядковый номер документа, который может отправляться несколько раз в одном отчетном периоде [7 символов, <C_DOC_CNT>]
        + '1' --числовой код типа отчетного периода (1 - месяц, 2 - квартал, 3 - полугодие, 4 - девять месяцев, 5 - год) [1 символ, <PERIOD_TYPE>].
        + Cast(LEFT(CONVERT(char(10), m.TaxDocDate, 101), 2) as varchar(max)) --отчетный месяц [2 символа, <PERIOD_MONTH>]
        + Cast(YEAR(m.TaxDocDate) as varchar(MAX)) --отчетный год [2 символа, <PERIOD_YEAR>]
        + '3200' --код ДПИ получателя [4 символа, <C_REG>, <C_RAJ>]. Если это не копия, а оригинал, то код один и тот же в начале и в конце файла.
        + '.xml'
    FROM dbo.t_Inv m WITH(NOLOCK)
    JOIN dbo.r_Ours ro WITH(NOLOCK) ON ro.OurID = m.OurID
    Where m.Chid = @ChID)
END

--rkv0 '2019-11-11 00:00' добавил блок для PACKAGE_METRO
ELSE IF @DocType = 'COMDOC_METRO' 
BEGIN
    --вместо @ChID можно подставить любое другое значение, т.к. этот момент не регламетнирован Metro.
    SET @FName = 'documentinvoice_' + convert(varchar,getdate(), 112) + replace(left(convert(time,getdate()),5),':','') + '_' + CAST(@ChID AS varchar(20)) + '.xml';
END

--rkv0 '2019-11-18 13:38' добавил блок для PACKAGE_METRO
ELSE IF @DocType = 'PACKAGE_METRO' 
BEGIN
    --вместо @ChID можно подставить любое другое значение, т.к. этот момент не регламетнирован Metro.
    SET @FName = 'packageDescription_' + convert(varchar,getdate(), 112) + replace(left(convert(time,getdate()),5),':','') + '_' + CAST(@ChID AS varchar(20)) + '.xml';
END

ELSE
BEGIN --меняем имя для всех других документов.
    SET @FName = REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR, GETDATE(), 120),'-',''),' ',''),':','') +
    -- '2019-12-10 11:21' rkv0 добавляю ChID
    + '-' + CAST(@ChID AS varchar(20)) +
    RIGHT('00-' + CAST(@OurID AS VARCHAR), 4) +
    '-OUT-' + CAST(@TOKEN AS VARCHAR) + '_' + @DocType + '.xml'
END;


BEGIN TRAN

EXEC dbo.z_NewChID 'at_z_FilesExchange', @CH OUT
EXEC dbo.z_NewDocID 666029, 'at_z_FilesExchange', @OurID, @DID OUT

INSERT dbo.at_z_FilesExchange (ChID,FileTypeID,FileName,DocID,DocDate,DocTime,OurID,StateCode,FileData)
SELECT @CH, 4 FileTypeID, @FName, @DID, dbo.zf_GetDate(GETDATE()), GETDATE(), @OurID, CASE WHEN (SELECT compid from t_inv WHERE ChID = @ChID) in (7001,7003) AND @DocType in ('COMDOC_METRO','DECLAR','PACKAGE_METRO')  THEN 502 ELSE 402 END StateCode, @X --статус 502 назначаем только METRO: comdoc, declar.

EXEC [dbo].[ap_LinkCreate] @PDocCode = @DocCode, @PChID = @ChID, @СDocCode = 666029, @СChID = @CH

EXEC dbo.z_DocLookup 'CompID', @DocCode, @ChID, @CompID OUT

MERGE dbo.r_CompValues AS target
USING (SELECT c.CompID, 'EDIINTERCHANGEID' VarName, RIGHT(@TOKEN, 4) VarValue
  FROM dbo.r_Comps b
  JOIN dbo.r_Comps c ON c.CompID = b.Value1
  WHERE b.CompID = @CompID) AS source (CompID, VarName, VarValue)
ON (target.CompID = source.CompID AND target.VarName = source.VarName)
WHEN MATCHED
  THEN UPDATE SET target.VarValue = source.VarValue
WHEN NOT MATCHED
  THEN INSERT (CompID, VarName, VarValue)
    VALUES (source.CompID, source.VarName, source.VarValue);
    
IF @@ROWCOUNT = 0 ROLLBACK
IF @@TRANCOUNT > 0 COMMIT
SET @OutChID = @CH
RETURN
































GO
