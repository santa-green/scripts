--�������� ����� ����� ������� � ������ ElitR 

--1.��������� �� (���� VC_Sync)17.01.2018 12:30

--2 ����� ElitR 17.01.2018 12:36

--3. ��������� ������������� �� ��� ��������� �������

--4. ������ ���� ������� � ������ � ����������� ����� 17.01.2018 12:38
/*
USE ElitR

	--������ ���� �������
	UPDATE r_Currs SET KursCC = 28 WHERE  CurrID = 840
	INSERT INTO r_CurrH (CurrID, DocDate, KursMC, KursCC) VALUES (840, '20180101', 1.00, 28.00)
	--������ ���� ������
	UPDATE r_Currs SET KursMC = 28 WHERE  CurrID = 980
	INSERT INTO r_CurrH (CurrID, DocDate, KursMC, KursCC) VALUES (980, '20180101', 28.00, 1.00)
	
	SELECT * FROM r_Currs WHERE  CurrID = 980
	SELECT * FROM r_CurrH WHERE  CurrID = 980
	SELECT * FROM r_Currs WHERE  CurrID = 840
	SELECT * FROM r_CurrH WHERE  CurrID = 840

*/
/* �������� ������ ���� � ���������� [CP1_DP].ElitCP1.dbo

	--������ ���� �������
	UPDATE [CP1_DP].ElitCP1.dbo.r_Currs SET KursCC = 28 WHERE  CurrID = 840
	INSERT INTO [CP1_DP].ElitCP1.dbo.r_CurrH (CurrID, DocDate, KursMC, KursCC) VALUES (840, '20180101', 1.00, 28.00)
	--������ ���� ������
	UPDATE [CP1_DP].ElitCP1.dbo.r_Currs SET KursMC = 28 WHERE  CurrID = 980
	INSERT INTO [CP1_DP].ElitCP1.dbo.r_CurrH (CurrID, DocDate, KursMC, KursCC) VALUES (980, '20180101', 28.00, 1.00)

	SELECT * FROM [CP1_DP].ElitCP1.dbo.r_Currs WHERE  CurrID = 980
	SELECT * FROM [CP1_DP].ElitCP1.dbo.r_CurrH WHERE  CurrID = 980

	SELECT * FROM [CP1_DP].ElitCP1.dbo.r_Currs WHERE  CurrID = 840
	SELECT * FROM [CP1_DP].ElitCP1.dbo.r_CurrH WHERE  CurrID = 840

*/

--5. ��������� �������������, ��� �� ������� ����������

--6. ���� ��� ������� ���������� � ������� ���� �� ���� ���� ������ ������������ ���� 
--	� �������� �� (���� VC_Sync) 17.01.2018 

--7. ��������� 
--|������ �� ��������� �����|||||||||

--|1. ������ "������"|||||||||
--|��������|��������� ��� �������|||||��������|||
--�����||����|�����|������ ���������|����, ��|������� 1||||
--1|������ ������|01.01.2018-31.01.2018|6,7,8,9,12|980|28|82, 87, 100, 2004,42|�������� ����, ��� ��������� ��� ��������� � ���������� �������� ���|11002|t_Rec|������ ������
--2|��������� �������� � ����� �������|01.01.2018-31.01.2018|6,7,8,9,12|980|28|42|�������� ����, ��� ��������� ��� ��������� � ���������� �������� ���|||
--3|����������� ������|01.01.2018-31.01.2018|6,7,8,9,12|980|28|40, 41,42|�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���|11021|t_Exc|����������� ������
--4|��������������|01.01.2018-31.01.2018|6,7,8,9,12|980|28|2004|�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���|11022|t_Ven|�������������� ������
--5|�������|01.01.2018-31.01.2018|6,7,8,9,12|980|28|2004|�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���|11003|t_Ret|������� ������ �� ����������
--6|������� ����������|01.01.2018-31.01.2018|6,7,8,9,12|980|28|82|�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���|11011|t_CRet|������� ������ ����������
--7|������� �� ����|01.01.2018-31.01.2018|6,7,8,9,12|980|28|63|�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���|11004|t_CRRet|������� ������ �� ����
--8|��������� ���������|01.01.2018-31.01.2018|6,7,8,9,12|980|28|63|�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���|11012|t_Inv|��������� ���������
--9|��������� ��������|01.01.2018-31.01.2018|6,7,8,9,12|980|28|2004, 2032, 2038|�������� ���� � ���������� ��� ��������� � ��� ��������� ���|11015|t_Exp|��������� ��������
--10|������� ������ ����������|01.01.2018-31.01.2018|6,7,8,9,12|980|28|63|�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���|11035|t_Sale|������� ������ ����������
--11|��������� �������� � ����� �������|01.01.2018-31.01.2018|6,7,8,9,12|980|28|100|�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���|11016|t_Epp|��������� �������� � ����� �������
--12|��������� �������� � ����� �������|01.01.2018-31.01.2018|6,7,8,9,12|980|28|2004|�������� ���� c ���������� ��� ��������� � ��� ��������� ���|||
--13|������������ ������|01.01.2018-31.01.2018|6,7,8,9,12|980|28|100|�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���|11321|t_SRec|������������ ������
--14|���������������� ������|01.01.2018-31.01.2018|6,7,8,9,12|980|28|100|�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���|11322|t_SExp|���������������� ������
--15|����� �������� ����� �� �����|01.01.2018-31.01.2018|6,7,8,9,12|980|28|63, 10|����������� ����� ��, �� ����� ����� ��,��|11018|t_MonRec|����� �������� ����� �� �����

--|2. ������ "�������"|||||||||
--|��������|��������� ��� �������|||||��������|||
--||����|�����|������ ���������|����, ��|������� 1||||
--16|������ ����� �� ������������|01.01.2018-31.01.2018|6,7,8,9,12|980|28|���|����������� ����� ��, �� ����� ����� ��,��|12001|c_CompRec|������ ����� �� ������������
--17|������ ����� �� ������������|01.01.2018-31.01.2018|6,7,8,9,12|980|28|���|����������� ����� ��, �� ����� ����� ��,��|12002|c_CompExp|������ ����� �� ������������

BEGIN TRAN


DECLARE @NewKursMC numeric(21,9) = 28.00 -- ����� ����
DECLARE @OldKursMC numeric(21,9) = 27.00 -- ������ ����
DECLARE @BDate SMALLDATETIME = '20180101'
DECLARE @EDate SMALLDATETIME = '20180131'

SELECT @BDate,@EDate

--1|������ ������|01.01.2018-31.01.2018|6,7,8,9,12|980|28|82, 87, 100, 2004,42|�������� ����, ��� ��������� ��� ��������� � ���������� �������� ���|11002|t_Rec|������ ������
--11002|t_Rec|������ ������
	--�������� ����, ��� ��������� ��� ���������
	Update d
	set d.KursMC =@NewKursMC
	From t_Rec d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@OldKursMC
		and d.OurID in (6,7,8,9,12) and d.CodeID1 in (82,87,100,2004,42)
		
	SELECT * From t_Rec d 
	where DocDate Between @BDate AND @EDate 
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (82,87,100,2004,42)
	
	--� ���������� �������� ���
	--��������� ���� ������� �� � ������������� �� � ��������
	Update p
	Set p.PriceMC_IN = p.PriceAC_In/c.KursMC, --���� ������� ��
 		p.CostMC = p.CostAC/c.KursMC -- ������������� �� 
	From t_Rec r 
	join t_recD rd on r.ChID = rd.Chid
	join t_Pinp p on rd.ProdID = p.ProdID and rd.PPID = p.PPID
	join r_Currs c on p.CurrID=c.CurrID
	where r.DocDate Between @BDate AND @EDate 
		and c.CurrID=980 and r.Ourid in (6,7,8,9,12) and r.CodeID1 in (82,87,100,2004,42)

	Select p.*
	From t_Rec r 
	join t_recD rd on r.ChID = rd.Chid
	join t_Pinp p on rd.ProdID = p.ProdID and rd.PPID = p.PPID
	join r_Currs c on p.CurrID=c.CurrID
	where r.DocDate Between @BDate AND @EDate 
		and c.CurrID=980 and r.Ourid in (6,7,8,9,12) and r.CodeID1 in (82,87,100,2004,42)
	Order By ProdID,PPID

--2|��������� �������� � ����� �������|01.01.2018-31.01.2018|6,7,8,9,12|980|28|42|�������� ����, ��� ��������� ��� ��������� � ���������� �������� ���|11016|t_Epp|��������� �������� � ����� �������
--11016	t_Epp	��������� �������� � ����� �������
	--�������� ����, ��� ��������� ��� ���������
	Update d
	set d.KursMC =@NewKursMC
	From t_Epp d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@OldKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (42)
	
	SELECT * FROM t_Epp d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@NewKursMC
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
	where r.DocDate Between @BDate AND @EDate 
		and c.CurrID=980 and r.Ourid in (6,7,8,9,12) and r.CodeID1 in (42)

	Select p.*
	From t_Epp r 
	join t_EppD rd on r.ChID = rd.Chid
	join t_Pinp p on rd.ProdID = p.ProdID and rd.PPID = p.PPID
	join r_Currs c on p.CurrID=c.CurrID
	where r.DocDate Between @BDate AND @EDate 
		and c.CurrID=980 and r.Ourid in (6,7,8,9,12) and r.CodeID1 in (42)
	Order By ProdID,PPID

--3|����������� ������|01.01.2018-31.01.2018|6,7,8,9,12|980|28|40, 41,42|�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���|11021|t_Exc|����������� ������
--11021	t_Exc	����������� ������
	Update d
	set d.KursMC =@NewKursMC
	From t_Exc d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@OldKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (40,41,42)
	
	SELECT * FROM t_Exc d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@NewKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (40,41,42)

--4|��������������|01.01.2018-31.01.2018|6,7,8,9,12|980|28|2004|�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���|11022|t_Ven|�������������� ������
--11022	t_Ven	�������������� ������
	Update d
	set d.KursMC =@NewKursMC
	From t_Ven d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@OldKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)
	
	SELECT * FROM t_Ven d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@NewKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)

--5|�������|01.01.2018-31.01.2018|6,7,8,9,12|980|28|2004|�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���|11003|t_Ret|������� ������ �� ����������
--11003	t_Ret	������� ������ �� ����������
	Update d
	set d.KursMC =@NewKursMC
	From t_Ret d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@OldKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)
	
	SELECT * FROM t_Ret d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@NewKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)

--6|������� ����������|01.01.2018-31.01.2018|6,7,8,9,12|980|28|82|�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���|11011|t_CRet|������� ������ ����������
--11011	t_CRet	������� ������ ����������
	Update d
	set d.KursMC =@NewKursMC
	From t_CRet d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@OldKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (82)
	
	SELECT * FROM t_CRet d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@NewKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (82)

--7|������� �� ����|01.01.2018-31.01.2018|6,7,8,9,12|980|28|63|�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���|11004|t_CRRet|������� ������ �� ����
--11004	t_CRRet	������� ������ �� ����
	Update d
	set d.KursMC =@NewKursMC
	From t_CRRet d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@OldKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63)

	SELECT * FROM t_CRRet d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@NewKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63)

--8|��������� ���������|01.01.2018-31.01.2018|6,7,8,9,12|980|28|63|�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���|11012|t_Inv|��������� ���������
--11012	t_Inv	��������� ���������
	Update d
	set d.KursMC =@NewKursMC
	From t_Inv d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@OldKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63)
	
	SELECT * FROM t_Inv d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@NewKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63)

--9|��������� ��������|01.01.2018-31.01.2018|6,7,8,9,12|980|28|2004, 2032, 2038|�������� ���� � ���������� ��� ��������� � ��� ��������� ���|11015|t_Exp|��������� ��������
--11015	t_Exp	��������� ��������
	--�������� ����
	Update d
	set d.KursMC =@NewKursMC
	From t_Exp d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@OldKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004,2032,2038)
	
	--� ���������� ��� ���������
	Update ed
	Set PriceCC_nt = Round((PriceCC_nt/@OldKursMC)*@NewKursMC,2), SumCC_nt=Round((SumCC_nt/@OldKursMC)*@NewKursMC,2), Tax=Round((Tax/@OldKursMC)*@NewKursMC,2), TaxSum=Round((TaxSum/@OldKursMC)*@NewKursMC,2), PriceCC_wt=Round((PriceCC_wt/@OldKursMC)*@NewKursMC,2), SumCC_wt=Round((SumCC_wt/@OldKursMC)*@NewKursMC,2)
	From t_Exp d join t_ExpD ed on d.ChiD=ed.ChID
	where d.DocDate Between @BDate AND @EDate and d.KursMC=@NewKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004, 2032, 2038)

	Select ed.*
	From t_Exp d join t_ExpD ed on d.ChiD=ed.ChID
	where d.DocDate Between @BDate AND @EDate and d.KursMC=@NewKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004, 2032, 2038)

--10|������� ������ ����������|01.01.2018-31.01.2018|6,7,8,9,12|980|28|63|�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���|11035|t_Sale|������� ������ ����������
--11035	t_Sale	������� ������ ����������
	Update d
	set d.KursMC =@NewKursMC
	From t_Sale d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@OldKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63)
	
	SELECT * FROM t_Sale d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@NewKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63)

--11|��������� �������� � ����� �������|01.01.2018-31.01.2018|6,7,8,9,12|980|28|100|�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���|11016|t_Epp|��������� �������� � ����� �������
	--�������� ����, ��� ��������� ��� ���������
	Update d
	set d.KursMC =@NewKursMC
	From t_Epp d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@OldKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100)
	
	SELECT * FROM t_Epp d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@NewKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100) 

--12|��������� �������� � ����� �������|01.01.2018-31.01.2018|6,7,8,9,12|980|28|2004|�������� ���� c ���������� ��� ��������� � ��� ��������� ���|11016|t_Epp|��������� �������� � ����� �������
	Update d
	set d.KursMC =@NewKursMC
	From t_Epp d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@OldKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)
	
	SELECT * FROM t_Epp d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@NewKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004) 
	
	Select ed.*
	From t_Epp d join t_EppD ed on d.ChiD=ed.ChID
	where d.DocDate Between @BDate AND @EDate and d.KursMC=@NewKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)
	
	--� ���������� ��� ���������
	Update ed
	Set PriceCC_nt = Round((PriceCC_nt/@OldKursMC)*@NewKursMC,2), SumCC_nt=Round((SumCC_nt/@OldKursMC)*@NewKursMC,2), Tax=Round((Tax/@OldKursMC)*@NewKursMC,2), TaxSum=Round((TaxSum/@OldKursMC)*@NewKursMC,2), PriceCC_wt=Round((PriceCC_wt/@OldKursMC)*@NewKursMC,2), SumCC_wt=Round((SumCC_wt/@OldKursMC)*@NewKursMC,2)
	From t_Epp d join t_EppD ed on d.ChiD=ed.ChID
	where d.DocDate Between @BDate AND @EDate and d.KursMC=@NewKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)

	Select ed.*
	From t_Epp d join t_EppD ed on d.ChiD=ed.ChID
	where d.DocDate Between @BDate AND @EDate and d.KursMC=@NewKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004)
	
	SELECT * FROM t_Epp d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@NewKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (2004) 

--13|������������ ������|01.01.2018-31.01.2018|6,7,8,9,12|980|28|100|�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���|11321|t_SRec|������������ ������
--11321	t_SRec	������������ ������
	Update d
	set d.KursMC =@NewKursMC
	From t_SRec d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@OldKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100)
	
	SELECT * FROM t_SRec d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@NewKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100)

--14|���������������� ������|01.01.2018-31.01.2018|6,7,8,9,12|980|28|100|�������� ����, ��� ��������� ��� ��������� � ��� ��������� ���|11322|t_SExp|���������������� ������
--11322	t_SExp	���������������� ������
	Update d
	set d.KursMC =@NewKursMC
	From t_SExp d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@OldKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100)
	
	SELECT * FROM t_SExp d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@NewKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (100)

--15|����� �������� ����� �� �����|01.01.2018-31.01.2018|6,7,8,9,12|980|28|63, 10|����������� ����� ��, �� ����� ����� ��,��|11018|t_MonRec|����� �������� ����� �� �����
--11018	t_MonRec	����� �������� ����� �� �����
	Update d
	set d.KursMC =@NewKursMC
	From t_MonRec d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@OldKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63,10)
	
	SELECT * FROM t_MonRec d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@NewKursMC
	and d.OurID in (6,7,8,9,12) and d.CodeID1 in (63,10)

--16|������ ����� �� ������������|01.01.2018-31.01.2018|6,7,8,9,12|980|28|���|����������� ����� ��, �� ����� ����� ��,��|12001|c_CompRec|������ ����� �� ������������
--12001	c_CompRec	������ ����� �� ������������
	Update d
	set d.KursMC =@NewKursMC
	From c_CompRec d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@OldKursMC
	and d.OurID in (6,7,8,9,12)
	
	SELECT * FROM c_CompRec d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@NewKursMC
	and d.OurID in (6,7,8,9,12)

--17|������ ����� �� ������������|01.01.2018-31.01.2018|6,7,8,9,12|980|28|���|����������� ����� ��, �� ����� ����� ��,��|12002|c_CompExp|������ ����� �� ������������
--12002	c_CompExp	������ ����� �� ������������
	Update d
	set d.KursMC =@NewKursMC
	From c_CompExp d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@OldKursMC
	and d.OurID in (6,7,8,9,12)

	SELECT * FROM c_CompExp d 
	where DocDate Between @BDate AND @EDate and d.KursMC=@NewKursMC
	and d.OurID in (6,7,8,9,12)


ROLLBACK TRAN