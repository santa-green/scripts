--	������ �� ��������� ����� ElitR
						
--	1. ������ "������"						
--	��������	��������� ��� �������					��������
--		����	�����	������ ���������	����, ��	������� 1	
--1	������ ������	01.04.2018-30.04.2018	6,7,8,9,12	980	27	82, 87, 100, 2004	�������� ����, ��� ��������� ��� ��������� � ���������� �������� ���
--2	����������� ������	01.04.2018-30.04.2018	6,7,8,9,12	980	27	40, 41,42	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
--3	��������������	01.04.2018-30.04.2018	6,7,8,9,12	980	27	2004	�������� ���� � ���������� ��� ��������� � ��� ��������� ���
--4	�������	01.04.2018-30.04.2018	6,7,8,9,12	980	27	2004	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
--5	������� ����������	01.04.2018-30.04.2018	6,7,8,9,12	980	27	82	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
--6	������� �� ����	01.04.2018-30.04.2018	6,7,8,9,12	980	27	63	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
--7	��������� ���������	01.04.2018-30.04.2018	6,7,8,9,12	980	27	63	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
--8	��������� ��������	01.04.2018-30.04.2018	6,7,8,9,12	980	27	2004, 2032, 2038	�������� ���� � ���������� ��� ��������� � ��� ��������� ���
--9	������� ������ ����������	01.04.2018-30.04.2018	6,7,8,9,12	980	27	63	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
--10	��������� �������� � ����� �������	01.04.2018-30.04.2018	6,7,8,9,12	980	27	100	�������� ���� � ���������� ��� ��������� � ��� ��������� ���
--11	��������� �������� � ����� �������	01.04.2018-30.04.2018	6,7,8,9,12	980	27	2004	�������� ���� c ���������� ��� ��������� � ��� ��������� ���
--12	������������ ������	01.04.2018-30.04.2018	6,7,8,9,12	980	27	100	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
--13	���������������� ������	01.04.2018-30.04.2018	6,7,8,9,12	980	27	100	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
--14	��������� �������� � ����� �������	01.04.2018-30.04.2018	6,7,8,9,12	980	27	42	�������� ���� � ���������� ��� ��������� � ��� ��������� ���
--15	������ ������	01.04.2018-30.04.2018	6,7,8,9,12	980	27	42	�������� ���� � ���������� ��� ��������� � ��� ��������� ���
--16	����� �������� ����� �� �����	01.04.2018-30.04.2018	6,7,8,9,12	980	27	63, 10	����������� ����� ��, �� ����� ����� ��,��
							
--	2. ������ "�������"						
--	��������	��������� ��� �������					��������
--		����	�����	������ ���������	����, ��	������� 1	
--17	������ ����� �� ������������	02.04.2018-30.04.2018	6,7,8,9,12	980	27	���	����������� ����� ��, �� ����� ����� ��,��
--18	������ ����� �� ������������	02.04.2018-30.04.2018	6,7,8,9,12	980	27	���	����������� ����� ��, �� ����� ����� ��,��

/*
EXEC master.dbo.sp_WhoIsActive
*/	

BEGIN TRAN

--1	������ ������	01.04.2018-30.04.2018	6,7,8,9,12	980	27	82, 87, 100, 2004	�������� ����, ��� ��������� ��� ��������� � ���������� �������� ���
print '11002|t_Rec|������ ������'
--Begin Tran
	--� ���������� �������� ���
	--��������� ���� ������� �� � ������������� �� � ��������
	Update p
	Set p.PriceMC_IN = p.PriceAC_In/c.KursMC, --���� ������� ��
 		p.CostMC = p.CostAC/c.KursMC -- ������������� �� 
	From t_Rec r 
	join t_recD rd on r.ChID = rd.Chid
	join t_Pinp p on rd.ProdID = p.ProdID and rd.PPID = p.PPID
	join r_Currs c on p.CurrID=c.CurrID
	where r.DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) 
		and c.CurrID=980 and r.Ourid in (6,7,8,9,12) and r.CodeID1 in (82,87,100,2004) and r.KursMC=28.00
		
	--�������� ����, ��� ��������� ��� ���������
	Update d
	set d.KursMC =27.00
	From t_Rec d 
	where DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) and d.KursMC=28.00
		and d.OurID in (6,7,8,9,12) and d.CodeID1 in (82,87,100,2004)
		
	--SELECT * From t_Rec d 
	--where DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) 
	--and d.OurID in (6,7,8,9,12) and d.CodeID1 in (82,87,100,2004)

	--Select p.*
	--From t_Rec r 
	--join t_recD rd on r.ChID = rd.Chid
	--join t_Pinp p on rd.ProdID = p.ProdID and rd.PPID = p.PPID
	--join r_Currs c on p.CurrID=c.CurrID
	--where r.DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) 
	--	and c.CurrID=980 and r.Ourid in (6,7,8,9,12) and r.CodeID1 in (82,87,100,2004)
	--Order By ProdID,PPID
--Rollback

--2	����������� ������	01.04.2018-30.04.2018	6,7,8,9,12	980	27	40, 41,42	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
print '11021	t_Exc	����������� ������'
--Begin Tran
	Update d
	set d.KursMC =27.00
	From t_Exc d 
	where DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) and d.KursMC=28.00
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (40,41,42)
	
	--SELECT * FROM t_Exc d 
	--where DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) and d.KursMC=28.00
	--and d.OurID in (6,7,8,9,12) and d.CodeID1 in (40,41,42)
--Rollback

--3 	��������������	01.04.2018-30.04.2018	6,7,8,9,12	980	27	2004	�������� ���� � ���������� ��� ��������� � ��� ��������� ���
print '11022	t_Ven	�������������� ������'
--Begin Tran

	--� ���������� ��� ���������
	Update ed
	Set PriceCC_nt = Round((PriceCC_nt/28.00)*27.00,2), SumCC_nt=Round((SumCC_nt/28.00)*27.00,2), Tax=Round((Tax/28.00)*27.00,2), TaxSum=Round((TaxSum/28.00)*27.00,2), PriceCC_wt=Round((PriceCC_wt/28.00)*27.00,2), SumCC_wt=Round((SumCC_wt/28.00)*27.00,2)
	,NewSumCC_nt=Round((NewSumCC_nt/28.00)*27.00,2),  NewTaxSum=Round((NewTaxSum/28.00)*27.00,2),  NewSumCC_wt=Round((NewSumCC_wt/28.00)*27.00,2)
	From t_Ven d join t_VenD ed on d.ChiD=ed.ChID
	where d.DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) and d.KursMC=28.00
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)

	Update d
	set d.KursMC =27.00
	From t_Ven d 
	where DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) and d.KursMC=28.00
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)
	
	--SELECT * FROM t_Ven d 
	--where DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) and d.KursMC=27.00
	--and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)

--SELECT  * FROM t_Ven WHERE ChiD = 2371
--SELECT  * FROM t_VenA WHERE ChiD = 2371
--SELECT  * FROM t_VenD WHERE ChiD = 2371

	--Select ed.*
	--From t_Ven d join t_VenD ed on d.ChiD=ed.ChID
	--where d.DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) and d.KursMC=27.00
	--and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)
--Rollback

--4 	�������	01.04.2018-30.04.2018	6,7,8,9,12	980	27	2004	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
print '11003	t_Ret	������� ������ �� ����������'
--Begin Tran
	Update d
	set d.KursMC =27.00
	From t_Ret d 
	where DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) and d.KursMC=28.00
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)
	
	--SELECT * FROM t_Ret d 
	--where DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) and d.KursMC=27.00
	--and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)
--Rollback


--5 	������� ����������	01.04.2018-30.04.2018	6,7,8,9,12	980	27	82	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
print '11011	t_CRet	������� ������ ����������'
--Begin Tran
	Update d
	set d.KursMC =27.00
	From t_CRet d 
	where DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) and d.KursMC=28.00
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (82)
	
	--SELECT * FROM t_CRet d 
	--where DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) and d.KursMC=27.00
	--and d.OurID in (6,7,8,9,12) and d.CodeID1 in (82)
--Rollback


--6 	������� �� ����	01.04.2018-30.04.2018	6,7,8,9,12	980	27	63	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
print '11004	t_CRRet	������� ������ �� ����'
--Begin Tran
	Update d
	set d.KursMC =27.00
	From t_CRRet d 
	where DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) and d.KursMC=28.00
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63)

	--SELECT * FROM t_CRRet d 
	--where DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) and d.KursMC=27.00
	--and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63)
--Rollback

--7 	��������� ���������	01.04.2018-30.04.2018	6,7,8,9,12	980	27	63	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
print '11012	t_Inv	��������� ���������'
--Begin Tran
	Update d
	set d.KursMC =27.00
	From t_Inv d 
	where DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) and d.KursMC=28.00
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63)
	
	--SELECT * FROM t_Inv d 
	--where DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) and d.KursMC=27.00
	--and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63)
--Rollback

--8 	��������� ��������	01.04.2018-30.04.2018	6,7,8,9,12	980	27	2004, 2032, 2038	�������� ���� � ���������� ��� ��������� � ��� ��������� ���
print '11015	t_Exp	��������� ��������'
--Begin Tran

	--� ���������� ��� ���������
	Update ed
	Set PriceCC_nt = Round((PriceCC_nt/28.00)*27.00,2), SumCC_nt=Round((SumCC_nt/28.00)*27.00,2), Tax=Round((Tax/28.00)*27.00,2), TaxSum=Round((TaxSum/28.00)*27.00,2), PriceCC_wt=Round((PriceCC_wt/28.00)*27.00,2), SumCC_wt=Round((SumCC_wt/28.00)*27.00,2)
	From t_Exp d join t_ExpD ed on d.ChiD=ed.ChID
	where d.DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) and d.KursMC=28.00
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004, 2032, 2038)

	--�������� ����
	Update d
	set d.KursMC =27.00
	From t_Exp d 
	where DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) and d.KursMC=28.00
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004,2032,2038)
	
	--Select ed.*
	--From t_Exp d join t_ExpD ed on d.ChiD=ed.ChID
	--where d.DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) and d.KursMC=27.00
	--and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004, 2032, 2038)
--Rollback

--9 	������� ������ ����������	01.04.2018-30.04.2018	6,7,8,9,12	980	27	63	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
print '11035	t_Sale	������� ������ ����������'
--Begin Tran

	--�������� ����
	Update d
	set d.KursMC =27.00
	From t_Sale d 
	where DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) and d.KursMC=28.00
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63)
	/*
	SELECT * FROM t_Sale d 
	where DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) and d.KursMC=28.00
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63)
	*/
--Rollback

--10	��������� �������� � ����� �������	01.04.2018-30.04.2018	6,7,8,9,12	980	27	100 	�������� ���� � ���������� ��� ��������� � ��� ��������� ���
--11	��������� �������� � ����� �������	01.04.2018-30.04.2018	6,7,8,9,12	980	27	2004	�������� ���� c ���������� ��� ��������� � ��� ��������� ���
--14	��������� �������� � ����� �������	01.04.2018-30.04.2018	6,7,8,9,12	980	27	42  	�������� ���� � ���������� ��� ��������� � ��� ��������� ���
print '��������� �������� � ����� �������'
--Begin Tran

	--� ���������� ��� ���������
	Update ed
	Set PriceCC_nt = Round((PriceCC_nt/28.00)*27.00,2), SumCC_nt=Round((SumCC_nt/28.00)*27.00,2), Tax=Round((Tax/28.00)*27.00,2), TaxSum=Round((TaxSum/28.00)*27.00,2), PriceCC_wt=Round((PriceCC_wt/28.00)*27.00,2), SumCC_wt=Round((SumCC_wt/28.00)*27.00,2)
	From t_Epp d join t_EppD ed on d.ChiD=ed.ChID
	where d.DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) and d.KursMC=28.00
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (42,100,2004)

	--�������� ����
	Update d
	set d.KursMC =27.00
	From t_Epp d 
	where DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) and d.KursMC=28.00
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (42,100,2004)
	
	--SELECT * FROM t_Epp d 
	--where DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) and d.KursMC=27.00
	--and d.OurID in (6,7,8,9,12) and d.CodeID1 in (42,100,2004) 
	
	--Select ed.*
	--From t_Epp d join t_EppD ed on d.ChiD=ed.ChID
	--where d.DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) and d.KursMC=27.00
	--and d.OurID in (6,7,8,9,12) and d.CodeID1 in (42,100,2004)
	
	--Select ed.*
	--From t_Epp d join t_EppD ed on d.ChiD=ed.ChID
	--where d.DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) and d.KursMC=27.00
	--and d.OurID in (6,7,8,9,12) and d.CodeID1 in (42,100,2004)
	
	--SELECT * FROM t_Epp d 
	--where DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) and d.KursMC=27.00
	--and d.OurID in (6,7,8,9,12) and d.CodeID1 in (42,100,2004) 
--Rollback


--12	������������ ������	01.04.2018-30.04.2018	6,7,8,9,12	980	27	100	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
print '11321	t_SRec	������������ ������'
--Begin Tran
	Update d
	set d.KursMC =27.00
	From t_SRec d 
	where DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) and d.KursMC=28.00
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100)
	
	--SELECT * FROM t_SRec d 
	--where DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) and d.KursMC=27.00
	--and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100)
--Rollback

--13	���������������� ������	01.04.2018-30.04.2018	6,7,8,9,12	980	27	100	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
print '11322	t_SExp	���������������� ������'
--Begin Tran
	Update d
	set d.KursMC =27.00
	From t_SExp d 
	where DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) and d.KursMC=28.00
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100)
	
	--SELECT * FROM t_SExp d 
	--where DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) and d.KursMC=27.00
	--and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100)
--Rollback

--15	������ ������	01.04.2018-30.04.2018	6,7,8,9,12	980	27	42	�������� ���� � ���������� ��� ��������� � ��� ��������� ���
print '11002|t_Rec|������ ������'
--Begin Tran
	
	--� ���������� ��� ���������
	Update ed
	Set PriceCC_nt = Round((PriceCC_nt/28.00)*27.00,2), SumCC_nt=Round((SumCC_nt/28.00)*27.00,2), Tax=Round((Tax/28.00)*27.00,2), TaxSum=Round((TaxSum/28.00)*27.00,2), PriceCC_wt=Round((PriceCC_wt/28.00)*27.00,2), SumCC_wt=Round((SumCC_wt/28.00)*27.00,2)
	,CostSum = Round((CostSum/28.00)*27.00,2), CostCC = Round((CostCC/28.00)*27.00,2), PriceCC = Round((PriceCC/28.00)*27.00,2)
	From t_Rec d join t_RecD ed on d.ChiD=ed.ChID
	where d.DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) and d.KursMC=28.00
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (42)

	--�������� ����, ��� ��������� ��� ���������
	Update d
	set d.KursMC =27.00
	From t_Rec d 
	where DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) and d.KursMC=28.00
		and d.OurID in (6,7,8,9,12) and d.CodeID1 in (42)

	--Select ed.*
	--From t_Rec d join t_RecD ed on d.ChiD=ed.ChID
	--where d.DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) and d.KursMC=27.00
	--and d.OurID in (6,7,8,9,12) and d.CodeID1 in (42)
--Rollback


--16	����� �������� ����� �� �����	01.04.2018-30.04.2018	6,7,8,9,12	980	27	63, 10	����������� ����� ��, �� ����� ����� ��,�� (�� ����� ���� ������ ������ ����)
print '11018	t_MonRec	����� �������� ����� �� �����'
--Begin Tran
	Update d
	set d.KursMC =27.00
	From t_MonRec d 
	where DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) and d.KursMC=28.00
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63,10)
	
	--SELECT * FROM t_MonRec d 
	--where DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) and d.KursMC=28.00
	--and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63,10)
--Rollback

--17	������ ����� �� ������������	02.04.2018-30.04.2018	6,7,8,9,12	980	27	���	����������� ����� ��, �� ����� ����� ��,�� (�� ����� ���� ������ ������ ����)
print '12001	c_CompRec	������ ����� �� ������������'
--Begin Tran
	Update d
	set d.KursMC =27.00
	From c_CompRec d 
	where DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) and d.KursMC=28.00
	and d.OurID in (6,7,8,9,12)
	
--	SELECT * FROM c_CompRec d 
--	where DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) and d.KursMC=28.00
--	and d.OurID in (6,7,8,9,12)
--Rollback

--18	������ ����� �� ������������	02.04.2018-30.04.2018	6,7,8,9,12	980	27	���	����������� ����� ��, �� ����� ����� ��,�� (�� ����� ���� ������ ������ ����)
print '12002	c_CompExp	������ ����� �� ������������'
--Begin Tran
	Update d
	set d.KursMC =27.00
	From c_CompExp d 
	where DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) and d.KursMC=28.00
	and d.OurID in (6,7,8,9,12)

	--SELECT * FROM c_CompExp d 
	--where DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) and d.KursMC=28.00
	--and d.OurID in (6,7,8,9,12)
--Rollback



ROLLBACK TRAN



--����� ��������� ��������� ������ 2 ����
BEGIN TRAN

IF 1=1 
BEGIN
  

SET NOCOUNT ON		
--set rowcount 0; 	
DECLARE @pos INT = 0, @DateShow DATETIME  = GETDATE(), @DateStart DATETIME = GETDATE(), @p INT,@ToEnd INT, @t INT, @Msg varchar(200), @p100 INT

DECLARE @ChID INT
DECLARE CURSOR1 CURSOR STATIC --LOCAL FAST_FORWARD
FOR
SELECT DISTINCT sr.ChID --,* 
 	From t_SRec sr 
	join t_SRecA sra on sra.ChID = sr.Chid
	join t_SRecD srd on srd.AChID = sra.AChid
	join t_Pinp p on srd.SubProdID = p.ProdID and srd.SubPPID = p.PPID
	join r_Currs c on p.CurrID=c.CurrID
	where sr.DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) 
		and c.CurrID=980 
		--and sr.Ourid in (12) 
		and sr.CodeID1 in (100)
		--and sr.StockID in (1001,1202,1314)
		--and  p.CostMC * c.KursMC <> srd.SubPriceCC_wt
	--ORDER BY sr.ChID
	
OPEN CURSOR1
	FETCH NEXT FROM CURSOR1 	INTO @ChID
WHILE @@FETCH_STATUS = 0
BEGIN
	--Script
------------------------------------------------------------------------------		
	IF @pos = 0 SET @p100 = @@CURSOR_ROWS	
	SET @pos = @pos + 1
	IF  DATEDIFF ( second , @DateShow , Cast (GETDATE() as DATETIME) ) >= 5 
	BEGIN
		SET @DateShow =  GETDATE()
		SET @p = (@pos*100)/@p100
		IF @p = 0 SET @p = 1
		SET @t = DATEDIFF ( second , @DateStart , Cast (GETDATE() as DATETIME) )
		SET @ToEnd = (100 - @p) * @t / @p  
		SET @Msg = CONVERT( varchar, GETDATE(), 121)  
		RAISERROR ('��������� %u ��������� ��  %u ���. �������� = %u ���.', 10,1,@p,@t,@ToEnd) WITH NOWAIT
	END	
------------------------------------------------------------------------------
	
--/*
--����������� ������������ ���������� �� ����� ������		
update srd
set srd.SubPriceCC_wt = p.CostMC * c.KursMC
,srd.SubNewPriceCC_wt = p.CostMC * c.KursMC
,srd.SubTax  = isnull(dbo.zf_GetIncludedTax((p.CostMC * c.KursMC), dbo.zf_GetProdTaxPercent(srd.SubProdID, dbo.zf_GetDate(sr.DocDate))),0) /* ���*/
,SubPriceCC_nt = p.CostMC * c.KursMC - isnull(dbo.zf_GetIncludedTax((p.CostMC * c.KursMC), dbo.zf_GetProdTaxPercent(srd.SubProdID, dbo.zf_GetDate(sr.DocDate))),0) /* ���� ��� ���*/
,SubSumCC_wt= srd.SubQty *  p.CostMC * c.KursMC /* ����� � ���*/
,SubTaxSum  = srd.SubQty * isnull(dbo.zf_GetIncludedTax((p.CostMC * c.KursMC), dbo.zf_GetProdTaxPercent(srd.SubProdID, dbo.zf_GetDate(sr.DocDate))),0) /* ����� ���*/
,SubSumCC_nt = srd.SubQty * p.CostMC * c.KursMC - isnull(dbo.zf_GetIncludedTax((p.CostMC * c.KursMC), dbo.zf_GetProdTaxPercent(srd.SubProdID, dbo.zf_GetDate(sr.DocDate))),0) /* ����� ��� ���*/

,srd.SubNewTax  = isnull(dbo.zf_GetIncludedTax((p.CostMC * c.KursMC), dbo.zf_GetProdTaxPercent(srd.SubProdID, dbo.zf_GetDate(sr.DocDate))),0) /* ���*/
,SubNewPriceCC_nt = p.CostMC * c.KursMC - isnull(dbo.zf_GetIncludedTax((p.CostMC * c.KursMC), dbo.zf_GetProdTaxPercent(srd.SubProdID, dbo.zf_GetDate(sr.DocDate))),0) /* ���� ��� ���*/
,SubNewSumCC_wt= srd.SubQty *  p.CostMC * c.KursMC /* ����� � ���*/
,SubNewTaxSum  = srd.SubQty * isnull(dbo.zf_GetIncludedTax((p.CostMC * c.KursMC), dbo.zf_GetProdTaxPercent(srd.SubProdID, dbo.zf_GetDate(sr.DocDate))),0) /* ����� ���*/
,SubNewSumCC_nt = srd.SubQty * p.CostMC * c.KursMC - isnull(dbo.zf_GetIncludedTax((p.CostMC * c.KursMC), dbo.zf_GetProdTaxPercent(srd.SubProdID, dbo.zf_GetDate(sr.DocDate))),0) /* ����� ��� ���*/

 	From t_SRec sr 
	join t_SRecA sra on sra.ChID = sr.Chid
	join t_SRecD srd on srd.AChID = sra.AChid
	join t_Pinp p on srd.SubProdID = p.ProdID and srd.SubPPID = p.PPID
	join r_Currs c on p.CurrID=c.CurrID
	where sr.DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) 
		and c.CurrID=980 
		--and sr.Ourid in (12) 
		and sr.CodeID1 in (100)
		--and sr.StockID in (1001,1202,1314)
		--and  p.CostMC * c.KursMC <> srd.SubPriceCC_wt
		--and srd.SubProdID in (611577) 
		--and sr.DocID = 600005625	
		and sr.ChID = @ChID
	
	--�������� ���������
	EXEC dbo.ap_UpdateSRecA @ChID 
	--EXEC dbo.ap_UpdateSRecA @ChID = 11267
--*/	
	FETCH NEXT FROM CURSOR1 INTO @ChID
END
CLOSE CURSOR1
DEALLOCATE CURSOR1
SET NOCOUNT OFF
          

/*
SELECT srd.AChID,srd.SubSrcPosID,sr.DocDate, p.CostMC , c.KursMC, p.CostMC * c.KursMC, srd.SubPriceCC_wt, sr.*
 	From t_SRec sr 
	join t_SRecA sra on sra.ChID = sr.Chid
	join t_SRecD srd on srd.AChID = sra.AChid
	join t_Pinp p on srd.SubProdID = p.ProdID and srd.SubPPID = p.PPID
	join r_Currs c on p.CurrID=c.CurrID
	where 
		(
		sr.DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) 
		and c.CurrID=980 and sr.Ourid in (12) and sr.CodeID1 in (100)
		and sr.StockID in (1001,1202,1314)
		and  p.CostMC * c.KursMC <> srd.SubPriceCC_wt
		--and srd.SubProdID in (611577) 
		--and sr.DocID = 600005625
		)
		--or (srd.AChID = 143261 and srd.SubSrcPosID  = 9)
	ORDER BY 1,2
*/		

END

ROLLBACK TRAN 

IF @@TRANCOUNT > 0 
BEGIN
  COMMIT TRAN
print '���������� COMMIT. ��� ��'
END


/*
--����� ����������� ������������ � ����������
SELECT sr.*,srd.*,sra.* FROM  	t_SRec sr 
	join t_SRecA sra on sra.ChID = sr.Chid
	left join t_SRecD srd on srd.AChID = sra.AChid
	left join t_Pinp p on srd.SubProdID = p.ProdID and srd.SubPPID = p.PPID
	left join r_Currs c on p.CurrID=c.CurrID
	where 
	sr.DocDate Between Cast ('20180401' as SMALLDATETIME) and Cast ('20180430' as SMALLDATETIME) 
		--and c.CurrID=980 
		--and sr.Ourid in (12) 
		--and sr.CodeID1 in (100)
		--and sr.StockID in (1001,1202,1314)
		--and  p.CostMC * c.KursMC <> srd.SubPriceCC_wt
		--and srd.SubProdID in (611577) 
		--and sr.DocID = 600005625	
		and 
		srd.AChID is null
		--and sr.ChID = 12985
*/		 