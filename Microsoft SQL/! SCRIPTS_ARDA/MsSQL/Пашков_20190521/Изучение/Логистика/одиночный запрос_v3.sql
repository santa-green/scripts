DECLARE	-- ������� ���������
		 @StockID VARCHAR(MAX) = '4,304' -- ������ �� ������� �������� �����
		,@PCatID VARCHAR(MAX) = '1-100' --��� ��������� 
		,@PGrID1 VARCHAR(MAX) = '' --��� ������ 1
		,@ProdID VARCHAR(MAX) = '' --��� �������

-- ����������� ���
SET DATEFIRST 1 --���������� ������ ���� ������ �����������
DECLARE  @WeekID INT = DATEPART(week, GETDATE()) -- ���� ������
		,@BeginDate DATE = DATEADD(MONTH , -2 ,dbo.zf_GetDate( GETDATE() )) --���� ������ �������, �� 2 ������ ������ �������
		,@EndDate DATE = dbo.zf_GetDate( GETDATE() ) --���� ����� �������, ������� ����
		 
--SELECT @BeginDate BeginDate,  @EndDate EndDate, @WeekID WeekID

/*���� �������*/
;WITH 
	 Rem218_CTE AS( SELECT ProdID, SUM(Qty - AccQty) SumQty_AccQty , SUM(AccQty) SumAccQty FROM t_rem m WITH(NOLOCK) WHERE  StockID = 218 GROUP BY ProdID )
	,Rem220_CTE AS( SELECT ProdID, SUM(Qty - AccQty) SumQty_AccQty , SUM(AccQty) SumAccQty FROM t_rem m WITH(NOLOCK) WHERE  StockID = 220 GROUP BY ProdID )
	,Rem_CTE AS( SELECT ProdID, SUM(Qty) SumQty FROM t_rem m WITH(NOLOCK) WHERE  StockID in ( select AValue from zf_FilterToTable(@StockID) ) GROUP BY ProdID )
	,gr_t_Ret_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Ret m WITH(NOLOCK)
					JOIN t_RetD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( select AValue from zf_FilterToTable(@StockID) )	and m.CodeID1 <> 100 GROUP BY d.ProdID
					)
	,gr_t_Inv_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Inv m WITH(NOLOCK)
					JOIN t_InvD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( select AValue from zf_FilterToTable(@StockID) ) and m.CodeID1 <> 100 GROUP BY d.ProdID
					)
	,gr_t_Exp_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Exp m WITH(NOLOCK)
					JOIN t_ExpD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( select AValue from zf_FilterToTable(@StockID) ) and m.CodeID1 <> 100 GROUP BY d.ProdID
					)
	,gr_t_Epp_CTE AS(
					SELECT d.ProdID, SUM(d.Qty) SumQty FROM t_Epp m WITH(NOLOCK)
					JOIN t_EppD d WITH(NOLOCK) ON d.ChID = m.ChID
					WHERE m.DocDate  BETWEEN @BeginDate AND @EndDate and m.StockID in ( select AValue from zf_FilterToTable(@StockID) ) and m.CodeID1 <> 100 GROUP BY d.ProdID
					)


SELECT *
,CASE WHEN �������_��_��_�� < �������_����_����� THEN �������_��_��_�� ELSE �������_����_����� END as '���_�������_����_�����' 
, (CASE WHEN �������_��_��_�� < �������_����_����� THEN �������_��_��_�� ELSE �������_����_����� END ) / �������_��_��_�� as '�������_��_�������'
FROM (		
	SELECT *
	,(isnull((round(�����_��_�������� / ���_�_�����,0) * ���_�_�����),0)) as '�������_�����_��_��������' --'�������_�����_��_��������' = ������(�����_��_��������/���_�_�����;0)*���_�_�����
	,(CASE WHEN (�������_��_��_�� - (isnull((round(�����_��_�������� / ���_�_�����,0) * ���_�_�����),0)) ) > 0 THEN (round(�����_��_�������� / ���_�_�����,0) * ���_�_�����) ELSE �������_��_��_�� END) as '����_�����' --'����_�����' = =����(�������_��_�� - �������_�����_��_�������� >0;�������_�����_��_��������;�������_��_��)
	,(isnull((round( ((CASE WHEN (�������_��_��_�� - (isnull((round(�����_��_�������� / ���_�_�����,0) * ���_�_�����),0)) ) > 0 THEN (round(�����_��_�������� / ���_�_�����,0) * ���_�_�����) ELSE �������_��_��_�� END)) / ���_�_�����,0) * ���_�_�����),0)) as '�������_����_�����' --'�������_����_�����' 
	FROM (
		 
		SELECT ProdID, PCatID, PCatName, ProdName, PGrID1, PGrName1, ���_�_�����, SumQty_t_Ret, SumQty_t_Inv, SumQty_t_Exp, SumQty_t_Epp,
		�������_��_��_��, ������_��_��, �������220_��,������220, �������218_��, ������218, �������, ������, kof 
		,(������ / 8 * kof * 4) as '�������'  --'�������'
		,(isnull(((������� - (������ / 8 * kof * 4))),0)) as '�������'  --  ������� - ������� = �������
		, case when (isnull(((������� - (������ / 8 * kof * 4))),0)) > 0 then 0 else (isnull(((������� - (������ / 8 * kof * 4))),0)) * -1 end as '�����_��_��������' --'����� �� ��������' = ����('�������'>0;0;'�������'*-1)
		FROM ( 
		   
			--������� ������� �� ������������ (220,218) ������ � �������� ���������
			SELECT gr.ProdID,  gr.SumQty_AccQty '�������_��_��_��', p.PCatID, r_ProdC.PCatName, p.ProdName, p.PGrID1, r_ProdG1.PGrName1 , isnull(mq.Qty,1) '���_�_�����',
			gr_t_Ret.SumQty SumQty_t_Ret,gr_t_Inv.SumQty SumQty_t_Inv ,gr_t_Exp.SumQty SumQty_t_Exp,gr_t_Epp.SumQty SumQty_t_Epp, 
			gr_t_Rem.SumQty '�������' , gr_t_Rem218.SumQty_AccQty '�������218_��' , gr_t_Rem220.SumQty_AccQty '�������220_��',
			gr.SumAccQty '������_��_��' , gr_t_Rem218.SumAccQty '������218' , gr_t_Rem220.SumAccQty '������220'
			, (ISNULL(gr_t_Inv.SumQty,0) + ISNULL(gr_t_Exp.SumQty,0)  + ISNULL(gr_t_Epp.SumQty,0) - ISNULL(gr_t_Ret.SumQty,0))  '������'
			,dbo.af_GetPercentsForPCatIDImport(p.PCatID,@WeekID) kof
			FROM (
				SELECT ProdID,  SUM(Qty - AccQty) SumQty_AccQty , SUM(AccQty) SumAccQty FROM t_rem m WITH(NOLOCK)
				WHERE  StockID in (220,218)
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

			WHERE ((0 = case when @PCatID is null then 0 when @PCatID = '' then 0 else 1 end ) OR ( (SELECT [dbo].[zf_MatchFilterInt](p.PCatID,@PCatID,',')) = 1 and 1 = case when @PCatID is null then 0 when @PCatID = '' then 0 else 1 end ))
			  AND ((0 = case when @PGrID1 is null then 0 when @PGrID1 = '' then 0 else 1 end ) OR ( (SELECT [dbo].[zf_MatchFilterInt](p.PGrID1,@PGrID1,',')) = 1 and 1 = case when @PGrID1 is null then 0 when @PGrID1 = '' then 0 else 1 end ))
			  AND ((0 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ) OR ( (SELECT [dbo].[zf_MatchFilterInt](p.ProdID,@ProdID,',')) = 1 and 1 = case when @ProdID is null then 0 when @ProdID = '' then 0 else 1 end ))
			  AND gr.SumQty_AccQty > 0

			) v1
		) v2
	) v3
ORDER BY '����_�����' desc
--ORDER BY 5 desc

