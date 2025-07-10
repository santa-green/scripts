--USE [Elit_TEST_IM]
--------------------------------������� #1--------------------------------------
--------------------------------������� #1--------------------------------------
--------------------------------������� #1--------------------------------------

ALTER PROCEDURE dbo.ap_medoc_actsverki_xml AS

BEGIN

DECLARE 
@OurID int = 1
,@BDate smalldatetime = '20190401'
,@EDate smalldatetime = '20190412'
,@IsConsCode int = 0
,@xml xml


IF OBJECT_ID (N'tempdb..#db_Doc', N'U') IS NOT NULL DROP TABLE #db_Doc
--INSERT #db_Doc
SELECT * 
 INTO #db_Doc
FROM (
SELECT data.CompID, CASE WHEN SUM(BCSaldo) > SUM(BDSaldo) THEN SUM(BCSaldo) - SUM(BDSaldo) ELSE 0 END BCSaldo,
CASE WHEN SUM(BCSaldo) > SUM(BDSaldo) THEN 0 ELSE SUM(BDSaldo) - SUM(BCSaldo) END BDSaldo,
CASE WHEN SUM(ECSaldo) > SUM(EDSaldo) THEN SUM(ECSaldo) - SUM(EDSaldo) ELSE 0 END ECSaldo,
CASE WHEN SUM(ECSaldo) > SUM(EDSaldo) THEN 0 ELSE SUM(EDSaldo) - SUM(ECSaldo) END EDSaldo,
/* ��������� ����� */
LTRIM(RTRIM(ISNULL(NULLIF(LTRIM(RTRIM(rc.Contract2)),''), rc.Contract1))) CompName,
rc.Job3, '/ '  + srs.SRName EmpName,
CAST((SELECT COUNT(*) FROM dbo.at_z_ContractsAdd zca WITH(NOLOCK) WHERE zca.HaveSeal = 1 AND zca.ChID = (SELECT TOP 1 ChID FROM dbo.at_z_Contracts WITH(NOLOCK) WHERE CompID = data.CompID AND OurID = @OurID AND Status = 1 ORDER BY EDate DESC, ChID ASC)) +
(SELECT COUNT(*) FROM dbo.at_z_ContractsAdd zca WITH(NOLOCK) WHERE zca.HaveStamp = 1 AND zca.ChID = (SELECT TOP 1 ChID FROM dbo.at_z_Contracts WITH(NOLOCK) WHERE CompID = data.CompID AND OurID = @OurID AND Status = 1 ORDER BY EDate DESC, ChID ASC)) AS BIT) HaveStamp
FROM (
SELECT m.CompID CompID, (SELECT BCompCode FROM dbo.at_r_CompOurTerms WITH(NOLOCK) WHERE CompID = m.CompID AND OurID = m.OurID) FLDNAME2, SUM(TSumCC_wt*KursCC) BCSaldo, 0 BDSaldo, 0 ECSaldo, 0 EDSaldo FROM av_t_Rec m WHERE DocDate < @BDate AND OurID = 1 AND CompID = 71297 AND ((CodeID1>=51 AND CodeID1<=79)) AND ((CodeID3>=2 AND CodeID3<=4) OR CodeID3=7 OR CodeID3=104) GROUP BY m.CompID, m.OurID UNION ALL
SELECT m.CompID CompID, (SELECT BCompCode FROM dbo.at_r_CompOurTerms WITH(NOLOCK) WHERE CompID = m.CompID AND OurID = m.OurID) FLDNAME2, SUM(TSumCC_wt*KursCC), 0, 0 ECSaldo, 0 EDSaldo FROM av_t_Ret m WHERE DocDate < @BDate AND OurID = 1 AND CompID = 71297 AND ((CodeID1>=51 AND CodeID1<=79)) AND ((CodeID3>=2 AND CodeID3<=4) OR CodeID3=7 OR CodeID3=104) GROUP BY m.CompID, m.OurID UNION ALL
SELECT m.CompID CompID, (SELECT BCompCode FROM dbo.at_r_CompOurTerms WITH(NOLOCK) WHERE CompID = m.CompID AND OurID = m.OurID) FLDNAME2, 0, SUM(TSumCC_wt*KursCC), 0 ECSaldo, 0 EDSaldo FROM av_t_Inv m WHERE DocDate < @BDate AND OurID = 1 AND CompID = 71297 AND ((CodeID1>=51 AND CodeID1<=79)) AND ((CodeID3>=2 AND CodeID3<=4) OR CodeID3=7 OR CodeID3=104) GROUP BY m.CompID, m.OurID UNION ALL
SELECT m.CompID CompID, (SELECT BCompCode FROM dbo.at_r_CompOurTerms WITH(NOLOCK) WHERE CompID = m.CompID AND OurID = m.OurID) FLDNAME2, 0, SUM(TSumCC_wt*KursCC), 0 ECSaldo, 0 EDSaldo FROM av_t_Exp m WHERE DocDate < @BDate AND OurID = 1 AND CompID = 71297 AND ((CodeID1>=51 AND CodeID1<=79)) AND ((CodeID3>=2 AND CodeID3<=4) OR CodeID3=7 OR CodeID3=104) GROUP BY m.CompID, m.OurID UNION ALL
SELECT m.CompID CompID, (SELECT BCompCode FROM dbo.at_r_CompOurTerms WITH(NOLOCK) WHERE CompID = m.CompID AND OurID = m.OurID) FLDNAME2, 0, SUM(TSumCC_wt*KursCC), 0 ECSaldo, 0 EDSaldo FROM av_t_Epp m WHERE DocDate < @BDate AND OurID = 1 AND CompID = 71297 AND ((CodeID1>=51 AND CodeID1<=79)) AND ((CodeID3>=2 AND CodeID3<=4) OR CodeID3=7 OR CodeID3=104) GROUP BY m.CompID, m.OurID UNION ALL
SELECT m.CompID CompID, (SELECT BCompCode FROM dbo.at_r_CompOurTerms WITH(NOLOCK) WHERE CompID = m.CompID AND OurID = m.OurID) FLDNAME2, SUM(SumAC*KursCC), 0, 0 ECSaldo, 0 EDSaldo FROM av_t_MonRec m WHERE SumAC>0 AND DocDate < @BDate AND OurID = 1 AND CompID = 71297 AND ((CodeID1>=51 AND CodeID1<=79)) AND ((CodeID3>=2 AND CodeID3<=4) OR CodeID3=7 OR CodeID3=104) GROUP BY m.CompID, m.OurID UNION ALL
SELECT m.CompID CompID, (SELECT BCompCode FROM dbo.at_r_CompOurTerms WITH(NOLOCK) WHERE CompID = m.CompID AND OurID = m.OurID) FLDNAME2, 0, SUM(-SumAC*KursCC), 0 ECSaldo, 0 EDSaldo FROM av_t_MonRec m WHERE SumAC<0 AND DocDate < @BDate AND OurID = 1 AND CompID = 71297 AND ((CodeID1>=51 AND CodeID1<=79)) AND ((CodeID3>=2 AND CodeID3<=4) OR CodeID3=7 OR CodeID3=104) GROUP BY m.CompID, m.OurID UNION ALL
SELECT m.CompID CompID, (SELECT BCompCode FROM dbo.at_r_CompOurTerms WITH(NOLOCK) WHERE CompID = m.CompID AND OurID = m.OurID) FLDNAME2, SUM(SumAC*KursCC), 0, 0 ECSaldo, 0 EDSaldo FROM av_c_CompRec m WHERE DocDate < @BDate AND OurID = 1 AND CompID = 71297 AND ((CodeID1>=51 AND CodeID1<=79)) AND ((CodeID3>=2 AND CodeID3<=4) OR CodeID3=7 OR CodeID3=104) GROUP BY m.CompID, m.OurID UNION ALL
SELECT m.CompID CompID, (SELECT BCompCode FROM dbo.at_r_CompOurTerms WITH(NOLOCK) WHERE CompID = m.CompID AND OurID = m.OurID) FLDNAME2, 0, SUM(SumAC*KursCC), 0 ECSaldo, 0 EDSaldo FROM av_c_CompExp m WHERE DocDate < @BDate AND OurID = 1 AND CompID = 71297 AND ((CodeID1>=51 AND CodeID1<=79)) AND ((CodeID3>=2 AND CodeID3<=4) OR CodeID3=7 OR CodeID3=104) GROUP BY m.CompID, m.OurID UNION ALL
SELECT m.CompID CompID, (SELECT BCompCode FROM dbo.at_r_CompOurTerms WITH(NOLOCK) WHERE CompID = m.CompID AND OurID = m.OurID) FLDNAME2, SUM(SumAC*KursCC), 0, 0 ECSaldo, 0 EDSaldo FROM av_c_CompIn m WHERE SumAC>0 AND DocDate < @BDate AND OurID = 1 AND CompID = 71297 AND ((CodeID1>=51 AND CodeID1<=79)) AND ((CodeID3>=2 AND CodeID3<=4) OR CodeID3=7 OR CodeID3=104) GROUP BY m.CompID, m.OurID UNION ALL
SELECT m.CompID CompID, (SELECT BCompCode FROM dbo.at_r_CompOurTerms WITH(NOLOCK) WHERE CompID = m.CompID AND OurID = m.OurID) FLDNAME2, 0, SUM(-SumAC*KursCC), 0 ECSaldo, 0 EDSaldo FROM av_c_CompIn m WHERE SumAC<0 AND DocDate < @BDate AND OurID = 1 AND CompID = 71297 AND ((CodeID1>=51 AND CodeID1<=79)) AND ((CodeID3>=2 AND CodeID3<=4) OR CodeID3=7 OR CodeID3=104) GROUP BY m.CompID, m.OurID UNION ALL
SELECT m.CompID CompID, (SELECT BCompCode FROM dbo.at_r_CompOurTerms WITH(NOLOCK) WHERE CompID = m.CompID AND OurID = m.OurID) FLDNAME2, SUM(SumAC*KursCC), 0, 0 ECSaldo, 0 EDSaldo FROM av_c_CompCor m WHERE DocDate < @BDate AND OurID = 1 AND CompID = 71297 AND ((CodeID1>=51 AND CodeID1<=79)) AND ((CodeID3>=2 AND CodeID3<=4) OR CodeID3=7 OR CodeID3=104) GROUP BY m.CompID, m.OurID UNION ALL
SELECT m.CompID CompID, (SELECT BCompCode FROM dbo.at_r_CompOurTerms WITH(NOLOCK) WHERE CompID = m.CompID AND OurID = m.OurID) FLDNAME2, 0, SUM(SumAC*KursCC), 0 ECSaldo, 0 EDSaldo FROM av_c_PlanRec m WHERE DocDate < @BDate AND OurID = 1 AND CompID = 71297 AND ((CodeID1>=51 AND CodeID1<=79)) AND ((CodeID3>=2 AND CodeID3<=4) OR CodeID3=7 OR CodeID3=104) GROUP BY m.CompID, m.OurID
UNION ALL
SELECT m.CompID CompID, (SELECT BCompCode FROM dbo.at_r_CompOurTerms WITH(NOLOCK) WHERE CompID = m.CompID AND OurID = m.OurID) FLDNAME2, 0 BCSaldo, 0 BDSaldo, SUM(TSumCC_wt*KursCC) ECSaldo, 0 EDSaldo FROM av_t_Rec m WHERE DocDate <= @EDate AND OurID = 1 AND CompID = 71297 AND ((CodeID1>=51 AND CodeID1<=79)) AND ((CodeID3>=2 AND CodeID3<=4) OR CodeID3=7 OR CodeID3=104) GROUP BY m.CompID, m.OurID UNION ALL
SELECT m.CompID CompID, (SELECT BCompCode FROM dbo.at_r_CompOurTerms WITH(NOLOCK) WHERE CompID = m.CompID AND OurID = m.OurID) FLDNAME2, 0, 0, SUM(TSumCC_wt*KursCC) ECSaldo, 0 EDSaldo FROM av_t_Ret m WHERE DocDate <= @EDate AND OurID = 1 AND CompID = 71297 AND ((CodeID1>=51 AND CodeID1<=79)) AND ((CodeID3>=2 AND CodeID3<=4) OR CodeID3=7 OR CodeID3=104) GROUP BY m.CompID, m.OurID UNION ALL
SELECT m.CompID CompID, (SELECT BCompCode FROM dbo.at_r_CompOurTerms WITH(NOLOCK) WHERE CompID = m.CompID AND OurID = m.OurID) FLDNAME2, 0, 0, 0 ECSaldo, SUM(TSumCC_wt*KursCC) EDSaldo FROM av_t_Inv m WHERE DocDate <= @EDate AND OurID = 1 AND CompID = 71297 AND ((CodeID1>=51 AND CodeID1<=79)) AND ((CodeID3>=2 AND CodeID3<=4) OR CodeID3=7 OR CodeID3=104) GROUP BY m.CompID, m.OurID UNION ALL
SELECT m.CompID CompID, (SELECT BCompCode FROM dbo.at_r_CompOurTerms WITH(NOLOCK) WHERE CompID = m.CompID AND OurID = m.OurID) FLDNAME2, 0, 0, 0 ECSaldo, SUM(TSumCC_wt*KursCC) EDSaldo FROM av_t_Exp m WHERE DocDate <= @EDate AND OurID = 1 AND CompID = 71297 AND ((CodeID1>=51 AND CodeID1<=79)) AND ((CodeID3>=2 AND CodeID3<=4) OR CodeID3=7 OR CodeID3=104) GROUP BY m.CompID, m.OurID UNION ALL
SELECT m.CompID CompID, (SELECT BCompCode FROM dbo.at_r_CompOurTerms WITH(NOLOCK) WHERE CompID = m.CompID AND OurID = m.OurID) FLDNAME2, 0, 0, 0 ECSaldo, SUM(TSumCC_wt*KursCC) EDSaldo FROM av_t_Epp m WHERE DocDate <= @EDate AND OurID = 1 AND CompID = 71297 AND ((CodeID1>=51 AND CodeID1<=79)) AND ((CodeID3>=2 AND CodeID3<=4) OR CodeID3=7 OR CodeID3=104) GROUP BY m.CompID, m.OurID UNION ALL
SELECT m.CompID CompID, (SELECT BCompCode FROM dbo.at_r_CompOurTerms WITH(NOLOCK) WHERE CompID = m.CompID AND OurID = m.OurID) FLDNAME2, 0, 0, SUM(SumAC*KursCC) ECSaldo, 0 EDSaldo FROM av_t_MonRec m WHERE SumAC>0 AND DocDate <= @EDate AND OurID = 1 AND CompID = 71297 AND ((CodeID1>=51 AND CodeID1<=79)) AND ((CodeID3>=2 AND CodeID3<=4) OR CodeID3=7 OR CodeID3=104) GROUP BY m.CompID, m.OurID UNION ALL
SELECT m.CompID CompID, (SELECT BCompCode FROM dbo.at_r_CompOurTerms WITH(NOLOCK) WHERE CompID = m.CompID AND OurID = m.OurID) FLDNAME2, 0, 0, 0 ECSaldo, SUM(-SumAC*KursCC) EDSaldo FROM av_t_MonRec m WHERE SumAC<0 AND DocDate <= @EDate AND OurID = 1 AND CompID = 71297 AND ((CodeID1>=51 AND CodeID1<=79)) AND ((CodeID3>=2 AND CodeID3<=4) OR CodeID3=7 OR CodeID3=104) GROUP BY m.CompID, m.OurID UNION ALL
SELECT m.CompID CompID, (SELECT BCompCode FROM dbo.at_r_CompOurTerms WITH(NOLOCK) WHERE CompID = m.CompID AND OurID = m.OurID) FLDNAME2, 0, 0, SUM(SumAC*KursCC) ECSaldo, 0 EDSaldo FROM av_c_CompRec m WHERE DocDate <= @EDate AND OurID = 1 AND CompID = 71297 AND ((CodeID1>=51 AND CodeID1<=79)) AND ((CodeID3>=2 AND CodeID3<=4) OR CodeID3=7 OR CodeID3=104) GROUP BY m.CompID, m.OurID UNION ALL
SELECT m.CompID CompID, (SELECT BCompCode FROM dbo.at_r_CompOurTerms WITH(NOLOCK) WHERE CompID = m.CompID AND OurID = m.OurID) FLDNAME2, 0, 0, 0 ECSaldo, SUM(SumAC*KursCC) EDSaldo FROM av_c_CompExp m WHERE DocDate <= @EDate AND OurID = 1 AND CompID = 71297 AND ((CodeID1>=51 AND CodeID1<=79)) AND ((CodeID3>=2 AND CodeID3<=4) OR CodeID3=7 OR CodeID3=104) GROUP BY m.CompID, m.OurID UNION ALL
SELECT m.CompID CompID, (SELECT BCompCode FROM dbo.at_r_CompOurTerms WITH(NOLOCK) WHERE CompID = m.CompID AND OurID = m.OurID) FLDNAME2, 0, 0, SUM(SumAC*KursCC) ECSaldo, 0 EDSaldo FROM av_c_CompIn m WHERE SumAC>0 AND DocDate <= @EDate AND OurID = 1 AND CompID = 71297 AND ((CodeID1>=51 AND CodeID1<=79)) AND ((CodeID3>=2 AND CodeID3<=4) OR CodeID3=7 OR CodeID3=104) GROUP BY m.CompID, m.OurID UNION ALL
SELECT m.CompID CompID, (SELECT BCompCode FROM dbo.at_r_CompOurTerms WITH(NOLOCK) WHERE CompID = m.CompID AND OurID = m.OurID) FLDNAME2, 0, 0, 0 ECSaldo, SUM(-SumAC*KursCC) EDSaldo FROM av_c_CompIn m WHERE SumAC<0 AND DocDate <= @EDate AND OurID = 1 AND CompID = 71297 AND ((CodeID1>=51 AND CodeID1<=79)) AND ((CodeID3>=2 AND CodeID3<=4) OR CodeID3=7 OR CodeID3=104) GROUP BY m.CompID, m.OurID UNION ALL
SELECT m.CompID CompID, (SELECT BCompCode FROM dbo.at_r_CompOurTerms WITH(NOLOCK) WHERE CompID = m.CompID AND OurID = m.OurID) FLDNAME2, 0, 0, SUM(SumAC*KursCC) ECSaldo, 0 EDSaldo FROM av_c_CompCor m WHERE DocDate <= @EDate AND OurID = 1 AND CompID = 71297 AND ((CodeID1>=51 AND CodeID1<=79)) AND ((CodeID3>=2 AND CodeID3<=4) OR CodeID3=7 OR CodeID3=104) GROUP BY m.CompID, m.OurID UNION ALL
SELECT m.CompID CompID, (SELECT BCompCode FROM dbo.at_r_CompOurTerms WITH(NOLOCK) WHERE CompID = m.CompID AND OurID = m.OurID) FLDNAME2, 0, 0, 0 ECSaldo, SUM(SumAC*KursCC) EDSaldo FROM av_c_PlanRec m WHERE DocDate <= @EDate AND OurID = 1 AND CompID = 71297 AND ((CodeID1>=51 AND CodeID1<=79)) AND ((CodeID3>=2 AND CodeID3<=4) OR CodeID3=7 OR CodeID3=104) GROUP BY m.CompID, m.OurID
) data
LEFT JOIN dbo.r_Comps rc WITH(NOLOCK) ON rc.CompID = data.CompID
LEFT JOIN dbo.at_r_CompOurTerms rcot WITH(NOLOCK) ON rcot.CompID = rc.CompID AND rcot.OurID = @OurID
LEFT JOIN dbo.at_r_SRs srs WITH(NOLOCK) ON srs.SRID = rcot.SRID AND 0 = @IsConsCode
GROUP BY data.CompID, rc.Contract2, rc.Contract1, rc.Job3, srs.SRName
) s1

SELECT * FROM #db_Doc

END
--------------------------------������� #2--------------------------------------
--------------------------------������� #2--------------------------------------
--------------------------------������� #2--------------------------------------
BEGIN

DECLARE 
--@OurID int = 1
--,@BDate smalldatetime = '20190401'
--,@EDate smalldatetime = '20190412'
 @Cons int = 0
,@CompID int = 71297


IF OBJECT_ID (N'tempdb..#db_DocD', N'U') IS NOT NULL DROP TABLE #db_DocD;
--INSERT #db_DocD
SELECT * 
 INTO #db_DocD
FROM (
SELECT ROW_NUMBER() OVER(ORDER BY DocID DESC) - 1 Num,DocDate, DocID, TaxDocID, DocName, SUM(ISNULL(DSumCC,0)) DSumCC, SUM(ISNULL(CSumCC,0)) CSumCC
FROM (
SELECT '������' DocName, DocDate, DocID, TaxDocID, TSumCC_wt*KursCC CSumCC, 0 DSumCC, 0 ChID FROM av_t_Rec m WHERE DocDate BETWEEN @BDate AND @EDate AND ((0 = @Cons AND m.CompID = @CompID) OR (1 = @Cons AND EXISTS(SELECT * FROM dbo.at_r_CompOurTerms WITH(NOLOCK) WHERE CompID = m.CompID AND OurID = m.OurID AND BCompCode = @CompID))) AND OurID = 1 AND CompID = 71297 AND ((CodeID1>=51 AND CodeID1<=79)) AND ((CodeID3>=2 AND CodeID3<=4) OR CodeID3=7 OR CodeID3=104) UNION ALL
SELECT '����������', DocDate, DocID, TaxDocID, TSumCC_wt*KursCC, 0, 0 FROM av_t_Ret m WHERE DocDate BETWEEN @BDate AND @EDate AND ((0 = @Cons AND m.CompID = @CompID) OR (1 = @Cons AND EXISTS(SELECT * FROM dbo.at_r_CompOurTerms WITH(NOLOCK) WHERE CompID = m.CompID AND OurID = m.OurID AND BCompCode = @CompID))) AND OurID = 1 AND CompID = 71297 AND ((CodeID1>=51 AND CodeID1<=79)) AND ((CodeID3>=2 AND CodeID3<=4) OR CodeID3=7 OR CodeID3=104) UNION ALL
SELECT '���������', DocDate, DocID, TaxDocID, 0, TSumCC_wt*KursCC, 0 FROM av_t_Inv m WHERE DocDate BETWEEN @BDate AND @EDate AND ((0 = @Cons AND m.CompID = @CompID) OR (1 = @Cons AND EXISTS(SELECT * FROM dbo.at_r_CompOurTerms WITH(NOLOCK) WHERE CompID = m.CompID AND OurID = m.OurID AND BCompCode = @CompID))) AND OurID = 1 AND CompID = 71297 AND ((CodeID1>=51 AND CodeID1<=79)) AND ((CodeID3>=2 AND CodeID3<=4) OR CodeID3=7 OR CodeID3=104) UNION ALL
SELECT '���������', DocDate, DocID, TaxDocID, 0, TSumCC_wt*KursCC, 0 FROM av_t_Exp m WHERE DocDate BETWEEN @BDate AND @EDate AND ((0 = @Cons AND m.CompID = @CompID) OR (1 = @Cons AND EXISTS(SELECT * FROM dbo.at_r_CompOurTerms WITH(NOLOCK) WHERE CompID = m.CompID AND OurID = m.OurID AND BCompCode = @CompID))) AND OurID = 1 AND CompID = 71297 AND ((CodeID1>=51 AND CodeID1<=79)) AND ((CodeID3>=2 AND CodeID3<=4) OR CodeID3=7 OR CodeID3=104) UNION ALL
SELECT '���������', DocDate, DocID, TaxDocID, 0, TSumCC_wt*KursCC, 0 FROM av_t_Epp m WHERE DocDate BETWEEN @BDate AND @EDate AND ((0 = @Cons AND m.CompID = @CompID) OR (1 = @Cons AND EXISTS(SELECT * FROM dbo.at_r_CompOurTerms WITH(NOLOCK) WHERE CompID = m.CompID AND OurID = m.OurID AND BCompCode = @CompID))) AND OurID = 1 AND CompID = 71297 AND ((CodeID1>=51 AND CodeID1<=79)) AND ((CodeID3>=2 AND CodeID3<=4) OR CodeID3=7 OR CodeID3=104) UNION ALL
SELECT '������', DocDate, DocID, 0, SumAC*KursCC, 0, ChID FROM av_t_MonRec m WHERE SumAC>0 AND DocDate BETWEEN @BDate AND @EDate AND ((0 = @Cons AND m.CompID = @CompID) OR (1 = @Cons AND EXISTS(SELECT * FROM dbo.at_r_CompOurTerms WITH(NOLOCK) WHERE CompID = m.CompID AND OurID = m.OurID AND BCompCode = @CompID))) AND OurID = 1 AND CompID = 71297 AND ((CodeID1>=51 AND CodeID1<=79)) AND ((CodeID3>=2 AND CodeID3<=4) OR CodeID3=7 OR CodeID3=104) UNION ALL
SELECT '������', DocDate, DocID, 0, 0, -SumAC*KursCC, ChID FROM av_t_MonRec m WHERE SumAC<0 AND DocDate BETWEEN @BDate AND @EDate AND ((0 = @Cons AND m.CompID = @CompID) OR (1 = @Cons AND EXISTS(SELECT * FROM dbo.at_r_CompOurTerms WITH(NOLOCK) WHERE CompID = m.CompID AND OurID = m.OurID AND BCompCode = @CompID))) AND OurID = 1 AND CompID = 71297 AND ((CodeID1>=51 AND CodeID1<=79)) AND ((CodeID3>=2 AND CodeID3<=4) OR CodeID3=7 OR CodeID3=104) UNION ALL
SELECT '������', DocDate, DocNum, 0, SumAC*KursCC, 0, ChID FROM av_c_CompRec m WHERE DocDate BETWEEN @BDate AND @EDate AND ((0 = @Cons AND m.CompID = @CompID) OR (1 = @Cons AND EXISTS(SELECT * FROM dbo.at_r_CompOurTerms WITH(NOLOCK) WHERE CompID = m.CompID AND OurID = m.OurID AND BCompCode = @CompID))) AND OurID = 1 AND CompID = 71297 AND ((CodeID1>=51 AND CodeID1<=79)) AND ((CodeID3>=2 AND CodeID3<=4) OR CodeID3=7 OR CodeID3=104) UNION ALL
SELECT '������', DocDate, DocNum, 0, 0, SumAC*KursCC, ChID FROM av_c_CompExp m WHERE DocDate BETWEEN @BDate AND @EDate AND ((0 = @Cons AND m.CompID = @CompID) OR (1 = @Cons AND EXISTS(SELECT * FROM dbo.at_r_CompOurTerms WITH(NOLOCK) WHERE CompID = m.CompID AND OurID = m.OurID AND BCompCode = @CompID))) AND OurID = 1 AND CompID = 71297 AND ((CodeID1>=51 AND CodeID1<=79)) AND ((CodeID3>=2 AND CodeID3<=4) OR CodeID3=7 OR CodeID3=104) UNION ALL
SELECT '����������� ��������� �����', DocDate,  DocID, 0, SumAC*KursCC, 0, ChID FROM av_c_CompCor m WHERE DocDate BETWEEN @BDate AND @EDate AND ((0 = @Cons AND m.CompID = @CompID) OR (1 = @Cons AND EXISTS(SELECT * FROM dbo.at_r_CompOurTerms WITH(NOLOCK) WHERE CompID = m.CompID AND OurID = m.OurID AND BCompCode = @CompID))) AND OurID = 1 AND CompID = 71297 AND ((CodeID1>=51 AND CodeID1<=79)) AND ((CodeID3>=2 AND CodeID3<=4) OR CodeID3=7 OR CodeID3=104) UNION ALL
SELECT '����������� �������� �������', DocDate, DocID, 0, 0, SumAC*KursCC, ChID FROM av_c_PlanRec m WHERE DocDate BETWEEN @BDate AND @EDate AND ((0 = @Cons AND m.CompID = @CompID) OR (1 = @Cons AND EXISTS(SELECT * FROM dbo.at_r_CompOurTerms WITH(NOLOCK) WHERE CompID = m.CompID AND OurID = m.OurID AND BCompCode = @CompID))) AND OurID = 1 AND CompID = 71297 AND ((CodeID1>=51 AND CodeID1<=79)) AND ((CodeID3>=2 AND CodeID3<=4) OR CodeID3=7 OR CodeID3=104)
) data
GROUP BY DocDate, DocID, TaxDocID, DocName
HAVING SUM(ISNULL(DSumCC,0)) <> 0 OR SUM(ISNULL(CSumCC,0)) <> 0
--ORDER BY DocDate, TaxDocID
) s2

SELECT * FROM #db_DocD

END

--------------------------��������� XML-----------------------------------------
--------------------------��������� XML-----------------------------------------
--------------------------��������� XML-----------------------------------------

--��� �������� ������??
--insert <?xml-stylesheet type="text/xsl" href="stylesheet.xsl"?>
--SET @xml.modify('
--insert <?xml-stylesheet type="text/xsl" href="stylesheet.xsl"?>
--before /*[1]
--')
--SELECT @xml

/*
������ ������ ����������� FOR XML
RAW � �����, ��� ������� � XML ��������� ��������� ��������� ������� <row> ��� ������ ������ ��������������� ������ ������ ���������� SELECT;
AUTO � � ������ ������ ��������� XML ��������� ��������� �������������, � ����������� �� ���������� SELECT (�����������, ��������� �������� � ��� �����);
EXPLICIT � ����� ����������� ����� ������ ����������� FOR XML, ��� ������� �� ���� ���������� ��������� ��������� XML ���������, �� ���� ���� ���� ����� ����� ����������. ������ ����� � �������� ������������ ��� �������� XML ���������� � ����� ������� ����������, ������� �� ���������� ����������� � ������� ������ �������;
PATH � ��� ������ ���� ���������� ����� EXPLICIT, ������� ������ ����������� �� ���������� ����� �� ������������ XML ����������, ������� ������������ ��������� ��� ���������. ���� ��� ����� ����� ������������ ��������� XML ������, �� ������������� ������������ ������ ���� �����.
��������� ����������� FOR XML
TYPE � ���������� �������������� XML ������ � ����� XML, ���� �������� TYPE �� ������, ������ ������������ � ����� NVARCHAR(MAX). �������� ��������� � ��� �������, ����� ��� ��������� XML ������� ����� ����������� ��������, ����������� ��� XML ������, ��������, ���������� ���������� �� ����� XQuery;
ELEMENTS � ���� ������� ������ ��������, ������� ������������ � ���� ��������� ���������;
ROOT � �������� ��������� � ��������������� XML-��������� ���� ������� �������� ������ (�������� �������), �� ��������� �root�, ������ �������� ����� ������� ������������.
https://info-comp.ru/obucheniest/642-for-xml-in-t-sql.html
*/

BEGIN

set @xml = (
SELECT 
--Transport
	  '4.1' AS 'TRANSPORT/VERSION' --4.1
	  ,Convert(varchar, GETDATE(), 104) AS 'TRANSPORT/CREATEDATE'
--Org/Fields
	  ,(SELECT Code FROM r_ours WHERE OurID = @OurID) AS 'ORG/FIELDS/EDRPOU'
--Org/Card/Fields
	  ,'1' AS 'ORG/CARD/@RTFDOC'
      ,'DocID' AS 'ORG/CARD/FIELDS/DOCID'
	  --, cast((SELECT CONVERT(varchar(max),(SELECT '' AS 'OUTID' FOR XML PATH(''), TYPE))) as xml) AS 'ORG/CARD/FIELDS' --����������������� ���.
      ,'' AS 'ORG/CARD/FIELDS/OUTID'
	  ,'GLOBALTMPLID' AS 'ORG/CARD/FIELDS/GLOBALTMPLID'
	  ,(SELECT Code FROM r_comps where compid = (SELECT CompID FROM #db_Doc)) AS 'ORG/CARD/FIELDS/TMPLEDRPOUOWNER' 
	  ,'��� �������' AS 'ORG/CARD/FIELDS/DOCNAME'
	  ,'ALD_AZV' AS 'ORG/CARD/FIELDS/CHARCODE' --ALD_AZV
	  ,'' AS 'ORG/CARD/FIELDS/PARTCODE' --7
	  --, cast((SELECT CONVERT(varchar(max),(SELECT '' AS 'GRPID' FOR XML PATH(''), TYPE))) as xml) AS 'ORG/CARD/FIELDS' --����������������� ��� (����������..).
	  ,'' AS 'ORG/CARD/FIELDS/GRPID' --������
	  --, cast((SELECT CONVERT(varchar(max),(SELECT '' AS 'NOTATION' FOR XML PATH(''), TYPE))) as xml) AS 'ORG/CARD/FIELDS' --����������������� ���.
	  ,'' AS 'ORG/CARD/FIELDS/NOTATION' --������
	  --, cast((SELECT CONVERT(varchar(max),(SELECT '' AS 'SIGNERNAME' FOR XML PATH(''), TYPE))) as xml) AS 'ORG/CARD/FIELDS' --����������������� ���.
	  ,'' AS 'ORG/CARD/FIELDS/SIGNERNAME' --������
	  ,'10106' AS 'ORG/CARD/FIELDS/SDOCTYPE' --? ��������� ����������?
	  ,'' AS 'ORG/CARD/FIELDS/PCTTYPE' -- '-1'
	  ,'����� �������� �����������' AS 'ORG/CARD/FIELDS/AUTHORNAME'
	  --, cast((SELECT CONVERT(varchar(max),(SELECT '' AS 'COMMENT' FOR XML PATH(''), TYPE))) as xml) AS 'ORG/CARD/FIELDS' --����������������� ���.
	  ,'' AS 'ORG/CARD/FIELDS/COMMENT' --

	  ,Convert(varchar, GETDATE(), 104) AS 'ORG/CARD/FIELDS/CRTDATE',
	  

--Org/Document
	  
	  /*����� ���������*/
	  (SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'DATA1' AS '@NAME',--DATA1 -  ���� ����� ������� ��������������.
		 Convert(varchar, @EDate, 104) AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

	  (SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'DATA_BEG' AS '@NAME',--DATA_BEG -  ���� ������ ������� ��������������.
		 Convert(varchar, @BDate, 104) AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

	  (SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'DATA_DOG' AS '@NAME',--DATA_DOG -  "������� ��".
		 '��' AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

	  (SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'DATA_END' AS '@NAME',--DATA_END -  ���� ����� ������� ��������������.
		 Convert(varchar, @EDate, 104) AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

	  (SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'DOCDATE' AS '@NAME',--DOCDATE -  ���� ����� ������� �������������� (???).
		 Convert(varchar, @EDate, 104) AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

	  (SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'DOCSUM' AS '@NAME',--DOCSUM -  ������ ��������.
		 CAST((SELECT ECSaldo FROM #db_Doc) AS decimal(12,2)) * -1 AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

	  	  (SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'DOG_DATE' AS '@NAME',--DOG_DATE -  ���� �������� ��������.
		 Convert(varchar, (SELECT m.DocDate FROM at_z_Contracts m WHERE m.CompID = @CompID AND m.[Status] = 1), 104) AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',
	  
		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'DOG_NUM' AS '@NAME',--DOG_NUM -  � �������� ��������.
		 Convert(varchar, (SELECT m.ContrID FROM at_z_Contracts m WHERE m.CompID = @CompID AND m.[Status] = 1), 104) AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'FIRM_ADR' AS '@NAME',--FIRM_ADR -  ����������� ����� ����� (����).
		 (SELECT City FROM r_Ours where OurID = @OurID) + ', ' + (SELECT [Address] FROM r_Ours where OurID = @OurID) + ', ' + (SELECT PostIndex FROM r_Ours where OurID = @OurID) AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'FIRM_ADR_FIZ' AS '@NAME',--FIRM_ADR_FIZ -  ����������� ����� ����� (����).
		 (SELECT City FROM r_Ours where OurID = @OurID) + ', ' + (SELECT [Address] FROM r_Ours where OurID = @OurID) + ', ' + (SELECT PostIndex FROM r_Ours where OurID = @OurID) AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'FIRM_BUH' AS '@NAME',--FIRM_BUH -  ��� ������� ���������.
		 'ͳ���� ˳�� ����������' AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'FIRM_CBANK' AS '@NAME',--FIRM_CBANK -  ��� ������ �����.
/*		 '305749' AS 'VALUE'
		 SELECT * FROM r_ours 
		 SELECT * FROM r_Banks
		 SELECT BankID FROM r_OursCC where OurID = 1 and DefaultAccount = 1
		 SELECT * FROM r_OursCC
		 SELECT * FROM [s-sql-d4].[elit].dbo.z_tables WHERE tableName LIKE '%r_OursCC%' OR tableDesc LIKE '%r_OursCC%'
*/		 (SELECT BankID FROM r_OursCC where OurID = @OurID and DefaultAccount = 1) AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'FIRM_EDRPOU' AS '@NAME',--FIRM_EDRPOU -  ��� ������.
		 (SELECT Code FROM r_ours WHERE OurID = @OurID) AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'FIRM_EMAILORG' AS '@NAME',--FIRM_EMAILORG -  ��� email.
		 '' AS 'VALUE' --37029549@ukr.net
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'FIRM_INN' AS '@NAME',--FIRM_INN -  ��� ���.
		 (SELECT TaxCode FROM r_ours WHERE OurID = @OurID) AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'FIRM_NAME' AS '@NAME',--FIRM_NAME -  ������ �������� ����� �����.
		 (SELECT OurName FROM r_ours WHERE OurID = @OurID) AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'FIRM_NM' AS '@NAME',--FIRM_NM -  �������� �������� ����� �����.
		 (SELECT Note1 FROM r_ours WHERE OurID = @OurID) AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'FIRM_NMBANK' AS '@NAME',--FIRM_NMBANK -  ��� ����.
		 (SELECT BankName FROM r_Banks where BankID = (SELECT BankID FROM r_OursCC where OurID = @OurID and DefaultAccount = 1)) AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'FIRM_RS' AS '@NAME',--FIRM_RS - ��� ��������� ����.
		 (SELECT AccountCC FROM r_OursCC where OurID = 1 and DefaultAccount = 1) AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'FIRM_RUK' AS '@NAME',--FIRM_RUK - ��� ������������.
		 '������ ������ �����������' AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'FIRM_RUKPOS' AS '@NAME',--FIRM_RUKPOS - ��������� ������������.
		 '��������' AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'FIRM_TELEFON' AS '@NAME',--FIRM_TELEFON - ��� ������� (�����������).
		 (SELECT Phone FROM r_Ours where OurID = @OurID) AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'FIRM_TEL_FIZ' AS '@NAME',--FIRM_TEL_FIZ - ��� ������� ����������� �����, �����.
		 (SELECT Phone FROM r_Ours where OurID = @OurID) AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'MISZE_SKL' AS '@NAME',--MISZE_SKL - ����� ����������� ����.
		 '�����' AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',
	  
		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'NA_KORIST' AS '@NAME',--NA_KORIST - �������� �����������.
		 (SELECT CompName FROM r_comps where CompID = @CompID) AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'NUM_DOG' AS '@NAME',--NUM_DOG - � ��������.
		 '�' AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'OB_DT_ORG' AS '@NAME',--OB_DT_ORG - ������...???.
		 '0' AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT'
	  
	  ,

		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'OB_KT_ORG' AS '@NAME',--OB_KT_ORG - ������� �� ������ (������).
		 CAST((SELECT SUM(CSumCC) FROM #db_DocD) AS decimal(12,2)) AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'ROUTE' AS '@NAME',--ROUTE - �������?? ������ 2??.
		 '2' AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'SIDE_ADDR_BUILDNUM' AS '@NAME',--SIDE_ADDR_BUILDNUM - � ���� �����������??.
		 (SELECT [Address] FROM r_comps where CompID = @CompID) AS 'VALUE' --� ������� ���� '3�', �� ��� �������� ����� ����?? - ���������� ���� ���.
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',
	  
		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'SIDE_ADDR_COUNTRY' AS '@NAME',--SIDE_ADDR_COUNTRY - ������ ���������� �����������.
		 '�������' AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'SIDE_ADDR_LOCALITY' AS '@NAME',--SIDE_ADDR_LOCALITY - ����� ���������� �����������.
		 (SELECT City FROM r_comps where compid = @CompID) AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'SIDE_ADDR_STREET' AS '@NAME',--SIDE_ADDR_STREET - ����� ���������� �����������.
		 (SELECT [Address] FROM r_comps where compid = @CompID) AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'SIDE_ADDR_ZIP' AS '@NAME',--SIDE_ADDR_ZIP - �������� ������.
		 (SELECT PostIndex FROM r_comps where compid = (SELECT CompID FROM #db_Doc))  AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'SIDE_CDADR_K' AS '@NAME',--SIDE_CDADR_K - ����� �����������.
		 (SELECT [Address] FROM r_comps where compid = (SELECT CompID FROM #db_Doc))  AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'SIDE_CDINDTAXNUM_K' AS '@NAME',--SIDE_CDINDTAXNUM_K - ��� �����������.
		 (SELECT TaxCode FROM r_comps where compid = (SELECT CompID FROM #db_Doc))  AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'SIDE_CD_K' AS '@NAME',--SIDE_CD_K - �������� �����������.
		 (SELECT CompName FROM r_comps where compid = (SELECT CompID FROM #db_Doc))  AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'SIDE_EDRPOU_K' AS '@NAME',--SIDE_EDRPOU_K - ������ �����������.
		 (SELECT Code FROM r_comps where compid = (SELECT CompID FROM #db_Doc))  AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'SIDE_EMAILORG_K' AS '@NAME',--SIDE_EMAILORG_K - email �����������.
		 (SELECT EMail FROM r_comps where CompID = 71297) AS 'VALUE' --'fudkom@mastergood.kiev.ua'
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'SIDE_SHORTNAME_K' AS '@NAME',--SIDE_SHORTNAME_K - �������� �������� �����������.
		 (SELECT CompShort FROM r_comps where compid = (SELECT CompID FROM #db_Doc))  AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'SK_DT_ORG' AS '@NAME',--SK_DT_ORG - ������ �������� (�����).
		 CAST((SELECT ECSaldo FROM #db_Doc) AS decimal(12,2)) * -1 AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'SND_ORG' AS '@NAME',--SND_ORG - ������ ��������� (�����).
		 CAST((SELECT BDSaldo FROM #db_Doc) AS decimal(12,2)) AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'TAXSYSTEM' AS '@NAME',--TAXSYSTEM - ��� ������� ���������������.
		 '��������' AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'TEXT_FIRM_E_D' AS '@NAME',--TEXT_FIRM_E_D - ����� �����.
		 '������' AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'TEXT_SIDE_E_D' AS '@NAME',--TEXT_SIDE_E_D - ����� �����.
		 '��� �� ������' AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'VERSION' AS '@NAME',--VERSION - ������ ����??.
		 '' AS 'VALUE' --1
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'VO_CODE' AS '@NAME',--VO_CODE - ??.
		 '22' AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'VO_FIRSTNAME' AS '@NAME',--VO_FIRSTNAME - ��� ������������.
		 '������' AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'VO_IDORG' AS '@NAME',--VO_IDORG - ???.
		 '' AS 'VALUE' --781
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'VO_LASTNAME' AS '@NAME',--VO_LASTNAME - ������� ������������.
		 '������' AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'VO_MIDDLENAME' AS '@NAME',--VO_MIDDLENAME - �������� ������������.
		 '�����������' AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'VO_NAME' AS '@NAME',--VO_NAME - ������� ��� ������������.
		 '������ �. �.' AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'VO_PIB' AS '@NAME',--VO_PIB - ������(?) ��� ������������.
		 '������ �. �.' AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

		(SELECT 
		 '0' AS '@LINE',
		 '0' AS '@TAB',
		 'ZA_DOGOVOROM' AS '@NAME',--ZA_DOGOVOROM - ����� �����.
		 '�� ���������' AS 'VALUE' 
		 FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',



	  /*���� �������*/
	  --Line? ����??
	  (
	  SELECT * FROM (
	  SELECT 
		 Num AS '@LINE',
		 '1' AS '@TAB', --@TAB = 1 (������?)
		 'TAB1_DATA_ORG' AS '@NAME',--TAB1_DATA_ORG -  ���� ���������.
		 Convert(varchar, DocDate, 104) + ' ' + Convert(varchar, DocDate, 108) AS 'VALUE' 
		FROM #db_DocD 
		union all
		SELECT 
		 Num AS '@LINE',
		 '1' AS '@TAB',
		 'TAB1_DOC_ORG' AS '@NAME',--TAB1_DOC_ORG -  ��� ���������.
		 '����������' AS 'VALUE' 
		FROM #db_DocD
		union all
		SELECT 
		 Num AS '@LINE',
		 '1' AS '@TAB',
		 'TAB1_KT_ORG' AS '@NAME',--TAB1_KT_ORG -  ����� ��������.
		  cast(CAST (CSumCC AS NUMERIC(21,2)) as varchar(13)) AS 'VALUE' 
		FROM #db_DocD) s1 order by 1,2,3
		FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',

	 -- (SELECT 
		-- Num AS '@LINE',
		-- '1' AS '@TAB',
		-- 'TAB1_DOC_ORG' AS '@NAME',--TAB1_DOC_ORG -  ��� ���������.
		-- '����������' AS 'VALUE' 
		--FROM #db_DocD FOR XML PATH ('ROW'), TYPE
	 -- ) AS 'ORG/CARD/DOCUMENT',

	 -- 	  (
	 --SELECT 
		-- Num AS '@LINE',
		-- '1' AS '@TAB',
		-- 'TAB1_KT_ORG' AS '@NAME',--TAB1_KT_ORG -  ����� ��������.
		--  CAST (CSumCC AS decimal(12,2)) AS 'VALUE' 
		--FROM #db_DocD FOR XML PATH ('ROW'), TYPE
	 -- ) AS 'ORG/CARD/DOCUMENT',

		 --ROW_NUMBER() OVER(ORDER BY DocDate) AS '@LINE',



/*-----�������� ������� �1

SELECT * FROM #db_DocD

	  (SELECT 
		 ROW_NUMBER() OVER(ORDER BY DocDate) - 1 AS '@LINE'
		 ,'1' AS '@TAB' --@TAB = 1
		 ,'TAB1_DATA_ORG' AS '@NAME'--TAB1_DATA_ORG -  ���� ���������.
		 ,Convert(varchar, DocDate, 104) + ' ' + Convert(varchar, DocDate, 108) AS 'VALUE'
		 FROM #db_DocD 
		 FOR XML PATH ('ROW'), TYPE
		  
		-- ,'TAB1_DOC_ORG' AS 'NAME'--TAB1_DOC_ORG -  ��� ���������.
		-- ,'����������' AS 'VALUE' 
		-- ,'TAB1_KT_ORG' AS 'NAME'--TAB1_KT_ORG -  ����� ��������.
		-- ,CAST (CSumCC AS decimal(12,2)) AS 'VALUE' 

		--FOR XML PATH ('ROW'), TYPE
	  ) AS 'ORG/CARD/DOCUMENT',
*/

--Ord/Card
	  cast((SELECT CONVERT(varchar(max),(SELECT '' AS 'DOCKVT' FOR XML PATH(''), TYPE))) as xml) AS 'ORG/CARD' --����������������� ���.

	  --FROM r_Comps
	  FOR XML PATH ('ZVIT'), TYPE --���������� �������������� XML ������ � ����� XML, � ���� �������� TYPE �� ������, ������ ������������ � ����� NVARCHAR(MAX). �������� ��������� � ��� �������, ����� ��� ��������� XML ������� ����� ����������� ��������, ����������� ��� XML ������, ��������, ���������� ���������� �� ����� XQuery;
)
END

--select @xml




--SET @xml.modify('
--insert <?xml-stylesheet type="text/xsl" href="stylesheet.xsl"?>
--before /*[1]
--')

--SET @xml.modify('
--insert <?xml version=\"1.0\" encoding=\"windows-1251\"?>
--before /*[1]
--')



--SELECT @xml


--��������� ������ � 
  /* ���������� ���������� ���������� */

  DECLARE @Path VARCHAR(512) = 'E:\OT38ElitServer\Import\Medoc_akt\'
  DECLARE @tmp VARCHAR(512), @FName VARCHAR(256) = 'akt_sverki' 
  DECLARE @Filter VARCHAR(250)
  DECLARE @Res INT
  DECLARE @Date SMALLDATETIME = GETDATE()
  DECLARE @Ch TABLE(ChID INT NOT NULL PRIMARY KEY)
  
  DECLARE @xmlDocument VARCHAR(MAX)
  --DECLARE @xmlDocument xml

  --select @xmlDocument = '<?xml version="1.0" encoding="windows-1251"?>' +  CHAR(13) + CHAR(10) + cast(@xml as varchar(max))
  select @xmlDocument = cast(@xml as varchar(max))
  --select @xmlDocument = @xml

  select cast(@xmlDocument as xml) 'cast'

--select Chid, FileName, N'<?xml version=`"1.0`" encoding=`"WINDOWS-1251`"?>' + cast(FileData as nvarchar(max)), cast(isnull(x.XmlCol.exist('true()'),0) as int) xml_check from dbo.at_z_FilesExchange as h OUTER APPLY h.FileData.nodes('/DECLAR/DECLARBODY') x(XmlCol) where StateCode = 403 and FileName like '%J1201010%.xml';

    IF OBJECT_ID('tempdb.[' + CURRENT_USER + '].##xml') IS NOT NULL
      DROP TABLE ##xml 
    
    SELECT @xmlDocument FileData INTO ##xml
    
    /* ��������� ������� ����� ����� (���� + ���) */
    SET @tmp = @Path + @FName + '.xml'

    SET @tmp = 'bcp "SELECT ''<?xml version=\"1.0\" encoding=\"windows-1251\"?>'' + CHAR(13) + CHAR(10) + FileData FROM tempdb.[' + CURRENT_USER + '].##xml" queryout "' + @tmp + '" -c -C RAW -T -Slocalhost'
    
    /* �������� xml ����� �� ���� */
    EXEC @Res = xp_cmdshell @tmp, NO_OUTPUT
    
    SET @tmp = 'DEL /F /Q "' + @Path + @FName + '.xml"'
    
    IF NOT EXISTS(SELECT * FROM ##xml)
      EXEC @Res = xp_cmdshell @tmp, NO_OUTPUT



/*
-------------------------DRAFT--------------------------------------------------
-------------------------DRAFT--------------------------------------------------
-------------------------DRAFT--------------------------------------------------

SELECT
	TOP 3 
	1 AS 'TAG', --1: ���� ������� ��������
	NULL AS 'PARENT', 
	CompName AS [r_comps!1!CompName!ELEMENT], --ELEMENT: ��� ����� ���������, ID - ���������.
	CompID AS [r_comps!1!CompID!ID],
	City AS [r_comps!1!City!ELEMENT]
FROM r_comps
--FOR XML RAW ('Product'), TYPE, /*ELEMENTS,*/ ROOT ('PRODUCTS')
FOR XML EXPLICIT, TYPE, ROOT ('PRODUCTS')

----------------
SELECT
	TOP 4 
	CompName AS "@Line",
	CompID,
	City,
	getdate() AS 'ROW/VALUE'
FROM r_comps
FOR XML PATH ('Row'), TYPE


<ROW LINE="0" TAB="0" NAME="DATA1">
    <VALUE>12.04.2019 00:00:00</VALUE>
</ROW>


SELECT TOP 3
	CompID AS "row/@Line",
	City AS "row/@TAB",
	CompName AS "row/@NAME",
	getdate() AS 'VALUE'
FROM r_Comps
FOR XML PATH, TYPE
*/



/*TEST*/
/*--������ ����������������� ���
begin

DECLARE @TempData Table
(
Column1 NVARCHAR(250)
)
INSERT INTO @TempData values('3')
INSERT INTO @TempData values('')
SELECT * FROM @tEMPDATA
SELECT * FROM @TempData FOR XML PATH('Test'), Type

SELECT (SELECT * FROM @TempData FOR XML PATH('Test'), Type) For XML PATH ('')

end;

SELECT '1' AS [Column1]
UNION
SELECT '2' AS [Column2]
UNION
SELECT '3' AS [Column3]
FOR XML PATH('Test'), ROOT('Rows')

SELECT CONVERT(varchar(max),(SELECT '' AS 'TAG/tag' FOR XML PATH('WOW'), TYPE));
SELECT CONVERT(varchar(max), (SELECT '' AS 'TAG/tag' FOR XML PATH('WOW'), TYPE));
*/

