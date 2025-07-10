DECLARE @BDate SMALLDATETIME = '20180601';
DECLARE @EDate SMALLDATETIME = '20180630';

    BEGIN --���� ���������� ����������
        DECLARE
--1,2,3,4,5...�������� ���������...



        /*�����*/
         @OurID VARCHAR(MAX)   = '1-5,11'-- ��������� ����� (����� ������)
        ,@PCatID_alcohol VARCHAR(MAX) = '1-100' --��� ��������� (��������� ������ (��������))
        ,@PCatID_ads VARCHAR(MAX) = '500' --��� ��������� (��������� ������ (�������))
        ,@PLID VARCHAR(MAX) = '106' --�����-����
        ,@CurCurs as numeric(10,2) = (select dbo.zf_GetRateMC(dbo.zf_GetCurrCC())) --�� 31.01.2020 ���� $ 25
        
        /*������*/

		,@PGrID1_sales VARCHAR(MAX)  = '1,3,4,5,6' --��� ������ 1 (����� ������)
		,@PGrID1_alcohol VARCHAR(MAX)  = '1,3,4,5,6' --��� ������ 1 (��������� ������ (��������))
		,@PGrID1_ads VARCHAR(MAX)  = '1,3,4,5,6' --��� ������ 1 (��������� ������ (�������))

        /*��������*/

        --������� 1
		,@CodeID1_sales VARCHAR(MAX) = '50-79' --(����� ������)
		,@CodeID1_license VARCHAR(MAX) = '2024' --(��������)
		,@CodeID1_brand VARCHAR(MAX) = '2002-2005,2008-2023,2025-2042,2044-2099,2101-3001' --(������� ������)
		,@CodeID1_credit VARCHAR(MAX) = '2043' --(�������� �� ��������)
		,@CodeID1_distrProfit VARCHAR(MAX) = '2100' --(�������� ������� �� �����������)
		,@CodeID1_deptExp VARCHAR(MAX) = '2002-2005,2008-2023,2025-2042,2044-2099,2101-3001' --(������� ����� �������)
		,@CodeID1_distrShipments VARCHAR(MAX) = '3' --(������� �� �������� ������������)
		,@CodeID1_distrExpProject VARCHAR(MAX) = '2002-2005,2008-2023,2025-2042,2044-2099,2101-3001' --(������� ������������ �� ������)
		,@CodeID1_distrExp VARCHAR(MAX) = '2002-2005,2008-2023,2025-2042,2044-2099,2101-3001' --(����� ������� ������������ �������)

        --������� 2
		,@CodeID2_distrShipments VARCHAR(MAX) = '200' --(������� �� �������� ������������)

        --������� 3
		,@CodeID3_distrShipments VARCHAR(MAX) = '141,143' --(������� �� �������� ������������)

        --������� 4
		,@CodeID4_brand VARCHAR(MAX) = '2000-2029,2100-3000' --(������� ������)
		,@CodeID4_license VARCHAR(MAX) = '2000-2029,2100-3000' --(��������)
		,@CodeID4_credit VARCHAR(MAX) = '2000-2029,2100-3000' --(�������� �� ��������)
		,@CodeID4_distrProfit VARCHAR(MAX) = '2000-2029,2100-3000' --(�������� ������� �� �����������)
		,@CodeID4_deptExp VARCHAR(MAX) = '2000-2029,2100-3000' --(������� ����� �������)
		,@CodeID4_distrExpProject VARCHAR(MAX) = '2030-2099' --(������� ������������ �� ������)
		,@CodeID4_distrExp VARCHAR(MAX) = '2030-2099' --(����� ������� ������������ �������)

        --������� 5
		,@CodeID5_brand VARCHAR(MAX) = '2012,2013,2017,2020,2066' --(������� ������)
		,@CodeID5_license VARCHAR(MAX) = '2012,2013,2017,2020,2066' --(��������)
		,@CodeID5_credit VARCHAR(MAX) = '2012,2013,2017,2020,2066' --(�������� �� ��������)
		,@CodeID5_distrProfit VARCHAR(MAX) = '2012,2013,2017,2020,2066' --(�������� ������� �� �����������)
		,@CodeID5_deptExp VARCHAR(MAX) = '2006,2007,2008,2010,2018,2022' --(������� ����� �������)
		,@CodeID5_distrShipments VARCHAR(MAX) = '2012,2013,2017,2020,2066' --(������� �� �������� ������������)
		,@CodeID5_distrExpProject VARCHAR(MAX) = '2012,2013,2017,2020,2066' --(������� ������������ �� ������)
		,@CodeID5_distrExp VARCHAR(MAX) = '2006,2007,2008,2010,2018'; --(����� ������� ������������ �������)
    END;


--"������� ����� �������" (���������� ID449)
/*IF OBJECT_ID('Elit..temp_corp_6_1_ID449', 'U') IS NOT NULL DROP TABLE temp_corp_6_1_ID449;
    SELECT TOP 0 * INTO temp_corp_6_1_ID449 FROM temp_corp_6_1;
INSERT INTO temp_corp_6_1_ID449 SELECT * FROM ( 
SELECT 192 'PartID', 0 Style, '������� ����� ������� (ID449)' 'PartIDName', PGrID1, ROUND(SUM(SumMC),0) 'SumMC' FROM (*/
          
    /*������ (����) - ������ ����� �� ������������*/          
    SELECT SUM(m.SumAC / m.KursMC) 'SumMC', 
    m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate
    FROM c_CompExp m WITH (NOLOCK) --c_CompExp	������ ����� �� ������������ view: av_c_CompExp
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --��� ������ ����� �� ������� �����������.
    GROUP BY m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate

    UNION ALL
    /*������ (����) - ������ ����� �� ������������*/          
    SELECT SUM(0-(m.SumAC / m.KursMC)) 'SumMC',
    m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate
    FROM c_CompRec m WITH (NOLOCK) --c_CompRec	������ ����� �� ������������ view: av_c_CompRec
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --��� ������ ����� �� ������� �����������.
    GROUP BY m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate

    UNION ALL
    /*������ (����) - ���������� ��� ������� (������)*/ 
    SELECT SUM(d.Qty * tpi.CostMC) 'SumMC',
    rcd1.CodeID1, rcd4.CodeID4, rcd5.CodeID5, m.OurID, m.DocDate
    FROM t_Est m WITH (NOLOCK) --t_Est	���������� ��� �������: ��������� view: av_t_Est
        JOIN t_EstD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_EstD	���������� ��� �������: ����� av_t_EstD
        JOIN r_Stocks r_Stocks_189 WITH (NOLOCK) ON (r_Stocks_189.StockID = m.StockID)
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
        JOIN r_Prods rp WITH (NOLOCK) ON (rp.ProdID = tpi.ProdID)
        JOIN r_ProdC rpc WITH (NOLOCK) ON (rpc.PCatID = rp.PCatID)
        JOIN r_ProdG rpg WITH (NOLOCK) ON (rpg.PGrID = rp.PGrID)
        JOIN r_ProdG1 rpg1 WITH (NOLOCK) ON (rpg1.PGrID1 = rp.PGrID1) --r_ProdG1	���������� �������: ��������� 1
        JOIN r_Codes1 rcd1 WITH (NOLOCK) ON (rcd1.CodeID1 = rpc.CodeID1)
        JOIN r_Codes5 rcd5 WITH (NOLOCK) ON (rcd5.CodeID5 = rpg1.CodeID5)
        JOIN r_StockGs r_StockGs_190 WITH (NOLOCK) ON (r_StockGs_190.StockGID = r_Stocks_189.StockGID)
        JOIN r_Codes4 rcd4 WITH (NOLOCK) ON (rcd4.CodeID4 = r_StockGs_190.StockGID)
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](rcd1.CodeID1,@CodeID1_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](rcd4.CodeID4,@CodeID4_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](rcd5.CodeID5,@CodeID5_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --��� ������ ����� �� ������� �����������.
        AND (rp.PCatID BETWEEN 600 AND 699) --��� ������ ����� �� ������� �����������.
        AND ((rp.PGrID BETWEEN 9100 AND 9999) --��� ������ ����� �� ������� �����������.
        OR (rp.PGrID BETWEEN 16000 AND 17000))--��� ������ ����� �� ������� �����������.
    GROUP BY rcd1.CodeID1, rcd4.CodeID4, rcd5.CodeID5, m.OurID, m.DocDate
         
    UNION ALL
    /*������ (����) - ���������� ��� ������� (������)*/ 
    SELECT SUM(0-(d.Qty * tpi.CostMC)) 'SumMC',
    rcd1.CodeID1, rcd4.CodeID4, rcd5.CodeID5, m.OurID, m.DocDate
    FROM t_Est m WITH (NOLOCK) --t_Est	���������� ��� �������: ��������� view: av_t_Est
        JOIN t_EstD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_EstD	���������� ��� �������: ����� av_t_EstD
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.NewPPID) AND (tpi.ProdID = d.ProdID) --NewPPID	��� ������
        JOIN r_Prods rp WITH (NOLOCK) ON (rp.ProdID = tpi.ProdID)
        JOIN r_ProdG rpg WITH (NOLOCK) ON (rpg.PGrID = rp.PGrID)
        JOIN r_ProdG1 rpg1 WITH (NOLOCK) ON (rpg1.PGrID1 = rp.PGrID1) --r_ProdG1	���������� �������: ��������� 1
        JOIN r_ProdC rpc WITH (NOLOCK) ON (rpc.PCatID = rp.PCatID)
        JOIN r_Codes1 rcd1 WITH (NOLOCK) ON (rcd1.CodeID1 = rpc.CodeID1)
        JOIN r_Codes2 rcd2 WITH (NOLOCK) ON (rcd2.CodeID2 = rpg.CodeID2)
        JOIN r_Stocks r_Stocks_189 WITH (NOLOCK) ON (r_Stocks_189.StockID = m.StockID)
        JOIN r_StockGs r_StockGs_190 WITH (NOLOCK) ON (r_StockGs_190.StockGID = r_Stocks_189.StockGID)
        JOIN r_Codes5 rcd5 WITH (NOLOCK) ON (rcd5.CodeID5 = rpg1.CodeID5)
        JOIN r_Codes4 rcd4 WITH (NOLOCK) ON (rcd4.CodeID4 = r_StockGs_190.StockGID)
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](rcd1.CodeID1,@CodeID1_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](rcd4.CodeID4,@CodeID4_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](rcd5.CodeID5,@CodeID5_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --��� ������ ����� �� ������� �����������.
        AND (rp.PCatID BETWEEN 600 AND 699) --��� ������ ����� �� ������� �����������.
        AND ((rp.PGrID BETWEEN 9100 AND 9999) --��� ������ ����� �� ������� �����������.
        OR (rp.PGrID BETWEEN 16000 AND 17000))--��� ������ ����� �� ������� �����������.
    GROUP BY rcd1.CodeID1, rcd4.CodeID4, rcd5.CodeID5, m.OurID, m.DocDate

    UNION ALL
    /*������ (����) - ��������� ���������*/ 
    SELECT SUM(d.Qty * tpi.CostMC) 'SumMC',
    m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate
    FROM t_Inv m WITH(NOLOCK) --t_Inv	��������� ���������: ��������� view: av_t_Inv
        JOIN t_InvD d WITH (NOLOCK) ON (m.ChID = d.ChID)
--        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND m.DocDate BETWEEN @BDate AND @EDate 
        AND (m.OurID IN (1,11,2,3,5,6,4)) --��� ������ ����� �� ������� �����������.
    GROUP BY m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate

    UNION ALL
    /*������ (����) - ��������� ��������*/ 
    SELECT SUM(d.Qty * tpi.CostMC) 'SumMC',
    m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate
    FROM t_Exp m WITH(NOLOCK)
        JOIN t_ExpD d WITH (NOLOCK) ON (m.ChID = d.ChID)
--        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --��� ������ ����� �� ������� �����������.
        AND m.DocDate BETWEEN @BDate AND @EDate 
    GROUP BY m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate

    UNION ALL
    /*������ (����) - ��������� �������� � ����� �������*/ 
    SELECT SUM(d.Qty * tpi.CostMC) 'SumMC',
    m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate
    FROM t_Epp m WITH(NOLOCK) --t_Epp	��������� �������� � ����� �������: ���������
        JOIN t_EppD d WITH (NOLOCK) ON (m.ChID = d.ChID)
--        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --��� ������ ����� �� ������� �����������.
        AND m.DocDate BETWEEN @BDate AND @EDate 
    GROUP BY m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate

    UNION ALL
    /*������ (����) - ������ ������*/ 
    SELECT SUM(0-(d.Qty * tpi.CostMC)) 'SumMC',
    m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate
    FROM t_Rec m WITH(NOLOCK) --t_Rec	������ ������: ���������
        JOIN t_RecD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_RecD	������ ������: �����
--        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --��� ������ ����� �� ������� �����������.
        AND m.DocDate BETWEEN @BDate AND @EDate 
    GROUP BY m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate

    UNION ALL
    /*������ (����) - ������� ������ �� ����������*/ 
    SELECT SUM(0-(d.Qty * tpi.CostMC)) 'SumMC',
    m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate
    FROM t_Ret m WITH(NOLOCK) --t_Ret	������� ������ �� ����������: ���������
        JOIN t_RetD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_RetD	������� ������ �� ����������: �����
--        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --��� ������ ����� �� ������� �����������.
        AND m.DocDate BETWEEN @BDate AND @EDate 
    GROUP BY m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate

    UNION ALL
    /*������ (����) - ������� ������ ����������*/ 
    SELECT SUM(d.Qty * tpi.CostMC) 'SumMC',
    m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate
    FROM t_CRet m WITH(NOLOCK) --t_CRet	������� ������ ����������: ���������
        JOIN t_CRetD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_CRetD	������� ������ ����������: ������
--        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --��� ������ ����� �� ������� �����������.
        AND m.DocDate BETWEEN @BDate AND @EDate 
    GROUP BY m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate

    UNION ALL
    /*������ (����) - ������� ������ �� ����*/ 
    SELECT SUM(0-(d.Qty * tpi.CostMC)) 'SumMC',
    m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate
    FROM t_CRRet m WITH(NOLOCK) --t_CRRet	������� ������ �� ����: ���������
        JOIN t_CRRetD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_CRRetD	������� ������ �� ����: �����
--        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --��� ������ ����� �� ������� �����������.
        AND m.DocDate BETWEEN @BDate AND @EDate 
    GROUP BY m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate
   
    UNION ALL
    /*������ (����) - ������� ������ ����������*/ 
    SELECT SUM(d.Qty * tpi.CostMC) 'SumMC',
    m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate
    FROM t_Sale m WITH(NOLOCK) --t_Sale	������� ������ ����������: ���������
        JOIN t_SaleD d WITH (NOLOCK) ON (m.ChID = d.ChID) --t_SaleD	������� ������ ����������: ������� ������
--        JOIN r_ProdG1 rpg1 WITH(NOLOCK) ON (rpg1.CodeID5 = m.CodeID5)  
        JOIN t_PInP tpi WITH (NOLOCK) ON (tpi.PPID = d.PPID) AND (tpi.ProdID = d.ProdID)
    WHERE
        (SELECT [dbo].[zf_MatchFilterInt](m.CodeID1,@CodeID1_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID4,@CodeID4_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.CodeID5,@CodeID5_deptExp,',')) = 1
        AND (SELECT [dbo].[zf_MatchFilterInt](m.OurID,@OurID,',')) = 1
        AND (m.OurID IN (1,11,2,3,5,6,4)) --��� ������ ����� �� ������� �����������.
        AND m.DocDate BETWEEN @BDate AND @EDate 
    GROUP BY m.CodeID1, m.CodeID4, m.CodeID5, m.OurID, m.DocDate

/*) AS SumMC  
GROUP BY PGrID1
) AS m449*/

/*DECLARE @ID449 BIGINT = (SELECT SUM(TOTALS) FROM temp_corp_6_1_ID449)
SELECT @ID449 '@ID449'*/