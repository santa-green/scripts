USE [Elit]
GO
/****** Object:  StoredProcedure [dbo].[ap_EXITE_CreateMessage]    Script Date: 09.11.2020 17:07:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[ap_EXITE_CreateMessage] @MsgType VARCHAR(20), @DocCode INT, @ChID INT, @OutChID INT OUTPUT, @ErrMsg VARCHAR(250) OUTPUT
AS
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*CHANGELOG*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- [CHANGED] rkv0 '2020-11-03 14:47' ������� ����� ���������, �.�. office tools ������������ ���������� ������������ ��������.
--[ADDED] rkv0 '2020-11-05 15:54' ������� �������� �� ���������� ���������� � �� � � RECADV ��� ���� METRO. ���� ���������� �� ��������, �������� ��������� ����/INVOICE ����������� (������ ������).


--20190110 pvm0 ��������� � ����� �����, ������� ��� � 2801 �� 2810 (����� ��I - ���� ������� ���������) � ������ xml c 08 �� 10
/*
DECLARE @OutChID INT, @ErrMsg VARCHAR(250); exec [ap_EXITE_CreateMessage] @MsgType ='desadv', @DocCode = 11012, @ChID = 200426460, @OutChID = @OutChID OUTPUT, @ErrMsg = @ErrMsg OUTPUT; SELECT @OutChID, @ErrMsg
DECLARE @OutChID INT, @ErrMsg VARCHAR(250); exec [ap_EXITE_CreateMessage] @MsgType ='INVOICE', @DocCode = 11012, @ChID = 200437457, @OutChID = @OutChID OUTPUT, @ErrMsg = @ErrMsg OUTPUT; SELECT @OutChID, @ErrMsg
DECLARE @OutChID INT, @ErrMsg VARCHAR(250); exec [ap_EXITE_CreateMessage] @MsgType ='PACKAGE_METRO', @DocCode = 11012, @ChID = 200352402, @OutChID = @OutChID OUTPUT, @ErrMsg = @ErrMsg OUTPUT; SELECT @OutChID, @ErrMsg
SELECT * FROM at_z_FilesExchange WHERE StateCode IN (502,503) ORDER BY 3 DESC
SELECT top 100 * FROM at_z_FilesExchange ORDER BY 1 DESC
SELECT top 100 * FROM at_z_FilesExchange WHERE StateCode IN (402) AND FILENAME LIKE '%PACKAGE%' ORDER BY 3 DESC


*/
--[ap_EXITE_ExportDoc] ��������� xml ����, ������� ������������ ����� � ������� at_z_FilesExchange (�� �������� 402).
--����� � ���� ��������� [ap_EXITE_CreateMessage]  ����������� ��� �����: �� COMDOC � DECLAR.

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
  -- [CHANGED] rkv0 '2020-11-03 14:47' ������� ����� ���������, �.�. office tools ������������ ���������� ������������ ��������.
  --SELECT @ErrMsg = '���������� ��������� ��������� �� ��������� ' + CAST((SELECT DocID FROM dbo.t_Inv WITH(NOLOCK) WHERE ChID = @ChID) AS VARCHAR) 
  --+ '. ��������, �� ��������� ��������������� ���� ������������/���������� ��� ����������� ����� ��������� � ������� �� eXite (����� ������� �� �� eXite).'
  --+ ' ��������� � ����������� ����������� �� ������� ������ �������� � ������� � ������� ������ ���� ������ ����� GLN (��� ����� ����������  � ������ �� �����-https://edo.edi-n.com)'
  SELECT @ErrMsg = --'���������� ��������� ��������� �� ��������� ' + CAST((SELECT DocID FROM dbo.t_Inv WITH(NOLOCK) WHERE ChID = @ChID) AS VARCHAR) 
  '��������� �������:' + char(10) + char(13) + '1) � ����������� ����������� -> ������ �������� -> �.�. ������ ����� GLN (��. ����� �� ����� EDIN)'
  + char(10) + char(13) + '2) �� ��������� �����. ���� �����-���/���-��;' + char(10) + char(13) + '3) ����� ������� �� �� EDIN.'
  RETURN --����� �� ���������.
END

EXEC dbo.z_DocLookup 'OurID', @DocCode, @ChID, @OurID OUT

--[ADDED] rkv0 '2020-11-05 15:54' ������� �������� �� ���������� ���������� � �� � � RECADV ��� ���� METRO. ���� ���������� �� ��������, �������� ��������� ����/INVOICE ����������� (������ ������).
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
    DECLARE @base_sum int = (SELECT SUM(d.Qty / ISNULL([dbo].[af_GetQtyInUM] (d.ProdID,'�����/����.'),1) ) FROM t_Inv m JOIN t_InvD d ON d.ChID = m.ChID WHERE m.OrderID = @OrderID)
    IF EXISTS(
        SELECT * FROM [S-PPC.CONST.ALEF.UA].[alef_elit].dbo.at_EDI_reg_files WITH(NOLOCK) 
            WHERE (RetailersID = 17 and doctype = 5000) 
            --+ ��������� �� ������, ���� ����� ������ �����-�� ������� ��������� � 11 �� ������, � ���������� �� ��������.
            and ([Status] = 11 OR DocSum != @base_sum)
            and Notes = @OrderID)
        BEGIN
            SELECT @ErrMsg = '��������!' + char(10) + char(13) + '�������� ���� (ChID = ' + cast(@ChID as varchar) + ') �� ����� ���� ���������, �.�. ���������� ����������� �� ���������� ������� � ����� ��������� ��������� � ����������� � ����� �� ���� METRO. ��������� ��������� �������� �������������.'
            RETURN --����� �� ����� IF @DocType = 'INVOICE' ���������.
        END;
END;

IF @DocType = 'DECLAR'
BEGIN 
    --SET @FName =(SELECT '2801'+'00'+dbo.af_GetFiltered(ro.Code)+'J12'+'010'+'08'+'1'+'00'+RIGHT('00000' + CAST(m.TaxDocID AS VARCHAR) + CAST(ISNULL((SELECT COUNT(*) FROM dbo.z_DocLinks zdlt WITH(NOLOCK) JOIN dbo.at_z_FilesExchange zfet WITH(NOLOCK) ON zfet.ChID = zdlt.ChildChID WHERE zdlt.ParentChID = m.ChID AND zdlt.ParentDocCode = 11012 AND zdlt.ChildDocCode = 666029 AND zfet.StateCode = 403),0) + 1 AS VARCHAR), 7)+'1'+  Cast(LEFT(CONVERT(char(10), m.TaxDocDate, 101), 2)as Varchar(max))+Cast (YEAR(m.TaxDocDate) as VARCHAR(MAX))+'2801'+'.xml'
    --20190110 pvm0 ��������� � ����� �����, ������� ��� � 2801 �� 2810 (����� ��I - ���� ������� ���������) � ������ xml c 08 �� 10
    SET @FName =(SELECT '2810'+'00'+dbo.af_GetFiltered(ro.Code)+'J12'+'010'+'10'+'1'+'00'+RIGHT('00000' + CAST(m.TaxDocID AS VARCHAR) + CAST(ISNULL((SELECT COUNT(*) FROM dbo.z_DocLinks zdlt WITH(NOLOCK) JOIN dbo.at_z_FilesExchange zfet WITH(NOLOCK) ON zfet.ChID = zdlt.ChildChID WHERE zdlt.ParentChID = m.ChID AND zdlt.ParentDocCode = 11012 AND zdlt.ChildDocCode = 666029 AND zfet.StateCode = 403),0) + 1 AS VARCHAR), 7)+'1'+  Cast(LEFT(CONVERT(char(10), m.TaxDocDate, 101), 2)as Varchar(max))+Cast (YEAR(m.TaxDocDate) as VARCHAR(MAX))+'2810'+'.xml'
    FROM dbo.t_Inv m WITH(NOLOCK)
    JOIN dbo.r_Ours ro WITH(NOLOCK) ON ro.OurID = m.OurID
    Where m.Chid = @ChID)
END

--rkv0 '2019-11-11 00:00' ������� ���� ��� PACKAGE_METRO
ELSE IF @DocType = 'COMDOC_METRO' 
BEGIN
    --������ @ChID ����� ���������� ����� ������ ��������, �.�. ���� ������ �� ��������������� Metro.
    SET @FName = 'documentinvoice_' + convert(varchar,getdate(), 112) + replace(left(convert(time,getdate()),5),':','') + '_' + CAST(@ChID AS varchar(20)) + '.xml';
END

--rkv0 '2019-11-18 13:38' ������� ���� ��� PACKAGE_METRO
ELSE IF @DocType = 'PACKAGE_METRO' 
BEGIN
    --������ @ChID ����� ���������� ����� ������ ��������, �.�. ���� ������ �� ��������������� Metro.
    SET @FName = 'packageDescription_' + convert(varchar,getdate(), 112) + replace(left(convert(time,getdate()),5),':','') + '_' + CAST(@ChID AS varchar(20)) + '.xml';
END

ELSE
BEGIN --������ ��� ��� ���� ������ ����������.
    SET @FName = REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR, GETDATE(), 120),'-',''),' ',''),':','') +
    -- '2019-12-10 11:21' rkv0 �������� ChID
    + '-' + CAST(@ChID AS varchar(20)) +
    RIGHT('00-' + CAST(@OurID AS VARCHAR), 4) +
    '-OUT-' + CAST(@TOKEN AS VARCHAR) + '_' + @DocType + '.xml'
END;


BEGIN TRAN

EXEC dbo.z_NewChID 'at_z_FilesExchange', @CH OUT
EXEC dbo.z_NewDocID 666029, 'at_z_FilesExchange', @OurID, @DID OUT

INSERT dbo.at_z_FilesExchange (ChID,FileTypeID,FileName,DocID,DocDate,DocTime,OurID,StateCode,FileData)
SELECT @CH, 4 FileTypeID, @FName, @DID, dbo.zf_GetDate(GETDATE()), GETDATE(), @OurID, CASE WHEN (SELECT compid from t_inv WHERE ChID = @ChID) in (7001,7003) AND @DocType in ('COMDOC_METRO','DECLAR','PACKAGE_METRO')  THEN 502 ELSE 402 END StateCode, @X --������ 502 ��������� ������ METRO: comdoc, declar.

EXEC [dbo].[ap_LinkCreate] @PDocCode = @DocCode, @PChID = @ChID, @�DocCode = 666029, @�ChID = @CH

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
