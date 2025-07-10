--��������� ����� � ���������� ���� ElitR

/*
������ �� ��������� �����						
						
1. ������ "������"						
��������	��������� ��� �������					��������
	����	�����	������ ���������	����, ��	������� 1	
--������ ������	01.09.2018-31.09.2018	6,7,8,9,12	980	29	82, 87, 100, 2004	�������� ����, ��� ��������� ��� ��������� � ���������� �������� ���
--����������� ������	01.09.2018-31.09.2018	6,7,8,9,12	980	29	40, 41	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
--��������������	01.09.2018-31.09.2018	6,7,8,9,12	980	29	2004	�������� ���� � ���������� ��� ��������� � ��� ��������� ���
--�������	01.09.2018-31.09.2018	6,7,8,9,12	980	29	2004	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
--������� ����������	01.09.2018-31.09.2018	6,7,8,9,12	980	29	82	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
--������� �� ����	01.09.2018-31.09.2018	6,7,8,9,12	980	29	63	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
--��������� ���������	01.09.2018-31.09.2018	6,7,8,9,12	980	29	63	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
--��������� ��������	01.09.2018-31.09.2018	6,7,8,9,12	980	29	2004, 2032, 2038	�������� ���� � ���������� ��� ��������� � ��� ��������� ���
--������� ������ ����������	01.09.2018-31.09.2018	6,7,8,9,12	980	29	63	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
--��������� �������� � ����� �������	01.09.2018-31.09.2018	6,7,8,9,12	980	29	100	�������� ���� � ���������� ��� ��������� � ��� ��������� ���
--��������� �������� � ����� �������	01.09.2018-31.09.2018	6,7,8,9,12	980	29	2004	�������� ���� c ���������� ��� ��������� � ��� ��������� ���
--������������ ������	01.09.2018-31.09.2018	6,7,8,9,12	980	29	100	�������� ����, � ���������� ��� ��������� � ��� ��������� ���
--���������������� ������	01.09.2018-31.09.2018	6,7,8,9,12	980	29	100	�������� ����, � ���������� ��� ��������� � ��� ��������� ���
--��������� �������� � ����� �������	01.09.2018-31.09.2018	6,7,8,9,12	980	29	42	�������� ���� � ���������� ��� ��������� � ��� ��������� ���
--������ ������	01.09.2018-31.09.2018	6,7,8,9,12	980	29	42	�������� ���� � ���������� ��� ��������� � ��� ��������� ���
--����� �������� ����� �� �����	01.09.2018-31.09.2018	6,7,8,9,12	980	29	63, 10	�������� ����, ����������� ����� ��, �� ����� ����� ��,��
						
2. ������ "�������"						
��������	��������� ��� �������					��������
	����	�����	������ ���������	����, ��	������� 1	
--������ ����� �� ������������	01.09.2018-31.09.2018	6,7,8,9,12	980	29	���	����������� ����� ��, �� ����� ����� ��,��
--������ ����� �� ������������	01.09.2018-31.09.2018	6,7,8,9,12	980	29	���	����������� ����� ��, �� ����� ����� ��,��

*/

BEGIN TRAN


DECLARE @BDate SMALLDATETIME = '20190301' --���� ������ ����� �����
DECLARE @EDate SMALLDATETIME = '20190331' --���� ����� ����� �����
DECLARE @Old_KursMC numeric(21,9) = 29.00 -- ������ ���� �������
DECLARE @New_KursMC numeric(21,9) = 28.00 -- ����� ���� �������
DECLARE @CurrID_GRN INT = 980 --��� ���������� ������

--��������
	
	SELECT KursMC,* From t_Rec d where DocDate Between @BDate and @EDate and d.KursMC!=@New_KursMC and d.OurID in (6,7,8,9,12) and d.CurrID = @CurrID_GRN
	SELECT KursMC,* FROM t_Epp d where DocDate Between @BDate and @EDate and d.KursMC!=@New_KursMC and d.OurID in (6,7,8,9,12) and d.CurrID = @CurrID_GRN
	SELECT KursMC,* FROM t_Ret d where DocDate Between @BDate and @EDate and d.KursMC!=@New_KursMC and d.OurID in (6,7,8,9,12) and d.CurrID = @CurrID_GRN
	SELECT KursMC,* FROM t_Inv d where DocDate Between @BDate and @EDate and d.KursMC!=@New_KursMC and d.OurID in (6,7,8,9,12) and d.CurrID = @CurrID_GRN
	SELECT KursMC,* FROM t_Exp d where DocDate Between @BDate and @EDate and d.KursMC!=@New_KursMC and d.OurID in (6,7,8,9,12) and d.CurrID = @CurrID_GRN
	SELECT KursMC,* FROM t_Epp d where DocDate Between @BDate and @EDate and d.KursMC!=@New_KursMC and d.OurID in (6,7,8,9,12) and d.CurrID = @CurrID_GRN
	SELECT KursMC,* FROM t_SRec d where DocDate Between @BDate and @EDate and d.KursMC!=@New_KursMC and d.OurID in (6,7,8,9,12) and d.CurrID = @CurrID_GRN
	SELECT KursMC,* FROM t_SExp d where DocDate Between @BDate and @EDate and d.KursMC!=@New_KursMC and d.OurID in (6,7,8,9,12) and d.CurrID = @CurrID_GRN
	SELECT KursMC,* FROM t_Exc d where DocDate Between @BDate and @EDate and d.KursMC!=@New_KursMC and d.OurID in (6,7,8,9,12) and d.CurrID = @CurrID_GRN
	SELECT KursMC,* FROM t_IORec d where DocDate Between @BDate and @EDate and d.KursMC!=@New_KursMC and d.OurID in (6,7,8,9,12) and d.CurrID = @CurrID_GRN
	SELECT KursMC,* FROM at_t_IORes d where DocDate Between @BDate and @EDate and d.KursMC!=@New_KursMC and d.OurID in (6,7,8,9,12) and d.CurrID = @CurrID_GRN
	SELECT KursMC,* FROM c_CompRec d where DocDate Between @BDate and @EDate and d.KursMC!=@New_KursMC and d.OurID in (6,7,8,9,12) and d.CurrID = @CurrID_GRN
	SELECT KursMC,* FROM c_CompExp d where DocDate Between @BDate and @EDate and d.KursMC!=@New_KursMC and d.OurID in (6,7,8,9,12) and d.CurrID = @CurrID_GRN

/*
*/
--������ ������	01.09.2018-31.09.2018	6,7,8,9,12	980	29	82, 87, 100, 2004	�������� ����, ��� ��������� ��� ��������� � ���������� �������� ���
--������ ������	01.09.2018-31.09.2018	6,7,8,9,12	980	29	42	�������� ���� � ���������� ��� ��������� � ��� ��������� ���
IF 1=0
BEGIN
--Rollback Tran
	--� ���������� �������� ���
	--��������� ���� ������� �� � ������������� �� � ��������
	Update p
	Set p.PriceMC_IN = p.PriceAC_In/c.KursMC, --���� ������� ��
 		p.CostMC = p.CostAC/c.KursMC -- ������������� �� 
	From t_Rec r 
	join t_recD rd on r.ChID = rd.Chid
	join t_Pinp p on rd.ProdID = p.ProdID and rd.PPID = p.PPID
	join r_Currs c on p.CurrID=c.CurrID
	where r.DocDate Between @BDate and @EDate  and r.KursMC=@Old_KursMC
		and c.CurrID=@CurrID_GRN and r.Ourid in (6,7,8,9,12) and r.CodeID1 in (82,87,100,2004)

	Select p.*
	From t_Rec r 
	join t_recD rd on r.ChID = rd.Chid
	join t_Pinp p on rd.ProdID = p.ProdID and rd.PPID = p.PPID
	join r_Currs c on p.CurrID=c.CurrID
	where r.DocDate Between @BDate and @EDate 
		and c.CurrID=@CurrID_GRN and r.Ourid in (6,7,8,9,12) and r.CodeID1 in (82,87,100,2004)
	Order By ProdID,PPID

	--�������� ����, ��� ��������� ��� ���������
	Update d
	set d.KursMC =@New_KursMC
	From t_Rec d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
		and d.OurID in (6,7,8,9,12) and d.CodeID1 in (82,87,100,2004)
		
	SELECT * From t_Rec d 
	where DocDate Between @BDate and @EDate 
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (82,87,100,2004)
	

--Rollback Tran
END




IF 1 = 1
BEGIN
--����������� ������	01.09.2018-31.09.2018	6,7,8,9,12	980	29	40, 41	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
--11021	t_Exc	����������� ������
--Rollback Tran
	SELECT KursMC,* FROM t_Exc d where DocDate Between @BDate and @EDate and d.KursMC!=@New_KursMC and d.OurID in (6,7,8,9,12) and d.CurrID = @CurrID_GRN
	ORDER BY ChID
		
	Update d
	set d.KursMC =@New_KursMC
	From t_Exc d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (40,41)
	
	SELECT * FROM t_Exc d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (40,41)
	ORDER BY ChID
	
	
--Rollback Tran
END


IF 1 = 1
BEGIN
--��������������	01.09.2018-31.09.2018	6,7,8,9,12	980	29	2004	�������� ���� � ���������� ��� ��������� � ��� ��������� ���
--11022	t_Ven	�������������� ������
--Rollback Tran

	--� ���������� ��� ���������
	Update ed
	Set PriceCC_nt = Round((PriceCC_nt/@Old_KursMC)*@New_KursMC,2), SumCC_nt=Round((SumCC_nt/@Old_KursMC)*@New_KursMC,2), Tax=Round((Tax/@Old_KursMC)*@New_KursMC,2), TaxSum=Round((TaxSum/@Old_KursMC)*@New_KursMC,2), PriceCC_wt=Round((PriceCC_wt/@Old_KursMC)*@New_KursMC,2), SumCC_wt=Round((SumCC_wt/@Old_KursMC)*@New_KursMC,2)
	From t_Ven d join t_VenD ed on d.ChiD=ed.ChID
	where d.DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)

	Update d
	set d.KursMC =@New_KursMC
	From t_Ven d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)
	
	SELECT * FROM t_Ven d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)
--Rollback Tran
END

IF 1 = 1
BEGIN
--�������	01.09.2018-31.09.2018	6,7,8,9,12	980	29	2004	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
--11003	t_Ret	������� ������ �� ����������
--Rollback Tran
	Update d
	set d.KursMC =@New_KursMC
	From t_Ret d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)
	
	SELECT * FROM t_Ret d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)
--Rollback Tran
END

IF 1 = 1
BEGIN
--������� ����������	01.09.2018-31.09.2018	6,7,8,9,12	980	29	82	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
--11011	t_CRet	������� ������ ����������
--Rollback Tran

SELECT KursMC,* From t_CRet d where DocDate Between @BDate and @EDate and d.KursMC!=@New_KursMC and d.OurID in (6,7,8,9,12) and d.CurrID = @CurrID_GRN

	Update d
	set d.KursMC =@New_KursMC
	From t_CRet d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (82)
	
	SELECT * FROM t_CRet d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (82)
--Rollback Tran

END

IF 1 = 1
BEGIN
--������� �� ����	01.09.2018-31.09.2018	6,7,8,9,12	980	29	63	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
--11004	t_CRRet	������� ������ �� ����
--Rollback Tran
	Update d
	set d.KursMC =@New_KursMC
	From t_CRRet d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63)

	SELECT * FROM t_CRRet d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63)
--Rollback Tran

END

IF 1 = 1
BEGIN
--��������� ���������	01.09.2018-31.09.2018	6,7,8,9,12	980	29	63	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
--11012	t_Inv	��������� ���������
--Rollback Tran
	Update d
	set d.KursMC =@New_KursMC
	From t_Inv d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63)
	
	SELECT * FROM t_Inv d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63)
--Rollback Tran

END

IF 1 = 1
BEGIN
--��������� ��������	01.09.2018-31.09.2018	6,7,8,9,12	980	29	2004, 2032, 2038	�������� ���� � ���������� ��� ��������� � ��� ��������� ���
--11015	t_Exp	��������� ��������
--Rollback Tran
	--� ���������� ��� ���������
	Update ed
	Set PriceCC_nt = Round((PriceCC_nt/@Old_KursMC)*@New_KursMC,2), SumCC_nt=Round((SumCC_nt/@Old_KursMC)*@New_KursMC,2), Tax=Round((Tax/@Old_KursMC)*@New_KursMC,2), TaxSum=Round((TaxSum/@Old_KursMC)*@New_KursMC,2), PriceCC_wt=Round((PriceCC_wt/@Old_KursMC)*@New_KursMC,2), SumCC_wt=Round((SumCC_wt/@Old_KursMC)*@New_KursMC,2)
	From t_Exp d join t_ExpD ed on d.ChiD=ed.ChID
	where d.DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004, 2032, 2038)
	
	--�������� ����
	Update d
	set d.KursMC =@New_KursMC
	From t_Exp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004,2032,2038)
	

	Select ed.*
    From t_Exp d join t_ExpD ed on d.ChiD=ed.ChID
	where d.DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004, 2032, 2038)
--Rollback Tran
END

IF 1 = 1
BEGIN
--������� ������ ����������	01.09.2018-31.09.2018	6,7,8,9,12	980	29	63	�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���
--11035	t_Sale	������� ������ ����������
--Rollback Tran
	--�������� ����
	Update d
	set d.KursMC =@New_KursMC
	From t_Sale d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63)
	
	SELECT * FROM t_Sale d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63)
--Rollback Tran
END

IF 1 = 1
BEGIN
--��������� �������� � ����� �������	01.09.2018-31.09.2018	6,7,8,9,12	980	29	100	�������� ���� � ���������� ��� ��������� � ��� ��������� ���
--11016	t_Epp	��������� �������� � ����� �������
--Rollback Tran
	--� ���������� ��� ���������
	Update ed
	Set PriceCC_nt = Round((PriceCC_nt/@Old_KursMC)*@New_KursMC,2), SumCC_nt=Round((SumCC_nt/@Old_KursMC)*@New_KursMC,2), Tax=Round((Tax/@Old_KursMC)*@New_KursMC,2), TaxSum=Round((TaxSum/@Old_KursMC)*@New_KursMC,2), PriceCC_wt=Round((PriceCC_wt/@Old_KursMC)*@New_KursMC,2), SumCC_wt=Round((SumCC_wt/@Old_KursMC)*@New_KursMC,2)
	From t_Epp d join t_EppD ed on d.ChiD=ed.ChID
	where d.DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100)
	
	--�������� ����
	Update d
	set d.KursMC =@New_KursMC
	From t_Epp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100)
	
	SELECT * FROM t_Epp d
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100)
--Rollback Tran
END

IF 1 = 1
BEGIN
--��������� �������� � ����� �������	01.09.2018-31.09.2018	6,7,8,9,12	980	29	2004	�������� ���� c ���������� ��� ��������� � ��� ��������� ���
--11016	t_Epp	��������� �������� � ����� �������
--Rollback Tran
	--� ���������� ��� ���������
	Update ed
	Set PriceCC_nt = Round((PriceCC_nt/@Old_KursMC)*@New_KursMC,2), SumCC_nt=Round((SumCC_nt/@Old_KursMC)*@New_KursMC,2), Tax=Round((Tax/@Old_KursMC)*@New_KursMC,2), TaxSum=Round((TaxSum/@Old_KursMC)*@New_KursMC,2), PriceCC_wt=Round((PriceCC_wt/@Old_KursMC)*@New_KursMC,2), SumCC_wt=Round((SumCC_wt/@Old_KursMC)*@New_KursMC,2)
	From t_Epp d join t_EppD ed on d.ChiD=ed.ChID
	where d.DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)
	
	--�������� ����
	Update d
	set d.KursMC =@New_KursMC
	From t_Epp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)
	
	
	SELECT * FROM t_Epp d
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)
--Rollback Tran
END

IF 1 = 1
BEGIN
--������������ ������	01.09.2018-31.09.2018	6,7,8,9,12	980	29	100	�������� ����, � ���������� ��� ��������� � ��� ��������� ���
--11321	t_SRec	������������ ������
--Rollback Tran
	--� ���������� ��� ���������
	Update ed
	Set SubPriceCC_nt = Round((SubPriceCC_nt/@Old_KursMC)*@New_KursMC,2), SubSumCC_nt=Round((SubSumCC_nt/@Old_KursMC)*@New_KursMC,2), SubTax=Round((SubTax/@Old_KursMC)*@New_KursMC,2), SubTaxSum=Round((SubTaxSum/@Old_KursMC)*@New_KursMC,2), SubPriceCC_wt=Round((SubPriceCC_wt/@Old_KursMC)*@New_KursMC,2), SubSumCC_wt=Round((SubSumCC_wt/@Old_KursMC)*@New_KursMC,2)
	From t_SRec d join t_SRecD ed on d.ChiD=ed.AChID
	where d.DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100)
	
	--�������� ����
	Update d
	set d.KursMC =@New_KursMC
	From t_SRec d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100)

	
	SELECT * FROM t_SRec d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100)
--Rollback Tran
END

IF 1 = 1
BEGIN
--���������������� ������	01.09.2018-31.09.2018	6,7,8,9,12	980	29	100	�������� ����, � ���������� ��� ��������� � ��� ��������� ���
--11322	t_SExp	���������������� ������
--Rollback Tran
	--� ���������� ��� ���������
	Update ed
	Set SubPriceCC_nt = Round((SubPriceCC_nt/@Old_KursMC)*@New_KursMC,2), SubSumCC_nt=Round((SubSumCC_nt/@Old_KursMC)*@New_KursMC,2), SubTax=Round((SubTax/@Old_KursMC)*@New_KursMC,2), SubTaxSum=Round((SubTaxSum/@Old_KursMC)*@New_KursMC,2), SubPriceCC_wt=Round((SubPriceCC_wt/@Old_KursMC)*@New_KursMC,2), SubSumCC_wt=Round((SubSumCC_wt/@Old_KursMC)*@New_KursMC,2)
	From t_SExp d join t_SExpD ed on d.ChiD=ed.AChID
	where d.DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100)

	--�������� ����
	Update d
	set d.KursMC =@New_KursMC
	From t_SExp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100)
	
	SELECT * FROM t_SExp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100)
--Rollback Tran
END

IF 1 = 1
BEGIN
--��������� �������� � ����� �������	01.09.2018-31.09.2018	6,7,8,9,12	980	29	42	�������� ���� � ���������� ��� ��������� � ��� ��������� ���
--11016	t_Epp	��������� �������� � ����� �������
--Rollback Tran
	--� ���������� ��� ���������
	Update ed
	Set PriceCC_nt = Round((PriceCC_nt/@Old_KursMC)*@New_KursMC,2), SumCC_nt=Round((SumCC_nt/@Old_KursMC)*@New_KursMC,2), Tax=Round((Tax/@Old_KursMC)*@New_KursMC,2), TaxSum=Round((TaxSum/@Old_KursMC)*@New_KursMC,2), PriceCC_wt=Round((PriceCC_wt/@Old_KursMC)*@New_KursMC,2), SumCC_wt=Round((SumCC_wt/@Old_KursMC)*@New_KursMC,2)
	From t_Epp d join t_EppD ed on d.ChiD=ed.ChID
	where d.DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (42)

	--�������� ����
	Update d
	set d.KursMC =@New_KursMC
	From t_Epp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (42)

	
	SELECT * FROM t_Epp d
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (42)
--Rollback Tran
END

IF 1 = 0
BEGIN
--������ ������	01.09.2018-31.09.2018	6,7,8,9,12	980	29	42	�������� ���� � ���������� ��� ��������� � ��� ��������� ���
--Rollback Tran

	
	--� ���������� ��� ���������
	Update ed
	Set PriceCC_nt = Round((PriceCC_nt/@Old_KursMC)*@New_KursMC,2), SumCC_nt=Round((SumCC_nt/@Old_KursMC)*@New_KursMC,2), Tax=Round((Tax/@Old_KursMC)*@New_KursMC,2), TaxSum=Round((TaxSum/@Old_KursMC)*@New_KursMC,2), PriceCC_wt=Round((PriceCC_wt/@Old_KursMC)*@New_KursMC,2), SumCC_wt=Round((SumCC_wt/@Old_KursMC)*@New_KursMC,2)
	From t_Rec d join t_RecD ed on d.ChiD=ed.ChID
	where d.DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (42)
	
	--�������� ����
	Update d
	set d.KursMC =@New_KursMC
	From t_Rec d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
		and d.OurID in (6,7,8,9,12) and d.CodeID1 in (42)
	
	
	SELECT * From t_Rec d 
	where DocDate Between @BDate and @EDate 
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (42)
--Rollback Tran
END

IF 1 = 1
BEGIN
--����� �������� ����� �� �����	01.09.2018-31.09.2018	6,7,8,9,12	980	29	63, 10	�������� ����, ����������� ����� ��, �� ����� ����� ��,��
--11018	t_MonRec	����� �������� ����� �� �����
--Rollback Tran
	--�������� ����
	Update d
	set d.KursMC =@New_KursMC
	From t_MonRec d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63,10)
	
	SELECT * FROM t_MonRec d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63,10)
--Rollback Tran
END

IF 1 = 1
BEGIN
--������ ����� �� ������������	01.09.2018-31.09.2018	6,7,8,9,12	980	29	���	����������� ����� ��, �� ����� ����� ��,��
--12001	c_CompRec	������ ����� �� ������������
--Rollback Tran
	Update d
	set d.KursMC =@New_KursMC
	From c_CompRec d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12)
	
	SELECT * FROM c_CompRec d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12)
--Rollback Tran
END

IF 1 = 1
BEGIN
--������ ����� �� ������������	01.09.2018-31.09.2018	6,7,8,9,12	980	29	���	����������� ����� ��, �� ����� ����� ��,��
--12002	c_CompExp	������ ����� �� ������������
--Rollback Tran
	Update d
	set d.KursMC =@New_KursMC
	From c_CompExp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12)

	SELECT * FROM c_CompExp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12)
--Rollback Tran
END
/*

--2|��������� �������� � ����� �������|01.01.2018-31.01.2018|6,7,8,9,12|980|28|42|�������� ����, ��� ��������� ��� ��������� � ���������� �������� ���|11016|t_Epp|��������� �������� � ����� �������
--11016	t_Epp	��������� �������� � ����� �������
--Begin Tran
	--�������� ����, ��� ��������� ��� ���������
	Update d
	set d.KursMC =@New_KursMC
	From t_Epp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (42)
	
	SELECT * FROM t_Epp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (42) 
	
	--� ���������� �������� ���
	--��������� ���� ������� �� � ������������� �� � ��������
	Update p
	Set p.PriceMC_IN = p.PriceAC_In/c.KursMC, --���� ������� ��
 		p.CostMC = p.CostAC/c.KursMC -- ������������� �� 
	From t_Epp r 
	join t_EppD rd on r.ChID = rd.Chid
	join t_Pinp p on rd.ProdID = p.ProdID and rd.PPID = p.PPID
	join r_Currs c on p.CurrID=c.CurrID
	where r.DocDate Between @BDate and @EDate 
		and c.CurrID=@CurrID_GRN and r.Ourid in (6,7,8,9,12) and r.CodeID1 in (42)

	Select p.*
	From t_Epp r 
	join t_EppD rd on r.ChID = rd.Chid
	join t_Pinp p on rd.ProdID = p.ProdID and rd.PPID = p.PPID
	join r_Currs c on p.CurrID=c.CurrID
	where r.DocDate Between @BDate and @EDate 
		and c.CurrID=@CurrID_GRN and r.Ourid in (6,7,8,9,12) and r.CodeID1 in (42)
	Order By ProdID,PPID

--Rollback



--4|��������������|01.01.2018-31.01.2018|6,7,8,9,12|980|28|2004|�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���|11022|t_Ven|�������������� ������
--11022	t_Ven	�������������� ������
--Begin Tran
	Update d
	set d.KursMC =@New_KursMC
	From t_Ven d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)
	
	SELECT * FROM t_Ven d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)
--Rollback

--5|�������|01.01.2018-31.01.2018|6,7,8,9,12|980|28|2004|�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���|11003|t_Ret|������� ������ �� ����������
--11003	t_Ret	������� ������ �� ����������
--Begin Tran
	Update d
	set d.KursMC =@New_KursMC
	From t_Ret d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)
	
	SELECT * FROM t_Ret d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)
--Rollback

--6|������� ����������|01.01.2018-31.01.2018|6,7,8,9,12|980|28|82|�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���|11011|t_CRet|������� ������ ����������
--11011	t_CRet	������� ������ ����������
--Begin Tran
	Update d
	set d.KursMC =@New_KursMC
	From t_CRet d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (82)
	
	SELECT * FROM t_CRet d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (82)
--Rollback

--7|������� �� ����|01.01.2018-31.01.2018|6,7,8,9,12|980|28|63|�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���|11004|t_CRRet|������� ������ �� ����
--11004	t_CRRet	������� ������ �� ����
--Begin Tran
	Update d
	set d.KursMC =@New_KursMC
	From t_CRRet d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63)

	SELECT * FROM t_CRRet d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63)
--Rollback

--8|��������� ���������|01.01.2018-31.01.2018|6,7,8,9,12|980|28|63|�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���|11012|t_Inv|��������� ���������
--11012	t_Inv	��������� ���������
--Begin Tran
	Update d
	set d.KursMC =@New_KursMC
	From t_Inv d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63)
	
	SELECT * FROM t_Inv d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63)
--Rollback

--9|��������� ��������|01.01.2018-31.01.2018|6,7,8,9,12|980|28|2004, 2032, 2038|�������� ���� � ���������� ��� ��������� � ��� ��������� ���|11015|t_Exp|��������� ��������
--11015	t_Exp	��������� ��������
--Begin Tran
	--�������� ����
	Update d
	set d.KursMC =@New_KursMC
	From t_Exp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004,2032,2038)
	
	--� ���������� ��� ���������
	Update ed
	Set PriceCC_nt = Round((PriceCC_nt/@Old_KursMC)*@New_KursMC,2), SumCC_nt=Round((SumCC_nt/@Old_KursMC)*@New_KursMC,2), Tax=Round((Tax/@Old_KursMC)*@New_KursMC,2), TaxSum=Round((TaxSum/@Old_KursMC)*@New_KursMC,2), PriceCC_wt=Round((PriceCC_wt/@Old_KursMC)*@New_KursMC,2), SumCC_wt=Round((SumCC_wt/@Old_KursMC)*@New_KursMC,2)
	From t_Exp d join t_ExpD ed on d.ChiD=ed.ChID
	where d.DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004, 2032, 2038)

	Select ed.*
	From t_Exp d join t_ExpD ed on d.ChiD=ed.ChID
	where d.DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004, 2032, 2038)
--Rollback

--10|������� ������ ����������|01.01.2018-31.01.2018|6,7,8,9,12|980|28|63|�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���|11035|t_Sale|������� ������ ����������
--11035	t_Sale	������� ������ ����������
--Begin Tran
	Update d
	set d.KursMC =@New_KursMC
	From t_Sale d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63)
	
	SELECT * FROM t_Sale d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63)
--Rollback

--11|��������� �������� � ����� �������|01.01.2018-31.01.2018|6,7,8,9,12|980|28|100|�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���|11016|t_Epp|��������� �������� � ����� �������
	--�������� ����, ��� ��������� ��� ���������
--Begin Tran
	Update d
	set d.KursMC =@New_KursMC
	From t_Epp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100)
	
	SELECT * FROM t_Epp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100) 
--Rollback

--12|��������� �������� � ����� �������|01.01.2018-31.01.2018|6,7,8,9,12|980|28|2004|�������� ���� c ���������� ��� ��������� � ��� ��������� ���|11016|t_Epp|��������� �������� � ����� �������
--Begin Tran
	Update d
	set d.KursMC =@New_KursMC
	From t_Epp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)
	
	SELECT * FROM t_Epp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004) 
	
	Select ed.*
	From t_Epp d join t_EppD ed on d.ChiD=ed.ChID
	where d.DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)
	
	--� ���������� ��� ���������
	Update ed
	Set PriceCC_nt = Round((PriceCC_nt/@Old_KursMC)*@New_KursMC,2), SumCC_nt=Round((SumCC_nt/@Old_KursMC)*@New_KursMC,2), Tax=Round((Tax/@Old_KursMC)*@New_KursMC,2), TaxSum=Round((TaxSum/@Old_KursMC)*@New_KursMC,2), PriceCC_wt=Round((PriceCC_wt/@Old_KursMC)*@New_KursMC,2), SumCC_wt=Round((SumCC_wt/@Old_KursMC)*@New_KursMC,2)
	From t_Epp d join t_EppD ed on d.ChiD=ed.ChID
	where d.DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)

	Select ed.*
	From t_Epp d join t_EppD ed on d.ChiD=ed.ChID
	where d.DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)
	
	SELECT * FROM t_Epp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004) 
--Rollback

--13|������������ ������|01.01.2018-31.01.2018|6,7,8,9,12|980|28|100|�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���|11321|t_SRec|������������ ������
--11321	t_SRec	������������ ������
--Begin Tran
	Update d
	set d.KursMC =@New_KursMC
	From t_SRec d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100)
	
	SELECT * FROM t_SRec d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100)
--Rollback

--14|���������������� ������|01.01.2018-31.01.2018|6,7,8,9,12|980|28|100|�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���|11322|t_SExp|���������������� ������
--11322	t_SExp	���������������� ������
--Begin Tran
	Update d
	set d.KursMC =@New_KursMC
	From t_SExp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100)
	
	SELECT * FROM t_SExp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100)
--Rollback

--15|����� �������� ����� �� �����|01.01.2018-31.01.2018|6,7,8,9,12|980|28|63, 10|����������� ����� ��, �� ����� ����� ��,��|11018|t_MonRec|����� �������� ����� �� �����
--11018	t_MonRec	����� �������� ����� �� �����
--Begin Tran
	Update d
	set d.KursMC =@New_KursMC
	From t_MonRec d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63,10)
	
	SELECT * FROM t_MonRec d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63,10)
--Rollback

--16|������ ����� �� ������������|01.01.2018-31.01.2018|6,7,8,9,12|980|28|���|����������� ����� ��, �� ����� ����� ��,��|12001|c_CompRec|������ ����� �� ������������
--12001	c_CompRec	������ ����� �� ������������
--Begin Tran
	Update d
	set d.KursMC =@New_KursMC
	From c_CompRec d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12)
	
	SELECT * FROM c_CompRec d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12)
--Rollback


--17|������ ����� �� ������������|01.01.2018-31.01.2018|6,7,8,9,12|980|28|���|����������� ����� ��, �� ����� ����� ��,��|12002|c_CompExp|������ ����� �� ������������
--12002	c_CompExp	������ ����� �� ������������
--Begin Tran
	Update d
	set d.KursMC =@New_KursMC
	From c_CompExp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@Old_KursMC
	and d.OurID in (6,7,8,9,12)

	SELECT * FROM c_CompExp d 
	where DocDate Between @BDate and @EDate and d.KursMC=@New_KursMC
	and d.OurID in (6,7,8,9,12)
--Rollback
*/
ROLLBACK TRAN