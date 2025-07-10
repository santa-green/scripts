--������ �� ��������� ������ 6_3 �� 14.11.2018 11:30
DECLARE	-- ������� ���������
		 @StockID VARCHAR(MAX) = '23,323' -- ������ �� ������� �������� �����
		,@StockID_ALL VARCHAR(MAX) = '4,304,11,311,27,327,85,385,23,323,220,320' -- ��� ������ �� ������� �������� ������
		,@PCatID VARCHAR(MAX) = '1-100' --��� ��������� 
		,@PGrID1 VARCHAR(MAX) = '0,8,10-15,17,19,30-31,33-35,38-41,44,45,47-51,53-62,64-68,70-75,77-80,83-88,90,91,93,95-105,106-200' --��� ������ 1
		,@ProdID VARCHAR(MAX) = '' --��� �������
		,@AllProds int = 1		   -- ���� 1 �� ��� ������, � ���� 0 �� ������ �� ��� �� ������� 220,218
		,@Months INT = 2

/*
1-7,9,16,76,92,94,32
0,8,10-15,17,19,30-31,33-35,38-41,44,45,47-51,53-62,64-68,70-75,77-80,83-88,90,91,93,95-105,106-200

*/		
/*
� ������ 6_2 �� ��������� �������, � ������� [������� 220],[������� 218] ����� ����.
� ������ 6_3 ��������� ����������  AND m.CompID <> 79
*/

SET DATEFIRST 1 --���������� ������ ���� ������ �����������
DECLARE  @WeekID INT = DATEPART(week, GETDATE()) -- ���� ������
		,@BeginDate DATE --���� ������ �������, �� @month ������ ������ �������
		,@EndDate DATE --���� ����� �������

IF 1=1 --#Month2
BEGIN
SET @BeginDate = DATEADD(day , -@Months*28, dbo.zf_GetDate( GETDATE() ))
SET @EndDate = DATEADD(day, (-@Months+1)*28, dbo.zf_GetDate( GETDATE() ))

IF OBJECT_ID (N'tempdb..#Month2', N'U') IS NOT NULL DROP TABLE #Month2

/*���� �������*/
;WITH 
	 Rem218_CTE AS( SELECT ProdID, SUM(Qty - AccQty) SumQty_AccQty , SUM(AccQty) SumAccQty FROM t_rem m WITH(NOLOCK) WHERE  StockID = 218 GROUP BY ProdID )
	,Rem220_CTE AS( SELECT ProdID, SUM(Qty - AccQty) SumQty_AccQty , SUM(AccQty) SumAccQty FROM t_rem m WITH(NOLOCK) WHERE  StockID = 220 GROUP BY ProdID )
	,Rem_CTE AS( SELECT ProdID, SUM(Qty) SumQty FROM t_rem m WITH(NOLOCK) WHERE  StockID in ( select AValue from zf_FilterToTable(@StockID) ) GROUP BY ProdID )
	
	--������� ������ �� ����������
	,gr_t_Ret_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Ret m WITH(NOLOCK)
					JOIN t_RetD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( select AValue from zf_FilterToTable(@StockID) )	and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	--��������� ���������
	,gr_t_Inv_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Inv m WITH(NOLOCK)
					JOIN t_InvD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( select AValue from zf_FilterToTable(@StockID) ) and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	--��������� ��������
	,gr_t_Exp_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Exp m WITH(NOLOCK)
					JOIN t_ExpD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( select AValue from zf_FilterToTable(@StockID) ) and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	--��������� �������� � ����� �������
	,gr_t_Epp_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Epp m WITH(NOLOCK)
					JOIN t_EppD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( select AValue from zf_FilterToTable(@StockID) ) and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
					

	,gr_t_Ret220320_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Ret m WITH(NOLOCK)
					JOIN t_RetD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( 220,320 )	and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	,gr_t_Inv220320_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Inv m WITH(NOLOCK)
					JOIN t_InvD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( 220,320 ) and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	,gr_t_Exp220320_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Exp m WITH(NOLOCK)
					JOIN t_ExpD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( 220,320 ) and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	,gr_t_Epp220320_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Epp m WITH(NOLOCK)
					JOIN t_EppD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( 220,320 ) and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
--����
	,gr_t_Ret220320_seti_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Ret m WITH(NOLOCK)
					JOIN t_RetD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( 220,320 )	and m.CodeID1 <> 100 
					and exists(SELECT top 1 1 FROM r_Comps c where c.CompID = m.CompID and  c.CompGrID2 in (2098))
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	,gr_t_Inv220320_seti_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Inv m WITH(NOLOCK)
					JOIN t_InvD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( 220,320 ) and m.CodeID1 <> 100 
					and exists(SELECT top 1 1 FROM r_Comps c where c.CompID = m.CompID and  c.CompGrID2 in (2098))
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	,gr_t_Exp220320_seti_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Exp m WITH(NOLOCK)
					JOIN t_ExpD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( 220,320 ) and m.CodeID1 <> 100 
					and exists(SELECT top 1 1 FROM r_Comps c where c.CompID = m.CompID and  c.CompGrID2 in (2098))
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	,gr_t_Epp220320_seti_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Epp m WITH(NOLOCK)
					JOIN t_EppD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( 220,320 ) and m.CodeID1 <> 100 
					and exists(SELECT top 1 1 FROM r_Comps c where c.CompID = m.CompID and  c.CompGrID2 in (2098))
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
--������ �����
	,gr_t_Ret_CTE_global AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Ret m WITH(NOLOCK)
					JOIN t_RetD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( select AValue from zf_FilterToTable(@StockID_ALL) )	and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	,gr_t_Inv_CTE_global AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Inv m WITH(NOLOCK)
					JOIN t_InvD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( select AValue from zf_FilterToTable(@StockID_ALL) ) and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	,gr_t_Exp_CTE_global AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Exp m WITH(NOLOCK)
					JOIN t_ExpD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( select AValue from zf_FilterToTable(@StockID_ALL) ) and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	,gr_t_Epp_CTE_global AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Epp m WITH(NOLOCK)
					JOIN t_EppD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( select AValue from zf_FilterToTable(@StockID_ALL) ) and m.CodeID1 <> 100 
					AND m.CompID <> 79
					GROUP BY d.ProdID
					)

SELECT ProdID, �������_��_��_��, PGrAID, PCatID, PCatName, ProdName, PGrID1, PGrName1, ���_�_�����, SumQty_t_Ret, SumQty_t_Inv, SumQty_t_Exp, SumQty_t_Epp, �������, �������218_��, �������220_��, ������_��_��, ������218, ������220,������,������220320, ������220320_seti,kof, ������_�����
 INTO #Month2	
FROM (
--������� ������� �� ������������ (220,218) ������ � �������� ���������
			SELECT gr.ProdID,  ISNULL(gr.SumQty_AccQty,0) '�������_��_��_��', p.PGrAID, p.PCatID, r_ProdC.PCatName, p.ProdName, p.PGrID1, r_ProdG1.PGrName1 , isnull(mq.Qty,1) '���_�_�����',
			gr_t_Ret.SumQty SumQty_t_Ret,gr_t_Inv.SumQty SumQty_t_Inv ,gr_t_Exp.SumQty SumQty_t_Exp,gr_t_Epp.SumQty SumQty_t_Epp, 
			ISNULL(gr_t_Rem.SumQty,0) '�������' , gr_t_Rem218.SumQty_AccQty '�������218_��' , gr_t_Rem220.SumQty_AccQty '�������220_��',
			gr.SumAccQty '������_��_��' , gr_t_Rem218.SumAccQty '������218' , gr_t_Rem220.SumAccQty '������220'
			, (ISNULL(gr_t_Inv.SumQty,0) + ISNULL(gr_t_Exp.SumQty,0)  + ISNULL(gr_t_Epp.SumQty,0) - ISNULL(gr_t_Ret.SumQty,0))  '������'
			, (ISNULL(gr_t_Inv220320.SumQty,0) + ISNULL(gr_t_Exp220320.SumQty,0)  + ISNULL(gr_t_Epp220320.SumQty,0) - ISNULL(gr_t_Ret220320.SumQty,0))  '������220320'
			, (ISNULL(gr_t_Inv220320_seti.SumQty,0) + ISNULL(gr_t_Exp220320_seti.SumQty,0)  + ISNULL(gr_t_Epp220320_seti.SumQty,0) - ISNULL(gr_t_Ret220320_seti.SumQty,0))  '������220320_seti'
			,dbo.af_GetPercentsForPCatIDImport(p.PCatID,@WeekID) kof
			, (ISNULL(gr_t_Inv_global.SumQty,0) + ISNULL(gr_t_Exp_global.SumQty,0)  + ISNULL(gr_t_Epp_global.SumQty,0) - ISNULL(gr_t_Ret_global.SumQty,0)) '������_�����'
			FROM (
				SELECT ProdID,  SUM(Qty - AccQty) SumQty_AccQty , SUM(AccQty) SumAccQty FROM t_rem m WITH(NOLOCK)
				WHERE  StockID in (220,218) or @AllProds = 1
				GROUP BY ProdID
				) gr 
			JOIN r_Prods p WITH(NOLOCK) ON p.ProdID = gr.ProdID
			JOIN r_ProdG1  WITH(NOLOCK) ON r_ProdG1.PGrID1 = p.PGrID1
			JOIN r_ProdC  WITH(NOLOCK) ON r_ProdC.PCatID = p.PCatID
			LEFT JOIN gr_t_Ret_CTE gr_t_Ret ON gr_t_Ret.ProdID = p.ProdID
			LEFT JOIN gr_t_Inv_CTE gr_t_Inv ON gr_t_Inv.ProdID = p.ProdID
			LEFT JOIN gr_t_Exp_CTE gr_t_Exp ON gr_t_Exp.ProdID = p.ProdID
			LEFT JOIN gr_t_Epp_CTE gr_t_Epp ON gr_t_Epp.ProdID = p.ProdID
			LEFT JOIN Rem_CTE gr_t_Rem ON gr_t_Rem.ProdID = p.ProdID
			LEFT JOIN Rem218_CTE gr_t_Rem218 ON gr_t_Rem218.ProdID = p.ProdID
			LEFT JOIN Rem220_CTE gr_t_Rem220 ON gr_t_Rem220.ProdID = p.ProdID
			LEFT JOIN r_ProdMQ mq ON mq.ProdID = p.ProdID and mq.UM = '��.'
			LEFT JOIN gr_t_Ret220320_CTE gr_t_Ret220320 ON gr_t_Ret220320.ProdID = p.ProdID
			LEFT JOIN gr_t_Inv220320_CTE gr_t_Inv220320 ON gr_t_Inv220320.ProdID = p.ProdID
			LEFT JOIN gr_t_Exp220320_CTE gr_t_Exp220320 ON gr_t_Exp220320.ProdID = p.ProdID
			LEFT JOIN gr_t_Epp220320_CTE gr_t_Epp220320 ON gr_t_Epp220320.ProdID = p.ProdID
			LEFT JOIN gr_t_Ret220320_seti_CTE gr_t_Ret220320_seti ON gr_t_Ret220320_seti.ProdID = p.ProdID
			LEFT JOIN gr_t_Inv220320_seti_CTE gr_t_Inv220320_seti ON gr_t_Inv220320_seti.ProdID = p.ProdID
			LEFT JOIN gr_t_Exp220320_seti_CTE gr_t_Exp220320_seti ON gr_t_Exp220320_seti.ProdID = p.ProdID
			LEFT JOIN gr_t_Epp220320_seti_CTE gr_t_Epp220320_seti ON gr_t_Epp220320_seti.ProdID = p.ProdID
			LEFT JOIN gr_t_Ret_CTE_global gr_t_Ret_global ON gr_t_Ret_global.ProdID = p.ProdID
			LEFT JOIN gr_t_Inv_CTE_global gr_t_Inv_global ON gr_t_Inv_global.ProdID = p.ProdID
			LEFT JOIN gr_t_Exp_CTE_global gr_t_Exp_global ON gr_t_Exp_global.ProdID = p.ProdID
			LEFT JOIN gr_t_Epp_CTE_global gr_t_Epp_global ON gr_t_Epp_global.ProdID = p.ProdID

			WHERE ((0 = case when @PCatID is null then 0 when @PCatID = '' then 0 else 1 end ) OR ( (SELECT [dbo].[zf_MatchFilterInt](p.PCatID,@PCatID,',')) = 1 and 1 = case when @PCatID is null then 0 when @PCatID = '' then 0 else 1 end ))
			  AND ((0 = case when @PGrID1 is null then 0 when @PGrID1 = '' then 0 else 1 end ) OR ( (SELECT [dbo].[zf_MatchFilterInt](p.PGrID1,@PGrID1,',')) = 1 and 1 = case when @PGrID1 is null then 0 when @PGrID1 = '' then 0 else 1 end ))
			  AND ((0 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ) OR ( (SELECT [dbo].[zf_MatchFilterInt](p.ProdID,@ProdID,',')) = 1 and 1 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ))
			  AND (gr.SumQty_AccQty > 0 or @AllProds = 1)
)big
END -- #Month2

IF 1=1 --#Month1
BEGIN
SET @Months = @Months - 1;
SET @BeginDate = DATEADD(day , -@Months*28, dbo.zf_GetDate( GETDATE() ))
SET @EndDate = DATEADD(day, (-@Months+1)*28, dbo.zf_GetDate( GETDATE() ))

IF OBJECT_ID (N'tempdb..#Month1', N'U') IS NOT NULL DROP TABLE #Month1

/*���� �������*/
;WITH 
	 Rem218_CTE AS( SELECT ProdID, SUM(Qty - AccQty) SumQty_AccQty , SUM(AccQty) SumAccQty FROM t_rem m WITH(NOLOCK) WHERE  StockID = 218 GROUP BY ProdID )
	,Rem220_CTE AS( SELECT ProdID, SUM(Qty - AccQty) SumQty_AccQty , SUM(AccQty) SumAccQty FROM t_rem m WITH(NOLOCK) WHERE  StockID = 220 GROUP BY ProdID )
	,Rem_CTE AS( SELECT ProdID, SUM(Qty) SumQty FROM t_rem m WITH(NOLOCK) WHERE  StockID in ( select AValue from zf_FilterToTable(@StockID) ) GROUP BY ProdID )
	
	,gr_t_Ret_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Ret m WITH(NOLOCK)
					JOIN t_RetD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( select AValue from zf_FilterToTable(@StockID) )	and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	,gr_t_Inv_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Inv m WITH(NOLOCK)
					JOIN t_InvD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( select AValue from zf_FilterToTable(@StockID) ) and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	,gr_t_Exp_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Exp m WITH(NOLOCK)
					JOIN t_ExpD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( select AValue from zf_FilterToTable(@StockID) ) and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	,gr_t_Epp_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Epp m WITH(NOLOCK)
					JOIN t_EppD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( select AValue from zf_FilterToTable(@StockID) ) and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
					

	,gr_t_Ret220320_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Ret m WITH(NOLOCK)
					JOIN t_RetD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( 220,320 )	and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	,gr_t_Inv220320_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Inv m WITH(NOLOCK)
					JOIN t_InvD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( 220,320 ) and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	,gr_t_Exp220320_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Exp m WITH(NOLOCK)
					JOIN t_ExpD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( 220,320 ) and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	,gr_t_Epp220320_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Epp m WITH(NOLOCK)
					JOIN t_EppD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( 220,320 ) and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
--����
	,gr_t_Ret220320_seti_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Ret m WITH(NOLOCK)
					JOIN t_RetD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( 220,320 )	and m.CodeID1 <> 100 
					and exists(SELECT top 1 1 FROM r_Comps c where c.CompID = m.CompID and  c.CompGrID2 in (2098))
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	,gr_t_Inv220320_seti_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Inv m WITH(NOLOCK)
					JOIN t_InvD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( 220,320 ) and m.CodeID1 <> 100 
					and exists(SELECT top 1 1 FROM r_Comps c where c.CompID = m.CompID and  c.CompGrID2 in (2098))
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	,gr_t_Exp220320_seti_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Exp m WITH(NOLOCK)
					JOIN t_ExpD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( 220,320 ) and m.CodeID1 <> 100 
					and exists(SELECT top 1 1 FROM r_Comps c where c.CompID = m.CompID and  c.CompGrID2 in (2098))
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	,gr_t_Epp220320_seti_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Epp m WITH(NOLOCK)
					JOIN t_EppD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( 220,320 ) and m.CodeID1 <> 100 
					and exists(SELECT top 1 1 FROM r_Comps c where c.CompID = m.CompID and  c.CompGrID2 in (2098))
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
--������ �����
	,gr_t_Ret_CTE_global AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Ret m WITH(NOLOCK)
					JOIN t_RetD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( select AValue from zf_FilterToTable(@StockID_ALL) )	and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	,gr_t_Inv_CTE_global AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Inv m WITH(NOLOCK)
					JOIN t_InvD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( select AValue from zf_FilterToTable(@StockID_ALL) ) and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	,gr_t_Exp_CTE_global AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Exp m WITH(NOLOCK)
					JOIN t_ExpD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( select AValue from zf_FilterToTable(@StockID_ALL) ) and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)
	,gr_t_Epp_CTE_global AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Epp m WITH(NOLOCK)
					JOIN t_EppD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( select AValue from zf_FilterToTable(@StockID_ALL) ) and m.CodeID1 <> 100 
					AND m.CompID <> 79 
					GROUP BY d.ProdID
					)

SELECT ProdID, �������_��_��_��, PGrAID, PCatID, PCatName, ProdName, PGrID1, PGrName1, ���_�_�����, SumQty_t_Ret, SumQty_t_Inv, SumQty_t_Exp, SumQty_t_Epp, �������, �������218_��, �������220_��, ������_��_��, ������218, ������220,������,������220320, ������220320_seti,kof, ������_�����
 INTO #Month1	
FROM (
--������� ������� �� ������������ (220,218) ������ � �������� ���������
			SELECT gr.ProdID,  ISNULL(gr.SumQty_AccQty,0) '�������_��_��_��',p.PGrAID, p.PCatID, r_ProdC.PCatName, p.ProdName, p.PGrID1, r_ProdG1.PGrName1 , isnull(mq.Qty,1) '���_�_�����',
			gr_t_Ret.SumQty SumQty_t_Ret,gr_t_Inv.SumQty SumQty_t_Inv ,gr_t_Exp.SumQty SumQty_t_Exp,gr_t_Epp.SumQty SumQty_t_Epp, 
			ISNULL(gr_t_Rem.SumQty,0) '�������' , gr_t_Rem218.SumQty_AccQty '�������218_��' , gr_t_Rem220.SumQty_AccQty '�������220_��',
			gr.SumAccQty '������_��_��' , gr_t_Rem218.SumAccQty '������218' , gr_t_Rem220.SumAccQty '������220'
			, (ISNULL(gr_t_Inv.SumQty,0) + ISNULL(gr_t_Exp.SumQty,0)  + ISNULL(gr_t_Epp.SumQty,0) - ISNULL(gr_t_Ret.SumQty,0))  '������'
			, (ISNULL(gr_t_Inv220320.SumQty,0) + ISNULL(gr_t_Exp220320.SumQty,0)  + ISNULL(gr_t_Epp220320.SumQty,0) - ISNULL(gr_t_Ret220320.SumQty,0))  '������220320'
			, (ISNULL(gr_t_Inv220320_seti.SumQty,0) + ISNULL(gr_t_Exp220320_seti.SumQty,0)  + ISNULL(gr_t_Epp220320_seti.SumQty,0) - ISNULL(gr_t_Ret220320_seti.SumQty,0))  '������220320_seti'
			,dbo.af_GetPercentsForPCatIDImport(p.PCatID,@WeekID) kof
			, (ISNULL(gr_t_Inv_global.SumQty,0) + ISNULL(gr_t_Exp_global.SumQty,0)  + ISNULL(gr_t_Epp_global.SumQty,0) - ISNULL(gr_t_Ret_global.SumQty,0)) '������_�����'
			FROM (
				SELECT ProdID,  SUM(Qty - AccQty) SumQty_AccQty , SUM(AccQty) SumAccQty FROM t_rem m WITH(NOLOCK)
				WHERE  StockID in (220,218) or @AllProds = 1
				GROUP BY ProdID
				) gr 
			JOIN r_Prods p WITH(NOLOCK) ON p.ProdID = gr.ProdID
			JOIN r_ProdG1  WITH(NOLOCK) ON r_ProdG1.PGrID1 = p.PGrID1
			JOIN r_ProdC   WITH(NOLOCK) ON r_ProdC.PCatID = p.PCatID
			LEFT JOIN gr_t_Ret_CTE gr_t_Ret ON gr_t_Ret.ProdID = p.ProdID
			LEFT JOIN gr_t_Inv_CTE gr_t_Inv ON gr_t_Inv.ProdID = p.ProdID
			LEFT JOIN gr_t_Exp_CTE gr_t_Exp ON gr_t_Exp.ProdID = p.ProdID
			LEFT JOIN gr_t_Epp_CTE gr_t_Epp ON gr_t_Epp.ProdID = p.ProdID
			LEFT JOIN Rem_CTE gr_t_Rem ON gr_t_Rem.ProdID = p.ProdID
			LEFT JOIN Rem218_CTE gr_t_Rem218 ON gr_t_Rem218.ProdID = p.ProdID
			LEFT JOIN Rem220_CTE gr_t_Rem220 ON gr_t_Rem220.ProdID = p.ProdID
			LEFT JOIN r_ProdMQ mq ON mq.ProdID = p.ProdID and mq.UM = '��.'
			LEFT JOIN gr_t_Ret220320_CTE gr_t_Ret220320 ON gr_t_Ret220320.ProdID = p.ProdID
			LEFT JOIN gr_t_Inv220320_CTE gr_t_Inv220320 ON gr_t_Inv220320.ProdID = p.ProdID
			LEFT JOIN gr_t_Exp220320_CTE gr_t_Exp220320 ON gr_t_Exp220320.ProdID = p.ProdID
			LEFT JOIN gr_t_Epp220320_CTE gr_t_Epp220320 ON gr_t_Epp220320.ProdID = p.ProdID
			LEFT JOIN gr_t_Ret220320_seti_CTE gr_t_Ret220320_seti ON gr_t_Ret220320_seti.ProdID = p.ProdID
			LEFT JOIN gr_t_Inv220320_seti_CTE gr_t_Inv220320_seti ON gr_t_Inv220320_seti.ProdID = p.ProdID
			LEFT JOIN gr_t_Exp220320_seti_CTE gr_t_Exp220320_seti ON gr_t_Exp220320_seti.ProdID = p.ProdID
			LEFT JOIN gr_t_Epp220320_seti_CTE gr_t_Epp220320_seti ON gr_t_Epp220320_seti.ProdID = p.ProdID
			LEFT JOIN gr_t_Ret_CTE_global gr_t_Ret_global ON gr_t_Ret_global.ProdID = p.ProdID
			LEFT JOIN gr_t_Inv_CTE_global gr_t_Inv_global ON gr_t_Inv_global.ProdID = p.ProdID
			LEFT JOIN gr_t_Exp_CTE_global gr_t_Exp_global ON gr_t_Exp_global.ProdID = p.ProdID
			LEFT JOIN gr_t_Epp_CTE_global gr_t_Epp_global ON gr_t_Epp_global.ProdID = p.ProdID

			WHERE ((0 = case when @PCatID is null then 0 when @PCatID = '' then 0 else 1 end ) OR ( (SELECT [dbo].[zf_MatchFilterInt](p.PCatID,@PCatID,',')) = 1 and 1 = case when @PCatID is null then 0 when @PCatID = '' then 0 else 1 end ))
			  AND ((0 = case when @PGrID1 is null then 0 when @PGrID1 = '' then 0 else 1 end ) OR ( (SELECT [dbo].[zf_MatchFilterInt](p.PGrID1,@PGrID1,',')) = 1 and 1 = case when @PGrID1 is null then 0 when @PGrID1 = '' then 0 else 1 end ))
			  AND ((0 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ) OR ( (SELECT [dbo].[zf_MatchFilterInt](p.ProdID,@ProdID,',')) = 1 and 1 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ))
			  AND (gr.SumQty_AccQty > 0 or @AllProds = 1)
)big
END -- #Month1


--SELECT ProdID, PCatID, PCatName, ProdName, PGrID1, PGrName1, ���_�_�����, SumQty_t_Ret, SumQty_t_Inv, SumQty_t_Exp, SumQty_t_Epp, �������_��_��_��, ������_��_��, �������220_��, ������220, �������218_��, ������218, �������, ������_m1, ������_m2, ������220320_m1, ������220320_m2, ������220320_seti_m1, ������220320_seti_m2, kof, �������, �������, �����_��_��������, ����_������, �������_�����_��_��������, ����_�����, �������_����_�����, ���_�������_����_�����, �������_��_������� 
SELECT PCatName '���������', PGrName1 '������', PGrAID '��� ������ �����������', ProdID '��� ������', ProdName '������������ ������', ���_�_����� '��� � �����', �������220_�� '������� 220', ������220 '������ ��', �������218_�� '������� 218', �������, ������_m1 '������ ���� �����', ������_m2 '������ ���� �����', ������220320_seti_m1 '������ ���� ���� �����', ������220320_seti_m2 '������ ���� ���� �����', /*������_����_�����, */ROUND (�������,0) '�������',  ROUND (����_������,1) '���� ������', �������_�����_��_�������� '����� �� �������� �� ��', ���_�������_����_����� '���� �����'
FROM (
	SELECT *
	,CASE WHEN �������220_�� < �������_����_����� THEN �������220_�� ELSE /*�������_����_�����*/ CASE WHEN �������_����_�����<0 THEN 0 ELSE �������_����_����� END /*�������, ����� ���������*/ END as '���_�������_����_�����' 
	, (CASE WHEN �������_��_��_�� < �������_����_����� THEN �������_��_��_�� ELSE �������_����_����� END ) / (case when [�������_��_��_��] = 0 then 1 else [�������_��_��_��] end)  as '�������_��_�������'
	FROM (

		SELECT *
		,(isnull((round(�����_��_�������� / ���_�_�����,0) * ���_�_�����),0)) as '�������_�����_��_��������' --'�������_�����_��_��������' = ������(�����_��_��������/���_�_�����;0)*���_�_�����
		,(CASE WHEN (�������_��_��_�� - (isnull((round(�����_��_�������� / ���_�_�����,0) * ���_�_�����),0)) ) > 0 THEN (round(�����_��_�������� / ���_�_�����,0) * ���_�_�����) ELSE �������_��_��_�� END) as '����_�����' --'����_�����' = =����(�������_��_�� - �������_�����_��_�������� >0;�������_�����_��_��������;�������_��_��)
		,(isnull((round( ((CASE WHEN (�������_��_��_�� - (isnull((round(�����_��_�������� / ���_�_�����,0) * ���_�_�����),0)) ) > 0 THEN (round(�����_��_�������� / ���_�_�����,0) * ���_�_�����) ELSE �������_��_��_�� END)) / ���_�_�����,0) * ���_�_�����),0)) as '�������_����_�����' --'�������_����_�����' 
		FROM (
		 
			SELECT m1.ProdID, m1.PGrAID, m1.PCatID, m1.PCatName, m1.ProdName, m1.PGrID1, m1.PGrName1, m1.���_�_�����, m1.SumQty_t_Ret, m1.SumQty_t_Inv, m1.SumQty_t_Exp, m1.SumQty_t_Epp,
			m1.�������_��_��_��, m1.������_��_��, ISNULL(m1.�������220_��,0) �������220_��,ISNULL(m1.������220,0) ������220, ISNULL(m1.�������218_��,0) �������218_��, ISNULL(m1.������218,0) ������218, m1.�������, 
			m1.������ ������_m1, m2.������ ������_m2
			,m1.������220320 ������220320_m1, m2.������220320 ������220320_m2
			,m1.������220320_seti ������220320_seti_m1, m2.������220320_seti ������220320_seti_m2
			, m1.kof	
			,((m1.������ + m2.������) / 8 * m1.kof * 3) as '�������'  --'�������'
			,(isnull((m1.������� - ((m1.������ + m2.������) / 8 * m1.kof * 3) + m1.������220320_seti * 0.9),0)) as '�������'  --  ������� - ������� = �������
			, case when (isnull((m1.������� - ((m1.������ + m2.������) / 8 * m1.kof * 3) /*+ m1.������220320_seti*0.9*/),0)) > 0 then 0 else (isnull((m1.������� - ((m1.������ + m2.������) / 8 * m2.kof * 3) /*+ m1.������220320_seti*0.9*/),0)) * -1 end as '�����_��_��������' --'����� �� ��������' = ����('�������'>0;0;'�������'*-1)
			, CASE WHEN m1.������ = 0 or m1.������_����� = 0 THEN 0 ELSE(isnull(((m1.������/m1.������_�����)*100),0)) END AS '����_������'
			, ((m1.������220320_seti + m2.������220320_seti)/2) AS '������_����_�����'
			FROM #Month1 m1
			LEFT JOIN #Month2 m2 on m2.ProdID = m1.ProdID
			WHERE ISNULL(m1.�������220_��,0) != 0 OR ISNULL(m1.�������218_��,0) != 0
			   ) v1
		) v2
	) v3
--WHERE ProdID in (33537)

--SELECT ������,������_����� FROM #Month1
--WHERE ProdID in (31959)
--WHERE CONVERT(int,v3.�������220_��) in (0) and CONVERT(int,v3.������220) in (0) and CONVERT(int,v3.�������218_��) in (0) and CONVERT(int,v3.���_�������_����_�����) not in (0)
ORDER BY '���������','������','��� ������ �����������','������������ ������'

/*
SELECT PCatIDi, (SELECT top 1 PCatName FROM r_ProdC pc WHERE pc.PCatID = PCatIDi) PCatName 
,[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52],[53]  
FROM at_t_PCatIDImport 
PIVOT ( 
MAX(Percents)FOR WeekID IN([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50],[51],[52],[53]) 
)pvt
ORDER BY 2
*/