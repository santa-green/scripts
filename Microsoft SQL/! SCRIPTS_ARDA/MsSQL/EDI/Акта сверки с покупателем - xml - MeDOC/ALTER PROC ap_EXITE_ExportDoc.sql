USE Elit_TEST_IM
GO
ALTER PROC [dbo].[ap_EXITE_ExportDoc] @DocType VARCHAR(20), @DocCode INT = 11012, @ChID INT, @Out XML OUT, @TOKEN INT OUT
AS
/* ��������� �������� ��������� Exite �� ��� ���� @DocType � ���� ����������� @ChID */
BEGIN
/*
DECLARE @xml XML, @token INT
EXEC ap_EXITE_ExportDoc @DocType='COMDOC_METRO', @DocCode=11012, @ChID=200226582,  @Out = @xml OUTPUT, @TOKEN = @token OUTPUT
SELECT @token, @xml
*/
  SET NOCOUNT ON
  --DECLARE @ChID INT = 300097817
  DECLARE @CompID INT, @CompName VARCHAR(250), @CompAddID INT
  DECLARE @DocID INT
  DECLARE @Msg VARCHAR(250), @Msg1 VARCHAR(250)
	--DECLARE @DocCode INT = 11012
  DECLARE @Desadv XML--(DesadvSchema)
	DECLARE @TblName VARCHAR(250) = (SELECT TableName FROM dbo.z_Tables WHERE TableCode = @DocCode * 1000 + 1)
  DECLARE @TblNameD VARCHAR(250) = (SELECT TableName FROM dbo.z_Tables WHERE TableCode = @DocCode * 1000 + 2)
	DECLARE @SQL NVARCHAR(MAX), @O VARCHAR(250)

	EXEC dbo.z_DocLookup 'CompID', @DocCode, @ChID, @CompID OUT
	EXEC dbo.z_DocLookup 'CompAddID', @DocCode, @ChID, @CompAddID OUT
	EXEC dbo.z_DocLookup 'DocID', @DocCode, @ChID, @DocID OUT
	SELECT @CompName = CompName FROM dbo.r_Comps WITH(NOLOCK) WHERE CompID = @CompID OPTION(FAST 1)

  IF NOT EXISTS(SELECT * FROM dbo.r_Uni WITH(NOLOCK) WHERE RefTypeID = 80019 AND RefID = @CompID)
    BEGIN
      RAISERROR('��� ������� ����������� "%s" (%u) ���������� ��������� ��������� "%s", ��� ��� ��� ���� �� �������� "������ ���������� ���������" (���������� ������������� "80019").', 18, 1, @CompName, @CompID, @DocType)
      RETURN
    END
     
  /* ��� ��� GLN ���� �� ������, �� � ��������� ��� ��� ������
  IF NOT EXISTS(SELECT * FROM dbo.t_Inv m WITH(NOLOCK) JOIN dbo.r_Comps rc WITH(NOLOCK) ON rc.CompID = m.CompID WHERE m.ChID = @ChID AND rc.GLNCode <> '')
    BEGIN
      RAISERROR('��� ������� ����������� "%s" (%u) ���������� ��������� ��������� "%s", ��� ��� ��� ���� �� ���������� "����� GLN".', 18, 1, @CompName, @CompID, @DocType)
      RETURN
    END*/

	SET @Out = NULL
	SET @SQL = N'SELECT TOP 1 @O = 1 FROM dbo.' + @TblNameD + N' WHERE ChID = @C AND Qty = 0 OPTION(FAST 1)'
	EXEC sp_executesql @SQL, N'@O INT OUT, @C INT', @O OUT, @ChID

  IF @Out IS NOT NULL
  BEGIN
    RAISERROR('� ��������� %u ������������ ����� � ����������� = 0. ������� ������.', 18, 1, @DocID)
    RETURN
  END
	
	SET @Out = NULL
	SET @SQL = N'SELECT TOP 1 @O = 1 FROM dbo.' + @TblName + N' WHERE ChID = @C AND TaxDocID = 0 OPTION(FAST 1)'
	EXEC sp_executesql @SQL, N'@O INT OUT, @C INT', @O OUT, @ChID
  IF @Out IS NOT NULL
  BEGIN
    RAISERROR('� ��������� %u �� ���������� ����� ��������� ���������. ������� ������.', 18, 1, @DocID)
    RETURN
  END
  
  IF @DocType = 'INVOICE' AND @DocCode = 11012
  BEGIN
    IF EXISTS(SELECT * FROM dbo.t_Inv m JOIN r_Comps rc ON rc.CompID = m.ChID WHERE m.ChID = @ChID
  	AND rc.Code = '32049199' AND NOT (m.SrcDocID IS NOT NULL AND (m.SrcDocID LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' OR m.SrcDocID LIKE '[0-9][0-9] [0-9][0-9][0-9] [0-9][0-9][0-9]')))
    BEGIN
      RAISERROR('� ��������� %u �� ���������� ����� "������ �����". ������� ������.', 18, 1, @DocID)
			RETURN
    END
  END
  ELSE IF @DocType IN ('DESADV', 'ORDRSP') AND @DocCode = 11012
  BEGIN
    IF EXISTS(SELECT * FROM dbo.t_Inv m JOIN r_Comps rc ON rc.CompID = m.ChID WHERE m.ChID = @ChID
      AND rc.Code IN ('36387249','38916558'))
    AND NOT EXISTS(SELECT * FROM dbo.at_t_InvLoad WHERE ChID = @ChID AND BoxQty IS NOT NULL AND ISNUMERIC(BoxQty) = 1
      AND PalQty IS NOT NULL AND ISNUMERIC(PalQty) = 1
      AND CarQty IS NOT NULL AND ISNUMERIC(CarQty) = 1)
    BEGIN
      RAISERROR('� ��������� %u �� ���������� ������������� ����������. ������� ������.', 18, 1, @DocID)
	  RETURN
    END
  END 
/*
  IF EXISTS(SELECT *
    FROM dbo.r_CompsAdd rca WITH(NOLOCK)
    WHERE rca.CompID = @CompID AND rca.CompAddID = @CompAddID AND rca.GLNCode = '')
  BEGIN
    SELECT TOP 1 @Msg = rca.CompAdd
	  FROM dbo.r_CompsAdd rca WITH(NOLOCK)
    WHERE rca.CompID = @CompID AND rca.CompAddID = @CompAddID AND rca.GLNCode = ''
    OPTION(FAST 1)
    RAISERROR('� ��������� %u ��� ����������� "%s" (%u) � ������ �������� "%s" (%u) �� ���������� "����� GLN". ������� ������.', 18, 1, @DocID, @CompName, @CompID, @Msg, @CompAddID)
    RETURN
  END  */

  IF @DocCode = 11012 AND EXISTS(SELECT * FROM dbo.t_InvD d JOIN dbo.t_PInP tpp WITH(NOLOCK) ON tpp.ProdID = d.ProdID AND tpp.PPID = d.PPID WHERE ChID = @ChID AND (tpp.ProdBarCode = '' OR tpp.ProdBarCode IS NULL))
  BEGIN
    SELECT @Msg = d.ProdID, @Msg1 = d.PPID
    FROM dbo.t_InvD d JOIN dbo.t_PInP tpp WITH(NOLOCK) ON tpp.ProdID = d.ProdID AND tpp.PPID = d.PPID WHERE ChID = @ChID AND (tpp.ProdBarCode = '' OR tpp.ProdBarCode IS NULL)
    RAISERROR('� ��������� %u ��� ������ %s � ������ %s �� ��������� ���� "�����-��� �������������". ������� ������.', 18, 1, @DocID, @Msg, @Msg1)
    RETURN
  END  
  
  --IF EXISTS(SELECT * FROM dbo.r_Uni WITH(NOLOCK) WHERE RefTypeID = 80019 AND RefID = @CompID)
  --  IF NOT EXISTS(SELECT * FROM dbo.r_Uni WITH(NOLOCK) WHERE RefTypeID = 80019 AND RefID = @CompID AND Notes LIKE '%' + @DocType + '%')
  --  BEGIN
  --    RAISERROR('��� ������� ����������� "%s" (%u) ���������� ��������� ��������� "%s", ��� ��� ���������� �� ��������� ��������� ������ ����. ������ ���������� ��������� ����� ��������, ����� �� ������ "?" ���� ���������� ����������� (����������� Adobe Reader).', 18, 1, @CompName, @CompID, @DocType)
  --    RETURN
  --  END
  
  DECLARE @OrdChID INT = dbo.af_GetParentChID(@DocCode, @ChID, 11221)
  
	IF @DocCode = 11012
  IF NOT EXISTS(SELECT *
  FROM
  (SELECT CAST(di.ProdID AS VARCHAR(20)) ProdID, irec.ExtProdID FROM dbo.t_IORecD di WITH(NOLOCK) LEFT JOIN dbo.r_ProdEC irec WITH(NOLOCK) ON irec.ProdID = di.ProdID AND irec.CompID = @CompID WHERE ChID = @OrdChID GROUP BY di.ProdID, irec.ExtProdID HAVING SUM(di.Qty) > 0) ird
   JOIN (SELECT ISNULL(irec.ExtProdID, CAST(di.ProdID AS VARCHAR(20))) ProdID, irec.ExtProdID, tpp.ProdBarCode, SUM(Qty) Qty FROM dbo.t_InvD di WITH(NOLOCK) LEFT JOIN dbo.r_ProdEC irec WITH(NOLOCK) ON irec.ProdID = di.ProdID AND irec.CompID = @CompID JOIN dbo.t_PInP tpp WITH(NOLOCK) ON tpp.ProdID = di.ProdID AND tpp.PPID = di.PPID WHERE ChID = @ChID GROUP BY irec.ExtProdID, tpp.ProdBarCode, ISNULL(irec.ExtProdID, CAST(di.ProdID AS VARCHAR(20)))) dd ON (dd.ProdID = ird.ProdID AND dd.ExtProdID IS NULL) OR (dd.ProdID = ird.ExtProdID AND dd.ExtProdID IS NOT NULL))
  BEGIN
    RAISERROR('��������� %u �� �������� ������-���� ����������� ������������ ������. ������� ������.', 18, 1, @DocID)
    RETURN
  END
  
  SET @TOKEN = CAST(LEFT(CAST(@CompID AS VARCHAR(250)) + '000000000', 9) AS INT) + ISNULL(CAST((SELECT TOP 1 VarValue FROM dbo.r_CompValues WITH(NOLOCK) WHERE VarName = 'EDIINTERCHANGEID' AND CompID = @CompID) AS INT),0) + 1
  
  IF @DocType = 'INVOICE'
  /* �������� INVOICE */
    SET @Out = (
    SELECT
    380 'DOCUMENTNAME',
    CAST(m.TaxDocID AS INT) 'NUMBER',
    CAST(m.TaxDocDate AS DATE) 'DATE',
    CAST(m.TaxDocDate AS DATE) 'DELIVERYDATE',
    NULL 'DELIVERYTIME',
    'UAH' 'CURRENCY',
    CASE WHEN ir.OrderID LIKE '%[_]non-alc' OR ir.OrderID LIKE '%[_]alc' THEN REPLACE(REPLACE(ir.OrderID, '_non-alc', ''), '_alc', '') ELSE ir.OrderID END 'ORDERNUMBER',
    irx.XMLData.value('(./ORDER/DATE)[1]', 'VARCHAR(13)') AS 'ORDERDATE',
    CAST(m.TaxDocID AS INT) 'DELIVERYNOTENUMBER',
    CAST(m.TaxDocDate AS DATE) 'DELIVERYNOTEDATE',
    CASE WHEN c.Code = '32049199' AND m.SrcDocID IS NOT NULL AND (m.SrcDocID LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' OR m.SrcDocID LIKE '[0-9][0-9] [0-9][0-9][0-9] [0-9][0-9][0-9]') AND m.SrcDocID != ir.OrderID THEN m.SrcDocID END 'PAYMENTORDERNUMBER',
    zc.ContrID 'CAMPAIGNNUMBER',
    LTRIM(RTRIM(o.TaxCode)) 'FISCALNUMBER',
    LTRIM(RTRIM(o.Code)) 'REGISTRATIONNUMBER',
    ISNULL((SELECT SUM(SumCC_nt) FROM dbo.t_InvD WITH(NOLOCK) WHERE ChID = m.ChID),0) 'GOODSTOTALAMOUNT',
    ISNULL((SELECT SUM(SumCC_nt) FROM dbo.t_InvD WITH(NOLOCK) WHERE ChID = m.ChID),0) 'POSITIONSAMOUNT',
    ISNULL((SELECT SUM(TaxSum) FROM dbo.t_InvD WITH(NOLOCK) WHERE ChID = m.ChID),0) 'VATSUM',
    ISNULL((SELECT SUM(SumCC_wt) FROM dbo.t_InvD WITH(NOLOCK) WHERE ChID = m.ChID),0) 'INVOICETOTALAMOUNT',
    ISNULL((SELECT SUM(SumCC_nt) FROM dbo.t_InvD WITH(NOLOCK) WHERE ChID = m.ChID AND Tax > 0),0) 'TAXABLEAMOUNT',
    CAST(ISNULL((SELECT SUM(TaxSum) FROM dbo.t_InvD WITH(NOLOCK) WHERE ChID = m.ChID AND Tax > 0) / (SELECT SUM(SumCC_nt) FROM dbo.t_InvD WITH(NOLOCK) WHERE ChID = m.ChID AND Tax > 0),0) * 100 AS INT) 'VAT',
    (
    SELECT COALESCE(irx.XMLData.value('(./HEAD/SUPPLIER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/SUPPLIER)[1]', 'VARCHAR(13)'), ir.GLNCode) 'SUPPLIER',
    COALESCE(irx.XMLData.value('(./HEAD/BUYER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/BUYER)[1]', 'VARCHAR(13)')) 'BUYER',
    COALESCE(irx.XMLData.value('(./HEAD/DELIVERYPLACE)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/DELIVERYPLACE)[1]', 'VARCHAR(13)'), rca.GLNCode) 'DELIVERYPLACE',
    COALESCE(irx.XMLData.value('(./HEAD/SUPPLIER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/SUPPLIER)[1]', 'VARCHAR(13)'), ir.GLNCode) 'CONSEGNOR',
    COALESCE(irx.XMLData.value('(./HEAD/DELIVERYPLACE)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/DELIVERYPLACE)[1]', 'VARCHAR(13)'), rca.GLNCode) 'CONSIGNEE',
    COALESCE(irx.XMLData.value('(./HEAD/RECIPIENT)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/RECIPIENT)[1]', 'VARCHAR(13)'), ir.GLNCode) 'SENDER',
    COALESCE(irx.XMLData.value('(./HEAD/SENDER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/SENDER)[1]', 'VARCHAR(13)')) 'RECIPIENT',
    @TOKEN 'EDIINTERCHANGEID',
      (
      SELECT ROW_NUMBER() OVER(ORDER BY MAX(dd.SrcPosID)) 'POSITIONNUMBER',
      tpp.ProdBarCode 'PRODUCT',
      dd.ProdID 'PRODUCTIDSUPPLIER',
			irec.ExtProdID 'PRODUCTIDBUYER',
      SUM(dd.Qty) 'INVOICEDQUANTITY',
      dd.PriceCC_nt 'UNITPRICE',
			dd.PriceCC_wt 'GROSSPRICE',
      SUM(dd.SumCC_nt) 'AMOUNT',
      LEFT(p.Notes, 70) 'DESCRIPTION',
      203 'AMOUNTTYPE',
      7 'TAX/FUNCTION',
      'VAT' 'TAX/TAXTYPECODE',
      CAST(dbo.zf_GetProdTaxPercent(dd.ProdID, m.DocDate) AS INT) 'TAX/TAXRATE',
      SUM(dd.TaxSum) 'TAX/TAXAMOUNT',
      'S' 'TAX/CATEGORY'
      FROM dbo.t_InvD dd WITH(NOLOCK)
      JOIN dbo.r_Prods p WITH(NOLOCK) ON p.ProdID = dd.prodid
      JOIN dbo.t_PInP tpp WITH(NOLOCK) ON tpp.ProdID = dd.ProdID AND tpp.PPID = dd.PPID
			LEFT JOIN dbo.r_ProdEC irec WITH(NOLOCK) ON irec.ProdID = dd.ProdID AND irec.CompID = @CompID
      WHERE dd.ChID = @ChID
      GROUP BY tpp.ProdBarCode, p.Notes, dd.ProdID, irec.ExtProdID, dd.PriceCC_nt, dd.PriceCC_wt
      FOR XML PATH ('POSITION'), TYPE)
    FOR XML PATH ('HEAD'), TYPE
    )
    FROM dbo.t_Inv m WITH(NOLOCK)
    JOIN dbo.r_CompsAdd rca WITH(NOLOCK) ON rca.CompID = m.CompID AND rca.CompAdd = m.Address
    JOIN dbo.t_IORec ir WITH(NOLOCK) ON @OrdChID = ir.Chid
    JOIN dbo.r_Ours o WITH(NOLOCK) ON m.OurID = o.OurID
    --JOIN dbo.r_OurValues ov WITH(NOLOCK) ON m.OurID = ov.OurID AND ov.VarName = 'GLNCode'
    JOIN dbo.r_Comps c WITH(NOLOCK) ON c.CompID = m.CompID
    LEFT JOIN dbo.z_DocLinks zdl WITH(NOLOCK) ON zdl.ChildChID = m.ChID AND zdl.ChildDocCode = 11012 AND zdl.ParentDocCode = 666028
    LEFT JOIN dbo.at_z_Contracts zc WITH(NOLOCK) ON zc.ChID = zdl.ParentChID
    JOIN dbo.at_t_IORecX irx WITH(NOLOCK) ON irx.ChID = @OrdChID
    WHERE m.ChID = @ChID AND
    --c.GLNCode <> '' AND
    rca.GLNCode <> '' AND
    (ISNULL(ir.GLNCode, '') <> '' OR irx.XMLData IS NOT NULL) AND
    m.TaxDocID <> 0 AND
    ir.OrderID IS NOT NULL AND ir.OrderID != ''
    FOR XML PATH ('INVOICE'))

  ELSE IF @DocType = 'DESADV'
  /* �������� DESADV (����������� �� ��������) */
    SET @Desadv = (
    SELECT
      CASE WHEN ir.OrderID LIKE '%[_]non-alc' OR ir.OrderID LIKE '%[_]alc' THEN REPLACE(REPLACE(ir.OrderID, '_non-alc', ''), '_alc', '') ELSE ir.OrderID END 'NUMBER',
      CAST(m.TaxDocDate AS DATE) 'DATE',
      CAST(m.TaxDocDate AS DATE) 'DELIVERYDATE',
      CASE WHEN CAST(il.ExpDate AS TIME) <> '00:00:00' THEN LEFT(CAST(il.ExpDate AS TIME), 5) END 'DELIVERYTIME',
      CASE WHEN ir.OrderID LIKE '%[_]non-alc' OR ir.OrderID LIKE '%[_]alc' THEN REPLACE(REPLACE(ir.OrderID, '_non-alc', ''), '_alc', '') ELSE ir.OrderID END 'ORDERNUMBER',
      irx.XMLData.value('(./ORDER/DATE)[1]', 'VARCHAR(13)') AS 'ORDERDATE',
      CAST(m.TaxDocID AS INT) 'DELIVERYNOTENUMBER',
      CAST(m.TaxDocDate AS DATE) 'DELIVERYNOTEDATE',
      m.DocID 'SUPPLIERORDERNUMBER',
      CAST(m.DocDate AS DATE) 'SUPPLIERORDERDATE',
      CAST(il.BoxQty AS INT) 'TOTALPACKAGES',
      CAST(il.PalQty AS INT) 'TOTALPALLETS',
      zc.ContrID 'CAMPAIGNNUMBER',
      CAST(il.CarQty AS INT) 'TRANSPORTQUANTITY',
      rd.CarName 'TRANSPORTMARK',
      rd.CarNo 'TRANSPORTID',
      rd.DriverName 'TRANSPORTERNAME',
      30 'TRANSPORTTYPE',
      31 'TRANSPORTERTYPE',
      rc4.CodeName4 'CARRIERNAME',
      CASE WHEN rc4.Notes LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' OR rc4.Notes LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' THEN rc4.Notes END 'CARRIERINN',
      (
      SELECT COALESCE(irx.XMLData.value('(./HEAD/SUPPLIER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/SUPPLIER)[1]', 'VARCHAR(13)'), ir.GLNCode) 'SUPPLIER',
      COALESCE(irx.XMLData.value('(./HEAD/BUYER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/BUYER)[1]', 'VARCHAR(13)')) 'BUYER',
      COALESCE(irx.XMLData.value('(./HEAD/DELIVERYPLACE)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/DELIVERYPLACE)[1]', 'VARCHAR(13)'), rca.GLNCode) 'DELIVERYPLACE',
      COALESCE(irx.XMLData.value('(./HEAD/RECIPIENT)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/RECIPIENT)[1]', 'VARCHAR(13)'), ir.GLNCode) 'SENDER',
      COALESCE(irx.XMLData.value('(./HEAD/SENDER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/SENDER)[1]', 'VARCHAR(13)')) 'RECIPIENT',
      @TOKEN 'EDIINTERCHANGEID',
        (
          SELECT 1 'HIERARCHICALID',
          (
            SELECT ROW_NUMBER() OVER(ORDER BY MAX(ird.SrcPosID))'POSITIONNUMBER',
            ISNULL(dd.ProdBarCode, pp.ProdBarCode) 'PRODUCT',
            ird.ProdID 'PRODUCTIDSUPPLIER',
            ird.ExtProdID 'PRODUCTIDBUYER',
            
--            SUM(ISNULL(dd.Qty, 0)) 'DELIVEREDQUANTITY',
            CASE WHEN RIGHT(SUBSTRING(CAST(SUM(ISNULL(CASE 
				 WHEN  @CompID=7138 AND ird.ProdID in (26213,31815,31874) THEN dd.Qty/20
				 WHEN  @CompID=7138 AND ird.ProdID in (29151) THEN dd.Qty/24
				 WHEN  @CompID=7138 AND ird.ProdID in (28585) THEN dd.Qty/30
				 WHEN  @CompID=7138 AND ird.ProdID in (28586,29152) THEN dd.Qty/6
				 WHEN  @CompID=7138 AND ird.ProdID= 31878 THEN  dd.Qty/6
				 WHEN  @CompID=7138 AND ird.ProdID= 26168 THEN  dd.Qty/12 
				 WHEN  @CompID=7138 AND ird.ProdID= 31880 THEN  dd.Qty/6 
				 WHEN  @CompID=7138 AND ird.ProdID= 3127 THEN  dd.Qty/ 6 
				 WHEN  @CompID=7138 AND ird.ProdID= 31879 THEN  dd.Qty/6
				 WHEN  @CompID=7138 AND ird.ProdID= 30843 THEN  dd.Qty/6  
			ELSE dd.Qty END,0)) AS varchar), 1, LEN(SUM(ISNULL(dd.Qty, 0)))+1 - PATINDEX('%[^0]%', REVERSE(SUM(ISNULL(dd.Qty, 0))))), 1) = '.' 
					 THEN SUBSTRING(CAST(SUM(ISNULL(
                 CASE 
					 WHEN  @CompID=7138 AND ird.ProdID in(26213,31815,31874) THEN dd.Qty/20
					 WHEN  @CompID=7138 AND ird.ProdID in (29151) THEN dd.Qty/24
					 WHEN  @CompID=7138 AND ird.ProdID in (28585) THEN dd.Qty/30
					 WHEN  @CompID=7138 AND ird.ProdID in (28586,29152) THEN dd.Qty/6
					 WHEN  @CompID=7138 AND ird.ProdID= 31878 THEN  dd.Qty/6 
					 WHEN  @CompID=7138 AND ird.ProdID= 26168 THEN  dd.Qty/12 
					 WHEN  @CompID=7138 AND ird.ProdID= 31880 THEN  dd.Qty/6 
					 WHEN  @CompID=7138 AND ird.ProdID= 3127 THEN  dd.Qty/ 6 
					 WHEN  @CompID=7138 AND ird.ProdID= 31879 THEN  dd.Qty/6
					 WHEN  @CompID=7138 AND ird.ProdID= 30843 THEN  dd.Qty/ 6  
				 ELSE dd.Qty END, 0)) as varchar), 1, LEN(SUM(ISNULL(dd.Qty, 0)))+1 - PATINDEX('%[^0]%', REVERSE(SUM(ISNULL(dd.Qty, 0))))) + '0'
                 ELSE SUBSTRING(CAST(SUM(ISNULL(
                 CASE 
					 WHEN  @CompID=7138 AND ird.ProdID in (26213,31815,31874)THEN dd.Qty/20
					 WHEN  @CompID=7138 AND ird.ProdID in (29151) THEN dd.Qty/24
					 WHEN  @CompID=7138 AND ird.ProdID in (28585) THEN dd.Qty/30
					 WHEN  @CompID=7138 AND ird.ProdID in (28586,29152) THEN dd.Qty/6
					 WHEN  @CompID=7138 AND ird.ProdID= 31878 THEN  dd.Qty/6 
					 WHEN  @CompID=7138 AND ird.ProdID= 26168 THEN  dd.Qty/12 
					 WHEN  @CompID=7138 AND ird.ProdID= 31880 THEN  dd.Qty/6 
					 WHEN  @CompID=7138 AND ird.ProdID= 3127 THEN  dd.Qty/ 6 
					 WHEN  @CompID=7138 AND ird.ProdID= 31879 THEN  dd.Qty/6
					 WHEN  @CompID=7138 AND ird.ProdID= 30843 THEN  dd.Qty/6  
				 ELSE dd.Qty END, 0)) as varchar), 1, LEN(SUM(ISNULL(dd.Qty, 0)))+1 - PATINDEX('%[^0]%', REVERSE(SUM(ISNULL(dd.Qty, 0)))))
            END  'DELIVEREDQUANTITY',
            
--            SUM(ird.Qty) 'ORDEREDQUANTITY',            
            CASE WHEN RIGHT(SUBSTRING(CAST(
            CASE 
				WHEN  @CompID=7138 AND ird.ProdID in (26213,31815,31874) THEN SUM(ird.Qty)/20
				WHEN  @CompID=7138 AND ird.ProdID in (29151) THEN SUM(ird.Qty)/24
				WHEN  @CompID=7138 AND ird.ProdID in (28585) THEN SUM(ird.Qty)/30
				WHEN  @CompID=7138 AND ird.ProdID in (28586,29152) THEN SUM(ird.Qty)/6
				WHEN  @CompID=7138 AND ird.ProdID= 31878 THEN  SUM(ird.Qty)/6 
				WHEN  @CompID=7138 AND ird.ProdID= 26168 THEN  SUM(ird.Qty)/12 
				WHEN  @CompID=7138 AND ird.ProdID= 31880 THEN  SUM(ird.Qty)/6 
				WHEN  @CompID=7138 AND ird.ProdID= 3127 THEN  SUM(ird.Qty)/ 6 
				WHEN  @CompID=7138 AND ird.ProdID= 31879 THEN  SUM(ird.Qty)/6
				WHEN  @CompID=7138 AND ird.ProdID= 30843 THEN  SUM(ird.Qty)/6  
			ELSE SUM(ird.Qty) END AS varchar ), 1, LEN(SUM(ird.Qty))+1 - PATINDEX('%[^0]%', REVERSE(SUM(ird.Qty)))), 1) = '.' 
                 THEN SUBSTRING(CAST(
					CASE 
						WHEN  @CompID=7138 AND ird.ProdID in (26213,31815,31874) THEN SUM(ird.Qty)/20
						WHEN  @CompID=7138 AND ird.ProdID in (29151) THEN SUM(ird.Qty)/24
						WHEN  @CompID=7138 AND ird.ProdID in (28585) THEN SUM(ird.Qty)/30
						WHEN  @CompID=7138 AND ird.ProdID in (28586,29152) THEN SUM(ird.Qty)/6
						WHEN  @CompID=7138 AND ird.ProdID= 31878 THEN  SUM(ird.Qty)/6 
						WHEN  @CompID=7138 AND ird.ProdID= 26168 THEN  SUM(ird.Qty)/12 
						WHEN  @CompID=7138 AND ird.ProdID= 31880 THEN  SUM(ird.Qty)/6 
						WHEN  @CompID=7138 AND ird.ProdID= 3127 THEN  SUM(ird.Qty)/ 6 
						WHEN  @CompID=7138 AND ird.ProdID= 31879 THEN  SUM(ird.Qty)/6
						WHEN  @CompID=7138 AND ird.ProdID= 30843 THEN  SUM(ird.Qty)/6  
					ELSE SUM(ird.Qty) END AS varchar), 1, LEN(SUM(ird.Qty))+1 - PATINDEX('%[^0]%', REVERSE(SUM(ird.Qty)))) + '0'
                 ELSE SUBSTRING(CAST(
					CASE 
						WHEN  @CompID=7138 AND ird.ProdID in (26213,31815,31874) THEN SUM(ird.Qty)/20
						WHEN  @CompID=7138 AND ird.ProdID in (29151) THEN SUM(ird.Qty)/24
						WHEN  @CompID=7138 AND ird.ProdID in (28585) THEN SUM(ird.Qty)/30
						WHEN  @CompID=7138 AND ird.ProdID in (28586,29152) THEN SUM(ird.Qty)/6
						WHEN  @CompID=7138 AND ird.ProdID= 31878 THEN  SUM(ird.Qty)/6
						WHEN  @CompID=7138 AND ird.ProdID= 26168 THEN  SUM(ird.Qty)/12 
						WHEN  @CompID=7138 AND ird.ProdID= 31880 THEN  SUM(ird.Qty)/6 
						WHEN  @CompID=7138 AND ird.ProdID= 3127 THEN  SUM(ird.Qty)/ 6 
						WHEN  @CompID=7138 AND ird.ProdID= 31879 THEN  SUM(ird.Qty)/6
						WHEN  @CompID=7138 AND ird.ProdID= 30843 THEN  SUM(ird.Qty)/6  
					ELSE SUM(ird.Qty) END AS varchar), 1, LEN(SUM(ird.Qty))+1 - PATINDEX('%[^0]%', REVERSE(SUM(ird.Qty))))
            END 'ORDEREDQUANTITY',
            
--            SUM(dd.SumCC_nt) 'AMOUNT',
            CASE WHEN RIGHT(SUBSTRING(CAST(
            CASE 
				WHEN  @CompID=7138 AND ird.ProdID in (26213,31815,31874) THEN SUM(dd.SumCC_nt)*20
				WHEN  @CompID=7138 AND ird.ProdID in (29151) THEN SUM(dd.SumCC_nt)*24
				WHEN  @CompID=7138 AND ird.ProdID in (28585) THEN SUM(dd.SumCC_nt)*30
				WHEN  @CompID=7138 AND ird.ProdID in (28586,29152) THEN SUM(dd.SumCC_nt)*6
				WHEN  @CompID=7138 AND ird.ProdID= 31878 THEN  SUM(dd.SumCC_nt)*6
				WHEN  @CompID=7138 AND ird.ProdID= 26168 THEN  SUM(dd.SumCC_nt)*12 
				WHEN  @CompID=7138 AND ird.ProdID= 31880 THEN  SUM(dd.SumCC_nt)*6 
				WHEN  @CompID=7138 AND ird.ProdID= 3127 THEN  SUM(dd.SumCC_nt)* 6 
				WHEN  @CompID=7138 AND ird.ProdID= 31879 THEN  SUM(dd.SumCC_nt)*6
				WHEN  @CompID=7138 AND ird.ProdID= 30843 THEN  SUM(dd.SumCC_nt)*6  
			ELSE SUM(dd.SumCC_nt) END AS varchar ), 1, LEN(SUM(dd.SumCC_nt))+1 - PATINDEX('%[^0]%', REVERSE(SUM(dd.SumCC_nt)))), 1) = '.' 
                 THEN SUBSTRING(CAST
                 (CASE 
					WHEN  @CompID=7138 AND ird.ProdID in (26213,31815,31874) THEN SUM(dd.SumCC_nt)*20
					WHEN  @CompID=7138 AND ird.ProdID in (29151) THEN SUM(dd.SumCC_nt)*24
					WHEN  @CompID=7138 AND ird.ProdID in (28585) THEN SUM(dd.SumCC_nt)*30
					WHEN  @CompID=7138 AND ird.ProdID in (28586,29152) THEN SUM(dd.SumCC_nt)*6
					WHEN  @CompID=7138 AND ird.ProdID= 31878 THEN  SUM(dd.SumCC_nt)*6
					WHEN  @CompID=7138 AND ird.ProdID= 26168 THEN  SUM(dd.SumCC_nt)*12 
					WHEN  @CompID=7138 AND ird.ProdID= 31880 THEN  SUM(dd.SumCC_nt)*6 
					WHEN  @CompID=7138 AND ird.ProdID= 3127 THEN  SUM(dd.SumCC_nt)* 6 
					WHEN  @CompID=7138 AND ird.ProdID= 31879 THEN  SUM(dd.SumCC_nt)*6
					WHEN  @CompID=7138 AND ird.ProdID= 30843 THEN  SUM(dd.SumCC_nt)*6  
				ELSE SUM(dd.SumCC_nt) END AS varchar), 1, LEN(SUM(dd.SumCC_nt))+1 - PATINDEX('%[^0]%', REVERSE(SUM(dd.SumCC_nt)))) + '0'
                 ELSE SUBSTRING(CAST
                 (CASE 
					WHEN  @CompID=7138 AND ird.ProdID in (26213,31815,31874) THEN SUM(dd.SumCC_nt)*20
					WHEN  @CompID=7138 AND ird.ProdID in (29151) THEN SUM(dd.SumCC_nt)*24
					WHEN  @CompID=7138 AND ird.ProdID in (28585) THEN SUM(dd.SumCC_nt)*30
					WHEN  @CompID=7138 AND ird.ProdID in (28586,29152) THEN SUM(dd.SumCC_nt)*6
					WHEN  @CompID=7138 AND ird.ProdID= 31878 THEN  SUM(dd.SumCC_nt)*6
					WHEN  @CompID=7138 AND ird.ProdID= 26168 THEN  SUM(dd.SumCC_nt)*12 
					WHEN  @CompID=7138 AND ird.ProdID= 31880 THEN  SUM(dd.SumCC_nt)*6 
					WHEN  @CompID=7138 AND ird.ProdID= 3127 THEN  SUM(dd.SumCC_nt)* 6 
					WHEN  @CompID=7138 AND ird.ProdID= 31879 THEN  SUM(dd.SumCC_nt)*6
					WHEN  @CompID=7138 AND ird.ProdID= 30843 THEN  SUM(dd.SumCC_nt)*6  
				ELSE SUM(dd.SumCC_nt) END AS varchar), 1, LEN(SUM(dd.SumCC_nt))+1 - PATINDEX('%[^0]%', REVERSE(SUM(dd.SumCC_nt))))
            END 'AMOUNT',
            
--            dd.PriceCC_nt 'PRICE', 
            CASE WHEN RIGHT(SUBSTRING(CAST(
            CASE WHEN  @CompID=7138 AND ird.ProdID in (26213,31815,31874) THEN dd.PriceCC_nt *20
			 	 WHEN  @CompID=7138 AND ird.ProdID in (29151) THEN dd.PriceCC_nt *24
			 	 WHEN  @CompID=7138 AND ird.ProdID in (28585) THEN dd.PriceCC_nt *30
			 	 WHEN  @CompID=7138 AND ird.ProdID in (28586,29152) THEN dd.PriceCC_nt *6
                 WHEN  @CompID=7138 AND ird.ProdID= 31878 THEN dd.PriceCC_nt *6
                 WHEN  @CompID=7138 AND ird.ProdID= 26168 THEN dd.PriceCC_nt *12
                 WHEN  @CompID=7138 AND ird.ProdID= 31880 THEN dd.PriceCC_nt *6
                 WHEN  @CompID=7138 AND ird.ProdID= 3127 THEN  dd.PriceCC_nt *6
                 WHEN  @CompID=7138 AND ird.ProdID= 31879 THEN dd.PriceCC_nt *6
                 WHEN  @CompID=7138 AND ird.ProdID= 30843 THEN dd.PriceCC_nt *6    
			ELSE   dd.PriceCC_nt END AS varchar), 1, LEN(dd.PriceCC_nt)+1 - PATINDEX('%[^0]%', REVERSE(dd.PriceCC_nt))), 1) = '.' 
                 THEN SUBSTRING(CAST(
                 CASE 
					 WHEN  @CompID=7138 AND ird.ProdID in (26213,31815,31874) THEN dd.PriceCC_nt *20
					 WHEN  @CompID=7138 AND ird.ProdID in (29151) THEN dd.PriceCC_nt *24
					 WHEN  @CompID=7138 AND ird.ProdID in (28585) THEN dd.PriceCC_nt *30
					 WHEN  @CompID=7138 AND ird.ProdID in (28586,29152) THEN dd.PriceCC_nt *6
					 WHEN  @CompID=7138 AND ird.ProdID= 31878 THEN dd.PriceCC_nt *6
					 WHEN  @CompID=7138 AND ird.ProdID= 26168 THEN dd.PriceCC_nt *12
					 WHEN  @CompID=7138 AND ird.ProdID= 31880 THEN dd.PriceCC_nt *6
					 WHEN  @CompID=7138 AND ird.ProdID= 3127 THEN  dd.PriceCC_nt *6
					 WHEN  @CompID=7138 AND ird.ProdID= 31879 THEN dd.PriceCC_nt *6
					 WHEN  @CompID=7138 AND ird.ProdID= 30843 THEN dd.PriceCC_nt *6    
				ELSE   dd.PriceCC_nt END as varchar), 1, LEN(dd.PriceCC_nt)+1 - PATINDEX('%[^0]%', REVERSE(dd.PriceCC_nt))) + '0'
                 ELSE SUBSTRING(CAST(
                 CASE 
					 WHEN  @CompID=7138 AND ird.ProdID in (26213,31815,31874) THEN dd.PriceCC_nt *20
					 WHEN  @CompID=7138 AND ird.ProdID in (29151) THEN dd.PriceCC_nt *24
					 WHEN  @CompID=7138 AND ird.ProdID in (28585) THEN dd.PriceCC_nt *30
					 WHEN  @CompID=7138 AND ird.ProdID in (28586,29152) THEN dd.PriceCC_nt *6
					 WHEN  @CompID=7138 AND ird.ProdID= 31878 THEN dd.PriceCC_nt *6
					 WHEN  @CompID=7138 AND ird.ProdID= 26168 THEN dd.PriceCC_nt *12
					 WHEN  @CompID=7138 AND ird.ProdID= 31880 THEN dd.PriceCC_nt *6
					 WHEN  @CompID=7138 AND ird.ProdID= 3127 THEN  dd.PriceCC_nt *6
					 WHEN  @CompID=7138 AND ird.ProdID= 31879 THEN dd.PriceCC_nt *6
					 WHEN  @CompID=7138 AND ird.ProdID= 30843 THEN dd.PriceCC_nt *6    
				ELSE   dd.PriceCC_nt END as varchar), 1, LEN(dd.PriceCC_nt)+1 - PATINDEX('%[^0]%', REVERSE(dd.PriceCC_nt)))
            END 'PRICE', 

            LEFT(rp.Notes, 70) 'DESCRIPTION'
            FROM (SELECT MIN(SrcPosID) SrcPosID, CAST(di.ProdID AS VARCHAR(20)) ProdID, irec.ExtProdID, SUM(Qty) Qty FROM dbo.t_IORecD di WITH(NOLOCK) LEFT JOIN dbo.r_ProdEC irec WITH(NOLOCK) ON irec.ProdID = di.ProdID AND irec.CompID = @CompID WHERE ChID = @OrdChID GROUP BY di.ProdID, irec.ExtProdID HAVING SUM(di.Qty) > 0) ird
            LEFT JOIN (SELECT ISNULL(irec.ExtProdID, CAST(di.ProdID AS VARCHAR(20))) ProdID, irec.ExtProdID, tpp.ProdBarCode, SUM(Qty) Qty, PriceCC_nt, SUM(di.SumCC_nt) SumCC_nt FROM dbo.t_InvD di WITH(NOLOCK) LEFT JOIN dbo.r_ProdEC irec WITH(NOLOCK) ON irec.ProdID = di.ProdID AND irec.CompID = @CompID JOIN dbo.t_PInP tpp WITH(NOLOCK) ON tpp.ProdID = di.ProdID AND tpp.PPID = di.PPID WHERE ChID = @ChID GROUP BY irec.ExtProdID, tpp.ProdBarCode, PriceCC_nt, ISNULL(irec.ExtProdID, CAST(di.ProdID AS VARCHAR(20)))) dd ON (dd.ProdID = ird.ProdID AND dd.ExtProdID IS NULL) OR (dd.ProdID = ird.ExtProdID AND dd.ExtProdID IS NOT NULL)
            JOIN dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID = ird.ProdID
            LEFT JOIN dbo.t_PInP pp WITH(NOLOCK) ON pp.ProdID = rp.ProdID AND pp.PPID = (SELECT MAX(PPID) FROM dbo.t_PInP WITH(NOLOCK) WHERE ProdID = rp.ProdID AND NOT (ProdBarCode = '' OR ProdBarCode IS NULL))
						WHERE -- ��� ��������� ����������� �� ���������� ����
						(m.CompID = 7030 AND dd.Qty IS NOT NULL) OR m.CompID != 7030
            GROUP BY dd.ProdBarCode, pp.ProdBarCode, ird.ExtProdID, ird.ProdID, rp.Notes, dd.PriceCC_nt
            FOR XML PATH ('POSITION'), TYPE)
          FOR XML PATH ('PACKINGSEQUENCE'), TYPE)
      FOR XML PATH ('HEAD'), TYPE
      )
    FROM dbo.t_Inv m WITH(NOLOCK)
    JOIN dbo.r_CompsAdd rca WITH(NOLOCK) ON rca.CompID = m.CompID AND rca.CompAdd = m.Address
    JOIN dbo.t_IORec ir WITH(NOLOCK) ON @OrdChID = ir.Chid
    JOIN dbo.r_Ours o WITH(NOLOCK) ON m.OurID = o.OurID
    --JOIN dbo.r_OurValues ov WITH(NOLOCK) ON m.OurID = ov.OurID AND ov.VarName = 'GLNCode'
    JOIN dbo.r_Comps c WITH(NOLOCK) ON c.CompID = m.CompID
    LEFT JOIN dbo.z_DocLinks zdl WITH(NOLOCK) ON zdl.ChildChID = m.ChID AND zdl.ChildDocCode = 11012 AND zdl.ParentDocCode = 666028
    LEFT JOIN dbo.at_z_Contracts zc WITH(NOLOCK) ON zc.ChID = zdl.ParentChID
    LEFT JOIN dbo.at_t_InvLoad il WITH(NOLOCK) ON il.ChID = m.ChID
    LEFT JOIN dbo.at_r_Drivers rd WITH(NOLOCK) ON rd.DriverID = m.DriverID AND rd.DriverId != 0
    LEFT JOIN dbo.r_Codes4 rc4 WITH(NOLOCK) ON rc4.CodeID4 = m.CodeID4 AND rc4.CodeID4 != 0
    JOIN dbo.at_t_IORecX irx WITH(NOLOCK) ON irx.ChID = @OrdChID
    WHERE m.Chid = @ChID AND --c.GLNCode <> '' AND
    rca.GLNCode <> '' AND
    (ISNULL(ir.GLNCode, '') <> '' OR irx.XMLData IS NOT NULL) AND
    ISNULL(ir.OrderID,'') <> '' AND m.TaxDocID <> 0
    FOR XML PATH ('DESADV'))
  ELSE IF @DocType = 'ORDRSP'
  /* �������� ORDRSP */
    SET @Out = (
    SELECT
      CAST(m.TaxDocID AS INT) 'NUMBER',
      CAST(m.TaxDocDate AS DATE) 'DATE',
      CASE WHEN ir.OrderID LIKE '%[_]non-alc' OR ir.OrderID LIKE '%[_]alc' THEN REPLACE(REPLACE(ir.OrderID, '_non-alc', ''), '_alc', '') ELSE ir.OrderID END 'ORDERNUMBER',
      irx.XMLData.value('(./ORDER/DATE)[1]', 'VARCHAR(13)') AS 'ORDERDATE',
      CAST(m.TaxDocDate AS DATE) 'DELIVERYDATE',
      CASE WHEN CAST(il.ExpDate AS TIME) <> '00:00:00' THEN LEFT(CAST(il.ExpDate AS TIME), 5) ELSE '00:00' END 'DELIVERYTIME',
      CAST(il.BoxQty AS INT) 'TOTALPACKAGES',
      CAST(il.PalQty AS INT) 'TOTALPACKAGESSPACE',
      CAST(il.CarQty AS INT) 'TRANSPORTQUANTITY',
      (
      SELECT COALESCE(irx.XMLData.value('(./HEAD/BUYER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/BUYER)[1]', 'VARCHAR(13)')) 'BUYER',
      COALESCE(irx.XMLData.value('(./HEAD/SUPPLIER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/SUPPLIER)[1]', 'VARCHAR(13)'), ir.GLNCode) 'SUPPLIER',
      COALESCE(irx.XMLData.value('(./HEAD/DELIVERYPLACE)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/DELIVERYPLACE)[1]', 'VARCHAR(13)'), rca.GLNCode) 'DELIVERYPLACE',
      COALESCE(irx.XMLData.value('(./HEAD/RECIPIENT)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/RECIPIENT)[1]', 'VARCHAR(13)'), ir.GLNCode) 'SENDER',
      COALESCE(irx.XMLData.value('(./HEAD/SENDER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/SENDER)[1]', 'VARCHAR(13)')) 'RECIPIENT',
      @TOKEN 'EDIINTERCHANGEID',
        (
          SELECT ROW_NUMBER() OVER(ORDER BY ird.SrcPosID)'POSITIONNUMBER',
          ISNULL(dd.ProdBarCode, pp.ProdBarCode) 'PRODUCT',
          ird.ExtProdID 'PRODUCTIDBUYER',
          ird.ProdID 'PRODUCTIDSUPPLIER',
          ru.Notes 'ORDRSPUNIT',
          LEFT(rp.Notes, 70) 'DESCRIPTION',
				CASE 
					WHEN  @CompID=7138 AND ird.ProdID in (26213,31815,31874) THEN dd.PriceCC_nt *20
					WHEN  @CompID=7138 AND ird.ProdID in (29151) THEN dd.PriceCC_nt *24
					WHEN  @CompID=7138 AND ird.ProdID in (28585) THEN dd.PriceCC_nt *30
					WHEN  @CompID=7138 AND ird.ProdID in (28586,29152) THEN dd.PriceCC_nt *6
					WHEN  @CompID=7138 AND ird.ProdID= 31878 THEN  dd.PriceCC_nt* 6 
					WHEN  @CompID=7138 AND ird.ProdID= 26168 THEN dd.PriceCC_nt*12 
					WHEN  @CompID=7138 AND ird.ProdID= 31880 THEN  dd.PriceCC_nt* 6 
					WHEN  @CompID=7138 AND ird.ProdID= 3127 THEN  dd.PriceCC_nt* 6 
					WHEN  @CompID=7138 AND ird.ProdID= 31879 THEN  dd.PriceCC_nt*6
					WHEN  @CompID=7138 AND ird.ProdID= 30843 THEN  dd.PriceCC_nt*6 
				ELSE 	dd.PriceCC_nt END'PRICE',
				CASE 
					WHEN  @CompID=7138 AND ird.ProdID in (26213,31815,31874) THEN dd.PriceCC_wt *20
					WHEN  @CompID=7138 AND ird.ProdID in (29151) THEN dd.PriceCC_wt *24
					WHEN  @CompID=7138 AND ird.ProdID in (28585) THEN dd.PriceCC_wt *30
					WHEN  @CompID=7138 AND ird.ProdID in (28586,29152) THEN dd.PriceCC_wt *6
					WHEN  @CompID=7138 AND ird.ProdID= 31878 THEN  dd.PriceCC_wt* 6 
					WHEN  @CompID=7138 AND ird.ProdID= 26168 THEN dd.PriceCC_wt*12 
					WHEN  @CompID=7138 AND ird.ProdID= 31880 THEN  dd.PriceCC_wt* 6 
					WHEN  @CompID=7138 AND ird.ProdID= 3127 THEN  dd.PriceCC_wt* 6 
					WHEN  @CompID=7138 AND ird.ProdID= 31879 THEN  dd.PriceCC_wt*6
					WHEN  @CompID=7138 AND ird.ProdID= 30843 THEN  dd.PriceCC_wt*6 
				ELSE dd.PriceCC_wt END 'PRICEWITHVAT',
					dbo.zf_GetProdTaxPercent(ird.ProdID, m.DocDate) 'VAT',
          CASE WHEN dd.Qty IS NULL THEN 3 WHEN dd.Qty = ird.Qty THEN 1 ELSE 2 END 'PRODUCTTYPE',
		CASE 
			WHEN  @CompID=7138 AND ird.ProdID in (26213,31815,31874) THEN ird.Qty/20
			WHEN  @CompID=7138 AND ird.ProdID in (29151) THEN ird.Qty/24
			WHEN  @CompID=7138 AND ird.ProdID in (28585) THEN ird.Qty/30
			WHEN  @CompID=7138 AND ird.ProdID in (28586,29152) THEN ird.Qty/6
            WHEN  @CompID=7138 AND ird.ProdID= 31878 THEN  ird.Qty/6 
            WHEN  @CompID=7138 AND ird.ProdID= 26168 THEN  ird.Qty/12 
            WHEN  @CompID=7138 AND ird.ProdID= 31880 THEN  ird.Qty/6 
            WHEN  @CompID=7138 AND ird.ProdID= 3127 THEN  ird.Qty/ 6 
            WHEN  @CompID=7138 AND ird.ProdID= 31879 THEN  ird.Qty/6
            WHEN  @CompID=7138 AND ird.ProdID= 30843 THEN  ird.Qty/6  
		ELSE ird.Qty END 'ORDEREDQUANTITY',
          ISNULL(CASE 
					WHEN  @CompID=7138 AND ird.ProdID in (26213,31815,31874) THEN dd.Qty/20
					WHEN  @CompID=7138 AND ird.ProdID in (29151) THEN dd.Qty/24
					WHEN  @CompID=7138 AND ird.ProdID in (28585) THEN dd.Qty/30
					WHEN  @CompID=7138 AND ird.ProdID in (28586,29152) THEN dd.Qty/6
					WHEN  @CompID=7138 AND ird.ProdID= 31878 THEN  dd.Qty/6
					WHEN  @CompID=7138 AND ird.ProdID= 26168 THEN  dd.Qty/12 
					WHEN  @CompID=7138 AND ird.ProdID= 31880 THEN  dd.Qty/6 
					WHEN  @CompID=7138 AND ird.ProdID= 3127 THEN  dd.Qty/ 6 
					WHEN  @CompID=7138 AND ird.ProdID= 31879 THEN  dd.Qty/6
					WHEN  @CompID=7138 AND ird.ProdID= 30843 THEN  dd.Qty/6  
				ELSE dd.Qty END, 0) 'ACCEPTEDQUANTITY'
          FROM (SELECT MIN(SrcPosID) SrcPosID, CAST(di.ProdID AS VARCHAR(20)) ProdID, irec.ExtProdID, SUM(Qty) Qty FROM dbo.t_IORecD di WITH(NOLOCK) LEFT JOIN dbo.r_ProdEC irec WITH(NOLOCK) ON irec.ProdID = di.ProdID AND irec.CompID = @CompID WHERE ChID = @OrdChID GROUP BY CAST(di.ProdID AS VARCHAR(20)), irec.ExtProdID HAVING SUM(di.Qty) > 0) ird
          LEFT JOIN (SELECT ISNULL(irec.ExtProdID, CAST(di.ProdID AS VARCHAR(20))) ProdID, irec.ExtProdID, tpp.ProdBarCode, SUM(Qty) Qty, di.PriceCC_nt, di.PriceCC_wt FROM dbo.t_InvD di WITH(NOLOCK) LEFT JOIN dbo.r_ProdEC irec WITH(NOLOCK) ON irec.ProdID = di.ProdID AND irec.CompID = @CompID JOIN dbo.t_PInP tpp WITH(NOLOCK) ON tpp.ProdID = di.ProdID AND tpp.PPID = di.PPID WHERE ChID = @ChID GROUP BY irec.ExtProdID, tpp.ProdBarCode, ISNULL(irec.ExtProdID, CAST(di.ProdID AS VARCHAR(20))), di.PriceCC_nt, di.PriceCC_wt) dd ON (dd.ProdID = ird.ProdID AND dd.ExtProdID IS NULL) OR (dd.ProdID = ird.ExtProdID AND dd.ExtProdID IS NOT NULL)
          LEFT JOIN dbo.r_Prods rp WITH(NOLOCK) ON rp.ProdID = ird.ProdID
          LEFT JOIN dbo.r_Uni ru WITH(NOLOCK) ON ru.RefTypeID = 80021 AND ru.RefName = rp.UM AND ru.Notes IS NOT NULL AND ru.Notes != '' AND ru.RefID < 1000
          LEFT JOIN dbo.t_PInP pp WITH(NOLOCK) ON pp.ProdID = rp.ProdID AND pp.PPID = (SELECT MAX(PPID) FROM dbo.t_PInP WITH(NOLOCK) WHERE ProdID = rp.ProdID AND NOT (ProdBarCode = '' OR ProdBarCode IS NULL))
          FOR XML PATH ('POSITION'), TYPE)
      FOR XML PATH ('HEAD'), TYPE
      )
    FROM dbo.t_Inv m WITH(NOLOCK)
    JOIN dbo.r_CompsAdd rca WITH(NOLOCK) ON rca.CompID = m.CompID AND rca.CompAdd = m.Address
    JOIN dbo.t_IORec ir WITH(NOLOCK) ON @OrdChID = ir.Chid
    JOIN dbo.r_Ours o WITH(NOLOCK) ON m.OurID = o.OurID
    --JOIN dbo.r_OurValues ov WITH(NOLOCK) ON m.OurID = ov.OurID AND ov.VarName = 'GLNCode'
    JOIN dbo.r_Comps c WITH(NOLOCK) ON c.CompID = m.CompID    
    LEFT JOIN dbo.at_t_InvLoad il WITH(NOLOCK) ON il.ChID = m.ChID
    JOIN dbo.at_t_IORecX irx WITH(NOLOCK) ON irx.ChID = @OrdChID
    WHERE m.Chid = @ChID AND-- c.GLNCode <> '' AND
  --  rca.GLNCode <> '' AND
    (ISNULL(ir.GLNCode, '') <> '' OR irx.XMLData IS NOT NULL) AND
    ISNULL(ir.OrderID,'') <> '' AND m.TaxDocID <> 0
    FOR XML PATH ('ORDRSP'))

  ELSE IF @DocType = 'COMDOC'
    SET @Out = (
    SELECT
      m.TaxDocID '���������/��������������',
      '��������� ��������' AS '���������/������������',
      '006' AS '���������/����������������',
      CAST(m.TaxDocDate AS DATE) AS '���������/�������������',
      CASE WHEN ir.OrderID LIKE '%[_]non-alc' OR ir.OrderID LIKE '%[_]alc' THEN REPLACE(REPLACE(ir.OrderID, '_non-alc', ''), '_alc', '') ELSE ir.OrderID END AS '���������/���������������',
      irx.XMLData.value('(./ORDER/DATE)[1]', 'VARCHAR(13)') AS '���������/��������������',
      '��������������� ���. �. ������������' AS '���������/̳������������',
      REPLACE(REPLACE(dbo.af_GetFiltered(REPLACE(REPLACE(zc.ContrID,'-','@'),'/','#')),'@','-'),'#','/') AS '���������/���ϳ������/��������������',
      '������' AS '���������/���ϳ������/������������',
      '001' AS '���������/���ϳ������/����������������',
      CAST(zc.BDate AS DATE) AS '���������/���ϳ������/�������������',
      (SELECT
        (SELECT * FROM (SELECT 
        '���������' AS '�����������������',
        '��������' AS '��������',
        o.Note2 AS '����������������',
        o.Code AS '��������������',
        o.TaxCode AS '���',
        305749 AS '���',
        2600530539322 AS '��������',
        o.Phone AS '�������',
        COALESCE(irx.XMLData.value('(./HEAD/SUPPLIER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/SUPPLIER)[1]', 'VARCHAR(13)'), ir.GLNCode) AS 'GLN'
        UNION
        SELECT 
        '��������' AS '�����������������',
        '��������' AS '��������',
        RTRIM(CASE WHEN c.IsBranch = 1 THEN c.Contract2 ELSE c.Contract1 END) AS '����������������',
        c.Code AS '��������������',
        c.TaxCode AS '���',
        rccc.BankID AS '���',
        rccc.CompAccountCC AS '��������',
        c.TaxPhone AS '�������',
        COALESCE(irx.XMLData.value('(./HEAD/BUYER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/BUYER)[1]', 'VARCHAR(13)')) AS 'GLN') AS contragents
        FOR XML PATH ('����������'), TYPE)
      FOR XML PATH ('�������'), TYPE
    ),
    (SELECT (
    (SELECT * FROM
      (SELECT '����� ��������' AS '��������/@�����', 1 AS '��������/@��', COALESCE(irx.XMLData.value('(./HEAD/DELIVERYPLACE)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/DELIVERYPLACE)[1]', 'VARCHAR(13)'), rca.GLNCode) AS '��������'
      UNION
      SELECT '������ ��������', 2, rca.CompAdd) params
      FOR XML PATH (''), TYPE))
    FOR XML PATH ('���������'), TYPE
    ),
    (SELECT (SELECT 
      ROW_NUMBER() OVER(ORDER BY MAX(dd.SrcPosID)) AS '@��',
      ROW_NUMBER() OVER(ORDER BY MAX(dd.SrcPosID)) AS '������',
        (SELECT ROW_NUMBER() OVER(ORDER BY MAX(d0.PPID)) AS '��������/@��',
        tpp.ProdBarCode AS '��������'
        FROM dbo.t_InvD d0 WITH(NOLOCK)
        JOIN dbo.t_PInP tpp WITH(NOLOCK) ON tpp.ProdID = d0.ProdID AND tpp.PPID = d0.PPID
        WHERE d0.ChID = m.ChID AND d0.ProdID = dd.ProdID
        GROUP BY tpp.ProdBarCode
        FOR XML PATH (''), TYPE
        ),
      ec.ExtProdID AS '��������������',
      dd.ProdID AS '���������������',
      p.Notes AS '������������',
      CAST(SUM(dd.Qty) AS NUMERIC(21,2)) AS '��������ʳ������',
      p.UM AS '������������',
      CAST(dd.PriceCC_nt AS NUMERIC(21,2)) AS '������ֳ��',
      CAST(dd.Tax AS NUMERIC(21,2)) AS '���',
      CAST(dd.PriceCC_wt AS NUMERIC(21,2)) AS 'ֳ��',
      CAST(SUM(dd.SumCC_nt) AS NUMERIC(21,2)) AS '�������������/����������',
      CAST(SUM(dd.TaxSum) AS NUMERIC(21,2)) AS '�������������/�������',
      CAST(SUM(dd.SumCC_wt) AS NUMERIC(21,2)) AS '�������������/����'
      FROM dbo.t_InvD dd WITH(NOLOCK)
      JOIN dbo.r_Prods p WITH(NOLOCK) ON p.ProdID = dd.prodid
      LEFT JOIN dbo.at_r_CompOurTerms rcot WITH(NOLOCK) ON rcot.CompID = m.CompID AND rcot.OurID = m.OurID
      LEFT JOIN dbo.r_ProdEC ec WITH(NOLOCK) ON ec.ProdID=p.ProdID AND ec.CompID = rcot.BCompCode
      WHERE dd.ChID = m.ChID
      GROUP BY ec.ExtProdID, dd.ProdID, p.Notes, p.UM, dd.PriceCC_nt, dd.Tax, dd.PriceCC_wt
    FOR XML PATH ('�����'), TYPE)
    FOR XML PATH ('�������'), TYPE
    ),
    (SELECT CAST(SUM(SumCC_nt) AS NUMERIC(21,2)) FROM dbo.t_InvD WITH(NOLOCK) WHERE ChID = m.ChID) AS '�����������������/����������',
    (SELECT CAST(SUM(TaxSum) AS NUMERIC(21,2)) FROM dbo.t_InvD WITH(NOLOCK) WHERE ChID = m.ChID) AS '�����������������/���',
    (SELECT CAST(SUM(SumCC_wt) AS NUMERIC(21,2)) FROM dbo.t_InvD WITH(NOLOCK) WHERE ChID = m.ChID) AS '�����������������/����'
    FROM dbo.t_Inv m WITH(NOLOCK)
    JOIN dbo.r_CompsAdd rca WITH(NOLOCK) ON rca.CompID = m.CompID AND rca.CompAdd = m.Address
    JOIN dbo.t_IORec ir WITH(NOLOCK) ON @OrdChID = ir.Chid
    JOIN dbo.r_Ours o WITH(NOLOCK) ON m.OurID = o.OurID
    CROSS APPLY [dbo].[af_GetCompReqs](m.CompID, m.TaxDocDate) c
    LEFT JOIN dbo.z_DocLinks zdl WITH(NOLOCK) ON zdl.ChildChID = m.ChID AND zdl.ChildDocCode = 11012 AND zdl.ParentDocCode = 666028
    LEFT JOIN dbo.at_z_Contracts zc WITH(NOLOCK) ON zc.ChID = zdl.ParentChID
    JOIN dbo.at_t_IORecX irx WITH(NOLOCK) ON irx.ChID = @OrdChID
    LEFT JOIN dbo.r_CompsCC rccc WITH(NOLOCK) ON rccc.CompID = m.CompID AND rccc.DefaultAccount = 1
    WHERE m.ChID = @ChID AND
    rca.GLNCode <> '' AND
    (ISNULL(ir.GLNCode, '') <> '' OR irx.XMLData IS NOT NULL) AND
    m.TaxDocID <> 0 AND
    ir.OrderID IS NOT NULL AND ir.OrderID != ''
    FOR XML PATH ('�������������������'))
 
   /* �������� COMDOC_METRO (--������--) */
  ELSE IF @DocType = 'COMDOC_METRO' --�������� ��������� (Document Invoice) - � EDI ������������ ������ ����� METRO
    SET @Out = (
    SELECT
	  --tag 'Invoice-Header'	
      m.IntDocID AS 'Invoice-Header/InvoiceNumber', --InvoiceNumber - ����� ��������� IntDocID(Len  <= 15)
	  CAST(m.DocDate AS DATE) AS 'Invoice-Header/InvoiceDate', --InvoiceDate - ���� ��������� (CCYY-MM-DD) DocDate
	  'UAH' AS 'Invoice-Header/InvoiceCurrency', --������
	  CONVERT(date, getdate()) AS 'Invoice-Header/InvoicePostDate', --���� �������� ���������
	  LEFT(CONVERT(time, getdate()),5) AS 'Invoice-Header/InvoicePostTime', --����� �������� ���������
	  'TN' AS 'Invoice-Header/DocumentFunctionCode', --��� ���� ��������� (TN - �������� ���������, CTN - ��������������� �������� ���������)
 	  CASE WHEN m.CompID = 7001 THEN 24479 WHEN m.CompID = 7003 THEN 24535 ELSE 0 END  AS 'Invoice-Header/ContractNumber', --� �������� �������� (24535 - ��������, 24479 -  ����).
	  --tag 'Invoice-Reference'
	 m.OrderID 'Invoice-Reference/Order/BuyerOrderNumber', --����� ������ (������������� �����, ���� �� ����� ��������� ������ ����)
	 m.TaxDocID 'Invoice-Reference/TaxInvoice/TaxInvoiceNumber', --����� ��������� ���������
	 CAST(m.TaxDocDate AS DATE) 'Invoice-Reference/TaxInvoice/TaxInvoiceDate', --���� ��������� ��������� (���� ��������� ��������� ������ ��������� � ����� �������� ���������)
	 /*��� ��� �����?*/'Invoice-Reference/DespatchAdvice/DespatchAdviceNumber', --����� ����������� �� ��������
	 (SELECT top 1 aerf.ID FROM [s-ppc.const.alef.ua].[Alef_Elit].[dbo].[at_EDI_reg_files] aerf WHERE aerf.doctype = 5000 AND aerf.RetailersID = 17) 'Invoice-Reference/ReceivingAdvice/ReceivingAdviceNumber', --����� ����������� � ������
	  --tag 'Invoice-Parties'
	  --����������
	 '4820086639637' AS 'Invoice-Parties/Buyer/ILN', --GLN ���������� [0-9](13)
	 c.CompID AS 'Invoice-Parties/Buyer/TaxID', --��������� ����������������� ����� ����������
	 c.Code AS 'Invoice-Parties/Buyer/UtilizationRegisterNumber', --������ ���������� (�� ������ ��������� 8 ������)
	 c.Contract1 AS 'Invoice-Parties/Buyer/Name', --�������� ����������
	 [c].[Address] AS 'Invoice-Parties/Buyer/StreetAndNumber', --����� � ����� ���� ����������
	 c.City AS 'Invoice-Parties/Buyer/CityName', --����� ����������
	 c.PostIndex AS 'Invoice-Parties/Buyer/PostalCode', --�������� ��� ����������
	 '2' AS 'Invoice-Parties/Buyer/Country', --��� ������ ���������� (��� ISO 3166)
	 c.Phone1 AS 'Invoice-Parties/Buyer/PhoneNumber', --������� ����������
	 --��������	
	 '4823052500009' AS 'Invoice-Parties/Seller/ILN', --GLN �������� [0-9](13)
	 o.TaxCode AS 'Invoice-Parties/Seller/TaxID', --��������� ����������������� ����� ��������
	 zc.ContrID AS 'Invoice-Parties/Seller/CodeByBuyer', --��� �������� (�������� ���� ������ ���� 5-������� ������)
	 o.Code AS 'Invoice-Parties/Seller/UtilizationRegisterNumber', --������ �������� (�� ������ ��������� 8 ������)
	 o.OurName AS 'Invoice-Parties/Seller/Name', --�������� ��������
	 [o].[Address] AS 'Invoice-Parties/Seller/StreetAndNumber', --����� � ����� ���� ��������
	 o.City AS 'Invoice-Parties/Seller/CityName', --����� ��������
	 o.PostIndex AS 'Invoice-Parties/Seller/PostalCode', --�������� ��� ��������
	 '2' AS 'Invoice-Parties/Seller/Country', --��� ������ �������� (��� ISO 3166)
	 o.Phone AS 'Invoice-Parties/Seller/PhoneNumber', --������� ��������
	 '4820086639309' AS 'Invoice-Parties/DeliveryPoint/ILN', --GLN ����� �������� [0-9](13)
	 '77' AS 'Invoice-Parties/DeliveryPoint/DeliveryPlace', --��� ����� �������� (len < 2)
	 'Invoice-Parties/Payer/ILN', --GLN �����������
	  --tag 'Invoice-Lines' (�������� ������� � ����������� � ������)
	 'Invoice-Lines/Line/Line-Item/LineNumber', --����� �������
	 'Invoice-Lines/Line/Line-Item/EAN', --�����-��� [0-9](14)
	 'Invoice-Lines/Line/Line-Item/BuyerItemCode', --��� ���������������� ����� � ����������, ���� ��������, �� ����� ��������� ����� � ������ ����
	 'Invoice-Lines/Line/Line-Item/SupplierItemCode', --��� ���������������� ����� � ��������
	 'Invoice-Lines/Line/Line-Item/ExternalItemCode', --��� ������ �������� ��� ���
	 'Invoice-Lines/Line/Line-Item/ItemDescription', --�������� ������
	 'Invoice-Lines/Line/Line-Item/InvoiceQuantity', --���������� ������ �� ���������
	 'Invoice-Lines/Line/Line-Item/UnitOfMeasure', --������� ���������
	 'Invoice-Lines/Line/Line-Item/InvoiceUnitNetPrice', --���� ����� ������� ��� ���
	 'Invoice-Lines/Line/Line-Item/TaxRate', --������ ���
	 'Invoice-Lines/Line/Line-Item/TaxCategoryCode', --��� ��������� ���: "E" (����������) � ���������� �� ������ ������, "S" (��������) � ����������� �����
	 'Invoice-Lines/Line/Line-Item/TaxAmount', --����� ������
	 'Invoice-Lines/Line/Line-Item/NetAmount', --����� ��� ���
	  --tag 'Invoice-Summary'
	 'Invoice-Summary/TotalLines', --���������� ����� � ���������
	 'Invoice-Summary/TotalNetAmount', --����� ����� ��� ���
	 'Invoice-Summary/TotalTaxAmount', --����� ���
	 'Invoice-Summary/TotalGrossAmount', --����� ����� � ���
	 'Invoice-Summary/Tax-Summary/Tax-Summary-Line/TaxRate', --������ ������
	 'Invoice-Summary/Tax-Summary/Tax-Summary-Line/TaxCategoryCode', --��� ��������� ���: "E" (����������) � ���������� �� ������ ������, "S" (��������) � ����������� �����
	 'Invoice-Summary/Tax-Summary/Tax-Summary-Line/TaxAmount', --����� ������ ��� ������ ��������� ������
	 'Invoice-Summary/Tax-Summary/Tax-Summary-Line/TaxableAmount' --���������������� ����� �� ��������� ��������� ������

	  FROM dbo.t_Inv m WITH(NOLOCK)
	  JOIN dbo.r_Ours o WITH(NOLOCK) ON m.OurID = o.OurID
	  JOIN dbo.r_Comps c WITH(NOLOCK) ON m.CompID = c.CompID
	  JOIN dbo.at_z_Contracts zc WITH(NOLOCK) ON m.CompID = zc.CompID
	  WHERE m.DocDate between '20190101' AND '20190312' AND m.compID in (7001, 7003) AND m.ChID = @ChID
	  FOR XML PATH ('Document-Invoice')
	  )

--
	  SELECT taxcode, * FROM r_Ours WHERE ourName LIKE '%����%'
	  SELECT TOP 100 * from t_inv
	  SELECT taxcode, * FROM r_comps WHERE compid IN(7001,7003)
	  SELECT * FROM r_prodec
	  SELECT * FROM at_z_Contracts WHERE compid IN(7001,7003)

/*
SELECT compid, orderid, * FROM t_inv where DocDate between '20190101' AND '20190312' AND compid in (7001, 7003) order by  docdate desc
DECLARE @xml XML, @token INT;EXEC ap_EXITE_ExportDoc @DocType='COMDOC_METRO', @DocCode=11012, @ChID=200226582,  @Out = @xml OUTPUT, @TOKEN = @token OUTPUT;SELECT @token, @xml
'*/

/*      
	  m.OrderID AS 'Invoice-Reference/Order/BuyerOrderNumber', --� ������ � EDI (8 ����)
	  m.TaxDocID AS 'Invoice-Reference/TaxInvoice/TaxInvoiceNumber', --� ��������� ���������
	  m.TaxDocDate AS 'Invoice-Reference/TaxInvoice/TaxInvoiceDate', --���� ��������� ���������
	  CASE WHEN ir.OrderID LIKE '%[_]non-alc' OR ir.OrderID LIKE '%[_]alc' THEN REPLACE(REPLACE(ir.OrderID, '_non-alc', ''), '_alc', '') ELSE ir.OrderID END AS 'Invoice-Reference/DespatchAdvice/DespatchAdviceNumber', --� ����������� �� ��������
	  ID 'Invoice-Reference/ReceivingAdvice/ReceivingAdviceNumber' FROM dbo.at_EDI_reg_files aerf	WHERE doctype = 5000 AND RetailersID = 17, --� ����������� � ������
	  --FOR XML PATH ('Invoice-Header')
	  )

*/
      --irx.XMLData.value('(./ORDER/DATE)[1]', 'VARCHAR(13)') AS 'Ivoice-Header/InvoiceDate',
      --'��������������� ���. �. ������������' AS 'Invoice-Header'/*/̳������������*/,
      --REPLACE(REPLACE(dbo.af_GetFiltered(REPLACE(REPLACE(zc.ContrID,'-','@'),'/','#')),'@','-'),'#','/') AS '���������/���ϳ������/��������������',
      --'������' AS '���������/���ϳ������' /*������������*/,
      --'001' AS '���������/���ϳ������/����������������',
      --CAST(zc.BDate AS DATE) AS '���������/���ϳ������/�������������',
    --  (SELECT
    --    (SELECT * FROM (SELECT 
    --    '���������' AS '�����������������',
    --    '��������' AS '��������',
    --    o.Note2 AS '����������������',
    --    o.Code AS '��������������',
    --    o.TaxCode AS '���',
    --    305749 AS '���',
    --    2600530539322 AS '��������',
    --    o.Phone AS '�������',
    --    COALESCE(irx.XMLData.value('(./HEAD/SUPPLIER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/SUPPLIER)[1]', 'VARCHAR(13)'), ir.GLNCode) AS 'GLN'
    --    UNION
    --    SELECT 
    --    '��������' AS '�����������������',
    --    '��������' AS '��������',
    --    RTRIM(CASE WHEN c.IsBranch = 1 THEN c.Contract2 ELSE c.Contract1 END) AS '����������������',
    --    c.Code AS '��������������',
    --    c.TaxCode AS '���',
    --    rccc.BankID AS '���',
    --    rccc.CompAccountCC AS '��������',
    --    c.TaxPhone AS '�������',
    --    COALESCE(irx.XMLData.value('(./HEAD/BUYER)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/BUYER)[1]', 'VARCHAR(13)')) AS 'GLN') AS contragents
    --    FOR XML PATH ('����������'), TYPE)
    --  FOR XML PATH ('�������'), TYPE
    --),
    --(SELECT (
    --(SELECT * FROM
    --  (SELECT '����� ��������' AS '��������/@�����', 1 AS '��������/@��', COALESCE(irx.XMLData.value('(./HEAD/DELIVERYPLACE)[1]', 'VARCHAR(13)'), irx.XMLData.value('(./ORDER/HEAD/DELIVERYPLACE)[1]', 'VARCHAR(13)'), rca.GLNCode) AS '��������'
    --  UNION
    --  SELECT '������ ��������', 2, rca.CompAdd) params
    --  FOR XML PATH (''), TYPE))
    --FOR XML PATH ('���������'), TYPE
    --),
    --(SELECT (SELECT 
    --  ROW_NUMBER() OVER(ORDER BY MAX(dd.SrcPosID)) AS '@��',
    --  ROW_NUMBER() OVER(ORDER BY MAX(dd.SrcPosID)) AS '������',
    --    (SELECT ROW_NUMBER() OVER(ORDER BY MAX(d0.PPID)) AS '��������/@��',
    --    tpp.ProdBarCode AS '��������'
    --    FROM dbo.t_InvD d0 WITH(NOLOCK)
    --    JOIN dbo.t_PInP tpp WITH(NOLOCK) ON tpp.ProdID = d0.ProdID AND tpp.PPID = d0.PPID
    --    WHERE d0.ChID = m.ChID AND d0.ProdID = dd.ProdID
    --    GROUP BY tpp.ProdBarCode
    --    FOR XML PATH (''), TYPE
    --    ),
    --  ec.ExtProdID AS '��������������',
    --  dd.ProdID AS '���������������',
    --  p.Notes AS '������������',
    --  CAST(SUM(dd.Qty) AS NUMERIC(21,2)) AS '��������ʳ������',
    --  p.UM AS '������������',
    --  CAST(dd.PriceCC_nt AS NUMERIC(21,2)) AS '������ֳ��',
    --  CAST(dd.Tax AS NUMERIC(21,2)) AS '���',
    --  CAST(dd.PriceCC_wt AS NUMERIC(21,2)) AS 'ֳ��',
    --  CAST(SUM(dd.SumCC_nt) AS NUMERIC(21,2)) AS '�������������/����������',
    --  CAST(SUM(dd.TaxSum) AS NUMERIC(21,2)) AS '�������������/�������',
    --  CAST(SUM(dd.SumCC_wt) AS NUMERIC(21,2)) AS '�������������/����'
    --  FROM dbo.t_InvD dd WITH(NOLOCK)
    --  JOIN dbo.r_Prods p WITH(NOLOCK) ON p.ProdID = dd.prodid
    --  LEFT JOIN dbo.at_r_CompOurTerms rcot WITH(NOLOCK) ON rcot.CompID = m.CompID AND rcot.OurID = m.OurID
    --  LEFT JOIN dbo.r_ProdEC ec WITH(NOLOCK) ON ec.ProdID=p.ProdID AND ec.CompID = rcot.BCompCode
    --  WHERE dd.ChID = m.ChID
    --  GROUP BY ec.ExtProdID, dd.ProdID, p.Notes, p.UM, dd.PriceCC_nt, dd.Tax, dd.PriceCC_wt
    --FOR XML PATH ('�����'), TYPE)
    --FOR XML PATH ('�������'), TYPE
    --),
    --(SELECT CAST(SUM(SumCC_nt) AS NUMERIC(21,2)) FROM dbo.t_InvD WITH(NOLOCK) WHERE ChID = m.ChID) AS '�����������������/����������',
    --(SELECT CAST(SUM(TaxSum) AS NUMERIC(21,2)) FROM dbo.t_InvD WITH(NOLOCK) WHERE ChID = m.ChID) AS '�����������������/���',
    --(SELECT CAST(SUM(SumCC_wt) AS NUMERIC(21,2)) FROM dbo.t_InvD WITH(NOLOCK) WHERE ChID = m.ChID) AS '�����������������/����'
    --FROM dbo.t_Inv m WITH(NOLOCK)
    --JOIN dbo.r_CompsAdd rca WITH(NOLOCK) ON rca.CompID = m.CompID AND rca.CompAdd = m.Address
    --JOIN dbo.t_IORec ir WITH(NOLOCK) ON @OrdChID = ir.Chid
    --JOIN dbo.r_Ours o WITH(NOLOCK) ON m.OurID = o.OurID
    --CROSS APPLY [dbo].[af_GetCompReqs](m.CompID, m.TaxDocDate) c
    --LEFT JOIN dbo.z_DocLinks zdl WITH(NOLOCK) ON zdl.ChildChID = m.ChID AND zdl.ChildDocCode = 11012 AND zdl.ParentDocCode = 666028
    --LEFT JOIN dbo.at_z_Contracts zc WITH(NOLOCK) ON zc.ChID = zdl.ParentChID
    --JOIN dbo.at_t_IORecX irx WITH(NOLOCK) ON irx.ChID = @OrdChID
    --LEFT JOIN dbo.r_CompsCC rccc WITH(NOLOCK) ON rccc.CompID = m.CompID AND rccc.DefaultAccount = 1
    --WHERE m.ChID = @ChID AND
    --rca.GLNCode <> '' AND
    --(ISNULL(ir.GLNCode, '') <> '' OR irx.XMLData IS NOT NULL) AND
    --m.TaxDocID <> 0 AND
    --ir.OrderID IS NOT NULL AND ir.OrderID != ''
    --FOR XML PATH ('Document-Invoice'))

/* �������� COMDOC_METRO (--�����--)*/


  ELSE IF @DocType = 'DECLAR'
    EXEC [dbo].[ap_EXITE_TaxDoc] @ChID = @ChID, @DocCode = @DocCode, @IsConsolidated = 0, @Out = @Out OUT
   
  IF @DocType = 'DESADV'
    SET @Out = @Desadv
END;



GO


----------------------------------------------
----------------------------------------------
----------------------------------------------

(SELECT 
      ROW_NUMBER() OVER(ORDER BY MAX(dd.SrcPosID)) AS '@��',
      ROW_NUMBER() OVER(ORDER BY MAX(dd.SrcPosID)) AS '������',
      ec.ExtProdID AS '��������������',
      dd.ProdID AS '���������������',
      p.Notes AS '������������',
      CAST(SUM(dd.Qty) AS NUMERIC(21,2)) AS '��������ʳ������',
      p.UM AS '������������',
      CAST(dd.PriceCC_nt AS NUMERIC(21,2)) AS '������ֳ��',
      CAST(dd.Tax AS NUMERIC(21,2)) AS '���',
      CAST(dd.PriceCC_wt AS NUMERIC(21,2)) AS 'ֳ��',
      CAST(SUM(dd.SumCC_nt) AS NUMERIC(21,2)) AS '�������������/����������',
      CAST(SUM(dd.TaxSum) AS NUMERIC(21,2)) AS '�������������/�������',
      CAST(SUM(dd.SumCC_wt) AS NUMERIC(21,2)) AS '�������������/����'
      FROM dbo.t_InvD dd WITH(NOLOCK)
      JOIN dbo.r_Prods p WITH(NOLOCK) ON p.ProdID = dd.prodid
      LEFT JOIN dbo.at_r_CompOurTerms rcot WITH(NOLOCK) ON rcot.CompID = m.CompID AND rcot.OurID = m.OurID
      LEFT JOIN dbo.r_ProdEC ec WITH(NOLOCK) ON ec.ProdID=p.ProdID AND ec.CompID = rcot.BCompCode
      WHERE dd.ChID = m.ChID
      GROUP BY ec.ExtProdID, dd.ProdID, p.Notes, p.UM, dd.PriceCC_nt, dd.Tax, dd.PriceCC_wt
    FOR XML PATH ('�����'), TYPE)